Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348764B7E4F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbiBPDED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:04:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241477AbiBPDED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:04:03 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E54670CCF;
        Tue, 15 Feb 2022 19:03:52 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c6so2009530ybk.3;
        Tue, 15 Feb 2022 19:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vb56BJHgozBm1V/crpd69p2Ram5QN1qqxOhVnbB5aE=;
        b=L8fKxPV1oOF4s0A+Lc0Q/53uPiwWiNUcZIT6zWE/jKzVxjtGJyFoqjp1Gbn0qkLK9d
         TQy6ECAl5Aq6U/MIGXdCWsEQxlJ28tMoFezkjoDBVY4uLNYFZmBmuyV8LHczc+bnab/2
         GoZFfoIwyiz4rrVzNVOOBd3hKEQmtVLHzEmZeSQ8QA5Fi40lIqNbJpwPXIt5CSCxY+hE
         oZSuWUde0EzbQO05OhohQb8E2LMeGotfqaEEwcVEP9KUMpeKJ6YplTUFLahrhR6IShQq
         pBIMAvWfHXDAGfDFz8mjID2u1KahdIMlD6mjJHoTMP2hpFbpmzRw0gRAPh3mcVTFG2C2
         uOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vb56BJHgozBm1V/crpd69p2Ram5QN1qqxOhVnbB5aE=;
        b=CcXOmIio4zE8gMojhqVM/3k0Vfct1BpqmzcxSpVLJdW5eVol0YIjNIpdT0FuPFkexH
         FORBmpaGvYxwYYqOdzv/JrFHS3a3Q6b7ADxfJiFLaA8YCKtolpt9/e8Yi4+hdCtopR9U
         ephgNRyDhdqKPnTuuq2313cM8CvCCn/jy7b4z0TDqHB/g9lMzxSvGEAyLVdiyu5934ns
         6RutZ6pujw6ui1KQ8SFsJtT27f5G91XjkijvsC+6ayI9pOzhxk6QFf0SthkqslbS10Fe
         /7XTIDYPrRGcNMccs0vlwf0/k4fY6Rhl4n6EYYDaCAQXikletC9rHLYH+Vh3uYVmFerc
         BO3A==
X-Gm-Message-State: AOAM5321EpbW4SeGzhS0NWlB98b7xgtmGrJsRJTSrnFgCuCTegwPbKjw
        WGWj5ahs5VGZETsPuETRYKcFjHYir5YIanM7Cg==
X-Google-Smtp-Source: ABdhPJxHuQ0Hs7qZOfe5yD4ngIRcR0IQu99iX6oKivlY2oKeH94oYrcc33wQ4nRq5FfUzqMWwO7vHCFlVhAWeiBaviQ=
X-Received: by 2002:a25:414c:0:b0:61a:9576:61f0 with SMTP id
 o73-20020a25414c000000b0061a957661f0mr518651yba.644.1644980631469; Tue, 15
 Feb 2022 19:03:51 -0800 (PST)
MIME-Version: 1.0
References: <CAA-qYXiUFi5atN8tGRdORbiGqWnbdquuAeKuwdpWSVFVO2FveA@mail.gmail.com>
 <8cb46dd1-c2eb-869a-0af8-443d84a83b85@gmail.com>
In-Reply-To: <8cb46dd1-c2eb-869a-0af8-443d84a83b85@gmail.com>
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Wed, 16 Feb 2022 11:03:40 +0800
Message-ID: <CAA-qYXh27znv90bm4VosJzYM-jT-iLmPrrkMHoP53mT-72tBVw@mail.gmail.com>
Subject: Re: 4 missing check bugs
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

I double-check the newest version v5.17 and the stable version 5.16.9.
The code of the 4 functions remains the same.
Are they missing check bugs?

Thanks!


Best regards,
Jinmeng Zhou

On Wed, Feb 16, 2022 at 5:51 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/15/22 04:37, Jinmeng Zhou wrote:
> > Dear maintainers,
> >
> > Hi, our tool finds several missing check bugs on
> > Linux kernel v4.18.5 using static analysis.
> > We are looking forward to having more experts' eyes on this. Thank you!
> >
> > Before calling sk_alloc() with SOCK_RAW type,
> > there should be a permission check, ns_capable(ns,CAP_NET_RAW).
> > For example,
>
>
> v4.18 is not a stable kernel.
>
> No one is supposed to use v4.18.5, and expect others to fix bugs in it.
>
>
