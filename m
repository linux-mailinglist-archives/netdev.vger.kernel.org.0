Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185563F3B0
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiLAPWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiLAPWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:22:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261A71A073
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:22:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bx10so3284858wrb.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 07:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2JYJL4PRliI2BDP35DC98p8HuxxcUt6MHu9B8s9tzk=;
        b=OLj9jCIoRKd4wGyd6YDGSYo47NvNQp9mN5wiEZTdkscLmoGYb5gq/CCRTrCRwsssb9
         WKeYjcYiHsjc0LgeXxsGpw6K/g7uCRd8ay1W81t2vGuSCIUrWivE6Rkj5OksfDiquBdQ
         uucBZ9k8KP/8k5RBnZA3Itxvml+FsawZ+T/RoWYQ0X/AsBvv123oyjdFXHVmSK5msOGM
         xW1Z7mk4HK4nWl2VN/eF0RL7qtIqB7ieIK+L9zmWE0UcB7koWbTMd/8LO3py4DSbSMSe
         SUeY5y+ebBn3w0D6zIaW3dfiEee+cAS3BRcJh3XCJxzErgsd5YVShHZ2eujFICfqzHby
         +6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2JYJL4PRliI2BDP35DC98p8HuxxcUt6MHu9B8s9tzk=;
        b=Sq4ti9CJP+0tWpeVJkFSnp6pLuz3Hbkv6mFl5C1FiuWNtlY3wNOB2BVC9KfRCXcbsQ
         ZJfB5WwaPENfCw4eLnCHcCdl/vYX2ZNJxR1BlAz/vq1VfNgJEcV7QnSPwSItnRctmp4I
         alPMA2uKRityg2JwGZPbjf9mBwkCyOhFzJxPA0M856AbnMOLVjjqOnKb1lQAYwiR/ueX
         C/ZHYenHgnaSw2JwnEY2wAQ4o4GKUf0Pff/GvQ+JLSjTuT9lfFkDdoSWrHyBwYwsoReG
         +gJaI+IpWhCV7pRzSybMp02D83sSC3Q2dLDbfU+gWEPUPGI3zebhCLtfDWhk7aSkFoVH
         CpUA==
X-Gm-Message-State: ANoB5pmL3qPZgxdVmVgZuuNLOmGRHjXmbrL67ZxUMSzKXcsKyx1AUPTr
        IFCsDygVMEqulrFQivusYp02Bo39aREuAREcnDI=
X-Google-Smtp-Source: AA0mqf40/qcLKzbvHLuhzg/raM2IhrFjVYxPi+61tbhzuC0sNW35tGfWdNEIo3MNQ3R7pgGQAugR2z103Nyqrj1L86g=
X-Received: by 2002:adf:d4cd:0:b0:241:fc9e:fb90 with SMTP id
 w13-20020adfd4cd000000b00241fc9efb90mr22423525wrk.430.1669908162174; Thu, 01
 Dec 2022 07:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20221130124616.1500643-1-dnlplm@gmail.com> <CAA93jw58hiRprhvCiek+YSOSb_y2QsQVWQMzrPARgGJGj9gEew@mail.gmail.com>
 <CAGRyCJGAMGxW04_XQjrUforZ6G7Y4gcR=CvkzZDiP0vqHnB-pg@mail.gmail.com>
In-Reply-To: <CAGRyCJGAMGxW04_XQjrUforZ6G7Y4gcR=CvkzZDiP0vqHnB-pg@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 1 Dec 2022 07:22:29 -0800
Message-ID: <CAA93jw7U7zD1bFtqNGz_cV76iDPRVJPNXE-d+OBYrEisUZhyMQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] add tx packets aggregation to ethtool and rmnet
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 2:55 AM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Hello Dave,
>
> Il giorno mer 30 nov 2022 alle ore 16:04 Dave Taht
> <dave.taht@gmail.com> ha scritto:
> >
> > On Wed, Nov 30, 2022 at 5:15 AM Daniele Palmas <dnlplm@gmail.com> wrote=
:
> > >
> > > Hello maintainers and all,
> > >
> > > this patchset implements tx qmap packets aggregation in rmnet and gen=
eric
> > > ethtool support for that.
> > >
> > > Some low-cat Thread-x based modems are not capable of properly reachi=
ng the maximum
> > > allowed throughput both in tx and rx during a bidirectional test if t=
x packets
> > > aggregation is not enabled.
> > >
> > > I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat.=
 4 based modem
> > > (50Mbps/150Mbps max throughput). What is actually happening is pictur=
ed at
> > > https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/vie=
w
> >
> > Thank you for documenting which device this is. Is it still handing in
> > 150ms of bufferbloat in good conditions,
> > and 25 seconds or so in bad?
> >
>
> New Flent test results available at
> https://drive.google.com/drive/folders/1-rpeuM2Dg9rVdYCP0M84K4Ook5kcZTWc?=
usp=3Dshare_link
>
> From what I can understand, it seems to me a bit better, but not
> completely sure how much is directly related to the changes of v2.

Anything that can shorten the round trips being experienced by the
flows such as yours and wedge more data packets in would be a
goodness.

A switch to using the "BBR" congestion controller might be a vast
improvement over what I figure is your default of cubic. On both
server and client....

modprobe tcp_bbr
sysctl -w net.ipv4.tcp_congestion_control=3Dbbr

And rerun your tests.

Over the years we've come up with multiple mechanisms for fixing this
on other network subsystems (bql, aql, tsq, etc, etc), but something
that could track a "completion" - where we knew the packet had finally
got "in the air" and out of the device would be best. It's kind of
hard to convince everyone to replace their congestion controller.

Any chance you could share these results with the maker of the test
tool you are primarily using? I'd like to think that they would
embrace adding some sort of simultaneous latency measurement to it,
and I would hope that that would help bring more minds to figuring out
how to solve the 25!! seconds worth of delay that can accumulate on
this path through the kernel

https://github.com/Zoxc/crusader is a nice, emerging tool, that runs
on all OSes (it's in rust) that does a network test more right and is
simpler than flent, by far. I especially like the staggered start
feature in it, as it would clearly show a second flow, trying to
start, with this kind of latency already in the system, failing
miserably.

My comments on your patchset are not a blocker to being accepted!

If you want to get a grip on how much better things "could be", slap
an instance of cake bandwidth 40mbit on the up, and 80mbit on the down
on your "good" network setup, watch the latencies fall to nearly zero,
watch a second flow starting late grab it's fair share of the
bandwidth almost immediately, and dream of the metaverse actually
working right...

> Regards,
> Daniele



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
