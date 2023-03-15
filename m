Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0209C6BAB51
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjCOI7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjCOI67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:58:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042BB11643;
        Wed, 15 Mar 2023 01:58:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13so8017509pjh.0;
        Wed, 15 Mar 2023 01:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678870737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzFT6vXz/r8jWMQXpxUgn/3JgOYkhx75YYs+pVWVTvg=;
        b=gywXm1X9g2Qs1seW2P+ZxUTEm0GNFlth36pkfO9dlOcIdt527Poa8YY8XXkNW425n7
         5psjK8dPIKDgnWpFH0YJtwf7NaTib4JjbjfWBj+foEktf1w5IHaJr76XqzOb3qYYZGb8
         6GSaUsilmDFvHEbGnQykNIgVTOPpoyFVrgH8758pDYFy5DnrJQgmdZLau+R2xfvzLtOu
         ClKU4Gj7aSTGm29pxGaH2vu5fKkOlNFb2yeOhU+XExyumY5WlwIEzb4eMBkuuMhjhxaJ
         9WmTkrMSG2yK+oALcvokBCs7s5kV76/LEVUJy/VF110HBC84AC3xAbDvMQ8qYChBSGQV
         /vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzFT6vXz/r8jWMQXpxUgn/3JgOYkhx75YYs+pVWVTvg=;
        b=eGwMbKY9R3rnt6Vip01fww1SQVzp5DY5LH1xsgPLFwInVq8juWtWCqJbV+N/elcp5W
         3yCYvs2/0CNLfz513I3o4VSETDP7msWfsamCbBXOSCdGYDGeISMNqfa6zESGhBimjzSW
         Flo9+F79AaNN7exDz11SBNqKnC8sq3ulLFI4XOoT9tG7qHeyl2lo2FgyPZeo05DvJO3w
         qE+R8F2lmCQLsiwi5hW8mVrlngZYUWQW3XZNclBUijq5CJgvbGVaOC6UHjwQwlXM4m8U
         36JsWzKZfyXbcmmHAZ/2kfnr0LricAuVdkIblZ/2g+Z8VhyCZYMoStBAnr6ZipfxOIwV
         hJYw==
X-Gm-Message-State: AO0yUKXgKZ54mbGjmL+gwgay93nf4LBcXjSxTM1Lgi0AXyujcBaocMRv
        cJ/JG0jW5L66wFikOBbh111OeyHFf8quebNOuuE=
X-Google-Smtp-Source: AK7set/FngVgFTHLEwnzsWZi0OUAb9EcDEH5/PXKKYukRLMBDgEleFvcHGMROiaADv9PZFUC8dkENDc2m0Qcm1efTU8=
X-Received: by 2002:a17:903:130a:b0:1a0:52f1:8ea7 with SMTP id
 iy10-20020a170903130a00b001a052f18ea7mr827414plb.12.1678870737462; Wed, 15
 Mar 2023 01:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230309094231.3808770-1-zyytlz.wz@163.com> <20230313162630.225f6a86@kernel.org>
 <CAJedcCxBn=GE_pQ4xzpnvUmMA6rDuwn_AiE7S7d1EqGF9cHkNw@mail.gmail.com> <20230314211028.6e9cbbcf@kernel.org>
In-Reply-To: <20230314211028.6e9cbbcf@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Wed, 15 Mar 2023 16:58:45 +0800
Message-ID: <CAJedcCwuH7eus+bVBvyDJOriPVgSp1UPjvXXjb9szy7C5t5h-A@mail.gmail.com>
Subject: Re: [PATCH net] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8815=E6=97=
=A5=E5=91=A8=E4=B8=89 12:10=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, 14 Mar 2023 09:59:09 +0800 Zheng Hacker wrote:
> > Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=
=97=A5=E5=91=A8=E4=BA=8C 07:26=E5=86=99=E9=81=93=EF=BC=9A
> > > On Thu,  9 Mar 2023 17:42:31 +0800 Zheng Wang wrote:
> > > > +     cancel_work_sync(&dev->tq_refill);
> > > >       ns83820_disable_interrupts(dev); /* paranoia */
> > > >
> > > >       unregister_netdev(ndev);
> > >
> > > Canceling the work before unregister can't work.
> > > Please take a closer look, the work to refill a ring should be
> > > canceled when the ring itself is dismantled.
> >
> > Hi Jakub,
> >
> > Thanks for your review! After seeing code again, I found when handling
> > IRQ request, it will finally call ns83820_irq->ns83820_do_isr->
> > ns83820_rx_kick->schedule_work to start work. So I think we should
> > move the code after free_irq. What do you think?
>
> Sorry, we have over 300 patches which need reviews. I don't have
> the time to help you. Perhaps someone else will.
>

Hi Jakub,

Thanks for your precious and kind reminder. I'll think about it again
and write the next version of patch.

> Please make sure you work on a single networking fix at a time.
> All the patches you posted had the same issues.

Yes, I'll keep that in mind.

Best regards,
Zheng
