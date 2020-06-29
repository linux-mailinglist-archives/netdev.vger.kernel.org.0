Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521D120DFE3
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgF2Ukk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731697AbgF2TOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C475C008602
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 03:14:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so16008007ejb.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 03:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rBLLrnf5msSWldk/b9lKXdnjWlfnslhZkR3ph4+G37c=;
        b=Yhfu/lQGE+ZHGF8Z/+StZlzzyxAua0lxbuBTS9KoiTdOaDZsUPxRqF6kYsvYZd+2+Q
         9zAUErqzDAfVi8ISMnV5CtOa63u0JH1TSl0hrKjYvcamuUt4EnVt2mWt3urPTNz4PZAu
         75YZwrn3xCZ296LbUjpKfqh037I6zvoPnHbLAXw577/+qXlZ4qC9mzleQw+2JJo+6PrL
         oEmDi5waRBRYgbWRnLEEKTkLNffrfzok6ZRNrgdl2bhc6W6DQNKuVMuJauX1wqXMyMGL
         YDvBhLjiPOUteQ7ZcaNIIVGz22kdUA9uMgTKCa77fFLd6EqdczAwgQLAoAJs9EjW3mWB
         DFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=rBLLrnf5msSWldk/b9lKXdnjWlfnslhZkR3ph4+G37c=;
        b=rF85h5BhXYv0HMsVcw3N/jAfQ3OmDuQJMwJeSu+7rpSPwKxHvjWJ1YzPTfEW5u52Hf
         44HHm5C4kGuQuntmnZx/mOvVG/MW/3CuC07qJt673Fe4/t4ab5nqeCXbTlPaaL7mYW3T
         4prfOv2JUHuhv9p/7NOg+tZLGnr8oIb3U/Y5MS9p2cP9OJZktAGRWWxcrQxHoj79ljJU
         e9YzRmfTqJRQubi8znln+7yaPzLgPb8BhNVCCBc+zQGbnsQW/M+qlluLWp6Y3mzPYhgJ
         wXTJPCrxmvzW+xjccBnJgxQkE49xG+45jfHC36HyFUwtdzlPFyNKQMIoAioPux0TUOa3
         X2Ag==
X-Gm-Message-State: AOAM530Ke+ozvwJY+xawcAoQaZMvCsL2t/3pAN+qVuXkHtD/WiaEdfaC
        XH24G1insn88Ex1cryse8DcCCwoYgUSnHO5AivtQwg==
X-Google-Smtp-Source: ABdhPJwW2DNml27tKusy65ml6m+5kJ8hXABy0Zt7Q+wJ+tv5k5+b/0XYtXu1L0pwYrUTiyvBcGgot+M804Rgvqs3DTE=
X-Received: by 2002:a17:906:5f98:: with SMTP id a24mr12818959eju.241.1593425697892;
 Mon, 29 Jun 2020 03:14:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Mon, 29 Jun 2020 03:14:57
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <20200626090519.7efbd06f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
 <1593171639-8136-3-git-send-email-kda@linux-powerpc.org> <20200626090519.7efbd06f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 29 Jun 2020 13:14:57 +0300
Message-ID: <CAOJe8K35osOCKOhrLCKGKns7Hu0M+EAP6TUvwbpsgS_B7Vi2jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v13 2/3] xen networking: add basic XDP support
 for xen-netfront
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 26 Jun 2020 14:40:38 +0300 Denis Kirjanov wrote:
>> The patch adds a basic XDP processing to xen-netfront driver.
>>
>> We ran an XDP program for an RX response received from netback
>> driver. Also we request xen-netback to adjust data offset for
>> bpf_xdp_adjust_head() header space for custom headers.
>>
>> synchronization between frontend and backend parts is done
>> by using xenbus state switching:
>> Reconfiguring -> Reconfigured- > Connected
>>
>> UDP packets drop rate using xdp program is around 310 kpps
>> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>
> Still here:
>
> drivers/net/xen-netfront.c: In function xennet_xdp_xmit_one:
> drivers/net/xen-netfront.c:581:31: warning: variable tx set but not used
> [-Wunused-but-set-variable]
>   581 |  struct xen_netif_tx_request *tx;
>       |                               ^~
Hi Jakub,

Ohh... going to send a fixed version.

Thanks.
