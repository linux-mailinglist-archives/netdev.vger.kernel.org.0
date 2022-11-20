Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE61D631340
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKTJwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKTJwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:52:40 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE7612752
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:52:38 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ft34so22506857ejc.12
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoM1VQAq7h1PK02LIY6g7IAXTRa5gsCiiA/BW+WTdpc=;
        b=AfEI2NF/BedyRtTllBFcKajF/GmCC/RYrLyQGJ+5Kw6Ymtz7d3pxBSNiF25ON2yoB+
         Obj9iLh/YOSyJDzqH1rZiH9bqIzYKN52QWU8VAjQvI84di+4XGdm6ADBxCs/Y0lYWCLW
         /Asr2AkRsbyEV2rbiZKNELO/glFIlWivfG0TdhOnCqemG/UDtFnVwuZgJp54vyZJx4k0
         6gSw1WVad3/B6g2wM6F6s6P0/HQSjC9MAIUnG44ZtCXwkdt0CYwzXWLH8yOSVp7uQtp/
         zNGUC0xspOB85fzFUhkmwWxPSjLUy/+xvNNSDOYgpbX4ipROsYIaU2KyAttfGgS4PGFJ
         t8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoM1VQAq7h1PK02LIY6g7IAXTRa5gsCiiA/BW+WTdpc=;
        b=I9GraE7iOsg2iGTF+eJi0AbWG4nCBy/4SC6LqsDuWfHQEgMzyAxQ9FWutvn3lVxZQc
         P1qkC1YOqIYQbeVMINcUZeEDR8gEak57NQx7Qr53Gi+kgsgA3iiM71FMq9vbe0ZJb/k3
         3V3/G7lK/wCv8vIylcw2uP5DOOPWzcHH4/nmACJl34hlYYNo5ABZlkQKfiE+75mAq66o
         F6aXzM3FThokdHMQiqGcgSGOHg7dhTpe0gRdNFdSM4IY6y+Uvu1XL0DcKDmR3lwmOMp8
         tRJnikfMZs+nMfg19UE/vRTs85sPi+ipf34KMau7Pc8UeLde0bwV/xwoEBnbWT5QylWb
         SsLw==
X-Gm-Message-State: ANoB5pk9KFH5Thl7zbozpY9Wef1XvG4uTxlixiXeZs2mGoe4h1gc8vRm
        bcYCDcHpiH9esVbyz+txH8+seYcTjPhD9H0GOyo=
X-Google-Smtp-Source: AA0mqf7T0Wdp8jYQHjjcUK5s+3X/Nu0tgegBbMiYh2m+lQI4x1UNv941RRLSjXpgZ8cR1d9RKRAIvZadJteofoMYCSk=
X-Received: by 2002:a17:906:ce4a:b0:7ae:5ad1:e834 with SMTP id
 se10-20020a170906ce4a00b007ae5ad1e834mr11643438ejb.312.1668937957253; Sun, 20
 Nov 2022 01:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com> <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
 <20221116162016.3392565-1-alexandr.lobakin@intel.com> <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
 <87tu2unewg.fsf@miraculix.mork.no>
In-Reply-To: <87tu2unewg.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Sun, 20 Nov 2022 10:52:26 +0100
Message-ID: <CAGRyCJFnh8iXBCyzNxzxSp9PBCDxXYDVOfeyojNBGnFtNWniLw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
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

Il giorno dom 20 nov 2022 alle ore 10:39 Bj=C3=B8rn Mork <bjorn@mork.no> ha=
 scritto:
>
> Daniele Palmas <dnlplm@gmail.com> writes:
>
> > Ok, so rmnet would only take care of qmap rx packets deaggregation and
> > qmi_wwan of the tx aggregation.
> >
> > At a conceptual level, implementing tx aggregation in qmi_wwan for
> > passthrough mode could make sense, since the tx aggregation parameters
> > belong to the physical device and are shared among the virtual rmnet
> > netdevices, which can't have different aggr configurations if they
> > belong to the same physical device.
> >
> > Bj=C3=B8rn, would this approach be ok for you?
>
> Sounds good to me, if this can be done within the userspace API
> restrictions we've been through.
>
> I assume it's possible to make this Just Work(tm) in qmi_wwan
> passthrough mode?  I do not think we want any solution where the user
> will have to configure both qmi_wwan and rmnet to make things work
> properly.
>

Yes, I think so: the ethtool configurations would apply to the
qmi_wwan netdevice so that nothing should be done on the rmnet side.

Regards,
Daniele
