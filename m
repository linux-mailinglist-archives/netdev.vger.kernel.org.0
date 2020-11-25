Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F280F2C3C29
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgKYJ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgKYJ1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 04:27:41 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78EEC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 01:27:41 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y9so1516432ilb.0
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 01:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12BXPuNJpNTHLbSDTDBbC2XwK7gRTi74c0tpy/C/gVs=;
        b=DL6B9nqeR6LzP+opt8NQb2EWEgCJw2ZZpywq/ttZp0mAYGOtkcCRtxKw/tvNEhNJzC
         R/XUbqLILBes9bob+EAvyUATlWzwUX5p7kJG9E6DSota4pLH51XD2t947sS+Sb11gvxi
         d4/wd7P2MpRM+KOmJI05tGbp3GZ1MxPxT/n1TXBY2yS2zIhmVk2cMMqoSmzbp4V4Mr8L
         cks3k7LtsSsrmBFJZaFOsXPcIrNPXOGi1H/mCQyjK5K1PvBOLBRCJ4DGqKL4K1JjhcYn
         EG5ffAq3ilInn5uA9AaqVSfynPUrFR8eMD4WxEeAl3qrVi6slsVBPvsuT7FLXxvVS7YB
         HAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=12BXPuNJpNTHLbSDTDBbC2XwK7gRTi74c0tpy/C/gVs=;
        b=bnUWvaS0zJXiA/DbopQQPv0LWYm27Bu/D8V7TyrMqGJKTOuiNPwhP8vPJmAEr2z4Lk
         RwvWmzYRBfCOauUkcAq5GB0Nt6zAPb+FeDdBQxBuxTUWvyQHis5DZMtuKn/qYwiJmze4
         Bmb/xX0/pZ4St5pr/lszDGpgdgj6zUH7hDv4zVMvJvn6jaWOgbCfhW9SrPMCQwUvCwMd
         J1e7JR8LaDTbksyERAhuKqN2CwpSAgmVMx8E32wx4dv70ixOEQVSRi0NVIEId4q8h5tC
         2n+Ldp35SusUkkyb6cmzTMqJxx/YOEmuDSXbiuIBeIFkbLv/8aq6oiGrj+uytOWU1Nmw
         9CfA==
X-Gm-Message-State: AOAM533WdEnfTjyi0+/Z+RfW3NMAIghfZpg5eFqRUJd11PWq5Fp9E3G4
        RipIEhRYDPrP7P/TXpKIMx2p+spw0i2MwqETnsxOMA==
X-Google-Smtp-Source: ABdhPJwcM6mRyuDXMbLzzPtsS4uBK6m4U1duek75JJHp8iqTm3wFW2C0m6f/MnYhbN3gtd4kw4p5m0ih0RokpulgCJ0=
X-Received: by 2002:a92:358e:: with SMTP id c14mr2267983ilf.69.1606296460480;
 Wed, 25 Nov 2020 01:27:40 -0800 (PST)
MIME-Version: 1.0
References: <20201123141256.14208-1-tariqt@nvidia.com> <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com> <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
 <20201125032549.GA13059@gondor.apana.org.au> <329952c5-b208-1781-5604-2b408796ec90@gmail.com>
In-Reply-To: <329952c5-b208-1781-5604-2b408796ec90@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Nov 2020 10:27:28 +0100
Message-ID: <CANn89iLTsTgW9UPFn_LNN5Qvs9+0drfcW2cQHtCVYMoboHdv4Q@mail.gmail.com>
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 10:06 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 11/25/2020 5:25 AM, Herbert Xu wrote:
> > On Tue, Nov 24, 2020 at 11:48:35AM +0100, Eric Dumazet wrote:
> >>
> >> Well, the 'increment' part was suggesting the function was adding
> >> flags, not removing them.
> >
> > The idea of the increment part is that we're adding a constituent
> > device, not that we're adding features.  There have always been
> > features which were conjunctions, i.e., they must be supported by
> > all underlying devices for them to be enabled on the virtual device.
> >
> > Your use of the increment function is unusual, as you're not adding
> > features that belong to one underlying device, but rather you're
> > trying to enable a feature on the virtual device unconditionally.

This was not the intent.

We can still disable TSO on the bonding device if desired.

pk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
tcp-segmentation-offload; done
tcp-segmentation-offload: on
tcp-segmentation-offload: on
tcp-segmentation-offload: on
lpk51:~# ethtool -K bond0 tso off
Actual changes:
tcp-segmentation-offload: off
tx-tcp-segmentation: off
tx-tcp-ecn-segmentation: off
tx-tcp-mangleid-segmentation: off
tx-tcp6-segmentation: off
large-receive-offload: off [requested on]
lpk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
tcp-segmentation-offload; done
tcp-segmentation-offload: off
tcp-segmentation-offload: on
tcp-segmentation-offload: on

The intent was that we could have :

lpk51:~# ethtool -K bond0 tso on
Actual changes:
tcp-segmentation-offload: on
tx-tcp-segmentation: on
tx-tcp-ecn-segmentation: on
tx-tcp-mangleid-segmentation: on
tx-tcp6-segmentation: on
lpk51:~# ethtool -K eth1 tso off
lpk51:~# ethtool -K eth2 tso off
lpk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
tcp-segmentation-offload; done
tcp-segmentation-offload: on
tcp-segmentation-offload: off
tcp-segmentation-offload: off
lpk51:~#


> >
> >> We might ask Herbert Xu if we :
> >>
> >> 1) Need to comment the function, or change its name to be more descriptive.
> >> 2) Change the behavior (as you suggested)
> >> 3) Other choice.
> >
> > I think Tariq's patch is fine, although a comment should be added
> > to netdev_add_tso_features as this use of the increment function
> > is nonstandard.
> >
>
> Thanks Herbert, I'll add a comment and re-spin.

I think we should remove the use of  netdev_increment_features() and
replace it with something else,
because there is too much confusion.
