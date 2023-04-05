Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC7B6D719C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjDEAo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDEAo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:44:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E259170C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:44:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334KoorB023485;
        Wed, 5 Apr 2023 00:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EvCxzfOgofnPjc/UgFicLV/Zp6aj6uErG6OkUMFidoQ=;
 b=ycrhiOhHZtYpZn0VWSSjW7PxX+sptKvXGj+1Lql9awNjKE3QrqPSqonMbMJ71tpT6T/5
 txro2z44jlNVy3UrCko5kJbvxngduKCLQklFkuhZDBx9LpIZjgxy+FmM/H+lvdnxcBEL
 IMHLWvsI8kR703RzgoeUGZ5AfS8gvEkf2KNrxdCHUPYKV/t55p/kpE7FWUgZXFdOPGpv
 PzWOdZvKGo8FaOc09hKlu3yT8eDn/Le3EqRHGc4pcwf4ujkUJUm8/nfG2lLmAmaTvNGq
 hfM7AYrj0QI4+pHud/kwuocWpUhOiL0vGvo/5U4qvfVNZFZYOByzF7i5mizjPclM2lKy PQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dq640-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 00:44:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 334MLRtS037729;
        Wed, 5 Apr 2023 00:44:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjswfev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 00:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSkkbMftkQTnbT2Vo6eJvZ0JC53UsBznHhr2vPp62UtuBAkFJ2nFXyZeMJzoOxwmluRhZoLUQbCFvOUPWZ/ZG+arBhKia+7YnDiuyuHuM0PSTJP3hzf4SUXV67QG/lvHBHKCrntJmkn4qh2jQ85E8kQfg5VQp7wMevVPflQqCwQPLWJBA0Jmh5n/g9c09xzXEQDBCmF/3tRf2/8nmSyHFk/LOtuu6aQRt6pyOfJpcDNeNUjU+Y0nU540zbflBvQpo8EEsyAhIkYr6zRAbAQ7/NYBUKWe+KjVv1sqef/2FNvgljEGOM1fk3gumpErb8WwzAhr9cYJe29RCF1/S1uCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvCxzfOgofnPjc/UgFicLV/Zp6aj6uErG6OkUMFidoQ=;
 b=dr9z8I4ellHn+evdP8am4wgn/o8NyptEz/7ErU74bJP1Tvnjvdcmf+LTuJx82hI0kr4PhY6oNH77QXpUln/LLgUXzn9V++OEuA3bJPNcjutFVpQxhWJEcentLDlPvIKjSSetJOesusFsXPvWCN7y5vRqjOGqXB/Sl7ickJJXF+vCzhW4vOiiUvRh61nev419Cg/z7le+8YWq9+jsU2bvxhmFffdTPYcA9gEn4l/2vWtQ9RkQoGlM0J6B5SRvIJb1El7bPMsiauUXxrgAE5glj9yokhCw5LZtx1JkHnbDlAS0BWM5Oj7amZD1591LV8UYyOMLPih6fmVgy7WrK7ucVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvCxzfOgofnPjc/UgFicLV/Zp6aj6uErG6OkUMFidoQ=;
 b=MSTeDIBlXnz08iIfTKty5EVNqPyACcFdaPBMiglgI+41Lv259ttAZSx0lcEnTEQEHY9pgc3iydRx/lnLsgq9+aklk+mQ+LfyHvx0Zuwq45GMyIGtZJxHGbYLQNqi9KlhyO50loAsSA3qjJ5dYvFhEotDfakXCdAcVybwPHBqZX0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 00:44:11 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 00:44:11 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZZlySHnrWBVVuSE6PrOQpkUIzqK8b3OoAgAAFyQA=
Date:   Wed, 5 Apr 2023 00:44:11 +0000
Message-ID: <D178AE57-68B8-4C63-8211-1F745ACC44D3@oracle.com>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
 <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
 <20230404172318.58e4d0dd@kernel.org>
In-Reply-To: <20230404172318.58e4d0dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH0PR10MB4567:EE_
x-ms-office365-filtering-correlation-id: 86ef044a-46cb-4937-3194-08db356edf6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSYLZnq+CuXyDBNcDq4B73A+FcOsvNjH2M+JbVw6IZZqVHlnD1kW679GWWkygAxyhVfCIHBkuyrUiSgdrnjFfrt1Nm+UOZRSJYSfAVGGZe9GpFw8KgmLRvLz1/uLTUNBP3jlcAaTbAcz0CpYD2PB0qg0YeZ8HQ55B6LJq9ZiZrCF9bONcMoDM2M5ukVK8vosiX8RNkjOzrP+0HIEwExppfrAweN2ChAjH1kOhEBC3hxyIicw4elurC+Bo0ckrn3iECTocYp+HEax4I1aDGaKqGmYKjFWKXCC2U3T5MNAVbpe7MFsqasqFacXCgemF4QcfP6iec+zvWHByBk7rfBYQELvp6vVP/Devv5Wtp1neoNv6lj+2t19BjSctbzHwQqjFCECrGcI0VZolKT2W/vafeIwuTogG4zgJby9vgNC+LNA1Tycp5fZTFxrs1UlHHpdjPXveEtdrS5RWKe71pE8yMr/mFlRzmQfehmaWMfadEtgcWeZltOrVMJ8oOABUCvvP385nNfu0k+9ENH/bjh4+6Cs3LUxsi1kBVmPaquK96Us0rVfQPwSmlDKQCmQ8UfE4JxFfBvrI/NEPEgNgXe++oM4GAEYw5A8dCxPG54zuebB/vNhfOfHQNLkZV9KSw3lJt9Gu86zd+61VLm4jZ369Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(186003)(53546011)(6506007)(26005)(6512007)(91956017)(66946007)(38100700002)(107886003)(122000001)(41300700001)(6486002)(71200400001)(83380400001)(2616005)(54906003)(478600001)(316002)(86362001)(2906002)(76116006)(66556008)(64756008)(8676002)(66446008)(66476007)(4326008)(6916009)(33656002)(5660300002)(38070700005)(36756003)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?psmkYcfajRedU/fe6RQf6gRlpH1meIKM9MlsqlYV/FXzAVWDxg1Q7PePjxH3?=
 =?us-ascii?Q?ZTghO3JbGhQH7AWx5jnOuh4a9kLO1S9h19b0hwf7kbqWwteGY9GHujQOuZXQ?=
 =?us-ascii?Q?KAAwgNjAo27aoOxZKeu1cENWP3QSbrmcpKO0uWIn/tgWptWMUxLaiAxRUbaA?=
 =?us-ascii?Q?/fTKYmXCbW/g2LR1tdNskfGnrXC7zagt9ghC6HQFRQfpUJAo4fSVA3d2wJ6A?=
 =?us-ascii?Q?AAHOp+dHBXs8/bZyLy1a3DosqeyNLhVpyfEpxBOnLTvwCiPwbWc40Wf+w7n6?=
 =?us-ascii?Q?oxTW44ZimWQincxeFOHGvB+LPAOR16ycZL7Y8gZeIsb34X2ZifB06n5qkT8M?=
 =?us-ascii?Q?sLfyLLvvYL9AmFbSTWyTuW9KkNycZY8CIZbfm9qsjxYB/REjukwu4nALPEqQ?=
 =?us-ascii?Q?C/Boz8cDJpN0SMazjxbyT/Juh2cSkbFeD4HqDrpJ/+8CEuVPZwnrOy9+drHN?=
 =?us-ascii?Q?TCXkIeV3OD1034pp/7EnoV7uONtDTb3T2MxhTzazY6zL5lxzBm/e4W8TePos?=
 =?us-ascii?Q?iFZ98qtkpDemjK0k5y+w1ufuL0l3syaGJPxztWSLaQ4RMCmEuw4mELsFmKHK?=
 =?us-ascii?Q?g8jKI3Zkma38foav/zI3DEVpqtydkZmEVfi4qE8BEKYiudL+WHk4dRe+zcTg?=
 =?us-ascii?Q?29YjG0osVB5VoIEGjeCs4PV8/aBPssj0IzsPXdCLIwHQNEK0EZvhgH9/281G?=
 =?us-ascii?Q?FLr3B2Ox4FqmRZX9a6h+CxAl3PiVcAu5tTLLI+ourBoAcLP7Y9uITGXV55p9?=
 =?us-ascii?Q?PJyfEeYavZ0DUPYNeRzOYsVY76yZiMwKicd0nMC/AY4dx/YeuYLaKRpN451V?=
 =?us-ascii?Q?ugp/ZDIbJhtRxStKd+z/1TVkcEF6NmKv0MP2uG7pruhMdQ507OMGDtxGL0Vw?=
 =?us-ascii?Q?gfKz28SSeUqLIUXQWsyD39Hf0c5Ehnjy9kiqN0Qooi6YEDTeddDnxB6AJybY?=
 =?us-ascii?Q?g9UNmItlLC/sjQnQl+9TcogXKc53c6b0ab0gQE9de3hEV0aI2lklu+STWdOa?=
 =?us-ascii?Q?mLKkEyvBS7sd0RENWch983ZH83PihH8U6ZcU1pb98LFG542V+3zojSN5d+sQ?=
 =?us-ascii?Q?xbLAOZ6rxxRezwi2xkLLcfO6i6dbfuvUciOJbKASC913d98p0UMnhwFpO5g0?=
 =?us-ascii?Q?CODqs0XhE35Un0Kb3Tv2PbNM+JgPbx0WjjeUoY3HCYY9lQdhW407+lKaajdC?=
 =?us-ascii?Q?QKwjbII/BCCekwP4OsLcmpMXWXKvz2PCK4QXm+Wq+d28MrqgK+MIUAIvLaMp?=
 =?us-ascii?Q?UGLJyqjg90onJ/t6lzQol2Vc0mTQ9K4aQhnn69azHwn44K05KfXHo/9wDmXC?=
 =?us-ascii?Q?Jr8zH0+u2z0LeJ8KYTGj4dDWnzDQN87PKU4waRn4hkrNM4CI6x7WlJjr00uI?=
 =?us-ascii?Q?LWTA1riYBW48q2SSRhmYFa1BQwVwGVs5XF9poeLLnIYAih+A4J90ArTdopGj?=
 =?us-ascii?Q?khqKbuG7/3LytP5G8PMVsTOGmPrho2LcJhVJxyxGJThHy55/LmdHgX8x27Wg?=
 =?us-ascii?Q?A66MP019vp1aOsWrK2lBOw9qi383jqvmVeArMbS+Bz6WTYSElhhcGAHAcU/+?=
 =?us-ascii?Q?YWG89sF6whNjqMNTboAPBMxmB5FRm/xnHbtREDCnG7rrw3vrNrN3JitX/b67?=
 =?us-ascii?Q?Kw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17C526195741604E9EA44E351D6B9342@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CriU+VaADBFrY5pmmtlWakJ/UjIdP+LACXXIrc8/CJRT655qHs9aLpOXqFCYYvqrUmAW64bz2pdO7OTdIs+4obcfUBgADLjm5XPfX5O5VwXO9q7DZGPyzdg4eRRzuMGp0+xGkbd8S82W/3GhBfuSngIkm2XEw1Wdl/3udMZxvXVLJDyXruoclUlhbeLLioZ0QWRxVvGc8flJDiE89ixelsdz+IEy+vmbA/le6d9L26dk9VUktOsrWl71bpM4MRQEJOMNhkM/nx2LlA+PF+7OBhL69ijpiKJ0UykeETiTvGR7QQkmkPA52VYN6bp8Yv0xNVzsjSY4M5MOnf4RzT21loGT7qspEjhWpmI6+h4ULezedF2yEW7bOSt3UnrE/W3ktuTJZkQMT3j7XNU8gRN64rYw2/ENFJpPft8v+YTnfhb4EjIBtSEECLObYoi6+5GtLBVYyHw55gi2gMxJtxdtAWSan3CbsxCWgLskA71w3lKNBinBvqIntOor0iL9qQ8nNAxhH37BMnI4xO8G7nCXmuV0K45FOeCFdHewzaQszECxtGBCXM+QOmTdgdNs+P4t9Gkbp1P/JR4axsQP9rBpiFkKlILgtZEzcdy16da/nHLAhcF8EEPevJm1pW0lCSdOi4SzwbsfOUThCxspQ0Lt9h/8CaLGybtjYys6LazcfqZEmK5QM6Yj0mhYHveZcZefcNAAbxK+IKbvgwdsMrVpUMHJYGh3FCgTBILg5AmrwP2M3a7QoEDbSsQi+iOywWoc/SnBDXJudxqKOcT4eNYtyPIXIG87PO65OQD/GxTUgHQ3yMKD6XYLNBHsWxykqhs6xXo6xux+jZ2AieQnj7vU1fhAy/eTebIkhZVUmEsZcF8PkRwJw+YpB596ul7eck3VuAYTy9/Ld6Ghod/Knd8h4Y9Lhe7jfkLzEMByqO9FBNQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ef044a-46cb-4937-3194-08db356edf6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 00:44:11.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4HNWr+VNOM36Ybrwt/qur+gAp2waoIl0J+SFryrUn89LAbdaNopPNdUypKSgYE94sUk7eggOB92ZhDMoasda8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_14,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050004
X-Proofpoint-GUID: _yPPgrZ7IDVkvaPUk4eoI1YD457yo6u_
X-Proofpoint-ORIG-GUID: _yPPgrZ7IDVkvaPUk4eoI1YD457yo6u_
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Apr 4, 2023, at 8:23 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Mon, 03 Apr 2023 14:46:02 -0400 Chuck Lever wrote:
>> +int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
>> +{
>> + struct net *net =3D sock_net(skb->sk);
>> + struct socket *sock =3D NULL;
>> + struct handshake_req *req;
>> + int fd, status, err;
>> +
>> + if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))
>> + return -EINVAL;
>> + fd =3D nla_get_u32(info->attrs[HANDSHAKE_A_DONE_SOCKFD]);
>> +
>> + err =3D 0;
>> + sock =3D sockfd_lookup(fd, &err);
>> + if (err) {
>> + err =3D -EBADF;
>> + goto out_status;
>> + }
>> +
>> + req =3D handshake_req_hash_lookup(sock->sk);
>> + if (!req) {
>=20
> fput() missing on this path?

fput of ... sock->file? DONE shouldn't do that if
it can't find the sock's matching handshake_req.


>> + err =3D -EBUSY;
>> + goto out_status;
>> + }
>> +
>> + trace_handshake_cmd_done(net, req, sock->sk, fd);
>> +
>> + status =3D -EIO;
>> + if (info->attrs[HANDSHAKE_A_DONE_STATUS])
>> + status =3D nla_get_u32(info->attrs[HANDSHAKE_A_DONE_STATUS]);
>> +
>> + handshake_complete(req, status, info);
>> + fput(sock->file);
>> + return 0;
>> +
>> +out_status:
>> + trace_handshake_cmd_done_err(net, req, sock->sk, err);
>> + return err;
>> +}
>=20
>> + /*
>> + * Arbitrary limit to prevent handshakes that do not make
>> + * progress from clogging up the system.
>> + */
>> + si_meminfo(&si);
>> + tmp =3D si.totalram / (25 * si.mem_unit);
>> + hn->hn_pending_max =3D clamp(tmp, 3UL, 25UL);
>=20
> No idea what this does (what's mem_unit?), we'll have to trust you :)

Paolo requested that we link the pending_max limit to
the memory size of the system. I thought folks would
be familiar with the si_meminfo() kernel API.

What does it need? A better comment? A different approach?


> And there are some kdoc issues here:
>=20
> include/trace/events/handshake.h:112: warning: This comment starts with '=
/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-=
doc.rst
> ** Request lifetime events
> include/trace/events/handshake.h:149: warning: This comment starts with '=
/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-=
doc.rst

Ah, that comment form was copied from
include/trace/events/rpcrdma.h. I didn't realize that would
be a source of noise. I'll replace it.

--
Chuck Lever


