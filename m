Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D319656C26B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiGHTpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 15:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiGHTpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 15:45:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA783F1B;
        Fri,  8 Jul 2022 12:45:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268JSqPU028263;
        Fri, 8 Jul 2022 19:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rTr+4kKstrGFk2OmVrEe+xZ2kfh1bXxxbsWygNgCuBY=;
 b=y9rq6xrim3xOmWOXG7bznqNzKIteQ5lyxKR1atW9vSrFXHVXKJgNa12PsO4xOu2mPwUA
 2Wr1T2Idr1jz3p5vKHUg65lnS5/+I3W1c6dxJrPu1JOBY1WzuZlpM36UDanmnPlLEp9S
 +MFjV8QNiAkRCbgObPCu2CS4bppaxCchBSIQrd7KyYZBlBw80YXhk3ltZulWW3IoVwuj
 77YzNiKBtLS6D9Qm+L4hgCP+kEofjnHaov/tlDlGKpv0CyguGifvmlkn5bfQziyuKktz
 VRXQqQKZw2+TYjFuVurcW7PD7sntGXOZE/1lkIBCkpUj/KVgNDb+apOEMbwvzduS2JhN iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubys1q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 19:45:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 268JjPFJ002598;
        Fri, 8 Jul 2022 19:45:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud8fk2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 19:45:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7XIehYH1+WidU53tP5z8WT8WDbwG/+7QgJ2cRRbFOLWIMs+koffHGOlZj0YnRfUoIK6vySDVxrPGnnkRFOc9t4fho55txVGQbvmeuRSL9+HSZ6J20nUrZKk9KyAhOYo4WSWXEqqeiqe/qQAMxBB3bjMXiGTxPBVprLMRKEvm4MzCNdjrIK9jYNB1cFKrUW4m3SNpNYzsIEB7Lv/PuVwnu9eTZZBYHzIUI7hE6WNMtFxpsgvbisaRoaRhmU7iakft09CGcU8RKfU8hFXrc/hEgkyvrYL6NqNacThsPnyP/2qKdW30QJRC9HZehC1RUCSTywwGgS0/4yFrwnJPl6X3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTr+4kKstrGFk2OmVrEe+xZ2kfh1bXxxbsWygNgCuBY=;
 b=If2dvwWnTebY6XLCClZy69OakH9yPXHrEC4iqJ1J2l+hw6KvPsDMs0a5AMZjsxyMfRkbk6x7WuPn1b10RTU6HjjFJLtV/1yNKfUDLhvi4dnJPdmO4vgE7aUPjGoKczmrOg/NckI6eKRuQGh/I0MW7KDHOO2oBcEe9QqBNTnBLTmuTy1phJW5t/u7IDB/fjWF3/XtOUMOtSXvl5T8FZtQ8bZZbUYocPl1PKeu4G/jmf+Jumut9bCsHKfjTPg04KBFik1Q29sk8zaFVdR0OHS9YlTdEZ8tnbUOZaYHYvALdDglGbir005h/KomNyeig2zNhoJsgNx7Xj7x9RPlHFG83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTr+4kKstrGFk2OmVrEe+xZ2kfh1bXxxbsWygNgCuBY=;
 b=MUF7BHAJUVmf2M6v1hD466J51O1MLWU8ZvFbVAretRGQB/PIYbGDIrJ3RP1GNPdtjvgV6cD74y0yRJwkoXvXL+2vojhA6OOVPOxnApCfuPilIC0pOSpq8E6jScLAGk7hLEhB2ni8c0ck6MyJIdOrkjk0lo9UERXil+pknh96b6Y=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 19:45:22 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%7]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 19:45:22 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jeff Layton <jlayton@redhat.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>
Subject: Re: [PATCH v3 17/32] NFSD: Never call nfsd_file_gc() in foreground
 paths
Thread-Topic: [PATCH v3 17/32] NFSD: Never call nfsd_file_gc() in foreground
 paths
Thread-Index: AQHYkvhIwRxSGdgHYEuAmw7lVweuc6104BsAgAAAeIA=
Date:   Fri, 8 Jul 2022 19:45:22 +0000
Message-ID: <13F5B78C-495C-4BAB-8809-5BE1D050FD2C@oracle.com>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
 <165730473096.28142.6742811495100296997.stgit@klimt.1015granger.net>
 <10963d58b011dbe42bf3b9ec69a010862f0d2638.camel@redhat.com>
In-Reply-To: <10963d58b011dbe42bf3b9ec69a010862f0d2638.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc417309-1e09-413c-44eb-08da611a658b
x-ms-traffictypediagnostic: BLAPR10MB5234:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emHxHU7wXDVfHg6xrjXylbBsGtddZf3sftyxQCCg5/9XptyJ6Lv1ltU+Howqzcd9b6qrOIRX4tNQCTZkf+GFPa2tp1yiyk8PtFdtEIRNEDBD/3lmErKcuglHrdK9yqnjj1s9M7u9TMULAWZcK5awo7Qy8tVgzAGCPAKka6hqiCtDtRFJ3rjm4A7PkkKo9oLa3wnmO+SIB5s7dCLg4dMYZ2fDOQvb8O7JHKuVArq8zN9WTuC9wxnWg8k0W6tpXoG1VT5MXA8zhKdEHy0tCA0f9Xi6AarRFV2aHnAP7UNrIQQogKT21L7NAxmDweRodNdr3ILehE+FK/UD4eRtnDwBri9B6StiRPZRIDM/biMlSMlVoLcE8fm5FrHwHNDdlyhTN1THnAQ5zjczxEbe7zRwRJQJzmrOxuotUVn9Di6fp4qZicvel9zm5aas7QDm1QEDW5TMDeqcvT6hx4BvimwxKQ3269MNwXqR5bfBSCjaNxmEte4u5z8Yo1oBz0uCm1VGGJ9zQHfiKywoPOFBiLEgjssicTKhiMmNBOBISG85PEDHyhwsrzXojfQpoo5th2fU59pR97tyD9ynlUv97hd21gvXJXR3RWYOgdH0PYcL+MBCwFlJcHjRJU/Fl0iNHvnxJXjwsblrVccCKTr8k+Hw5JwO1txYefouOnQEFTJlsNupG+S/BC8NKgNl4gjAPIg7yzG63FJGGO0N4hEiFOtmOJNToR/RvFkDOZl2vABWjC2YQkrkyJ877yAR4twLpPAXuxLvmqW3WBeL6o4ZCe0ORDLbxz+DM9UOjti6itH+tDa7LXrAQd4U0m1PFaf2kw2QHtoCut0i9dMvxQl6Z7dMsrqmawpIMsDPyIQewZWTYZ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(136003)(366004)(346002)(38100700002)(316002)(83380400001)(186003)(66446008)(66476007)(71200400001)(91956017)(8676002)(76116006)(4326008)(122000001)(6916009)(66946007)(66556008)(64756008)(36756003)(6486002)(54906003)(478600001)(2616005)(6506007)(6512007)(5660300002)(86362001)(53546011)(26005)(41300700001)(38070700005)(33656002)(8936002)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3UWSe6YCEPeo4lIJp5KhD67fEjElQtQvx5hkviaKigLIbvCIjz5i7wydtva8?=
 =?us-ascii?Q?8eNmFksgrVX7otZKCX5d7Rojn1pY3fJCe53wrmsQqlpHsP6Xm80FDbZc9GfL?=
 =?us-ascii?Q?OXPneq9c2RXXTCLTqsr4N1wNqB21vOXi9ZI9L9OPROP7W/vhgKuguHGsvzTe?=
 =?us-ascii?Q?7jRbN5gDT4z/xOKPD/2mw6e25sxdsYmU+QKUD7zXY56B6kcnyC4iFr43zQyk?=
 =?us-ascii?Q?LJCwdpcLQ6xz1qA3B74kXrQYZCBZoFCXqTPn1yqk5vob5a4eYnrbevdpltxV?=
 =?us-ascii?Q?qjTsJR6cF3cSF1AeZNbdKTBR/aMnnDYBU+488f/N5lyD0iIjklTP+FSeg6rh?=
 =?us-ascii?Q?Pe5zMloj08ioJrhIqz/r2jnpMx3Ar3VbhnmUeFAuGiJJSUbBPr+C6/W5K2MP?=
 =?us-ascii?Q?VqO6BIYJd2T5cYjL3HetKZBO/+vqIRs5J1AOzZSFj4rlTLrhiLqPLrlI8Br0?=
 =?us-ascii?Q?+wn1FhrlpZEipunb4XQfUJK67KrpHSBL6mC53V31FE3Btva/Mriv9vebv1A6?=
 =?us-ascii?Q?ubeSNhjxxRZYmnb/PLdddZndKIrUVZp+ualNm85EgRld4SW9sPkvXtR9VR1N?=
 =?us-ascii?Q?8Ld2x2TWeGTk7ndvbgNtEZ+e8DlQ9ioDVDzbXJABa2GVElGTugHsDttd/QKP?=
 =?us-ascii?Q?pciyWTO1OrOhL718TRgtog0t1Ize2OumXax8LugiiyPY5NvC5jD+BiuvL3jK?=
 =?us-ascii?Q?ftuDgKlZcMW9cNFONyxFs7MTQ2Cf5mYKpz4suGujFSSDH1cN5fd67iTr+8ev?=
 =?us-ascii?Q?7QwH+EsJrSoNErWm9ydWibDIwq1VY2bglWEJS8xtqOn0x8hfuMKLj2BQeAaL?=
 =?us-ascii?Q?FuxMuw7J8NBblUzRl5F8gZqXoVqyxJ/Zmv2KzXFapLFjRU1CzhQTw5H+yiF5?=
 =?us-ascii?Q?cV0E7buF1+Lj6IS36LSOitKtypQs/JRPvixChiA7qHlNGNo9qqHXKfWlRdPF?=
 =?us-ascii?Q?MXTBKR8l9CpwnakLn3DbnoD93JEAAwULvES5P8E9lZu37/P7NRA3fHBOK+Yt?=
 =?us-ascii?Q?I8UPtfPV7wAtrfcclt2R9VsCgZlxmOPe3cgPNoAlA/7ANK5MxDu+pJFviGgz?=
 =?us-ascii?Q?JobLi37MI6G9eHAzfUfB8gpJfIuZQhxEvUQVq/lIp8/4UmD+VCx9HmDg/hkp?=
 =?us-ascii?Q?RJYI0m9eGPbtLSK6508kbC/2az9SmegrytJAAT/1m6KpOB1Z3z0MI7/ImsWm?=
 =?us-ascii?Q?inzmFanIYvSjVJzO5719Ams88cratDW64pTXdqyyLwke4GCUMztqAWqbXE4K?=
 =?us-ascii?Q?7aWOcjYgLu9Ap+o43qKWU8U7LwXDVcqa6emfowZyDCH7YdLXAayGkfqtveHz?=
 =?us-ascii?Q?7wOOhiEfP3mdMc9PlZUbJwEcaTS3Y/B9LUqfn6TG8+d4Q4Tr/hYmcNVy/q0c?=
 =?us-ascii?Q?MsRv5Zlt0ndJFKw2FZk2uYav581FlFOWfXd4VoA3Th5jG9yXvX666ZqV3tLa?=
 =?us-ascii?Q?cYnlJxR0DZxGSzfWVSdcFbkinAnHbl7jFcF6U190Wv3LWz11xz0TZ9r+4GVd?=
 =?us-ascii?Q?VBzz8t9MSTWk9X9rW0WNNkDBDyxAHpwEmfIGqnKr6X3BXgSkGSanI2+zFdE2?=
 =?us-ascii?Q?WLDASOid5FWbla1pUXzfynKhEkvai45WRXMMZm3OVkPoL3/qXHtnyi2QsmpN?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56A1292E2F126C4D94A70AB6F2F1693F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc417309-1e09-413c-44eb-08da611a658b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 19:45:22.6547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IUDVMphEyDC5yre6IfQGQGmyH/CO9H+kgn6ckC2Yy34/6y2E0eRrINyGITp58vapR0zhTpGF/fcp/zReQn99g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-08_16:2022-07-08,2022-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080077
X-Proofpoint-GUID: SKLMQ_9B-ZIEvJp9pj6hSwppwgekhfXi
X-Proofpoint-ORIG-GUID: SKLMQ_9B-ZIEvJp9pj6hSwppwgekhfXi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 8, 2022, at 3:43 PM, Jeff Layton <jlayton@redhat.com> wrote:
>=20
> On Fri, 2022-07-08 at 14:25 -0400, Chuck Lever wrote:
>> The checks in nfsd_file_acquire() and nfsd_file_put() that directly
>> invoke filecache garbage collection are intended to keep cache
>> occupancy between a low- and high-watermark. The reason to limit the
>> capacity of the filecache is to keep filecache lookups reasonably
>> fast.
>>=20
>> However, invoking garbage collection at those points has some
>> undesirable negative impacts. Files that are held open by NFSv4
>> clients often push the occupancy of the filecache over these
>> watermarks. At that point:
>>=20
>> - Every call to nfsd_file_acquire() and nfsd_file_put() results in
>> an LRU walk. This has the same effect on lookup latency as long
>> chains in the hash table.
>> - Garbage collection will then run on every nfsd thread, causing a
>> lot of unnecessary lock contention.
>> - Limiting cache capacity pushes out files used only by NFSv3
>> clients, which are the type of files the filecache is supposed to
>> help.
>>=20
>> To address those negative impacts, remove the direct calls to the
>> garbage collector. Subsequent patches will address maintaining
>> lookup efficiency as cache capacity increases.
>>=20
>> Suggested-by: Wang Yugui <wangyugui@e16-tech.com>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> fs/nfsd/filecache.c | 10 +---------
>> 1 file changed, 1 insertion(+), 9 deletions(-)
>>=20
>> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
>> index bd6ba63f69ae..faa8588663d6 100644
>> --- a/fs/nfsd/filecache.c
>> +++ b/fs/nfsd/filecache.c
>> @@ -29,8 +29,6 @@
>> #define NFSD_LAUNDRETTE_DELAY		 (2 * HZ)
>>=20
>> #define NFSD_FILE_SHUTDOWN		 (1)
>> -#define NFSD_FILE_LRU_THRESHOLD		 (4096UL)
>> -#define NFSD_FILE_LRU_LIMIT		 (NFSD_FILE_LRU_THRESHOLD << 2)
>>=20
>> /* We only care about NFSD_MAY_READ/WRITE for this cache */
>> #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
>> @@ -66,8 +64,6 @@ static struct fsnotify_group		*nfsd_file_fsnotify_grou=
p;
>> static atomic_long_t			nfsd_filecache_count;
>> static struct delayed_work		nfsd_filecache_laundrette;
>>=20
>> -static void nfsd_file_gc(void);
>> -
>> static void
>> nfsd_file_schedule_laundrette(void)
>> {
>> @@ -350,9 +346,6 @@ nfsd_file_put(struct nfsd_file *nf)
>> 		nfsd_file_schedule_laundrette();
>> 	} else
>> 		nfsd_file_put_noref(nf);
>> -
>> -	if (atomic_long_read(&nfsd_filecache_count) >=3D NFSD_FILE_LRU_LIMIT)
>> -		nfsd_file_gc();
>=20
> This may be addressed in later patches, but instead of just removing
> these, would it be better to instead call
> nfsd_file_schedule_laundrette() ?

nfsd_file_put() already kicks the laundrette.

I can't see a reason to call the laundrette again; once there are items
on the LRU it seems to run every 2 seconds anyway.


>> }
>>=20
>> struct nfsd_file *
>> @@ -1075,8 +1068,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struc=
t svc_fh *fhp,
>> 	nfsd_file_hashtbl[hashval].nfb_maxcount =3D max(nfsd_file_hashtbl[hashv=
al].nfb_maxcount,
>> 			nfsd_file_hashtbl[hashval].nfb_count);
>> 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
>> -	if (atomic_long_inc_return(&nfsd_filecache_count) >=3D NFSD_FILE_LRU_T=
HRESHOLD)
>> -		nfsd_file_gc();
>> +	atomic_long_inc(&nfsd_filecache_count);
>>=20
>> 	nf->nf_mark =3D nfsd_file_mark_find_or_create(nf);
>> 	if (nf->nf_mark) {
>>=20
>>=20
>=20
> --=20
> Jeff Layton <jlayton@redhat.com>

--
Chuck Lever



