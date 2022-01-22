Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4C496E14
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 22:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiAVVFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 16:05:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbiAVVFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 16:05:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20MCdxZX025601;
        Sat, 22 Jan 2022 13:05:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2FAJHTRcN2ajy6FZAdIEdY/CXryoXukAyGbxaMKP0kI=;
 b=Oma9f7ZkKwxILhgVLavkZvfbgWyawTsewbLutTjTfX5VhD4WrddtdUDRhkhJBw0Nru14
 +GUNwwhnVvZcniMjHxkz7XeTAWDnfe6namJWPPwsUHFvTJZygpmdvgwVN2u9mKaNkiQZ
 zKxEflc0kTclGbzPkxxcWGw3+Jlgj4rwMSM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3drj45hd2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 Jan 2022 13:05:28 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 22 Jan 2022 13:05:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej2jgJ6lZAk1hYNw1lAD3T3HcpqzXw9YaqvtBuzAVid0nnjpjHF0TQtnBa5uFt73M6AFRoMggEBYfn8fmNBO41OnLgCZa3q1jB0xF2DDZumXYALfcLd/jy/l6xrYJowOl3VHaebpdXbfyoBFVk3jTh7tpEVn7zRPSm4ViLLWlkdzqYfFPcsREKk2JoM4AqUvKthbBnjui/RdQ4zOh3YHHrvPG75qE+wYUmSkk/msmWithsRsKkgTgRbVPB6dvh2leavnw3zN5YMkbkIo1cKW6kJkiyHDBp0PfyWJYM3uu+gkFrXl9srxttGuSfwoBGdklvEMGJeA2Okp1m96Igx0Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FAJHTRcN2ajy6FZAdIEdY/CXryoXukAyGbxaMKP0kI=;
 b=CI0OQd1S6tRk1bdxieoDzECevDu3UQyIFL+hIDrXSllhEfRaFzBbAJGqD4NAy3m0RgzeKGsSDmtDf6KM8SU6r7Fgd4/ky6nabw+EUQSRn4vcoYU0y1TdKvHCK9BRRZIGMgFLtfD2QoPKNAn+c7u+hCrAE/d6R4wiwNm8Y7Fndg2QFHUL3oIvBENIDmwwqmJOgwynKMQvg0BjZBOZyl1WXfviMN10T696jcFK2eQ+7mFApZKUuFq3EqLfOLzlwe20VE/E9AFd7kMmM73GI/fA7lJV/Gh2s6NK+9+RkIez7DlcnBdBxf2OnPRYfZY7+FfGs/g0OfruMK0VEbk7x7/n5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH7PR15MB5306.namprd15.prod.outlook.com (2603:10b6:510:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Sat, 22 Jan
 2022 21:05:26 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 21:05:25 +0000
Date:   Sat, 22 Jan 2022 13:05:22 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v3 net-next 0/4] Preserve mono delivery time (EDT) in
 skb->tstamp
Message-ID: <20220122210522.jouxkapr6ewaigjs@kafai-mbp.dhcp.thefacebook.com>
References: <20220121073026.4173996-1-kafai@fb.com>
 <CA+FuTSe83TdzkvYLdfbZDZrW3BGq74_KmmksrCjDKKua7pE1jA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSe83TdzkvYLdfbZDZrW3BGq74_KmmksrCjDKKua7pE1jA@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:303:b8::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f03b92-08de-4507-4847-08d9ddeae95f
X-MS-TrafficTypeDiagnostic: PH7PR15MB5306:EE_
X-Microsoft-Antispam-PRVS: <PH7PR15MB53068F82352B90FBA7F69195D55C9@PH7PR15MB5306.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEuXxmNA5I4mZnHO1P8F6H6dEsLhpt+Gc/WkKgdgsqduhyGZfZZ90MpVWRzUmLD4S7aFQtVIP9YjMWH8eOPVptMO0AnR6Ah/nMqXzblmalpOcEJJUuiKNN5JKKra5UdDWWTEJZ7guZ58UMDuhuj9fhN/gNnkWsNvoCwq7FmdKDLZVSPSnWHaZfZ5+Lznu6vXx0v0wVDeRi6NV0bRtp4wQsWKw/0Na7IFUR41oE+yi97yQyRr9IoD9UJz7tkJi81qwmtTyd+QtbTDBvbg6CF4CeQoZXx8tvwuAamC5X3NJTZJSa9dsqOGlLS7rkzi6cZfj2YXG4ikTDhsX2KGs2dpZhyERdKLXwmlME9k/B0FwaruR+m8dxv0wbuVGJtipF1pBIr37siPTqQepozs7zxaCI/0da4XrhFnb7JTQyAkOSIVI0so+tG7a02iP8eQeHzxpKQJ0AWX9DoxiHdw0uvYCku4ayR7E4TqyY2iZVFQl1ZrySLG1mGpUqKqkGvry1HG2ZQcSrHTR6IjQGm7oWO321Pn3gBbu6f50GZUFgSe9CJqRYfqjgcc9yJ4RjFkm15c8KKfku5tHUz/vj0NGkqCsRT9o9cXJc/nF19XsHTv+yW2aQjww/nf/Yym2/cSxh2kBrp1NTt5K/ApQhrvG4pd5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(5660300002)(4326008)(186003)(1076003)(66946007)(66476007)(54906003)(66556008)(9686003)(6512007)(6666004)(38100700002)(6506007)(8936002)(2906002)(6916009)(8676002)(6486002)(86362001)(316002)(508600001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zms/zOBWn39aCVaertLBkm239jX9uCLsPXK0w8YTfO3HxwzF3BdofrTxrvBR?=
 =?us-ascii?Q?5AugR0hp7TggwEZ0PN+AxXW8pzQQjGNDCFcnliGlNrJ2+R57kITqP6fr/qmC?=
 =?us-ascii?Q?nmWLy232TY2aliToVzYWx4RW6aumIdRIDae0tg5cuU1GQPCFsrG9d5Ad6m8h?=
 =?us-ascii?Q?4Uh9Cgkkh17ms5ep7PAeDPW7Yy/xLFP+QsgJHa5oIsS7JtA/hP7a6OEIET5u?=
 =?us-ascii?Q?4Coqx/gUh0Nt3WJafUTXs66D7rbil+WrEpklxym9LiJ8RHjqeo1rYjp/2YXb?=
 =?us-ascii?Q?DX7Q3U9S0GoB5gXJWnYW1MkMDbDu/NHugRp1uk0hPqdsVo7fWpl8/nAHA7Uc?=
 =?us-ascii?Q?+Jch4/RBUS9jXnqpPfGtE2ZRbS2E+cHyLkJx876b5PwDrNmPxYaI+lDpEQ9Z?=
 =?us-ascii?Q?JCZP8kjWBipMTIDGExkIpTdHHL/ee0VkHZHd5AfNhbzT0S0pihh9ItPLMmE8?=
 =?us-ascii?Q?kq+MLvcBCiTHWRd5J5jJStxGJgDsBPEM1VZ6yqOHqg1UJ0hnhs7mInJ9vt0f?=
 =?us-ascii?Q?xvCvUcW2t9ruU3l6m8pyxqlnjL/2dyNJQ55PTTat4nR/uCwsDK7ckP6LJIc/?=
 =?us-ascii?Q?UQC0eeX66Mmx3B7rU+HKBAnzVYGUga9FFYb4xd8vnl3OWgxFOmZT/B/ZoFnF?=
 =?us-ascii?Q?okJQEYuUBDJbd1dGRVnCBws+iP1jOzPfmETcNz+/I8Wdw4lx/xfdmYWbnyI8?=
 =?us-ascii?Q?9N/hrfT+902gnx22MmagGxEiXdOeMVri9ZaHoyDDE2t8mHdMkvNbV2uYicBO?=
 =?us-ascii?Q?aEo8FGOYyXHhSI2GvG3AeNkCuGIx56FsU4SfAP2YmDqCSmSEU6JqRERFa9Z6?=
 =?us-ascii?Q?lx/UosQ3EN26P81kWzZ0eDgG51jCBvpH7OFNgsDELDk/lb9vIrheXpZTUp1W?=
 =?us-ascii?Q?5tKzNAVGbGd6MyDcWjg1OaoRvmTqpogNVer56b0L75YLRcT6chUFypzmBg30?=
 =?us-ascii?Q?XhHl6YMc1lLIPLD+uV1MgN21zrmbQmQBiRQvBBmHXpOPW6C7wlJtIvdEr3WI?=
 =?us-ascii?Q?0yXq0Xex6IO25jAkpqGNijygsP0h5HCQYS25NBd0O2KajSFZTPmKErQItQr2?=
 =?us-ascii?Q?MaSEAWS0s984Be+yzbt6ZgysYEhmZCIFw6u/2+dA7zwPSu+nhAUCtaldPyj9?=
 =?us-ascii?Q?9tErKqgcJsZPrvVbbe4x8lrr6vSyeCtFCCrEHYemqGvq1XnBxgp809yL3Taa?=
 =?us-ascii?Q?zXm7aHEnd/8EeyQVkIxXtD0kRYTbLLShUTbKakf7CJwtVNzRW26aiDpXNOAO?=
 =?us-ascii?Q?GbnLpDaI+Hj4WUucfiWa98RURjjlPVDgINTOaqhBYJM+V2ivJBcxpXaOC+Fz?=
 =?us-ascii?Q?U+p8PNuHjdAM8lqlYs42W9GAdeSL1LQgp0TMWTZh5bMDJjzuonEdikYPNvIQ?=
 =?us-ascii?Q?nWuDn+eKDeXh+vqW/4XIgN4Wijj2luPzN/VL9ajTCGtFvKHkI3COmhH2L5Ic?=
 =?us-ascii?Q?lESn72VUvoIDA+bdyLYJIWuoLY0n7wfvxs4B5gmlfnOvJTM0VhymrXoA4lzf?=
 =?us-ascii?Q?6yNS64ZNRGRU9p5eem1KhBswKFg6YJCTl1kOXqGoVxx2KEYMNB6963apuHhO?=
 =?us-ascii?Q?8rsXaK9gz4bt5O1FAmzm+5xapXKi8dIWYkR42s9KZhJEDVn4WHBBO6LHD1it?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f03b92-08de-4507-4847-08d9ddeae95f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 21:05:25.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pi/JaLlj0UbL5UZgTpj94HEpgtPqdXCWNnb9NzYx0nE2PDV2ZFx6MX/l/5kaQhb3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5306
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: yfrqGJotQ4ZFtN4gVuGPC8vTWLlXhSqX
X-Proofpoint-GUID: yfrqGJotQ4ZFtN4gVuGPC8vTWLlXhSqX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=766 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201220150
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 10:43:57AM -0500, Willem de Bruijn wrote:
> This overall looks great to me.
> 
> The only effect on timestamping is slightly delayed receive timestamp
> for packets arriving over a virtual loop (loopback, veth, ..)
> interface, as the timestamp is now captured at the network protocol
> input.
> 
> Actually, while writing that: timestamping is a socket level option,
> not specific to IP. Might this break receive timestamping over such
> interfaces for other protocols?
The EDT (and the skb->mono_delivery_time bit) is only set for TCP
which is IP only.  For other non IP skb->protocol, that bit is
not set, so the skb->tstamp should have been cleared as before.

Thanks for the review !
