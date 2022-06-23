Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D05558026
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiFWQo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiFWQoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:44:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D8A40E45;
        Thu, 23 Jun 2022 09:44:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NEmjAo027225;
        Thu, 23 Jun 2022 16:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8gLur/O4Nvsk6/DudM78Onm+RtiPhV3FOA/cOWNvMno=;
 b=VGRNrfsLfdjLnTsvBzT2C/9uhk2r+jtiAreI/zVDsx1ixSgM+n+UAbV43yoTwgT2hewB
 WDgvSnBsaYlMhQMKGAUqaflatqhjWsdLkFIBQKGhQtwfoowDtTQoqsOTi/Q5pRxrWObM
 C4dEhlo39vzrJ8gyXWwZboYiunN6HjRUfUvSedLXv0ffWzRcwF5LU8sApJFFQ4OO9DYZ
 f3F1wi1DDGYhX57EWhmPVoAHAPJbzwyIyis6I6Maxf2kW9lTO6JMgJuWfVXn2Uk28D71
 BXWMMVphI+DNnMRCBNAbXoqpty0/qcfim5dShMJXpoiC70KDIy+4UV+Vby7Lx0nQPqU5 3Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kfberf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 16:44:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NGahCT005623;
        Thu, 23 Jun 2022 16:44:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9wffkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 16:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDt88qZuKrVVlluM0oXHsVuzW90bvsqNC0bIKGmAGVL7UtuaaGTcIPyvmqxU+E/krJPHHjEvSQMZ3jYD0VcAAuZoLH9kxlowhvSi8As20qlEST3pFYRNw1OYgEjcYXUH4SuYgRWtOwQ62PhHZvtGF3/RJVf4jNv3eQOL51dBcpqk9A4X3+GliiFuS1iKe4n0Pedfrquf7FmNpKXFJCoAOd6Om/6gckyU3EKXFhG/t6lzVmWqqXwW6wAJfRG7ELig423dEujUL/r++AxwlCyduhru1/Nvf+dB6pjAaUq4WAQ96MPFK6PFrPnaWdqmQq0mglDzbfq7M112CiV2I9dDmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gLur/O4Nvsk6/DudM78Onm+RtiPhV3FOA/cOWNvMno=;
 b=D6I01EPt1sBka5UT7NlXH9pZBSFu90bRV6e/I6Mo0PGxnROPQcX/49ap1AI63nnYpHy4TIJNERIIhgmehkMr512CavA3GbyAk2MTnmtKy/lpX0T1XlxDIPtx/Wurnw2rmkfYW5uq1enDMb+nT55B+4w6U1uwp8NR2RV7oAYJvLZFOu0FkFD/EhHt3f+nYHHYI1vQxds20jFhqnENkJ8g/rfXdtS71jFLqxcEb/9T0usRn8keDUwDAaSS5HaX3wBzCz3h5hAFHp76ghHQxIyut0iyl7a+9ZGMmzYBuNVbJJ9p873on8v6SiaZhrvYcKBHlS7SsHmvunwTX6Fc4qc/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gLur/O4Nvsk6/DudM78Onm+RtiPhV3FOA/cOWNvMno=;
 b=jb3y5Fng4gw6+0Ofkh4AV15oEIkBJRqJynsdhdtpHSxSUH2KoWCARcmIvYkiURMbe94SE40gLuxG/NWlCnvjjwNVo4OFJMo4WdbF4U7G6SkwpskG7EZTImygDwYOpzq3R9ey6xX79OUR9CjwgftuivoCRwjLP6SNxmvZ++KE7f4=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by SA1PR10MB5782.namprd10.prod.outlook.com (2603:10b6:806:23f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Thu, 23 Jun
 2022 16:44:43 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::c952:6550:162d:4aa]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::c952:6550:162d:4aa%5]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 16:44:43 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1bwYeAgAAHywCAAA9RgIAA2ruAgACBMAA=
Date:   Thu, 23 Jun 2022 16:44:42 +0000
Message-ID: <0292A2FC-7725-47FC-8F08-CCB8500D8E1D@oracle.com>
References: <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
 <F57A580E-07D0-499A-9693-18D82D73ED3A@oracle.com>
 <20220623170218.7874.409509F4@e16-tech.com>
In-Reply-To: <20220623170218.7874.409509F4@e16-tech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79e06d2d-98e7-4949-6845-08da5537ac62
x-ms-traffictypediagnostic: SA1PR10MB5782:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UiH4ey0NLTTjKc6fRIojmZF/FjSDgO2KhOn7SVRAYBBrMbYGe4UE97fPNYHRqvjPPIr4Ze6GqEfEBpP0P9i/pD5i85fokzvl+UtDheNqKzn+JDkEK2pvGuvp9354NByBn3JrrB63jWhwStirjBDxmJsTq6ePvMGVLvCdfvqlg4djnN5OmpX3v8QJII97GqTo28V9GR9fWNPKIGbhwwmgJ0Ni3H+lvqP1tWgaSMMd8JgFX669c711hoB8NOV20nTWSgkMCyAV/ZzEvCfw9ZJk/trz1op9tPeZQ2LVPrclrQrmDsrebtGMZtsz8zR9DMcxXKwmkwoSLzVTnNl5ti3nTQsNS5ZAIW8DiqBCqSDs7OD/HgPNtRsbtXNF6sg4TvzHzM6QXHn2bk/6acYCDjxFzIU/ZG7bLaF7nj5tD/PI7xjnAmMxnoYxz8ph4CtbdDTbIetjKMo8cyNBC2XPXOXm/joaMv/jnbfE3YF/9C5FhXf8oDIOpKf7w2FuJvc13WsT3TXE39p/X0AA9zAJt6yKJN7LiZ7aFMdWhTGnCUWVHpSeyMiLZEmEj415oKJ8RgszxjqsokrInPHLVjcrL1GkAaLX6Nvwf+h/eGOD5Pqne/khjI2eKPOqpvxCP9WSBE3m89MwPPSrOE6DoKFsBklE78e+hFfF2A6W2NnYV6Xk7TWPxJK/GufTk4OmHXhCcTwtfwnWVJLhhrgT9CZPaPv/YRpcIvTJrNbvu+iVD8X86+R2vwfU4K91O1b9q+nCdVOeXXtHjMpQHoS4SaikJ0bN7YuxJLS1WCL4Nn35X3vMT+1P+k4pvlTl1g/ZPuMBycuBuW6ZHesCwFWpqc/W7JDyWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(346002)(136003)(376002)(64756008)(8676002)(33656002)(91956017)(86362001)(186003)(8936002)(4326008)(76116006)(66556008)(316002)(6486002)(71200400001)(66446008)(6916009)(36756003)(478600001)(2906002)(38070700005)(5660300002)(54906003)(83380400001)(2616005)(41300700001)(26005)(53546011)(66476007)(6512007)(6506007)(38100700002)(66946007)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?opnT4WfC4vy8Vqg7ffzOd0f+b+lAaXZLA+ArITjWYLq1ikYQfKik0LM1skjQ?=
 =?us-ascii?Q?zFtDcAIyHYZ3lYxH/hLKX8G4SBhpsgKGfLlQbgIfGfWjnqz+YaFsOaNz8KQy?=
 =?us-ascii?Q?T7fCK/6et9bMoAfdnR8YxPeqstHpW1wiUWMvPj0bui5MmY8RPbqTfEwai5GZ?=
 =?us-ascii?Q?bIkS9JgY8nOMsWJDG71GrhuYIUs65HLeRLEzhhmqCkZcBrjUfKcJBvp9k7bu?=
 =?us-ascii?Q?koRuBQIsgYL7Q54akLMsFjqjOy2JFhuBqTnNOUb47gSEfMeHuFoTsvCrCFxd?=
 =?us-ascii?Q?6Ec5YKpSvxNi3SzG2EkakYJ+ERaqwRJz/3JijsXFpCsVrdHMv7qkCKIh02Op?=
 =?us-ascii?Q?uIv0fqC0MQ5u6ygxafm8QkQOjD65my0Ol8tUx2EiBP2K/lfYBmTXZLmpUc3z?=
 =?us-ascii?Q?Bnqe0AVi8PY0o+GTqpAVdfHGvg7XvmNz/wNy9nOB12do2VfTeXJa1aDoL0e9?=
 =?us-ascii?Q?rRZro0BbwNcVT5WxWr8k3WQIyVZ6pEkONERXKQbd9f7P7JGoS/b/o4oCG8qP?=
 =?us-ascii?Q?/hTODOUhDHodDGQl3Qonsr1RP+5JNnBPZRRkfhNynRJHic4bZo8V+cZSdYb9?=
 =?us-ascii?Q?50uGGym+4IyiPp0kvjojOTNUTEJhEwrFH1u1mbPCpE+WczO4Gtr7TRqkpVFS?=
 =?us-ascii?Q?zrN32m5M+jXTzj1PnZgmTYSKIw2QZAVRxL66aJr/RrWZ+WnePshIk/zw1Ugg?=
 =?us-ascii?Q?AYDZZdHUZnbZNS6VZ/EVzeWT+E/YbWb80KXUZKuZP1cXKSvLZrcR0zW8gQxX?=
 =?us-ascii?Q?+ZA9Qw6Ted77GRq79gat28Lrj4WtX56GDDCUNZaK25PAsOkNEj8cGNwSb7nw?=
 =?us-ascii?Q?QzL+D68r7BSfcZxxVMNUWFhO6WMFgnJzljVItxSA42Pd5HeXOHgSuSiQ+R9N?=
 =?us-ascii?Q?sw09O0xbcg4cJ/6u0q1nTO0QvKoi26NjBvOFjjBmGyTJxVEsr5guGDL0iP/i?=
 =?us-ascii?Q?GYsFZeafMba+TRU7JAxKnspHxERwgz0cS9823kD2tcXIqT/TNKic5sFxmuP/?=
 =?us-ascii?Q?+BsWrux+kJXLdWyeN6y2HEUFgsoItWh11IW0CUVrsH74ajbcyT0AAlILZGZr?=
 =?us-ascii?Q?o6PuvQ1QXpcVmsZipEP555pfzqkdDOcFMX+9CEXIh49uyQjN96ogbUurKM5G?=
 =?us-ascii?Q?aFHMjkHGbcppxX2uk+EG5fpO6Tkw/DdxoutpqmQYHHAaVETKDQ+738PBoNAw?=
 =?us-ascii?Q?oFhfbGQuL8BD86yiTMvFzqb3RL2/nco2AE0MnIqreyHoGR9E8vTTVGG2EuVN?=
 =?us-ascii?Q?Ij03NHAOdIBjgcz1u85ogJSTiBl29w7nSYnU2Xjho2Y7wssheXts+ehRlxxM?=
 =?us-ascii?Q?6EVLDvX1EBlXOs6uXes3IgEghKNvoOHm+qHVd3lRILLDPgFO6RRNXNhNdXsl?=
 =?us-ascii?Q?IvKDkqYUtf1lykOmdxe88AEXkqDlxAI923HJzPt0QRsqadWSuCLhWcM2f802?=
 =?us-ascii?Q?bfi7xBrMrj8EUveFIbhgLxkipwSWiwyqDKeegk0WwF61WapZxCFzE7+kdJAM?=
 =?us-ascii?Q?ZFY3AsT+VKgMRwckL8D6v4GeeZkgwmBkdoQSfyGL7H+QV7FkKSEhYtvTRgbR?=
 =?us-ascii?Q?7vnkhmSB8vJCckkEOmpsm4sGkHXam7cktUH+bcDIfP11Km3neKKJsvsAYa92?=
 =?us-ascii?Q?JQLl5O+NK3MAyz06/7WFD2tN2zV4MC6MWT4ZggZNkrvLei0pqEzUyXt4cNMu?=
 =?us-ascii?Q?U72kYnLYzhqfBTEFyAADWRnrSkDE+t3k2WB5sRuzh1nDD8TbJmNvBvmDnmoj?=
 =?us-ascii?Q?KA9DhwhOo24e77QTfI1C1hIevfNaSo8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3581734C1AB870479B38B9C4C18AE776@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e06d2d-98e7-4949-6845-08da5537ac62
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 16:44:42.9570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qn1J/rl8t1PTsbRI2ir7IvxU00Lf+QD1Tk1vIuvrsq+BzfhXMa1siIas8UX8Sdt5iqw3SidaeSyU/tB+Rd3QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5782
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_06:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=369 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230064
X-Proofpoint-ORIG-GUID: Nsi286nM2kLXAYFm7HOz2WgGe-1wBEPG
X-Proofpoint-GUID: Nsi286nM2kLXAYFm7HOz2WgGe-1wBEPG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2022, at 5:02 AM, Wang Yugui <wangyugui@e16-tech.com> wrote:
>=20
> Hi,
>=20
>>> On Jun 22, 2022, at 3:04 PM, Chuck Lever III <chuck.lever@oracle.com> w=
rote:
>>>> On Jun 22, 2022, at 2:36 PM, Wang Yugui <wangyugui@e16-tech.com> wrote=
:
>>>>=20
>>>> Hi,
>>>>=20
>>>> fstests generic/531 triggered a panic on kernel 5.19.0-rc3 with this
>>>> patchset.
>>>=20
>>> As I mention in the cover letter, I haven't tried running generic/531
>>> yet -- no claim at all that this is finished work and that #386 has
>>> been fixed at this point. I'm merely interested in comments on the
>>> general approach.
>>>=20
>>>=20
>>>> [ 405.478056] BUG: kernel NULL pointer dereference, address: 000000000=
0000049
>>>=20
>>> The "RIP: " tells the location of the crash. Notice that the call
>>> trace here does not include that information. From your attachment:
>>>=20
>>> [ 405.518022] RIP: 0010:nfsd_do_file_acquire+0x4e1/0xb80 [nfsd]
>>>=20
>>> To match that to a line of source code:
>>>=20
>>> [cel@manet ~]$ cd src/linux/linux/
>>> [cel@manet linux]$ scripts/faddr2line ../obj/manet/fs/nfsd/filecache.o =
nfsd_do_file_acquire+0x4e1
>>> nfsd_do_file_acquire+0x4e1/0xfc0:
>>> rht_bucket_insert at /home/cel/src/linux/linux/include/linux/rhashtable=
.h:303
>>> (inlined by) __rhashtable_insert_fast at /home/cel/src/linux/linux/incl=
ude/linux/rhashtable.h:718
>>> (inlined by) rhashtable_lookup_get_insert_key at /home/cel/src/linux/li=
nux/include/linux/rhashtable.h:982
>>> (inlined by) nfsd_file_insert at /home/cel/src/linux/linux/fs/nfsd/file=
cache.c:1031
>>> (inlined by) nfsd_do_file_acquire at /home/cel/src/linux/linux/fs/nfsd/=
filecache.c:1089
>>> [cel@manet linux]$
>>>=20
>>> This is an example, I'm sure my compiled objects don't match yours.
>>>=20
>>> And, now that I've added observability, you should be able to do:
>>>=20
>>> # watch cat /proc/fs/nfsd/filecache
>>>=20
>>> to see how many items are in the hash and LRU list while the test
>>> is running.
>>>=20
>>>=20
>>>> [ 405.608016] Call Trace:
>>>> [ 405.608016] <TASK>
>>>> [ 405.613020] nfs4_get_vfs_file+0x325/0x410 [nfsd]
>>>> [ 405.618018] nfsd4_process_open2+0x4ba/0x16d0 [nfsd]
>>>> [ 405.623016] ? inode_get_bytes+0x38/0x40
>>>> [ 405.623016] ? nfsd_permission+0x97/0xf0 [nfsd]
>>>> [ 405.628022] ? fh_verify+0x1cc/0x6f0 [nfsd]
>>>> [ 405.633025] nfsd4_open+0x640/0xb30 [nfsd]
>>>> [ 405.638025] nfsd4_proc_compound+0x3bd/0x710 [nfsd]
>>>> [ 405.643017] nfsd_dispatch+0x143/0x270 [nfsd]
>>>> [ 405.648019] svc_process_common+0x3bf/0x5b0 [sunrpc]
>>=20
>> I was able to trigger something that looks very much like this crash.
>> If you remove this line from fs/nfsd/filecache.c:
>>=20
>> 	.max_size		=3D 131072, /* buckets */
>>=20
>> things get a lot more stable for generic/531.
>>=20
>> I'm looking into the issue now.
>=20
> Yes. When '.max_size =3D 131072' is removed, fstests generic/531 passed.

Great! Are you comfortable with this general approach for bug #386?


--
Chuck Lever



