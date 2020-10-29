Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDF229F261
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgJ2Q6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgJ2Q6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:58:46 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EACCC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:58:46 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id b129so1923479vsb.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aDtbXhTlBa748s0h1Ogx7XDQgfv7TLeyu6NvN3vLWQk=;
        b=JW39bg0p3pFD6AuX17A3EEqsbHd0ilwYe+VdOG97eUwMsV15P/meUrTLamSm1kTXRj
         bHzeyPULvQZqQU48nfD85WNvvghI+YxKz8LFaurQx5w2xYHkPNlVCMxlvHpD004uptnf
         ulQc57Vc9bAj+Ish/kDabJxnrhwYhuKj6GKLfyXxCviMnNUSDWtXZAtFPQbPpYeoueVJ
         DGkXppSZiL/RmP4UIvtAUtQqH4RBQrE/QUYqKmxSL38A1w5a8LFpQHr2n0m4ur48C8+T
         h6GGW7U6bro8CSEJVbYcn0bUI8SvBhFk3ZSRYKImT531boAy5HgGDNq+6bJdFXxZgp+h
         G+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDtbXhTlBa748s0h1Ogx7XDQgfv7TLeyu6NvN3vLWQk=;
        b=sQLkswOvWr80UBasnzFcQWHhiGHgt5agBRvHIFIOivnJC3VyFkhf7QFRxriW9DyC5N
         lyH2X2s6Yn23b/y1Pd1XD6H1Lw2JxetKHWW5SlYMec+asenUTHpHaDyr1lMpKV4FcCRP
         QSvT9K649luxg9T4ETeH2yWn+upOCtKNnLxXPFx04mLPCd9qZDi1iB9vUQIIW623cpfu
         fOF7QBQRU8jd3uPANV9eLXak9B+pFaUmNbyRtTIEuzEZ1C9Yj7lkfnpaofGij+/soOGD
         2agRCjtiJKCPMzdYGoqFxhaIl1zeLJZ2v7lG7SiyHJlR7ThEf67hVhaayqBg/2B1ipSm
         GykA==
X-Gm-Message-State: AOAM530jGm16bCoAn1COmxIfl12SJJmCT9PumQAKC1PuZWxVSaHeXpe6
        CtzZbu5NN9g9ABEas04dearMvlEnLU4=
X-Google-Smtp-Source: ABdhPJx/EHWvPJzjr1eThXOkJwnH3zOuGj1HP/ykZ0+UPDhIBkNIgcBcqg8rlB+3uFIAkeEFT+swsg==
X-Received: by 2002:a67:77cc:: with SMTP id s195mr3931781vsc.56.1603990724950;
        Thu, 29 Oct 2020 09:58:44 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id l19sm385356vke.33.2020.10.29.09.58.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 09:58:44 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id f15so893144uaq.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:58:43 -0700 (PDT)
X-Received: by 2002:ab0:35d7:: with SMTP id x23mr3511937uat.92.1603990723236;
 Thu, 29 Oct 2020 09:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201028184310.7017-1-xie.he.0141@gmail.com> <20201028184310.7017-3-xie.he.0141@gmail.com>
In-Reply-To: <20201028184310.7017-3-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 12:58:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf_Veb8Pexix5_Nx3Ujm3P+d=0VNx6hhzPsyoBBdwQ=BQ@mail.gmail.com>
Message-ID: <CA+FuTSf_Veb8Pexix5_Nx3Ujm3P+d=0VNx6hhzPsyoBBdwQ=BQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: hdlc_fr: Change the use of "dev" in
 fr_rx to make the code cleaner
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:12 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> The eth_type_trans function is called when we receive frames carrying
> Ethernet frames. This function expects a non-NULL pointer as an argument,
> and assigns it directly to skb->dev.
>
> However, the code handling other types of frames first assigns a pointer
> to "dev", and then at the end checks whether the value is NULL, and if it
> is not NULL, assigns it to skb->dev.
>
> The two flows are different. Mixing them in this function makes the code
> messy. It's better that we convert the second flow to align with how
> eth_type_trans does things.
>
> So this patch changes the code to: first make sure the pointer is not
> NULL, then assign it directly to skb->dev. "dev" is no longer needed until
> the end where we use it to update stats.

No need for dev at all then?
