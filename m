Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37116836A4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjAaTew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjAaTev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:34:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D694C41097
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:34:47 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VIiGrG014220;
        Tue, 31 Jan 2023 19:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=E3nd4oAuP0QaNBBDnRkSn+299+kFSbjrYI7EkWPynFE=;
 b=CShXrEz3bAxiNhPEjijEyztaO9nuGb1CFa3R9KvounAwyaoACuU6Ei0n/oJf0vEBWwCB
 Z7cVKIo+8s2gnK1YWW7A6J1LepUpRNIM6KC92zte8Put8NQi5dO5/Kzp1aKf0bkD6urX
 ycG2C/UfoDeKCVmWNcn7IbVLMVyKzIVlV9YmhgFSvRquBZKD0YOucvdgTJ5atmX9+fVO
 l6Qgv5wRADP/ridaGvJiYYbpvvLzZ6a3dNKBL9MijC6G76PYT8C2a21H+sXsuBdescTi
 /Kzte011RwoQ4vJUXfVYdqP9180CDlQgcThWVoCaGe+uX64RoBpUt6bdvRXu/wVw0oB+ iA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvn9xhjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 19:34:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VI53Y7035952;
        Tue, 31 Jan 2023 19:34:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct56e1x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 19:34:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwJE/ArsVZbf72IGM0UOcOeWM3ORRbZt49QNu1HtVAC7rZQZ8Jw/SuRd+KbbSZW7oV2L3zoEuLdujfMLHHol/+Np4llz0kfAI8EJU2zW1mqCBFBOiDB7ESdUFojHGEG2SHs0wL4GRF5zgjNG3lzLYpJBUMaEf+pqZ8tjhu4EpC19NRVDX2lMFSnIaXp74bvn1rnu3YnYvyev5Ji6liTDN8vb71AzZHLLWelIVM/kTifa11G53dDIBrJ7JTlzbZ1h2Z19wQs1hgWdn+gQT7GSLH/n+jelhzpeyKgHgFAw8v5W7/CdkRJnBrRlcw5ZGW5X7y9X9J1GiFYaLDFox8/atQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3nd4oAuP0QaNBBDnRkSn+299+kFSbjrYI7EkWPynFE=;
 b=liyqtm6C5et8SeDmvR8HXC1FKLU/CdqHW7UMrV3AdL0lTOpSIfLGMK10YWj60jbVPNXklIhJazKv8f1tB8ww4IDtQWPYFzQY3LCfe4moR2Vkseew3h4cdG7Ldx9QhLUE4I2bdyFFYzsQsJwLtFv0pnRT7FLlq8pnCZEM4lZO0I1s0O1+CyvpuFF1qUGOJ1yDosnQ0O4sUgPvdsG4itmKHjvT5W6Ey6WtZbfKikmEa62TKr5Ykf1nRMgPPU/mNRsqJPooDyTftZaARWxB4K62qicbR9C5AcQkH+UUBIG8jE5XSZ4rOXcJrmj9DXTEvjdFFo15a4HUO+4NbKykuloxNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3nd4oAuP0QaNBBDnRkSn+299+kFSbjrYI7EkWPynFE=;
 b=qX5ZIDvvdEEHoAZc0wKUAZ4J90OM7CvK21A0nhqg/bpruje9n2FPhehiMHqRK1r0nMgck1maaEPU9zZ5XTHj02iYPLzlYAktwU06lcvCIXRcUJFSyi7DKRX+ESoExMt8tHbENfUsql/2FiJsbq/HnDgidSBXZ4BN9x/RFYl4bkI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 19:34:36 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%5]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 19:34:36 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Topic: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Index: AQHZMvMNX3GnD3At1ECXj8a1a7fZTa6z3aCAgAQXWgCAALOJgIAARoqAgAABJYA=
Date:   Tue, 31 Jan 2023 19:34:36 +0000
Message-ID: <7CF65B71-E818-4A17-AE07-ABBEA745DBF0@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
 <20230130203526.52738cba@kernel.org>
 <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
 <20230131113029.7647e475@kernel.org>
In-Reply-To: <20230131113029.7647e475@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB6087:EE_
x-ms-office365-filtering-correlation-id: ea89a7e2-545f-42a7-4246-08db03c22fe2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Q93qWYAIqbhZEV0GL7gDrUKANILkOGbAQf5Bjmnb0KvflExtc4gd4ynhvW8UphoDqTiLe0zB8Nkkuff3poMSPpMjH48KXZd6H7dME3D3J60KsSdkIQHSW5F6if1jiq6ozQ7OwrJwFTig0+4HNStFQHoErOk84ZhHhIJbLgNYhVEYsxSKspOupcJMWt9BwKWeQNU6cdzMOQFFPSIwIPy5YC14yghL3UZ7LXNnY8w8mnpllzzxaurwiY2w5xc0MlkneTs30Hdkm8UZ9fInMPYZr0zAQDpjlrFMb7qAd1Y59T9kXS1YHdeXTLaF1HYVqgbWZWpO3aLqI/gDYQjxVezoZ3dRdnr3KTP18XK5zlL4M1Dg/iJjjhBALjOFM7/E1x0ptQnDr7Yjo4Oq1UAv1JGdLgkFshi43/Y6P+ykjOn7CbM7EIoE+UPnd27AryN/AHL3Np04TtbwJ4R6yyPrAPH/Z9pv0IbSBH/CTNbvDh9ck1KUV+6QOJGy/RA7BPu8I2oJv3eoU+LV11gEBctetcWb19WuMdAgUTZzHcAGrMmUugupw+daWutIkrrBoUE2R94LaDGmjNL8p8SaK31pDC7qfdK8OvQYV5fcIoop6kvOijHmxcwOijqpbiektauzEaGRR5NIosipwtgoilUJLO8dIIZts+PIC+lP+e1f69abZDw8N1G2/6ysWdvxtYlMMSkkd2F/guNOr6HZiEOl/WTyXs5H4UpTR1sJ7Zvrb1o9Aw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199018)(4744005)(5660300002)(41300700001)(8936002)(66556008)(66946007)(6916009)(76116006)(4326008)(6512007)(66446008)(66476007)(64756008)(8676002)(186003)(26005)(6506007)(53546011)(2906002)(91956017)(83380400001)(478600001)(6486002)(2616005)(38070700005)(122000001)(38100700002)(54906003)(36756003)(316002)(86362001)(33656002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mwO4kKTuBTk6YuTV/vS8kxdp13ShDMEay1AxN/Zby9ZtSLEpqVKnL9HXTrXQ?=
 =?us-ascii?Q?JOy8yVF3Qv8mDGU+glxqvuiPSsxHFEa1FwEms3MtNU1NJj3jG2T3OstrLbfc?=
 =?us-ascii?Q?a5dwSZ6cl7N2GkXZE5SVUozt1rP8w6Ra4BkX0Gb5pP4sQrWV9xkzAGCKqSa2?=
 =?us-ascii?Q?MDzEjO2+V6MZf4iJ0IkF48QtW2TChXMJbvSMsl13lQjhIWLEvwPpyGoUqjOU?=
 =?us-ascii?Q?JIq8b34/A9uxQO0gWka4SnJG5RdCnjRGDL1QLkQQ1p/1k9VYQJeBtl+xSoGy?=
 =?us-ascii?Q?svgTOSs5B81ANQqjr4z2sMrr94/+BbpzyvVQULSGyrwqU772Lh878HiHepn1?=
 =?us-ascii?Q?W+W/th8UoLPZmwRFQ7YPVIxXEdRHZkQj2OXz89M8Zh4tNoHLN7AFGF5VwrpP?=
 =?us-ascii?Q?yCq0ykM/Quqk0SsHgvqtpVX1diumRAh1D+aNVspwBvwmdNqy2uCGl7i7Z/63?=
 =?us-ascii?Q?j1Qm41KNGZsPTZyxVSaqx3r2byyH9/3N842BnKAGX4WRGqc6Ly58CzDKSE3c?=
 =?us-ascii?Q?3CaNX37ShsTb3mAbdOd+Z3zVJ0JHHkg3Z9YKB/QbUJh98UwG2ymfti7h+SAS?=
 =?us-ascii?Q?Rr0m7sThT7eKAaDsajaNyR2JhaL2PNRWsWGe+ObV9jIPi+Itm3rnpwQ2FtSF?=
 =?us-ascii?Q?27ZqN4qrxp1tAcmdw9+s30tpzAPv45/wK9FfIfujY/hgygR+C4E1cgwj47e8?=
 =?us-ascii?Q?k4Xo7kPZf6mAcECshZ+EjW269ex4MXLmelkEw2EvF5Jz8j8K4pIm/5yl5Nb+?=
 =?us-ascii?Q?tjXmWFlim3Hqi2ZBXNN7a/U4/cBJg10AFNNy/gB2/TANLtoPcD8quWCJVIz6?=
 =?us-ascii?Q?9K54jbfE6/JkCncsJFuDMs8oe+VCxZQ6zO8vJXZhM0uDvz6tkQs2qK6sUivM?=
 =?us-ascii?Q?fDc/Gj1aQ4u/awv19Re0UoZXRGRRIB6Si2zYgzbRl94a40N2xwyEL/JCg96k?=
 =?us-ascii?Q?6It8KTNO0k0ahb8Zui86i+XdQ2raowXRPidrsKDT5LRk1h6Te8SJaADYM2Om?=
 =?us-ascii?Q?gKAGmS1XVmpNnXrvKs2ClfZ5OzvVKvJ2cQ3rMxIh0VhUxV6IsADtIlQSc9tP?=
 =?us-ascii?Q?Tu10k0RjIsvoL3AjUKFTFvoht0SzxmZe82vwnm4jWMLtU8xey+FX8ppLhsTq?=
 =?us-ascii?Q?Kq0btVLK49+0YC59UXSyNSkNrLg4TEto1176RLzxQilP2IaiCuWhRjFjaBbM?=
 =?us-ascii?Q?vlyoXijS+78aNB19ZL6qBQW8oF2KJ7ULodm9WSlYMk8l4IYL6I7K6GB1LYoK?=
 =?us-ascii?Q?d3bkJep6OvgCIXolt57B4VJK6xxDLXWwhv79bMaimBz5U6b7UHHIwnGXwfAm?=
 =?us-ascii?Q?m6yTv0yqXRghkaxBXX4ctjNHVHNqri4+D9rRqjGVixjIwLRGf2XyHjAC0PE3?=
 =?us-ascii?Q?oO5dVaBjHsN1x27tVRnKhfQLJebTy16aWNlsJ5Js3v0IBUBEwDF2/p5eUu6X?=
 =?us-ascii?Q?NvbudUPUhG7Aukg1k8FqZSu6USUUHpxWaccnPjZmmq4EBoKtfssV2biBHLG9?=
 =?us-ascii?Q?iwPNC1wzmC3cckfjeLYQIPLo65/pVbkG2odCXH0qvqYZEN+9DX23Qj6/fkor?=
 =?us-ascii?Q?53wSBZXXYBZ7dwVUb6XjZgKXR7GJPOnniaS0xSrKJg/SCvqll+urC14XnbKF?=
 =?us-ascii?Q?KA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3AF4440507F1C347BF11238C69BF6916@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nzdN9/ln0MENt+zKuzcdoAkIqZZV5dXi8nyT9llTaHkY7WNx7Bgr0mcB0SaAreI5lU3WZpAX0RSLeOz8LeAhUZ8mhMJq0ldQwdMQv3y3A90N3FWgtjpWIgVvftE9BokgKPUM7I08AotIstnIIIGNSX6HS1Fi8qfglr6sdgeDa5hJ7eVmVz9h+t4FbLcKnZZtjqkGf19azwm0O6fFukxz1ArRLMWeeRJmRXyyGI1MxdoQ0cnn17YJaeD0/XQHdvOoh23OPQ+kfQBx6wLiDSXP2k+tuP9nX/pTZLwPQn6xzPoQhrpf/3gaAiGG19c9cM6l1k8veRFLBASRicaS8TSvcEUCmVm2CLncSfvDGuWx4ECd8vYuPLhbOstuGFkINucYP0Zo7hHxyHSTIgxAMDWIkCX655Ag3l3faxbEYdFWC1m8xUjPtFo1fhPRov8VSCZZ3/z6oCMoKrNNOJV7zARMZJ5YyQSpCz6J5gAo69J19keWNPjESF3EaK8fIx0EcoxZZv4IBsUQn8FW5mma5itsrRsM8EbAuwQA7Ei+A096amvPH1+s7+vfFK0jBKNyeiCxUul69p9FjG7ZLofC33FijGCXj/0PsQ2rLkpG0hhoC7GGY7LKAHdYv48d61Yq17kPYjmztbVi4j0XtvkdymYTy7gu4jcqdQkaxmMfBL414Z9qlE7pVi+Qj/jLJs4yfaJRtmPyZ3+U1CbRofMQtV5TkQeEp2AL1h5JQ8xCQLQMLZBwmVaL22sNxYhGw1I/ToRhXlT2jXWJcVF5M+L8nCrOny9Peq2hxZObOuoMIcLQ9xPagwMYF9EG5fA/3ywMUx+XKtOpQGHyfVw89PnHizOUQV6XnVSYX9cJuaawSzHEjqjRhUsHNK494+IwQTBe9MOR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea89a7e2-545f-42a7-4246-08db03c22fe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 19:34:36.4640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0fsyEqZaf+/vcbJLZyX0tnz1pBR5GqFW46kShTjZc3mE/yE6FsOgqc56EuVKoyhmcfdOvUUTDLh3nC/aJTFWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301310170
X-Proofpoint-GUID: sYh8CExkQtbiW5aq7NMGaEjT4_Nf651T
X-Proofpoint-ORIG-GUID: sYh8CExkQtbiW5aq7NMGaEjT4_Nf651T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Jan 31, 2023, at 2:30 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
>> On Tue, 31 Jan 2023 15:18:02 +0000 Chuck Lever III wrote:
>> And, do you have a preferred mechanism or code sample for
>> installing a socket descriptor?=20
>=20
> I must admit - I don't.

As part of responding to the handshake daemon's netlink call,
I'm thinking of doing something like:

get_unused_fd_flags(), then sock_alloc_file(), and then fd_install()=20


--
Chuck Lever



