Return-Path: <netdev+bounces-1588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4F86FE65A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4655B1C20E29
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08581D2D8;
	Wed, 10 May 2023 21:34:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055521CC1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:34:55 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E25171E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:34:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f13d8f74abso8767996e87.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20221208.gappssmtp.com; s=20221208; t=1683754491; x=1686346491;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4rW3QimZ81wVbkQjNuUdZDDjEpRn2AG4LuA/Nl1pMGs=;
        b=zu+JrSYtLvi+Mwz8sm/tNOSTa4sVuFI8B3DRh3ooQ6El2xocAIeTy8UGhdBIyknwpu
         V6rKK18rbVhx+sAvOz+0MmkSZUUyu51Onw97BLZOKvaIYIiyMncYhmitalMIub/6dzvs
         o7MBAgzF8q8BzHQu0S3/y/KmzJQMnF2nK94BerkQd3NdbR10bJWSOiA8+mDpIWzZ2Bvd
         DTG7TXcZOXY7MoNcIh7vhrtEaP37zs5yd9xpQov6yhIDPqb66pxA23imMghbxCdOYej0
         wHuPYJjCo2ez/LP+ZOrKypCxZAnG188rIt/cDHG/JLiiQKR3pb2pF79+hpwbRJF4Tsk5
         Q15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683754491; x=1686346491;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4rW3QimZ81wVbkQjNuUdZDDjEpRn2AG4LuA/Nl1pMGs=;
        b=j4X03vpFD8SkkrdqD8Wbd1nUvLdheP7Dyf5Cy3DZSTKyK2c+1wsr3SOptWEiVaAUxu
         b1CZppCT7GFuVgrPZKgJSFFBZHYTtvJAYGqiV5e8r6HOYoxI8HKD1vhay+TBHYPlrx2u
         pVIb7qFPC++QP43I5rbTOLqF7GpNMsTtWZF4+cwtTsTBzn/FQn4srdDDiUfUKlo1wOn4
         xmH6+2svO29nmjyCsBAfLYz6hkWCjrdME3L3+y+1SAwT1HMs4djhN7nb9Frsvbj4WPhL
         UBUIGUT3Y7E3GesOMU5FvOwHC9aOTwX6WWVHV2KRRhTC9sOznvFMs4w+243ousiuv/Mu
         PjwQ==
X-Gm-Message-State: AC+VfDwLF+iFek6vy1ePew6Hxw0adOTpFzvF9SN8XqkF9ZiUh3Jkn8Vp
	vuNh95wofNPvdwE8E3eF4Q6NViHHBKgejSoRVjA=
X-Google-Smtp-Source: ACHHUZ4pTblppGTXNFhs4vyvYVeDydVDN6gkd1FFJGTHkxLH3fp8GMYk3LqB2wb4wujBeR4Inrq5Uw==
X-Received: by 2002:ac2:42d1:0:b0:4e8:c5d:42a5 with SMTP id n17-20020ac242d1000000b004e80c5d42a5mr2108550lfl.24.1683754491427;
        Wed, 10 May 2023 14:34:51 -0700 (PDT)
Received: from wkz-x13 (h-176-10-137-178.NA.cust.bahnhof.se. [176.10.137.178])
        by smtp.gmail.com with ESMTPSA id r10-20020ac252aa000000b004b6f00832cesm855835lfm.166.2023.05.10.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 14:34:50 -0700 (PDT)
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Steffen =?utf-8?Q?B=C3=A4tz?=
 <steffen@innosonix.de>, netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
In-Reply-To: <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
Date: Wed, 10 May 2023 23:34:49 +0200
Message-ID: <87pm77dg5i.fsf@waldekranz.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Hi Fabio,

On ons, maj 10, 2023 at 11:05, Fabio Estevam <festevam@gmail.com> wrote:
> On Fri, May 5, 2023 at 10:02=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrot=
e:
>
>> I'm not too familiar with all this VLAN stuff. So i could be telling
>> your wrong information.... 'self' is also importing in way's i don't
>> really understand. Vladimir and Tobias are the experts here.
>
> Vladimir and Tobias,
>
> Would you have any suggestions as to how to allow PTP multicast to be
> forwarded when
> vlan_filtering is active?

If possible, could you install mdio-tools and paste the output of `mvls`
on your board from the two configurations above?

Unfortunately, you will have to patch it to support your device. Based
on a quick view of the datasheet, this should probably work:

diff --git a/src/mvls/mvls.c b/src/mvls/mvls.c
index 3ced04a..d4442c9 100644
--- a/src/mvls/mvls.c
+++ b/src/mvls/mvls.c
@@ -195,6 +195,16 @@ const struct chip chips[] =3D {
                .family =3D &opal_family,
                .n_ports =3D 11,
        },
+       {
+               .id =3D "Marvell 88E6320",
+               .family =3D &opal_family,
+               .n_ports =3D 7,
+       },
+       {
+               .id =3D "Marvell 88E6321",
+               .family =3D &opal_family,
+               .n_ports =3D 7,
+       },
        {
                .id =3D "Marvell 88E6352",
                .family =3D &opal_family,

