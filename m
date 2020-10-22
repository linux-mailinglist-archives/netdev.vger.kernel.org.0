Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8D1295D22
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896808AbgJVLDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:03:41 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:18752 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2443221AbgJVLDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:03:41 -0400
X-Greylist: delayed 2011 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2020 07:03:40 EDT
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MATQtd015340;
        Thu, 22 Oct 2020 03:29:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Hlxo1EQRm6bPj+EzLOfc5c8T9eaguqn7eH+B7jwwCww=;
 b=UZWcoknhObXe85r0Pcu22/7nAbquZuBLW90psTmGp+Ks+yiMWXCqaXrhLN8K3a7ZteOu
 IFnDXkCeondYT7Cqz05BsP22WeW16aM01M6A+NFnVZUj42RahDwSkx9hOUAyKY5VIfHG
 dUic8rX7j7uhgxkXYCkxS4VoPb0K1FmFVq7rxAZfwKuUBcgOocMBn+mI6tgisKjmUBid
 mgbYQk/B3C0aeeGGSm0dstKkm19KuGAsO963RO5+DRBhw9kUGNzxNfYPcX9rBWK27iLY
 m/qEGG9hX+L+PgSR7oqejFpXGMT54ax23Ndrsd/Q+EPus4ed1J0j++BUpG0CLefWZe+i yA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0b-0014ca01.pphosted.com with ESMTP id 347v6ykww7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 03:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4KcY1uzxeSQakZ6TTEDJwi3mQHAnbDJzyIwsp7NpgYQL0pRkyODjC4P27IwMDh1DZ+B/3am6BHNE6LAHBwqdlN40+QO9H/dEpoyVIsNNms7a5Yn49wlHgfEPidw2XdLvKwn4KtBp0iORYrK5+4dwl863oxOC5ayEBqN+uqD5soswmEtoLktHytoY/8NFwbRq53+McKWXrNsgj2EgV5cza0ULW2YbqkHwzwlggjmDgZ/6GRo4OrU3i/0iRb+WBfGuLHrsBF9pfIelC/GoMBQD8feRZg88rGOUgSBNLvyURQsAGuostJNrqZHpj4q3FZofBPIS9FNFRFky8v0B1rqlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hlxo1EQRm6bPj+EzLOfc5c8T9eaguqn7eH+B7jwwCww=;
 b=TNhrw1wsTpKay4pS459EDgdEoThF4JX7tMUTJsp8ow9Bl+MmwBxRrqGCrpnJPECw/4KQNAdeZdP9/aHuUx59DcLtggiDPBs1TGYDyhVdFkQyugttCJNtyxy0VNJv7EbYnxk+Skm2kC02klPvEq2E72L8SQ26gbafwQPNrwZm4y74Gfx+5b6bqPWwlftsd3Xst+yuHYoCs6vxf8UtgLCgJnuOHSIPpBh8aPa9ojXIzaOmPHwq1h+zEjIkjw7MrI1KANYMLUaL8/4A/lUw6WS2p6JhreWhrxuKWxsJLiZeIG9GOfCVthOzffB40Bp6KvP3xCxwhNrwu5wMaCgRwkUV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hlxo1EQRm6bPj+EzLOfc5c8T9eaguqn7eH+B7jwwCww=;
 b=L8x37ddoBNfZBPBlnH7sJjqcWx0GpcuDGEkL10VtLdOM2KqxjWsYm9voMf5taHVCdCQAELqdmMU1b8cQoJOj/D7XP9ejzBqHwR5IXOVJWzR0PIl/pNXZFtmR8p9ARvtCPrwAmHEqSeK0qXC3hqdSBVjCfviZwDhjqhuiaDMgo5g=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DM6PR07MB4523.namprd07.prod.outlook.com (2603:10b6:5:ca::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.27; Thu, 22 Oct 2020 10:29:43 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 10:29:43 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v3] net: macb: add support for high speed interface
Thread-Index: AQHWp9HS4UctazNdVUWuQbMULgmNwKmiZpMAgAEAG1A=
Date:   Thu, 22 Oct 2020 10:29:43 +0000
Message-ID: <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
 <20201021185056.GN1551@shell.armlinux.org.uk>
In-Reply-To: <20201021185056.GN1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy03ZDQ1ZmIwYi0xNDUxLTExZWItODYwZi0wMDUwNTZjMDAwMDhcYW1lLXRlc3RcN2Q0NWZiMGMtMTQ1MS0xMWViLTg2MGYtMDA1MDU2YzAwMDA4Ym9keS50eHQiIHN6PSIxOTExIiB0PSIxMzI0NzgzNjE4MDI0NTQwMDEiIGg9InlWZGZhT3ZONHRVVUF5alErNFhieGNCWkZ2dz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=cadence.com;
x-originating-ip: [34.98.221.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 146c61b1-e2da-4f07-856b-08d876756414
x-ms-traffictypediagnostic: DM6PR07MB4523:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR07MB4523E809A6F87C49BA6E87B1C11D0@DM6PR07MB4523.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wQcQoD4WQGsaw4TMKwYZxXh2ePwwtH7VE1Yq2k2HKP/xC3MUlQnwEhb/pgpzvAEgwPvQJk8KHz1uRAwtSvlAvMZSHcAqDvW4ETi6zH6QwfWqZCdfJOXPFRXjDZSLsee3H+c3Uv18sRgjGI1ClHgT5wSu+bCvs3TOLpZPCWSMxw8YeZXilbneEYVYOT1icjWjPlJkKJ+4dqQesbtH2R4Ibt4V7zcS1PSirhJdskbSxmjgfb4OVHFuFRgnVlxhyPU6bbKTN5jvKvOhfBuF5ms0oHTrAH2sIM4SIqi1t18YAgldvLgblLTYejkC59tbILGNhR8K5ua4UhLbITtxJK4FXNvw4sa1HfTkpMZ96bkF52U5L2W405fXR5ggVbCylH+s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(36092001)(54906003)(71200400001)(186003)(55016002)(26005)(83380400001)(107886003)(5660300002)(316002)(33656002)(7696005)(6506007)(478600001)(4326008)(52536014)(6916009)(76116006)(2906002)(8676002)(66946007)(66476007)(9686003)(86362001)(66556008)(64756008)(8936002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: aXF6MjS27vSJb21iT5Y6lMpd1D0I9vGZcZ9xOpfTB8hoacakoEqXIWV5MnolLHY89iYGHS7z3FOatqhQdUzTsv6TRMWlpW8GhvhWUz/OEl38Hsq4alNV+Lh6MJWpFIAiGDCV8aKaxXqMICqAD6nfzrKq1CtwiSQPKENFN7RMt85OgY6V+OHhzr1vdZPHE/03fdJJxMD7d1pfKyzlzXDHIb1fXSDx7qC6lO1sGS/Rx534WIGdWSunDB0NA3vcpq2N8ibDhX2PnSnTBWXWKO3u4BN3Je3u1Y1AaiIBQlETQPcQQriTV82SQDqPGg0M+GAx/N4QfgAK3IFuSdQrLadEnBjZ42+MRTF3cCAZD5CONeHri+9etA3NA5rqHRxAVylnHQ/hyuT91jgSl8VRCFf6RCBe8sUO+2hkFr+rX3wSGQTERC2TFuGWFxUdrHXLvFy4Qfn1oOE4Gio1/EhFTTjLbNiG+p9YeeieoaTATw2xLuwoBUvqNQbFzqDkHWdPXU/ib5z28JKT4lbxfy6JqfW9/PuMx6K81oLQgVES7yc8GrVHTbbax9tTOUTtc39GVXyT8KsDqFkjyPPhWe4FodLQ4WP6CMefRdty5oXJiTDoa+26Uq07CjGuDOmb3nDqM/pCjVThNugcxbpE27iZ0u0JLA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146c61b1-e2da-4f07-856b-08d876756414
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 10:29:43.3213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /cP1WtUUxmwutL6m3042B7d2Bk99PHSiG78KVjgxbTXjp0R+ZP9JiWN/U363R27DHxuVbLWtXC3rvQyLzjQ38chJduIY0mo7eocYLGWHecc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB4523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_06:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>If you're going to support pcs_ops for the 10GBASE-R mode, can you
>also convert macb to use pcs_ops for the lower speed modes as well?

Ok, I will add pcs_ops for low speed as well. In fact, having single
pcs_ops and using check for interface type within each method of
pcs_ops to decide appropriate action will also solve the below mentioned
issue when phylink requests 10GBASE-R and subsequently selects a
different interface mode.

Since macb_mac_an_restart  is empty, macb_mac_pcs_get_state only
sets "state->link =3D 0" and there is nothing to be done in pcs_config, the=
re will
be no changes in pcs_ops methods pcs_get_state, pcs_config and pcs_link_up,
except guarding current code in these methods by
interface =3D=3D PHY_INTERFACE_MODE_10GBASER check.

pcs_config and pcs_link_up passes "interface" as an argument, and in
pcs_get_state call "state->interface" appeared to be populated just before
calling it and hence should be valid.

 528         state->interface =3D pl->link_config.interface;
 ...
 535
 536         if (pl->pcs_ops)
 537                 pl->pcs_ops->pcs_get_state(pl->pcs, state);
 538         else if (pl->mac_ops->mac_pcs_get_state)
 539                 pl->mac_ops->mac_pcs_get_state(pl->config, state);
 540         else
 541                 state->link =3D 0;
=20
>> +	val =3D gem_readl(bp, NCFGR);
>> +	val =3D GEM_BIT(PCSSEL) | (~GEM_BIT(SGMIIEN) & val);
>> +	gem_writel(bp, NCFGR, val);
>
>This looks like it's configuring the MAC rather than the PCS - it
>should probably be in mac_prepare() or mac_config().

Ok

>What happens if phylink requests 10GBASE-R and subsequently selects
>a different interface mode? You end up with the PCS still registered
>and phylink will use it even when not in 10GBASE-R mode - so its
>functions will also be called.

