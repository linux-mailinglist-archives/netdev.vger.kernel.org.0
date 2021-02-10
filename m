Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAAD316422
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhBJKpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:45:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60778 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229944AbhBJKnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:43:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AAelmO021366;
        Wed, 10 Feb 2021 02:42:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=a/0f9w0DbRQVl27OdEvPTgl7uoZSVaz8AVwVmRLD1Bs=;
 b=aIpXUuXOFeXapvZrvxErKHNz5QJPZ2STlYNp715xgM55o73SxatlU4eZ6rITrVWJD9Kx
 jMTM0pKR6uyRZrQ58L1F/dOv888LwdkTmojJeWc9B6TJN8Ce2IQNbT0oSUEMzg39qloc
 YxKewzinLKK+OJSYl/0iX1dHlpnIOlPUPTx3KrjSvVPpySQDHxC2grEMmI1oKCPAwLpX
 HTecQznC9rP/xQDM0nOPctj/Luxvto0hg/peaXeMPdvkneWr24yeegzansBODh7HLVUK
 Vs+vSvN9Sgrft9ZBeB9UMh3RR8pkoMrLfl2WV5t893E54Q0ehpMwCGcvTSBOqmkfTgpZ /Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqbbnu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 02:42:23 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 02:42:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 02:42:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 10 Feb 2021 02:42:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9i7EPGqogcfEh/GS7KhMdp0ZBJqhzZMjPSM9qYh69SNmfmT8IqHtEaVnFYBdwqjzCf46fgCBmCl88CriKVQDAJ1BlBEFGd/m24ig7en2wrcnWFOoEIXyNczxqHzfLPDKeFHdQjyRdbSfhKRnWSnek7/pMEZHF190os0bxQ9ksH2sEZtUHuT3hB8d2Xc+Zgd1eoDGk2sd+USL3LYQB13ru9ligL411MoJEJ/3Zj7gWwmDKsGby6sK0dObO7qIH7iPQB08wVGFbKrhB3JNziOFaTNVP5eMvCZLkZNHFf1gb8VPxRxrQuPuajoxWaXH4WMid8OZT4NTfKEAUAlRAIe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/0f9w0DbRQVl27OdEvPTgl7uoZSVaz8AVwVmRLD1Bs=;
 b=mabRwK3TerXBEaoG4YrutBBXtV/Zz5G6a20BWx9/hoe7Wv2sUyTQQp9IJ/YU1ClDpSWQoOGdbJaIfoxG/52oYWbkeKcxqvWYdDte1F13eAtGs0Zcm+9niNRHhWkAPs4KnghUnnleliCNoagNRkRFtBO6Ub7fmaanVYkiqx4esC1AQK6hVeUkmRvOoyCuoIB5WZcF7c4ecMu5+raNqSkra8WTWCgCTLTROIeqHN5Q3wE2uFPQXz0YJHqiH7IU23NIQen9ahUgpw6lDmKJXdM1AlIRViIuwAlm9vG4Br1T8DcfAWrnuLWPa36278Y3vqaTWAeIfG3Re3UdCJwQwR/Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/0f9w0DbRQVl27OdEvPTgl7uoZSVaz8AVwVmRLD1Bs=;
 b=gQQRx2maFU5j+4zk6dcdvod+7a3s7YsEUOQFhpxNqXQH9zudlLMeyRM59/L1pWPNilJp42hgDA2Ou5dIFmsGMJnwwdIeJVFcQpTFa5LT2h3XtbCa684rnfVw8wpFiVg3w9GW+Lb4YwWILOB9myab+v/sX0L7TPq7M0mnM7RGl0s=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN6PR18MB1265.namprd18.prod.outlook.com (2603:10b6:404:e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 10:42:16 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0%8]) with mapi id 15.20.3825.032; Wed, 10 Feb 2021
 10:42:16 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Topic: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Index: AQHW+34dqeNi3qeAj0SumJjdXBCv2KpOsW+AgAAT+ICAARriAIAAPIIAgAAh5tCAAFG0gIAAcJfQ
Date:   Wed, 10 Feb 2021 10:42:16 +0000
Message-ID: <BN6PR18MB1587414DCFF009CA5AF26BC9BA8D9@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YCKVAtu2Y8DAInI+@lunn.ch>
 <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
 <YCMovY0veFPIQkTB@lunn.ch>
In-Reply-To: <YCMovY0veFPIQkTB@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.191.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16f62e0c-609b-4be2-36b0-08d8cdb088e4
x-ms-traffictypediagnostic: BN6PR18MB1265:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BN6PR18MB1265E6BC3147082C64BBC30EBA8D9@BN6PR18MB1265.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4gVJuSA5J/EcQ1CxOFOlPOJb/Hn7569Sm0iKEJC/20e1Jn8+8cfczV601vBMDaL+3MPvfjopyB68+hOTFjVhmw3w4b7Im0dVUc7YF0ezam4a0x9MlusDv8WT5j6U1/afSAk2Dm3hH6gee5YVPdXcl8nnDeLuaRxM6sx0tPvPhdNcbF0FTpFrBIqDOHEjMb/ZgxJZL5f0w+V1ih7DC4I7XieK8ZyG1DfR9CQ/tJ3AxQcpSB7YKgNDNRZ0tw66nwYYVyRofq3VyBR3qkR533iDpqnZ3/vffUNToNEWjxHvtdWgL7MSvmzpHv7gN96+IyJW4kac5ZRPehajKt4sHITHAUFk/KMtZHnSvd7FodiUgu15vz6tzzdf3A2qOKtFyNWS+UoKW1hVIfMMWT1NpKfB+Ik87e9mO0axiG7xv3OhA2ykMOpvHRDaEmfSCoi0qaVo6i1NjqJvXXl2yJRGLNrgl6eRxU2C4E9cdRZ3DaJDrAVsQny4+0OQMM9SQDmJvPKARBxBsZVfveFgPTxHjrXCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(6916009)(54906003)(478600001)(7696005)(4326008)(55016002)(8676002)(316002)(9686003)(5660300002)(8936002)(71200400001)(26005)(52536014)(33656002)(86362001)(4744005)(186003)(76116006)(66556008)(64756008)(66446008)(66946007)(66476007)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SlQ2TUZ6VU9KMm0vMG1KU2lnRWZ5MjQvb0t6cVBzbmZLZkZPa0xqckJZeFJy?=
 =?utf-8?B?QlRCbDZLSXZ6QXBWNzdlV0k4SjU2UzRBdFZKRHY5N2xnS1V1cUpSMlRqMFlh?=
 =?utf-8?B?elZrSkpnclZ6WmpkUDJsVEMzeENwR3NjNjc1WmlySEo0RDhwZE1pb0I2YWs1?=
 =?utf-8?B?bkFHRDAxNlJLNWZQbC9jUUhFSkJlM1pMUlRDeTVoZUkzZDhHYUtOK1MwOFht?=
 =?utf-8?B?dW9mWERTYjJrMTlWUWFMbHVOaTgyZFMzc1hUNW0raVB3Tjd6ZmcxVWJjbU5u?=
 =?utf-8?B?bllNV2JEZDFRb09hS3kxTG9VRXB4VVVMelhjeXhsblF3WUVUSDVQWHZyYXU4?=
 =?utf-8?B?K3NtcWZLdDBYNHJ1WEVQT2kzTUxPc0hweFFRUTREaGJqbENIK1dZMk93SlU4?=
 =?utf-8?B?N0ZMNkVsVkhERmY3alhUTnptZE0rcWdCbWNZcG1CT3QzTUp2OFdCVHFETjha?=
 =?utf-8?B?TXIwSmdJYXVHQ0xoakJrZXRPRWprSUFENEEwOWhUWU5qQS9nMEc3VStvZlFi?=
 =?utf-8?B?dUtvdERkWkR2TUxZalo0eEJCa2RCeDF3c0hFRjM5eWQydzJZSm5Sb1V6cWFF?=
 =?utf-8?B?aG9vZ2pKSjZGMUdQVDg3WUhScnpSZERXNER5YUJZMDJUVThJNGErTm1aZGYr?=
 =?utf-8?B?VlZaUFR2RGVpZUJhY1Q0cUs3OEIyMU9pbXhpQ0dpS3pPcTBBWkxoT3dkcE8r?=
 =?utf-8?B?QTR1WnUrajhrUmY4SVlzMDVieitFaTdLbkl6b0dOeFcrNlZIajBtK2RaVTAy?=
 =?utf-8?B?c05vMHl6d2pTQjV1NEFOcC9Ga2d1YVAxTjdNdG84L3VrQmxTbWxydTlyVkMy?=
 =?utf-8?B?TlkydU1IdVdxdmRTVnVRSytsSlZyTmx6b042b3N5U3p6OWpZRHpWVFl1NWtF?=
 =?utf-8?B?emNCSGlDV2YvUkpHajFKRWlTRkNWMlJFKzZmOXE4V0FGajZDY2R4YTlWalkv?=
 =?utf-8?B?Ukw4V2hSWDRic2xMVE9qdEFxVkIxQ0hkWEErdksrMGtEbFhEbk5qcXcvZDhX?=
 =?utf-8?B?azJyVGMrcmJkUEx5RVNGWUhxL1l2MFlPL1NyUVFUaEdZTE1ES2ZWT0ROdHVX?=
 =?utf-8?B?eXozdEljOW1EMHV0azRXQ1IvUDhGR3hMZUozR2h5K3hQY3V6U1FXdDJGZUVT?=
 =?utf-8?B?VXNDU05aNllUcmVFNTJyTXNndU1uazc2ZnhPUE93Z1FrWGVTUlJ6dXVDRXlz?=
 =?utf-8?B?RzBNbVQrQUpmWkROVDYwMkYyTSt6aCtOVGJlMkQ4UGN0WjM0TGp3TUswZEFk?=
 =?utf-8?B?QnVvWFd4Wi9sZndvUGpCZ3VhZXdhM1paOUNTYTJIOVp2UzNSQ0dkWGIxSW1p?=
 =?utf-8?B?VTNrNnAwdGoyTHYxUU1WczFwZUtoZExONnJsVHFydXhTUTdxUWNXNDdDdGg4?=
 =?utf-8?B?UWt5UDZNWHhwRVJaVCt4MHNFdkRBRDIvV1JZdzFkYlMyS3N5VmJUQnpWelpj?=
 =?utf-8?B?eThDU1Vzc2g1RXNuSmpCY21POUx5aFlQMk9FSjZZbEFCTDNBQlhYZE1tTW5Y?=
 =?utf-8?B?OW9wNW1QbEJEWDFqZDdkbWZBQVg4RUxId1dmN0lYSks3TUdNeXFSMk5md3c4?=
 =?utf-8?B?NUtaaHBJYkM0SnozQmdtUlNUOWhyTTBMZXhXTTN1NHpmdGtGTWFUcG5QVkRx?=
 =?utf-8?B?bVBRRm5aS3ZLZGVnZ01HR3FaVTB1V2V6Z2d5S0EwdXQ0R1BSaENGaysrWDJZ?=
 =?utf-8?B?ZE1uVGJHZmNRT2JmZERLeGtnWC9iaThudUQ3R0RiMUcwOTFrOFNMNG5yNFZY?=
 =?utf-8?Q?v/LvA4UovX3zaYPl3Hn5oZL/NTclgusv5r6cFQ/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f62e0c-609b-4be2-36b0-08d8cdb088e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 10:42:16.7151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9iQ18lExzYuDXl/170yAA8PPl+airIiniX1LMyj3lvSgglS7Xqbr5IDTiK0sSzX/uBKBZ21HmoGH8qJynCCSqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1265
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEl0IHdpbGwgYmUgaW50ZXJlc3RpbmcgdG8gc2VlIGhvdyB3ZWxsIHlvdSBtYW5hZ2UgdG8g
aGFuZGxlIHRoZSAnc3BsaXQgYnJhaW4nIHByb2JsZW0uDQpSaWdodCDwn5iKIHRoaXMgaXMgdGhl
IGNoYWxsZW5nZSBwZXIgZWFjaCBmZWF0dXJlIHRvIGVuc3VyZSBubyAicmVnaXN0ZXIiIGNvcnJ1
cHRpb24uDQpUaGUgUFAgaXRzZWxmIHByb3ZpZGVzIHVzIHRoZSByaWdodCBmYWNpbGl0aWVzIGFu
ZCBieSBkcml2ZXItd2lzZSAtIHdlIHJlZmFjdG9yaW5nIHRoZSBkcml2ZXIgYWxtb3N0IGZyb20g
c2NyYXRjaC4NCg0KPiBJIGd1ZXNzIHN0YXRzIHdvdWxkIGJlIGEgZ29vZCBwbGFjZSB0byBzdGFy
dC4uLg0KUmlnaHQsIG1vc3RseSB0aGUgTUFDIE1JQiBjb3VudGVycy4gDQoNCk1pY2tleQ0KDQo=
