Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA2631332
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiKTJ0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKTJ0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:26:07 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED9922D5
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:26:06 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s12so12566427edd.5
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jd78G4d5ZD0lDCvBRuLW/rYa/9HXjleQQwuOU/fiPw=;
        b=b1Ibj41YUhEAIQ+hvEljA36vR3EuoG2YSppLRS4jiDRpD39a15sd90p0btSZ9VUG4O
         HhiO/qYCGDw/lsxdkGOmd8CA9G42r6EKEMJVN7dHlabcM4ekI335nf44gVPvDazvmSAe
         /qsyCfm2aAwzlg9MY4a6assytFtOvRPQjBbR7cJ88hif+jYFtprqFokQL25pEugjcoWe
         XnmflNJUxY3v83N/2lKHNTkjBFTLG97yfVPfB6fwut/3JVDsaq+FM9+oEc/RPGwZ0vmF
         5cXRKTeza/cnGEg+7awcUaPud+4zKtGrY8TOnY/9eFgCSjDTgvNYE3mxUb48etIEw4Ja
         UfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7jd78G4d5ZD0lDCvBRuLW/rYa/9HXjleQQwuOU/fiPw=;
        b=pkRgOLHHNUCMJEPWAOdWdWtdnUo5vhvZoqjzEWDl1Q2b794q2BB1eNfYdiLEQnPH8S
         9JD1mod2ZhPGOziV8aQ9FHc6sqK9lcJagHX8EeJYx6Jrtnte7km+ZW3c0/Pc9N3dUU73
         eiIgzpEWk38i/odcv35gn497JfLA3EzhjOwewgBdVK4F3d3l/yyifgrp19TMeeq3JZs/
         Vrpba0VlkrFRBGZwbBhMsnsZ1VbuSd7vNe5ufymrgFMWWNbKSduXtKhvopwdtun8EFsl
         Y22LQtC6Czkk89dDeSYIniG+T9TIg/hV5Z9OvJRZbMDtNgT2vpw5IVgh+BkZftRziStv
         Teow==
X-Gm-Message-State: ANoB5pmoalkmUO7MJhv2WhmLoGlCrzlf4LbPUUg2/5z6hYIMcnZZEau2
        ZfNgeuQMIp762cTvrfA+DvLMy2JHAeyCQuy5TLg=
X-Google-Smtp-Source: AA0mqf4Pl5riN/v882vsdxON9sLQ7RxmOLrN2tZLxRh5UvUbwkPZx9gfNkDPhe4UI7C6XoaGw8w916K596TGA/59f+s=
X-Received: by 2002:a05:6402:3485:b0:468:89dd:d326 with SMTP id
 v5-20020a056402348500b0046889ddd326mr12167892edc.352.1668936364795; Sun, 20
 Nov 2022 01:26:04 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com> <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
 <20221116162016.3392565-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221116162016.3392565-1-alexandr.lobakin@intel.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Sun, 20 Nov 2022 10:25:53 +0100
Message-ID: <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno mer 16 nov 2022 alle ore 17:21 Alexander Lobakin
<alexandr.lobakin@intel.com> ha scritto:
>
> From: Daniele Palmas <dnlplm@gmail.com>
> Date: Wed, 16 Nov 2022 16:19:48 +0100
>
> > Hello Alexander,
> >
> > Il giorno gio 10 nov 2022 alle ore 18:35 Alexander Lobakin
> > <alexandr.lobakin@intel.com> ha scritto:
> > >
> > > Do I get the whole logics correctly, you allocate a new big skb and
> > > just copy several frames into it, then send as one chunk once its
> > > size reaches the threshold? Plus linearize every skb to be able to
> > > do that... That's too much of overhead I'd say, just handle S/G and
> > > fraglists and make long trains of frags from them without copying
> > > anything?
> >
> > sorry for my question, for sure I'm lacking knowledge about this, but
> > I'm trying to understand how I can move forward.
> >
> > Suppose I'm able to build the aggregated block as a train of
> > fragments, then I have to send it to the underlying netdevice that, in
> > my scenario, is created by the qmi_wwan driver: I could be wrong, but
> > my understanding is that it does not support fragments.
> >
> > And, as far as I know, there's only another driver in mainline used
> > with rmnet (mhi_net) and that one also does not seem to support them
> > either.
> >
> > Does this mean that once I have the aggregated block through fragments
> > it should be converted to a single linear skb before sending?
>
> Ah okay, I've missed the fact it's only an intermediate layer and
> there's some real device behind it.
> If you make an skb with fragments and queue it up to a netdev which
> doesn't advertise %NETIF_F_SG, networking core will take care of
> this. It will then form a set of regular skbs and queue it for
> sending instead. Sure, there'll be some memcopies, but I can't say
> this implementation is better until some stats provided.
>
> And BTW, as Gal indirectly mentioned, those perf problems belong to
> the underlying device, e.g. qmi_wwan and so on, rmnet shouldn't do
> anything here.

Ok, so rmnet would only take care of qmap rx packets deaggregation and
qmi_wwan of the tx aggregation.

At a conceptual level, implementing tx aggregation in qmi_wwan for
passthrough mode could make sense, since the tx aggregation parameters
belong to the physical device and are shared among the virtual rmnet
netdevices, which can't have different aggr configurations if they
belong to the same physical device.

Bj=C3=B8rn, would this approach be ok for you?

Thanks,
Daniele

> So you could try implement aggregation there or
> whatever you'd like to pick. I'd try to read some specs first and
> see whether qmi_wwan HW is capable of S/G or whether some driver
> improvements for Tx could be done there.
>
> >
> > Thanks,
> > Daniele
>
> Thanks,
> Olek
