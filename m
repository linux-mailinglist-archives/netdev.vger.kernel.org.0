Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C6229696
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgGVKrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:47:42 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:24635 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgGVKrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=498; q=dns/txt; s=iport;
  t=1595414859; x=1596624459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WCSqf5Uls9spb4IbsGkk45DnUFBgOspOkCfNX6kdcEs=;
  b=ebtnT0iB7Hxa1TcUM6nwGlSTfcHZ9pskl6pyZ21UwsS4tZZEOmwHaSrP
   Y475HvhOIE+cIUQ7bWFlc7Q0EJBEEjlx22F4XetCc4Df2Rr6qipvyWYzf
   slHwvV0qcxs/RGMuDBIRMl2FwD/nWgppLUO6L0vOJUzs7WRSALK04KhKa
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3A8tKbcxQkrjZwiq4txkTMVRz9Ndpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESQBtmJ7f9YlO3MsLjkRGkK7IzHt2oNI9RAVB?=
 =?us-ascii?q?4A3MMRmQFoQMuIElbyI/OiaSsmVN9DW1lo8zDeUwBVFc/yakeUrii06jgfSR?=
 =?us-ascii?q?PyKRVyPOftHpPXhcmtkeeo9M6bbwBBnjHoZ7R0IV2/phnQsc9Dh4xkJ8NTgh?=
 =?us-ascii?q?vEq3dFYaJY32RtcFmShB37oMy3+c1u?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CfCAAGGRhf/49dJa1gHgEBCxIMQIE?=
 =?us-ascii?q?/C4FSUQeBRy8sCoQpg0YDjUiYXoJTA1ULAQEBDAEBLQIEAQGETAIXgXUCJDc?=
 =?us-ascii?q?GDgIDAQELAQEFAQEBAgEGBG2FXAyFcgEBAwESEREMAQE3AQ8CAQgaAiYCAgI?=
 =?us-ascii?q?wFRACBA4FIoMEgkwDDh8BAaF6AoE5iGF2gTKDAQEBBYUVGIIOCRR6KoJqg1W?=
 =?us-ascii?q?GM4IagTgcgk0+hD2DFjOCLYFHAZBVPKJ2BgSCXZlmAx6CaQGcZy2wXAIEAgQ?=
 =?us-ascii?q?FAg4BAQWBaSSBV3B6AXOBS1AXAg2OHoNxilZ0NwIGAQcBAQMJfI5DAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.75,381,1589241600"; 
   d="scan'208";a="515450508"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Jul 2020 10:47:36 +0000
Received: from XCH-RCD-005.cisco.com (xch-rcd-005.cisco.com [173.37.102.15])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 06MAla4i019006
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 22 Jul 2020 10:47:36 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-RCD-005.cisco.com
 (173.37.102.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 05:47:35 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 06:47:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 05:47:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5OBsJ2pHeyF+t9e+StXGN9iRM3fV6p72xlQvxnsnoMK1T98itlUDz4iP2U+JcJpu2uPpTIFY/pplAWFmChneYWyTDN2xMmwz2RFhuDemaj3RceHLRjViXcGoAC2MiCIMQ0fgEAE24geuXTv45eZ7gtDvYUIsY5NbY4G4tZfQGoOiD/WJA3OOwmYDmaf4NNRm+l429N8lhtnavoZTZaoZRgypqBmzTFsh1loj/V4blli4pY8z5XLXTeMGP9E6fcFa2B9skvDsq87jDXUuuDtN3199KEZX+r64fCyv+12R7gVFjj7UHdzzq3IFOy4aEQmqiYjleVXBKbAd2dl2ZSahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCSqf5Uls9spb4IbsGkk45DnUFBgOspOkCfNX6kdcEs=;
 b=ZENzwdR+/tmxkx6NrFIPfyhO6BRWnDObGY9KQoitPnMqhr/Qmh990ngzhvlcT1HgAqVTfIy1x/NyWnvTEC4vr9rP/f453Q0fMmDrpbKHZuag0aUxPI0TInft4y3zADQKlaWhqb3ktDUF9kt22tvcCqv54sgBFVHpwelMEG1F1RVq1vKdix2Sejgk7lWJ9qEGuxpzngPY+gGcxqYnF9dOz4KrmaXkTSLSN7SavDyFI4OpmaSyhSfuiYdOHcvM1ACA2Xga88TikyrRdj+qhfM9FEztAHo72zEVV8BLv2yHQMJZCCJbE+Buu/QwwIu8gieJ8/Nq/xsbpywNmeovcLd3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCSqf5Uls9spb4IbsGkk45DnUFBgOspOkCfNX6kdcEs=;
 b=e7iv3DfFJ/kmkARjBJeDBxovP+0dsKcbLd3+/Y1X+VhxrvUdixxv41cnX+AnDiPXyfgS7ECA0k9Tre3aHEbdujcoB7X/FGvJBtNzpKd7G7CmEdYpPMulW3iPX1fBn2NFo240dnqTuIgjXhWMl+eNGdQZlLqrRNmKXko+bMgGPbE=
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by CY4PR1101MB2150.namprd11.prod.outlook.com
 (2603:10b6:910:18::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Wed, 22 Jul
 2020 10:47:33 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766%11]) with mapi id 15.20.3195.025; Wed, 22 Jul
 2020 10:47:33 +0000
From:   "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Topic: [PATCH v4] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Index: AQHWX3jViMyDafIl90i5mFDwKnwkz6kTyEAA
Date:   Wed, 22 Jul 2020 10:47:32 +0000
Message-ID: <9D7619F5-821F-4F06-B0EC-BBBAB8450690@cisco.com>
References: <20200721071404.70230-1-srirakr2@cisco.com>
 <20200721090528.2c9f104d@hermes.lan>
In-Reply-To: <20200721090528.2c9f104d@hermes.lan>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.39.20071300
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=cisco.com;
x-originating-ip: [106.51.23.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3f0e3a4-6d13-4765-f989-08d82e2ca38e
x-ms-traffictypediagnostic: CY4PR1101MB2150:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB215011E156E55CF00D78AFF490790@CY4PR1101MB2150.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jBTzT4SqGEyd6LGdZTC7og3B1402HyvHq7ESHCjZ+Yyh+bFBuluIrjRUh1EeIOWyGgmoD4MYKcwQOzHQ70WLbqDWVfwVjaRSMjYoCPhqF517zWGbfn+c7wm9zTNas+kRjaGAEFd3Zpn9d7rbYEoBm1Dz7Vl1D8tzO0kqXMoX99vJy6hA9y2JmEHQbA8SyM1O9awgF93Y1sCQtxtus4+BVYxLu5Tip/lFms1e1Cgf/c+mJPXZh8PHH6Yc/n6PGXn8leqfeAH5ydAoyaEhq2jkJYltBdl9Ghy/FVeQEdXEuj0crw+kIjfy6mtnTBWNoz+p
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(54906003)(33656002)(86362001)(71200400001)(478600001)(5660300002)(55236004)(6916009)(8676002)(316002)(6486002)(2906002)(4326008)(8936002)(6506007)(83380400001)(36756003)(6512007)(66946007)(66446008)(66476007)(64756008)(66556008)(2616005)(26005)(7416002)(186003)(91956017)(76116006)(558084003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UwCM5fA6mNPyK/iDDuGOS2AqUX2AbEbHbeOki9EmlB16O3ZEwyPSUc10kO8UTzFLMRZekFW4mhJR2guCv4Jk+og+TBTsQ1kDWVJfjs848cAVpUKOdy+l7RsFhPmtRQzUpdUWae5cKv4kx+sUWAD7MNdXktSY3r0zH6uTS6jXj3Rjjtbii2m8z+uyMIGfDXjlWK3jGutrhqsMelmScGhM4ROp97ibzSW6iMNgM2asJM9KYBx06EP0TUmsg0bRNe9f2ralVBWpxwyzgXBke5R5WV1IastOBYqWXoKcXCOTzXeQZ7m2fQ4xdwRJCGGSX8Lok7aORJlOLwIAcPNektv9JWuDBC7C44Z+/2DuM4z+lU9vob8QKCffVqZXatyH4VZHkwk/cV2SMafw2dd6gmXoEHA1fmum1C+QqNnyIIdy2RxThITNrVM9/ezslScFlandODTm4nZx8Y39jMY0quI4T5r2jY+MITyg3bQ3vx5713k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A625900AF370C142A4996C48097F3C64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f0e3a4-6d13-4765-f989-08d82e2ca38e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 10:47:32.8610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ajp0X7UNXnr7qCN/0gAqSChRfwb1pifZeIaaoIPyxFHwa+DoY8NquLvbMdEBBdIUm5VAcSqfL0C2QhWVauNtIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2150
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.15, xch-rcd-005.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDIxLzA3LzIwLCA5OjM2IFBNLCANClN0ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVu
QG5ldHdvcmtwbHVtYmVyLm9yZz4gd3JvdGU6DQoNCiAgICA+IFByaW50aW5nIGVycm9yIG1lc3Nh
Z2VzIGlzIGdvb2QgZm9yIGRlYnVnZ2luZyBidXQgYmFkIElSTC4NCiAgICA+IFVzZXJzIGlnbm9y
ZSBpdCwgb3IgaXQgb3ZlcmZsb3dzIHRoZSBsb2cgYnVmZmVyLg0KDQogICAgPiBBIGJldHRlciBh
bHRlcm5hdGl2ZSB3b3VsZCBiZSB0byBhZGQgYSBjb3VudGVyIHRvIG5ldHZzY19ldGh0b29sX3N0
YXRzLg0KDQogICAgVGhhbmtzLCB0aGUgcmVjb21tZW5kZWQgY2hhbmdlIGNhbiBiZSBmb3VuZCBp
biBwYXRjaCB2NQ0KICAgIA0KDQo=
