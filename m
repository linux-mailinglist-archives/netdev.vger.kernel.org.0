Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40279350721
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 21:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhCaTDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 15:03:51 -0400
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:63656 "EHLO
        mx0a-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235991AbhCaTDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 15:03:32 -0400
X-Greylist: delayed 4020 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2021 15:03:32 EDT
Received: from pps.filterd (m0108159.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VHsNQx027895;
        Wed, 31 Mar 2021 10:56:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=fhUspAdoxzdFw7GUOyorkVNYFRM9YQbENR6lpHhFvSk=;
 b=cZluJbesvS6Mf3EehYH3yrT1Xh30yuiZ4NpnAo8SvB2+uvSZO3od8rUGcBC6mPz/7z5V
 HdvmGw/W2dFK2Er9rj2DHDQDcNAbDVbJzv+s5OjdTKoKJaHXCwnCmRpDzMe+WrGyjto1
 nKFts5n+GiPVSjudLmJxnXocJw7nMSOmQtP5t2ZqeeZxmj35nknXxL1oPfdXxesRiIaS
 fpEd/6Glr1htllPUpZnu5ILMj6wkLeiRy5VDpnuCvJOJjJhwbhWZWjROTGDy1JrWD0ZL
 gKl+k1HcZR86ac2wHaCbzdBhgPcLx+SMyrxYYELZiZapkmy+8ExUK1bM+285srwKLnEF xw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00273201.pphosted.com with ESMTP id 37mtn5gksk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 10:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIOP7Ysiw4/b7iotuNkiG+BY4PXFkeaAzaK00LoGA1+wN5C1CaL2Lq4CSXPn77aWGSPRqsJLLu52g2Usc6V3g67meYiK3T4vbGuvSuJ0NENTudMfMgRgJL5kOjePyNgZ+mi4SdpxI1CAOqVcHKyDm7mA7bODMRQnxFjpdQJqS9uq0ZWtjCT1UDWVntuHjTisMo/3XLn1+Zu06NkUkhf7JfIPgHmeKfV1VRgMg55R5vXakvuRL83xtgMMwXC2KKx45I9LBSRCA9K/UGb1sNAtcQU3WB2FHzhkrij1OV2AeGklXdbZiwbod2k2c3K4VbT17NI2b7dDYxzVVSGZkUFDpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhUspAdoxzdFw7GUOyorkVNYFRM9YQbENR6lpHhFvSk=;
 b=Tt0K4tJQZHNnSfp87IalVkibbnYjOBlF4UmbnhNM112hXK9vo/giPgtomgnq9tp8qoWBgcBH8U+tLGjYbaTX6V/YJ/IfvAc1fIFNr36cR/YdBywCOuuzJAgUfluqFuK9D0yjdX3bxri1rkcTatYImn8BOQSbGEmm2euXSwoShuSjoMreulERMt5Gs7SlG0L8NLNMLE6lIJhtEfDId9sgapH9lIuhiI18Wn1UvQvqV7GLiUfuTsWj00/BdqEChNGZdzQ0qJqs6S/mxqPWTYIt02trpyE80j9nKb+zVEfyVR429jvRbwvFTWh2v+NX9f65Ba5cIGKoillO2BL/nY902g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhUspAdoxzdFw7GUOyorkVNYFRM9YQbENR6lpHhFvSk=;
 b=XVzoLJV9aYSE7b/9KLUjwQs0OqgaY439RYa2KtxskDrZik1LjyvMBJPuFi2bwL8rxNZ7G0NgRVyr8zcqQlQ9r/AUIRJAhW4gsx9LAhXdq7z5NKSD9MEWYv93yMAGNCWcHSTk7YK0XbD/6abP/eD/F0+FK6ZyFaQIJuVmFwPF8lc=
Received: from BL0PR05MB5316.namprd05.prod.outlook.com (2603:10b6:208:2f::25)
 by BLAPR05MB7315.namprd05.prod.outlook.com (2603:10b6:208:291::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.13; Wed, 31 Mar
 2021 17:56:27 +0000
Received: from BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe]) by BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe%2]) with mapi id 15.20.3999.028; Wed, 31 Mar 2021
 17:56:27 +0000
From:   Ron Bonica <rbonica@juniper.net>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Ahern <dsahern@gmail.com>, Zachary Dodds <zdodds@gmail.com>,
        Ishaan Gandhi <ishaangandhi@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
Subject: RE: rfc5837 and rfc8335
Thread-Topic: rfc5837 and rfc8335
Thread-Index: AQHXHr2uLkiNuGD0bUKudZz6Kl88daqRUnMAgABYvQCAAmKXAIAG//ZggABZEKCAAslXgIAAQKzw
Date:   Wed, 31 Mar 2021 17:56:27 +0000
Message-ID: <BL0PR05MB5316B56EA12C4EE314A6536CAE7C9@BL0PR05MB5316.namprd05.prod.outlook.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
 <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
 <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com>
 <CAJByZJBNMqVDXjcOGCJHGcAv+sT4oEv1FD608TpA_e-J2a3L2w@mail.gmail.com>
 <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
 <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com>
 <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
 <BL0PR05MB531617E730233A4913B4C5B3AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
 <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2021-03-31T17:56:25Z;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=0633b888-ae0d-4341-a75f-06e04137d755;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=e81e02bf-17f9-4df3-97a7-5ec921e116e4;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=2
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=juniper.net;
x-originating-ip: [173.79.122.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cf91a7f-0d51-479e-3f59-08d8f46e4e79
x-ms-traffictypediagnostic: BLAPR05MB7315:
x-microsoft-antispam-prvs: <BLAPR05MB731556C023185B7619B15DC1AE7C9@BLAPR05MB7315.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MpdhWB5YfZSyecjuQP6n41HYQilbT6VYLA9Vqz59ps2q960Y6yuQrVospX6omTDrjdnepxM2GAyB6AC0Bar2jOJ/lnKwTQGwnnIfq7m94yK+vFkJxogdrMJ6PUlQ3UGoPRArxLrMM3r0HMaLP2eIFYmaJaMp63JDr9M3vgn5Tw+eFuRQG+qiMmnu+SOYIq/HzlMMl819R4hq9ZV3fyyhEZtOD4yLL8Hb5JhRr4YoncsFxrR39LZP8NmE4M74DFlbIVaFz2YkO90ZWJgE4ZnCwAQkmOOztjFTh+zYsF2F2b1bu8cUtanyw8HxRDjGnXC6n+fEJNiB1JYAUenUpUSVOHAw5cGo3F3EGheOrMhcoH3QCegfFfC3UZE4BbGKAUUIGmSbZTqKWpPECAPCVZCtwQeocagO7ILYmMjnXO4of8awCbQMnRbvCBsx8MnffSZUdsx+4loWCd/XAP6jcbFfmEaCrD4cnLDQul9jr3Xzicj8pq4sA9FjTgrisGQdhKkqjmtU4gmpdPUJZShpytebjwiRmOiP/BJajy/e8Wcfjj3IH0w6VeB4m8LRR0uwzeQuD/cg1k3ReQX08ePzFEAwzMLshhNpx5iI/k3c8xhjuEMKLAqf2TTt+RuDgkpZ+LmdgsSB4eVPgr39bDDW7fzPWMYd3AyH5Ubs65RchFAWEqM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5316.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(66476007)(9686003)(76116006)(186003)(86362001)(8676002)(83380400001)(66556008)(26005)(8936002)(6916009)(64756008)(71200400001)(55016002)(478600001)(4326008)(66574015)(53546011)(33656002)(52536014)(7696005)(2906002)(54906003)(316002)(66946007)(6506007)(5660300002)(66446008)(7116003)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a0FHbzNHNVY0Y1dyTDFBUjBHZ3Eva25mSHRvL2krdUJYc3ppL21xNjJnL25v?=
 =?utf-8?B?c21LVHkybS9OMHN3YTdsT0VWTEVDakw4MmxiRWpXd1dOQW5pL1NBM0RLeU9P?=
 =?utf-8?B?UHJyaVdKMC9uYWJidTN6ZUxpYlFjNVdCMGNBQ3p3by8zRVJ0S05VcFlERzJi?=
 =?utf-8?B?c3p5T0dlNjJ1MWttVDlOV1pLR3ZFaEV1U1pMTEZPajJvc25waHYzWjFlZzZr?=
 =?utf-8?B?OEkra2RXQlk2VHlUUnBZUnh6MU85ZW9YLzlFUU1tQ0FXOWRmMWd0dTZhM1FM?=
 =?utf-8?B?UGVCN0hKKytKaHpRVlVLTVRNT1lVeGNoYlMxdE9GbWVhTzNia0pZMUpGbnJ1?=
 =?utf-8?B?ODcyekI0YWU3Y2xNbm9BYk9TR0t5SmdIVmRwK0VaYWlScXdZSjNDVXFoNS8x?=
 =?utf-8?B?K0tUM0RGb1hoT2gwNU9qSk1DS05MVDBIdEczYjNzWGUwNFh6M0UvL3V2NHJK?=
 =?utf-8?B?Z1FONlE4WUs5UDY4SHc0aHFUNVRJMkVrU2d5VUlqL1dSUmxTdElnS2RMaXZw?=
 =?utf-8?B?alZzL1lEWlRDRnBIQXRORkpUb2wyVS9VaVZnTXZ5ZEVKSVA0M05MS0ova1JY?=
 =?utf-8?B?WmxHakh4ZW9BTDlpcllrQVpwbzJFMXQyZ3FPTXd0cVRUNUpGdGYxemNiMHhW?=
 =?utf-8?B?TnpTVjU4cE9JaUZvNThsNE0vVjNCNFFXM2E2VjlpdmMra3pzbjR2dW5obDBs?=
 =?utf-8?B?K3RuRnk2NlEvQURVZ0ZCdmpwaTl4MEhKeW42Q29DVVJ2M3FPTnB4czY2dDR0?=
 =?utf-8?B?ZUd2aVRRNVFHNU42WDRpa0hNdVRuUzNneHp1dlMxNElKSTBPTGE3TlB0WXBG?=
 =?utf-8?B?bHRwcXYwb2szVXpzV1EwRXAvYnlaUkgzdTVscFMwMzV5NStUejF5TU5VUkxP?=
 =?utf-8?B?N1lpTHE0VFpkSlB0Q3p1N0g4UGx3aXpaOHQ0SU5VWkJlRnRsVlJXR3dCQk56?=
 =?utf-8?B?K2sremJLdVJJYzk2VmNyc3dkNkh5SkxKcUxjUUJJVmI0U3JBZE1Fa2NsakhE?=
 =?utf-8?B?WnN3akpaUWJuU3o4Wk9wWjRWUmpheWVzcHgwS2dzbURlcUZLRVJEbjNIcFVT?=
 =?utf-8?B?eDM5YXFoWmFGdjA0MFpLa2NnSHlXbXZJWUVWSk1VR3FaamhiUDkyYWxJeGVi?=
 =?utf-8?B?anJjck4rOEV3YmlwV3JkajNsQ2ovZWYrWFlNbmFLeXQySFFnWDRsWUVLak1B?=
 =?utf-8?B?OUVaT2Vjd2V0LzVLTlZlQTVPKy9PZkJEMHJYUmFDMlNTWGVjUE1peVpUTTlZ?=
 =?utf-8?B?S0lseUUrbmFVODVLNDRxaVUyRHNrNUhUeUJHdkRkUEdyQWlsTzNROVBobVNm?=
 =?utf-8?B?RWN6OTBSb3ZjR2N5aTBBWkIyQnFHVXkydC9zNG5ZOWg3bElTbjNNSTZlcXlK?=
 =?utf-8?B?TjcyVk5xRkVscDRZNzVDWkoyYm5mOUo3VkpBOEN0cUVXRHpNdUM5MW9PUEt0?=
 =?utf-8?B?bi9CcUFyVFVMa0huM21PUWdXQnNBTDdGOFAxeW54ak9laEYydWpxODRRbWFp?=
 =?utf-8?B?MC9GaVFMZVJSQzFmS0VkNHFmUkpUUHZmZEVoZGNZVkxVa0F6azVyMzIrMWQy?=
 =?utf-8?B?YmQ1a1kvS3k0VkZITDc0TzljUlpQMVU4WEgyeHI1aWxOL3ZwODdibk1FZnRQ?=
 =?utf-8?B?RHlhRTU4bWVFTHRVVW1pcS9kU0hYNDY0blc1WHdIMTU5Y0hiS0V4Q0w0azJT?=
 =?utf-8?B?WnVKTEJrcFdybEpIVVJOZzl4WVN2SUZQRkxRSVplQ25TejNIMDZsaC9wY2ZL?=
 =?utf-8?Q?421KIc4fX4T2GHCN9oF5ilwSXNEcBQjZj3P2++g?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5316.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf91a7f-0d51-479e-3f59-08d8f46e4e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 17:56:27.0925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1D0m2Z9Vu2JwmJ0fUrDwkFJncOXJZLSZBcfsuBPzqpblge8JOK8lRKX1H7vReJc1ttg/tr6oFICBdRm26pChLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR05MB7315
X-Proofpoint-ORIG-GUID: 9rOC8BHnrJz3EbqiZPgsyHgcXTOiseHp
X-Proofpoint-GUID: 9rOC8BHnrJz3EbqiZPgsyHgcXTOiseHp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_08:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103300000 definitions=main-2103310123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIQ0KDQoNCkp1bmlwZXIgQnVzaW5lc3MgVXNlIE9ubHkNCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IFdpbGxlbSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5l
bEBnbWFpbC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBNYXJjaCAzMSwgMjAyMSAxMDowNSBBTQ0K
VG86IFJvbiBCb25pY2EgPHJib25pY2FAanVuaXBlci5uZXQ+DQpDYzogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPjsgWmFjaGFyeSBEb2RkcyA8emRvZGRzQGdtYWlsLmNvbT47IElzaGFh
biBHYW5kaGkgPGlzaGFhbmdhbmRoaUBnbWFpbC5jb20+OyBBbmRyZWFzIFJvZXNlbGVyIDxhbmRy
ZWFzLmEucm9lc2VsZXJAZ21haWwuY29tPjsgRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsgTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFN0ZXBo
ZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz47IGp1bmlwZXJvc3MyMEBj
cy5obWMuZWR1DQpTdWJqZWN0OiBSZTogcmZjNTgzNyBhbmQgcmZjODMzNQ0KDQpbRXh0ZXJuYWwg
RW1haWwuIEJlIGNhdXRpb3VzIG9mIGNvbnRlbnRdDQoNCg0KT24gTW9uLCBNYXIgMjksIDIwMjEg
YXQgMzo0MCBQTSBSb24gQm9uaWNhIDxyYm9uaWNhQGp1bmlwZXIubmV0PiB3cm90ZToNCj4NCj4g
Rm9sa3MsDQo+DQo+IEFuZHJlYXMgcmVtaW5kcyBtZSB0aGF0IHlvdSBtYXkgaGF2ZSB0aGUgc2Ft
ZSBxdWVzdGlvbnMgcmVnYXJkaW5nIFJGQyA4MzM1Li4uLi4NCj4NCj4gVGhlIHByYWN0aWNlIG9m
IGFzc2lnbmluZyBnbG9iYWxseSByZWFjaGFibGUgSVAgYWRkcmVzc2VzIHRvIGluZnJhc3RydWN0
dXJlIGludGVyZmFjZXMgY29zdCBuZXR3b3JrIG9wZXJhdG9ycyBtb25leS4gTm9ybWFsbHksIHRo
ZXkgbnVtYmVyIGFuIGludGVyZmFjZSBmcm9tIGEgSVB2NCAgLzMwLiBDdXJyZW50bHksIGEgLzMw
IGNvc3RzIDgwIFVTRCBhbmQgdGhlIHByaWNlIGlzIG9ubHkgZXhwZWN0ZWQgdG8gcmlzZS4gRnVy
dGhlcm1vcmUsIG1vc3QgSVAgQWRkcmVzcyBNYW5hZ2VtZW50IChJUEFNKSBzeXN0ZW1zIGxpY2Vu
c2UgYnkgdGhlIGFkZHJlc3MgYmxvY2suIFRoZSBtb3JlIGdsb2JhbGx5IHJlYWNoYWJsZSBhZGRy
ZXNzZXMgeW91IHVzZSwgdGhlIG1vcmUgeW91IHBheS4NCj4NCj4gVGhleSB3b3VsZCBwcmVmZXIg
dG8gdXNlOg0KPg0KPiAtIElQdjQgdW5udW1iZXJlZCBpbnRlcmZhY2VzDQo+IC0gSVB2NiBpbnRl
cmZhY2VzIHRoYXQgaGF2ZSBvbmx5IGxpbmstbG9jYWwgYWRkcmVzc2VzDQo+DQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgDQo+IFJvbg0KDQpUaGFua3MgZm9yIHRoZSBjb250ZXh0LCBSb24uDQoNClRoYXQgc291bmRz
IHJlYXNvbmFibGUgdG8gbWUuIEFuZHJlYXMncyBwYXRjaCBzZXJpZXMgaGFzIGFsc28gYmVlbiBt
ZXJnZWQgYnkgbm93Lg0KDQoNCj4NCj4NCj4NCj4gSnVuaXBlciBCdXNpbmVzcyBVc2UgT25seQ0K
Pg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb24gQm9uaWNhDQo+IFNl
bnQ6IE1vbmRheSwgTWFyY2ggMjksIDIwMjEgMTA6NTAgQU0NCj4gVG86IERhdmlkIEFoZXJuIDxk
c2FoZXJuQGdtYWlsLmNvbT47IFphY2hhcnkgRG9kZHMgPHpkb2Rkc0BnbWFpbC5jb20+OyANCj4g
SXNoYWFuIEdhbmRoaSA8aXNoYWFuZ2FuZGhpQGdtYWlsLmNvbT4NCj4gQ2M6IEFuZHJlYXMgUm9l
c2VsZXIgPGFuZHJlYXMuYS5yb2VzZWxlckBnbWFpbC5jb20+OyBEYXZpZCBNaWxsZXIgDQo+IDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZz47IA0KPiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5v
cmc+OyBXaWxsZW0gZGUgQnJ1aWpuIA0KPiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNv
bT47IGp1bmlwZXJvc3MyMEBjcy5obWMuZWR1DQo+IFN1YmplY3Q6IFJFOiByZmM1ODM3IGFuZCBy
ZmM4MzM1DQo+DQo+IERhdmlkLA0KPg0KPiBKdW5pcGVyIG5ldHdvcmtzIGlzIG1vdGl2YXRlZCB0
byBwcm9tb3RlIFJGQyA1ODM3IG5vdywgYXMgb3Bwb3NlZCB0byANCj4gZWxldmVuIHllYXJzIGFn
bywgYmVjYXVzZSB0aGUgZGVwbG95bWVudCBvZiBwYXJhbGxlbCBsaW5rcyBiZXR3ZWVuIA0KPiBy
b3V0ZXJzIGlzIGJlY29taW5nIG1vcmUgY29tbW9uDQo+DQo+IExhcmdlIG5ldHdvcmsgb3BlcmF0
b3JzIGZyZXF1ZW50bHkgcmVxdWlyZSBtb3JlIHRoYW4gNDAwIEdicHMgY29ubmVjdGl2aXR5IGJl
dHdlZW4gdGhlaXIgYmFja2JvbmUgcm91dGVycy4gSG93ZXZlciwgdGhlIGxhcmdlc3QgaW50ZXJm
YWNlcyBhdmFpbGFibGUgY2FuIG9ubHkgaGFuZGxlIDQwMCBHYnBzLiBTbywgcGFyYWxsZWwgbGlu
a3MgYXJlIHJlcXVpcmVkLiBNb3Jlb3ZlciwgaXQgaXMgZnJlcXVlbnRseSBjaGVhcGVyIHRvIGRl
cGxveSA0IDEwMCBHYnBzIGludGVyZmFjZXMgdGhhbiBhIHNpbmdsZSA0MDAgR2JwcyBpbnRlcmZh
Y2UuIFNvLCBpdCBpcyBub3QgdW5jb21tb24gdG8gc2VlIHR3byByb3V0ZXJzIGNvbm5lY3RlZCBi
eSBtYW55LCBwYXJhbGxlbCAxMDAgR2JwcyBsaW5rcy4gUkZDIDU4MzcgYWxsb3dzIGEgbmV0d29y
ayBvcGVyYXRvciB0byB0cmFjZSBhIHBhY2tldCBpbnRlcmZhY2UgdG8gaW50ZXJmYWNlLCBhcyBv
cHBvc2VkIHRvIG5vZGUgdG8gbm9kZS4NCj4NCj4gSSB0aGluayB0aGF0IHlvdSBhcmUgY29ycmVj
dCBpbiBzYXlpbmcgdGhhdDoNCj4NCj4gLSBMSU5VWCBpcyBtb3JlIGxpa2VseSB0byBiZSBpbXBs
ZW1lbnRlZCBvbiBhIGhvc3QgdGhhbiBhIHJvdXRlcg0KPiAtIFRoZXJlZm9yZSwgTElOVVggaG9z
dHMgd2lsbCAgbm90IHNlbmQgUkZDIDU4MzcgSUNNUCBleHRlbnNpb25zIG9mdGVuDQo+DQo+IEhv
d2V2ZXIsIExJTlVYIGhvc3RzIGFyZSBmcmVxdWVudGx5IHVzZWQgaW4gbmV0d29yayBtYW5hZ2Vt
ZW50IHN0YXRpb25zLiBUaGVyZWZvcmUsIGl0IHdvdWxkIGJlIHZlcnkgdXNlZnVsIGlmIExJTlVY
IGhvc3RzIGNvdWxkIHBhcnNlIGFuZCBkaXNwbGF5IGluY29taW5nIFJGQyA1ODM3IGV4dGVuc2lv
bnMsIGp1c3QgYXMgdGhleSBkaXNwbGF5IFJGQyA0OTUwIElDTVAgZXh0ZW5zaW9ucy4NCg0KQnV0
IHRoZSBwYXRjaCBzZXJpZXMgdW5kZXIgcmV2aWV3IGFkZHMgc3VwcG9ydCB0byBnZW5lcmF0ZSBz
dWNoIHBhY2tldHMuDQoNCg0KPiBKdW5pcGVyIG5ldHdvcmtzIHBsYW5zIHRvIHN1cHBvcnQgUkZD
IDU4Mzcgb24gb25lIHBsYXRmb3JtIGluIGFuIHVwY29taW5nIHJlbGVhc2UgYW5kIG9uIG90aGVy
IHBsYXRmb3JtcyBzb29uIGFmdGVyIHRoYXQuDQo+DQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KPiBSb24NCj4NCj4NCj4NCj4NCj4gSnVuaXBlciBCdXNpbmVzcyBVc2UgT25seQ0KPg0KPiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBn
bWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMjQsIDIwMjEgMTE6MTkgUE0NCj4g
VG86IFJvbiBCb25pY2EgPHJib25pY2FAanVuaXBlci5uZXQ+OyBaYWNoYXJ5IERvZGRzIA0KPiA8
emRvZGRzQGdtYWlsLmNvbT47IElzaGFhbiBHYW5kaGkgPGlzaGFhbmdhbmRoaUBnbWFpbC5jb20+
DQo+IENjOiBBbmRyZWFzIFJvZXNlbGVyIDxhbmRyZWFzLmEucm9lc2VsZXJAZ21haWwuY29tPjsg
RGF2aWQgTWlsbGVyIA0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IE5ldHdvcmsgRGV2ZWxvcG1l
bnQgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyANCj4gU3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBo
ZW5AbmV0d29ya3BsdW1iZXIub3JnPjsgV2lsbGVtIGRlIEJydWlqbiANCj4gPHdpbGxlbWRlYnJ1
aWpuLmtlcm5lbEBnbWFpbC5jb20+OyBqdW5pcGVyb3NzMjBAY3MuaG1jLmVkdQ0KPiBTdWJqZWN0
OiBSZTogcmZjNTgzNyBhbmQgcmZjODMzNQ0KPg0KPiBbRXh0ZXJuYWwgRW1haWwuIEJlIGNhdXRp
b3VzIG9mIGNvbnRlbnRdDQo+DQo+DQo+IE9uIDMvMjMvMjEgMTA6MzkgQU0sIFJvbiBCb25pY2Eg
d3JvdGU6DQo+ID4gSGkgRm9sa3MsDQo+ID4NCj4gPg0KPiA+DQo+ID4gVGhlIHJhdGlvbmFsZSBm
b3IgUkZDIDgzMzUgY2FuIGJlIGZvdW5kIGluIFNlY3Rpb24gNS4wIG9mIHRoYXQgZG9jdW1lbnQu
DQo+ID4gQ3VycmVudGx5LCBJQ01QIEVDSE8gYW5kIEVDSE8gUkVTUE9OU0UgbWVzc2FnZXMgY2Fu
IGJlIHVzZWQgdG8gDQo+ID4gZGV0ZXJtaW5lIHRoZSBsaXZlbmVzcyBvZiBzb21lIGludGVyZmFj
ZXMuIEhvd2V2ZXIsIHRoZXkgY2Fubm90IA0KPiA+IGRldGVybWluZSB0aGUgbGl2ZW5lc3Mgb2Y6
DQo+ID4NCj4gPg0KPiA+DQo+ID4gICAqIEFuIHVubnVtYmVyZWQgSVB2NCBpbnRlcmZhY2UNCj4g
PiAgICogQW4gSVB2NiBpbnRlcmZhY2UgdGhhdCBoYXMgb25seSBhIGxpbmstbG9jYWwgYWRkcmVz
cw0KPiA+DQo+ID4NCj4gPg0KPiA+IEEgcm91dGVyIGNhbiBoYXZlIGh1bmRyZWRzLCBvciBldmVu
IHRob3VzYW5kcyBvZiBpbnRlcmZhY2VzIHRoYXQgDQo+ID4gZmFsbCBpbnRvIHRoZXNlIGNhdGVn
b3JpZXMuDQo+ID4NCj4gPg0KPiA+DQo+ID4gVGhlIHJhdGlvbmFsIGZvciBSRkMgNTgzNyBjYW4g
YmUgZm91bmQgaW4gdGhlIEludHJvZHVjdGlvbiB0byB0aGF0IA0KPiA+IGRvY3VtZW50LiBXaGVu
IGEgbm9kZSBzZW5kcyBhbiBJQ01QIFRUTCBFeHBpcmVkIG1lc3NhZ2UsIHRoZSBub2RlIA0KPiA+
IHJlcG9ydHMgdGhhdCBhIHBhY2tldCBoYXMgZXhwaXJlZCBvbiBpdC4gSG93ZXZlciwgdGhlIHNv
dXJjZSBhZGRyZXNzIA0KPiA+IG9mIHRoZSBJQ01QIFRUTCBFeHBpcmVkIG1lc3NhZ2UgZG9lc24n
dCBuZWNlc3NhcmlseSBpZGVudGlmeSB0aGUgDQo+ID4gaW50ZXJmYWNlIHVwb24gd2hpY2ggdGhl
IHBhY2tldCBhcnJpdmVkLiBTbywgVFJBQ0VST1VURSBjYW4gYmUgDQo+ID4gcmVsaWVkIHVwb24g
dG8gaWRlbnRpZnkgdGhlIG5vZGVzIHRoYXQgYSBwYWNrZXQgdHJhdmVyc2VzIGFsb25nIGl0cyAN
Cj4gPiBkZWxpdmVyeSBwYXRoLiBCdXQgaXQgY2Fubm90IGJlIHJlbGllZCB1cG9uIHRvIGlkZW50
aWZ5IHRoZSANCj4gPiBpbnRlcmZhY2VzIHRoYXQgYSBwYWNrZXQgdHJhdmVyc2VkIGFsb25nIGl0
cyBkZWxpdmVyIHBhdGguDQo+ID4NCj4gPg0KPg0KPiBJdCdzIG5vdCBhIHF1ZXN0aW9uIG9mIHRo
ZSByYXRpb25hbGU7IHRoZSBxdWVzdGlvbiBpcyB3aHkgYWRkIHRoaXMgc3VwcG9ydCB0byBMaW51
eCBub3c/IFJGQyA1ODM3IGlzIDExIHllYXJzIG9sZC4gV2h5IGhhcyBubyBvbmUgY2FyZWQgdG8g
YWRkIHN1cHBvcnQgYmVmb3JlIG5vdz8gV2hhdCB0b29saW5nIHN1cHBvcnRzIGl0PyBXaGF0IG90
aGVyIE5PUydlcyBzdXBwb3J0IGl0IHRvIHJlYWxseSBtYWtlIHRoZSBmZWF0dXJlIG1lYW5pbmdm
dWw/IGUuZy4sIERvIHlvdSBrbm93IHdoYXQgSnVuaXBlciBwcm9kdWN0cyBzdXBwb3J0IFJGQyA1
ODM3IHRvZGF5Pw0KPg0KPiBNb3JlIHRoYW4gbGlrZWx5IExpbnV4IGlzIHRoZSBlbmQgbm9kZSBv
ZiB0aGUgdHJhY2Vyb3V0ZSBjaGFpbiwgbm90IHRoZSB0cmFuc2l0IG9yIHBhdGggbm9kZXMuIFdp
dGggTGludXgsIHRoZSBpbmdyZXNzIGludGVyZmFjZSBjYW4gbG9zdCBpbiB0aGUgbGF5ZXJzIChO
SUMgcG9ydCwgdmxhbiwgYm9uZCwgYnJpZGdlLCB2cmYsIG1hY3ZsYW4pLCBhbmQgdG8gcHJvcGVy
bHkgc3VwcG9ydCBlaXRoZXIgeW91IG5lZWQgdG8gcmV0dXJuIGluZm9ybWF0aW9uIGFib3V0IHRo
ZSByaWdodCBvbmUuDQo+IFVubnVtYmVyZWQgaW50ZXJmYWNlcyBjYW4gbWFrZSB0aGF0IG1vcmUg
b2YgYSBjaGFsbGVuZ2UuDQo=
