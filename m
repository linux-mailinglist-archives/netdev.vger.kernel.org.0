Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8B95FD7CB
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJMK3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMK3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:29:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A493FAA65
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 03:29:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so2860984ejb.13
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 03:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WGZONRhkEHYOZp0ds95v80w8H73rTkhqzNmfYGEj6j8=;
        b=kJSHlx0JBHahejvu3iriFg0wapaICcFdeRVvQSwuTL00bwpZhYzly2zk7ypbHzBQzq
         unRO3TsLbDsexp1Gk3raezi7sF5oWgFaHNaqiaVl9SiyQZWOPc/oz5LVflmRFVFBe2IA
         4dNeRi9eklgaKQtViIqTf3bKAtpIoy1gG4nB1qPtvkLl1EX1FsuqhSGg6PPEebhFip9r
         EsurNTK8xkEryca/u262YUJcnWmvJJWNiBzV4wP2Fh7ANBURfVmvQouavuWliVn3mwSM
         BrmEDq/uzyJtHF/JmtKyQnPzrpFUW6HPZmLuYs/CkR2EHSf6coJ99MXoJeHl/DXh1tMm
         LKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WGZONRhkEHYOZp0ds95v80w8H73rTkhqzNmfYGEj6j8=;
        b=T7RYKdZXvr5p4D9rh4Kx7ZNIDgoN/6vAHWsSOkwX2Y6X9mncQtfJ99LV4eTrnok9Ks
         jIC5IMUM/tZHpQpq9gO81FKLbFhXD0QWhzC/BA5qMeotrKc1l6wUfPkJjKTSs5913KWO
         77SvjPzeBfURIPpH2fqZtucSmwqPbFYKB5RQuqvmGvNp1573/l9CAEiiMx+9fX8uxGxZ
         y02/xrh0YyfgkpmjQL6RmBBHP9hx5qPg1l63Uup3MBVgUmKWcGfri4mrXmZWeomR9AiX
         j/OQ8R/Fd1/CP2z2Lkel4qN2fMY6QXkTNkfGT+KiTdKqTy/pCceDVTTGRpkrCi0s20oZ
         Uv8A==
X-Gm-Message-State: ACrzQf12Q0diB7YrXsWmMANo1IC6bNsTc6T7zxlZW4RAC+JAt6ffuLkG
        ZS0QJkxB6c+DUDE4dPl+UfC9Bz+lTd3s+uRj2PzXnEWUuXmILA==
X-Google-Smtp-Source: AMsMyM5h3NDcZiC89+OZ7ZjtoAXh/bL+DBBWZyYAwXY4jdlOfvOgdV1g3D1THdfXlSwhfsPdoH3DhifrO03CqgDTkiw=
X-Received: by 2002:a17:906:1350:b0:77f:76a7:a0f with SMTP id
 x16-20020a170906135000b0077f76a70a0fmr25667372ejb.503.1665656951730; Thu, 13
 Oct 2022 03:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221012153737.128424-1-saproj@gmail.com> <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com> <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com>
In-Reply-To: <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Thu, 13 Oct 2022 13:29:00 +0300
Message-ID: <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than 1514
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 at 00:41, David Laight <David.Laight@aculab.com> wrote:
>
> From: Sergei Antonov
> > Sent: 12 October 2022 17:43
> >
> > On Wed, 12 Oct 2022 at 19:13, David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Sergei Antonov
> > > > Sent: 12 October 2022 16:38
> > > >
> > > > Despite the datasheet [1] saying the controller should allow incoming
> > > > packets of length >=1518, it only allows packets of length <=1514.
> > >
> > > Shouldn't that be <=1518 and <1518 ??
> >
> > Oh, thanks for noticing. But still it should be slightly different:
> > <= 1518 and <=1514
> > Here is my test results of different packet sizes:
> > packets of 1518 / 1517 / 1516 / 1515 bytes did not come to the driver
> > (before my patch)
> > packets of 1514 and less bytes did come
>
> I had to double check the frames sizes, not written an ethernet driver
> for nearly 30 years! There is a nice description that is 90% accurate
> at https://en.wikipedia.org/wiki/Ethernet_frame
>
> Without an 802.1Q tag (probably a VLAN tag?) the max frame has
> 1514 data bytes (inc mac addresses, but excl crc).
> Unless you are using VLANs that should be the frame limit.
> The IP+TCP is limited to the 1500 byte payload.

Exactly! Incoming packets first go through a switch chip (Marvell
88E6060), so packets should get tagged.

> So if the sender is generating longer packets it is buggy!

Looking into it.

On the sender computer:
sudo ifconfig eno1 mtu 1500 up
ssh receiver_computer

On the receiver computer:
in ftmac100_rx_packet_error() I call
ftmac100_rxdes_frame_length(rxdes) and it returns 1518. I suppose, it
is 1500 + 18(ethernet overhead) + 4(switch tag) - 4(crc).

Would you like me to dump the entire packet and verify?

> > If FTMAC100_MACCR_RX_FTL is set:
> >   the driver receives the "long" packet marked by the
> > FTMAC100_RXDES0_FTL flag. And these packets were discarded by the
> > driver (before my patch).
> >
> > > Looks like it might cause 'Frame Too Long' packets be returned.
> > > In which case should the code just have ignored it since
> > > longer frames would be discarded completely??
> >
> > Is there such a thing as a response packet which is sent in return to
> > FTL packet? Did not know that. My testcases were SSH and SCP programs
> > on Ubuntu 22 and they simply hang trying to connect to the ftmac100
> > device - no retransmissions or retries with smaller frames happened.
>
> Overlong frames should be discarded.
> The sender might choose to do PMTU (path MTU) detection,
> but probably doesn't unless a router is involved.

I am afraid the developers of ftmac100 controller did not take into
account the possibility of VAN tagging. So my patch is an attempt to
solve the issue. However, I am now doubtful about it. After my patch
the driver will not be correct for the case without a switch. Should I
instead of simple checking for "length > 1518" check a packet for VLAN
tag presence and then, depending on the result, for "length > 1514" or
"length > 1518"?

> ...
> > > Do you need to read this value this early in the function?
> > > Looks like it is only used when overlong packets are reported.
> >
> > I decided to make a variable in order to use it twice:
> > in the condition: "length > 1518"
> > in logging: "netdev_info(netdev, "rx frame too long (%u)\n", length);"
> > You are right saying it is not needed in most cases. Can we hope for
> > the optimizer to postpone the initialization of 'length' till it is
> > accessed?
>
> Unlikely unless there are no function calls and no volatile
> memory accesses.
> IMHO just because you can assign a value on the declaration
> (of a local) doesn't mean it is a good idea.
> Better to move it nearer the use (unless it is used throughout
> the function).

OK. I will rewrite this part in future versions of the patch.
