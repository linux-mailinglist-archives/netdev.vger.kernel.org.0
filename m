Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A8164E36
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgBSS6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:58:00 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:43852 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgBSS6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:58:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=975; q=dns/txt; s=iport;
  t=1582138678; x=1583348278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s85jXSyeXw5AI+pkYkOjCP30nX/ZEN2717Zje8vLCCg=;
  b=c8pAmOoSFShk3yGdZgqtVnXCEASlqNM9kKMM19wF5HkIgQk+XbABshGo
   YJpuMj+9TMhyw6YTpZvkskpD8lWYaOqtNkmdCDWHCdZGox+jc0ytBKVsQ
   g3hcRsGkk5juTI5MHMnnvcccPyHQxVX7d/RvpW04E6cI1zOYtYCTzQrga
   w=;
X-IPAS-Result: =?us-ascii?q?A0CnAAC3hE1e/5xdJa1mHAEBAQEBBwEBEQEEBAEBgWkFA?=
 =?us-ascii?q?QELAYFTUAWBRCAECyoKh1ADinCCX48WiHuBLhSBEANUCQEBAQwBAS0CBAEBg?=
 =?us-ascii?q?UyCdAKCBCQ2Bw4CAwEBAQMCAwEBAQEFAQEBAgEFBG2FNwyFZgEBAQEDEigGA?=
 =?us-ascii?q?QE3AQsEAgEIFQMJFRAPIyUCBA4FIoVPAy4BAqNJAoE5iGKCJ4J/AQEFhSMYg?=
 =?us-ascii?q?gwJgTgBjCMagUE/hCQ+hDIZhW6wFQqCO5ZUKA6bHYsInywCBAIEBQIOAQEFg?=
 =?us-ascii?q?VkCMIFYcBWDJ1AYDY4dg3OKU3SBKYxaAYEPAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3ATozZoRC0L79I9+LTAdCyUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuIPfsbiE+A81qX15+9Hb9Ok9QS46nPQ/Ir3a/7CAfFl?=
 =?us-ascii?q?DkLQQlerbTHYjfx4Svzeeu9pbPYgJOwj2gfbd1KxbwpgLU5IEdgJBpLeA6zR?=
 =?us-ascii?q?6BrnxFYKxQwn8gKV+Inhn679u9mfwr6ylKvvM968NMGb73eag1V/RYCy86KC?=
 =?us-ascii?q?E4?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.70,461,1574121600"; 
   d="scan'208";a="419089202"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Feb 2020 18:57:57 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 01JIvjIe019464
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 19 Feb 2020 18:57:56 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 12:57:50 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 13:57:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Feb 2020 12:57:49 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGXZzAXEaof5KxouNvo9MSvokhSVhuBUo54fWCWrr/Yu18AjX7tQYfAhAcvV7fVYzIkAZl4f9OUL3ZUNIM9uca9l72rkHxiJcsqMy6k10rOY0n6NVrGkC9TvPMkQEXdmQaiAPkUMv7evsxQnTrSqB2odn96OS1Ms1druE4ChfruZJs8rXI94XXx4iSlyxu5fiiTzj8n2AJTmCQoFyN6xSwgm1E3sBHKX7A7SwB3+Ho9OnjD97VtvtAyyDu34iybJ4f7aX9L6ZFrL3HD9O8aQt8lpyGhngfH06Ygk5uBeLG9SPfgESmCYZ2jTy96BcceENz9ZkG2nDiACIxewOmE/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s85jXSyeXw5AI+pkYkOjCP30nX/ZEN2717Zje8vLCCg=;
 b=ez9yi1p0WxRMPL5Qmgi4NeA4EZ3UJ1jLixANsCvYMkXTOLqqYyVM1mXOsCjNCCWWXeR/XGxKjNjnQSjBeX05MWKU9mekj0V7PtFnWQWO6WDkdDRTJiiCnE9PCyLDXjHln2YoSTsyyfeB67TmQHPCV1bmcc5dloPpsoskRcUYe1uaPkuOli784XlV0endzva/S0pxcsDKLfBHCuSjimTiRcHSZj+6iOmyzV1bkd1/nj7zli7h0IBHEVmhWOSRSm7lBHBk/P4baVwAriua9mAOczyQT5euGCaA/PYgneJiLy+lxPrQVOTKRTctmCI2ag0mBXjWEYM591WcA4dJPGNISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s85jXSyeXw5AI+pkYkOjCP30nX/ZEN2717Zje8vLCCg=;
 b=DG+Ap8pZdE6GwNMP9CsXb0zK6rD0pmtlnVWR0R1qZdpDJpMzNTW74SJ3a366MfnFPTb/AssyWl71L9T+hW1sDoBq01bEX6KL91p/WHJAYc58+pvVYe5V9OQewGVEWU5EzeIfWq8QNWu7dCncse/70WpoM9ig1m7mOsvM0xM//f4=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB3319.namprd11.prod.outlook.com (20.177.127.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Wed, 19 Feb 2020 18:57:48 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 18:57:48 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES MAURIITIUS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHV51Z5+kj8bd3gOEemCa38/k1KDg==
Date:   Wed, 19 Feb 2020 18:57:47 +0000
Message-ID: <20200219185747.GK24043@zorba>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
 <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <79AEA72F-38A7-447C-812E-4CA31BFC4B55@cisco.com>
 <VI1PR04MB48805B8F4AE80B3E72D14E7B96760@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB48805B8F4AE80B3E72D14E7B96760@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.187]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52ea0bdc-07d9-4e5c-ceb7-08d7b56d9ca3
x-ms-traffictypediagnostic: BYAPR11MB3319:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3319AC1AEE6CE384DBAE1417DD100@BYAPR11MB3319.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(189003)(199004)(6506007)(8936002)(6916009)(5660300002)(26005)(2906002)(9686003)(4326008)(1076003)(6512007)(66476007)(66446008)(76116006)(4744005)(66556008)(64756008)(33656002)(66946007)(71200400001)(86362001)(54906003)(33716001)(8676002)(186003)(81156014)(81166006)(107886003)(478600001)(6486002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3319;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s5ihwoZFMMsy6ZTLZ7QF1dQ+xfMRj/lseUwRW6yHcvvj6JvCfulBxuBJvljumBuX41Wq1Qej4X+e+yTk3mTPdxqvQEp7623yxR3hD28FslDS8ZU+8axC1CRSliM/mtYZBnAAbi/VcXiHl6Gra45mwg+HUgkzD74Dh73a5jCKlZpi7k6aSl+xsjNQ4kickZGdYQeXm2WmsRJAMCT6T2eBAelxM5fskYnLIdI+04wlQ2k4gbwXdtlXAko0zqlfWrmMVYC9OxPXEIXBwSBD4gIKeINY0UCMYK5Ht0SXPDe//W+cs05GRpdzSsXt8GQA+Az4kZ5Fsx5ohx4KcWXsAw4mGia4qVWWaRQIzJc0xdXZzoRz+l2Et8svE0Zn9lbmprE3ZH0HIfWrNYx/MvW44FFZFHQY7024hbrbM4p0fmlzrHI1sL0vQUxbbyDBXHUTXlAD
x-ms-exchange-antispam-messagedata: IwaFVr8qZv2Jp8locfcADlrLzl1O8ypZ4HgrvnqUdGXo2waj1eg1QNGRn0I4wC984DAptA2gXN+Izni8KmD6ARjM/k9U6w7XCL1ufkngX+E/mHH9CgWaNUwebti8CI6YS17qEr4PloVFBNgvdzQIzQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CBD60DAF069BA74197DFD2CAC060BC9C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ea0bdc-07d9-4e5c-ceb7-08d7b56d9ca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 18:57:47.8459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zf16ENL0ndcfn6m3BAifSPRYKVps/5jNqqsq4lfVg6L3KM6JSVrDZqrX7lXZ8ovGnTDuWKvht7SVp+hLb4uMsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3319
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 04:01:39PM +0000, Claudiu Manoil wrote:
> >-----Original Message-----
> >From: HEMANT RAMDASI (hramdasi) <hramdasi@cisco.com>
> [..]
> >
> >>> This bit must be set when in half-duplex mode (MACCFG2[Full_Duplex] i=
s cleared).
> >>
> >> Should the bit be clear when in full duplex or it does not matter?
> >>
> >
> >> From my tests, in full duplex mode small frames won't get padded if th=
is bit is disabled,
> >> and will be counted as undersize frames and dropped. So this bit needs=
 to be set
> >> in full duplex mode to get packets smaller than 64B past the MAC (w/o =
software padding).
> >
> >This is little strange as we do not see this problem on all pkt type, ic=
mp passes
> >well and we observed issue with tftp ack.
>=20
> I tested on a 1Gbit (full duplex) link, and ARP and small ICMP ipv4 packe=
ts were not passing
> with the PAD_CRC bit disabled.


Have you looked into this patch any further ?

Daniel=
