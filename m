Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A2A410E24
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 03:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhITBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 21:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhITBPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 21:15:43 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2A8C061574;
        Sun, 19 Sep 2021 18:14:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j6so14735433pfa.4;
        Sun, 19 Sep 2021 18:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oRSRcDxtN/Ll6J7EsviEMpFneSzICU8Oj1/Q6JuhQIU=;
        b=cE0k4oLUY/m6MQVOxb/KYAL8TZm20cj3jwE9ZFqCwQCTc0pMrF2B8WeajWYwWYDXYs
         7GS56xu0I6n+Xh9upVjbL1UYiKUfr/nMUMT+8UPHQQJxK9p8gJxN0gCI+SY2g/4Xsl81
         AtOoaJC+XAc8ubMhz/CpgZtUk68lAa7ktZgF9BSM0IOiy1W5R6bHp0G5mte02wjf92Ok
         KEfVAM2lKYpFooxu+J8XV0xFQfnEpIYFL9/agTgMGWuMw/btzt+S7GZF/4wWE81TXRwC
         bW8qaO4PfzurtV60uB2c0qSel8ynlKo/+qBiSgYXuZA9tLkQjmO2jjOd4coHSzLVDcZq
         u9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oRSRcDxtN/Ll6J7EsviEMpFneSzICU8Oj1/Q6JuhQIU=;
        b=41H2OTcL/I9cLJGTH7e+VukENW3sbY4WJOfgOhWk0xOAFCVBVcoWJKnBdacm0K11/1
         nkc2Mk/lZlHAmXEzx9pByeIZtLxSZ8cfMZYDhWBOTLNV2mjc+QfNvmuEz93CR4Ldt3iA
         +zeZAgxoTHRz+q9wOOxca+XRxST1uo7C3yRs3odxMZ57ahYAcgT8aB1dD90CU85Iy0xC
         B3hAEYxjCVaIAl2VCCiXr/GmPwasvO2k+SzhUsz6dga6UqU9g/aCIv+fD+KsUAW/r0sw
         HOn1lhYjThxxrzROtstvQJuay1RBN0jyQLgqFWle6fSKhyQxwrxDjZFkZ5Vdv+8UMgPw
         A1UA==
X-Gm-Message-State: AOAM532tsJ2cwghwu+lwZybw39VGiqwlOYujjk+u6LEVFbNvD1hun2LX
        /mFPU9cW0U00L4vYDL9b4KilmGIMTyw8EoTxgI0=
X-Google-Smtp-Source: ABdhPJz9gqbQdMZpXCD3dv5VfRuGlJfT+HkKzkTncnCxr+thQCCIH5ga9+Rl/gG6yqZPVvxZ8O2RuFOwzxH83E10qao=
X-Received: by 2002:a63:6f82:: with SMTP id k124mr16716550pgc.218.1632100456597;
 Sun, 19 Sep 2021 18:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210917013222.74225-1-liujian56@huawei.com>
In-Reply-To: <20210917013222.74225-1-liujian56@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 19 Sep 2021 18:14:05 -0700
Message-ID: <CAM_iQpUpUdd-SnrLOffVoGnW3ocKxDtefUAjktEs1KxE2-Gmvw@mail.gmail.com>
Subject: Re: [PATCH v2] skmsg: lose offset info in sk_psock_skb_ingress
To:     Liu Jian <liujian56@huawei.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 3:05 AM Liu Jian <liujian56@huawei.com> wrote:
> @@ -624,6 +635,13 @@ static void sk_psock_backlog(struct work_struct *work)
>         while ((skb = skb_dequeue(&psock->ingress_skb))) {
>                 len = skb->len;
>                 off = 0;
> +#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> +               if (psock->sk->sk_data_ready == sk_psock_strp_data_ready) {
> +                       stm = strp_msg(skb);
> +                       off = stm->offset;
> +                       len = stm->full_len;
> +               }
> +#endif

How does this work? You are testing psock->sk->sk_data_ready here
but it is already the dest sock here, so, if we redirect a strp_msg() from
strp socket to non-strp socket, this does not work at all?

And this code looks ugly itself. If you want to distinguish this type of
packet from others, you can add a bit in, for example skb->_sk_redir.

Thanks.
