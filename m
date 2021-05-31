Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA839575E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhEaIuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:50:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhEaIuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:50:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14V8dmHJ101309;
        Mon, 31 May 2021 08:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gH7BkkkyDV2QJxfuDGpq+es1/+TKWWMwj+JSFKf/R80=;
 b=eUz8uSQo2+zK9PnXbRPMaZYiA2QttdFKfyEvugSj6kITqHTfQ2oXKF+YXGW2LNDqd4B7
 o/9K+sY3HbhqTmYNVPhRcTOpjNFMclbwgoqhO/EDUhiF0rtklTaC1fTrNicdlgrYLlIf
 EHK76/lS7BPRFpCeriTypgAVPkUOHnhJEQWxOA6gxlnAs4nCWEth1umctQm73WvPE7Gu
 vG96/F+0nR30NhJZcz9Y9H1/5CIoqAo8ycNtyhdqvv5+F8MZLQQqLXq4nZxWoGzLpPdS
 esZH1BrjCrZNi91E2UEh8il/kPb4QlmEdlHPXR/76awPJiuF1P+NvAncLaOoM7EmTyHQ 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ue8paj3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 08:48:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14V8kdUL080232;
        Mon, 31 May 2021 08:48:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 38uycq7ayc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 08:48:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYSNp98UQHfz+2YaaByi4SN2yC7fVhse8vpKotqv+u8MKA78dSQO4WvxYpUydqvPAS8JHLiIG1xEs2C3WU99gphOO5ytgkRaK6u8y2DFXpZKZIzSu7C+bp2JclDgLixufTQqmwENSt3Uvj5QeqNkuT0OYtA4QJIY/J7GGZA+0ap+ZYma2v7L04HDfp6dIvrNTt0PSTbokfanCs/A+3b6LNitjxossupO/TBz2/xHCzJbRBxN3apquCS9q9IZl4Ph/T1nbWtf/tCcQKiSSs6AGrkTrlc0NEUca0YxCeQQUXdnLqZFmDbEkVLS2DOw/JmndtVXLnPT50ssXOJMPkAkCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gH7BkkkyDV2QJxfuDGpq+es1/+TKWWMwj+JSFKf/R80=;
 b=fwfZzdQYFq4WjbyrVz+BRKbPNPzN59dX+eKsQH8rY9K/T5H6d1uYw5p810JK1vcJ+VM+cbILSTSBoNCVgMYq++m+ED9iGglOxuyp/yRPReUOUtZfevVC4bl7phexBTV3RnFmyGKZphQtJbTwNLfbzGhyPw4bwKpoA+492diGOvNIuYiYDJRsvNj3SS6+a4UiBx1TXE3/ZD04GLTF6LcoV1Y8qwNGFEXfiVPNlyPQKUcQZjby4n0teRcS3Ty7/J1sd1mJWTMLDoKzRh+H/23/1SZD+bOwJiv8PMXUDaYjk8H9jZRlj2mq95RZLVGeE2MJK7IwoZGJ53eCRdK4ePLwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gH7BkkkyDV2QJxfuDGpq+es1/+TKWWMwj+JSFKf/R80=;
 b=Ux/eKEDbCGv4hGD415QR3bb8RoIl6tsJo6A8N9Y6iyGn0aV3kDmUvF9x5UgVJ2/PzQCqcGviS7DxObiGmPiS7SBFseWV7EEr6olD7IAovE2cI2xGCh7ayCng2VFJPMpJqWsdX7EHbFuXK9et6JRwbWq8H1JCaqICPTUa5N4Xw0w=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR1001MB2213.namprd10.prod.outlook.com (2603:10b6:910:44::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Mon, 31 May
 2021 08:48:14 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3%8]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 08:48:14 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH net-next] rds: Fix spelling mistakes
Thread-Topic: [PATCH net-next] rds: Fix spelling mistakes
Thread-Index: AQHXVeVhWuhzB5AqSEmC/QHQGKIVSKr9R5aA
Date:   Mon, 31 May 2021 08:48:13 +0000
Message-ID: <99448616-D9CB-4A83-B8E3-8F8641868289@oracle.com>
References: <20210531063617.3018637-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210531063617.3018637-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5be53694-8bbc-4025-9e21-08d92410d3c7
x-ms-traffictypediagnostic: CY4PR1001MB2213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1001MB2213179671642BBD900334BAFD3F9@CY4PR1001MB2213.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +aZvvE99W3RLok58wVcd70L4LtCQim3eViHzsBVlUcdqF5IAW93o/zhHKFShAE3xSMxFV7ZZF3Xpm5gEDA6z5IYmXr+HVpe/gqgqLuBp3we7HRa0HKEd1vMXorHlnsUJEdiSYZRSFyT1VkPtek+2Rd4zSkwJ0aswEe78ZSSYkrnMbQj8Hc0TJH8WqckL5Sntu5jS6UfkoE7nnb4RlctDZ2thIWctHUvtSnhQJbREhR0akVfz9At+8FRaChNYQsjJPr+Ciag8uAyng5HFxtbsi1RCB5VBesK0FL+2kApALkxwFZBfzHfZMSIEf4VmumjxrDqYujb575MZro96eZ3k1i73e92TOwApMe48h/SMcwETA+BTZujQFdiKgWzmviA8YTLV56tW9eRv7K19rMXRgRYD92N4bd+k6/IRXIX/31DcvnRAonqRn7F3XNsKYWYFw6Hk8o6cpOH5wmdfsVT8ROsgFa5ogi2PB74NU/K9gYW1O+yLDmJrIEV0dFNio2e2qfnAFFg/x9/11Nb779/ubpn5rMEdrRv/Lkm/Y68l9/+QVRLtd3kMctq3iTAwXddFJmx6A/6X8VmSytWPOZtM8Ch9XtkRijn6NXohCZOiVRaqcR72kww8pDNY5nPMe6ivCvQw27MT18QMKylVs37nl3q4ayT8MdNeYJ7Il2I6xi4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(107886003)(66946007)(6506007)(53546011)(316002)(86362001)(8936002)(66476007)(33656002)(66556008)(44832011)(186003)(66446008)(64756008)(26005)(6512007)(54906003)(8676002)(83380400001)(36756003)(71200400001)(122000001)(478600001)(91956017)(38100700002)(5660300002)(76116006)(2906002)(2616005)(6916009)(6486002)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T29hQWlqbjd0YnVtZUE1ajlDV1RpL01uQkU3dW5kSTkyQWlMQk5IVTZFNGlI?=
 =?utf-8?B?WFFrc2l0RmxzNHVtaEZ2WGFhV25vZGlENmpnTGh3eVJkRm9Wajl2bkpzN1N3?=
 =?utf-8?B?dS9BUVNqWDNhck1iTndSeUJjQ1BpbTNKbm92eHFTd21WSmNaS3dYWTNWdlpQ?=
 =?utf-8?B?TUZ0dUlqUzN1SW9VdE5YN0pXd0RNV2diZ2RVNVpXTC9DMEVPOURwT24zc1Mz?=
 =?utf-8?B?YThOVURnSWpZT2hjUHJRNWdacjZpNmtlNFBsUnV2R0Z5Vzd4YWkrbCtIeDJz?=
 =?utf-8?B?aXptdlBHV1YwdEw4eFJNbEJBaWh2c3ZZWXNLUVVPbGJBcGlJcnlxeXBDS0ZH?=
 =?utf-8?B?U0ZKTGtDUVVPcG1icWV3bnZ4N1J6Q2dLWTZGaGUzWG12dWpRV0paeS8wczFK?=
 =?utf-8?B?YkJhTUI3NE1ZUWdyQ3BIakJ0aW1LOXZPZVlkZXVlU3k0WEhCUUc2OWluMjBk?=
 =?utf-8?B?cm9ZZVJUKzlZbFFwTWxjbVFkeHFDUjlLYUdDZm9FSEdBS2V4QXBHYjJtSGI4?=
 =?utf-8?B?OWRIUDdTc3c5bnJVWERmM2h0d3RxSnk1YzEvRjFtN1lCYXRHNFdjQ040dkZY?=
 =?utf-8?B?aUtpOHZNNjFpUE9VcUxlL3o1ZGkvNHBndGFCN3J2R3BpTFVpaHl1YTRBeFhS?=
 =?utf-8?B?YkFDa1gydVNqanB4LzdoaEtZajlJbjd2Nkw1WnJCdVZNaWg1NGVPd0xFdkVy?=
 =?utf-8?B?R1FQbTZqYzJVWjFOWm9sYkErRlZva3Z3WEZGK1BhbjVQdHdDOGRmSGxJNEQ1?=
 =?utf-8?B?QlFhcnRzT2pWZDF5N0dWUzhVOUZKSGZRTEJ0aWdCL1YyNnZRQm9CdWloRG5Y?=
 =?utf-8?B?UFZDSWFZY2lpMTh6cTR6SmVMb0xvNmJrcXRZZFBNL0MrbzlYTWt6aEdQb3Zt?=
 =?utf-8?B?eldXd0RRRks2c1dPTEJ6WVFpRmhtQW8vYjVQVmhzYkJkN2FSem0yczBUTnlG?=
 =?utf-8?B?SWJMTU1ocHJNQzdlUk14YUFMRWZIdG5sSWhWNFI1OHNJeHdJUFg3VWxMV0lB?=
 =?utf-8?B?ejdOcXNTK2oySG1OT0c0blVtUFgvNjkxTkhMN2hkZEFETW1LYUdJVXZuMjM1?=
 =?utf-8?B?K1Q4UTBpQ0YxRDQwaDdtaXJmSFN2UmNBMUlwR1JWL3c4NDY0M1I0Q2lYSjFL?=
 =?utf-8?B?a1cyRWcvYytQRmJIQzc2ckt2d3dEL1dLYldocXVkNUNjY0xxQ3Vjc0Q4TGhC?=
 =?utf-8?B?bjI4ZmhOUVlER3BJeHRSbXloZ1M5SmRhQjkyNjZ3cE9kMnRocTc5a0VsWkpX?=
 =?utf-8?B?ODFUUTBRbUd5dHRaZVJ0cjFsRUdnTEE0K1d2SGV6eTFsZ3I0c0ZjbzdzMG5S?=
 =?utf-8?B?UVNUZHc0SmE1b3VoTXlpMWZ0OHNWa29pNVVUMEdUU2NiZUhLMHdmSGNMcDFI?=
 =?utf-8?B?SFZRUGhLdkwyOVE3cmkxUlRkTjBqaGxKNEpvT1hHN1hqanNrc2xJbXNreE94?=
 =?utf-8?B?OCt0di9icnNibUpmMzc1V1JIYkx6TzJxZ0VDdXZMRDhMTEF1NGhNY0ZRTHpH?=
 =?utf-8?B?bFY2ZFZRbkJkcldER2wxdmlLK01KV2NVL1BjWHFnQmxrSmFVa1c3RDFOTG9u?=
 =?utf-8?B?L2hMdzBsU2hNbng1SUt1dXdRSHcvUjNmeUlrTEc2bTVWRWlWT0pCdmFTRWNi?=
 =?utf-8?B?b3ByaG1aMW9ISkFWcDlNbW5BTnk4Mkh1bXMzMXBBajF0aWRISDQrYUVXSTEr?=
 =?utf-8?B?andrRGZSYmFSejBXZk04RE1SaG1ucEdBRmM3TEdlQmlaeEZma25CekVROC9H?=
 =?utf-8?B?bExFTk5UVCt4YUZEenJTTUhLVGJIaFFKWEd2SGl1YWhTdnpWV0tzSWJybFVw?=
 =?utf-8?B?SStrUzZDcnA2K1BURHo3QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7697585FAE3AC242B289BA0FDE0599C5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be53694-8bbc-4025-9e21-08d92410d3c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 08:48:13.9577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qsuev+eWQCGTDS6DmJiDgXXOa1rouqQ6uvP6bFYeucdzpuvAmENwDVTVBtNwc0rYl8SXw/Fz4HGZkW9Zfl0T9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2213
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10000 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105310063
X-Proofpoint-GUID: V00f4MMOLXGwwVsqC1_Y09GTg985GXuW
X-Proofpoint-ORIG-GUID: V00f4MMOLXGwwVsqC1_Y09GTg985GXuW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10000 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105310062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMzEgTWF5IDIwMjEsIGF0IDA4OjM2LCBaaGVuZyBZb25nanVuIDx6aGVuZ3lvbmdq
dW4zQGh1YXdlaS5jb20+IHdyb3RlOg0KPiANCj4gRml4IHNvbWUgc3BlbGxpbmcgbWlzdGFrZXMg
aW4gY29tbWVudHM6DQoNCkZpeCB0d28gc3BlbGxpbmcgbWlzdGFrZXMuDQoNCg0KDQo+IGFsbG9j
ZWQgID09PiBhbGxvY2F0ZWQNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpo
ZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT4NCg0KTEdUTSwNCg0KUmV2aWV3ZWQtYnk6IEjDpWtvbiBC
dWdnZSA8aGFha29uLmJ1Z2dlQG9yYWNsZS5jb20+DQoNCg0KPiAtLS0NCj4gbmV0L3Jkcy9pYl9y
aW5nLmMgIHwgMiArLQ0KPiBuZXQvcmRzL3RjcF9yZWN2LmMgfCAyICstDQo+IDIgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L25ldC9yZHMvaWJfcmluZy5jIGIvbmV0L3Jkcy9pYl9yaW5nLmMNCj4gaW5kZXggZmY5N2U4ZWRh
ODU4Li4wMDZiMmU0NDE0MTggMTAwNjQ0DQo+IC0tLSBhL25ldC9yZHMvaWJfcmluZy5jDQo+ICsr
KyBiL25ldC9yZHMvaWJfcmluZy5jDQo+IEBAIC0xNDEsNyArMTQxLDcgQEAgaW50IHJkc19pYl9y
aW5nX2xvdyhzdHJ1Y3QgcmRzX2liX3dvcmtfcmluZyAqcmluZykNCj4gfQ0KPiANCj4gLyoNCj4g
LSAqIHJldHVybnMgdGhlIG9sZGVzdCBhbGxvY2VkIHJpbmcgZW50cnkuICBUaGlzIHdpbGwgYmUg
dGhlIG5leHQgb25lDQo+ICsgKiByZXR1cm5zIHRoZSBvbGRlc3QgYWxsb2NhdGVkIHJpbmcgZW50
cnkuICBUaGlzIHdpbGwgYmUgdGhlIG5leHQgb25lDQo+ICAqIGZyZWVkLiAgVGhpcyBjYW4ndCBi
ZSBjYWxsZWQgaWYgdGhlcmUgYXJlIG5vbmUgYWxsb2NhdGVkLg0KPiAgKi8NCj4gdTMyIHJkc19p
Yl9yaW5nX29sZGVzdChzdHJ1Y3QgcmRzX2liX3dvcmtfcmluZyAqcmluZykNCj4gZGlmZiAtLWdp
dCBhL25ldC9yZHMvdGNwX3JlY3YuYyBiL25ldC9yZHMvdGNwX3JlY3YuYw0KPiBpbmRleCA0MmM1
ZmYxZWRhOTUuLmY0ZWUxM2RhOTBjNyAxMDA2NDQNCj4gLS0tIGEvbmV0L3Jkcy90Y3BfcmVjdi5j
DQo+ICsrKyBiL25ldC9yZHMvdGNwX3JlY3YuYw0KPiBAQCAtMTc3LDcgKzE3Nyw3IEBAIHN0YXRp
YyBpbnQgcmRzX3RjcF9kYXRhX3JlY3YocmVhZF9kZXNjcmlwdG9yX3QgKmRlc2MsIHN0cnVjdCBz
a19idWZmICpza2IsDQo+IAkJCQlnb3RvIG91dDsNCj4gCQkJfQ0KPiAJCQl0Yy0+dF90aW5jID0g
dGluYzsNCj4gLQkJCXJkc2RlYnVnKCJhbGxvY2VkIHRpbmMgJXBcbiIsIHRpbmMpOw0KPiArCQkJ
cmRzZGVidWcoImFsbG9jYXRlZCB0aW5jICVwXG4iLCB0aW5jKTsNCj4gCQkJcmRzX2luY19wYXRo
X2luaXQoJnRpbmMtPnRpX2luYywgY3AsDQo+IAkJCQkJICAmY3AtPmNwX2Nvbm4tPmNfZmFkZHIp
Ow0KPiAJCQl0aW5jLT50aV9pbmMuaV9yeF9sYXRfdHJhY2VbUkRTX01TR19SWF9IRFJdID0NCj4g
LS0gDQo+IDIuMjUuMQ0KPiANCg0K
