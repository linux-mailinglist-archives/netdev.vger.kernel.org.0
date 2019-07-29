Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A27C785FE
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfG2HQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:16:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63422 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbfG2HQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 03:16:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6T7FPYb015228;
        Mon, 29 Jul 2019 00:16:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=9RiyxZaBrxDUASV57UhsJfBAlapUNde51WvA28AyKZ0=;
 b=gexNx7h7XkjohtQJA0MXiVp0dLjjcG1kfnCHsBLn9EasejJ6NY34IxOzVx3yikluizNQ
 ol/iMBxg960BfBAJfZBQZ0OeIpl1q2J/j5pNdiAv4pCvr6NciPCWq7gT8T3zrYZdU8ox
 1qVjsKVRrRM3ZQziFj9+qfw0yqpXoFP+OPbVNhuC+XQWiuceoW9HzR7pyZt5aSUuvyz2
 1/TW9hFX1C+SUes35zC9wzb2kXA7bY4Csb0Dqd02NEALwu/ZWC6dfVWpkZHJM9dPnqq1
 SgU+NQlkyRVTNYRpg6nkP4uxVXhlxFwYWLHFxwIgPho97eiy84CV16fdEIvKVdFSSqDX 7w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kypy25r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 00:16:20 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 29 Jul
 2019 00:16:19 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 29 Jul 2019 00:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4jwWFowwplpvvjVJNUhYI4z7x5pz7t69MLKYvbP3exgKDpkpJNuvs6DDmcCglRCGAVBJiDxFpNvgvt2q/X3Cqp1dwUZ6TR/IAc/U+ib5vBYUgyBVUKEePEHxhGzsZCmrgH+/AzMQAKW39dyzYpAkpyX4WMAWlDogkp8KQqZAiyidcqGX41c3xAB9xIeBEPpl/M4+x1cIDk934YB2IG5VRy2TnlXRH/mvs9xv6EdIIGEmcDan1UcDCl+3ex5qOlp5DjFfDAXULU5WyNG8MeFY4JsMAEu6/k+VQn7p+91elw1FUIGm6ZZkxYH4IlLG8PMfdNfgsc+gzAlUUnduqlp1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RiyxZaBrxDUASV57UhsJfBAlapUNde51WvA28AyKZ0=;
 b=PU1WqFuT/W7CSNTs8VTPLq1AFbERxOASvqDUhf8rN84YZBZAjrULeXVVzZTAXqFDF1BdhvLAleH99g/eUtFuILhqHRnWSwV196Mn+Be+3/YbZTyMTbjW4eC29VAVYMTAtT2Rz9S4z8gpxc2QAoI/CgiOtVxor1Da/kWZc7czlJjzEHOVxKK/ZLQbbtAGC0iRvBez+V5AGnMDmFZmYNTR8dTQ1dkUpX/MmDkZZxTR5X3HlkOq+2SErczVjT01B+3UO6sA/MaCCNq0dSGIGojpJB7E8/848gJhtYoA0odY985ekXltsVXNxhacbC2rJd3Lr7ah9tWfjESo2zjG/dFSZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RiyxZaBrxDUASV57UhsJfBAlapUNde51WvA28AyKZ0=;
 b=P6bIiZaH0ZNGSDDBQRUI4NVQRr19azVRZUxvWt6KnA3nk05GLGkki2GeNH3YDXhHXSCIw33TJCnwqBw3clDkY9uovjCMtIbNGjINaPfIg/NKgBdtxuTg0dptwRRgkNwVvCo8wc6zLODYEBp8xI+hib0+kv2Ke5Ruy4wmbz1od68=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2559.namprd18.prod.outlook.com (20.179.84.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 07:16:17 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 07:16:17 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next v3 0/2] qed*: Support for NVM config attributes.
Thread-Topic: [PATCH net-next v3 0/2] qed*: Support for NVM config attributes.
Thread-Index: AQHVROeiYGuhbTLCZkWtTd35qA279qbfSkcAgAHiuIA=
Date:   Mon, 29 Jul 2019 07:16:17 +0000
Message-ID: <MN2PR18MB2528091339990B1E74C21134D3DD0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
 <20190727.191328.1351271863559760336.davem@davemloft.net>
In-Reply-To: <20190727.191328.1351271863559760336.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4070:218f:1c13:583c:e641:6b2d:e6a1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61b670b4-c73e-4a3b-b44c-08d713f4a649
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2559;
x-ms-traffictypediagnostic: MN2PR18MB2559:
x-microsoft-antispam-prvs: <MN2PR18MB255972F695B4052EB95F3C4BD3DD0@MN2PR18MB2559.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39850400004)(396003)(13464003)(199004)(189003)(7696005)(53936002)(6246003)(76116006)(66446008)(476003)(486006)(86362001)(66946007)(66476007)(8936002)(66556008)(64756008)(446003)(81166006)(229853002)(9686003)(107886003)(11346002)(8676002)(55016002)(316002)(186003)(6436002)(76176011)(14454004)(478600001)(33656002)(102836004)(53546011)(54906003)(46003)(99286004)(6506007)(256004)(14444005)(81156014)(2906002)(7736002)(4326008)(5660300002)(25786009)(6916009)(74316002)(52536014)(6116002)(68736007)(71200400001)(305945005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2559;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UTTGg6e/hOD4EgnUFN/zrCBlI64AQRDT63Y4HMEiJLRBFt5seA9pB5YoqRxU7UySxlsDjZSumerBuVVsGWfHPPZO6iDm7oXFp4Z15K39c7nYSXw2ea7OKe/A8wf9sIotrbSVPh/gohAgbdEwTV6OGI63+x7SlU8QD0ZLOdTC1CNlZrOT926GblCHwhN69Bfuvvippx4IirfyElnBkPdh2N4DkXb5pLfSdX8QhyIQ7ktibNE+m6Rlq9x0Eyvzkdt9MByyH3I4UxYMZJI4DlLLDi3uwspZLxQNhvDRkvzhzif05rY3l7S9BVgAcgZaW+YxmatJJBugp+TaG/D7h0xri6zTxjzEEAw9lcc+pj+3JFgmfFXpSVmuO2yK5SYaScQKOjuZqs8f9o7clSCSS8833XFl+5rTIWTrUZJ80zLzLMg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b670b4-c73e-4a3b-b44c-08d713f4a649
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 07:16:17.6971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2559
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-29_04:2019-07-29,2019-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Sunday, July 28, 2019 7:43 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>;
> Ariel Elior <aelior@marvell.com>
> Subject: Re: [PATCH net-next v3 0/2] qed*: Support for NVM config
> attributes.
>=20
> From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Date: Sat, 27 Jul 2019 18:55:47 -0700
>=20
> > The patch series adds support for managing the NVM config attributes.
> > Patch (1) adds functionality to update config attributes via MFW.
> > Patch (2) adds driver interface for updating the config attributes.
> >
> > Changes from previous versions:
> > -------------------------------
> > v3: Removed unused variable.
> > v2: Removed unused API.
> >
> > Please consider applying this series to "net-next".
>=20
> I don't see where an existing ethtool method hooks into and calls this ne=
w
> NVM code.
Dave,=20
  The new API/functionality is invoked as part of ethtool flash (ethtool -f=
) implementation.
Example code path:
   ethtool_ops-->flash_device--> qede_flash_device() --> qed_nvm_flash() --=
> qed_nvm_flash_cfg_write() --> qed_mcp_nvm_set_cfg()
Thanks,
Sudarsana

