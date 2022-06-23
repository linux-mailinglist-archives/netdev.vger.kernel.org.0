Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A43E558BF0
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiFWXvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiFWXvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:51:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E1C609E6;
        Thu, 23 Jun 2022 16:51:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NKEUPt003476;
        Thu, 23 Jun 2022 23:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KNCtjPGvfjaedM9wvjst11eNKElO+kq8+Oj3HnVUR0Y=;
 b=oCu5XwOQuaQ/afV2dEtZdET7KF2cGjVv4hHbo1bLTAQipuZgb5cUMVuZNnT0HCZRN1Ml
 gN69MUrkjz3SDYhmWSucJrhr8wwNRRuQsBnRoyGBzrGyFvaNBT99wIEpuKm5qBkxQjhm
 TeuXT8NI2JKEW8rlrcVNNe6NeGbZh7qNZE9SBX3xeYgh+6MwLlNm71joIGqQ/W7ZmrwZ
 Fj50EngWrggCinq8dekIKbhJeIFc9TY3r9GO6rVjEY5naveqd82Ut9Z9QLQP34INPQGl
 Lkjkgv+rP4tGKszoh7y4jkQkHYuvdbR1vgU2VJLfoVJ+eyoUzZICWoq5jFJMrqdl4tk+ Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs78u4gbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 23:51:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NNonfY018640;
        Thu, 23 Jun 2022 23:51:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtg5wydy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 23:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/HiJD3y7WUfO0PfSNhItOa/9gDNil7D+/krCb7j/FcU8zJhkLq+PzW0E+aVRXKZ5d5GbknU2QL3Yb/5kKeXTbT/s9whTIQQqGldUvw6F24vga8Dj4PvanCG7W1ul/56ko2hdWnGO7ma3MsWf3bCYjZqrIhvRwbxIAt9ZzVSwgM5I2F2BuBf3GyXXb77MED8dPB+AgslhWfvK0fw4f97nOX+0rjjtgs95Ij9gIqerSGz0tMrzK5jOx8X5jjXmTZDL80X6V5nUiPgyCTEbMsEZsWzviXA+ryNToE3mS/Vi9i4NruEY+DIQSqR32mlM6Hhyh7X6aJ7rmd4/gqIXj/BaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNCtjPGvfjaedM9wvjst11eNKElO+kq8+Oj3HnVUR0Y=;
 b=giC88iwgCI33ZG6u44RmxaO8tCwllw30ZBAqWjUnFGtuM8wcqzJunI/CS/oGwSWDTzi/GIJEEFJv93ODgrTF6KoYAb0thop698AeLTyJOCbBx/zFENKsdM07hK2bJY4KZsM0mzpqLGY1LioazkHy+Q5LflJyjya8/Ei8Ikmqis+yulAvbehQCbN+rSI80A61IkSRybFZr42sBC7C7QwzpA3c7MvvjWhD8O+54dh9WDWmBy9BAmmBe3vwHfRT+CXpYBa81BcPPQYFiVFRGKpn2jrhlhDqfoVAupNgg/j/0Csz4C3ioRXE63XvXm5pHkzndEqbWugGKquvV7phB5WG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNCtjPGvfjaedM9wvjst11eNKElO+kq8+Oj3HnVUR0Y=;
 b=tPHRayfzWs0OPCDo9UEH1dyEqdq8JRvLEATgQipWzySo4odjn6MG3u7WS0yH1mQdKGd9g0kk+gnzWX+FJeGGBnXNwDwaBJFL2Xpa5/U+SGdbHgJO01xCqiEYr9+Lrfoq6lJLJSQGoqp3TmOUfRMf10mUyrWJU9B4yHxs76LmHOk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BYAPR10MB3319.namprd10.prod.outlook.com (2603:10b6:a03:150::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 23 Jun
 2022 23:51:29 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%5]) with mapi id 15.20.5373.017; Thu, 23 Jun 2022
 23:51:29 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Thread-Topic: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Thread-Index: AQHYhkLIv6uRbtoPJEu5Zs/9WvV7ta1dnH2AgAAPTAA=
Date:   Thu, 23 Jun 2022 23:51:29 +0000
Message-ID: <1E65ABAA-C9D9-41F3-A93C-086381A78F10@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
 <YrTvq2ED+Xugqpyi@ZenIV>
In-Reply-To: <YrTvq2ED+Xugqpyi@ZenIV>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c784f036-45d9-45e1-6a07-08da55734acf
x-ms-traffictypediagnostic: BYAPR10MB3319:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VGDuOFWzduqXO+ZkJ83bxKAS2g3Dy+P7aSuvWdNFwgCtFNBbIj5nzGEWDFZjMBroCsu6eV5p951dNgEwpQTaHBTsCFmOr2+HGBLTeJtwkvJ/woQXg/yVC1+kv71WMxNUXFys8O9M2JMDVmgGsLij8tqmTxvfhG/BP1/tbRfVyM3T8a+geU/IGL1DZ/rwBamyIAe8/30rKIDj3OpYvGCzSDmtxZc1kPBpxxjaA40CBQzL41MAGAfANTNpsqrFsNmCOt1qFeDuqGWWSY9uM0xviOXIpKyNUtDHklVhrAZp3TaQYeBA3p9K20EDFjDOCGXgdwAcr23X4l2wnPofHW/bYYbhFO4G2ilXs/ol90HL+s56e44FKUAzciryL/zCRvCLa7bjy+yWSoYJEHYf7YjY/cPEUpNT9UENyK2ozjBvu169wt0adtWDs6xM8fonj8cJ+0wTL0nKNkQFaUGvIP7oNDyjfavHvYMRzjWMEZPjHY87kFWmOII2Vcwo+PB8if3ZUUTQgdNQJnKoPtj6sgs422fZslCYWFhHc8rRbhVoWoax3LrZ8jlkLhHm35eY7m9BcU4I6skqSrar3tW0q8CRuKFufQCFRS94Hav7+mVxrOcbbkNG97o0nIQhZcmGfA1CWMgp9E/ImxevL4vUtTnoYBzx09YtLiJ21AVeOFYxBLjCLoj1RFy/NdA+w/RfDA8QwyPKbJUijAnmAlALsKv5KJgcJbQNGFD6u7XNr3A5VDfs27wIWcs59o3dVEd/pvfIvjdQ0UgLbXPiXwrtxGds4GZkQgHmBBRalem7saaCfj8OJw13AP9B2Wsivr852MVxZNrSJ1C+FrjutL+RUvkTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(39860400002)(366004)(396003)(4326008)(122000001)(76116006)(66946007)(66446008)(8676002)(2616005)(36756003)(71200400001)(8936002)(6486002)(316002)(5660300002)(53546011)(478600001)(86362001)(91956017)(66556008)(66476007)(41300700001)(54906003)(4744005)(26005)(38070700005)(33656002)(6512007)(6506007)(38100700002)(2906002)(6916009)(186003)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OUIT5ek7/QZ5an6HGqRvragQYzFTA/mBdwx2a9B457/zHXFl6kqUxVKtO6Va?=
 =?us-ascii?Q?toEe9XAUYPC5O/BoQdP7kDu1yyufZKH2k/An+iMTHjwr+EQCarjpbb6dhfYK?=
 =?us-ascii?Q?vGB7Pjeih9mqZn0NH+6x29CToh6WqtS6UluFmLQI9LSQe3wg60WVlXUIwkjS?=
 =?us-ascii?Q?wxVDp0Uy4ZwIioLzWPYP3eQWdWADs+T/V9PrRvHUfBIUOpi4nsOLE9Jc47Vv?=
 =?us-ascii?Q?mCvZ/p+x+KBWND4aNNXz+reKLNPzvVXo4POqbOG7ZmC0i3WywCNMHZnJtZIR?=
 =?us-ascii?Q?4bpwQil2n4OPT7oWXlyI7Ngx9M0ydv0vmAaIiadsIKwCM/EiaXz6TOeroW//?=
 =?us-ascii?Q?c3sLInUtUNnSLl3FMVV3MV8u8FCcz14V/YsHGUmhJFfnMVBlePwMA0rzlN11?=
 =?us-ascii?Q?MvJaHom5n/BelqRXNmrU4ckO3T4SJfsw0VX2kd5H0DN6pZ0vrw26n9NNvOno?=
 =?us-ascii?Q?inXiBkX7ix7NTEbnv26Wvq5PKQKix8xaGMaKU0/qalXVCSHQLFGh7tZCezN5?=
 =?us-ascii?Q?mE0SPS/PUfbFiplMfkDXEOveOw/qYdYEln1RkkAztBu8X+Vns851DxsniPEB?=
 =?us-ascii?Q?b6P4iInAv45vA8N8ZvTlOr4mXDV9MIDs8t3CArCHY3IUbQxtJ0+YwwLJvi/X?=
 =?us-ascii?Q?EO4wIR8OCZsFjF6MCFAPxWIAOfpR9FAy65NrTR7bao18lDnrN0FA+gK298le?=
 =?us-ascii?Q?uSBDXFoj1a3yUARLNYS8/JiAhSN70En4vrvpV+ryQvu71A2ZwVhXTGLd5sTt?=
 =?us-ascii?Q?K39qK0LGL6pN/GPpf5gP9mtyGEtsmPycbcJWkOYJI3ZyWQU28pr3JZ5VvtvI?=
 =?us-ascii?Q?O3svD5fcg1Gy/dWtaSEJcNmapvdyCT6MzwCHuzPp4cem5X8idopyNCo902fQ?=
 =?us-ascii?Q?RQzwC54ncuJl+jpHwX/29Ir9PuzIAT41lrtnZLbPwr9VuXkonLLPVRNm+MhE?=
 =?us-ascii?Q?TwYXt+E/KQRrgdOtjd5di37Uj38ieeKTyge1mlHkvhPEYeoR+VIOrB02HD1f?=
 =?us-ascii?Q?WhYGeeYMYIt4+d3FQhaEpoPb5ul4Fi6BvHPkM+aBMATCDOzOLwqrAbnZJqlo?=
 =?us-ascii?Q?tLHPoOOf9jlqeCh8iFk9+Vlg8t354GMhtgfpa/d2fTLOW2fBwU5EFxWXnXBx?=
 =?us-ascii?Q?MsD6YP7aNkV452P72KmtihPJkdin6Z23dGGlDg94UzBQwS6ZithAV18eznGo?=
 =?us-ascii?Q?QECseHN5qG/H7tNQthU4PCR/Fiaku95kEMgP2deVH9TLJCxRHrVnwI5kwdL8?=
 =?us-ascii?Q?CIDwVvq9tgtdd/57edcYDsgOdZfX1Yksy8YNBjeWGNUzCCOUOb2iPbXuf8QW?=
 =?us-ascii?Q?WJpN05xdNJPx1ef9O31Lfsp7HOx2J6DocSYEsHF8PBZ5Ef73NPSi3tBmlvQm?=
 =?us-ascii?Q?KTlKiE66mzokjfIZqUhOr57/3Ot+cpoLs7ze30VFzGPAH9NihoGrz+m6CXDS?=
 =?us-ascii?Q?CeYGTTUqZfkcLqAC41wfEHSfPvj9zbQAQKRLVgD5FnBom2sj9YzqGHXM8L7e?=
 =?us-ascii?Q?uO1x1XI9vMiioWiyyuLWeWsyDZRwF+6+NywIl7k5Db2wh+LDxfCCWHVQdz9B?=
 =?us-ascii?Q?xe2nEym/c3fYpi+XrvEO0dgxh7NAiTb91a6RNI8nWy5xK3FqsB4zCAmqee6I?=
 =?us-ascii?Q?IA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2B432EB83F433348ABC815B17EBC446F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c784f036-45d9-45e1-6a07-08da55734acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 23:51:29.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfUDkBAEOaHqb1oh9SK9BSJnlpB1jXdZdLEjC41i5U/NdXhetW48ETLMV1xm/4hAe+70qo/uy+i7YJfyE8Z4Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3319
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_11:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=859 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230092
X-Proofpoint-GUID: q8BsgKKOXhYdcWRqirrQwwT3jiJZRqqo
X-Proofpoint-ORIG-GUID: q8BsgKKOXhYdcWRqirrQwwT3jiJZRqqo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2022, at 6:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>=20
> On Wed, Jun 22, 2022 at 10:15:50AM -0400, Chuck Lever wrote:
>=20
>> +static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
>> +{
>> +	const struct nfsd_file *nf =3D data;
>> +
>> +	return jhash2((const u32 *)&nf->nf_inode,
>> +		      sizeof_field(struct nfsd_file, nf_inode) / sizeof(u32),
>> +		      seed);
>=20
> Out of curiosity - what are you using to allocate those?  Because if
> it's a slab, then middle bits of address (i.e. lower bits of
> (unsigned long)data / L1_CACHE_BYTES) would better be random enough...

 261 static struct nfsd_file *
 262 nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 263 {
 264         static atomic_t nfsd_file_id;
 265         struct nfsd_file *nf;
 266=20
 267         nf =3D kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);

Was wondering about that. pahole says struct nfsd_file is 112
bytes on my system.


--
Chuck Lever



