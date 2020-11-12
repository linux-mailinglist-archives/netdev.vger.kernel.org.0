Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95D2AFFE2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKLGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgKLGwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:52:30 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872ECC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 22:52:29 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id j14so4651435ots.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 22:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GE7p94KmLHGLgQFOXX7eLLFKTENdZjqb8K4ql0IbfUQ=;
        b=EEF2FoD9nMrZifYTzOYO3SNQDEDZO5Wmrc+cK2mHMlaynhOUGxv2YHcMHgZj27qArP
         LOL5OYULH0WO07m3dNdVaYzIsb3vTEv7QmUFOwls1g7jtRxqR4Ci/b5yA1qRLLNG3WRh
         IF78ms66VbQCd1KenWY2Y77jSGmRO1ffnhguv4LHY3kCAcVOw9mKktf7YbaEy1hlE2KC
         TUIILlmdv3WuCTPEq9KGf5M+uhlkzf946O2Z0mco7FCRYQBZm7TDw1MtEeXXURoJ580n
         mUMAPMkSrY9H7JxMDB18JJYZipgg8HBIMrIN05FN4VKBeB4jOu5EktdAdNFzNw41QLZT
         fLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GE7p94KmLHGLgQFOXX7eLLFKTENdZjqb8K4ql0IbfUQ=;
        b=Lymkpi/aBhActH6XInsKEKZNnbkZx2thPP96sBkbPM59KluTIODuCDfniGg1Ps9Vvq
         zrQF2DQ8aG893Wg3tRrsS1RTHRa53wF9uXhT0KCfPB8nh2tUyDzo7CyzJsfdRxQKRSPE
         rrOf6/b3dvBhW/C5z0lvRdZeiWTpluHbgvCJRyb4qELcPuoIUmx2LSUrsLquGdrcZgk6
         scLLvCql6znlqgyXa4GrnnnvxDhC49BIhuFIJyTM/GMD4ZNjUf1Sz5VylJ87RqBzaYAF
         9jvaL94mJ9/4ZiC4e0ZJsApmjeW3bN6GIqD8m6aPmTp2DrDhvHYJElK+9bHbGj++tp2k
         TK+A==
X-Gm-Message-State: AOAM530Geg7A2tA5Qq/JRmmKWOKj9L6I6EpjQZbmO8Y3pvh/IkKWyFUa
        wClBCdGekEGmagnW3P91K7HNzTgKDh+xST9c+Kw=
X-Google-Smtp-Source: ABdhPJz1KT1U8eaQzrza+76V3+rPPKUPaxjdDoe58LNCgFPpqmy1MXJBeJ65Jh5l6kW9mljbXGtmW74lIaYR9xHXw6Q=
X-Received: by 2002:a9d:929:: with SMTP id 38mr21311748otp.170.1605163948869;
 Wed, 11 Nov 2020 22:52:28 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com> <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
In-Reply-To: <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Thu, 12 Nov 2020 07:52:18 +0100
Message-ID: <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
Subject: Re: net: fec: rx descriptor ring out of order
To:     Fabio Estevam <festevam@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:18 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> On Wed, Nov 11, 2020 at 11:27 AM Kegl Rohit <keglrohit@gmail.com> wrote:
> >
> > Hello!
> >
> > We are using a imx6q platform.
> > The fec interface is used to receive a continuous stream of custom /
> > raw ethernet packets. The packet size is fixed ~132 bytes and they get
> > sent every 250=C2=B5s.
> >
> > While testing I observed spontaneous packet delays from time to time.
> > After digging down deeper I think that the fec peripheral does not
> > update the rx descriptor status correctly.
>
> What is the kernel version that you are using?

Sadly stuck at 3.10.108.
https://github.com/gregkh/linux/blob/v3.10.108/drivers/net/ethernet/freesca=
le/fec_main.c
The rx queue status handling did not change much compared to 5.x. Only
the NAPI handling / clearing IRQs was changed more than once.
I also backported the newer NAPI handling style / clearing irqs not in
the irq handler but in napi_poll() =3D> same issue.
The issue is pretty rare =3D> To reproduce i have to reboot the system
every 3 min. Sometimes after 1~2min on the first, sometimes on the
~10th reboot it will happen.
