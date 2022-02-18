Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33ABB4BB794
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiBRLFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:05:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiBRLFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:05:18 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6028881F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:05:00 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id bn33so3728175ljb.6
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dW38+fVt/5B2vK83bepturKi78lX8fCf7eiBH2aFc4c=;
        b=egBKrWlefX52oE0NwfmpSs2LrD2HbYv/z/rIOlXcpUcgCsaSZ7c7kneDD+QL4ns860
         Nxqj9CMO6aFkIynDv0KAeo8wqG7SHQBt2u5pPGbTtO7iSGg80Y4FmD0SJcSuGBwXPxsC
         MEL98ErPZOWVfgPWustjGUS2B+J1jOBxkm8qSg75ylrW8TxUg61WF5Pi5gTI6am+dmRS
         YNrg/fR9wtBOIsIqNPjyyzRkgpPiY1xtmOMz2G25nS2THyNHjGTPhdxzygv80Lol6X1h
         5nzaXSYb+rMvKSj4XMJRdp4BZsP/TtRsEUxWlro6P7Ko00E0XxFJakB5KZKW6voUg93G
         Zblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dW38+fVt/5B2vK83bepturKi78lX8fCf7eiBH2aFc4c=;
        b=zHxJTJsd7DFdSA9z/4NYWNBNxCAovfKQR33MdP13REOuAy4vbXlj7dBeJujUA5eRI9
         IpZF5SzCJqJOR3Le7f3quZ7sYXA8m8Q+OOjxI2iOltRDACKHmUHYQsAi3psWeRYJHmPu
         SzD770rst+hpkAXkJXBFF5Ai5PafkhNXpG9+V3JNBEvM7+jVQ5f0XKjWcpaW1BmYxKo+
         myh1xGAdhUDGRcA+cPZS9Eke2t1MTwFSmZtYydl0k7oBNLkda70XjKRtNz/OgT1aOoVz
         kcKFnYy2A8cTn8+GIVJaJIzb6g12/FsnRDoi55PUM6jPu5w+WSem+B9TBqDKyiqasCYb
         sReQ==
X-Gm-Message-State: AOAM531sAD/t/jLOKKNMkR7LWtVaL6G8ub/An9eqLT8nHVtI/Kc047WF
        4K6ABl5Mpnz8GiXJzQla4empvj0DcqzI9qPWaw8=
X-Google-Smtp-Source: ABdhPJwY1TAg8H0kyv/daGEHktSuVt6/PrOEuIN/nRodo9uqnQl0VWkrN9BxeS0pOgB7axqBV9rox3/1sn+wwpAxmIg=
X-Received: by 2002:a2e:b0f1:0:b0:239:2415:67a7 with SMTP id
 h17-20020a2eb0f1000000b00239241567a7mr5105409ljl.256.1645182299162; Fri, 18
 Feb 2022 03:04:59 -0800 (PST)
MIME-Version: 1.0
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
 <1645109346-27600-2-git-send-email-sbhatta@marvell.com> <20220217090202.3426cbac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuriYME8fr1YBMDAwUNWSy5jJ8igYCtA=kYiZJBGraNU8A@mail.gmail.com>
In-Reply-To: <CALHRZuriYME8fr1YBMDAwUNWSy5jJ8igYCtA=kYiZJBGraNU8A@mail.gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 18 Feb 2022 16:34:47 +0530
Message-ID: <CALHRZurHknYM=qvbuF2Ym1CusFpR6RvLdPXb97qGL2XAjD4tgQ@mail.gmail.com>
Subject: Re: [net-next PATCH 1/2] ethtool: add support to set/get completion
 event size
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
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

Hi,

On Fri, Feb 18, 2022 at 1:40 PM sundeep subbaraya
<sundeep.lkml@gmail.com> wrote:
>
> Hi Jakub,
>
> On Thu, Feb 17, 2022 at 10:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 17 Feb 2022 20:19:05 +0530 Subbaraya Sundeep wrote:
> > > Add support to set completion event size via ethtool -G
> > > parameter and get it via ethtool -g parameter.
> >
> > > @@ -83,6 +85,7 @@ struct kernel_ethtool_ringparam {
> > >   */
> > >  enum ethtool_supported_ring_param {
> > >       ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
> > > +     ETHTOOL_RING_USE_CE_SIZE    = BIT(1),
> > >  };
> >
> > include/linux/ethtool.h:90: warning: Enum value 'ETHTOOL_RING_USE_CE_SIZE' not described in enum 'ethtool_supported_ring_param'
>
> compiled for ARM64, x86 and with COMPILE_TEST, W=1 but I did not see
> any problem.
> Please let me know what I am missing here.
>
Got it. It is a kdoc warning. Sorry for the noise.

Sundeep

> Thanks,
> Sundeep
