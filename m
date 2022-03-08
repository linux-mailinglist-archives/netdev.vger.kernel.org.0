Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23964D0E09
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344369AbiCHCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 21:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiCHCcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:32:13 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23A535DC1;
        Mon,  7 Mar 2022 18:31:16 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 227NQTBV023710;
        Mon, 7 Mar 2022 18:30:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=CijzUaDsOQrY90sTgX0Ij207HIbHRGssQrvy2+ozIj4=;
 b=lfQSJ/h8Pm6zb4FlIz+psSnqgkSKi7RrS/juwDzXydRtxBIbTocoUch+F/0+QVpKgze3
 cmn9DEV5fBFkA6wjsX1FAvtRbOaFlnb4s90ThE057LEdYBO8lDTkEWfxnC3wx+gwYoq6
 PiBvWga9GbT6UuYC7irZIL8EjlunyF17qKg= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by m0089730.ppops.net (PPS) with ESMTPS id 3emrgqujjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 18:30:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdZu6jJXU8s7uHGi/B7XJrSwDiEWdKgKLlIfz/n9CROopnzqK2S97kQVBkJA3jNIfBiFBsn6v8WlptZjRQycHQq2bKysOt9IrQzWSjMmLVFt27KJAC87YG0j5zrW1XtNzh5A0iD59CREgdAbVsE9ExJPJYH1UtHc+5G0cYPxl+8922bkS/8hQS9w4tLa3/J62368BI9LmToITAaUqKr3uqKrEcoloQ1fKLJuNFQHkHnuZRs0Yg6Yv6a2dN/4HCReTvm7uPYOX/BrHvKN3++IKTxW21DYXv965xCDg8QbBo2zz832cFYrNoDlHfZeoC1CoZB6qs9v89Jd6gO3TKxzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lby1yUwlsu+2jAeNIMfcsfRnlQQez4LUicDuV3Gjpxk=;
 b=ZG0HlvFx1euxm64I0FNazQbISzk4rMGAgrPXHinBKhhpK/Eme29tjXcvhrNBnxi+4aKIA+xa/RjxhIQ1MDBV5GCS0ZGrT6yHKzGRIwbniuMwK+wXMMPch2QTT14v7R6JQHvsdzC6aVSjnayXB3xa2YfRDZo3gq5I7t8oxCo7VqF91ipb6a5nn7W9Y8RS1DioLBRUdaxxftd7L7TJc7NIpWdqjY/UmJQ3Y40C5h89eaVGkf5bkV5gG9lKDUlV7W//VbWnj7Nci4g0Qi8AJJFrtmnlq1fHI6fHzirJRyJra1fWz4/kOqi0C2PpUGg7m32T0t0UKlqZL4Tc9D5PWFdIqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CO6PR15MB4193.namprd15.prod.outlook.com (2603:10b6:5:349::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 02:30:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:30:57 +0000
Date:   Mon, 7 Mar 2022 18:30:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 4/5] selftests/bpf: Move open_netns() and
 close_netns() into network_helpers.c
Message-ID: <20220308023052.f7x5oxrcbdxnq7vu@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-5-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220306223404.60170-5-toke@redhat.com>
X-ClientProxiedBy: CO2PR07CA0059.namprd07.prod.outlook.com (2603:10b6:100::27)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6869acf-ba0f-4feb-9a99-08da00abacf7
X-MS-TrafficTypeDiagnostic: CO6PR15MB4193:EE_
X-Microsoft-Antispam-PRVS: <CO6PR15MB4193A5FFAEE94BA7E0C68B4ED5099@CO6PR15MB4193.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UFWqlqRdK5/da7TUwcPbZLOTpkRXXShtmwWfexCLCZabT5VMgLh1BQKC/MAQaO1CcD4jHkRwczHFCsuyDIE8UB9iIbVVCLUCU9NRq7Qq2aae6jIQSWXX9bzkvSBoYlp0VNocjMdnAzImuMsprCXKhOM2b4ero9TwL1Tsz1pULeAEvS4gSsMkPyQYB1binM+9asRyoGqb2wsQ4UhMPAGUf6tFGUUzSJoKV2+xaVfvXLhsglgfdpY+N3DtsssrbNaLkuPzNnfYdU3H3ERApXbSuPCA4pMxK0mxIkWq4fvFiBTfRPNajMMe7eN60shp38N/OcacCT+bxKRn5cRb8k/j4rHmkjIuBgqQGciUZO/45V6rOtnLZVW0KyJDIZnGi+Mc+gegc17vTaE5D3G4PDIRMhaqD5fQQHRgDW2YyukFvTxt86LG3MruHdN70t4g2lQBDtrW59y/jtSFbSIICau1WREf+w8yURJU+gnr3w+OjLICdO7xYsJwMsFOTfr0x6/iteSHOw9Ga9r0WTfMX6ecnv3IGpPB80hAl5uT5oNIx67BTbt2pedhwvDvNdB/ULiMo2ysXMotTVoysj0wXgjPNawjP/mRsowNXJs+K3uqH22P7ELOyBD10PwCKWuad4q47JmrkM7nWja3xcHodEUF9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(4326008)(8676002)(54906003)(316002)(6916009)(66556008)(66476007)(38100700002)(66946007)(8936002)(7416002)(5660300002)(2906002)(508600001)(6486002)(83380400001)(9686003)(6506007)(6666004)(6512007)(66574015)(52116002)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?b8t+6UtcHzmywqKYeCDRcTyzE5O+0hY5ObkUzyM0mHbNxSLAsEtfQCw8V9?=
 =?iso-8859-1?Q?MaCLFPVEbsCbfKtNHTCsJdxtC8U75QgfhUrq1nvDg+/Z7FM2CDaXxMKT9F?=
 =?iso-8859-1?Q?GD8XQyU2Wxa+RDu56pV9Ro/T88F+0TCGv0+vBZmsTa0L89h+QSEs+8fiis?=
 =?iso-8859-1?Q?VeSNkp34GDrzb2/gPOonjZ/pBW8MHLUqEEUeR4X5+viw0UAemf9xx0hewP?=
 =?iso-8859-1?Q?gpB1NqsH4HF7Le5DeWUf0vGvdesMM8FdTbX/MoF90/YDMWLJQVtaLpnDNs?=
 =?iso-8859-1?Q?q5DsB9+IrzQIZwfY0yVaPFHRTWxQfLD/BEPlh9AkozteJZOj6xBlbPFGv3?=
 =?iso-8859-1?Q?LD2N6WyE9/tIc5dQfUQFK+MJd3ezdr4E7xwb8jmWUypGLSi9h1HbixQ6zp?=
 =?iso-8859-1?Q?saIT03s988I/LJmWB7GQug7Ii3WRO4cO4IAYu93BjigXWlaeAwVqlDoPez?=
 =?iso-8859-1?Q?Uub0ftkb1L/CPCTLx4SkFMGFTrVzAK26qLdfQKEuCcbOJc0ixaftuj525q?=
 =?iso-8859-1?Q?yC/TXnQSroAyc/Ss9CKNOtKsgObazR6XWYOs7kMKsDOV9I6sXWcHWnGQgb?=
 =?iso-8859-1?Q?9tvaNzqctWTf9WBgweZUiVvBS2PHVCEAFCfGMPsgqPmaLhInxoa3GIZ5Ki?=
 =?iso-8859-1?Q?SJV2C457MZ6r8jakF7AUlOVr5Z1j/F3nXLB/ejDZvarifdIE6xuIZDnYYJ?=
 =?iso-8859-1?Q?dH0Lj6zk15NxRY0YXG3ZWJP5/CH2YS2RJIh+bZEfQx8W2DA0pNX29EAfui?=
 =?iso-8859-1?Q?0g7Eyh1Zij51kNSH+K4kn7h3SJs2d1YXSSJ5CxUoCjDUkpY50fWG/2RViX?=
 =?iso-8859-1?Q?1yP+Uyc3n2Ms+Zc+8wP80GyaEklRHvCucG77sYLyokz/+Y7IjNd0EsNkqI?=
 =?iso-8859-1?Q?wYCiMVAAyTi8HrBt+9Zz0Y8VQCZo2Ue+tqnAuQ/EpfOf+y3Yf0ZwBFQ7E4?=
 =?iso-8859-1?Q?wCkUCkNatYD2mgz2HDICGptikaI1celGbF1tK2r4WrJ2KRhDlKNOV2KA8p?=
 =?iso-8859-1?Q?cOSdcyJiolEmY55wXTHCt8z515hEGrZjY0/K6HkvLlH0HhAdat74/eyr+i?=
 =?iso-8859-1?Q?eaIAZV5UYMf/bDm9y30ATiPJiAWMe6E9rTx4hB8FAS8Uc6DF3NHm7P8Owd?=
 =?iso-8859-1?Q?RzmED+FC0qz6w3llCxP+aeawaY77Osz3d9gFuYDxqWWnIl12stTPBzjV9j?=
 =?iso-8859-1?Q?qqwuJ+MKyE4e58USt7ah8zV8g8MFA9GvJG/jKAQQfjfNi4g0lInUh3QA/7?=
 =?iso-8859-1?Q?yVfL9kzXmFYBTgeP+B3kLm02FK/rnW0fgGT2OPVrM+NfRu8ej/imOKh4j2?=
 =?iso-8859-1?Q?w3tERrLwN/WTS4qcH5TYmzUG+Q3X+qxtFy5PxN3kyPKLzarL07geh65EeP?=
 =?iso-8859-1?Q?Cs0IP4zJwNZwWes+v51l6vzM+GBxy1K7JRHxSM4/Z63ofvPyD/lHe8TX0R?=
 =?iso-8859-1?Q?HALN7iQlenRAZktagIWrAW/O24bLOmah3cfJyRHgAGpKwjSGvuj8LKnX3g?=
 =?iso-8859-1?Q?QTP9ZI761C6oMUWlP0iMW0HLsnuTZZpXK3PoUN//2TAMniXb1dQYpD3n7F?=
 =?iso-8859-1?Q?VGwO9r7J3+ZIuPkYGIwbMRTmVJ1mbOO8oyufDo0KwasK8MFjkVaXzG/W0e?=
 =?iso-8859-1?Q?XatagkE+6pAC+1i1QJG2kjJD+dqc+Bf+EQBRBGuy5zgyhoFrBBFMAxCA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6869acf-ba0f-4feb-9a99-08da00abacf7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:30:56.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8A/PIdHuhLKBo/BrNomwqo+WLkes7splgxcTd8bi8JKsKVF6kNtK81P+JqZE11h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4193
X-Proofpoint-GUID: haR8cmQG2_OYGUTTVawSU8q4pEJkpIAe
X-Proofpoint-ORIG-GUID: haR8cmQG2_OYGUTTVawSU8q4pEJkpIAe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_12,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 11:34:03PM +0100, Toke Høiland-Jørgensen wrote:
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> index 6db1af8fdee7..2bb1f9b3841d 100644
> --- a/tools/testing/selftests/bpf/network_helpers.c
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -1,18 +1,25 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +#define _GNU_SOURCE
> +
>  #include <errno.h>
>  #include <stdbool.h>
>  #include <stdio.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <sched.h>
sched.h is added.

[ ... ]

> diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
> index d198181a5648..a4b3b2f9877b 100644
> --- a/tools/testing/selftests/bpf/network_helpers.h
> +++ b/tools/testing/selftests/bpf/network_helpers.h
> @@ -55,4 +55,13 @@ int make_sockaddr(int family, const char *addr_str, __u16 port,
>  		  struct sockaddr_storage *addr, socklen_t *len);
>  char *ping_command(int family);
>  
> +struct nstoken;
> +/**
> + * open_netns() - Switch to specified network namespace by name.
> + *
> + * Returns token with which to restore the original namespace
> + * using close_netns().
> + */
> +struct nstoken *open_netns(const char *name);
> +void close_netns(struct nstoken *token);
>  #endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> index 2b255e28ed26..d9e48b3ac9a6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> @@ -22,7 +22,6 @@
>  #include <sched.h>
sched.h can be removed?

and the _GNU_SOURCE above.

>  #include <stdbool.h>
>  #include <stdio.h>
> -#include <sys/mount.h>
>  #include <sys/stat.h>
>  #include <unistd.h>


Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>
