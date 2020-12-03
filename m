Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336F32CD307
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgLCJ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:57:05 -0500
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:37318 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgLCJ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:57:04 -0500
Received: from pps.filterd (m0108157.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B39rcCU022643;
        Thu, 3 Dec 2020 01:56:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=PPS1017;
 bh=//rt4b90YZB6D3WeFNjWBofzMaukgA3vZhzLfsPuLaE=;
 b=HiEYpzfunm1w5Onof6lC7vBjYFAJtGJKwYlJjA/IVSebJd27m8cdy+Ad0L1A1j39ZFv9
 PqtGlLfwJp2QiL6J8C5R+B6evHNBEe4RZ3iogUiDFOKdl30wO5/Ym2R5UpEUY4+Dy5FK
 JI6FGpHNpZ3YzI2yZh7kjDiTXCBI1vfrM4C6a7UDoYZJaB2pHxtspPJ2Cgoi/sdpa9SG
 +qC86ixHwyDXziAojXIPjs9k4VFZzotMauoK0eQva5u0QMetnu6sfH0FlDJfVg/3hWyx
 peSFVHugjls2mDVlnh3zXliYt5E1vU86P8Km/8rntym38fcNA8AdXVuLCR2E4jKkfpVx +g== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-00273201.pphosted.com with ESMTP id 355vj1ua2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 01:56:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jh4Lh+YBMVHynV1S9KXSTxdPNQ96mVDr9Qc0yByyn40MyCJJl02A0gBpMyTLk+MzKkOGl4BYlINBqKfB4bkowJbrX/8a93gIdntKhaiKGb6FNe08GWA/6QtWHYiBMNUrubXOVT9+BQTnbEdzvcW0052PO6LzmfgwXqleiLmU/+NtNMRvKeLEVpVL2blUepysYyL/FpaD6dmFivsj62G9n+Lfnj0oW05RTizpU7mM/sezq4XsxiX8ny/YK1f6DUM+27C92qJ0H7+mdbOKD7Qu64NPKJ8/6uamNzFYzIVZs1FvxpyKLHgJYzocXXpLnhJQqSwyp2aF3vAD4bBgVR+7jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//rt4b90YZB6D3WeFNjWBofzMaukgA3vZhzLfsPuLaE=;
 b=WhM9J0ZMER0Mr+7QnAOwH0qzva+h5Ys5lzE+m3fAaWfkmVdndwscQUdZcrxvksDHSmcs7lkgiymTlShL7PnqRH+KqSOUuCU1EwKw+mFvEZkt95Fc/nEQ8qq0laSvAK5TzRoR11FB/+6UehNWQdAJyt8j/2XhAqMd1ewl51Cd2Bwbh2WjHJv0yoePuf33ZPQ4a+1sNvgv3kc5jhY+aj7fphhFZ3Iq4l+2Mj7ldO5tiRgVFtA9P7i4zsufI5sXU19putDTvf8eUXe+sD3/PckUcAfwQWvEee3zu6nkBXZNL5cyFcPDNmTAGtIm57qqz5iIclvALUXPJs1qaVzdDXDzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//rt4b90YZB6D3WeFNjWBofzMaukgA3vZhzLfsPuLaE=;
 b=ZYuFig66X8oyDT+dyUO0dCP1x8DRnmIwKXSHorfZH0TEvEDbtPW37jEkTyKxMZIIfUQjbf7bhAwHMeCVH/yWr2kLoCV53hKhgBxBcmWxSN0ilbdfdV3llhwoVu95ksZruGQKs33JXNkDJaepPYNqerwutj4tlcG7QNo/cYVRHJk=
Received: from SA0PR05MB7275.namprd05.prod.outlook.com (2603:10b6:806:bb::9)
 by SN4PR0501MB3870.namprd05.prod.outlook.com (2603:10b6:803:4d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.16; Thu, 3 Dec
 2020 09:56:15 +0000
Received: from SA0PR05MB7275.namprd05.prod.outlook.com
 ([fe80::8c45:d5a1:7fc9:230f]) by SA0PR05MB7275.namprd05.prod.outlook.com
 ([fe80::8c45:d5a1:7fc9:230f%9]) with mapi id 15.20.3632.019; Thu, 3 Dec 2020
 09:56:15 +0000
From:   Preethi Ramachandra <preethir@juniper.net>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jimmy Jose <jimmyj@juniper.net>,
        Reji Thomas <rejithomas@juniper.net>,
        Yogesh Ankolekar <ayogesh@juniper.net>
Subject: Re: Linux IPV6 TCP egress path device passed for LOCAL_OUT hook is
 incorrect
Thread-Topic: Linux IPV6 TCP egress path device passed for LOCAL_OUT hook is
 incorrect
Thread-Index: AQHWyJ61jWvdoGeWyEK5V+lOSzNoZqnkgNaAgAD/MgA=
Date:   Thu, 3 Dec 2020 09:56:14 +0000
Message-ID: <0A10EEDD-B3A6-4FCC-89E0-23BA946D3AFB@juniper.net>
References: <3D696DFB-7D22-44A6-9869-D2EFDEBDDEEB@juniper.net>
 <7b4f897a-b315-09eb-58f2-5e0b4a33ec73@gmail.com>
In-Reply-To: <7b4f897a-b315-09eb-58f2-5e0b4a33ec73@gmail.com>
Accept-Language: en-029, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=0;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=c9b15dd7-2d44-4ffd-8adf-1c2654527e4a;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2020-12-03T09:54:32Z;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=Juniper
 Business Use
 Only;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=juniper.net;
x-originating-ip: [116.197.184.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d94b8f0-39b7-4bcd-a040-08d89771ac67
x-ms-traffictypediagnostic: SN4PR0501MB3870:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0501MB38701604E56D76A132F9B476D1F20@SN4PR0501MB3870.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /C1zpEdEgMYMEJyMTFv7EX8sXeKz5NRHfWo5xRkRgJSkFaVESBNtXKdDBWRM1/7HB4QKcLedX9rRhVPX5H5tHpcjuoAR2Zr6wlBTfESEh1yLIvzMhPzUFSmLGsIaTZ/W+ydC7gHi7yn/VZQCoTBB9eyEn8/2KaTcDzF+nkN+ZaMvXOba6+/sfI8wOgnY2JArhdlfLh5RE0m0B5PKk2gGfPNe4/+/WuoUM/oSqh4/s7XMpIoeXqdCxjiZqb5KNNKoIhB4yKZM1dBcZ4rn7ql7qp90SceUphTR33j2TClZ+WfB1/gWJ2lZEPThh5jHmcJIfvCcIfDBx2WWpKIzC88jPth6y6I4lPghe5chYgCd4itf44W4k8/ZAeH7gk+TWnGVwiVXLBEdDX1jIDFsBiMJuqGNpqCitT8I+k2awFmsX1pHYtuesO+Z360qH6CxPP7qPeRg/cONG1DYVFb2WEd9Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR05MB7275.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(5660300002)(110136005)(33656002)(6506007)(53546011)(107886003)(26005)(86362001)(71200400001)(54906003)(36756003)(91956017)(478600001)(8676002)(76116006)(186003)(4326008)(6512007)(64756008)(66446008)(66476007)(66556008)(316002)(66946007)(6486002)(2616005)(8936002)(966005)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dXluVjNDRGtDU0dySkswZzlvNHRTYjZLUWpyOVVjY2pmclhlcDM0cUNIdWRM?=
 =?utf-8?B?ZWRIWVB1a3RVUWJoRE0vMElkem15bW1uK1dqRGFtOFlQQlI1ejB5TUVVcDJa?=
 =?utf-8?B?N2pWbWtYeGdJS0tCaGVWL0RhM1c4NkwyUXVMQmJ2UzRCb20vNG91ejVwMnJU?=
 =?utf-8?B?ZElpQ1lsdENrQVNuQ2VKYVV6YlVLMUErcitmZ0lQa3hreXkvdnFSdGVPZmda?=
 =?utf-8?B?MmRFaVpWVUxZOFc2QzdBSWcxMWxxNkdkS3ZvT2ZuZDBLR1M1aUErRjRxemdr?=
 =?utf-8?B?S1pMdVlvcDhrcUpQNlNHMXk3YjFMVHBSUk1MeURzcGpjb0JYZFVvY1I4TWI3?=
 =?utf-8?B?NGZGVG02NXdmc05JaG9yTmtoMjhJUlFRd0Z1MEtWbktlajl4WU90VytXTEdo?=
 =?utf-8?B?bjJXYmx4MHNxMHlJN1YrVFhHN29xemRNRzlZYTV2cklGeWVyQmI4a3FBM3p2?=
 =?utf-8?B?ODBwUU1aRzh5alNOdEpuajVkbWZiOFNpK2lVNTV2WkJIR2Z3Z0hsSFNlTHVX?=
 =?utf-8?B?ZzVKOTRvTUE4Ukw0WWlXVHcyTWNaQkZnd05pSzl4NksxUkNmU1JSS29BRGpR?=
 =?utf-8?B?Mld4YmNNcDFBVUgwV0xWZHh6bHdBZUV4K3ZCeGd0WGVRcjJ4RGJVUjFyZU5B?=
 =?utf-8?B?NEV0K0dicU8zWWpVMjdRZkc3d3JtSzhpeWI0WWlPbkc5SU9uV0Qrek9zUnJ1?=
 =?utf-8?B?d1BkRko4VmVBMVk4cjdJbmFkdWM4eEJiQjVHMEFvYUk2clpOSERwQUU4bXV2?=
 =?utf-8?B?c2l4d3FqaU55djYxbzFFRnBveFJJL1REMS9ZQkdSVnk2aWxqc2g0MHRnWDcy?=
 =?utf-8?B?ZFlLb2ZQR1NUQW9NWGszejBHYmZETFZMUEM4Vml2TVFvcWdlMkNNNnJEYzZw?=
 =?utf-8?B?aW50UkhtSWduWmpsbnBVLzBkWnJkLzBwMGEvWWM4ZmZIMGtuR3RCMUVGeURz?=
 =?utf-8?B?QUpsdHFNNXl6R2lRaHBwM1BjTE1hekVzK1REbE91YmNwaVJhYnpPVUdSQ2lp?=
 =?utf-8?B?QTBQakZRVjM1Rit6K2tQbGdEVFpMR0tJR2o4OTRQeVF3OUE1Mmo1b2NoVS80?=
 =?utf-8?B?VTlNNDIzcHV0VGFlV3VzZGIvZUFwMmdleCtBaGt0WlZ1cFZhaUFacTkxNFY4?=
 =?utf-8?B?YTZBUHBESUtvTnV3NXN3YWVsak1pSnNiSjUwN2kvdEhMRW91M29vL3ZCZnFP?=
 =?utf-8?B?d0lUTVB4ZTNyTnZkVzVTV1hZSFg1enp2YkR0V2RLajBreEJMZFVucmlwQjJG?=
 =?utf-8?B?cVB6elBzeG02TTdKRE8zVEx3MzE0dlJRM0VIZHVjMEMxVmwvTDVGWEZoa2I5?=
 =?utf-8?Q?J6EABOh0hciAUZvGFl3S3EaLtHqLzHpGZv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B486B5849DCB164085D6BF0BA839F128@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR05MB7275.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d94b8f0-39b7-4bcd-a040-08d89771ac67
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 09:56:15.1410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ijt6WPeNj32oQzqAsrkEygKdo5TwTdIS35q8NF22G4T+CiPVNMxOR5WkQ5W8RP3kcugoYPAKoHmtNwKWIOkMQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3870
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_06:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012030059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIERhdmlkIGZvciB0aGUgcmVzcG9uc2UuDQpPdXIgbG9jYWwga2VybmVsIGRvZXNu4oCZ
dCBoYXZlIHZyZl9pcDZfb3V0X2RpcmVjdCBwYXRjaC4gSSB3aWxsIHBpY2sgdGhpcyBjaGFuZ2Ug
ZnJvbSB1cHN0cmVhbSB0byBmaXggdGhlIGZpcmV3YWxsIGlzc3VlLg0KDQpUaGFua3MsDQpQcmVl
dGhpDQoNCu+7v09uIDAzLzEyLzIwLCA1OjQyIEFNLCAiRGF2aWQgQWhlcm4iIDxkc2FoZXJuQGdt
YWlsLmNvbT4gd3JvdGU6DQoNCiAgICBbRXh0ZXJuYWwgRW1haWwuIEJlIGNhdXRpb3VzIG9mIGNv
bnRlbnRdDQoNCg0KICAgIE9uIDEyLzIvMjAgNDozMSBBTSwgUHJlZXRoaSBSYW1hY2hhbmRyYSB3
cm90ZToNCiAgICA+IEhpIERhdmlkIEFocmVuLA0KICAgID4NCiAgICA+IEluIFRDUCBlZ3Jlc3Mg
cGF0aCBmb3IgaXB2NiB0aGUgZGV2aWNlIHBhc3NlZCB0byBORl9JTkVUX0xPQ0FMX09VVCBob29r
IHNob3VsZCBiZSBza2JfZHN0KHNrYiktPmRldiBpbnN0ZWFkIG9mIGRzdC0+ZGV2Lg0KICAgID4N
CiAgICA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2VsaXhpci5ib290bGlu
LmNvbS9saW51eC9sYXRlc3Qvc291cmNlL25ldC9pcHY2L2lwNl9vdXRwdXQuYypMMjAyX187SXch
IU5FdDZ5TWFPLWdrIVRURU1JcjZZX3FpT3pfUVkzX0ZoNFFuUmdseEhFZnUxbXdvU29fU3ZlX1E2
cmRwbUNNYWYzbDhaQ0JOQW5ONFckDQogICAgPiBzdHJ1Y3QgZHN0X2VudHJ5ICpkc3QgPSBza2Jf
ZHN0KHNrYik7ID4+PiBUaGlzIG1heSByZXR1cm4gc2xhdmUgZGV2aWNlLg0KICAgID4NCiAgICA+
IEluIHRoaXMgY29kZSBwYXRoIHRoZSBEU1QgRGV2IGFuZCBTS0IgRFNUIERldiB3aWxsIGJlIHNl
dCB0byBWUkYgbWFzdGVyIGRldmljZS4NCiAgICA+IGlwNl94bWl0LT5sM21kZXZfaXA2X291dC0+
dnJmX2wzX291dC0+dnJmX2lwNl9vdXQgKFRoaXMgd2lsbCBzZXQgU0tCIERTVCBEZXYgdG8gdnJm
MCkNCiAgICA+DQogICAgPiBIb3dldmVyLCBvbmNlIHRoZSBjb250cm9sIHBhc3NlcyBiYWNrIHRv
IGlwNl94bWl0LCBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9lbGl4aXIuYm9v
dGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMqTDI4MF9f
O0l3ISFORXQ2eU1hTy1nayFUVEVNSXI2WV9xaU96X1FZM19GaDRRblJnbHhIRWZ1MW13b1NvX1N2
ZV9RNnJkcG1DTWFmM2w4WkNEY1piZnlJJA0KICAgID4gU2xhdmUgZGV2aWNlIGlzIHBhc3NlZCB0
byBMT0NBTF9PVVQgbmZfaG9vayBpbnN0ZWFkIG9mIHNrYl9kc3Qoc2tiKS0+ZGV2Lg0KICAgID4N
CiAgICA+IHJldHVybiBORl9IT09LKE5GUFJPVE9fSVBWNiwgTkZfSU5FVF9MT0NBTF9PVVQsDQog
ICAgPiAgICAgICAgbmV0LCAoc3RydWN0IHNvY2sgKilzaywgc2tiLCBOVUxMLCBkc3QtPmRldiwg
PDw8PCBTaG91bGQgYmUgc2tiX2RzdChza2IpLT5kZXYNCiAgICA+ICAgICAgICBkc3Rfb3V0cHV0
KTsNCg0KICAgIFRoZSB2cmYgZGV2aWNlIHZlcnNpb24gb2YgdGhhdCBjYWxsIGlzIG1hbmFnZWQg
YnkgdGhlIHZyZiBkcml2ZXIuIFNlZQ0KICAgIHZyZl9pcDZfb3V0X2RpcmVjdCgpOg0KDQogICAg
ICAgICAgIGVyciA9IG5mX2hvb2soTkZQUk9UT19JUFY2LCBORl9JTkVUX0xPQ0FMX09VVCwgbmV0
LCBzaywNCiAgICAgICAgICAgICAgICAgICAgICAgICAgc2tiLCBOVUxMLCB2cmZfZGV2LCB2cmZf
aXA2X291dF9kaXJlY3RfZmluaXNoKTsNCg0KDQpKdW5pcGVyIEJ1c2luZXNzIFVzZSBPbmx5DQo=
