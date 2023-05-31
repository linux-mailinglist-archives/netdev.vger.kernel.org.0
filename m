Return-Path: <netdev+bounces-6942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A925718EAF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EE0928160E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4876120697;
	Wed, 31 May 2023 22:43:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D2200B0
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:43:11 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F7512C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685572989; x=1717108989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iTfW6HVBIXcrlo0FOhBu3a3Wwdaetwhhvk+Pk1Q241M=;
  b=1rKY/o20eYmK+YQsn/lvQrnnQ7BAF7vLnl+nWSUou050uYGG/FLtvee1
   2aiGU06MiR24juzJOutdtzHgHxcOK80wQ6bvrxkyLVj5xpL0hRzlTYq3U
   0fwNgrS4Ks85nMWVMsbhYlzZumRVf9WocT8Oiik1zqPK0HQEZI+I2q39c
   M7K/63/BbB3pXDS8DGlF4L2xtTFW9XpwoH89kMxBLcw9Mj10laQDcOLHc
   lLNTrLEu4+ovOvVey70E02Lz3Y2mSPkTgfzHe5daw5k/15YNW4C+yjddb
   N0HrnEgUFIgQ241l3GI/j87Leof8Bga4KhhkKpoj4zlMQgQuYEr/dpPP6
   g==;
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="218261659"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2023 15:43:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 31 May 2023 15:43:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 31 May 2023 15:43:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFrpL0BJ+AcgD1eDMQSmnhPAS6sy/+zHL7HRH6GLNzYBqzMuCeM/4DjTkJI6XkvG5T0ia0/V2/oydZz77Tu27dRAiTS8qkpVTeMrIB3fdHnky5dqOD/JymHWCN7umLXzo2wH1Vz5w2NgyEHrvKfqgU6Z++Vi74yDlAhPF24PlXjqP7CdaGSN0EBsBdaOrebFMRayawS7Wbkr+OpVad+Gd6IpCJjHj/IBd3EaxSgGO7F3VDOK/Hg5cFFJ2jdHS+f+mgHQBYip2a6gPZm625Zi2pA827cyxgjPYgFqDWfOpJ6fSqEjnplGaNDlehVogNXfdG41Opq0SBRe2Ze2Gm2Uwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zl1WYL9R7khak8HDJthTyUSYLkQpT4TQRzTMCQC8WyQ=;
 b=KhroNqes3Yebmn1gejtjmpWO8gnN95ugXkRz5j4QmWNNc3DOGeUlZc9vB6NUjIiEHIEqu+w30rAF9dHCBa+PInHX8jRG6q950SOytgVMCINGa64GVpw+WoTMXDx28Azxuwz26zgGkFTgHQS93Ic+wfY9eULDQA2uVquVEeYoUn5fCfEbiZv01lTVk2qVBiMTUxKG+/QrQnCvWgXzV3q+umiNzAnSFt22GemRxtmMJ3tlQU8XdGHGAeBxEKlmy6sOJdtmXNUX0grXUbdkwZWDLiIgnPqpWpPnINeSxaROT6IfKu93xW38tYp8s0LOV1VnX5Gps0+3a5XDRUeXQJXltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zl1WYL9R7khak8HDJthTyUSYLkQpT4TQRzTMCQC8WyQ=;
 b=C80Ycdrg9jaXCOsyQZik2yPspEd9DlwirmPLIwlL6LM9hICe0iY6OSRwMFPG8nu2xmNmTJQhVowIv/JX2uUxeencpU9O3lDfQXnGJJCphiTncTEiW0R9eV85iR5VMVo1aLES1/k/Dpfat0+uqmXEaGr9Mg4IBir7rmTSk+mdtcs=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by IA0PR11MB7187.namprd11.prod.outlook.com (2603:10b6:208:441::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 22:43:02 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::449c:459f:8f5d:1e46]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::449c:459f:8f5d:1e46%6]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 22:43:01 +0000
From: <Tristram.Ha@microchip.com>
To: <andrew@lunn.ch>
CC: <davem@davemloft.net>, <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
	<UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Topic: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Index: AQHZkDwiffQVuCP3CUK1xQvBykSLHa9xWOWAgAOin9A=
Date: Wed, 31 May 2023 22:43:01 +0000
Message-ID: <BYAPR11MB35583CCCF0C908763B5BA5E3EC489@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
 <cd313489-603e-4d8e-a09d-22a0c492a3cd@lunn.ch>
In-Reply-To: <cd313489-603e-4d8e-a09d-22a0c492a3cd@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3558:EE_|IA0PR11MB7187:EE_
x-ms-office365-filtering-correlation-id: 26318d8d-ddab-4e66-6873-08db622863cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lG+loiKvaV2Km2KEYWJ59vvNeuP0vlv6rWSWJ5Bap/oSP10VomS7fyYRZp5B1uf49wfFS0Mziy2sQl+68LGIJRYy33zofAsCY5DN8B0YvlfWzY5qjgMFKQeN+fzYn+yKiDaPfjeHq8D5bvNcPvlBgWFqkbGD/pQDn16azNNK0yxKkY5XBnBfixDV/WiS0gH+1Qai6PWtl/vijGV3w0Ic9UmMS10yJCvOvE6TZNWDI9RUaMVspV/TpjdpjJSZqCAKa7w3ySVlaER3FpetvbrGFL1whOwKZZ9NI1W2B3HhswxKw1Ge1LdNVQC1FwIDbtAxE1cGPhW4tFX0bY+JVvN9HIPZ4Ls2/ETCII/kxjThIpXygvUMRUB9ImW0hft6vvnl5P26TBgwqlh5K/sSHh73OfB0x7vW3/+tisqDknUqLH3V3mQIms0Yq6T1dR/mt3NE33OYKKEp+dpnW5eWrz9EMWX3ex+ZfK9mmYzXbOVVelWzR3XxxhbssNK7kngVFJEvy9dIMGZzbMb6jRMujMxhnBZjg2vSAUDtv+Qc7iba6KzYwZjKbptQ5HLNYJfh3xZFSpSdnm0GLwU+B7AgMse1Q+qPZmzBEU1KadWj3BnCjp5DH9HJfq1ODfMq/Mm6NcpG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199021)(83380400001)(186003)(2906002)(64756008)(4326008)(6916009)(66946007)(66446008)(66476007)(76116006)(71200400001)(316002)(7696005)(66556008)(54906003)(478600001)(26005)(107886003)(6506007)(52536014)(5660300002)(9686003)(8676002)(41300700001)(8936002)(55016003)(38100700002)(122000001)(38070700005)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6eR0EQimrN03yD+ttTASW1ABdCR+8zz0aunrsKW+nSZWKiaWfPwsNf+aFBLM?=
 =?us-ascii?Q?gfSb/HpWT+FZWG/yH41x6Upb/ljDLXCAdxUKA6Ot1WQcejTHa+glwymqtIDi?=
 =?us-ascii?Q?aEcopg/N+Ncx5Jh9Wh/DEqIzPl8x5hZ5hPV6ABj1r9B8Qfma8atinww+bzi4?=
 =?us-ascii?Q?qDDp6aAJDqRz1Ed+oys+zsJSbd1reOXsZsOPngSqZ6KV4MUyuPMohMPt0Mus?=
 =?us-ascii?Q?Jcc+ErEQsNIuqx4251kCDqPHjSolZHOeR5p61nr114ds49tHN7EigcUChNK0?=
 =?us-ascii?Q?VYCF9q6HMgr7pTm7C3kWHhNlsukBzaF4EGPPrum4laCHpSuAb/2bxxrH3Ydp?=
 =?us-ascii?Q?JD9Iqy6+Xtz5QR2w5XtDyoHzF5NVbgIHvSezrftpeE4qbwcrBazXs/p5dZQ5?=
 =?us-ascii?Q?kk432HLsLMllizdPOYmjkqxcztTMv2C1ZZijFQkJtwo+HwaMavE8qV3p2II+?=
 =?us-ascii?Q?NSW63UKtx8ZWCtjKDsgOt2OkWoRfSdZCysXKDJ/JUiijgzMyjxul76ifDZXx?=
 =?us-ascii?Q?6hTzEhPZqu8LG3lshzlCQxd+igiaUcoMAYzdGSGzAVFhIm4bCae441pD9N6R?=
 =?us-ascii?Q?WSSMza1p2c79AZPI6VnunjJwdtQifUfjP31/eg5APovt0Tum9IH937eYsfvz?=
 =?us-ascii?Q?wIPOgbzWcUAJDm/FJtk57J2aNu3pANM3IPXbeLZlcklVa8z1xlHMfjzJV2Kr?=
 =?us-ascii?Q?5JonpKmUut6KdUSHxlfWixg2KJPRdYajgiOhoifDRHzD+0lxEMGSaB8cZs9f?=
 =?us-ascii?Q?GBC6XnU8qqF64FQP43Te2hVfGCX++WQZHWIh/RiDAWaYKJ327wUVcQNqqGUa?=
 =?us-ascii?Q?SEwbwN4vZ6aJaMKyeQt9RewUEpik7767GYvZYNFzWVjpwcxc3RSfjOk5ra8r?=
 =?us-ascii?Q?a1WfVxfLRN+6mCXl6wqPfmTtHNw614YvraPD/+C1exL9S0lfKwZKnLxBWiFC?=
 =?us-ascii?Q?w9j4XYs92X2DcgqK3ECtb7V8dinPvI/6pTWPl8fXat2RoI81jtKLBhH7K1Kv?=
 =?us-ascii?Q?bBhmY4J+JJK7QL5vshvRO+ZxBxVcQUWAhOPfQLAUMMESTrIyLIAAj3X/bk4s?=
 =?us-ascii?Q?zxu14f//0Ig/BEBHI5QCDkJw1D5CMlLPSgPMJWRw2ytrtbPG817HS7t1vDpF?=
 =?us-ascii?Q?Mbj6jBPUeajgVbvsOHRkeTMqwcGAw9dSrRX2+W01tHw2y8clAvNdFoIFbUQW?=
 =?us-ascii?Q?DLYmI2WDHH16AfUUtfYzDz6Up8PdMqLpoilhxqluYMeM6UOq3rLFz6iHSxCq?=
 =?us-ascii?Q?cUracYnxPOA8nx8mSJcUfdVPV7oJC49AQuxmxM0Vhwvsc0Pf127XmZHWWj8a?=
 =?us-ascii?Q?GSIDfcXTL+rHRAHCSrj1Lh6HKOYmgYkwtvDTNIItx1c6RGPj89Vz8I+SMTS5?=
 =?us-ascii?Q?wO+qdAfj/K3YiRYWOiCFz1nBCPzulZa0bOpiCcbKM45Woe0ItJJLYo3dOuwG?=
 =?us-ascii?Q?TS+W4oQPpJKJmtaafNigkZchR0CK8mRQtVUfD4ou5h8LUDn4b9GuZ20BZJL4?=
 =?us-ascii?Q?jhuTUcKr9OOXWyH+CAIIFidYDZ5G9dse6O/lXBzuFyyTy2hIMN+aqmPrqFiZ?=
 =?us-ascii?Q?a+nlQzYddFpWcXpXJb6pjd6eNmLjuRw5NZTUAQ4W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26318d8d-ddab-4e66-6873-08db622863cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 22:43:01.5563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qVMGXi1t9piHFHYYTZjthqXMdbxW1ZYGtWY8hnG2k/btShQwrPx5Bk7vxHiW6KUnG50RBYSAan8Q8RFaszSH+em1TJoO6mZFucvtaacSBbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7187
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to LAN8740/=
LAN8742
> PHYs.
>=20
> > +     if (wol->wolopts & WAKE_ARP) {
> > +             const u8 *ip_addr =3D
> > +                     ((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_add=
ress);
>=20
> I'm not sure this is safe. What happens when the interface only has an
> IPv6 address? Is ifa_list a NULL pointer? I really think you need to
> be using a core helper to get the IPv4 address.
>=20

This will be fixed with in_dev_get() and rcu_dereference().
Indeed the address will disappear when the link is down.
Why is that so?

> > +             const u16 mask[3] =3D { 0xF03F, 0x003F, 0x03C0 };
>=20
> Are there any endianness issues here? I've not looked at how mask is
> used, but if it is indicating which bytes in the pattern should be
> matched on, i guess endian does matter.

These values eventually are programmed into MMD registers.
There are 8 for 128-bit value.  Bit 0 in the last register is byte 0.
I do not see PHY register values are checked for endianness.

> > +             u8 pattern[42] =3D {
> > +                     0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
> > +                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +                     0x08, 0x06,
> > +                     0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
> > +                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +                     0x00, 0x00, 0x00, 0x00,
> > +                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +                     0x00, 0x00, 0x00, 0x00 };
>=20
>=20
> > +     if (wol->wolopts & WAKE_MCAST) {
> > +             u8 pattern[6] =3D { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };
> > +             u16 mask[1] =3D { 0x0007 };
> > +             u8 len =3D 3;
> > +
> > +             /* Try to match IPv6 Neighbor Solicitation. */
> > +             if (ndev->ip6_ptr) {
> > +                     struct list_head *addr_list =3D
> > +                             &ndev->ip6_ptr->addr_list;
> > +                     struct inet6_ifaddr *ifa;
> > +
> > +                     list_for_each_entry(ifa, addr_list, if_list) {
> > +                             if (ifa->scope =3D=3D IFA_LINK) {
> > +                                     memcpy(&pattern[3],
> > +                                            &ifa->addr.in6_u.u6_addr8[=
13],
> > +                                            3);
> > +                                     mask[0] =3D 0x003F;
> > +                                     len =3D 6;
> > +                                     break;
> > +                             }
> > +                     }
> > +             }
>=20
> From an architecture point of view, i don't think a PHY driver should
> be access these data structure directly. See if ipv6_get_lladdr() does
> what you need?

ipv6_get_lladdr() is not exported so cannot be used when building the
PHY driver as a module.
The WAKE_ARP and WAKE_MCAST code just want a regular IPv4 address
and an IPv6 address as shown by ifconfig command.
They are more like an example to show how the hardware pattern filtering
is done.

> > +     if (wol->wolopts & (WAKE_MAGIC | WAKE_UCAST)) {
> > +             const u8 *mac =3D (const u8 *)ndev->dev_addr;
> > +
> > +             if (!is_valid_ether_addr(mac))
> > +                     return -EINVAL;
>
> Is that possible? Does the hardware care?
>

Removed.


