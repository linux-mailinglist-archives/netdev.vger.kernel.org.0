Return-Path: <netdev+bounces-7247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 188E471F4FD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0FE2818D1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E882413E;
	Thu,  1 Jun 2023 21:46:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A2182D0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:46:58 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D99107
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:46:53 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 351GWLSu018166
	for <netdev@vger.kernel.org>; Thu, 1 Jun 2023 14:46:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=9qGQl93eTM8QUbCO53INq68lUucn/qQxcXOC8DhXcDw=;
 b=EVxSDt5rcYcsIrx0qfh3kGTaVMat2dE5SgMOl7wWptLLxJ24qq/9AFpPKWMj3jAY+Urr
 EkALxDvvI/kK9839eokaF+V1krvpo/ByuLFpx8gI/x4Hf/bBOIuFiv1jQ60nqXHJoBrb
 RbWxqRVEfrjfbJ3zPODo6Na+jkAwYnxEREcdr77mMPh2/1lvzs+WmmXXxxcb2kUKPB2L
 y3mYOr15+IyBuo5ha7bpDm76zCUw0qeuFcLBfOrQZ4zz6ezcfUGQY/LHUF3M98z5jUjq
 gpn4hHc7ubkFzInfbZiigtLBKFkIsyEb9OkU7Sf+lO7w70QXy08T9F0QQtpPFaMJFytF cA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by m0001303.ppops.net (PPS) with ESMTPS id 3qxawf2rk1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 14:46:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKReEjaQlAu3Nwsgr1lYTDqFVbYhpnyNsqknzOgLhPhrDNoDmzRAQGgJafa7A9JJxde+X7PwL8xpyEE7ZDbAGk3oVixwA2+m6jDby1CnLXxxgochTcgnjEXpVuhOaNb1CZ/L5N0k81MKvu0wJrlqwLwsSBy1eYSM0PIAQHH0BZ/Ya7knn4a2X+PJjPjMoM6y7AoZbcbetS6ZbgcnrpzjLX6GakxPMaex7jgRl8p8uhpWoCmcaD8qsi7Zllru+rMC+Nuy4bIm0aRyrjBIazjRSuq9C6OSnX4b2GnhNWmicni0aHHtuXIGDiCGqqP9uIDOr/ApjnLPZueRa4HhGNqf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWr25AsYl2X04pw4JjWuK3s+Jc5tPvqrz/0R19Xpw50=;
 b=d+S57AaJJfqJyEQfR8Md7yUQpQ7kGMMs7ybLXW2KIelWb8K13wt+qDIxaj15KW+hVc6pY0as6eqgTzZmWN5WlNADx6E9N+CuTLdf07zKS+B/P9D2z4FcNx1OR++xhCFSE3wtobubmPSlQBjJ3ryb7LeJ7LgRva63x20K4fsjlyH3P8exC7Vsx3S9THlsEVz+0nnCYx6AhnMsmhcrD1OyXccmrHdYl0DIDR6gS/qlg1Hnl6cTuRa8NepwdHq0YTaJFGibSL6l9y6fsQm+mBXC4svqJ4eSaSjRHDk8hgxh/2uSWKR2QYiiCDFdj/YF1E7mKy/q/LRSYR5X5vPtg/576Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10)
 by MW3PR15MB3867.namprd15.prod.outlook.com (2603:10b6:303:45::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 21:46:50 +0000
Received: from MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b538:61d6:dcc3:dc46]) by MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b538:61d6:dcc3:dc46%3]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 21:46:50 +0000
From: Alexander Duyck <alexanderduyck@meta.com>
To: Eric Dumazet <edumazet@google.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xin Long
	<lucien.xin@gmail.com>, David Ahern <dsahern@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: RE: [PATCH net] tcp: gso: really support BIG TCP
Thread-Topic: [PATCH net] tcp: gso: really support BIG TCP
Thread-Index: AQHZlM59SFciypg/ZUaWKAnyyZLGoa92dJBA
Date: Thu, 1 Jun 2023 21:46:50 +0000
Message-ID: 
 <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
References: <20230601211732.1606062-1-edumazet@google.com>
In-Reply-To: <20230601211732.1606062-1-edumazet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR15MB5121:EE_|MW3PR15MB3867:EE_
x-ms-office365-filtering-correlation-id: 5094793f-695a-4761-082b-08db62e9b4b7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 boQ2ZLPHXVPNfsDe1St3jo75lQF4Fl7YwLNqIHhhipcSYCFFIFNmNaG6qINq+uYvCyPBs+z4e5YeyBDgQAgORiEhzlo1nfBavxKeMMdeyCc0IOXLxyfTbmbEbVdbi2ULM4enTPGPY57+BZmiYEhxwQgmS43yi9/w8Z5lSA2mXp6BYNtbbcXQ2rc0emwaLSuL6NA5Occ++aMw3RuPryPvfXX5tXCA4bbDW3exm1YM5ml/C6YfCmxTASEfhe9LKpfsYaxkyzHlPiNRLihUyo2Ld6Ge9rT6kKv5kLR/xV575YmrbxOnYM1QvmdhrmP6j6ZpRlthLvHkU6a7WXZYUw42CU4gBLP1zvdh+ocOai3DC3RQyIrHnggjuU5otfGnRFF4mY9yLJk2Ylf71y8/ahlcd4vxCQaBJ88Bqs4oK3x0uRdiEZKZOt+7qmv/7RGcnZE+B9otu9YIiKabGVuiE47v+ayJbKLxU+MNAi5U6Ne8QbR1Qh2u5pj/Iu8RYGfOOWhiT08+JJogP6FsDA3cDp00rcOqa17VqiFz5ETeFF8qPmGTYHEO+r1CoWMh5r0bXehOO4OuorD8ZEy5AaBE8Yff+hivdYhsK1DG94DkrKhliv0cUKSH1YjOy1ea8OP4Lflb
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR15MB5121.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199021)(83380400001)(9686003)(6506007)(26005)(53546011)(41300700001)(38100700002)(186003)(7696005)(55016003)(71200400001)(478600001)(38070700005)(54906003)(110136005)(4326008)(76116006)(66476007)(122000001)(66446008)(64756008)(66556008)(316002)(66946007)(52536014)(5660300002)(8676002)(8936002)(86362001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TUV2bFEweVFpYkFXeW5DUHpnZVphVnNlSEZ2dnY1UWg4QWY4TEJhbE8veHZu?=
 =?utf-8?B?QTF4aHdNYk9NQUwrQ2tsaG80bHNLYXQvaXd3eTQ4VmFWc3Q4UnBobmZjb0R0?=
 =?utf-8?B?eG4vYlFtcEFTblVYMmRlb3NtY2ZiZk9hcUhoQkZuTmVxU2F6VDNWaWdqb01S?=
 =?utf-8?B?ZUMxV1BHeGNDRGR5Y1VNSm1UT0YxeXNPTnEyVjIwUFRLeWNDOHhBVEM4U0Mw?=
 =?utf-8?B?Z1NGb3VzbVBJVDFsVlhKL01oUDN5clgwODZUc1dUc0Z5YlZ5dWVnN3N6K1RI?=
 =?utf-8?B?cXg0SGpaMldSVTQyNUh3SldiMHkzODZNZUdWOFd6dWZ0eUdYRStSZkIxYzlW?=
 =?utf-8?B?cHg2OStmcTVyejMzVUp3cGpkMmRTYUtNVTQ2S1VROUlFRkplc3B4VXlSZmJw?=
 =?utf-8?B?elJQZ3VqeEwwN0Z4V0dSaU8wdTVlWnhUc3RGYlRRcVZwdGFndEhCek5CdGVt?=
 =?utf-8?B?eXByMnNUZnQ2TUxwcjgyZkZBdUxGeWM1aHJBTGx4RVZpcTRoSDhCdXp4TkhF?=
 =?utf-8?B?WDR1aDBZV0FmN3FqRFdQQU9EMWhKd0dFcCt2NHBBK3d5UmNtZHlGY3h5YW4z?=
 =?utf-8?B?RXBVL3Zlc0RTSUFoNHNvNWYrK0V6eGYyRmJUazZZekR1MXg1WjROWkx5ZlFn?=
 =?utf-8?B?T2xwblNCUFZTY1ppMWF6cUYvY1R2dGZydTVuenJCL094UnJocnl6UXRBbmtK?=
 =?utf-8?B?bFloeHFVcmJMNGVRa3Fka3VOaFRWQzIrYXp1QzVFaUZOR0NwcGpjYlJoK2Vo?=
 =?utf-8?B?UWxVNXRwanowaWJSYnUxeUNLMTdOakc2YzdYVVBUb1g2RzBQazN5YTBxWk56?=
 =?utf-8?B?UWI0NVUrajVBMXlvcmJLR1htMnBiVmFOQnIwU2ZxNlVRQUt0NUtiTlJzc0J5?=
 =?utf-8?B?UlpZRXprTFpCUXpmL2I0UVNaamZTeWpjenEzcGRKNmNkVFA2MDZ5WEFsQ0kz?=
 =?utf-8?B?R1RreWNTeXd1MkdKTDJncjhQd2NrMmRkbnp4eVUxa0ZHbnFJQlpzQm0xSVZj?=
 =?utf-8?B?UldWU0E2MnBSRDE2VlFnbGRuRCtXMnBNamE2bW9kUVNDakZtMWJjUTEwN2Y1?=
 =?utf-8?B?dWptQ2JjNTJUeTN4VVFlS3hoYU5Sd2plMGVsUWVaMzMrZlB3WExlcEorTU1T?=
 =?utf-8?B?TG9CRVJEWXpRSklHdGY3MmwzQjJYRGFLbUJ4UkcxckZZY3hZbktiM0JDckRG?=
 =?utf-8?B?YlpJYURFekJqRGExd3cxZlFtSWJzVzdibGttd0tQVWpJSm1PRUJtaE1FMC84?=
 =?utf-8?B?L0tEZUVZcHVTTnQvNDJRV2o5R1QrdWNaOWVMWWdySkNOQzBBK2ZiYjRCek5O?=
 =?utf-8?B?UmV3dHkyUTE4K3ZKREMyWDFkdHVnUGg4d1M0bWE3NkVnc2l0Qkh6ekNPQUZo?=
 =?utf-8?B?aTU0c2JXTHR4Y290bEsraGJaYnNhVjhLSGI4MTF3OGMxN2pPV0FaTzN4a0Ni?=
 =?utf-8?B?RzcvblE1bmZPRHZOa24xdEZxNnRkQlNtbFZhMFpOeWZSRWNqQnhlbHRmSmxT?=
 =?utf-8?B?bGhnZy9PbFZZTEs2eDZidUQzVVRNY0tsa2dDK1E4cjhCODEvZVlqY2RLaW9v?=
 =?utf-8?B?blI5bWoreTJGUGxJMDdtQlFRcENFQTFRN3pNQkZsQlg2RFlzQlFsOVdEL2Ns?=
 =?utf-8?B?UG5XajBsTklnVkwrTGxvQkVYdGxONktYcnRsRHV2MTdJTEoyeG14ZlpvWDFx?=
 =?utf-8?B?aDAveGJ1UnRrOGcyKzJHVTR5K1ZNZ1FObzlBQWZsa1BLZktmQU5vZjVKR295?=
 =?utf-8?B?Q05xbVZ4SlZRdkRjNzdVdHhWeHkwTGhOV240T1J5cXZKcm9ubzUyckdnT3pG?=
 =?utf-8?B?bmt2MTRtblQzSGFBcDBKOGpnV05saWN1ZnVycWxmUCsyZmJ2UkgzVlZDUFIx?=
 =?utf-8?B?aDZSems3THZSK0xTSWhrVGJtdGNmelVYbmU5VDFpS1hKbjVLWHphek5mYUNo?=
 =?utf-8?B?NmhHdEpaWVlSQkpCUXozZ0ttRHZtMTdjQ29JT3RxclRBRXU2dlpzV0ttWFdO?=
 =?utf-8?B?ZHlJZ0ZGRnFnZTRhdmRMeEtqdUVrcXppSVFYZE5mN3VTUHhySUxuSC9nMEFj?=
 =?utf-8?B?SGVkZ0R0M0F0K3JTSWgzV1YxVnFLYm0vNGIrc2RTTHBkM3h1ZUlMVUc2WW0w?=
 =?utf-8?Q?yAOSZOVLmECmpn0WGW8Kthl5J?=
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR15MB5121.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5094793f-695a-4761-082b-08db62e9b4b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 21:46:50.1444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iZ5aF5jnau4coqEDsoNNbKZ0uNB48W7Uaiq4rmAdooG6nn5Ara+OFcbt2WBfBcWx23yTrq3uBrlyySPV3VZvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3867
X-Proofpoint-ORIG-GUID: F-ljRVJcQnKpLbnn0DVTgofBtIydOEvO
X-Proofpoint-GUID: F-ljRVJcQnKpLbnn0DVTgofBtIydOEvO
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Eric Dumazet <edumazet@google.com>
> Sent: Thursday, June 1, 2023 2:18 PM
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org; Xin Long <lucien.xin@gmail.com>; David Ahern
> <dsahern@kernel.org>; eric.dumazet@gmail.com; Eric Dumazet
> <edumazet@google.com>; Alexander Duyck <alexanderduyck@meta.com>
> Subject: [PATCH net] tcp: gso: really support BIG TCP
>=20
> >=20
> We missed that tcp_gso_segment() was assuming skb->len was smaller than
> 65535 :
>=20
> oldlen =3D (u16)~skb->len;
>=20
> This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO
> problems.")
>=20
> This leads to wrong TCP checksum.
>=20
> Simply use csum_fold() to support 32bit packet lengthes.
>=20
> oldlen name is a bit misleading, as it is the contribution of skb->len on=
 the
> input skb TCP checksum. I added a comment to clarify this point.
>
> Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  net/ipv4/tcp_offload.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index
> 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204b5
> 0e3fc76c14b64e9 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>  	if (!pskb_may_pull(skb, thlen))
>  		goto out;
>=20
> -	oldlen =3D (u16)~skb->len;
> +	/* Contribution of skb->len in current TCP checksum */
> +	oldlen =3D (__force u32)csum_fold((__force __wsum)skb->len);
>  	__skb_pull(skb, thlen);
>=20
>  	mss =3D skb_shinfo(skb)->gso_size;

The only thing I am not sure about with this change is if we risk overflowi=
ng a u32 with all the math that may occur. The original code couldn't excee=
d a u16 for delta since we were essentially adding -oldlen + new header + m=
ss. With us now allowing the use of a value larger than 16 bit we should be=
 able to have the resultant value exceed 16b which means we might overflow =
when we add it to the current checksum.

As such we may want to look at holding off on the csum_fold until after we =
have added the new header and mss and then store the folded value in delta.




