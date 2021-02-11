Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1917318647
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBKIX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:23:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22612 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhBKIXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:23:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B8KrJ8002245;
        Thu, 11 Feb 2021 00:22:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ayw1TI8aShGTSnnf+JSCSBTzZDc/6TEAvJvItldKBI0=;
 b=cqlH5Ix3pFetKcRmOjxiEswDkKNqm92g9xhCof/DJu+l1WdE8OapX/e5D3rALhBHoQZS
 HqVGlVntLdQqWRwbJhykSNFdCcuz4kPGf+xlDfYbzSM5o4PhkLghvn5AfnvW9WsDv1OQ
 oPRkVtIgC97Fwp8LvRBvTBkIDSM54WsbIuXn89aYuezKbH2+SFXsYrzbNqyJWU2VTF7a
 k0/CSkRJE6j9Dp/U/66ostpnod+xIIfhiTpR+Vrj6cJCL5JgKYtMCHz+cLyGlywKb6pE
 mR+cFi5TA0byfeigVENL8X++MQ+Br3raDrwvyEgxLJxm7T8dsbK4IKX2jwH5MjNVLE3s hQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqe6b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 00:22:59 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 00:22:57 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 00:22:56 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 00:22:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GU+JxNv0IlXsscXjvpu4FxMq3TH/nyg2pwkg5RaCL7VzIPJHgEzu2blOt7TSXUeyQckOR49MJYf1me15n/3DHPbHV7hVfZM/EWCojzvN3vU7LoDZUW0MXnARdb7nzct4hrp99qcMO1FKUQ8zJjb/hIrWfEfc6FkujVbir/VEvGUZoPfvmotG8tXc+5p08tfVjoYVISc5lHv0Auok2rDC2AitKm2BWW7zs+9dagX+xu4/QglZuavIuj/uaDZFKBBe0QKo8+u7G6Nd9VPjm6S+WBCKIkomyWDqJ61Y1Gwx2G57nXrQKHO7NUQiP4CXh3ZBPFwL8YbAId+cXNVi/S1ZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayw1TI8aShGTSnnf+JSCSBTzZDc/6TEAvJvItldKBI0=;
 b=UBPsdDfMmUFuDyp+Kxh3+cCnBp7KDy7pXjid4MsnlvYAu2w9g3nDyNSL3IiPyq9RjTWelM/WodFVbG9vn3aEVtWLgC1ITKu7FtMHDo8TQfrJaaBHrwgWAVz8VQ8+mjbOIADSdBt7G5UOv4xHWSOA/s5h9st7K1MxkLfRVl88VreqhBpbJtyFmrlN//AcB+xusU1C4tkci2OtvTP8trLnRWy1ZHG/6JjA5nZLTAS6C50ZB1PoDFC9KniHS5YSQH0QUklJDBosQaZsGCQHtema58FTzD1bDHrDOhwQGDtgVr5u0NsG10fWe6C/2SSqHOUlFIyTjuK4C1jKlsUoUMz4uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayw1TI8aShGTSnnf+JSCSBTzZDc/6TEAvJvItldKBI0=;
 b=jtmsBu8ye9Z4dErRaIO719KF+nYL89zIO0WzcCe4Hlm+KPInsDJjhdzYyHuAe3zrvIEXvtaYTO/u/AR60e2WapRmIow+krrULF9nIHCoxLg5Y23c/RfFRbBcnbqf0pLw2s92uhyJR9hwrd2Uwr2tT057DtSNj5Uc0vju2H5yByw=
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 (2603:10b6:910:7f::33) by CY4PR18MB1240.namprd18.prod.outlook.com
 (2603:10b6:903:108::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 08:22:55 +0000
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::a9f1:4957:cb7c:96bb]) by CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::a9f1:4957:cb7c:96bb%7]) with mapi id 15.20.3805.028; Thu, 11 Feb 2021
 08:22:55 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Nathan Rossi <nathan@nathanrossi.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Nathan Rossi <nathan.rossi@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [EXT] [PATCH] net: ethernet: aquantia: Handle error cleanup of
 start on open
Thread-Topic: [EXT] [PATCH] net: ethernet: aquantia: Handle error cleanup of
 start on open
Thread-Index: AQHXADVN5+XfcfE+eUSyG4LXP5SGy6pSnVwA
Date:   Thu, 11 Feb 2021 08:22:55 +0000
Message-ID: <CY4PR1801MB181630A02E1E7AB32A7FA87CB78C9@CY4PR1801MB1816.namprd18.prod.outlook.com>
References: <20210211051757.1051950-1-nathan@nathanrossi.com>
In-Reply-To: <20210211051757.1051950-1-nathan@nathanrossi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nathanrossi.com; dkim=none (message not signed)
 header.d=none;nathanrossi.com; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [46.223.163.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2b1f6bb-f8b3-4c27-4da0-08d8ce663b94
x-ms-traffictypediagnostic: CY4PR18MB1240:
x-microsoft-antispam-prvs: <CY4PR18MB124096D26E47C3B35262EADFB78C9@CY4PR18MB1240.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:386;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aqto9dVmF5pF9selGDBYgMhatTojY1n79oBNiecJ9s/7rgAv5my9a7zdWVsr5yt8NlRMQrxZCDpJeb2Bmh4FgsLnyl9Dvr5pPBy78/GJ1zT8dFX0mrbbRxeG2aan38gIucIHrftxXSDkMvD9aWZOP6XSpHRCYdbuJ0oTJiB0FBs7KMr2ahIyHlbf7cuZg0fQ3Tv6g2MSx8nQWvY8PP/UaT3E26QRShTm5i4EmPh+44JEUY512I5cvrSE6/zB1GgfEap/xg34eq4ejyRjCIPWDmJRvxop340LOoaxt9+sr6c9IJeWKTg526wyeWbZeuXzORL2BsHUNhtmR1CwhcnMq9vzdHDrac0YEaJIdwzsXT8oyME/D+Iyc/Et0P5pPYbmXjPY6eafZXjm3MfT1ijxOOQq5xdX+n+//s7qgf+CfFwgWZY6NtHZYjOeM20/DWLLuohm4uXjpF1p7VXcFeA0gVGniSW0CKcGy7tMSzYZF39PPwHeJVifUwqARpixzMLTyuSguKQx1k5jgdZCqXYAhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1816.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(86362001)(76116006)(558084003)(66946007)(66476007)(66556008)(64756008)(66446008)(83380400001)(55016002)(478600001)(6506007)(8936002)(54906003)(26005)(186003)(71200400001)(316002)(9686003)(8676002)(5660300002)(52536014)(2906002)(7696005)(33656002)(110136005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bGFYbU16b2h4bUhxYkpmSDhiYTM2QmZRTUpwYUoxSE9PMERWNWJqRjBxZnJ3?=
 =?utf-8?B?bmFIdkhnaE9JMmZydkxDYWcyQVhybDhXV2NIMDlqc0kwU2ZIUFZXQTJ1NUxx?=
 =?utf-8?B?VlVybDJBbTc1Z05tQmM0M05ncjEwRkVaRFRsZW9SUWVHdmNvTjFvZFJNNmZP?=
 =?utf-8?B?U09SRklmTUZLa3J4TWE0ci9qWnEyRTJjUkJMOUY3d3NMOEFKSEllekE5ZVJD?=
 =?utf-8?B?bWkyOGZjTDBOTHhBYjdxV21WdXlXMWFVSVlDdm9FSVVJaVBpQTg0VlUyOCtK?=
 =?utf-8?B?WUJRc25ieFJlS1l6NDNKMTY2L2oxbmoyVS81d1d1dEZ0d1E4LzU1U2NnOFJs?=
 =?utf-8?B?dlY1RHA5QndLbDhja3RiOUtHUGxXUmdteDY4c0YvbDFzaXlteDN0dm1QOWxX?=
 =?utf-8?B?RTZVS1VDU0huSWdCazBQS25DdFJUK2JXNzFQY0FoR2tTdGpCcmI2bDFUWVIx?=
 =?utf-8?B?RW9vdkg0T3JJZVBEaXQ0cEFOeGVMZW9NLzQ4WFQvcG9Vb0hKYjFmb2h4dFN2?=
 =?utf-8?B?OE5nc285YjRkNjNnM1oxVlo3dXc0V2F3MVRYZDB1T29zTi96ZTVQekdMakpk?=
 =?utf-8?B?dHgrMlZ1bGpFZE9mTUJLeW00bXlYTHU2Sm1pRTEvc3RvMktBMGVkS3gyUXk3?=
 =?utf-8?B?K0JOOGZ1VFBFOTl1cFBzZWcvbUd2ejIyN2xMTlJLdWtUWXBxRVd0V3JOSUxH?=
 =?utf-8?B?dmY3Tk5pMEg3S05vT0RVcXhyMW8zVzllOFp3ZEdRTnoxZDQ0K2Mxa0huckRj?=
 =?utf-8?B?azY5b1NsdFI4R3loS1NLZGlOUTZiV3lncUpEVVlleG1GaUpLTnBFa2x0dDVB?=
 =?utf-8?B?ZkJ4N2lKa1lrTkNYS29vVkxLeFJlVjdzQUV3MDNBRWt4TlB4TmFrVEcvZEd6?=
 =?utf-8?B?OGFBN29lbWVjQk5JTEtvWGhEQ0dDSlp6MkNDdDA1NTBJNitRaUU1UlFCZXB3?=
 =?utf-8?B?Sk83Wnliak16bkNuUVd4RExXNHhtRlYwdlRJMElESzZtb2NVZHhITE42eE1Z?=
 =?utf-8?B?NkhCZVZBemtjS2x4dUlyN2IvN3FWQ3JQTnF4YmdZdENUQWl6bURpWmcvYVZx?=
 =?utf-8?B?Y1lrOVhPYWFtYXo2M0tuTGdwZjZZRzlEOFBWNG9vcHp2MUZCVFZSaEo3K2hI?=
 =?utf-8?B?TTZsZXN2TGVvUWc3aWFHb1dwZiszdzZkZDdwQUZ6aUNZa01xYjhMSVpDY3ZE?=
 =?utf-8?B?eWttMVoxclNISzhqMG95dXArenpMdlNtZzY0cEVxOVMzdnFwbWZzbDVXWlFP?=
 =?utf-8?B?VkJLZWRDMXhwRWNFRnkzeExTK0dPbEJFZ1lFbU5kaCtyTlVXamlwMHRMRFZJ?=
 =?utf-8?B?cVFBYnljNVc3cG1yK3FnWitVT2lJUTg0Z3FPWnJEcTVKUDh0aEY3TzAwN2M0?=
 =?utf-8?B?V2dQSWNlQWxxTG1lbVYwYXNJb1MwTVlVT0k0OWQwYlZNLzZreSt3WGlXRjFL?=
 =?utf-8?B?TXVtM1J5b3JTR2ROOTBKOUkya256K0IwdGVjclRWVmEzVldMazBiTFJZaitt?=
 =?utf-8?B?S1hKRHVkTGc2SjR6b0l1bHU1QldQV1c0eTQwV0w5bkU4YXRFSzF3bGdZYmRC?=
 =?utf-8?B?bkVKd1JwQ1VHWmk0NU1xaXo5T0QxTXBUVkRjYWhEeVYzLytNTEtpMUUzaEg5?=
 =?utf-8?B?TFpDZ1pZTHNHTk03Ujl0L25pb0J1N1AzcXlsNW96R3kvcFNVQ1lZTzFMRnRi?=
 =?utf-8?B?NVA3Z0lqS0QwV1BOUjdwWnJYQ1FwSGFoSHR1WGt3dG00b0x1b0Fqd29FeHIr?=
 =?utf-8?Q?NRiANWrr4IVGaVg8FDXe78FWrE5fvylpB4XHH7n?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1816.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b1f6bb-f8b3-4c27-4da0-08d8ce663b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 08:22:55.3496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MvOEM9MLYnJjN4+QNcmp9XgxiQ7m78rtDNzTGPmbEO7+HVH1XRGrSnXC72SZIm6q55aVvH40j8SDXyp7bPx5rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1240
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBJbiBvcmRlciB0byBjb3JyZWN0bHkgY2xlYW4gdXAgdGhlIGZhaWxlZCBhdHRlbXB0IHRvIHN0
YXJ0IGEgZGV2aWNlIGNhbGwgYXFfbmljX3N0b3AuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IE5hdGhh
biBSb3NzaSA8bmF0aGFuLnJvc3NpQGRpZ2kuY29tPg0KDQpMb29rcyBnb29kIHRvIG1lLCB0aGFu
a3MhDQoNClJldmlld2VkLWJ5OiBJZ29yIFJ1c3NraWtoIDxpcnVzc2tpa2hAbWFydmVsbC5jb20+
DQoNCklnb3INCg==
