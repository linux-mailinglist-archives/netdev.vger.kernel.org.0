Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA0B2CBC58
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgLBMEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:04:53 -0500
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:16516 "EHLO
        mx0a-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgLBMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:04:51 -0500
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 07:04:50 EST
Received: from pps.filterd (m0108158.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2BTfRj007302;
        Wed, 2 Dec 2020 03:31:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=AH3N1nyob2aAZAIrZbDrQsZ1/tbzL11z1JQIjIXnJ0o=;
 b=xLP0JrgKMa0HSR3kuKaRuWAapwUe/woEQ27gU/lzcrGF1WV4v1fPv6zXQ0KpPbhnsNnm
 hZLa65vnKU0EbmPCAXOpqoi1lP2f5971Au9zHIjw80gb4c14xI+0z2plNYDfG+mgoOsl
 FlZ5zojk1oEa6rtwT3YwWcEXLEb/e1KILQyXQrMmGK9QPZ5rv4O3UD2dClsitjkW3muX
 1vUu4f6yT6DOj4+CcrDQ9nQeTiIqMy1lUpwV4a0cXWuHoMbns01rfM9WEFdVGUP2gLmc
 XyyrZKCcnNySgrOqYP4Q6WefaWhqjwmuw6dz7sBqKoyWru4nZISw/fCiHV7FEAWaoiIw YQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-00273201.pphosted.com with ESMTP id 355vhr9b0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 03:31:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIN6FQ0PACDC7xa/G0AgJn594asKttOlu0tWYk7wBdg0AMQ3W1Vs4SoyTJmzIYxzQqEsA7jNpATHlazzGz2LbCF86CQ6zVbvfm6sGC9Vcv7Put3cf3ujPb+d7PrjMQEVyaFPvJLtyxZw5b5+mUjeCixfC49Ar8lBHMR0s4aLrKQsDCANjjaU5gX9iX0GXSWOTpH2mg64rerf4+m9kYS1XrsD8VKbXAMIa0yclZ/upajhAjTN6e8ryb8/1kAw4HBhyfzZFWdUtgBvGNvyOLvNWInEek18eSiafbnLPcCAO2tHL5crY3SzgDkFcfuQUjAgaGCOoDhwj1ZZxHUq8jvYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH3N1nyob2aAZAIrZbDrQsZ1/tbzL11z1JQIjIXnJ0o=;
 b=CGW+2Af9kcj3V5o7xGmR/5jAS3RBBVs4DCJzQEwY+H0kXD6vISGg1nkCJCeH/XmFIllVShSWsVNt5S4OCiasuC/arflLC2idJZkOw1L1nNU4k9E2qkrGc+O6FvEupLJzCO9i8lORQhvm4UxK+6Mrhr9Bpna9KvvUe3iQL6xJFLWiRypn8CmTeFGi2GwUiftuTqlYIWxW9z6CEKKDJpGMFcl8q9VEmXoXGN3Lurw3vytUOIsYYlafxj0lBnNFm9PKZTVAaqzBlJX5LMk9QBjpwK4v7yxLZxJB/45+nCEl//3kacrJPHAUPY6/QRpXSFH1iZ+enr2npbHsz6Pvi4z3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH3N1nyob2aAZAIrZbDrQsZ1/tbzL11z1JQIjIXnJ0o=;
 b=DZia+HMgu/WVjSe0dOMV5gO97H69c9TwiXjoqSQqPBVNwwCxxLyEe/iE15ynB/5TsCW9m+OcbYR1fB9PM6NoDsOFxB0IwhDeiav6tjl6K4dYFiWZOUFpbMTEq0TN1bmk+V/1BKQfNOen2/y9tsNtYYeW3i2xIDDG3U/YOxGM2zs=
Received: from SA0PR05MB7275.namprd05.prod.outlook.com (2603:10b6:806:bb::9)
 by SN7PR05MB7728.namprd05.prod.outlook.com (2603:10b6:806:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5; Wed, 2 Dec
 2020 11:31:42 +0000
Received: from SA0PR05MB7275.namprd05.prod.outlook.com
 ([fe80::8c45:d5a1:7fc9:230f]) by SA0PR05MB7275.namprd05.prod.outlook.com
 ([fe80::8c45:d5a1:7fc9:230f%9]) with mapi id 15.20.3632.006; Wed, 2 Dec 2020
 11:31:42 +0000
From:   Preethi Ramachandra <preethir@juniper.net>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jimmy Jose <jimmyj@juniper.net>,
        Reji Thomas <rejithomas@juniper.net>,
        Yogesh Ankolekar <ayogesh@juniper.net>
Subject: Linux IPV6 TCP egress path device passed for LOCAL_OUT hook is
 incorrect
Thread-Topic: Linux IPV6 TCP egress path device passed for LOCAL_OUT hook is
 incorrect
Thread-Index: AQHWyJ61jWvdoGeWyEK5V+lOSzNoZg==
Date:   Wed, 2 Dec 2020 11:31:42 +0000
Message-ID: <3D696DFB-7D22-44A6-9869-D2EFDEBDDEEB@juniper.net>
Accept-Language: en-029, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=0;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=ce0ca94c-f9cf-4672-9149-9f7c0ec22fa7;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2020-12-02T10:53:40Z;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=Juniper
 Business Use
 Only;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=juniper.net;
x-originating-ip: [116.197.184.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b5eb1d9-958e-4879-3b2a-08d896b5d7d7
x-ms-traffictypediagnostic: SN7PR05MB7728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN7PR05MB7728E45B0CBE32384D81BB91D1F30@SN7PR05MB7728.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxLNzhwXg3cz68FZv3TxE/6DeHxBYcbqH3bDXDkBsybDVV13jKnQHZ2Axfw+InoNYE8NIM6I6hwwfIgJKf5Yy/7yiy4MCtkpPZPNTYIpTQu/17M8ZyMnNpQNHVJabAqT2lKqWct3GQb/rN74h0dQiuP5PTKz/viQVY6nvBheEOQUjWc7TtK3CoKT+1O1bUDOHOqiOKsy4dW9TFLD4q2+7TttGepJaDhX+W5dUJtoIwn1DW7eNfLlT+6GAAXQMHppCn+D8bSjbFYa81zzkJAcOP/9TX6OiBL0/ievryOD3zSJOmtfQszdY6GiaqMYOuT2VhZR+gdncUnzzf9bZJoClErhRFaz9IVQlaZnORYGiemRcp4OWk6bfRikoOU3/Nhyb6daLqJduFWvg0YZot2DRDFCJ9TtG6ckC96xOURbZC4DAjSBEnJq/NZGXJpUED4glxqDkMSrMpGMm7+1A5z++w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR05MB7275.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(36756003)(186003)(66946007)(6486002)(91956017)(6512007)(33656002)(19627235002)(8676002)(5660300002)(26005)(66476007)(66556008)(316002)(76116006)(6506007)(64756008)(66446008)(107886003)(86362001)(2616005)(966005)(71200400001)(4326008)(8936002)(110136005)(2906002)(54906003)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WnlvZXFTdmtTbVNtWUdjNjA3VTdmSTVHWXJpTE4rMHFvZGlPNUprd3NBbkhs?=
 =?utf-8?B?aXZ5QW5LeFN3MkVDYUY3NWxxdmF3Ulo4Z2YvMVlMVEU3RllGMWRSeUlqZGRu?=
 =?utf-8?B?bEszMXBIMkF5TlRmRkdNTVVEelFDb1Z5N3NML1BMV3FYN2V6aDlWOVc5Tzda?=
 =?utf-8?B?MHFFbHNpRWlYbEhmQmZ5V1d2aTYyNGhrNTRGOC9DczBzOHJ1Z2Z2L1FSZ1ZW?=
 =?utf-8?B?MEh1am9rWTRQdzFZbFVZTE1MUitEQXJKVGFBWFJ2QmpQZjRLcVhkUXU0MlU2?=
 =?utf-8?B?YS9iYVVpTVpsdFhpUXZwVDlzQnhMUXFmNE1aYzg2Sk1QenJTbWlkK01GSnpG?=
 =?utf-8?B?UThvREFJOWRUN3ZSb2xmVHFiNUdtNHowbERIVDVmMWFJekxUSm5Ieit0TXJL?=
 =?utf-8?B?ckVwVXdsMWFmUE9zbTBkVHVnZDNIVXdRNUtUTmNHWnRmdkc0QUVQL0ZOdmhN?=
 =?utf-8?B?MDFoNjF0anBLWTg4Znc5R29JNjRTNWlSNzg1UkRuZVczRjlxQVRhT214WU5S?=
 =?utf-8?B?TVhDclhRdUNBSWpqdFFtTWxmbUd4VWg2dHlwVDZiRURQL3lobWpGMGhUWGha?=
 =?utf-8?B?Z0VXeHpmNXVTOWp2UnY2NUJlVE9EN2x6SzNIUjNxTk5VOHF2SGJybE92VHRC?=
 =?utf-8?B?cWkvTlI5dERFUm52VWt4cjFMOUx4RmtQZll5VVQ0VzlpRDRZQXhsNi9MMVdo?=
 =?utf-8?B?bG1LeXh5OTYwMzVDSDdmNjdtMzd0dlQyMTkwaG1ERUNLaDYwYkoyKzRPQTk2?=
 =?utf-8?B?KzVjc3UyTExGMmxWRzh5Zm9RaC9taWNqSTBQYTJtcTRzNmJDVGw4by81OGNY?=
 =?utf-8?B?OFRwazFjZytFM0dSOTIweDlzaFpiaHYvcnBLVDZXSHdXaWZmSFBUMUh2bzYz?=
 =?utf-8?B?UVhyV0ZjbUlBZitKSys4OVVaZC9uSExLWjh3OVF4Wjl4QVJEMjdtbVR4UDZs?=
 =?utf-8?B?MmZLS3dzNW1GRUdWbllXQldHTHBXaWpkTkM4ank1ZkFnbG5JSzNLa3dtRGYw?=
 =?utf-8?B?Uk5jQUM2clhUU0tTUVlBeWtiQTQyYXp1bE1wY2VhL3l6aUJuUWw1TW5VRW1u?=
 =?utf-8?B?YzYzcmdiVHR6TGhGY0xyaFRhSkhxWWFpdm9Cb3VvOGNId2xRRW1URk1SZ1lO?=
 =?utf-8?B?elhmVWxRUHp5WDNKZkdZZGNoRWhtb0RhL2pyV3dTVVFDOEN4OGMremw3UmND?=
 =?utf-8?B?dURKN3RnejNsNEp0dU5pWElvSWc2QThyMzV1Um5Nb0tFWC9wMjBTWU51OFpI?=
 =?utf-8?B?WURRNU9vNWl5bjd5ZytRR1EyQzE3dmVISzJlSkE2cm94UWdZMGwyR1ZDT1Ey?=
 =?utf-8?Q?HLU1AkLPJUWTRt0LbxObHcfluf3XzpmKK+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54D64944D2C3E14984E49056A51931A9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR05MB7275.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5eb1d9-958e-4879-3b2a-08d896b5d7d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 11:31:42.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMSfcHbf1Q2eDEVf3wDI3OaVU2ig/+5xabZ/M+UXPBVI1WCHKdd8kPNuQwWCqYSqhyJjnrDU3hSoTtFFS3VglQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB7728
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_04:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 mlxscore=0
 adultscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=922
 clxscore=1011 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012020069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQgQWhyZW4sDQoNCkluIFRDUCBlZ3Jlc3MgcGF0aCBmb3IgaXB2NiB0aGUgZGV2aWNl
IHBhc3NlZCB0byBORl9JTkVUX0xPQ0FMX09VVCBob29rIHNob3VsZCBiZSBza2JfZHN0KHNrYikt
PmRldiBpbnN0ZWFkIG9mIGRzdC0+ZGV2Lg0KDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9s
aW51eC9sYXRlc3Qvc291cmNlL25ldC9pcHY2L2lwNl9vdXRwdXQuYyNMMjAyDQpzdHJ1Y3QgZHN0
X2VudHJ5ICpkc3QgPSBza2JfZHN0KHNrYik7ID4+PiBUaGlzIG1heSByZXR1cm4gc2xhdmUgZGV2
aWNlLg0KDQpJbiB0aGlzIGNvZGUgcGF0aCB0aGUgRFNUIERldiBhbmQgU0tCIERTVCBEZXYgd2ls
bCBiZSBzZXQgdG8gVlJGIG1hc3RlciBkZXZpY2UuDQppcDZfeG1pdC0+bDNtZGV2X2lwNl9vdXQt
PnZyZl9sM19vdXQtPnZyZl9pcDZfb3V0IChUaGlzIHdpbGwgc2V0IFNLQiBEU1QgRGV2IHRvIHZy
ZjApDQoNCkhvd2V2ZXIsIG9uY2UgdGhlIGNvbnRyb2wgcGFzc2VzIGJhY2sgdG8gaXA2X3htaXQs
IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvbmV0L2lwdjYv
aXA2X291dHB1dC5jI0wyODANClNsYXZlIGRldmljZSBpcyBwYXNzZWQgdG8gTE9DQUxfT1VUIG5m
X2hvb2sgaW5zdGVhZCBvZiBza2JfZHN0KHNrYiktPmRldi4NCg0KcmV0dXJuIE5GX0hPT0soTkZQ
Uk9UT19JUFY2LCBORl9JTkVUX0xPQ0FMX09VVCwNCiAgICAgICBuZXQsIChzdHJ1Y3Qgc29jayAq
KXNrLCBza2IsIE5VTEwsIGRzdC0+ZGV2LCA8PDw8IFNob3VsZCBiZSBza2JfZHN0KHNrYiktPmRl
dg0KICAgICAgIGRzdF9vdXRwdXQpOw0KDQpUaGlzIHdpbGwgY2F1c2UgYSBidWcgaW4gZmlyZXdh
bGwgZmlsdGVycy4gbmZfaG9vay0+aXA2dGFibGVfbWFuZ2xlX2hvb2stPmlwNnRhYmxlX2ZpbHRl
cl9ob29rIChEZXZpY2UgcGFzc2VkIGlzIHNsYXZlIGRldmljZSkuIElmIHRoZSBmaXJld2FsbCBm
aWx0ZXIgcnVsZSBpcyBjb25maWd1cmVkIHdpdGggZGV2aWNlIGFzIFZSRiBpdCB3aWxsIGZhaWwg
dG8gYXBwbHkgdGhlIGZpbHRlci4gQXMgcGVyIExpbnV4IGRvY3VtZW50YXRpb24gZmlsdGVycyBz
aG91bGQgd29yayBmb3IgVlJGIGRldmljZXMuDQoNCkZpcmV3YWxsIFJ1bGU6DQoNCmlwNnRhYmxl
cyAtQSBPVVRQVVQgLW8gdnJmMCAtbSBjb21tZW50IC0tY29tbWVudCBGLW91dGVyNl9ULUItbG8w
X0ktMTAwMSAtaiBvdXRlcjYgKG9yIC1BIE9VVFBVVCAtbyB2cmYwIC1tIG1hcmsgLS1tYXJrIDB4
MTAwMDAwMCAtbSBjb21tZW50IC0tY29tbWVudCBGLW91dGVyNl9ULUItbG8wX0ktMTAwMSAtaiBv
dXRlcjYgKFJ1bGUgZmFpbHMgdG8gYXBwbHkgZm9yIFRDUCBwYWNrZXRzKQ0KDQpMaW51eCBmaXJl
d2FsbCBkb2M6DQoNCmh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL0RvY3VtZW50YXRpb24vbmV0
d29ya2luZy92cmYudHh0DQoNClsyXSBJcHRhYmxlcyBvbiBpbmdyZXNzIHN1cHBvcnRzIFBSRVJP
VVRJTkcgd2l0aCBza2ItPmRldiBzZXQgdG8gdGhlIHJlYWwNCiAgICBpbmdyZXNzIGRldmljZSBh
bmQgYm90aCBJTlBVVCBhbmQgUFJFUk9VVElORyBydWxlcyB3aXRoIHNrYi0+ZGV2IHNldCB0bw0K
ICAgIHRoZSBWUkYgZGV2aWNlLiBGb3IgZWdyZXNzIFBPU1RST1VUSU5HIGFuZCBPVVRQVVQgcnVs
ZXMgY2FuIGJlIHdyaXR0ZW4NCiAgICB1c2luZyBlaXRoZXIgdGhlIFZSRiBkZXZpY2Ugb3IgcmVh
bCBlZ3Jlc3MgZGV2aWNlLg0KDQpDb21wYXJpc29uIG9uIGRldmljZSBwYXNzZWQgdG8gTE9DQUxP
VVQgaG9vayBmb3IgSVBWNCBUQ1AgYW5kIElQVjYgcmF3L3VkcCBzY2VuYXJpb3MuDQoNClRDUCBJ
UFY0IGVncmVzcyA6IEluIF9faXBfbG9jYWxfb3V0IHRvIE5GX0lORVRfTE9DQUxfT1VUIHNrYl9k
c3Qoc2tiKS0+ZGV2IGlzIHBhc3NlZC4NCg0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGlu
dXgvbGF0ZXN0L3NvdXJjZS9uZXQvaXB2NC9pcF9vdXRwdXQuYyNMMTE1DQpyZXR1cm4gbmZfaG9v
ayhORlBST1RPX0lQVjQsIE5GX0lORVRfTE9DQUxfT1VULA0KICAgICAgICAgICAgICAgICAgICAg
IG5ldCwgc2ssIHNrYiwgTlVMTCwgc2tiX2RzdChza2IpLT5kZXYsIDw8IHdpbGwgYmUgc2V0IHRv
IHZyZjANCiAgICAgICAgICAgICAgICAgICAgICBkc3Rfb3V0cHV0KTsNCn0NCg0KUmF3L1VEUCBW
NiBlZ3Jlc3MgcGF0aDogc2tiX2RzdChza2IpLT5kZXYgaXMgcGFzc2VkIG9udG8gTkZfSU5FVF9M
T0NBTF9PVVQNCg0KcmF3djZfc2VuZG1zZy0+IGlwNl9zZW5kX3NrYi0+IGlwNl9sb2NhbF9vdXQt
PiBfX2lwNl9sb2NhbF9vdXQgKExPQ0FMX09VVCBob29rLCBkZXZpY2UgcGFzc2VkIGlzIFNLQiBE
U1Qgd2hpY2ggaXMgVlJGKS0+bmZfaG9vay0+IGlwNnRhYmxlX21hbmdsZV9ob29rLT5pcDZ0YWJs
ZV9maWx0ZXJfaG9vaw0KDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qv
c291cmNlL25ldC9pcHY2L291dHB1dF9jb3JlLmMjTDE2Nw0KDQpyZXR1cm4gbmZfaG9vayhORlBS
T1RPX0lQVjYsIE5GX0lORVRfTE9DQUxfT1VULA0KICAgICAgIG5ldCwgc2ssIHNrYiwgTlVMTCwg
c2tiX2RzdChza2IpLT5kZXYsDQogICAgICAgZHN0X291dHB1dCk7DQoNClRoYW5rcywNClByZWV0
aGkNCg0KDQpKdW5pcGVyIEJ1c2luZXNzIFVzZSBPbmx5DQo=
