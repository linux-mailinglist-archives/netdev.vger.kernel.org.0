Return-Path: <netdev+bounces-3968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71337709DA6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B2381C2135E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7B7125D0;
	Fri, 19 May 2023 17:13:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762E12B62
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:13:32 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF6219F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:13:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JFx6jD005908;
	Fri, 19 May 2023 17:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=eQyHWGp5v7TJIU8ey0eWCOHzFVoZzv6A61FYlx6f7P0=;
 b=x1xVRYjwjrzCbbIcrkqW90QQdOx1a9JJbo6PqtRv1yHNqZ/mufFJEGIhA4eYE7pkrC16
 I0HB+o+KMBrRVt6ixTdfscmWUVLvBRILMSBWrvnq5X7Hj3O7QkvG6NeHNZw7XElNWD2X
 EMNyjCNcdNs/N/Dg8OdljqNkm0sJQmyIvflHObM4c/NyAoQAvi35IX9ry0QAEhc7mfq0
 xBfnZfPConvUwZEvEprOnkfiHyHvwD5kTBQMvfZOoSweEEAYvzR/nsnEoYeSArT8Iaq2
 3W5AggMRw0tqcSt5Mh3i9Wc/UEDX/58hy1vCRRaYFssVgZFLsVrc1ZYwcrgi0dWiroqV ww== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0yeakas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 17:13:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JFkl2j036239;
	Fri, 19 May 2023 17:13:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qmm05bes1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 17:13:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgCjkViOOXwWPBbLBjlVhjLx4H5BHwnBByTsB5FF2ogSt+BcIk5T+//aFg7c8EHHlai+7bCLE2+haeLcjxOCmaiDGoTcIqn7qF5X7hcJyKHgW1SGYYt05l6swqVeyrLE/DRFajEVB6/pxRjAb8tauTSQWZySyqnRo/Sd0a2FMlUThjBUwDTAIzxMZvqv4OJawM4fAsGahDWbcKce8ec7EuNypay4YJRXYcW4pMRvGQKueOTyKpNd9qc4GjPNJL4OMo3Jpu0F72rSvM1k8AAGnI1CT8VkAINCMNwCg9jG6Pe+dO8RD6saOUXDnsLAIvqJNlU413BBpa2Kiw9vOKNx0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQyHWGp5v7TJIU8ey0eWCOHzFVoZzv6A61FYlx6f7P0=;
 b=DTDv0ciVCeKC5SMEkBqa57L++r2zlcqhyJ1Ty6G2V7HH8q3hMEF6RpDqAC4Oueejj1wKX98yFiHx2IIm/Xy5z6aXAreTvr9ZM43nsjNMOwr69xqBnj6Tfp/SjJH8fIpf1AGd42/JnPtj9Q4kgWb4j1/cvg5/hYxnbUhWQwUTOsUWPf8TnOMSfq/wJzdQgAXuQbzRJQ9keSsu9dn/PsQ4uDUO11IfbH3L3gjwOeexccvJ9cgN1gTc1nFTtDn+BvxagXJwmQHc9/utKGDr0pQ9FkyDJ7w5xtaJE0GtLQ6WWVI3LJIkij0mR2pO99A2rbdGze1noxQxiQkiiDBbTrYwUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQyHWGp5v7TJIU8ey0eWCOHzFVoZzv6A61FYlx6f7P0=;
 b=w/3lqMdggSM1YERsjjhfBMcvlz7J+uSRPRmkvDcAN9XS65SzsJToliq/ydw7ONgLiqEjOAiGk0JTwGYxFnVNnv+lI6vtQUmBGW3K8337uVKO1iHwApFScj4gvaVXQVeUpbInG//HNBEvHBNAe2prjxtLj5Hpn1ALTw6Q1Teg7Gc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MN2PR10MB4381.namprd10.prod.outlook.com (2603:10b6:208:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 17:13:17 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 17:13:17 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Chuck Lever <cel@kernel.org>
CC: Dan Carpenter <dan.carpenter@linaro.org>, Netdev <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH] net/handshake: Fix sock->file allocation
Thread-Topic: [PATCH] net/handshake: Fix sock->file allocation
Thread-Index: AQHZinSPmBZZw0Gk50+dW6q4wkZ89a9h1XEA
Date: Fri, 19 May 2023 17:13:17 +0000
Message-ID: <68C83941-D81F-453C-B717-10AEEDD66BBA@oracle.com>
References: 
 <168451609436.45209.15407022385441542980.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168451609436.45209.15407022385441542980.stgit@oracle-102.nfsv4bat.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MN2PR10MB4381:EE_
x-ms-office365-filtering-correlation-id: e8c1ba2f-40cc-4e47-2a0d-08db588c5684
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 v57qvFUwuGBPhY55zXp8+7DV2r1whdDw75gS9EJvhl+6ajexMABFBFywNAnA/t/G5OabLRUY5zK5d6Qtm+GO55x4rmHx5G3+41cXus4M8PptfKiQasTIv5oZrhUAKGWkUcw2f45eo1jjk682j5exGFW00D1PcME6tbuT5TFOXwVUTSW4juYOmo/vGZMRrwWQBEHSV7u1zxYvacxKWek9h5/xcpKNBmq3lOU6QueUxOsOnklFzb8yC4RRwI8KqQdGKEGn2DTrN0v9LK9Sme8FScMq4IP8sFfuR241gs8+jMyJbwdCSbIZIhW4UOXS7CoMJAJP9m/KczpE32mw/YpqFT8OispnLMKLhut2d+N0fKvlrVARy99h2AmJM57elpCzHe74GwBpKIEwkxtbEiErUU1Ck0nrFdDxoCEM7V4aX/kvBTSdnCNtjRFcyuldgGOl4bQLTVF3E6SgchUrlEXm8Twn8BKnPr1/PoXsEJDQdaOfFhLV9dd0zGuhsB/YExS3lCmgUyS1DkGdVB6/hAqI4aFJRXtU76jIoGzgba/3NGL38ysXlj0IuTjnMXWWQi9EAYKLM9tjtX95vEeWYukZ3AZbmiBV5iSWxbu5l79GsuV9vub0FmU7Xzr2O1H5QH7Em0cbSmsMm57MRmvMQtbWaw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(5660300002)(71200400001)(41300700001)(2616005)(83380400001)(2906002)(86362001)(38100700002)(36756003)(122000001)(38070700005)(33656002)(186003)(8936002)(6512007)(6506007)(8676002)(26005)(66946007)(66556008)(76116006)(91956017)(53546011)(66446008)(6486002)(66476007)(64756008)(54906003)(478600001)(4326008)(6916009)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?JpWh4zsGct+qIKbF19Ofu03ErI6K1LPMBy3Lxvos9tm1mKtV+a+BeVGF5JJO?=
 =?us-ascii?Q?K9wJ9yFJRwNe73hzyP8Xsg0ez+KDhuPcf0CkwlGzQmCksKPdHuqg0CJ/KSPy?=
 =?us-ascii?Q?y8mRVMuf9vKjIqZZGDABsnPRavTQ+sLFeIIY4nZhGkhOk5pwb13bJaS5FbDA?=
 =?us-ascii?Q?K8OCcksH/3uw4pB6PkL8goCIedXWweBAWO3Z5PmATRs9WpyRxB/Fn7JtxF8j?=
 =?us-ascii?Q?AKo55PLpSA5KN0n6nm1BYMBJ2OIGNftF9jh+01QIjp976XpP8JFTKWaFy6ss?=
 =?us-ascii?Q?1oHgmDkvWCxNpweWXAJpk4FvxKaAuov/Lkps59yUD6qsubaDpeSVS7PHUqPw?=
 =?us-ascii?Q?XUocIrocsmn2IfNGF+g23OBS0+toOHfaDOsrtYF34axVs3eGUVWSYxIeVO9a?=
 =?us-ascii?Q?OL6FYfMHh/EodMuDEVHEA+q5D19ShQ42DHQ9Nw+YW7oUwXh/hULqksNBP//P?=
 =?us-ascii?Q?Q1/Z5a7U5DQojdqD7o7+uSw6J6kuKUAohLZZd20VU3BMXvSd35CXNSh5hRJ6?=
 =?us-ascii?Q?w+8sNuJ/TugYCJe9pCwByZx7LkjgAvJk4KoPUuJyiz2b6HO7Jjt416J1Pc8W?=
 =?us-ascii?Q?5i9IFh/rbtXBHorUhXvK37Wjv3oXjeL7dX1oEWm8xX3WHmoXNVWwixnw7rGq?=
 =?us-ascii?Q?BlX4W8YJVrQPu2AocVJlMwA0+4AAQOLsI89goMmtR8wmcF1uKyfIaD6MpGQH?=
 =?us-ascii?Q?2T1bb2use8aufj38lWaBmm4++DxYzUN1ZgTS6ATHPvNy1RYrbv816R0NpUcT?=
 =?us-ascii?Q?odLz5sRxIiUrn9g9GUlKxi3lxX9MvubqgjP5Vul9TZlSIF+xUlLN/X56ivrv?=
 =?us-ascii?Q?/5PRovwFgGKz+su17VgTbf6e2JuUCQ863k3wGQOUa6Sf34/V2YWWgVsr281t?=
 =?us-ascii?Q?IpAuWzxZIOYxSOb0ec98SIB9yMD+ooObGbMpGSVh2cTp2uaByTHd1ZmzGkKU?=
 =?us-ascii?Q?XMGWBnqch4Oaf0iLNwmzoaEQ/8qLJ5xbg2Hd28QcIonvTYzoZLr44I/xvf7d?=
 =?us-ascii?Q?KYSxRO1TAXSxNo/UgHHearsjYuds/CPy5OLvWIlA27rTTeEImWdkFeTK+ySL?=
 =?us-ascii?Q?aF8+VaVWc4mLUHg8BTRhPYKCVWJk02feOli1GflJpswzy736PojiX2cncpSj?=
 =?us-ascii?Q?mgLdBDuZWma3613gmA0t1WMnOJR2mXkYofaA7CX3NAA9G9qi59kng2VlUprm?=
 =?us-ascii?Q?0MTQL9rMlv8Nb4KFICN5/z8l5TEMO/T4V6KHiRpeMq/ZOZDuUt5Yd/ZBt5NV?=
 =?us-ascii?Q?AFIPocEdmikayOY1tsldQe5YJ6pMZyrn7VJr1XsLTx/mHl6Q2zWssI1HXckA?=
 =?us-ascii?Q?6ftqzLbsw0GP+Opd8YF6n2aUg59zDWnTV/8Qy98m5HuR3eF2tbFJmkOFCob8?=
 =?us-ascii?Q?u1O5wuo5bFX3RWduzzG4uc8HDjnpjiTNX0OVt46PQx8Zod3XDpeyq/5s+QsJ?=
 =?us-ascii?Q?aOJTCFIwN+aKT81CaA5taiA7nCtgW5dtflfvXDb2GJ3MMgE3aaJO2Aecxkiu?=
 =?us-ascii?Q?D/PqBf1nb+RGPm4W6zyjTCmSHaatxhIKks2eXu4lBBxCYUn6nEGrm5A+4Ifs?=
 =?us-ascii?Q?Ts3atjEL1Xhw4BW5au0riYbsocJQuJmbrbcU753bACBDLfWPhExPRhnZglmA?=
 =?us-ascii?Q?oA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7D9345BD38D4AA4698A3DF381F1F1094@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MOsb3gcNWfVQqfa58eh3Hk/VP4AX6yS1pTp3ttwXeBylV22H+javTEm95TxK6WzSzJkm1QxMbdRK8SccWiJXC7oZceX9CBHk/rB6L1bhaRh6OUk/3noeKVYM7NdyaMsHCRBFx/YXMJg7QELQIdIldeUUP0U79dzD/cwmrinUojOYQbXrbNDK6tUhzieEd5dCAzyZuSEfTGerBCOQ43aym7tCFOIFlDuNfiiIggxo1Suyc4+Z0Je5ZRTx/k1NjCB6mX42dbyppjhC1q+FxgoZ2DKUcB05LHXp57acYqzijzWvsNxJKswwEP/95iHxsXElJQzbnp+PbsIkaj7ZgZxKWGYWz2S2Rb+wUTjMZGgaV1E2BnDyJNDfKGmcTsC4cK30vCyQfXvNxm1BwinzsHU99hs3Zm36ZndxnM9UX90i4tu+qm+uB6n2lvs1eGNuWS1Mq4L+DuYNngk1awB+YQS9B5VG5tjMp6AF2WXT2b4of2o9lDgbCmOm2BVyExP7XfB4yKG3UGnlZTAvuUftkx5yZz8sYBB6+JXILWJtdKmtTw5XlzZo5cmuMJi4M50Q3Wrwl7yflZ0nxpkgUuSC4S+zvjAURr9EWczbHJdphxxd6DFKJXNAPtD2EJdEaTdbvnJJT3Xf9dKS43sJZ6oI4AR5DFTIYfmKQyjJ9WlXeRiBs9RyuzWEIzfXYL/OrK9wEX0Qy3hWQeUj/etPz3P9//aXEL6mzYIFD4KTreDckImkX38Hd/eN4Vm9eVb72h24QmaWC8iA39QVIqAbs5OUTdw9bx+YU3WBkgg3PhFIo8ZmKHhoHSe0D7i34Apa3FmtQb64hUp9cmmJZzlXQsQxlnQDgYok3YtWbfamY2qQNOtcDok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c1ba2f-40cc-4e47-2a0d-08db588c5684
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 17:13:17.2966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kRuZWq4n6Hrdlr+CWHQ3mwogvms4+auaRGFReAdHsI/6i7TohRSDKLDUsSHN394JFKticiuXZPZ8g2Bvo+3qCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_12,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190147
X-Proofpoint-ORIG-GUID: NUH-gFyYpesJWNECSRIz5uAmhStF1JAV
X-Proofpoint-GUID: NUH-gFyYpesJWNECSRIz5uAmhStF1JAV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 19, 2023, at 1:08 PM, Chuck Lever <cel@kernel.org> wrote:
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> ^^^^                         ^^^^
>=20
> sock_alloc_file() calls release_sock() on error but the left hand
> side of the assignment dereferences "sock".  This isn't the bug and
> I didn't report this earlier because there is an assert that it
> doesn't fail.
>=20
> net/handshake/handshake-test.c:221 handshake_req_submit_test4() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:233 handshake_req_submit_test4() warn: 're=
q' was already freed.
> net/handshake/handshake-test.c:254 handshake_req_submit_test5() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:290 handshake_req_submit_test6() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:321 handshake_req_cancel_test1() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:355 handshake_req_cancel_test2() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:367 handshake_req_cancel_test2() warn: 're=
q' was already freed.
> net/handshake/handshake-test.c:395 handshake_req_cancel_test3() error: de=
referencing freed memory 'sock'
> net/handshake/handshake-test.c:407 handshake_req_cancel_test3() warn: 're=
q' was already freed.
> net/handshake/handshake-test.c:451 handshake_req_destroy_test1() error: d=
ereferencing freed memory 'sock'
> net/handshake/handshake-test.c:463 handshake_req_destroy_test1() warn: 'r=
eq' was already freed.
>=20
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>

Fixes: 88232ec1ec5e ("net/handshake: Add Kunit tests for the handshake cons=
umer API")

> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
> net/handshake/handshake-test.c |   42 +++++++++++++++++++++++++++--------=
-----
> 1 file changed, 28 insertions(+), 14 deletions(-)
>=20
> diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-tes=
t.c
> index e6adc5dec11a..daa1779063ed 100644
> --- a/net/handshake/handshake-test.c
> +++ b/net/handshake/handshake-test.c
> @@ -209,6 +209,7 @@ static void handshake_req_submit_test4(struct kunit *=
test)
> {
> struct handshake_req *req, *result;
> struct socket *sock;
> + struct file *filp;
> int err;
>=20
> /* Arrange */
> @@ -218,9 +219,10 @@ static void handshake_req_submit_test4(struct kunit =
*test)
> err =3D __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> KUNIT_ASSERT_NOT_NULL(test, sock->sk);
> + sock->file =3D filp;
>=20
> err =3D handshake_req_submit(sock, req, GFP_KERNEL);
> KUNIT_ASSERT_EQ(test, err, 0);
> @@ -241,6 +243,7 @@ static void handshake_req_submit_test5(struct kunit *=
test)
> struct handshake_req *req;
> struct handshake_net *hn;
> struct socket *sock;
> + struct file *filp;
> struct net *net;
> int saved, err;
>=20
> @@ -251,9 +254,10 @@ static void handshake_req_submit_test5(struct kunit =
*test)
> err =3D __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> KUNIT_ASSERT_NOT_NULL(test, sock->sk);
> + sock->file =3D filp;
>=20
> net =3D sock_net(sock->sk);
> hn =3D handshake_pernet(net);
> @@ -276,6 +280,7 @@ static void handshake_req_submit_test6(struct kunit *=
test)
> {
> struct handshake_req *req1, *req2;
> struct socket *sock;
> + struct file *filp;
> int err;
>=20
> /* Arrange */
> @@ -287,9 +292,10 @@ static void handshake_req_submit_test6(struct kunit =
*test)
> err =3D __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> KUNIT_ASSERT_NOT_NULL(test, sock->sk);
> + sock->file =3D filp;
>=20
> /* Act */
> err =3D handshake_req_submit(sock, req1, GFP_KERNEL);
> @@ -307,6 +313,7 @@ static void handshake_req_cancel_test1(struct kunit *=
test)
> {
> struct handshake_req *req;
> struct socket *sock;
> + struct file *filp;
> bool result;
> int err;
>=20
> @@ -318,8 +325,9 @@ static void handshake_req_cancel_test1(struct kunit *=
test)
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
>=20
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> + sock->file =3D filp;
>=20
> err =3D handshake_req_submit(sock, req, GFP_KERNEL);
> KUNIT_ASSERT_EQ(test, err, 0);
> @@ -340,6 +348,7 @@ static void handshake_req_cancel_test2(struct kunit *=
test)
> struct handshake_req *req, *next;
> struct handshake_net *hn;
> struct socket *sock;
> + struct file *filp;
> struct net *net;
> bool result;
> int err;
> @@ -352,8 +361,9 @@ static void handshake_req_cancel_test2(struct kunit *=
test)
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
>=20
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> + sock->file =3D filp;
>=20
> err =3D handshake_req_submit(sock, req, GFP_KERNEL);
> KUNIT_ASSERT_EQ(test, err, 0);
> @@ -380,6 +390,7 @@ static void handshake_req_cancel_test3(struct kunit *=
test)
> struct handshake_req *req, *next;
> struct handshake_net *hn;
> struct socket *sock;
> + struct file *filp;
> struct net *net;
> bool result;
> int err;
> @@ -392,8 +403,9 @@ static void handshake_req_cancel_test3(struct kunit *=
test)
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
>=20
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> + sock->file =3D filp;
>=20
> err =3D handshake_req_submit(sock, req, GFP_KERNEL);
> KUNIT_ASSERT_EQ(test, err, 0);
> @@ -436,6 +448,7 @@ static void handshake_req_destroy_test1(struct kunit =
*test)
> {
> struct handshake_req *req;
> struct socket *sock;
> + struct file *filp;
> int err;
>=20
> /* Arrange */
> @@ -448,8 +461,9 @@ static void handshake_req_destroy_test1(struct kunit =
*test)
>    &sock, 1);
> KUNIT_ASSERT_EQ(test, err, 0);
>=20
> - sock->file =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> - KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
> + filp =3D sock_alloc_file(sock, O_NONBLOCK, NULL);
> + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
> + sock->file =3D filp;
>=20
> err =3D handshake_req_submit(sock, req, GFP_KERNEL);
> KUNIT_ASSERT_EQ(test, err, 0);
>=20
>=20

--
Chuck Lever



