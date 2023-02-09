Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5705B6910E0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjBITBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBITBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:01:01 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2100.outbound.protection.outlook.com [40.107.14.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFE95C88B;
        Thu,  9 Feb 2023 11:00:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kwd0RyDu7oPTO0CXpqVFOgwZY/tqlRj9chHBba4t70P7zq+Dle+ryFXui9adfODXnNSavZT0EiYHUZC398HstqZSOBNaT7eLNtascCGQxzCcdf98NWztBVQ7hZnu9NpNUFCLdEYM9YlFtJ18eXXK7oa5vcuiKsNb60lqyJsZBjGqU37XMtFARwLw5fCaqsIn0B+W9s3jk5NuDR1sNyMqrVG7kvm0bYUq33XvEMMe/n5VXxMPvTQxIVyY2X+h+7NM90lcZpF5rcGkDJ3WeJZLo/8tQRE4Yqub6eqtGGyl63n1ygX8gcSumZ3phcI/ZQ7/E7e/4YSfo65N0HktJXf7fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOBs+sq83sqLEd/OlIYnnbySW32FSalfNn1M56CAnHw=;
 b=hObr3PuxRw7aeYC3myj5g2ceK8T4ZjuMC3E/AXkH0t6Y8h4AFLtu/KzNaTxKgrnRl9gd9vih5JSMnD0X5V5Do4Q2nZeir81Nh0CyB9UDl0kNV/MF1UxDAxLZNk+RXref89lYnqjupUHwgt0a2w/gmBClgSlGxEb01uhnSvLTC1TkT7WRS4bsTr4SwBnHNXVkqZXEhU7v83cyi8DnpH377lSQBb8XAoyRSRmuB319GYU/SWX0iQnuI781QYfxnR7xVGTWvt4Y0cRoQQmbIJyJTMoV3kcn474/bSkOWn3HgNcNE9rQyipDDOehTtGg4XvopNrvu02voXYc/rkF/I3t1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOBs+sq83sqLEd/OlIYnnbySW32FSalfNn1M56CAnHw=;
 b=tm2PEAV2yriHX7fK7rHHaX+KUV609z1wJO1VZcBCj+Ww2R/yObGHwRcPc7YgPUY2BGPuhXXjgIwAM6ZMIoSpDx1p7JT6q3/Nu1Nf50RNq+1dCaOSGbBHJJUZRDWWYacA6m31Nae9LhIwHRN5/dq991txLkdOX8pUzpNs4rglRv4=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 GV2PR03MB8849.eurprd03.prod.outlook.com (2603:10a6:150:b5::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Thu, 9 Feb 2023 19:00:54 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::e7f7:70e0:d33:df60]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::e7f7:70e0:d33:df60%5]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 19:00:54 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Thread-Topic: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Thread-Index: AQHZE/C1wQWkeZ5g50Kutho7W0eaTK52RcWAgAJmpACAAIPzAIAzK7iAgA+wfQCACz03gA==
Date:   Thu, 9 Feb 2023 19:00:54 +0000
Message-ID: <da0551556e42fd67c0b743d6d066fb09702571ef.camel@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
         <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
         <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
         <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
         <786db8fae65a2ed415b5dd0c3001b4dfc8c7112b.camel@esd.eu>
         <20230202152256.kc5xh4e4m6panumw@pengutronix.de>
In-Reply-To: <20230202152256.kc5xh4e4m6panumw@pengutronix.de>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|GV2PR03MB8849:EE_
x-ms-office365-filtering-correlation-id: 11ad1f43-7879-4673-30fa-08db0acff884
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jnHMWLnBoNbc5N9AlleEkvvqAYdYQ9Dd3DDQBovK/DnbwYOYLXdP4NdXAHcg9Lzt4olUehMmoLPnVq0Vu1DZJkwCY/G7HfbdoJRYbJ1CpbvmZTbveeuIg3f/AeEqY5KhMVi3aEDEsffcDYRIIrpqE/UfzkRlQpELG1SbXCs4+sWDJuWTmfwjU25rumJnvWbKVEL0rgw3rf72BFrouh6aBsRxPhe03b/ReOd4nWmgLtTuoWMc6jPzFp97FxkNOi0bWcNIasJtWau0Ta406QffZyNF4u5zfIAJ6RQ5mdCH4EGKvSX6QB2b1k+AUWO4rcfM7xNX/YyQvqf5NpkT1SBrFsOJC1DkKl0AepHjigOaRGYw81q0ScLIrQuUqvJSS9Pbz93Fx6F4hDAsY2J6CamdLSPt0AdLzkra2bfpoXz4dCv/Zho7uTBCWFiP1sQ58u/pdUDVq0B4TR2KuXr75TwA9hqL0Y3ENiGnqlvhxb9/cf51cuWaJaYwZUmeSLMgMeAH5N7MwDyGPQ2F9DiH20+Yi02zNHpJh/EgejDba5v87BRwRNuwL8SoPPoc5JN1bm+0CH0MUpIFBWnaaUpFkpehqUeonCuTh3vbtVvtLJVHPYWH3Si4+KWcybU8MwDBjaoMyeawBrzXUkllXkRey9EHr0/EINvGLpbfAsNe+r5fkdF1uOZTbtVHHbfWZjyp+UjkyA/6wwZ4PZoKE66SEIEE3bKhYJoE71ctF6funkbSJ0U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199018)(6506007)(86362001)(53546011)(5660300002)(186003)(26005)(66556008)(6512007)(2906002)(8936002)(4001150100001)(64756008)(66946007)(91956017)(66446008)(6916009)(76116006)(38070700005)(4326008)(66476007)(8676002)(38100700002)(122000001)(41300700001)(316002)(966005)(2616005)(478600001)(71200400001)(6486002)(54906003)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?fLySsPWJXtfRPrtfPH18trPT/shmPwd8ejtXKmcSXPLsA0HPVMxXkfd9g?=
 =?iso-8859-15?Q?aj42tc32FVOqwirdszIjRAcrhzwOM7frLr7Po0h1/n1TQSdQjugzDZqJ3?=
 =?iso-8859-15?Q?JZirkmGjfqTca5VO/Gy8hpHYs029P6yTR8iDHprteVSQUOYJsG/iX1s5m?=
 =?iso-8859-15?Q?rScWOAiCmfM34H/U45RgNfAkOhajPStJlRyRnI8z89N0JXk5GKnprwPOx?=
 =?iso-8859-15?Q?c5prkaiUo/VtyV/0jarRq6Q4XG3ERYolqx58rwWrQoIjLEXFZTSbNl/Wk?=
 =?iso-8859-15?Q?e1UjY4gc2w5J6+Edp767DQYm146BSqXRlTtUac6o7AGbtYGpAR7TmjPYZ?=
 =?iso-8859-15?Q?EFZSZi+WMzTioWlRh3vtPtwlOly3+WWcZNiHAD6K5uRxx4kHYCsqrK7Kt?=
 =?iso-8859-15?Q?KfdpVnZFRSlEhQCi3bcCBQ/AND8pN8e8s5/IsC58S2YYTgn7zvm+OiOQi?=
 =?iso-8859-15?Q?z+whiYdOGhNSBb0wtOQu19uVE2ziL6NFkWc4kKyUBo8pbxok/88cB/zXw?=
 =?iso-8859-15?Q?Or0v4hUeqJXDznb8Jzy67zTUDB7SyHV1LiPiiQladX78POQqwk2yRhF2L?=
 =?iso-8859-15?Q?ABgHSSZVh9rwYCS3pT9xTrfP8A3pE0ch15csOzSR7aCiRnwW1GGankuE2?=
 =?iso-8859-15?Q?9Frpjj1o8LymShahIbemaiJsH6ML5tpAjBLA7IXUGtsGeua1PSraAjBXx?=
 =?iso-8859-15?Q?DoHAT8vqiGuw/zZEfIFy45dpvcWVAlNc333z76TuB/bWYmjbu89NFYmnu?=
 =?iso-8859-15?Q?jZF8G8u/xeZMfTlOYNwNZyCEIHBNgq3ZMsBHtvLq04tTqtj7I2Vk1se9b?=
 =?iso-8859-15?Q?MKotNo8lySZ7vUsi/wUqzXk5UtqgiFsMhYoL+Jhd5Y/LI7AUtBZNReFCe?=
 =?iso-8859-15?Q?RMr81EKWj/F+nhUgzi1KcTb6ExHt9YB99fOVV+Fs4tUqhfF4ixchSFqef?=
 =?iso-8859-15?Q?TH+zh1Eg98nZ99sNqB3LCR91EQ/JpHgw5i7If8SI2BVvw//Om5jUNnzhx?=
 =?iso-8859-15?Q?dsGjl7/9KTiyk+nd7ERtx9RU/avS8h+cIJk7W8lpuOq72i88EShl8mtPa?=
 =?iso-8859-15?Q?Uxk0ocUu+ttr8/vuhjl15mFhulDMbV3duWV8lyUmJTh2siZyDWnNr8KWQ?=
 =?iso-8859-15?Q?3nFW49GfEmAahtdSsgJz2ChPh5woUWLmmZzonr6cd+EtiAQcMWA0jkt8T?=
 =?iso-8859-15?Q?5TJql80FH6wXSltJ4PTcmbcP/mgBVkGEo0aCAG1SoSkY7SXcoNq480CYr?=
 =?iso-8859-15?Q?T53MWJqDbsxJ2gfjAUkXGCH77vMEZmXykf2NWDgbk+s2EhDgwdcW6CWrw?=
 =?iso-8859-15?Q?KGZYSdpI4ulucgoW81Dz/YeHcpd9M5rDdc5/WZG9VuieD78BYULwsLUE+?=
 =?iso-8859-15?Q?JEtTfgSyPLGy48fo5i3ZVefqsy613fq+v/ZQh1jYE9O1mpqtenoqG9IQ1?=
 =?iso-8859-15?Q?1XQ2jG4DfEA794QZvNgoZ630Cq+rBWTjNQz0UcFFtUtt1cmAMLmkvaFTm?=
 =?iso-8859-15?Q?12eJdpeQoaXBTT5o/HT2jm1cqtv8XsS+jrUp85mSHIdceALdLAKszBBd1?=
 =?iso-8859-15?Q?BcL20dzCkhCo0FWIwRQ3WYElDn+RKnCuUPWqTE0dRu3C6bxUUlpAs3i+V?=
 =?iso-8859-15?Q?5dmqJDYyXDRi5eAUgsm7VXrq5YM8wg1efzyGMKEwo2fN3w17DuMZk1jls?=
 =?iso-8859-15?Q?YWSUUpxOc6KCdmrXeCTdr+nRog=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <5966396EBE316348893DDC92FAE8255E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ad1f43-7879-4673-30fa-08db0acff884
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 19:00:54.6821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvvOzh0aYKMKux4sLwfxyWRcr5tDmyllsoQFb9Pn6DhDyF0USlol7AyPImfEdrqRTnqgjJCu3UMTYIxFMofTBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 16:22 +0100, Marc Kleine-Budde wrote:
> On 23.01.2023 15:47:22, Frank Jungclaus wrote:
> > On Thu, 2022-12-22 at 11:21 +0900, Vincent MAILHOL wrote:
> > > On Thu. 22 Dec. 2022 at 03:42, Frank Jungclaus <Frank.Jungclaus@esd.e=
u> wrote:
> > > > On Tue, 2022-12-20 at 14:49 +0900, Vincent MAILHOL wrote:
> > > > > On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@e=
sd.eu> wrote:
> > > > > > Started a rework initiated by Vincents remarks "You should not =
report
> > > > > > the greatest of txerr and rxerr but the one which actually incr=
eased."
> > > > > > [1]
> > > > >=20
> > > > > I do not see this comment being addressed. You are still assignin=
g the
> > > > > flags depending on the highest value, not the one which actually
> > > > > changed.
> > > >=20
> > > >=20
> > > > Yes, I'm assigning depending on the highest value, but from my poin=
t of
> > > > view doing so is analogue to what is done by can_change_state().
> > >=20
> > > On the surface, it may look similar. But if you look into details,
> > > can_change_state() is only called when there is a change on enum
> > > can_state. enum can_state is the global state and does not
> > > differentiate the RX and TX.
> > >=20
> > > I will give an example. Imagine that:
> > >=20
> > >   - txerr is 128 (ERROR_PASSIVE)
> > >   - rxerr is 95 (ERROR_ACTIVE)
> > >=20
> > > Imagine that rxerr then increases to 96. If you call
> > > can_change_state() under this condition, the old state:
> > > can_priv->state is still equal to the new one: max(tx_state, rx_state=
)
> > > and you would get the oops message:
> > >=20
> > >   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/dev/=
dev.c#L100
> > >=20
> > > So can_change_state() is indeed correct because it excludes the case
> > > when the smallest err counter changed.
> > >=20
> > > > And
> > > > it should be fine, because e.g. my "case ESD_BUSSTATE_WARN:" is rea=
ched
> > > > exactly once while the transition from ERROR_ACTIVE to
> > > > ERROR_WARN. Than one of rec or tec is responsible for this
> > > > transition.
> > > > There is no second pass for "case ESD_BUSSTATE_WARN:"
> > > > when e.g. rec is already on WARN (or above) and now tec also reache=
s
> > > > WARN.
> > > > Man, this is even difficult to explain in German language ;)
> > >=20
> > > OK. This is new information. I agree that it should work. But I am
> > > still puzzled because the code doesn't make this limitation apparent.
> > >=20
> > > Also, as long as you have the rxerr and txerr value, you should still
> > > be able to set the correct flag by comparing the err counters instead
> > > of relying on your device events.
> > >=20
> >=20
> > I agree, this would be an option. But I dislike the fact that then
> > - beside the USB firmware - there is a second instance which decides on
> > the bus state. I'll send a reworked patch which makes use of
>                       ^^^^^^^^^^^^^^^^^^^^^
> > can_change_state(). Hopefully that will address your concerns ;)
> > This also will fix the imperfection, that our current code e.g. does
> > an error_warning++ when going back in direction of ERROR_ACTIVE ...
>=20
> Not taking this series, waiting for the reworked version.
>=20
> Marc
>=20
Marc, can I just send a reworked patch of [PATCH 2/3], let's say
with subject [PATCH v2 2/3] as a reply to this thread or should I
better resend the complete patch series as [PATCH v2 0/3] up to
[PATCH v2 3/3]?

Regards Frank
