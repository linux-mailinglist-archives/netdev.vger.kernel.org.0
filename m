Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30F948D41C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiAMI4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:34 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231709AbiAMI4G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNt4Z6bVn2ZeH+6DmZRfqsXB13ei8JOIWT4Wti0K1gnAbAa1YxSNbyq/Vg1gkh7bA18Nz+h7ZcWoGyS0W1G3orRXD/zqRyy5SvDAXHIYszZSvmwweGQmRKuHOtpYcT7F+wam+NqbHysWBjz+aolHxgU/xFCj3MSt2De7NRJY/y7GEdljHz7rj2JYwKBqkBCiKlpYNk3x4mX9RIBARP2Bmlkwf/WUCI2HvllnGK0+nbfPAYOiyvHw2lrXgC/YUvM4Yj3QgSho1mji4NvCjweHQYiVp8O7WCKcGFi6U3Y3PfLdCfD3ZS8FlgIrQMRZWTkXDS8d20DLQgH6Eurw49S+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nL2ckEzABAEpqhcSpNv/SBV9/l2lXuMeaPOSaepFJzs=;
 b=jOkMhzlS6UI6hjrxT4kmIQIISTXIfkWCQ1jdsuRfhtNeE4gMXtAnjJ78ZyWtBVopjRtOZnr9Wn2z1h8VptQVlZlyaGrlP+QOBo84rxG4NJZKpgjHgEdNOAUOFgDwG6UgrOOuz2hGm89F4GkOPATbT+wiuAMuMKOzquOP54ZLucz96lU1V9hdRHFZl1n+/7J8NssxQeMPAcA9RsPP1DeFO36NbCGk+GsCBP8j++71OzDLgLW7O3Gsr6A5ypRSG2Xf2Dkp0jhDqsPbQjqwpqBzqIb5d8hw+XtRIfWTuwneB2OJ8N43KT9CjdwF0K9GiGUl7h46ljRM5qP5rxib9ySnLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nL2ckEzABAEpqhcSpNv/SBV9/l2lXuMeaPOSaepFJzs=;
 b=ncW4zNi9fa7LzBMIzP+hjHGAo4jsmLO1CPhcfZwvBzNOj0R1GDqNKcDAu0iIP+DtlPn0ClOLCl7K9H4C0ECOJhSyhB8BY+kLUUwY50ws6Vq7JOwALDG+3HdhkN0fkhB1sV025VXMxflWjh3Ruw6gcMHDpucfTabws3IExewNkZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:54 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/31] staging: wfx: use IS_ALIGNED()
Date:   Thu, 13 Jan 2022 09:55:01 +0100
Message-Id: <20220113085524.1110708-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e4d412-aad3-46f7-ce86-08d9d672817b
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB404032BBCBC7588D549F3A3993539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:85;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4OFh3JLRDWZqhlZYJ2r/Ytvr0aiTU2DgmXGz3BXoJS3XAOgvJQ4eW1BuEJ3jLi4FoWmuamc3KT4nsD1NKEpyw/TtaKs+yeiw62X72lrngsvOzdCkoUogUONf25TCZRB63WATnUmkFAIQCM/E0bayNYcS2EOd6HfHqGsMFuhEgWU4AV65kkmZ1K5BGn3hvnseDV0S84ZmjpZ5KDqhN4T8oyUFqjFKr2rxo5MrrdNjVJyujZDWeM32Q+dSoX2VIHAaYnzDqjtJDy/6r8tOBBtCF7MCxZ9loHNazRoFOr3UzcNgog57wu5+dx2kZG68unzJ3VLHaB46+Il+/OlVwlpI6QBTXhDUqYHRuRunZ3VzkLEx6NjEbNcQgOY1Q+o45kneQtZtVbguqEiwVbBwApWALSXRfp92hgmy9e5EZMOqK6WGRG1G64X5z05rQl2ehDnYG5YUp6NK5YC4b0Sp3Wg3h0LSuxwDL+AMGjRfNVP4WlUAJioUTamo7kRIxDY8bo5Ja2z+tucZfBcRVbqjQzWUEE0546fDHLeHFOc9RsvxDlUQ2eoLyPP00+IayocuI9F7I4efgjcXkAyVkgLRDLlL5ccUwI6nAvS4DSuKLRJNIEWOCTyssDpSwlPjp2U9MkRkpLGE/oBh+Ehro1/lUn4jmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3M0VVFabWcrTnNwdzNvMzJFdjQ0Q3JhZldCYm9wd2xoalp6akJOUmFWTC9X?=
 =?utf-8?B?SnROSkZtMWRpTnllaDY0Zkc1RXM3QWk3U1hxZTQrTnU1UlAxdzlGc0hHN1Mx?=
 =?utf-8?B?MTkxSEtGeVVZRHBUUEhid1ZKM3hTVEdTemFyeENxQVlaSnRmdStSWnlBdWtK?=
 =?utf-8?B?ejJXZUN0VEZyLyszaWlNY3NTU0lCY2U5Z2cydTB3blBpOE80NGZpaUhacGgr?=
 =?utf-8?B?Q29ZTXBKMXVPR0RZWlplMnVrMm02Wk4zSUl3Rk9oMU9VeSthaHZhRldPSlQz?=
 =?utf-8?B?Y09McWlkOHFURXdUZFJwZmwza0MrUUVYbzRyNWt0eVlnMlYyL09DQzRuUXIy?=
 =?utf-8?B?VG5XaHpXYVdsZ3Y2NHRBMnpKY0Zic2JNeVo3OWlTWllDcG42Rmw1Y3NUMDBz?=
 =?utf-8?B?dXU2MVlCb0ptM2NNeFdZMmU2azVZWllHK0Y2bHNKcm9vUkx0MHhqOEhlNWp0?=
 =?utf-8?B?VHR6S2FERGtKUmMrSDE2bS90TjN4VWh5VysvV0lpdTRMeVQ5TnpFUG9pWGF5?=
 =?utf-8?B?cnBrOTAyTHFEb3JTTWNTRTJWOFF3eTZGcXdMR2x4L2FLZUFscDlCSThFUHk4?=
 =?utf-8?B?czVNVkRYa1h4aVZCMStGVW9SaXBkZ0lzZE9OOG9UK0FXT1VVZjFuVnhrQ1J3?=
 =?utf-8?B?ZEJ4ejlRUGVmb2VWTi9mUlVjQ0Z1cE4yeFdHZVZlckh4VC96ckcyeDJ2UHMw?=
 =?utf-8?B?T3hXUmRDWUtKR2xWY05RTUpqNCtybFdZNXNQaHVlZUhZQU83UGpiTlBmOWt0?=
 =?utf-8?B?WEdIYVl4ckh0czFjRFBaMmlwM2ROM2JkNjg4Q3FEbGwvamVSb3dmdWVYdWpU?=
 =?utf-8?B?dFVOTXVqZ29ONzdBWUZoVi9YQnJnb0x6Ui82WFNxZlI1NFZYVk5HUFVYR3l5?=
 =?utf-8?B?L3BpNjRUVWFBU3FpbWFTTWliWVZMSnk5NWxvMmJWOVgzWDRZQlVjVjkwY0hx?=
 =?utf-8?B?aXJSMmZHbE9PaWhwUnVOTWdQcnRnTlN3RjdEdTRkZ01KcFFUS2laa2FKWnhV?=
 =?utf-8?B?Y1gwRDRscGtYbTFMSk05V1ZFWStiMisxQkhwWEFraXhTRHQrNmtRTExBdjEz?=
 =?utf-8?B?eHdMUWxvQjhlcndFNldSUU96WStsYTAzeThnSURrNDBiTnVlL28ycmdJU21D?=
 =?utf-8?B?UW5nY09QZW9taEk2T1RqUjBKeVpKNUJ6VldnYVNxZXJtY29xZGJmSCtCUkhT?=
 =?utf-8?B?VDYvU2N6bVU5eFFzajNyY2xPajREamlvazN1WEI2c0ZQWUJKNlM0SFZNL2J3?=
 =?utf-8?B?amJia0hOeHFsc3B5OG1MNm5RTUdBdjhhVWltd0N2T1dTcHdUOHdaWVhjRlV0?=
 =?utf-8?B?dHZKdUhkRm9xcXIzM2ZCOWZSd1ZZMTlXQjdXUy9DeUUyQUtPTVljRjJ2dTFK?=
 =?utf-8?B?SG0yZGZWSzVIQWY5MWdYSC9vOGdRR1RrVUVZSlVxUy9hL2U5MWZNaGNHQmtO?=
 =?utf-8?B?Zy9xSUl1UE5wMDVnL0tET2ROWC9iSlpXY1JGVkRPT0hLeHIvV0Z1NWJ6aksr?=
 =?utf-8?B?SmY5eGRzZXBGeDdiK2t0ZjZtRjVzcWtpczFuR29xNkJuSVk5SS8xQ2VIcWN1?=
 =?utf-8?B?YjUvc2dJdmZiemVzSHFZbHMvck44cmpUbTRjbzdQQWx6RmN1QXBzRndwMzhK?=
 =?utf-8?B?N3pXZ1oxUWxYcm50RUhmYXplZE5FaWJ5K2FqL3h4WHdydjEyUHJIS3NLUldz?=
 =?utf-8?B?eCtiVDdkV0J2emtoOTYvVmVMbG1CS3NrQnc4VHU0QXlYcG1uU0dlWmE5Ri9L?=
 =?utf-8?B?UVpxSzhodW5lbVhqcHROUTJFQ3ZveFc5MXUwUUp3TE9JakZYV0hjdFJheUp3?=
 =?utf-8?B?WmV1dFFsSlJhRVdER0pGUzhSM1hNaEl6d0Vua3lPWFJQV1JRZmFNdnRUV3Zi?=
 =?utf-8?B?Q0pySGRReEEwU3lrYlJHSE91b1ZYTXBzaHorZ2lWMG5UdmUyWVpITytEeVB6?=
 =?utf-8?B?cDhRbnVlMndSMWpxWWlkY2hXblNqaVFnNk9pVERyV3BWZ0xRdkcwZ2lZMm1o?=
 =?utf-8?B?Z3V5VHdkbGpIS3gzRzhoOExNdHUzNUF6YVhyb1Y1KzVYc1VXNkNRLzlnMjND?=
 =?utf-8?B?Q1RoTUdvdjhiNkU2SDN1QjZmaGFzTjhSTEdialByVHluT1V4LzFyNnRoWkdm?=
 =?utf-8?B?bzg5S01OZ2pmMGpkZWtseEJYSG9LSFJqWGkvT2ZKSUZKNWxQUm83Q1Flc2Fn?=
 =?utf-8?B?RGZHeW5QV2gwalpUK2Z6ZmdPdHZDNWoweHdmM25iOFdNWko2KzJuNHlnaFlO?=
 =?utf-8?Q?QS61fyyJaq+SDZD2iYuZ+UOswumzXfDVqgKQUufff8=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e4d412-aad3-46f7-ce86-08d9d672817b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:53.9125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Bc3TGifiGnF8+OXqraaWQHWkRNDzN0VFdEafz9baEDxV5qo+UnFM83LgryXzdg4i4+fMBwaqYZzHinfY3pt3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
IklTX0FMSUdORUQocHRyLCA0KSIgaXMgbW9yZSBleHBsaWNpdCB0aGFuICJwdHIgJiAzIi4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMgfCA5ICsrKysrLS0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9od2lvLmMgICAgIHwgNSArKystLQogMiBmaWxlcyBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9idXNfc2Rpby5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jCmluZGV4
IGE2NzAxNzZiYTA2Zi4uNDJhZWFiMzBiZjBhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2J1c19zZGlvLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jCkBAIC0x
Miw2ICsxMiw3IEBACiAjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CiAjaW5jbHVkZSA8bGlu
dXgvb2ZfaXJxLmg+CiAjaW5jbHVkZSA8bGludXgvaXJxLmg+CisjaW5jbHVkZSA8bGludXgvYWxp
Z24uaD4KIAogI2luY2x1ZGUgImJ1cy5oIgogI2luY2x1ZGUgIndmeC5oIgpAQCAtNDAsOCArNDEs
OCBAQCBzdGF0aWMgaW50IHdmeF9zZGlvX2NvcHlfZnJvbV9pbyh2b2lkICpwcml2LCB1bnNpZ25l
ZCBpbnQgcmVnX2lkLAogCWludCByZXQ7CiAKIAlXQVJOKHJlZ19pZCA+IDcsICJjaGlwIG9ubHkg
aGFzIDcgcmVnaXN0ZXJzIik7Ci0JV0FSTigoKHVpbnRwdHJfdClkc3QpICYgMywgInVuYWxpZ25l
ZCBidWZmZXIgc2l6ZSIpOwotCVdBUk4oY291bnQgJiAzLCAidW5hbGlnbmVkIGJ1ZmZlciBhZGRy
ZXNzIik7CisJV0FSTighSVNfQUxJR05FRCgodWludHB0cl90KWRzdCwgNCksICJ1bmFsaWduZWQg
YnVmZmVyIGFkZHJlc3MiKTsKKwlXQVJOKCFJU19BTElHTkVEKGNvdW50LCA0KSwgInVuYWxpZ25l
ZCBidWZmZXIgc2l6ZSIpOwogCiAJLyogVXNlIHF1ZXVlIG1vZGUgYnVmZmVycyAqLwogCWlmIChy
ZWdfaWQgPT0gV0ZYX1JFR19JTl9PVVRfUVVFVUUpCkBAIC02MSw4ICs2Miw4IEBAIHN0YXRpYyBp
bnQgd2Z4X3NkaW9fY29weV90b19pbyh2b2lkICpwcml2LCB1bnNpZ25lZCBpbnQgcmVnX2lkLAog
CWludCByZXQ7CiAKIAlXQVJOKHJlZ19pZCA+IDcsICJjaGlwIG9ubHkgaGFzIDcgcmVnaXN0ZXJz
Iik7Ci0JV0FSTigoKHVpbnRwdHJfdClzcmMpICYgMywgInVuYWxpZ25lZCBidWZmZXIgc2l6ZSIp
OwotCVdBUk4oY291bnQgJiAzLCAidW5hbGlnbmVkIGJ1ZmZlciBhZGRyZXNzIik7CisJV0FSTigh
SVNfQUxJR05FRCgodWludHB0cl90KXNyYywgNCksICJ1bmFsaWduZWQgYnVmZmVyIGFkZHJlc3Mi
KTsKKwlXQVJOKCFJU19BTElHTkVEKGNvdW50LCA0KSwgInVuYWxpZ25lZCBidWZmZXIgc2l6ZSIp
OwogCiAJLyogVXNlIHF1ZXVlIG1vZGUgYnVmZmVycyAqLwogCWlmIChyZWdfaWQgPT0gV0ZYX1JF
R19JTl9PVVRfUVVFVUUpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5jCmluZGV4IDM5M2JjYjFlMmY0ZS4uYTJhMzdlZmM1
MWE2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2h3aW8uYwpAQCAtOCw2ICs4LDcgQEAKICNpbmNsdWRlIDxsaW51eC9rZXJu
ZWwuaD4KICNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4K
KyNpbmNsdWRlIDxsaW51eC9hbGlnbi5oPgogCiAjaW5jbHVkZSAiaHdpby5oIgogI2luY2x1ZGUg
IndmeC5oIgpAQCAtMjIxLDcgKzIyMiw3IEBAIGludCB3ZnhfZGF0YV9yZWFkKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCB2b2lkICpidWYsIHNpemVfdCBsZW4pCiB7CiAJaW50IHJldDsKIAotCVdBUk4o
KGxvbmcpYnVmICYgMywgIiVzOiB1bmFsaWduZWQgYnVmZmVyIiwgX19mdW5jX18pOworCVdBUk4o
IUlTX0FMSUdORUQoKHVpbnRwdHJfdClidWYsIDQpLCAidW5hbGlnbmVkIGJ1ZmZlciIpOwogCXdk
ZXYtPmh3YnVzX29wcy0+bG9jayh3ZGV2LT5od2J1c19wcml2KTsKIAlyZXQgPSB3ZGV2LT5od2J1
c19vcHMtPmNvcHlfZnJvbV9pbyh3ZGV2LT5od2J1c19wcml2LAogCQkJCQkgICAgV0ZYX1JFR19J
Tl9PVVRfUVVFVUUsIGJ1ZiwgbGVuKTsKQEAgLTIzNyw3ICsyMzgsNyBAQCBpbnQgd2Z4X2RhdGFf
d3JpdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0IHZvaWQgKmJ1Ziwgc2l6ZV90IGxlbikK
IHsKIAlpbnQgcmV0OwogCi0JV0FSTigobG9uZylidWYgJiAzLCAiJXM6IHVuYWxpZ25lZCBidWZm
ZXIiLCBfX2Z1bmNfXyk7CisJV0FSTighSVNfQUxJR05FRCgodWludHB0cl90KWJ1ZiwgNCksICJ1
bmFsaWduZWQgYnVmZmVyIik7CiAJd2Rldi0+aHdidXNfb3BzLT5sb2NrKHdkZXYtPmh3YnVzX3By
aXYpOwogCXJldCA9IHdkZXYtPmh3YnVzX29wcy0+Y29weV90b19pbyh3ZGV2LT5od2J1c19wcml2
LAogCQkJCQkgIFdGWF9SRUdfSU5fT1VUX1FVRVVFLCBidWYsIGxlbik7Ci0tIAoyLjM0LjEKCg==
