Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D4831696D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhBJOwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBJOwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:52:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E4DC061574;
        Wed, 10 Feb 2021 06:51:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id i8so4705610ejc.7;
        Wed, 10 Feb 2021 06:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvXV28pKYZQ6XN2BS9VfvmXTJ0BIn3jo9mdDyBLMsno=;
        b=JHd97QPXdtdgWBVVFWf5uycI5zboNkqBWl6I7CyXj/rrhhwshsHn7XHwI1B+/vAXjW
         dnbNILCCJfBL8l7EdB9hJ+rI3wA2aMa4JMYVxGnPVai/J0qsx2YWGh/lQDffC45qYCbd
         CwNNnJKq0v1EYmIzcBpFOhuMcFCDZZas90G3OLMVxatwtofUqmnxL63wpAY3tRP+Fgks
         Ch5dN3ZinRZ8Pv+uWje0NfpxbSPlwKOoWh0KRmaUkHBfjLXPSJeAwj+c3butvbzOZUWK
         0rCryg0nj4BnJXC9n/6xMRk+vn8qV54JeKErlcyPWzDT7GrcJqg8osSpMoYvO/6Gt2sS
         Y9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvXV28pKYZQ6XN2BS9VfvmXTJ0BIn3jo9mdDyBLMsno=;
        b=dJCQffqWhSsx4anmgjnqVuWdadP8CykJ3D3H5tGgkS5aD8ztpdStmdBK4syuxjUSnu
         +zvxq9R0T6txZtihr/3iBZ5encGzoMh63TxKXwp/GNj9RODjm7Gzu3BfNVgGfhhGQATd
         FLrwlNg/LG1GI1j1xQF2TO/pVMlyskr7sRTw3NykzCTYmvNHkiWlpjA4QmVhY3aH8mEE
         VIbw3kMkgWQJh6oXXpxhJLSrCrcNJLSvTNXNm9sp4fODTQpMamEVWORBsjYD8R8UHk3i
         s8kL11fhIAYWNe3cTpRnfw+tRZ0vS0SZP6POQWzXTv2e8PdI02NNqCaePHAsDAF9zRlt
         +haQ==
X-Gm-Message-State: AOAM530vRcYALnymEMa5seIZcWt124zz6nv99gtMccITYiRsLxR5B6kG
        /JiiIRsjeGxEUDVUe0wsSAm+Kc7WNVBwAnOXAfo=
X-Google-Smtp-Source: ABdhPJzPlyWmeSdVzKHbGdY+4dp+tW+DNd3dY0E3hgFCW24SyIEA3c5b9IvR4dNAHTpoXcfb6xSIpDfL+yN3eh9pTqY=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr3182527ejk.538.1612968678886;
 Wed, 10 Feb 2021 06:51:18 -0800 (PST)
MIME-Version: 1.0
References: <20210210065925.22614-1-hxseverything@gmail.com>
In-Reply-To: <20210210065925.22614-1-hxseverything@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 10 Feb 2021 09:50:43 -0500
Message-ID: <CAF=yD-LLzAheej1upLdBOeJc9d0RUXMrL9f9+QVC-4thj1EG5Q@mail.gmail.com>
Subject: Re: [PATCH/v2] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
To:     huangxuesen <hxseverything@gmail.com>
Cc:     David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        huangxuesen <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 1:59 AM huangxuesen <hxseverything@gmail.com> wrote:
>
> From: huangxuesen <huangxuesen@kuaishou.com>
>
> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
> encapsulation. But that is not appropriate when pushing Ethernet header.
>
> Add an option to further specify encap L2 type and set the inner_protocol
> as ETH_P_TEB.
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
> Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
> Signed-off-by: wangli <wangli09@kuaishou.com>

Thanks, this is exactly what I meant.

Acked-by: Willem de Bruijn <willemb@google.com>

One small point regarding Signed-off-by: It is customary to capitalize
family and given names.
