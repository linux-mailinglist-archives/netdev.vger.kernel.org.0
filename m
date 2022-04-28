Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFEF513E37
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347598AbiD1V5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiD1V5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:57:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B813940A1E;
        Thu, 28 Apr 2022 14:54:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJhY65011324;
        Thu, 28 Apr 2022 21:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Swl12vKkfAjZbYWqlfIpCfMtImqN14SRK9b72n1CGi8=;
 b=mPD00lg2mumO02MLwxJyBaO+xH4DrIwxqy1wvi4DRLfxsTfBWmEDF9+cb1B+d+EmsjX3
 hWPhjmmzd13MBzRdz9/mMKHYU3yACVtRskFOsFAR7HoYjmWBUVOgpagD0tBTFXz5O32U
 V/r3O8F8QPD+zCl5tdtFHzuVPL4nJPYFp9bgnxXoUv+kshu6K1bfnvP93ubjBrvxu8RI
 pQgLfGxYhv3UPoTCuNf0Fz72j7LH8Hehhz3rqhJ5HeXUm8bCxH4xSoHmuWkPa8wKq/7m
 O/fSBAJlri7oDzjkMs+amvltrxPP5awLIuuf8wcyAhkg1qSA2r3pP3D/nEGPg97IYDz6 Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4ndh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:54:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SLkBwl003664;
        Thu, 28 Apr 2022 21:54:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7996h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkJHGJ9bJEQ0uEatBT/gBqcgmkPohUNQzyTE0KIDGW2wzTe0cWlKmOL2NgdePi7QipoXXITGp8Ub1idKNOBsFXhleMoyT0NHdlPi2AC0mKnIDLH615YWnHcmZsklCxgee4BBVpmtv1Bqi21impjdFtLtWOdBF7rTuqGfluZTztZkwrvM2XBB+hgboPwiV5PbQ+sf02Gp5w2zEMa8bRB2y8oz72G2FsspEU5JShTLlfWBuur3qf4ZnkVtTxmXWLF5ubrTYUzZ82UvUUmMLL72btl88V4dCCjWG9wrBfJB9L+FHnWJZO4srBDCRXS79dtRIHMxbdC3hyHmWR/OICjm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Swl12vKkfAjZbYWqlfIpCfMtImqN14SRK9b72n1CGi8=;
 b=hhQ/LFI8kgHTvrivZ/pZmKuMylkrDmHrp/1R3lhKZfwZs+RURjimAZEnPH6tG/T1D8ydPzRcG0xUCEaesw/Rby3UH9wfazEVFUzlEXbv8HDe1nCqi+52bJRC9GPLOwPvQvQZzqfOm5OQn9+DPhfsV7Lv/l9xRcIggHDE9+7XRbQQ4H7sM8TO68hjX3pLgqb4I5XvQWPO+rrtInv15YszXX27hfvoCI4BjRrozoVcIlvxbrzahR7HyIZpZoYZhh8cBTdbeyYF95orMwJxFLndhtwszKtYLrJ7/chnvhU+7kmNtT+ksPMY65dly1P/wgQwvK1LsVMJAKz2wZtIB02L0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Swl12vKkfAjZbYWqlfIpCfMtImqN14SRK9b72n1CGi8=;
 b=E0+JErWcrtxruKCoZAueCxnocfkDyTaPIcXaq65tG/D0VvIBDXjw31/BVE4rqRCeXb0g5umt02FgqpXLVZ2K4ST58w+DL+3TB7R/Ez0wxye5utJc9ZxtkLjcrxkdqz5D/qBCnYSjRug128W6n0gBhtOIbbjRuvFqbCgeK4YObT8=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5223.namprd10.prod.outlook.com (2603:10b6:408:12a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 21:54:02 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:54:02 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAFYlQCAABKoAIAAEbcAgACC9gCAAPo/AIAAmfUAgAAanYCAAUmbgIAADJ6A
Date:   Thu, 28 Apr 2022 21:54:01 +0000
Message-ID: <661A8F3F-A95E-412E-B9A7-F35A95610729@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
 <20220426075504.18be4ee2@kernel.org>
 <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
 <20220426164712.068e365c@kernel.org>
 <7B871201-AC3C-46E2-98B0-52B44530E7BD@oracle.com>
 <20220427165354.2eed6c5b@kernel.org>
 <F64C2771-663D-4BE7-9EB9-A8859818C7F8@oracle.com>
 <20220428140851.6e9eebd5@kernel.org>
In-Reply-To: <20220428140851.6e9eebd5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee074f59-bc5c-439c-ebf7-08da29619b50
x-ms-traffictypediagnostic: BN0PR10MB5223:EE_
x-microsoft-antispam-prvs: <BN0PR10MB522322D5BFB0519DE8BDCC1F93FD9@BN0PR10MB5223.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TCemrJw+UHKPD9ke+PLKL5K24+tDLaT7cq3qYwsz3R3uquoat/OHMkYhpwKgQ3gDtHDdJAi5MH5LYwTdVD5USECzhHUuNHEcxX8XcRtBbLQHNdxk7n+qfGX+tu5zT6oRb7T3tnnyGy8HsofOH5ya/670ePV+LNNB7ornr4IH7uNU0VnSIsPOnYwxfTrMGjOIIZH0iswl7G53fDQL4DIPrWemEZmxLLcLmoyRXnYzzDl4g3cIzIPo040o/eEpvYwZMni+AexVLy0zP2M71gJmNK95yci3nW5FRXDnjMFQUQ+e4NsabtzhGRrhbUPmS434sGI4KomSompn9kMiGZvXkjiTGtVOEXz+fOG+gLcVDtLo3xE+8O+dl6s7gAbRJqmnevKKwKa9DmGGNPTsWuW+Y/z0lg1zwmeOOI/9KaFD+5bl8GLtHoCV0CRQ88QkL53loOQ0Z/DfrXvnNd/VcGrCuF6uuSXHlpRVgnUDdVUoY6QaLAJ2mPkyAXYbOrrMakaCrwcyMfqhEhIvOnJAjE7TxsWofEp9fRu0OYuKcw3/PWGcRjQVJOMVTj6un32rNv9ktSrJPpr0IxOHNkkJxz9echUB8T8SUtjwjo/e51lOPyZq8BrpXAdFhyzWQRKiqmaN4Yfr8y+D5PNtLG9zdXI4ytpq4S4D5YS5HrKI4amRDJM2XfaWGczlA91IYVz5HPzC98sAzedlO6yCbTZOVvm/vxkKp+s0feB596CZLDRnfZwEZw3XghKycwTr/uGlYGuK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(71200400001)(33656002)(86362001)(2616005)(186003)(64756008)(8676002)(91956017)(36756003)(66446008)(4326008)(66556008)(66946007)(66476007)(76116006)(53546011)(508600001)(316002)(2906002)(5660300002)(38070700005)(38100700002)(6486002)(8936002)(6506007)(6916009)(54906003)(6512007)(26005)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ziwax6lgDB9+Maf/ZJaZVhBMCn+z759Ox0I4kRna5RkD5LQTFrdjlJmnA8nT?=
 =?us-ascii?Q?4CMunYDYyTG11fgH7mUBHK6uqxJYwbJmDpW/pvjUriqS1rzq2xlGb1urqu5O?=
 =?us-ascii?Q?g+p4NejY2Mn07iECtD5bwv1WHRsr1yKvhP16XxZUMkCiQTwQK34qQ26FGKUX?=
 =?us-ascii?Q?IFX2TmGY8qYI7zltBpKZMaDhpK9OEixfZMt7KVbIzgspwdAVh6rbHu3L47/7?=
 =?us-ascii?Q?CHr99Gwb+OCIihDAwpLebpNcM0in1QScCuGDHevcJ2tnhWtxbmUil17osylC?=
 =?us-ascii?Q?DZTaHtxIZEGQZCAWCMgEWtax/gUkJ9PEAj1P+we1lGnt0KWIQlumx5Hj1MQE?=
 =?us-ascii?Q?1OlqpRj1l1LZGZ2zLZyrlvmcdxjsQwYXQhesAmvUNmFzb1FTh6+iyszWura/?=
 =?us-ascii?Q?clg9NOLINjgX/htrdmQh6o97pGqfnw7wjxPgswMC9QbeZd2JRJ3cB3P4gmjc?=
 =?us-ascii?Q?MsxGpuieDSWBa7M1/ZzlRenbKrphGNOUoX+ploVxutpFV0L6se2v8XUEAHMT?=
 =?us-ascii?Q?WN786R9oA4mgvASsku+XEmAQWxHGyU5bP8KOXAM8rua1xn9jPBZoRvPb33GS?=
 =?us-ascii?Q?eaNWAkmFVRsdq0HcZN3968l01O98iRwAX4Ax4UoXHylSz727DPKHoyWJEui3?=
 =?us-ascii?Q?xTHEABc1YVHtP6WxxzRsgC+/+cupTQbQ+J5Jv5ZDRmk4nfi8xQp56IkRHBr5?=
 =?us-ascii?Q?1YVPHes9lRQ7Ssul7T1UOl59+mh/D5xODE64RIqMkoZ/Kd7mNzBp8yiYOAro?=
 =?us-ascii?Q?sbM5Jym6MIKUKmqXxKtxG4xZa02YtM8REb1ndp+3490l3eLRLQnticEDD9AY?=
 =?us-ascii?Q?qGQ9FoOqixXzkaEJDcwTWL+1LvbS6vP9YlXdoHdgLau84sq38siy1GVFCF4o?=
 =?us-ascii?Q?fZxhcOqPONEhw9bWKGg1Tm22popL5GPdq+E7SoiPeMnxF1O99zyt8ix6DYog?=
 =?us-ascii?Q?CM4uVbO1f4DnyJknNnTUZCtytMITXjGqobXGiUltv2+YBLdyTe68QdOdtxgr?=
 =?us-ascii?Q?sqbY8/FOdaLYLwU06z690I82kZRU07g1ZpqUsLwjqjbdi4kjgNEtHJSO6hM4?=
 =?us-ascii?Q?vh0VI7vvOfuW2cwOTYWQW+hZ2iMXl0rcHIaKuk56X48h/eC5fWdrCXROYY1C?=
 =?us-ascii?Q?bklIdJMJlTbu3eLCL2noGPkReDg54uVr4KCqSelOhkhdjlq1XXwf/XV5UcHx?=
 =?us-ascii?Q?Nlz8oe8tuS8LGQLZrHUHMYuQI7WbtTqpbfnXfyihWKHp0kk8F/XHiwx5Fg5v?=
 =?us-ascii?Q?c0ZqLUgADQ+g4TqWdSK5jjVMfXmNDDmyeYyhhlC39H+Ndywuw9JfbYS7i9jZ?=
 =?us-ascii?Q?BaFprRvI2P7tOY10j+5IWEo8Jr8xq0fsxsB5Go5UcyiKhgZ86t8XvCEnFJd+?=
 =?us-ascii?Q?sg//ckSvHoDAPLU3yHSUkYpIB8wNyc0x22tCbJPJgKgY+ce8/GJZjIduI4Ab?=
 =?us-ascii?Q?iiZ5X/VXDQM931mmmc0N98vTxlBAoHUS5HhV8uydzIFiKDemW6DDZ9hBqtLg?=
 =?us-ascii?Q?SnyRSiMtqPQ/cN2MIK/9Qrm36uT2SQbLzG70aR1tQV0KKpGkIKsCV50gj6qO?=
 =?us-ascii?Q?AIpIuhMBFmWmx1LJcOhlzMFZTJesf+npyfy9wSgTC6YpkqeEBmYYMoSC++QJ?=
 =?us-ascii?Q?I5z306d1nBau6Y5hNmeehcdBUrw4PiYmyo5iilw9Bie4jrhoj3l7qqRKdbvz?=
 =?us-ascii?Q?755hHvvC8dnqG21vFrP2YZ4OwzqrD+c3q6h8bUMAhh0L7Ghn2j4O6WuIppqc?=
 =?us-ascii?Q?ZXATwPvDsRemDpqJe9jUyPdOsh594TA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2A152BA4975DC4DB507253F325B75EE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee074f59-bc5c-439c-ebf7-08da29619b50
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 21:54:02.0215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UZOPBo09vvCQiUNwCasaZHSXxOlWpiHiXu2y8akNNuo8QIYousK/rfaT77dISE6QeRPe/BGumn3cKd+zsYEYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5223
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
X-Proofpoint-GUID: DjJJRuAKuPmDYt1m9nAfKMYzgC7Pz_IV
X-Proofpoint-ORIG-GUID: DjJJRuAKuPmDYt1m9nAfKMYzgC7Pz_IV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2022, at 5:08 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 28 Apr 2022 01:29:10 +0000 Chuck Lever III wrote:
>>> Is it possible to instead create a fd-passing-like structured message
>>> which could carry the fd and all the relevant context (what goes=20
>>> via the getsockopt() now)?
>>>=20
>>> The user space agent can open such upcall socket, then bind to
>>> whatever entity it wants to talk to on the kernel side and read
>>> the notifications via recv()? =20
>>=20
>> We considered this kind of design. A reasonable place to start there
>> would be to fabricate new NETLINK messages to do this. I don't see
>> much benefit over what is done now, it's just a different isomer of
>> syntactic sugar, but it could be considered.
>>=20
>> The issue is how the connected socket is materialized in user space.
>> accept(2) is the historical way to instantiate an already connected
>> socket in a process's file table, and seems like a natural fit. When
>> the handshake agent is done with the handshake, it closes the socket.
>> This invokes the tlsh_release() function which can check=20
>=20
> Actually - is that strictly necessary? It seems reasonable for NFS to
> check that it got TLS, since that's what it explicitly asks for per
> standard. But it may not always be the goal. In large data center
> networks there can be a policy the user space agent consults to choose
> what security to install. It may end up doing the auth but not enable
> crypto if confidentiality is deemed unnecessary.

> Obviously you may not have those requirements but if we can cover them
> without extra complexity it'd be great.

We can be flexible about how/where handshake success is checked.

However, using a simple close(2) to signal that the handshake
has completed does not communicate whether the handshake was
indeed successful. We will need a (richer) return/error code
from the handshake agent for that use case.


>> whether the IV implantation was successful.
>=20
> I'm used to IV meaning Initialization Vector in context of crypto,
> what does "IV implementation" stand for?

Implantation, not implementation. The handshake agent implants
the initialization vector in the socket before it closes it.


--
Chuck Lever



