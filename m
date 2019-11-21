Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13114105640
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKUP6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:58:35 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:46620 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUP6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1161; q=dns/txt; s=iport;
  t=1574351914; x=1575561514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sWEKZ7u9G/ZGkNKSnmQEl1i5+KIUb6p3/2ImwMfEAnM=;
  b=F/gjdVjrO8Ls0Y+h4StScJZ9vQsZoV+XasCiGwF5Qem2DO8Omc3EP1jm
   a0A8ivyFrk+O86kjRL99dUevO2gHiT/q8v9usuSy6XiWxyKckAyxCEWkH
   gO9vntHX/l6OxMDNSD38u4eU5X6Cf00uuHvXR53Cegu+1o5ZVntANaE87
   s=;
IronPort-PHdr: =?us-ascii?q?9a23=3AE4XcShKXvFX85ywhCdmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXEHyKv/nazMzNM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AOAACqs9Zd/4wNJK1lGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFrBAEBAQELAYFKUAWBRCAECyoKh2YDimyCX48?=
 =?us-ascii?q?IiHmBLhSBEANUCQEBAQwBAS0CAQGEQAKCKCQNKAgOAgMNAQEEAQEBAgEFBG2?=
 =?us-ascii?q?FCwEFAiQMhVIBAQEDEigGAQE3AQ8CAQgYCRUQDyMlAgQOJ4VHAy4BoycCgTi?=
 =?us-ascii?q?IYIIngn4BAQWFChiCFwmBNgGMFRqBQD+EIz6ELheDQoIsrjQKgiuVRCcMmgy?=
 =?us-ascii?q?KcJ1kAgQCBAUCDgEBBYFUAjWBWHAVgydQERSCfiODJ4NzilN0gSiPDgGBDgE?=
 =?us-ascii?q?B?=
X-IronPort-AV: E=Sophos;i="5.69,226,1571702400"; 
   d="scan'208";a="385328451"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Nov 2019 15:58:33 +0000
Received: from XCH-RCD-009.cisco.com (xch-rcd-009.cisco.com [173.37.102.19])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id xALFwXTN021834
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 21 Nov 2019 15:58:33 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-009.cisco.com
 (173.37.102.19) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 09:58:32 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 09:58:32 -0600
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 21 Nov 2019 09:58:32 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/hiGQm/6+V1UiRfdf71AfsM6Q3qoQeojWxdlFzLdwc+EYHVueXxaJu6w3D1qb5NzF8JnVBRHY4lbiPQ0t8qgMuO/c4F8yElm4QiY3ySywK6brfx0x1qzn8ekGqqhiq0R7yrk/CYw6WzMBZtEDs7KY68U5uZ9QtuWW0UGBCjIr0qGlrR6IiUHzFDXfLKGxi6y67e7s01S2/ZDvBGaaGrQiGv1dK3kijPth9prspgiE2Y1GbXHAb4le2gUmRk9v7FPvs73Rr9IC/UsE6BvlxIKiXekz9hYt93oyprWSGyrRVSxwrUJHnFWEHjeCKrLcwR9pUED8iKdbDengr8iQikag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWEKZ7u9G/ZGkNKSnmQEl1i5+KIUb6p3/2ImwMfEAnM=;
 b=Nt6q7/0LFe2hBtrA4BToY/1CeJ80jB89eMCD32eWmDNcZkPG9sRAyJHsvgFa2SBePtp03WZYT6lMJFvJAUUhadqWvjOOByhESfBqcmK7qah6ZoS8R4urZG/x64TWdFvtpiQEnSF7rouLMhMlx75C+saUQ3FbhrktyhnB+vubW6Vkxne0Msrg0kNtFg5lHiJ2dNufRh7ucJIHdlpF26Bil0A5m90m5H3iSPIodzjhKsoK4ySd3dypPaV7Ys8UN1UrQ5+jmYSvBTGFIHniHZbMGNnN/ZKLGe6A1maPzNHDPDbDFRjf8VlSouovebZB8cbEl5FgFvJ1gglOZcrxdgYJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWEKZ7u9G/ZGkNKSnmQEl1i5+KIUb6p3/2ImwMfEAnM=;
 b=jDxXwjX900UCXZKJgiyPQsvZpbIwifMS+ly7tQfwaABL5P/A+X3vFEPa+GIKX7TASpgacx22u4Fy/JtQb2vHzAyfh1HrkYEka8f8HmEnGTDxWqIgcyxPAu4hEXtGbb0j470Z6SxJC7W0e3qW7QNLVxl4rXZrw/PuVbNdlu32iic=
Received: from CY4PR11MB1655.namprd11.prod.outlook.com (10.172.71.143) by
 CY4PR11MB1303.namprd11.prod.outlook.com (10.169.254.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Thu, 21 Nov 2019 15:58:31 +0000
Received: from CY4PR11MB1655.namprd11.prod.outlook.com
 ([fe80::4dfe:ce46:f1d:e0ff]) by CY4PR11MB1655.namprd11.prod.outlook.com
 ([fe80::4dfe:ce46:f1d:e0ff%9]) with mapi id 15.20.2451.029; Thu, 21 Nov 2019
 15:58:31 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVoISFMEKKMxe/iU6ModuMQmyV8g==
Date:   Thu, 21 Nov 2019 15:58:31 +0000
Message-ID: <20191121155830.GC18744@zorba>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
In-Reply-To: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc4b7245-21fe-49ea-d113-08d76e9ba7f4
x-ms-traffictypediagnostic: CY4PR11MB1303:
x-microsoft-antispam-prvs: <CY4PR11MB1303AC21B7A9C267C4CB7DC1DD4E0@CY4PR11MB1303.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:SPM;SFS:(10009020)(7916004)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(189003)(199004)(6486002)(76116006)(81166006)(26005)(186003)(8676002)(81156014)(2906002)(99286004)(91956017)(64756008)(66476007)(66556008)(25786009)(66446008)(11346002)(54906003)(316002)(8936002)(7736002)(305945005)(86362001)(66066001)(6916009)(1076003)(33656002)(6116002)(14454004)(5660300002)(71200400001)(71190400001)(3846002)(66946007)(229853002)(446003)(76176011)(6506007)(102836004)(33716001)(4326008)(508600001)(6436002)(256004)(6246003)(6512007)(9686003)(989001);DIR:OUT;SFP:1501;SCL:6;SRVR:CY4PR11MB1303;H:CY4PR11MB1655.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: slizwlt0XClE/uL2gEesUGx8eQrmYc5mhwLnlOIsjpS6VGZGDl7VNCqGjfuzXn2ND8NokdPQJLpRVfYb1hK6y1aWrQlaDLVPQHLaXw8S5b68AZhivIEV0JXNv1yvzf94oIUvyoGNu6bOxyw7zAScHVHW+x5qwgBVJdF+TpbumX+W27kSS+ztHO6zxTK0nCDdt5HKKJu0Mym9vDXGM7BKojA5AWU2fuZwqxR6uXkLoQ9D/Gi20UkQoBXrDvs1TnOVlSLTTfGfcwfTdMSX29KcG9jjRxoE07mmJ8GKs/Wg3jmAxaENxTgQ/IQP1yLTAIo5VTeXHwecsA74DeJLvi8TVGm8BgcDPfHEEooXRPB47T4A/tK8tNN5jCZIy0gFvrAHGQP2VPcuGjeiHJADgej9tuDiEkCu7ImWFy+8TdhE5UlmDORNUOekDl/moHlTzn7TFAMt533d1ton9AvsvavPanb+0J9u9y8NK5p7ntsJ0RTmbJb7vK1x1vaDnveoovx+LxlMwLKz2jIO7MncZHM2TBe8++AjzyRjuINUWAYIctj0IMLQntBzZfxEaQFumOn52d72UElNDv0twMJiuIa2E75DPcZSH0gDosxxKxJUwGg26HM3P2/svy0Zr0+OiPMYSzrnWC6AePi/twE4700//WJW/BLKDLJ85EIawfzXVpkA18ztAdfuoCkKZwzqHLlyGlewYtebCHd8c6cqT3mnKw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C6F9A107757BC4A90D8E64507889CDC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4b7245-21fe-49ea-d113-08d76e9ba7f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 15:58:31.1200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OylA9n6xwKKtBe2T3mbk0dYX7zdAB20viC126jne5KdArPvCIdIOp1n42hsd7khn3B5cemZZkC7/5IyjIrQHtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1303
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.19, xch-rcd-009.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:55:11PM +0200, Claudiu Manoil wrote:
> We received reports that forcing the MAC into RGMII (1 Gbps)
> interface mode after MAC reset occasionally disrupts operation
> of PHYs capable only of 100Mbps, even after adjust_link kicks
> in and re-adjusts the interface mode in MACCFG2 accordingly.
> Instead of forcing MACCFG2 into RGMII mode, let's use the default
> reset value of MACCFG2 (that leaves the IF_Mode field unset) and
> let adjust_link configure the correct mode from the beginning.
> MACCFG2_INIT_SETTINGS is dropped, only the PAD_CRC bit is preserved,
> the remaining fields (IF_Mode and Duplex) are left for adjust_link.
> Tested on boards with gigabit PHYs.
>=20
> MACCFG2_INIT_SETTINGS is there since day one, but the issue
> got visible after introducing the MAC reset and reconfig support,
> which added MAC reset at runtime, at interface open.
>=20
> Fixes: a328ac92d314 ("gianfar: Implement MAC reset and reconfig procedure=
")
>=20


We tested these changes on our side, and it appears to solve the problem.
Have been able to resolve the issues which you have seen on your side?


Daniel=
