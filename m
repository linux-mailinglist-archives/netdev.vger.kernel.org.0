Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004DE51460F
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357058AbiD2J5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345976AbiD2J5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:57:31 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130057.outbound.protection.outlook.com [40.107.13.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664973F319;
        Fri, 29 Apr 2022 02:54:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUBJs1fPk9DKXhXv4zjqcC8XF++EoptxQWxcF7LlrKGoGAg4aYJ/YrV29u/z43a7zE4x/uWa9vkEMnCpYNDhCOD0Y3kc2eUBwTi9rC+lhootpKikLGj5Gf1Kg8C7oUQ+GowKyWzV55n7y36KVjv3BeTCeZPhim4dXqhRApuQdFMbOnHs3z9+X4hMaOfLxxntdr8aG8VYaCSeBkJ/ZRpYjo6w3tL6YRCvwRjOgcb01FRZDarKbrsqIL4EylNru8EvHQ9FSaThyNBt0hB88i2G2z44sOck38spaBsZzVhylj8h1op57z+LSgU5EchSPB55uw2Vz14livnL5MTG6w1y1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdL+SIRl+htSjUrr5RLD+4UtXCDCUCraxX0TKpNkNi8=;
 b=HaXz/QD90Nb8yMtlfMothZe7JTt15iRM3EuLtrKdc+mJrHVWj3LJp8RY+ceIPhYPbgy8qAv5rkaupFjncZ/cFCH26VMs0Pfq27oIQEoaBBUDobScfjhRaH+SHk8Sfi4o4N2pHEIw6iYg9cnRhdwIl1FJ8mTtlM6xf1l+ldNXKmAGynP0bKFEcnQc4i1f5oQwLaPAaqCFQj7pZ9wzFcPbex1Sszd52BFQm3xkEXJF6Br6V9wi6mx+JM8jzyxrDCxxuqWuzuChbw/74We9EiatT67dsRhwcCbAzH/RteDq9iPM1wlo/g1VfD6ujuwEdC+lbtXpdScygShEdOeMSRuhsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdL+SIRl+htSjUrr5RLD+4UtXCDCUCraxX0TKpNkNi8=;
 b=kgWvfAJWF09MpCdNh/R+V8U6MmbrKylfpah0DNMh4bAoONLDCWvlqTdq+Un/jAs8P9RvlwMMBroEDf2xg+JUGRFWpYo+1WQFJu8NrzK+OO83RIQqUqDEM6DDxXaN0mJuKw222bIZoCWV+WSi4dn7PR58LBuhRjurJGKv+IMOlow=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7019.eurprd04.prod.outlook.com (2603:10a6:10:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Fri, 29 Apr
 2022 09:54:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 09:54:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Thread-Topic: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Thread-Index: AQHYSey/rjYFxWFs6ECKeXXw010xTqzmJwaAgCCOMACAABUWAA==
Date:   Fri, 29 Apr 2022 09:54:11 +0000
Message-ID: <20220429095410.iewnssn3gookhi2y@skbuf>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
 <20220408152929.4zd2mclusdpazclv@skbuf> <YmukEb1gyBKXIDUP@kroah.com>
In-Reply-To: <YmukEb1gyBKXIDUP@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23864f70-b1d3-4415-c325-08da29c6363f
x-ms-traffictypediagnostic: DB8PR04MB7019:EE_
x-microsoft-antispam-prvs: <DB8PR04MB701977CCFFD78738EF4247A2E0FC9@DB8PR04MB7019.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OqOr1JubJGv2RxgCs3ilT29P0716Og7Dlsq2n6r2t6mPAQkqPTQ/Ns8rQ6v3atEAXWTeanvYgb2qjD81WZXsOIRdRwdDb7nZXoLTWMKuE6Y+T0L1WMaKzRwmNTNjSKah9jz7xommof+bDvU2+PL30XZq7kvU3uj4HhPMkxjLjLPpNjXcwUfw0Dg4xCeuMSzNNyRcwOOHaRyZHyka1Is+PlXbjFueHy6Rld5bFoqMW5qAP1BmdDAhc2O6dFiaFa2DDoYm6stotwaZG2FhPOezegsgL5Bksp/W52mS8FvQNzy3R+M6D7dfnMnREnNQCcLN8gv/Trh1elBRqWNkMJp1qbFioImDthc039P7PMdJ1lYidLwrV17ubtjb098/olYQlNh0tqjgkgdKsUdw7eDed+dmVjChi57sdlq9cXUoXGvCowpniMGVdZGDL0HOfRXtL4Wr0dazhf4YR+3vWjbnXvfsC/T1aU+w0RnBMJw7BSWbO5PECiSXWs7ixXtCPQ9g2Qf5+VmF8uLQ5WZ70QpmAMy15GykPzBn9JOXCKHg0EU9SZOexZE9+yLfWR88vLjizlVPUgLRaiFSSuJ7ZbvQVebINEMb4jXkK0GP56cDDleZmJjW9GT0Y0GMooP5KhW/lNs+0CRXGeFx2O+vzafFHKcQ7V1+QQc5Zze3t6bJgAuFWbGdHinnn7XEgl7zwTFYEik8zNw86tJB8Z52Q/o37NKtS3NmE4g5fJIWOmyTJ82QyVRYkICZGqKWXFn7LqHE9L3wnJ5usM6191euScZRdGMdCW6qUgTmu9lUh2+jzayihRqCMN98CFRyY3ZWRUPK/0XnM3Nmarcy795RVKf0Lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(5660300002)(8936002)(1076003)(966005)(6486002)(2906002)(44832011)(122000001)(7416002)(508600001)(38070700005)(83380400001)(38100700002)(66946007)(66476007)(66556008)(4326008)(8676002)(33716001)(316002)(66446008)(91956017)(64756008)(76116006)(186003)(6506007)(54906003)(6916009)(71200400001)(9686003)(6512007)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i0zU2zYpAb+/CWEvcLk0SxBKbvxlPLFuTehTmCHcQFszvsCFD3pW8jbGVide?=
 =?us-ascii?Q?5TxvaAbAQ7b7gO3RPstILsm6UdF3Yta8jlOcZQK6qCOQ0BQlR0CT/r6MeD6W?=
 =?us-ascii?Q?MMNjkvBNq/avHmszsT6Jh36vCO0cOwFiwbknextAf3SWXpMVlZ41hJNq+tIn?=
 =?us-ascii?Q?UKFpALN75IEVU1zgG3TGxW62HJjgv0j1qXSN0Je1BGCsvOBEHms5GHzbr0CY?=
 =?us-ascii?Q?GFU0+ksC6drLxZi8YcASuOwWjKBZLKIYTFBZfzjNfyDvWOJnj4KpJ/loKRES?=
 =?us-ascii?Q?Oc+73YmBMNxnT1REiQzpzGfqCB8msvIrrPS4d04sOBiARqucrS8IgDw5SaMI?=
 =?us-ascii?Q?sQw6G0/JmHOxWbmZrkx7XwRoOJo4DYRXSZYUMLfO+GdABGsFYJw6PCqEY4gm?=
 =?us-ascii?Q?AZXX1Fr8KUUCRZkYVdR0bMV2eVxsp7GWIaelrEvG7Vy2MeYZ94sHKAHA5tJI?=
 =?us-ascii?Q?Z89Xf6E6wQfOoYQqBmaoUaTucHcY/tD/pXEekphxNnZtdWtRmtiV8irOoyVt?=
 =?us-ascii?Q?syv02uHJFjStdyVsgyJaahmrbSiXOFyQEPUKqrIiM+jM7WvWYK5QJSHe0xJa?=
 =?us-ascii?Q?NciZa8BRfQuHbMGtxS/TcbkcSrTtoUhv4JcpIXMzo/jKCe4J8wk5YsXAvxYt?=
 =?us-ascii?Q?hDQj4uEcPD+SgBkX5PYyWRN+txpX4ZWlWw9ASr+S0AH50SKmQEseYo1oIeKt?=
 =?us-ascii?Q?RXGRohoaK7DxScvCGb6rcIgtCmW5I7a6dDKhC60y8KoTE3gjxLJc+vkpr+Hs?=
 =?us-ascii?Q?L9f48WMPDwBHL0DcwNxkYhWt4LQRgY6jXii234EtQ/E5Ydy7VnhsF4b9KrrQ?=
 =?us-ascii?Q?fUw1aVYE/UtkLACVrV+4dh6L1eF/NCPSz8SGGklmsUlCsQ/ggVO81IMqnRHm?=
 =?us-ascii?Q?YfCXjDrL7zNS/8UBklsqrEzAdjovgm79xK4qYseE7QrEmM6JvycRIhQDwoIG?=
 =?us-ascii?Q?/kKq5p9JbiFmtNkSRZ8QFjoJ7LCwVLl3q2+Y+YZ9W7sqdvC37kC6BXxPGQ7j?=
 =?us-ascii?Q?oqNcvkJcih6bNmXXp0caCdL+nTcI1cRNOXpE/0xXCKAEmkARYIoRd/pT7w2X?=
 =?us-ascii?Q?iLyLE7ZoSzDYrbYgHJMCF9Mn52kFT1Qn4hrU2wnX2kkcYEzyDyMWwymtYgO7?=
 =?us-ascii?Q?5XEnwc5KeRX0QOsqYZaTeY5yGwy8Yr7tAbbTui6DFlXss1bv0HPjH+yobt3M?=
 =?us-ascii?Q?3DsvZPJVKUYz0m1iEShmZZltvky8pCCQm0xVx58D6YQ+RDCO9l1OZfWdoVA9?=
 =?us-ascii?Q?d5lDqHR5dM954RrAWCicHHJCsYZ/pDwrOXWJnscFvo6P6VVSDS8D0penLqrM?=
 =?us-ascii?Q?VlYUoVbc+ZBCnXRIWVwYCfmKZ6Kfb9m18r3JsfTW3+vp9PXP0j8hcpF9Z/QM?=
 =?us-ascii?Q?hFa6d5KJA3W2QW9o0w201KX8drRs4gsBN9kXWjAO3TLVOib+FfolwbKXDUIi?=
 =?us-ascii?Q?rT7wOiIKo9cFCeQ7EaTgdZwJK5HXCPUakZKYxI4+49EBqMD+mZPTGYzFgDT1?=
 =?us-ascii?Q?E74EFoPwBZQMFEczyfOHx7iHyHjJJzmgMEO+6AYzT3iJ1WpegbcyLemKd24d?=
 =?us-ascii?Q?5LGgS2AAeDgek62qZG5dOOcld+jzPUUaklN43cxeHfvDdrSeMOBEHKDvRDcK?=
 =?us-ascii?Q?l77Mpv/EEnyf/OKOTlhpj7YMCOJQReiPRVCpKBRmKDG389vfGWejHTb66frd?=
 =?us-ascii?Q?x0sIttIOqMUyncSCTaG+RMzN1t6vB845EqRDUa2vD7ZYxV/bQqjkRMton+ya?=
 =?us-ascii?Q?zVVskKd8h7hDAeSJJS8slZdR5npLlpc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4F3E22A53D39048A02E610E9F45D379@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23864f70-b1d3-4415-c325-08da29c6363f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 09:54:11.6445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1zIFfmgL175oqLVcsWMyr+nCss4vPFhB1qpPELnD6f6mGMTIXYvxK3kNNsIBvIiRZz3x37/mOgHsBhNQ7+RTpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7019
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 10:38:42AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Apr 08, 2022 at 03:29:30PM +0000, Vladimir Oltean wrote:
> > Hello Greg, Sasha,
> >=20
> > On Wed, Apr 06, 2022 at 10:29:53PM +0300, Vladimir Oltean wrote:
> > > As discussed with Willem here:
> > > https://lore.kernel.org/netdev/CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0=
C3rKMzGgcPc6A@mail.gmail.com/T/
> > >=20
> > > the kernel silently doesn't act upon the SOF_TIMESTAMPING_OPT_ID sock=
et
> > > option in several cases on older kernels, yet user space has no way t=
o
> > > find out about this, practically resulting in broken functionality.
> > >=20
> > > This patch set backports the support towards linux-4.14.y and linux-4=
.19.y,
> > > which fixes the issue described above by simply making the kernel act
> > > upon SOF_TIMESTAMPING_OPT_ID as expected.
> > >=20
> > > Testing was done with the most recent (not the vintage-correct one)
> > > kselftest script at:
> > > tools/testing/selftests/networking/timestamping/txtimestamp.sh
> > > with the message "OK. All tests passed".
> >=20
> > Could you please pick up these backports for "stable"? Thanks.
>=20
> Do you not already see these in a released kernel?  If not, please
> resubmit what is missing as I think they are all there...

They're there, thanks.
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.14.y&id=3Dadd668be8f5e53f4471a075edaa70a7cb85fd036
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.14.y&id=3Da96c57a72f477b42ab238fad3c2c1f8e8c091256
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.19.y&id=3Dcd7295d0bea3f56a3f024f1b22d50a0f3fc727f1=
