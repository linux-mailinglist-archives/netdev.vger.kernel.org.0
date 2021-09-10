Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781CD406D92
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhIJOXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 10:23:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47684 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233706AbhIJOXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 10:23:53 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ADqIWG023985;
        Fri, 10 Sep 2021 14:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0mJDtg/qYCq5Cp0lJKnV49NM97FXVJSeIZx1wOP+KqM=;
 b=df5txdrQDhxoBF3Mishk3W7y1GNKH2rqNFSwy/8H7vJkAa0FtcyFXBVtIC/wc4wC6dSm
 ko7QAQ/HtNndSsTrJNRlDtYVEupfkEHm/0M2I1ZGXPuk50jHTsW2ZB3/+AbqejwO8owC
 cFwonRd0RtFdvy36yZ7AsyP2fa7IT67I0ZDGPYVBIAmDTwVIqU4NG8PAM2v1tzEcpqLy
 DZrnh45TuplcBxwpf55IGjCqmjRRBnO0erDtx+ur5AunqqK6lvICTaUU5MU/ExA3hsjv
 MzrF1ya5iJi/FttTqxX/MfC73YtitaiOXr6NONdeqApCddZHmxOY6KoW/Iz2p/Sca2V3 0w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=0mJDtg/qYCq5Cp0lJKnV49NM97FXVJSeIZx1wOP+KqM=;
 b=LFM3lXEfzQ3FMhyAq7oDPN8VgA8Lq5inp27IFvF8/3m2Yo1TK6Moz2pCZzcDV/hniTeb
 Y14vge87ZqbAIwF5SiTfpsjQThs0NIr/QMr3RHe0TnhGoJqzMmPuhmqOFrV/zd4HTSM9
 kThNLBcT88SB36eKVOgY0gD6l/zloDLGFT6aggWun3b7Tn7YY/qOkia1d9Q5JRaP1eiN
 VkdzxG3cN/MONgArShRHcwsyNF+e4pqLD3Of8L1l8QNAEUVqp3z0Vy+wHVLiAgsROP9c
 DjjY7JWDUFNS4Gh/kGJvCutL+01y9wH5yImMl8wG4uP78eFlcmTbBesAM4U93ct0FUqX HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytfka16m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:22:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AEGuRf001534;
        Fri, 10 Sep 2021 14:22:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3aytftymeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:22:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AanldghEs9gEeWtY1BFnE5Y2o8mflJXCFoFv/p8X6KzPfFl2nPmy6vfn09Ozcv+ZOBgCvnefiOpEBZXdpa5s+4xev84YNa6EPLES3DYper61vcBK+/Ndlvl4IF8Z97WHqyGOuldgkic7jkvUb3yYDJoqZjywk3ssmPWt9/Rtd8GkaPizIZeGaQ9S7BI6E1hCfA63NCGWZ1Gvw7VbSZt//GONtLOukK029fbsB1tEQvA5c4Rc3xFKLI44zsXZFYLDZHqx5Ezr45cF/+ebPAae3QN6SGI1K0WVQfoAhpHY4Y9MobDEoc7yPp6wlRaKWV1VodaAu2Juu1K0waoWKeillQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0mJDtg/qYCq5Cp0lJKnV49NM97FXVJSeIZx1wOP+KqM=;
 b=YYnoNOxcKmg7vdybgCURFtvpT5mN05C79wc5GBK5EeAmkbRzWCcLHZTCdmSOh1/GHFEzZZUdxN534Ou87jEXKbwnj2FTyUm61+euDWpMYvLr6Lysy2dSdAiGFceMiiwSbGYpregy1wUuTx9xlKNdwobZ7F0BklKq37lY6v9WKzQojHPdNdpT1rJZijpC8wIKugfDF7fmt6new3L95qskrdQh540f9nEeGf0macgLAHbVpOKM2m7lYa/0x6UW0Bzt4NDaa34l0n6brT85myXUdGTpcf9OIcDpz+3gP9a4o0f/LUQhiWvII31aD3FqSkhHsBougnIlQ8TB49e7C5ZiFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mJDtg/qYCq5Cp0lJKnV49NM97FXVJSeIZx1wOP+KqM=;
 b=lnv8qThEqfmJNLbpH4smRETrOat+nZOCqJUM3GshwUX8f99/yR0vk2KsEHAMPTagAqofmQoGkyAIK8TZ/Diz9hlJo12PurRTfMy3i6/njCuAP86uaAbPK26yWKWQfeJzY/6iZRxAh/YeVb3KyyyKS9EMeJV7lioWyANE/k+QAJk=
Received: from DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17)
 by DM6PR10MB2939.namprd10.prod.outlook.com (2603:10b6:5:6d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 10 Sep
 2021 14:22:32 +0000
Received: from DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489]) by DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 14:22:32 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Thread-Topic: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Thread-Index: AQHXpXwB9uiZyfI9lkyCqWjXsXAVU6ubssmAgAGg04A=
Date:   Fri, 10 Sep 2021 14:22:32 +0000
Message-ID: <756E20E4-399D-45ED-AA9A-BB351C865C65@oracle.com>
References: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
 <YToMf8zUVNVDCAKX@kroah.com>
In-Reply-To: <YToMf8zUVNVDCAKX@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc0bcf46-90a3-47b0-2303-08d974666dbf
x-ms-traffictypediagnostic: DM6PR10MB2939:
x-microsoft-antispam-prvs: <DM6PR10MB293901273525FB02C42A54CAFDD69@DM6PR10MB2939.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C4ZUVtkrmbC3zypBDK32EwfnQioWsNYlzqksMg9vHT5jBStMvp/N+jbRJ/vuqgm5a0qUoGriu1qbZBi5sANv8+L6jVaMtLT7AKT42uKQgr6p7PLxZ+B7EzU33LevnN5LX6b70EwtMtDEkh3kY2vxbuBZcb5uCXgLCDWNxbxWw3MeLhB5fqv5vYsoVac3sVPzd5DvlpCmQooD+809Z8GhAtUJh8eae3G0lTYGuWugICw1+BQR+p/CxdJp/07w/192tAycJWzbggLGHLCd3TEBnFmThDUpwBxatmrBcQfsvXoUHaPnzvbFuTZXMRdO/dSs1h3QJPk1AbiCqWWGTT6la7RggTOhJG73SnxfY6rJ+zn+N/czm+YhgwBUJaJmkHu81C8FSGy6YR2MP4EgmXN2MOjWheW/IUnWibAc2+lWwFbrTTrBK7AnzPE82+ab3oCIpV2Ni+BNTkrXfVnM7j+kA2voGTXfkPkRs9lCjm+6kOqcrIBxyqt3NH/4kmANL7QYOZR28TnhMphMDB2wbnKW2qegnNqG6xa1hSR5xv93zZTfqmdzJ9cFgP+Tq7TgdFdgcNtlNTs66rHCnFnCLKi+tBV4uVPbKyUucexl/zzLXJndYGQ9OsSYNJPwdp//bMaDeq2o8tmPgfOcN7sUf7GU4QfoViEtiH5pt+HwExS+wiAKEk9G0Z7ZrfITIFWgG/6nKm7JYqnFL0GRx/F3H10UJYUbz55YTwLKp92XbFc1Kn06OfDlpWWHU6lnrrsHSGeu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4863.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(366004)(346002)(396003)(38070700005)(44832011)(6486002)(6506007)(66574015)(53546011)(6512007)(4326008)(122000001)(316002)(76116006)(8936002)(26005)(478600001)(54906003)(2906002)(2616005)(33656002)(66476007)(8676002)(6916009)(64756008)(66556008)(5660300002)(7416002)(83380400001)(186003)(4744005)(71200400001)(86362001)(36756003)(38100700002)(66946007)(66446008)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGJGb0g0WFp1KzE2ZzN3bW9xbzJlMnBsMmY0YS9kbHkxcnpBQm5qU0MwRmpj?=
 =?utf-8?B?cFM0OVlZRzN1dzlLRUxYTDhFb2hJWUFOWU5ydjZ1N083QjhZVlFaRXlYNUM2?=
 =?utf-8?B?YktBYlFhR2JjTm5CV2FpRHNKMk5za2VyWnhRVEIrWHZPbCtLOG85Q2hHYm0y?=
 =?utf-8?B?NVV3emVCMStyVnl0WGxjVFF0TlJLVkdwR25WaXM3YVNBZG5nWCtwY0x4blVu?=
 =?utf-8?B?THhlcVkxUG9Cd3JVWThLQ0xrb1RCZFIvZGlVVGhRaWpXd25Yb2kzRy9GeEJr?=
 =?utf-8?B?aDU0R0tVTWhqcnlYN0pTcnRIZjkzczcyYWR0S1BySWF2VUFnZmFzUkxaVGhi?=
 =?utf-8?B?b3lzWk5EVjNORGszczIwaFYzZ3ZvMHcyWXQxVTNsNEUxWDhUKytCeUtvRnJv?=
 =?utf-8?B?R0FDa1cwMVZJN1dTVGwwQi9qcktQd0luTlhpbGdyc0lzMHhicXVzOVBjRjMy?=
 =?utf-8?B?c2tJd1RBRFRFWFJjT3R1RGNYMTh5ZC9YZnJ0S2xzdHJlMXJxOG5kcm1uNFJm?=
 =?utf-8?B?UVFSZHBCQmlBa0Y1TWlBWEhTa2pBWXZlS0RkbFR3SCs2Q000VGhkaEFoM3Vj?=
 =?utf-8?B?V0JhY2pYcUVPVlVBQVF5ZFVBZG9ESVdNRzhVM1Z3Tk5YZ3pPVFgzdTVscmI3?=
 =?utf-8?B?MzZuaFFTemJqUlR2MDBqbElvS0MzL3pnM1BoM2NFcUR0NERjQzM5cFlTY3F2?=
 =?utf-8?B?MW56UmJnZTl6dVk0dC9vb0hjckZXcXRaZ2o0VWliSG5IdXJERzRTRlNuZHFD?=
 =?utf-8?B?eVprQXFzUTNpMlZWYkliM1QwMmk4a0phR1pQN0NIbmg5eS94NzRtQkEwRHdy?=
 =?utf-8?B?UlJIZDhxZnN3VWk2c0YvNWNLM0RTbFpyK1IwakZJYmVSV3ZxaHBkbzNtTlVR?=
 =?utf-8?B?UkdwR3lvU1A3RjRyT2JGNHJDTVprQmllZkd3b3Z2WWhXazI5K0ExVEsvNEl0?=
 =?utf-8?B?VXBjRG9QSXZNcFY0eEZyRFExcEtTdVpsTnRRWU5yMDhWWDNnSVBxaHgzTUtu?=
 =?utf-8?B?SCtkeGlPWVNDQUdweVh0REJLRGp2dER5RmNHSGIzUGYrOEZJWXRxbTRHOEZp?=
 =?utf-8?B?aHJQbFBaSlFnNitrNDY2dUFacHN1NjdQY2p1eUpTVTBvTEcvdXdpTkdFa2Vn?=
 =?utf-8?B?WHdqS1RwSUV4WmxQcGZieHExVWN2NXgwRFo3SjlRNDE3OWF6QlI3K3NNRktK?=
 =?utf-8?B?ejYvS20rYXpyNVAvSE9jdnVjVmUxUjZuSEhSa3pyWXdZNEhiaERXTmxJdkY4?=
 =?utf-8?B?TFhNSjcvb0dFVzdPcDIrcWxyRlIzN3NaQ2lHUjkvZWFmdHVvcGZLOUdMdXpC?=
 =?utf-8?B?aitmVUttTDhyQ0lwc1NCWHVZbE1UeXR6RVd6Q2xzb05USWNMc1VYMW9UUElL?=
 =?utf-8?B?akZZUDQxWDEvSzRNZkxTTDdRL2taR1hpWVJLMjV5NWZPdEhGZ3lRV3labHpS?=
 =?utf-8?B?cFh1RXNkWW9tV2hKOUdGdi9xeGxGNE0wZk5ENW9UZFF3bGtvbjN0K0JhbnZV?=
 =?utf-8?B?elRFZzdGYnJzMkZNWnJMUSsyV1UzMUNvQXJhaWFmM1ZjWXFvV09tdFU2d0Yr?=
 =?utf-8?B?Nm51elExMVoySTU2L3U2ek1VNHozSXRTT2VKb2hidk9TRFdKQVkvaUdHRWJ6?=
 =?utf-8?B?T281cXJaSFUxR0lrYVZrc0h2eGR5MXgyaVhPdTdwWEZqbGhHUkphSlNMRzRY?=
 =?utf-8?B?NDVKVDV2S0JtL0VEUFBFVkc0KzVUT0xsOEMwOXN2VWY4K3RXQ2lSQUpxdGov?=
 =?utf-8?B?MkNVaFozZ3pieXc4YjlranZ3Mk1FOTJTNHBVVklLZjVsU1VTL01kZ1BaMXVh?=
 =?utf-8?B?TTV1dGU1TldnMXhscGlrdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AC293AB762F6F4CADE41AF73809E29E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4863.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0bcf46-90a3-47b0-2303-08d974666dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 14:22:32.5558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wqVxYz8/Fup5s7/2FRLRz0WtIgWkmuuvGvbvDZgSGoarQmd4SPPFVltkYCnvun/qkSKFpy5VCa7aR2H4On0mRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2939
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100082
X-Proofpoint-GUID: N2sVFRtMImovn4TFQXGiDJDFC-kmN14P
X-Proofpoint-ORIG-GUID: N2sVFRtMImovn4TFQXGiDJDFC-kmN14P
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gOSBTZXAgMjAyMSwgYXQgMTU6MzAsIEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgU2VwIDA5LCAyMDIxIGF0IDAxOjEwOjA1
UE0gKzAwMDAsIEhhYWtvbiBCdWdnZSB3cm90ZToNCj4+IEhpIEdyZWcgJiBTYXNoYSwNCj4+IA0K
Pj4gDQo+PiB0bDtkcjogUGxlYXNlIGFkZCAyZGNlMjI0ZjQ2OWYgKCJuZXRuczogcHJvdGVjdCBu
ZXRucyBJRCBsb29rdXBzIHdpdGgNCj4+IFJDVSIpIHRvIHRoZSBzdGFibGUgcmVsZWFzZXMgZnJv
bSB2NS40IGFuZCBvbGRlci4gSXQgZml4ZXMgYQ0KPj4gc3Bpbl91bmxvY2tfYmgoKSBpbiBwZWVy
bmV0MmlkKCkgY2FsbGVkIHdpdGggSVJRcyBvZmYuIEkgdGhpbmsgdGhpcw0KPj4gbmVhdCBzaWRl
LWVmZmVjdCBvZiBjb21taXQgMmRjZTIyNGY0NjlmIHdhcyBxdWl0ZSB1bi1pbnRlbnRpb25hbCwN
Cj4+IGhlbmNlIG5vIEZpeGVzOiB0YWcgb3IgQ0M6IHN0YWJsZS4NCj4gDQo+IFBsZWFzZSBwcm92
aWRlIGEgd29ya2luZyBiYWNrcG9ydCBmb3IgYWxsIG9mIHRoZSByZWxldmFudCBrZXJuZWwNCj4g
dmVyaXNvbnMsIGFzIGl0IGRvZXMgbm90IGFwcGx5IGNsZWFubHkgb24gaXQncyBvd24uDQoNCkkn
dmUgZG9uZSB0aGUgYmFja3BvcnRzLiA0LjkgaXMgYWN0dWFsbHkgbm90IG5lZWRlZCwgYmVjYXVz
ZSBpdCB1c2VzIHNwaW5fe2xvY2ssdW5sb2NrfV9pcnFzYXZlKCkgaW4gcGVlcm5ldDJpZCgpLiBI
ZW5jZSwgd2UgaGF2ZSBhbiAib2ZmZW5kaW5nIiBjb21taXQgd2hpY2ggdGhpcyBvbmUgZml4ZXM6
DQoNCmZiYTE0M2M2NmFiYiAoIm5ldG5zOiBhdm9pZCBkaXNhYmxpbmcgaXJxIGZvciBuZXRucyBp
ZCIpDQoNCldpbGwgZ2V0J20gb3V0IGR1cmluZyB0aGUgd2Vla2VuZC4NCg0KDQpUaHhzLCBIw6Vr
b24NCg0KDQoNCg0KDQo=
