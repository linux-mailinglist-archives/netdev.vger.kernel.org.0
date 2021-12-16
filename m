Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19B8476D71
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhLPJaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:30:06 -0500
Received: from mswout.fic.com.tw ([60.251.164.98]:43466 "EHLO
        mswout.fic.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbhLPJaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:30:05 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2021 04:30:04 EST
Received: from spam.fic.com.tw (unknown [10.1.1.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mswout.fic.com.tw (Postfix) with ESMTPS id 26F56C0126;
        Thu, 16 Dec 2021 17:24:22 +0800 (CST)
Received: from TPEX2.fic.com.tw (TPEX2.fic.com.tw [10.1.1.106])
        by spam.fic.com.tw with ESMTP id 1BG9HOv7055090;
        Thu, 16 Dec 2021 17:17:24 +0800 (+08)
        (envelope-from KARL_TSOU@UBIQCONN.COM)
Received: from TPEX2.fic.com.tw (10.1.1.106) by TPEX2.fic.com.tw (10.1.1.106)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 16 Dec
 2021 17:24:16 +0800
Received: from TPEDGE1.fic.com.tw (10.1.100.44) by TPEX2.fic.com.tw
 (10.1.1.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 16 Dec 2021 17:24:16 +0800
Received: from APC01-HK2-obe.outbound.protection.outlook.com (104.47.124.57)
 by mailedge.fic.com.tw (10.1.100.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.17; Thu, 16 Dec 2021 17:21:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9JHwGnrMoxBZiYYnvf0/BVFKiTQaq9VppdeiKptYwMUbqdrX7wy/pvb1QA1029TiGT5yRgKjZyA06BEVHLibGrGQPXP+EtPAfcPdLA+2nRmxZ2jNGhT2fzbShb61iQ0fJLPMQMtfNApSjJKREiEW/RMo/+aOKvp8C68rBIKaCwg3P4FBMGrJ/P/WxpA1+FduCcraLszuYWu6whZtK4zlSs92KBtWrXcqVth0mx3JG0HRZVlPZ8/ntviqWi52T5BCwu50FZ69RHLXr8wF8MJxBFBYvRsYHjwBTPHo09ghXbcg+el2cQaIuDtn/8WH0ZqCCOWTVXV3zBV8xQHvP1eOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lomo2pKwe4CX+BOutLdhtsdFCbsVYnELnlPTXD3UGck=;
 b=ZUGvcaMg7idtT1KaKnuSh68cyGlDHdWwaZUyFODV5jpzN9Fl983ZIj5TYLFn6CXz/pVXMMOw4QRAY1v5GYXTRxWyY8XbYdbUTEkUzMuwzU1oVIbwidyaq0X09AuSYNnfnXZUbRBoA70htBfOc1m7iEJ1ojqcvrxioLp+XBf32DC9oHcC/jKRQBKLAq0M6n+p8o2GQMRENmBy+TfqzqixsKWPdhb/CRluXC+8FwFLNkjZqACk/crPPQO/s+GmyKDWFYbSHg32IB9oVyc7DHOsxrSFl5IiA+yTv86xQd89J/B45aZU8dsstFaDu7IMFyj18ZJ2szhLVD95n6bQadNdfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ubiqconn.com; dmarc=pass action=none header.from=ubiqconn.com;
 dkim=pass header.d=ubiqconn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fico365.onmicrosoft.com; s=selector1-fico365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lomo2pKwe4CX+BOutLdhtsdFCbsVYnELnlPTXD3UGck=;
 b=H4jXCLG4eRNsjus4jBlOCsBdbVOotaghCD9DCFEGCQemSXoPBhwMt30jNSHTcEkf2ORp9TvHjeosZKm1U8zzZWmpQrkzcE+a6dNbm57cqv2FqUZeBZ0/2Unv9tP3m1NNFZimP2knDHs9FJmupQjEjwqFXtzQlD5Mrz+GYFBnea8=
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com (2603:1096:202:28::11)
 by HK2PR0302MB2563.apcprd03.prod.outlook.com (2603:1096:202:c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 09:24:15 +0000
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91]) by HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91%4]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 09:24:13 +0000
From:   =?iso-2022-jp?B?S0FSTF9UU09VICgbJEJuQGJ9GyhCKQ==?= 
        <KARL_TSOU@UBIQCONN.COM>
To:     "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Topic: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Index: AQHX8lxFF5ETxF22rUqK34URMx0EUA==
Date:   Thu, 16 Dec 2021 09:24:13 +0000
Message-ID: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 727457eb-b809-ceaa-adbc-31bd5bd4325a
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=UBIQCONN.COM;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb893555-7ebc-4db0-77de-08d9c075d328
x-ms-traffictypediagnostic: HK2PR0302MB2563:EE_
x-microsoft-antispam-prvs: <HK2PR0302MB2563B3306D37A6D5E0158BF1E0779@HK2PR0302MB2563.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:525;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MxDKCl+XU4XwgXRNpdvbOOX6UhXy7UcV+SDDIDXSMaSPdG5dwor4daq4ZZ3TesykHpp3evDSWRTScSRgIdPFECI3MaEDA80B6BJIw3gXjo+QLl/9tyUiaBgpM6JDTWDGcuTwNSry5zpEsdhIWzTYaVe2jKOFb/Ts5lx02QdqZBesbXFe+4aOYttWOiP8A5wJSy42/9XnfH5rJyZMIGLzmBKV9Q96dYD/Lp4EhwLQ9m787VCDmmgSs8puq6+ZAOr96uYOZPDbOMaXhXGxN+f0NBJ2B2JFz/5qTG9ekwX5ZJ6dogeSdNzZuhLw58/2GlAL7e7/YGl0rhTweBMHGT/A9i+NnoVRnB+Kxn9CwxySgRFzNn4z3u8w9bYCCUEEjvGxgpQF30WKJC1UFyIKkUupsPEs8L1BQ1OLTTGgJ5RhnGosqpjKfowRU1NdGU0g0x/xyLZ6/ZyTkcrbb+Sy0nfdvrd9VNUwLbydbSQBDfVt5SB17wj8/TE5DVw54SNQKC86SQ11MF6l+FpU9sx+1TwTEr4zphiIDPlgoop9pCKa/eny4ZZgtPtTFvuSYEijGt7oQJzajS/IXyspvX7vr+v8VkKg0W4PnSwGkWO8rzJdj5lnZLhmXfwJGXQNe0FX7QWeYG8iPjZD91H9fF3EwJwLsEIP+5ORGNckXDMaNHPX/iLgA6CtBHq7jYl3v3Mnjw115dmB49M0WryUcI7KquSSGMcafsa985UCGuRYQC+Kx/TzJnzg2lJUOmqFdzabi2RN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR03MB4307.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(9686003)(7696005)(71200400001)(508600001)(99936003)(26005)(186003)(5660300002)(55016003)(33656002)(66476007)(76116006)(64756008)(66946007)(52536014)(4326008)(38070700005)(2906002)(66446008)(66556008)(316002)(54906003)(8676002)(110136005)(8936002)(38100700002)(86362001)(558084003)(122000001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?S3o4dlQ2K1FaL0VodFo2d0FxK3BpV3Q5dFBaSDUva3A5RHhnZE14dzVP?=
 =?iso-2022-jp?B?TUpRMmRrYXREaHNwbGY1MnVIbE9QSmJGNGUwM2E3Wjg1WW85VmxURUpH?=
 =?iso-2022-jp?B?bDRxa01hRFloZ0RBTmtzTFl6YWdUQm1ySWtwanNvbUhPV0NtMGhWVkEw?=
 =?iso-2022-jp?B?ZlZNR1A2NFNuK2kyc0swOGZTWlI0QXluOFIyM1Y0ajVlK3V2cHQ0T0hy?=
 =?iso-2022-jp?B?VHFGUHUzdm94Y2xNckU4OUlZbGlHSExqOW9KSi9SbDN3dGNzUFNZUGJa?=
 =?iso-2022-jp?B?cWRrbWxsc0hETWJLTU9CWG85VlFCRWlrUUxEL0phM2t4SWtjbmRjOHho?=
 =?iso-2022-jp?B?bkt3aU5VeGVLYStyOEwzRlBkcUh2ZldFUVdhS2QveWgvV3NxWU41WkpT?=
 =?iso-2022-jp?B?aW1ES29odmJzdGpPKzVVaVRka1kvOFVqQVI2Q0V5SHNRNWxLYTZ3cU82?=
 =?iso-2022-jp?B?RjYrUVlhbzA1OTRQS3JWQUpsQU9CT1lmOXhlRDhCejloSnI2b21kSk5N?=
 =?iso-2022-jp?B?d0FGekhvTGNNRnZqSUQwanlXUXNIOW1MZElPdXdTcWtNR0VxVjVYSmdT?=
 =?iso-2022-jp?B?enM5ZG9INHNvdnEwb2d2M2pKQkxXOXF4cjllS0R6L1VILzB1ZVp6bTVH?=
 =?iso-2022-jp?B?bmFlZExtbVc1aWZ1bUVoK0M3eWFlTGV2MEJtS0tzOGNJUkxMRjhaeTI4?=
 =?iso-2022-jp?B?czNNd3YzcDV3SExvYS93aDV2OG9VUUZ0VmF2YnFUT3c4UFEzSllwaVlX?=
 =?iso-2022-jp?B?ZzZkWFNKYzJYVEJYQ25SMDFISVlmbmVJd2FiZ3VpMVhkcUg1MTVjWXRi?=
 =?iso-2022-jp?B?c1lCRFo2VEhKQWNBR2g0SExZYUVEOGZkK1dlNmR5UTlwRlY2NDNLVmM0?=
 =?iso-2022-jp?B?MHRvdVF4TEllbVQzNzg4bjRrcWFqeC96M0U2TmdCSC9QdjdhWDdZclBh?=
 =?iso-2022-jp?B?OVM3ZE5aU3dYcmZxb0dBem5FODZWUU9ob2RqMDFIM28wMFhMR1JyYkcr?=
 =?iso-2022-jp?B?N3JpQnFXdS91Rm14UkJTQlBLbDFHRjUxclJKL1dVdExMYUQ4TU9TclRi?=
 =?iso-2022-jp?B?NGVsUVNxaXZPNkFCRmkySDZmb0F1TVZJS3dIcnhKUkZRdlZtbTdKeXp0?=
 =?iso-2022-jp?B?SDFwUUIxZnhUNWdXOTh4blV1ZXpOcFZibVM0bW9EWFgyVzUvSmxiQnp5?=
 =?iso-2022-jp?B?NlZBN3JtU0hOZXhTbjhiN3lOZmNheE5iQU5EV3QzcThBUDVpZkJrQkF3?=
 =?iso-2022-jp?B?UVNqZS9UVDVPYTJlYXk4SWYvM1EvbEZ4LzJyUGQ2U2ZUVFczMFhCUHdQ?=
 =?iso-2022-jp?B?OVdpeHBady9NRkd0VjlQT2R1bXJkR1pESFQ3WTh0TEZnMlN1WnJJOWZT?=
 =?iso-2022-jp?B?Ry9ZOHRFVUdKZWQ0RmwyY3pnWG5NVHpDQUg0NWMyaVI2ZW9yMVdmQVY4?=
 =?iso-2022-jp?B?TkxGOXV0TCt3RG1vT0tuUisrSENNa004eDM4OThZNDQvUVFEb1lvY1VD?=
 =?iso-2022-jp?B?dndwN2xMdUIvTXlobXNOZUh5Zkw0cnMvMWZJU3JsZHpnV2lZdFAvckJY?=
 =?iso-2022-jp?B?UGZtb3dMMC9UNk5RVzFtKzF2cjA1S2VqcTlDNnZTZkJqQVBFYTVwZDdO?=
 =?iso-2022-jp?B?QVhQRGE2cWp4YWJHMU9VRmtpZk9sZU1kcVp6a1FBQkVsRU0yc2hBUTE4?=
 =?iso-2022-jp?B?bnpCVFdYTCtITnpITitSWXpGQUFVRkhCcjNPd0VvbW1HQmJRaUZTd2Ux?=
 =?iso-2022-jp?B?T2lzRlduSjhkd0hNNm9nbU9SNytSUldMY0ZITEduRm10NFloSVo0TkJZ?=
 =?iso-2022-jp?B?OUlKVjlwdTJjYVhjVE5PTWMyUzlncTBGcTkzY3hkVHlyZEhOSUZVVlNT?=
 =?iso-2022-jp?B?bGozK0NJcVRDc3p4NGFhRnJ5SERIT3FoYUZSQm5wK25zdURIZitwOU1O?=
 =?iso-2022-jp?B?YVBRWDUzL2FCNVpnbkx2T1RSU2FKSmEvVEU3ek5UVlE4MCtlVytlQk1U?=
 =?iso-2022-jp?B?V1FaNDhaY08yTlJRWlpVQWN3Q2xBSzhrWnNhS2FoTVNMVDkwY3d4d21B?=
 =?iso-2022-jp?B?Q1NTT2FMeTl6eXNZQmJvRldtVkp6VkIwa09yUG9wOU95b0tJUG5KcDZQ?=
 =?iso-2022-jp?B?cU1ib21qYndRQm5RbkNmYWdsSEtyYkpzdlNuOGJVT2w4UDVxT3Bod08v?=
 =?iso-2022-jp?B?Wis3WFdZTitTMGJncFlNL1hpaTdlZmhYUlFJOHRBQ0RJN28wZW5GTTN6?=
 =?iso-2022-jp?B?aFNlQ3JLWng2Uk1JckdITGxxMUhKdndBRW4vM3h5NFN6ckY5Y2EvWVpo?=
 =?iso-2022-jp?B?TmU1K1hHQllPY1ZCcklyU21QUlVIdTltdFE9PQ==?=
Content-Type: multipart/mixed;
        boundary="_002_HK2PR03MB43070C126204965988B2299DE0779HK2PR03MB4307apcp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR03MB4307.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb893555-7ebc-4db0-77de-08d9c075d328
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 09:24:13.5362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 767e8d94-d5f3-412e-b9e8-50323cd2c43c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9a4kjOXI/P9yWJslhhhcHPjLFNJW2z+g7lyg/VO91uYE55N/SBp/pw1jqttaelSC5NmBs5S7eed2dGho9IZWPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR0302MB2563
X-OriginatorOrg: ubiqconn.com
X-DNSRBL: 
X-MAIL: spam.fic.com.tw 1BG9HOv7055090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_HK2PR03MB43070C126204965988B2299DE0779HK2PR03MB4307apcp_
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

This fix driver ksz9897 port6 with PHY ksz8081 by hardware setup=

--_002_HK2PR03MB43070C126204965988B2299DE0779HK2PR03MB4307apcp_
Content-Type: text/x-patch;
	name="0001-net-dsa-microchip-Add-supported-ksz9897-port6.patch"
Content-Description: 0001-net-dsa-microchip-Add-supported-ksz9897-port6.patch
Content-Disposition: attachment;
	filename="0001-net-dsa-microchip-Add-supported-ksz9897-port6.patch";
	size=1540; creation-date="Thu, 16 Dec 2021 09:07:11 GMT";
	modification-date="Thu, 16 Dec 2021 09:07:11 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3YmI0ODcyMjQxMDc1ZmI4NDZlZjgzZmE2ZmRkMzkxOTNjMTM2YjQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBrYXJsdCA8a2FybF90c291QHViaXFjb25uLmNvbT4KRGF0ZTog
VGh1LCAxNiBEZWMgMjAyMSAxNjoyMzozMyArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIG5ldDogZHNh
OiBtaWNyb2NoaXA6IEFkZCBzdXBwb3J0ZWQga3N6OTg5NyBwb3J0NgpUbzogYW5kcmV3QGx1bm4u
Y2gsCiAgICB2aXZpZW4uZGlkZWxvdEBnbWFpbC5jb20sCiAgICBmLmZhaW5lbGxpQGdtYWlsLmNv
bSwKICAgIG9sdGVhbnZAZ21haWwuY29tLAogICAgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCwKICAgIHdv
b2p1bmcuaHVoQG1pY3JvY2hpcC5jb20sCiAgICBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29t
CkNjOiBrdWJhQGtlcm5lbC5vcmcsCiAgICBuZXRkZXZAdmdlci5rZXJuZWwub3JnCgpUaGlzIGZp
eCBkcml2ZXIga3N6OTg5NyBwb3J0NiB3aXRoIFBIWSBrc3o4MDgxIGJ5IGhhcmR3YXJlIHNldHVw
CgpTaWduZWQtb2ZmLWJ5OiBrYXJsdCA8a2FybF90c291QHViaXFjb25uLmNvbT4KLS0tCiBkcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyB8IDQgKysrLQogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5
NDc3LmMKaW5kZXggYWJmZDM4MDJiYjUxLi5mMzQzYmZlMzA3YmMgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNy
b2NoaXAva3N6OTQ3Ny5jCkBAIC0xMTk2LDcgKzExOTYsNyBAQCBzdGF0aWMgdm9pZCBrc3o5NDc3
X3BvcnRfc2V0dXAoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsIGJvb2wgY3B1X3Bv
cnQpCiAJLyogZW5hYmxlIDgwMi4xcCBwcmlvcml0eSAqLwogCWtzel9wb3J0X2NmZyhkZXYsIHBv
cnQsIFBfUFJJT19DVFJMLCBQT1JUXzgwMl8xUF9QUklPX0VOQUJMRSwgdHJ1ZSk7CiAKLQlpZiAo
cG9ydCA8IGRldi0+cGh5X3BvcnRfY250KSB7CisJaWYgKHBvcnQgPCBkZXYtPnBoeV9wb3J0X2Nu
dCB8fCAhY3B1X3BvcnQpIHsKIAkJLyogZG8gbm90IGZvcmNlIGZsb3cgY29udHJvbCAqLwogCQlr
c3pfcG9ydF9jZmcoZGV2LCBwb3J0LCBSRUdfUE9SVF9DVFJMXzAsCiAJCQkgICAgIFBPUlRfRk9S
Q0VfVFhfRkxPV19DVFJMIHwgUE9SVF9GT1JDRV9SWF9GTE9XX0NUUkwsCkBAIC0xMzM5LDYgKzEz
MzksOCBAQCBzdGF0aWMgdm9pZCBrc3o5NDc3X2NvbmZpZ19jcHVfcG9ydChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMpCiAJCQkvKiBTR01JSSBQSFkgZGV0ZWN0aW9uIGNvZGUgaXMgbm90IGltcGxlbWVu
dGVkIHlldC4gKi8KIAkJCXAtPnBoeSA9IDA7CiAJCX0KKwkJaWYgKGRldi0+Y2hpcF9pZCA9PSAw
eDAwOTg5NzAwICYmIGkgPT0gNikKKwkJCXAtPnBoeSA9IDE7CiAJfQogfQogCi0tIAoyLjI1LjEK
Cg==

--_002_HK2PR03MB43070C126204965988B2299DE0779HK2PR03MB4307apcp_--
