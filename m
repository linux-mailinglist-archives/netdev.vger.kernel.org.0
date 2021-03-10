Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7D3338BA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCJJ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhCJJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:29:11 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3CEC06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:29:11 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 18so32285238lff.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6yh80nQY40PbFt2IsESnkkLcKsJBSUQZxo/JQ9QxsTA=;
        b=DU89UfxXTESbvMybzt6TEwNod+QBpRbX2013U9r+zAeCVQVU4HFJbXuBph3SfxO8jV
         cZZN2cYT7YP8b0Ya06tkHgi2VatO2DNAtE7sNZFGc8pZS+r6IkJUHVIjnqOSC2mUiQXo
         Ybq2TQ8ytMdZOwtocOGIz+krvtv+1GA7ArqmCPjFMQKPg+nf0bwcW9g++R9mKkLdicgM
         /jhKqPPJ8WBTGwMwVsflx79Yh+IosQWOCAoH37Kb86f0X3WG6feg3GR1pateauTqPkEo
         Slcd+DQLo+HX4Rg7WO6Pnyhdb5Al6WR1SmnxzlVT3OvBAUB+1sY0Y3nUt678KgOOg/wR
         qQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6yh80nQY40PbFt2IsESnkkLcKsJBSUQZxo/JQ9QxsTA=;
        b=lUYr1H+4yzrkmC0mPaycoE8+vdi6NXCwcApDliPAYMpJ6ESzrTShMsGf7WpzqakprM
         YGsY/fEcgxL0hUdeF5IrR8Xl2STc4EN/6oQ1TJ8qzj1Fxc35+xncVyjZ695zJEFLviGb
         KaiyMjEw1JZwFr/Y/nXQu6mW32iPDvlLmuYzPUoqvqCYjdE4aTenAZ5aDllXIEavDFnU
         WLugrF1JfCf8ZUNGrtO22A4VgqWdFDmcTEwleVTYp5BcdT+D0xUHTymFmCr5sRAkqpGA
         eWDXExs/X+PI/gaYE3eNYSd/HNW6v7Ed45zYAH9HQhcObtwY8iqa+oMh5aEGfePLd12k
         /p/Q==
X-Gm-Message-State: AOAM530ru7q1Mf1UrhWgZR2uXkuIcykGR87J09eEH7m20h966g1+XBKi
        8HLhiUfx2ZxLlhBjnGP4ubNyFX1jNib+Dx4aXaE=
X-Google-Smtp-Source: ABdhPJyR2zFVXwJiFMofqzwKbAODSxg1+8apOsI8hJGvv8neGcqvdJ+EpOGbBK077rbnUIGq0rjOQGV4tTln2tso0+A=
X-Received: by 2002:a05:6512:991:: with SMTP id w17mr1539185lft.85.1615368549856;
 Wed, 10 Mar 2021 01:29:09 -0800 (PST)
MIME-Version: 1.0
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
 <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com> <CANS1P8EHJ+ZSZT8MT43PzXH6bhZ6FVhrQ_sxxFWbWTvzyT+3rA@mail.gmail.com>
 <BY5PR12MB4322F7A218F0C0D2BBF99EF1DC929@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322F7A218F0C0D2BBF99EF1DC929@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   ze wang <wangze712@gmail.com>
Date:   Wed, 10 Mar 2021 17:28:58 +0800
Message-ID: <CANS1P8ENKYGnRk44P7bT4fC4aZtfsdyPJ8hOv0CV9eXig03gJA@mail.gmail.com>
Subject: Re: mlx5 sub function issue
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav,
      Thanks for your help. I did enabled VFs, and after turning off
SR-IOV, it works.
Now the each PF can create 255 SFs, which is probably enough for us.
Is it convenient
to reveal how many SFs can be created at most?

Ze Wang

Parav Pandit <parav@nvidia.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=889=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=888:36=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Ze Wang,
>
> > From: ze wang <wangze712@gmail.com>
> > Sent: Tuesday, March 9, 2021 8:34 AM
> >
> > Hi David,
> >       I can see that the variable settings are in effect=EF=BC=9A
> > # mlxconfig -d b3:00.0 s PF_BAR2_ENABLE=3D0 PER_PF_NUM_SF=3D1
> > PF_SF_BAR_SIZE=3D8 # mlxconfig -d b3:00.0 s PER_PF_NUM_SF=3D1
> > PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=3D8 # mlxconfig -d b3:00.1 s
> > PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=3D8
> >
> > after cold reboot:
> > # mlxconfig -d b3:00.0 q|grep BAR
> > PF_BAR2_ENABLE                           False(0)
> > # mlxconfig -d b3:00.0 q|grep SF
> > Description:    ConnectX-6 Dx EN adapter card; 25GbE; Dual-port SFP28;
> > PCIe 4.0 x8; Crypto and Secure Boot
> >          PER_PF_NUM_SF                   True(1)
> >          PF_TOTAL_SF                         192
> >          PF_SF_BAR_SIZE                   8
> > # mlxconfig -d b3:00.1 q|grep SF
> > Description:    ConnectX-6 Dx EN adapter card; 25GbE; Dual-port SFP28;
> > PCIe 4.0 x8; Crypto and Secure Boot
> >          PER_PF_NUM_SF                  True(1)
> >          PF_TOTAL_SF                        192
> >          PF_SF_BAR_SIZE                  8
> >
> > I tried to create as many SF as possible, then I found each PF can crea=
te up to
> > 132 SFs. I want to confirm the maximum number of SFs that
> > CX6 can create. If the mft version is correct, can I think that CX6 can=
 create up
> > to 132 SFs per PF?
> Do  you have VFs enabled on the system? mlxconfig -d b3:00.0 q | grep VF
> If so, please disable SRIOV.
>
> >
> > David Ahern <dsahern@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=888=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8811:48=E5=86=99=E9=81=93
> > =EF=BC=9A
> > >
> > > On 3/8/21 12:21 AM, ze wang wrote:
> > > > mlxconfig tool from mft tools version 4.16.52 or higher to set numb=
er of
> > SF.
> > > >
> > > > mlxconfig -d b3:00.0  PF_BAR2_ENABLE=3D0 PER_PF_NUM_SF=3D1
> > > > PF_SF_BAR_SIZE=3D8 mlxconfig -d b3:00.0  PER_PF_NUM_SF=3D1
> > > > PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=3D8 mlxconfig -d b3:00.1
> > > > PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=3D8
> > > >
> > > > Cold reboot power cycle of the system as this changes the BAR size
> > > > in device
> > > >
> > >
> > > Is that capability going to be added to devlink?
