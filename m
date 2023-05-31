Return-Path: <netdev+bounces-6887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE6A718912
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10A14281438
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB7B19923;
	Wed, 31 May 2023 18:11:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5E1C11
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:11:46 +0000 (UTC)
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554CE98;
	Wed, 31 May 2023 11:11:45 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEOJY6008349;
	Wed, 31 May 2023 11:10:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=u3sg1YYKz8h2afeZD6aUoE/gL/Q557Gp0pEOCmoQZmc=;
 b=yLlEnKzYlnKYn+AHiTYWC61U2lcCMgPEKw1QJdZWBHnCv5aJnBOoDKcywjVAuxMc+Zgh
 eQHTa6TaiRMEDlY9+TfD/xoFOkgkApSAA90yTSjeTtXfEpnnJ00Y/Koajy3cjG/6iq+e
 SgbCsoQhBDxvlHTItfmPZ2ASGTw+vJeheEB4FkurjA98RBAmSnjYKPgzXc6BN9uPg96t
 rVilaCcIHKUSRkIEqXJVjqOh60QKS5BQT5PgThRIwGf9FaEYfUzlkiye4iHcWPP45AI9
 It0Oe6EcJriDybbgjOjnUpvF0KAB2rc9iWc/xFBf2fH3QNFFBZdIsKXMv+lHb/bIXM4X LQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufd6tsq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 11:10:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS1fvNoNVUSsszSZat/n4P8mbbh1cvoVCldhCVvIIYWHOMBZrriOuom3Hj0WUcWEjTxH2Ei+rHYYS27A00efzwn2gBG0LVdCwqHHZOihyZ44imcpRpCfO9t6H4RKm7EuKjiDcn4gmtKJeCbculCMYPSPg8b8yE+ydquNPj0mhUwL1wG0iYSCLrSbpUVFnUaQqXc/inWZlrVpOjrCeUTXgW8TM4AZY8YSf7Sro//L7c1QgrWHDUmCccUlTyXfTtswV7WdWbrHbvLWG7ijg8+Td1FReRVUqw6vNexeR4zPTx1Q5NWQ728RhR+f+aCUuzXzRo3hbDan8IbQEaghq7Rh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3sg1YYKz8h2afeZD6aUoE/gL/Q557Gp0pEOCmoQZmc=;
 b=BjuxvPq/+ZPUwXOqrpdGKUy7Vaf2P8+/QDVUF9NYm0OpM3hJmGeimnxPSQXTVT4lZiaICwKPuEP0KL1CuaHeaRK1vhb1pRN6hdvAL7YRdrRfTt0kutEMWkPOWkRzXTM3QoUBf39gBPtdMaawS8canTQCD6dXqVMC72beZBdqONfc+sSBgNnqZ7iPNwrNW2xgQY8IafUYYUaWI+WdwFrA3Bw9FzpUzaG+t+joqKareyyBOaIoOh/kE60aLkm1oO+fSfbvARatO4z6OJ6fCoQVJl/XY7bi23Kj16vgVuWtPjzzdU/lQcm6kzr4rbeDF7RdudGR5oBH2EhoVTMAuchRyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3sg1YYKz8h2afeZD6aUoE/gL/Q557Gp0pEOCmoQZmc=;
 b=ZXSsoWJ02hqtwCc++RjzWJj/NvZvTzwdaIWWwHZpiO3Pg3CMhh8aive6/CrvCj9tsYrT4waP9HgfGzK427Tp/YMpoqSYsR3UUgRRUKCHY/6uYyaDe4lQDO4/UKohUVjzXNVJ0uoZ1d+qL0gfCs6YNZv4P+ZCXR3TEbGlcnjI3y5Iwy+bOLer+r2u3CEWqW36urU3Yt5hmff5l/gqA6JRVl45aYK1M5EsnVwTrm9ptgqBtKaR40wufIfQs+cdvUJsayHyCSwlpg6It0pafAAJq4b7u483k5oiYZBjqMiX046f45CG2jFujb7sFBL8uRsGV7mheLJLW6fnhcESMt1EOA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN0PR02MB8208.namprd02.prod.outlook.com (2603:10b6:408:153::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 18:10:21 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 18:10:21 +0000
From: Jon Kohler <jon@nutanix.com>
To: Eric Dumazet <edumazet@google.com>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        Menglong Dong
	<imagedong@tencent.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        John Fastabend
	<john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel
 Borkmann <daniel@iogearbox.net>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Qingqing Yang <qingqing.yang@broadcom.com>, Daniel Xu <dxu@dxuuu.xyz>,
        Felix
 Fietkau <nbd@nbd.name>,
        Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] flow_dissector: introduce skb_get_hash_symmetric()
Thread-Topic: [PATCH] flow_dissector: introduce skb_get_hash_symmetric()
Thread-Index: AQHZk+RxmdTXxpqVM0m0KZDS1nnqo690pFCAgAAD0oCAAAO/AIAAAqgA
Date: Wed, 31 May 2023 18:10:21 +0000
Message-ID: <AE369266-E9BA-4554-8470-C2C2932E9B13@nutanix.com>
References: <20230531172158.90406-1-jon@nutanix.com>
 <CANn89iLE1d=MuSMTisEbLh6Q_c4rjagd8xuRj0PC-4ua0pDRPA@mail.gmail.com>
 <30861EDF-D063-43C7-94A7-9C3C5ED13E54@nutanix.com>
 <CANn89i+EKgtVnnq-LqtmHXd5Yg2WMVn5Uw+F7zM0jPRdaj3wsQ@mail.gmail.com>
In-Reply-To: 
 <CANn89i+EKgtVnnq-LqtmHXd5Yg2WMVn5Uw+F7zM0jPRdaj3wsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|BN0PR02MB8208:EE_
x-ms-office365-filtering-correlation-id: 73857ff3-daa2-41c4-9d89-08db62024c8c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 cSugjHOC/btKXzzaXJNFyTi+ZsRrevIIf8u2Oi+8s5XlpmyAwTcFQs5acYjhL+cBDMcPnhi9wCsWNLOqhtpjZTFDPK6F2ayf86rQAtXIc9HlKnPQzAaN7V4tBy/USf/xSSrbU+ag6mP/LH88H/IOoFDv4py0MIdiL0hwrk3yhcw0FoST0Rgh7WAZGIjU4mC3Br23Z1ldGqZS9DhP09AwUcbXE7M7y5pAGXBYZ9l/iv6v4kxrjyU1eCanHefzT1ek+jRRJkQIPOp42AKGqyIm0bCDEz+MEuLc79Rs7vZZYoJbelPQtu74ic980UWlVCZa1KeGe4IB75UCHMNI3eOC9XXTMqOE1lWqoWuGeM9jqJccThcLBquO0kyLWN917jZ0z1X+cpAHSMVAB+p+Dd0abYj5YAdgK6vU8/xWIfEFJ5ckrX6jiU/ybRg1fBUjaoyeK+sOn0JvT+NWjLg7LpO+/symomW3lFyp2IiYeQf08OFdNzemOpu59ecx3jp+c94O2Ik9e66Wiwtiymx1t6Or/Ttcyd1tkwH/r+oc8fIkfniYlxhzuzvutimkRMS0fwHAC+nMzCLolKHglqu4cMhdYFXUUW3hYozQpWX9GvDcoRnXs1UTkevDm5DwtvSdJvjx4QV4QWHkjAulU5ZS7dQh9Q==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199021)(4326008)(91956017)(7416002)(6916009)(66446008)(66556008)(66946007)(76116006)(66476007)(64756008)(8676002)(316002)(41300700001)(2906002)(5660300002)(8936002)(54906003)(71200400001)(6486002)(478600001)(6512007)(53546011)(186003)(36756003)(6506007)(33656002)(122000001)(2616005)(38070700005)(86362001)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TEI2L3dnZXJPa05Rbk9pazcwZC9yS1JYTXQvVlpvM1pQR1phWE5iUEZXTWNx?=
 =?utf-8?B?VEcwQ0hFV1poYkMzQWlia2FsTkhaL1NWVmdocktUYTUzU2pjQVNFZmJhTDBS?=
 =?utf-8?B?dmFQM2dtV2hCa3pEU3UwRllzbWRDWlJTNW11MEhnL1drVk5zTHhhdW1ONjdK?=
 =?utf-8?B?VG51dCtZNUx2Z09RQnd4T1NCNTBmNldzVWp0UStTckE1U3UxekF3REd5N0V4?=
 =?utf-8?B?dCtDK1B5Mk1UQXlrTXJXWDNiVHdJY3QybHp6U3BOOTg1K2lIdjlCdWFDR0R1?=
 =?utf-8?B?NUpWZ05FaDVkaUhFS0JvSkljQU5tNFM4ZU5QZmFDVDNSYlBQN3FxVWV3N2V5?=
 =?utf-8?B?b25lNStzdFY2ZGRuN2JDaGh5UWxzRnY3THRRaEUyWDRFcHZKZVZrcXVGaTlr?=
 =?utf-8?B?Tzk2S01MSmxLR2dQQmVZZHU3MDZoYks4ajl1aUEyekVTdVhZODZTUzQvYlhu?=
 =?utf-8?B?bGNrcStsdHFQRVNVc01odmlqMlBQaFNZNXZqSjlEc1dPYU13c3NwSGE3N1pT?=
 =?utf-8?B?QVRIYWR6SWsxMHdQcDlQYUhpaFpiV3NEZXpCZHZnUVMrR0lqbjAzMDUvZUhX?=
 =?utf-8?B?ejExNnlsVTdVd29SK3Z0dFlmcVFmVU9BNHc3d09SSWpJOEJvWXQxY2l2ZjFC?=
 =?utf-8?B?YVJZNERPbklyZUVTWnVNSWttQXRWdGRXVGJvZE1tRVY5QWFZZ1YxbGNxWDgx?=
 =?utf-8?B?RTFGek9JWnBtSHhTQ3ltbVZUajlPMFZZdlFVQWNDNURUcFFVWGNTMStFWThs?=
 =?utf-8?B?U0RzMjljeTBWNmNxcnV6YmxIcXNsZnd1SW5ONitjNWVTc3g1Y1ppYko5MXVV?=
 =?utf-8?B?aEVZUWpsVEVMampHTU9MTjVUNFF5b2ZCQVV0V0oxOGkrc1RIcXV6V1lMMG5z?=
 =?utf-8?B?NitoV3pLNS9ISEN4RFpxdmZKUGRNMWlqdnRMQ2cwSjJjaEp6RzFzbG5qVEFn?=
 =?utf-8?B?ekgzYkhCRXhYL2liOVRTdk1EWjZCaUgwRjJUWTNtR2NBUE1QK0VXUVN5eUcz?=
 =?utf-8?B?em5xNHZQVHNzWCtybXFYZ3U2MkY3NnJ2eEJaeUNJczEwM2w3eE85cjVkZU5T?=
 =?utf-8?B?Qm96MU5IdkxCNnNlaHgvcDFjREpweVUrUXRvM2J0NzhWRy9MVGJ1THdocGlL?=
 =?utf-8?B?WlY0dVFqSjBjZzRjajhibWMvbEVvUXFOdDZLTUZkUlNOZEtxRzJjR2NQU2h2?=
 =?utf-8?B?Y0UrZVRhb1A0Z2ttN3NxWmNmSXhJaDBUeC9JMkRzMU9Qd01FNXY3K01tUnZU?=
 =?utf-8?B?cTZHRWE0SmFGQmxlY1I1TlJhd2o2bHR2VHhTUW43TUZSM0JUdzlXMkh5WTNM?=
 =?utf-8?B?djJZaXEzWDQ5K1psY1JqMUE4d3ZPNXVTT3dPUzRiT1ZxUlUzVE45MUdVYmN2?=
 =?utf-8?B?V3BNMkNXTFNNQkJ4QkpxOEZYanhuN1VyUmhRbVVubHhXNmgvS2tkbmhRSmR3?=
 =?utf-8?B?RW1tWHNuVHJDZzlUYmRuVWxZL05LV280Y0MvKzRsM1ZNRit0ZUZYWU1RKzJZ?=
 =?utf-8?B?L3BKMUEwZDRvTGdYOXNOSitLb2VEcDRqUGduZXVzYXFERlN4TzgwZnVoYU9O?=
 =?utf-8?B?cmJUN0dUK0NNVFcrR1VBRkdJT2JCQWhNb3B0VlEralZ1RW8rKzl5Mjg2Sk1V?=
 =?utf-8?B?Y3FRdDIxVXdQV1dKZGRyblBLUHhCU1lSQm0vV1diV1I4UHd3QjBnUWNXSVVj?=
 =?utf-8?B?cmdCRE9LWE8rY05HQ242aHRZd3JhT1RBS3QvZ3ZnRGJUZ1c2NUZ3Q3R4SnRW?=
 =?utf-8?B?Y2xXVzhtcEN3WElHeHJ0b3oyYm91NlR3cGF6OTBmQ3dTWWNHU2JnMitUc0cz?=
 =?utf-8?B?UENxQ0JjWkxxcGFMWTM0bE1hT3hWdjZoaFJvYzI5VWZ6RHdUaFk5R0hIUWNX?=
 =?utf-8?B?VFBRNzdjRHNVcWtaamZzd3VNbWlvSDlWbHc0djBITFZBcEMrVG1CZ0JRNkgx?=
 =?utf-8?B?SFAwTUJRVUdSTzM0aDVkTm96Si9EQktjcHV1Z3lMb3NNaWVWOUJYTjViNnRX?=
 =?utf-8?B?RjhVdDdndGpZWUZpOVFkaFRlb1Nmay9VQTdGQzhGemZmWkRXSEhrRm5qdE5w?=
 =?utf-8?B?aVlXY1JTd3RxRG9nVmhoT1Fra2QrVTN2QzdTTWo2bDFsNmx5U1pmQTdDakRm?=
 =?utf-8?B?NVJQVFhoVCt3VURuTHJJYTEzbytDZjRveC9wcFI4cjBsdHBxZ3Uyb0cxZWlU?=
 =?utf-8?B?QVVxczF1NlpISHZYQjRRVFVuYW5HckN1akUxK0o2MmtOWTVWUzcxY1Nra3Fx?=
 =?utf-8?B?d2tEeExtLzIrUklEN0FxRlNERFdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <817BACAE01B2674993301F9767C1B30E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73857ff3-daa2-41c4-9d89-08db62024c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 18:10:21.6779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eu1VuNLt8M4pl0mvH+FCI1dCasq7by1pLbxXSpDb+hsLqcGc/roDpffHMNq7AGQ4LLzO5WZmpPIUjNgEMBAWJEujhbfsL3ELfDbMsVtFaqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8208
X-Proofpoint-ORIG-GUID: udYkAYvbdABVa3WHS1hqsnrP0j6Rp5rm
X-Proofpoint-GUID: udYkAYvbdABVa3WHS1hqsnrP0j6Rp5rm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_12,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAyOjAwIFBNLCBFcmljIER1bWF6ZXQgPGVkdW1hemV0
QGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMzEsIDIwMjMgYXQgNzo0N+KA
r1BNIEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IA0KPj4gDQo+
Pj4gT24gTWF5IDMxLCAyMDIzLCBhdCAxOjMzIFBNLCBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdv
b2dsZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFdlZCwgTWF5IDMxLCAyMDIzIGF0IDc6MjLi
gK9QTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gdHVu
LmMgY2hhbmdlZCBmcm9tIHNrYl9nZXRfaGFzaCgpIHRvIF9fc2tiX2dldF9oYXNoX3N5bW1ldHJp
YygpIG9uDQo+Pj4+IGNvbW1pdCBmZWVjMDg0YTdjZjQgKCJ0dW46IHVzZSBzeW1tZXRyaWMgaGFz
aCIpLCB3aGljaCBleHBvc2VzIGFuDQo+Pj4+IG92ZXJoZWFkIGZvciBPVlMgZGF0YXBhdGgsIHdo
ZXJlIG92c19kcF9wcm9jZXNzX3BhY2tldCgpIGhhcyB0bw0KPj4+PiBjYWxjdWxhdGUgdGhlIGhh
c2ggYWdhaW4gYmVjYXVzZSBfX3NrYl9nZXRfaGFzaF9zeW1tZXRyaWMoKSBkb2VzIG5vdA0KPj4+
PiByZXRhaW4gdGhlIGhhc2ggdGhhdCBpdCBjYWxjdWxhdGVzLg0KPj4+PiANCj4+Pj4gSW50cm9k
dWNlIHNrYl9nZXRfaGFzaF9zeW1tZXRyaWMoKSwgd2hpY2ggd2lsbCBnZXQgYW5kIHNhdmUgdGhl
IGhhc2gNCj4+Pj4gaW4gb25lIGdvLCBzbyB0aGF0IGNhbGN1YXRpb24gd29yayBkb2VzIG5vdCBn
byB0byB3YXN0ZSwgYW5kIHBsdW1iIGl0DQo+Pj4+IGludG8gdHVuLmMuDQo+Pj4+IA0KPj4+PiBG
aXhlczogZmVlYzA4NGE3Y2Y0ICgidHVuOiB1c2Ugc3ltbWV0cmljIGhhc2giKQ0KPj4+IA0KPj4+
IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+DQo+Pj4+
IENDOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPj4+PiBDQzogRGF2aWQgUy4g
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPj4+PiAtLS0NCj4+Pj4gDQo+Pj4gDQo+Pj4+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9za2J1
ZmYuaA0KPj4+PiBpbmRleCAwYjQwNDE3NDU3Y2QuLjgxMTJiMWFiNTczNSAxMDA2NDQNCj4+Pj4g
LS0tIGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPj4+PiArKysgYi9pbmNsdWRlL2xpbnV4L3Nr
YnVmZi5oDQo+Pj4+IEBAIC0xNDc0LDYgKzE0NzQsNyBAQCBfX3NrYl9zZXRfc3dfaGFzaChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLCBfX3UzMiBoYXNoLCBib29sIGlzX2w0KQ0KPj4+PiANCj4+Pj4gdm9p
ZCBfX3NrYl9nZXRfaGFzaChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4+Pj4gdTMyIF9fc2tiX2dl
dF9oYXNoX3N5bW1ldHJpYyhjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4+Pj4gK3UzMiBz
a2JfZ2V0X2hhc2hfc3ltbWV0cmljKHN0cnVjdCBza19idWZmICpza2IpOw0KPj4+PiB1MzIgc2ti
X2dldF9wb2ZmKGNvbnN0IHN0cnVjdCBza19idWZmICpza2IpOw0KPj4+PiB1MzIgX19za2JfZ2V0
X3BvZmYoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgdm9pZCAqZGF0YSwNCj4+Pj4g
ICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgZmxvd19rZXlzX2Jhc2ljICprZXlzLCBpbnQg
aGxlbik7DQo+Pj4+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jIGIvbmV0
L2NvcmUvZmxvd19kaXNzZWN0b3IuYw0KPj4+PiBpbmRleCAyNWZiMGJiYzMxMGYuLmQ4YzBlODA0
YmJmZSAxMDA2NDQNCj4+Pj4gLS0tIGEvbmV0L2NvcmUvZmxvd19kaXNzZWN0b3IuYw0KPj4+PiAr
KysgYi9uZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jDQo+Pj4+IEBAIC0xNzQ3LDYgKzE3NDcsMzUg
QEAgdTMyIF9fc2tiX2dldF9oYXNoX3N5bW1ldHJpYyhjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KQ0KPj4+PiB9DQo+Pj4+IEVYUE9SVF9TWU1CT0xfR1BMKF9fc2tiX2dldF9oYXNoX3N5bW1ldHJp
Yyk7DQo+Pj4+IA0KPj4+PiArLyoqDQo+Pj4+ICsgKiBza2JfZ2V0X2hhc2hfc3ltbWV0cmljOiBj
YWxjdWxhdGUgYW5kIHNldCBhIGZsb3cgaGFzaCBpbiBAc2tiLCB1c2luZw0KPj4+PiArICogZmxv
d19rZXlzX2Rpc3NlY3Rvcl9zeW1tZXRyaWMuDQo+Pj4+ICsgKiBAc2tiOiBza19idWZmIHRvIGNh
bGN1bGF0ZSBmbG93IGhhc2ggZnJvbQ0KPj4+PiArICoNCj4+Pj4gKyAqIFRoaXMgZnVuY3Rpb24g
aXMgc2ltaWxhciB0byBfX3NrYl9nZXRfaGFzaF9zeW1tZXRyaWMgZXhjZXB0IHRoYXQgaXQNCj4+
Pj4gKyAqIHJldGFpbnMgdGhlIGhhc2ggd2l0aGluIHRoZSBza2IsIHN1Y2ggdGhhdCBpdCBjYW4g
YmUgcmV1c2VkIHdpdGhvdXQNCj4+Pj4gKyAqIGJlaW5nIHJlY2FsY3VsYXRlZCBsYXRlci4NCj4+
Pj4gKyAqLw0KPj4+PiArdTMyIHNrYl9nZXRfaGFzaF9zeW1tZXRyaWMoc3RydWN0IHNrX2J1ZmYg
KnNrYikNCj4+Pj4gK3sNCj4+Pj4gKyAgICAgICBzdHJ1Y3QgZmxvd19rZXlzIGtleXM7DQo+Pj4+
ICsgICAgICAgdTMyIGhhc2g7DQo+Pj4+ICsNCj4+Pj4gKyAgICAgICBfX2Zsb3dfaGFzaF9zZWNy
ZXRfaW5pdCgpOw0KPj4+PiArDQo+Pj4+ICsgICAgICAgbWVtc2V0KCZrZXlzLCAwLCBzaXplb2Yo
a2V5cykpOw0KPj4+PiArICAgICAgIF9fc2tiX2Zsb3dfZGlzc2VjdChOVUxMLCBza2IsICZmbG93
X2tleXNfZGlzc2VjdG9yX3N5bW1ldHJpYywNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgJmtleXMsIE5VTEwsIDAsIDAsIDAsDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
IEZMT1dfRElTU0VDVE9SX0ZfU1RPUF9BVF9GTE9XX0xBQkVMKTsNCj4+Pj4gKw0KPj4+PiArICAg
ICAgIGhhc2ggPSBfX2Zsb3dfaGFzaF9mcm9tX2tleXMoJmtleXMsICZoYXNocm5kKTsNCj4+Pj4g
Kw0KPj4+PiArICAgICAgIF9fc2tiX3NldF9zd19oYXNoKHNrYiwgaGFzaCwgZmxvd19rZXlzX2hh
dmVfbDQoJmtleXMpKTsNCj4+Pj4gKw0KPj4+PiArICAgICAgIHJldHVybiBoYXNoOw0KPj4+PiAr
fQ0KPj4+PiArRVhQT1JUX1NZTUJPTF9HUEwoc2tiX2dldF9oYXNoX3N5bW1ldHJpYyk7DQo+Pj4+
ICsNCj4+PiANCj4+PiBXaHkgY29weS9wYXN0aW5nIF9fc2tiX2dldF9oYXNoX3N5bW1ldHJpYygp
ID8NCj4+PiANCj4+PiBDYW4geW91IHJldXNlIGl0ID8NCj4+IA0KPj4gTm90IGRpcmVjdGx5LCBi
ZWNhdXNlIHRvIHVzZSBfX3NrYl9zZXRfc3dfaGFzaCByZXF1aXJlcyBzdHJ1Y3QgZmxvd19rZXlz
DQo+PiB3aGVuIHVzaW5nIGZsb3dfa2V5c19oYXZlX2w0KCkuIF9fc2tiX2dldF9oYXNoX3N5bW1l
dHJpYygpIGRvZXMgbm90DQo+PiB0YWtlIG9yIHJldHVybiB0aGF0IHN0cnVjdCwgc28gd2XigJlk
IGVpdGhlciBoYXZlIHRvIHJlZmFjdG9yIHRoYXQgKGFuZCBpdHMgY2FsbGVycykNCj4+IG9yIGlu
dHJvZHVjZSB5ZXQgYW5vdGhlciBmdW5jdGlvbiBhbmQgY29uc29saWRhdGUgZG93biB0byB0aGF0
IOKAnG5ldyBvbmXigJ0uDQo+PiANCj4+IEkgcGxheWVkIGFyb3VuZCB3aXRoIHRoYXQgZXhhY3Qg
dGhvdWdodCBieSB0YWtpbmcgdGhlIGZ1bmN0aW9uYWwgZ3V0cyBvdXQgb2YNCj4+IF9fc2tiX2dl
dF9oYXNoX3N5bW1ldHJpYywgbWFraW5nIGl0IGEgbmV3IHN0YXRpYyBmdW5jdGlvbiwgcGx1bWJp
bmcgdGhhdA0KPj4gaW50byBfX3NrYl9nZXRfaGFzaF9zeW1tZXRyaWMgYW5kIHRoaXMgbmV3IHNr
Yl9nZXRfaGFzaF9zeW1tZXRyaWMsIGJ1dA0KPj4gdGhlIExPQyBjaHVybiB3YXMgYmFzaWNhbGx5
IHRoZSBzYW1lIGFuZCBpdCBmZWx0IGEgYml0IHdvcnNlIHRoYW4ganVzdCBhDQo+PiBjb3B5L3Bh
c3RlLg0KPj4gDQo+PiBBbHRlcm5hdGl2ZWx5LCBpZiBpdCB0dXJuZWQgb3V0IHRoYXQgZmxvd19r
ZXlzX2hhdmVfbDQoKSB3YXNu4oCZdCBpbXBvcnRhbnQsIHdlDQo+PiBDb3VsZCBzaW1wbHkgc2V0
IHRoYXQgdG8gZmFsc2UgYW5kIHRoZW4gcmV1c2UgX19za2JfZ2V0X2hhc2hfc3ltbWV0cmljDQo+
PiBpbiBhIHRyaXZpYWwgbWFubmVyLiBJIGNvdWxkbuKAmXQgcXVpdGUgZmlndXJlIG91dCBpZiBM
NCBmbGFnIHdhcyBuZWNlc3NhcnksIHNvIEkNCj4+IHdlbnQgdGhlIHNhZmUobWF5YmU/KSByb3V0
ZSBhbmQgY29weS9wYXN0ZSBpbnN0ZWFkLg0KPj4gDQo+PiBIYXBweSB0byB0YWtlIHN1Z2dlc3Rp
b25zIGVpdGhlciB3YXkhDQo+IA0KPiBUaGVyZSBhcmUgNiBjYWxsZXJzIG9mIF9fc2tiX2dldF9o
YXNoX3N5bW1ldHJpYygpDQo+IA0KPiBJIHdvdWxkIGNvbnZlcnQgX19za2JfZ2V0X2hhc2hfc3lt
bWV0cmljKCkgIHRvDQo+IA0KPiBza2JfZ2V0X2hhc2hfc3ltbWV0cmljKHN0cnVjdCBza19idWZm
ICpza2IsIGJvb2wgcmVjb3JkX2hhc2gpDQoNCk9rLCB0aGFuayB5b3UgZm9yIHRoZSBzdWdnZXN0
aW9uLiBJ4oCZbGwgd29yayB0aGF0IHVwIGFzIGEgdjIgdG8gdGhpcyBwYXRjaC4NCg0K

