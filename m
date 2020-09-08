Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94D3261069
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgIHLDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729479AbgIHLAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:00:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48F0C061573;
        Tue,  8 Sep 2020 04:00:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id l126so3630128pfd.5;
        Tue, 08 Sep 2020 04:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7P+HyTNGtG0TbTo1ltjHRYMV5rgT/s2SfZTbcF+5SnY=;
        b=jwwFp3586/x/n+b9Tn93XWRg6mQQyMXg/b3SxsHRQjc/SUTnyv8C7D9VHMKSQSw8iM
         VvKKkKdG8IFdID9WKJjJdly5ue9AMZpfewGJvB8G5LzVgUw83+QzdYYhJFsfEgW0kKYR
         EVrf432HRoksV34dRIrT8HwFU0autE4mdlWzJg6VxuxArB7YknY+eSdFE36N7zJ7nbZB
         TUBTG7Htv+0fen0CfURZySfQiv9qy4VZyn2u0u93ko7dDvh/gerr6dxzAlc/kximIhcv
         6c8YSF/5X+e7oq2fYr5FQC5J/YtPBrR7kI4gex/KVjMmOuuqsLjNixJHWtyLHm3bnF1v
         vCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7P+HyTNGtG0TbTo1ltjHRYMV5rgT/s2SfZTbcF+5SnY=;
        b=G/73GfjTPnESJrGMCzeMy9GzUDeWKZS8dYtDlzeYpzntgHgnW/W0y+uMqCIkFiGS4p
         02ql8AwUR/tQykuiervJ5BQb4+FDrF/UVxlRedzuJe9NuwSO1RNEf0dNhDvsJXBnq8py
         tOKYvTn8baRC9NTaWqYNeZ50a1QNQBHZ/w6/FxzgwiwN+JVGTtkVCa4qNAgr0P55INBc
         9tCKUV1ckAkIKx6Q6KkjVkYm4wdHz2MPJT0Ul6jIazxAXPYORxd2XE+OWbVWWwz+AhXO
         MY3R2E+jMsbMCaXajrB/IJsZ2cwAAHc2v8wtawGaiwJFUv6vIAN6tybPh6F4QnY0IAfv
         KNxA==
X-Gm-Message-State: AOAM532blKO4nfeiOkoRj+FE2tO+sA35d4g7AR4mpltYB/4262ofoCVV
        ojiuQNZ30QTts8Lcbjpf/sVJ72Q6dOO7a6Rd4u8=
X-Google-Smtp-Source: ABdhPJwsEpXaiJLryhaI0pj5sh7Z33Qq5glUERK4QTaOGvBUWws8u2uEs+dNKUu13UyQHrVNBBqlhbRxW30vLrhFc90=
X-Received: by 2002:a17:902:7083:b029:d0:cbe1:e7b5 with SMTP id
 z3-20020a1709027083b02900d0cbe1e7b5mr670449plk.38.1599562824414; Tue, 08 Sep
 2020 04:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
 <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
 <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com> <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
In-Reply-To: <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 8 Sep 2020 04:00:13 -0700
Message-ID: <CAJht_EN7SXAex-1W49eY7q5p2UqLYvXA8D6hptJGquXdJULLcA@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 1:41 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> The intent is to bypass such validation to be able to test device
> drivers. Note that removing that may cause someone's test to start
> failing.
>
> >  So there's no point in
> > keeping the ability to test this, either.
>
> I don't disagree in principle, but do note the failing tests. Bar any
> strong reasons for change, I'd leave as is.

OK. I got what you mean. You don't want to make people's test cases fail.

I was recently looking at some drivers, and I felt that if af_packet.c
could help me filter out the invalid RAW frames, I didn't need to
check the validity of the frames myself (in the driver when
transmitting). But now I guess I still need to check that.

I feel this makes the dev_validate_header's variable-length header
check not very useful, because drivers need to do this check again
(when transmitting) anyway.

I was thinking, after I saw dev_validate_header, that we could
eventually make it completely take over the responsibility for a
driver to validate the header when transmitting RAW frames. But now it
seems we would not be able to do this.
