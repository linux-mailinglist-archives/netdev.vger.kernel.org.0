Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEEC393306
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbhE0QBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:01:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62650 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234147AbhE0QBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:01:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RFr1nN024092;
        Thu, 27 May 2021 15:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=wNtzehL9DEOVVkQZGhXcgbSzBRWAUtIrth7vUOoTNy0=;
 b=c0vsyq9hpbpVxTzZp5V4AzxoejwnznUQlEtS8WZyTainqTlYRlv0gxblkjWr/1LuS7vK
 7CqU1yqqx8e56iFPX6x1/6oGQHpL2iKR/E6yltmkSG3Z0F+2H0c0UU+OovkyXSEeaDdk
 HoHIpGKVI26L+s0+sSEn2rDogVNc9ea3YVN6NEBOxGhEx7V8aDjRSLPCVzqY/y9OHjjg
 dHlNITRDzbz+GZ73apNm1S/BO1xiJ5EAjIUIMLZ963KV05Dsj76dHD69Zt4XKBxzhHct
 QMIOEOJ/G3RvJNNZoDv7r/tyQJxPT2ssMNBzbG7wVlh2+AdBnY+HOrF2H0okdFhva2qH sQ== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38sn3yrhb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:40 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14RFq4qU092141;
        Thu, 27 May 2021 15:59:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 38pq2whdwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZgXUU722HkrUEHGLXSJ4aryQZJezeWvneucvDAjXW1V8xWvHwGQ+IfTklQWbOHvkxIijA2kghlMszV9Mnp5+cisb205c37G7vAje0Lny/N20IYEs+nF1rgybFln2IsMj73CsUDMTqejBzavlKO7FwtWHkYH+K9BSkmsso+zVus2qJd7R7xmBYpU8aTDravX8USaGquetYlKug6ur+KEg4DxePl/BZgv9gVXPzQgfYNDpEzxbV6gEth5g23U/RFlUedO8XAg3Lp9Ng9bpy2SU8RkUzYeBomTkG0cQkkogoneLE7peSa7DpMOHYmwWEM3Oz/j6PHRtD9ytr9WPp3VUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtzehL9DEOVVkQZGhXcgbSzBRWAUtIrth7vUOoTNy0=;
 b=CD4TWN5owEM2M1MYIKZl2yElpVMwkGKItcvd6/FatkFctLlORZs7xOjF8MSdJGnBynCJNQkzdSRXolvBaT1mIzJboK9PqXkUYwOv0nJi1EH592sHVgsoe1tHU9ujYYXCyyljZbgwTtk1DcXhBX2LK4HvBZLsgay8v0OyBOTLFrbm/jhdBqgls91x0NFxvEhA0Ohk/MALzIAn6opCxgIBDcFamToMbtLDqJZLy8XJh9YJILYv1wPzHDg1QLwkoxSduucupC7r/aL/Rn4XN9WduCFrH10MAG4dyOjlBSVvpNfHVcwOmoNzk3RVWARpUB5xUxIZLdDZETOX/ijEQ5kMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtzehL9DEOVVkQZGhXcgbSzBRWAUtIrth7vUOoTNy0=;
 b=px9KM0UcaTc6TpurID9hnTBltXuwydvEgaeiyWxusoyTbfvMTejbVJIFT8fzeqKqmOBMmkN5ncPhB7MpO+ScDBX+gjJpIWSSGdIwI28A27x0nx8tLwtn/6+JcRvbENjVw5xJSTuCsky43KEmCGIkCXaNQaCXGHFSD1atc2szAs4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3342.namprd10.prod.outlook.com (2603:10b6:208:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 15:59:37 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.020; Thu, 27 May 2021
 15:59:37 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 0/2] libbpf: BTF dumper support for typed data
Date:   Thu, 27 May 2021 16:59:28 +0100
Message-Id: <1622131170-8260-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:152::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 15:59:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44919495-d3c5-4e6e-cf57-08d921286db3
X-MS-TrafficTypeDiagnostic: MN2PR10MB3342:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB33424C40918C8879BE9F9C23EF239@MN2PR10MB3342.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48LlfGDwT3PtSRgb1apsucc7mVCJePKLCyql+xdVhQCGzTIAK06WUpxUO74/SqvlCFQ+MDladfGFlCWdYWQ/EkaJG5GIhMPeaQwcO9JoNLPAJgppnnl5i92ChfOUQlfdZysE+MOrB5QzXpsYBDTo95KuhT/ZhXXMu2IC+btSxJgIKamLf7R10FhsZq735MAhAR2QBd5U52yTqV4v7BcfjE937Kf/AJL3jii49d2ZTKiT6bZ9jgliCwHOdhoYT4ZmGqbPWpDUcvv0I/bQNTfIhFOKSMKMwsGN1ssbfNbgg1fT2IHfCH8Mt8q+tFAv/5vhOoxBi3aWNl9tzVtzX5nc7Mu6eGcthLWkzsD1xCSooah4daUPDCRRwMsHTDOudHbkh07GLlsUlZbPNhkOXJxAeSNeudSK0y+jwSSTUqjUxNuL+MtVSPdi4meY53RqZgFkjFbFDq9Il4H+xIQAjeXAxtCcd5wUknDWyonpKil/1dTmRxsyNf7irNhUyJD/yXn9xBTaQCspH3A38AnNj56des/WF7QrFl/Raus7UbnonrNsAFGVv7iNVauxSGTNPR1Pqk7hE1t1eA56sd/ER5bVswgrBf7tIBFfBLvID+gH+7CgYUaxH5EpIh0xZD6CpZiB4zAThHTbAabZGZCOn7OemL7MuHMlQcgfqTiaPW4RZiAD23k3Chzg7EhjaYb4jKZrfnzcbEh6UYYX6KKWgXF01aJ25yGygolrLeu2vSMoBBjTf/A3rLYtPUD7IPW9n3EwQi1f5MMHGmoHhfgrzp32Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(478600001)(26005)(966005)(107886003)(2906002)(4326008)(7416002)(44832011)(956004)(52116002)(16526019)(2616005)(186003)(7696005)(5660300002)(38100700002)(66556008)(316002)(6666004)(38350700002)(8676002)(66476007)(6486002)(86362001)(66946007)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ftMPSTgOgH6CSSK/vmzAZlhChT1M4+srTHYEdjTV0KLPFM7z52j3bcXkIpSt?=
 =?us-ascii?Q?Y7bO+/MG3aCjfhWRdinsoGGiw8mNbExz7q1sbBhJeXeJ45IHU3qol/Hj7Pv9?=
 =?us-ascii?Q?Y6LfXOApunAFHgfcWk03Kkq7QdB17UpmJUX+2u2TIl+g6pfS+EewKuSyggj1?=
 =?us-ascii?Q?+iO596ytOGY/eikE83gVV1ULx7Tu8LTSnpkzS5VcUqSoZvge0Jq+h1CMpc/n?=
 =?us-ascii?Q?C4Buk2Zub65LMFvTAA04drPASHfP2u2hdI0K8ceazY+KrkpdZx9r0QWP9ozG?=
 =?us-ascii?Q?KZh8K1sI5fvlbwcpkn1spafpPZYgTsvvEq6of/hbyTqd6+k4lVV5vhlgSntT?=
 =?us-ascii?Q?GIHqKnIUgxRX/KZBvT8Wl5Zd9XzJpcNi48YOE0HwOhlmWQW8T/nxoiTTfzFG?=
 =?us-ascii?Q?DiNWjoRq3kRHiBiYRx3mu+8j4qd5pM8fsfp3FkWshkpf3XaRZhj6bTU8K0Ua?=
 =?us-ascii?Q?PPQyXoLfr996prK/aTR+vAgDHyTPm8Z+W70cXZJFjfraI9igC5Q22Frfn21j?=
 =?us-ascii?Q?TW3zs6U1jj3mgT+q/xPR0LWmVYJANFX3xGpvL25fE+TsAZo6/9wePe2sIPYd?=
 =?us-ascii?Q?Fvn0l8ec5le+LECRqnpgtr8mnq2EaGgqg46BNM1y3MlPkhz9eMAt7Y3YV9Dx?=
 =?us-ascii?Q?7euUBgkePJyQ0+WIBx3CrmEOINTAiKfb6P6Uu0Lw7lHOVZVGXqC29/bRQlvE?=
 =?us-ascii?Q?aF7rhoYiUgNVvE4lhF32Zy6WVH5bSQTDmFidOoIBRRfQsHjlDu8A7i3RpDXn?=
 =?us-ascii?Q?6IAm1j4bqW/Wolg+KfkNCanCj5dhqJTRqKgsSsjzeRAwG1QSHV84YMSsolUR?=
 =?us-ascii?Q?QJc3wTWlaZ6T85xdD+qavL2r/F3CwJef1pPfj1xRIrSlSTpEEtaT4trBq3vw?=
 =?us-ascii?Q?BmqaA2e5DIZMgiFM0LFB17ZpmHAQitX48VMpnRjK8p4bkq2z5UWNRzzGu4/v?=
 =?us-ascii?Q?fqAuLTwKEmtMMCgrURZaF0vtZ5Q9/m7NECMButVIwh9/nJd/S8W0DNRi0LKb?=
 =?us-ascii?Q?FUQCfy5teaR34r0ADg+55cX2FpoIffs4wlOzfiW6b/FKRhIl8IpUyyoezXSt?=
 =?us-ascii?Q?dtrZFo+X+hJ/9bmiEuIXbyowFrsbkHGiJzB286JpMDo5kTCQ0twevjCL9cdG?=
 =?us-ascii?Q?/ZJCLvUy4RXFA0/rAvt6kogzPHKPYk3FVj7b551zZ6dKK7BCaKyzJ9UHvBj/?=
 =?us-ascii?Q?RYM6QndVLgeUDpFnSaNQ1dmqLX1d4saI3AKVNK3bXxToHyu6F/rqwW4NF5DW?=
 =?us-ascii?Q?ORk9E0yMoog+2gkf5euViMGUrHPXBBW+QtcFNq/jkE8Cj8uJBK05FEmvT1kF?=
 =?us-ascii?Q?AZmQY76QVaTfnl8QC6xMcleZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44919495-d3c5-4e6e-cf57-08d921286db3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 15:59:37.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DulZtNoC9HT2YDxLl2ouGcmWM1uqfS3+DkfYLnZ+1XbHi7sxuSGGFphB9K/5aYropAwObz64h8OezkM0fjLIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3342
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270102
X-Proofpoint-GUID: zC_CdLbeHyJZVUHaIzQs2lxLeMvvmRn9
X-Proofpoint-ORIG-GUID: zC_CdLbeHyJZVUHaIzQs2lxLeMvvmRn9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a libbpf dumper function that supports dumping a representation
of data passed in using the BTF id associated with the data in a
manner similar to the bpf_snprintf_btf helper.

Default output format is identical to that dumped by bpf_snprintf_btf()
(bar using tabs instead of spaces for indentation); for example,
a "struct sk_buff" representation would look like this:

(struct sk_buff){
	(union){
		(struct){
			.next = (struct sk_buff *)0xffffffffffffffff,
			.prev = (struct sk_buff *)0xffffffffffffffff,
			(union){
				.dev = (struct net_device *)0xffffffffffffffff,
				.dev_scratch = (long unsigned int)18446744073709551615,
			},
	},
...

Patch 1 implements the dump functionality in a manner similar
to that in kernel/bpf/btf.c, but with a view to fitting into
libbpf more naturally.  For example, rather than using flags,
boolean dump options are used to control output.  In addition,
rather than combining checks for display (such as is this
field zero?) and actual display - as is done for the kernel
code - the code is organized to separate zero and overflow
checks from type display.

Patch 2 consists of selftests that utilize a dump printf function
to snprintf the dump output to a string for comparison with
expected output.  Tests deliberately mirror those in
snprintf_btf helper test to keep output consistent, but
also cover overflow handling, var/section display.

Apologies for the long time lag between v2 and this revision.

Changes since v2 [1]

- Renamed function to btf_dump__dump_type_data, reorganized
  arguments such that opts are last (Andrii)
- Modified code to separate questions about display such
  as have we overflowed?/is this field zero? from actual
  display of typed data, such that we ask those questions
  separately from the code that actually displays typed data
  (Andrii)
- Reworked code to handle overflow - where we do not provide
  enough data for the type we wish to display - by returning
  -E2BIG and attempting to present as much data as possible.
  Such a mode of operation allows for tracers which retrieve
  partial data (such as first 1024 bytes of a
  "struct task_struct" say), and want to display that partial
  data, while also knowing that it is not the full type.
  Such tracers can then denote this (perhaps via "..." or
  similar).
- Explored reusing existing type emit functions, such as
  passing in a type id stack with a single type id to
  btf_dump_emit_type_chain() to support the display of
  typed data where a "cast" is prepended to the data to
  denote its type; "(int)1", "(struct foo){", etc.
  However the task of emitting a
  ".field_name = (typecast)" did not match well with model
  of walking the stack to display innermost types first
  and made the resultant code harder to read.  Added a
  dedicated btf_dump_emit_type_name() function instead which
  is only ~70 lines (Andrii)
- Various cleanups around bitfield macros, unneeded member
  iteration macros, avoiding compiler complaints when
  displaying int da ta by casting to long long, etc (Andrii)
- Use DECLARE_LIBBPF_OPTS() in defining opts for tests (Andrii)
- Added more type tests, overflow tests, var tests and
  section tests.

Changes since RFC [2]

- The initial approach explored was to share the kernel code
  with libbpf using #defines to paper over the different needs;
  however it makes more sense to try and fit in with libbpf
  code style for maintenance.  A comment in the code points at
  the implementation in kernel/bpf/btf.c and notes that any
  issues found in it should be fixed there or vice versa;
  mirroring the tests should help with this also
  (Andrii)

[1] https://lore.kernel.org/bpf/1610921764-7526-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1610386373-24162-1-git-send-email-alan.maguire@oracle.com/T/#t


Alan Maguire (2):
  libbpf: BTF dumper support for typed data
  selftests/bpf: add dump type data tests to btf dump tests

 tools/lib/bpf/btf.h                               |  17 +
 tools/lib/bpf/btf_dump.c                          | 901 ++++++++++++++++++++++
 tools/lib/bpf/libbpf.map                          |   5 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 524 +++++++++++++
 4 files changed, 1447 insertions(+)

-- 
1.8.3.1

