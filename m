Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200A5CC749
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfJEBwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:52:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45388 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbfJEBwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:52:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x951p68P005145;
        Fri, 4 Oct 2019 18:51:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=IoOO84f11ZbaAq15IbvyLBf5+bIoLDCYU2mb+DJwKO0=;
 b=E1+y1nHBrGMEQClmp0o+eeOiUpmv1aNw+JZCta7tb0xNGfP5aJjHWFWBT01Zuk/qWNIC
 KX7Jm/3mzCiP6Wp3fP6s3xU3axXn0grvxnps5J7oGSEL8xxq6AlcY+ihUXU/sBArlVR0
 eHY6I6x7JEh2uDs/JB2VG+ceIGpkAJpTVtKQil4HvdepXi8O3i7nkpFDTUrUSKpxsAFx
 ReVs9+0SRLPxMQfCDQebR7dzAOzSuprtIvthcvEJJdsHjSBpF0QumZVRXLH72t9Xq9aZ
 mAY0vO4GmcIHmqD2yRihvH6vMS3P5T1rfYeRr7nQtnLMFXfZapO+vDGcOrObbmRNPXFZ /A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vd0yaaagh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 18:51:48 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 4 Oct
 2019 18:51:47 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 4 Oct 2019 18:51:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3Uq812PHGZub8/N02KIC4JCwE0wX9aMA0hY5K3y98gywmCFdrquhy7boaekwSpyvhNqaS1V+7SwddRJBK95K8yifcuv9k+HVpDHUfiG3IU04rlO51jWa83bYxdAlDJc3TWPKhF0c1U0+izz4JnBtWl8YbnoV5LcB5CQmcEJzieR5k08I/Vigeggb4DfMRDu9CZJjjjB0LvZMgimiOe/yBHN+TGp5z5oRYtDapmMdagrLmTLF2I9E3JkxHjeDzfdRoavlPmQayB0exVkSDfBU5iWWsicl32Nv04AL/7cL5iepVSgudifSf9Ntu/ybSkWZKaUNW5vnuXbsyeHya8iwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoOO84f11ZbaAq15IbvyLBf5+bIoLDCYU2mb+DJwKO0=;
 b=AaJdxrbonGMOhKk+d2GDctYYP+66YACfNGuFI5nQRVw+0L54lpiE2D76EEphos4fpSkEChzoD4R3nDNxTajVTafGbwsYVRC2KOFNxHf+hJ7h/f3uh6oDlK7lTzz48Q9FI9TVi78VGkxATiGzED/1tk+cCyMyACT7WG/9+7w2ZGgk3Atn1eR1DE346RPxoQLsScaAT0snzbq+zhk6+ckDuTyaH9tx/Jxl1OLAItSw8YCvqRU3eEuiKPvYLOwjjWxQJvshayI27SHQ0ZRICXgajt5sHl3nzs0KST89gPWra/U0k6XqYMUwKshgt2t1JUbQqn4ANz64ZDXh6qvb6Ln/1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoOO84f11ZbaAq15IbvyLBf5+bIoLDCYU2mb+DJwKO0=;
 b=dzHZyzRNtJJN7SmBVq6DIuPq7BB4V0F8Mi+0F7k5Wb+VaXlShIcNldcSXS2kLQlsbczcHx+MBUm7+ECC1KVnT1MVnqtOdAVCD03KP4owEhFT1Clk3E7lQY4WT7pDO8J2fWPzP/UzGhDNS9i6spbYyj1n7PeU6puo6jGaYUNaghE=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB3133.namprd18.prod.outlook.com (10.255.238.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Sat, 5 Oct 2019 01:51:45 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828%7]) with mapi id 15.20.2305.023; Sat, 5 Oct 2019
 01:51:45 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_alloc_cmdrsp_buf
Thread-Topic: [EXT] [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_alloc_cmdrsp_buf
Thread-Index: AQHVeu+VjJmN3rtj6Em9c/YO9xW8c6dLQGQQ
Date:   Sat, 5 Oct 2019 01:51:44 +0000
Message-ID: <MN2PR18MB263767B6B7B771837F0137F7A0990@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <20191004200853.23353-1-navid.emamdoost@gmail.com>
In-Reply-To: <20191004200853.23353-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.193.243.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6edf8c16-65ab-4db6-4e60-08d7493693a9
x-ms-traffictypediagnostic: MN2PR18MB3133:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB313387612ACD01A37C35969EA0990@MN2PR18MB3133.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(199004)(189003)(51914003)(6916009)(6506007)(26005)(102836004)(7696005)(14454004)(74316002)(76176011)(2906002)(7736002)(305945005)(7416002)(8936002)(33656002)(8676002)(99286004)(25786009)(478600001)(81156014)(81166006)(476003)(66556008)(64756008)(66446008)(66476007)(76116006)(66946007)(71200400001)(71190400001)(486006)(5660300002)(52536014)(66066001)(11346002)(446003)(256004)(186003)(3846002)(6116002)(316002)(86362001)(6246003)(4326008)(6436002)(229853002)(9686003)(55016002)(558084003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3133;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4fugZ09RWy7jpDc/69RCmFObwP9nc4wwyV/WaRBSgLaOMDV2U1EFzkWpe3ldeFvbKpipfi/7C3FybBcwe76MQVofT+Gw4ukMQtvZcnO4Dsn0+084l1O9sSbrIJtym1Wt2gbCV5Ihu7FhB0ZQ2nr/wWg1NzdZC/u41jChMPuQZEYc36nZUSHRboCBGmjLKDmrqpafoOW1pK/RT4aeM+eLRwYhb1gDBbw3drpN4Aak0+jBIF3++DkwFr/w7kr5+3OcMp7oCDbTU6CDfzqoS4fIAxZFO5FOhteGO9v9QpiDLM1TA219bVqg4Sbdy0MA3W5h+8hlNOZ7KyW4W2DHyX3n/ksWZwRLjwKgehMGFSR1qySMfqYr7CPPVeD92HJqj2etJF3nW7Mk7XMt4WAdeU7fkDP2tQDjRTysq8q00c5qlE0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edf8c16-65ab-4db6-4e60-08d7493693a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 01:51:44.9023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tE2xeGGPnSff8BVMs590dtTPIszakXCbGZZBrgLDb1LqYbEhwpaHMnCAxll9S6XnFCfZOykowMJAUWk4AcehtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3133
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_15:2019-10-03,2019-10-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Navid,

> Fixes: fc3314609047 ("mwifiex: use pci_alloc/free_consistent APIs for PCI=
e")

Thanks for the change;

Acked-by: Ganapathi Bhat <gbhat@marvell.com>

Regards,
Ganapathi




