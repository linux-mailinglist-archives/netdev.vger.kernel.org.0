Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68183FDEAC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbhIAPat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244284AbhIAPas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:30:48 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A51C061760
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 08:29:51 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id e131so5862957ybb.7
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEydQnCiiB9iy6pnOk/cAGg/1/rtBHcq3DPIzAFNphY=;
        b=hSUaQDMK4O8Ut68DmSUoyerIq/HjsCLsDayNQWB1FJynMeNZXln0F3/aUTnbm8y39I
         rkLW3LfODYhP3/b7uR5g4aNi1am0qJJ1VSfnjaVnJqN2Z7AWTZCmE+WqVDqdwAx903hl
         Ed5BM1FRToqbl4PX3nY9E1zbR+/f/d5vrspqeSiHkFJFsSTBQPBLtblBZPTevVPdfOdU
         1etEgYH91SZv7rIC++eZ4aDUo3AprLZt+EStIhc37YenTf4Az7k9ji2PO9JwU5UhOpeg
         LlnVsEp7rlHJEzbFA8Q+uEBR1GW9ZS02cYBAhhkOrBT8I15H8lGRljTeyIMt6pwSm1EW
         3gLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEydQnCiiB9iy6pnOk/cAGg/1/rtBHcq3DPIzAFNphY=;
        b=txgF57TSPeyS6RCLdVBkD1NilLEV7tFdIOHaKxVtuEQHxPWEvvZVK4vQbZRq69ZODg
         Hvhr8QTPkk6/+x4jt3T0gJYyd5Lkr2wFUFpklReLhi/PuBrIW7hzBo/AlCaVohjES7MK
         cDppz8glXdR8yBHybF9r+0XPAfYTOqRW5S6NOu5RZUlrSpaBnaxStYOpUshU6knCA3a0
         q1V27gdOnn10GiZWVGhpjhSFAzUmlLFqabFCIsPwFqoTXQ5AsoG0EP6cO7n5on7FaaxG
         SJf4Ov6k7Zq3+NmChmz039W/BZOvmCk0NE6ekZNGb5gP0j62NbHOm3RuicULgzRdRGhi
         jj+Q==
X-Gm-Message-State: AOAM530mHM3Ki/WM6whH+Mkjk+/A+Cg7XWdMLbsufS8lA0aX/9H+zFLz
        Lr9cRMZDhj+oIh2BUaNqugKjFAfBuK3KhxHUk6Fs/w==
X-Google-Smtp-Source: ABdhPJz5awbgOKC0zlUDSKhgM3uohHZwxW/JsQQkEsstbjQi6yQpMmzZsV8j+DIAJEvOUGFfzNlU80svca6oG4UqIsI=
X-Received: by 2002:a25:6994:: with SMTP id e142mr88133ybc.364.1630510190355;
 Wed, 01 Sep 2021 08:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
 <9c9ef2228dfcb950b5c75382bd421c6169e547a0.camel@redhat.com>
 <CANn89iJFeM=DgcQpDbaE38uhxTEL6REMWPnVFt7Am7Nuf4wpMw@mail.gmail.com>
 <CANn89iKbgtb84Lb4UOxUCb_WGrfB6ZoD=bVH2O06-Mm6FBmwpg@mail.gmail.com> <c40a178110ee705b2be32272b9b3e512a40a4cae.camel@redhat.com>
In-Reply-To: <c40a178110ee705b2be32272b9b3e512a40a4cae.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Sep 2021 08:29:39 -0700
Message-ID: <CANn89iKxeD0sMe-Qp5dnQ_vX28SGeyW3M857ww4chVsPE-50uw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 8:25 AM Paolo Abeni <pabeni@redhat.com> wrote:
>

> You are way too fast, I was still replying to your previous email,
> asking if I could help :)

All I did was to resurrect this patch (rebase got no conflict) and send it :)

>
> I'll a look ASAP. Please, allow for some latency: I'm way slower!

Thanks Paolo !
