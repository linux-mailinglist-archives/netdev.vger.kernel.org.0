Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF645AA76F
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 07:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiIBF4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 01:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiIBF4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 01:56:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DBD6A492;
        Thu,  1 Sep 2022 22:55:57 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28208oDA019809;
        Thu, 1 Sep 2022 22:55:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tQ3yMpodHeCELwKFjuWJw9TX9W4Evc1kj4vzxLz+rMs=;
 b=ThGmSYCrUHhq5KyKSfXegqRMQpoqPn5e4yfy5XVojWHQp25eMrGOAWXUc3VxmYdIezpJ
 S1OUQ/iczPtH+T3wpiHEbtVGptYsDwX3Xoru9rLfkQb7NJSOlLvO5SLahusHLCvoWaZt
 XT7IzFk3gLARsEc0moEC0FjblWjGwsLl1iw= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jam3vgbkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 22:55:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfJcFlY5Nh40o8HdgCF8c4PzpJysZZVkWLTxja+BzwXuS0VD5aOblXkYq+84b+yyqAvB4sRfuq3VKvancKcOUTE6d227NYvS0n0w3g8Zk6Hg6PwBcAeHcDAtB8P2i2gv0+yj07FR3Buni/RhW2VijGTzVpNRC/B3q7C5Sq/Kz+eD0e8jyPyB03bJFNWFZxCCBphJgawvm/crm6HlTvhsOYhA5koSxvWfjDETbxUJAHq8NQzKuWZjFaOE180WyDyLM5Tbqoo1a/sWSrhYdfVNljvIl4UfMTqmjSANp+nd9JuCFi5qmMbjQZ59mFWh7yrWZkuo3HLUrqvhYsZibXMI+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQ3yMpodHeCELwKFjuWJw9TX9W4Evc1kj4vzxLz+rMs=;
 b=FgyQQMx00FSk6MpFQlQfAK678P1neHoDBa268WwgSfskyda7QN3DzQxuqmEMk5ppI+O2lZ4K/fo0YAGRk2AgWMIRy9yN3G66a/fQw5irb5c9XYXkkjnWhTbqSC9fwD5Y7fxAK09ieYseQMCLUnY95rj/oL6Uqy+DnNbHS10L7gF8N4ozZ/MyaHK604IMpgX7ZDM4slLgJEg7DRsMFA3VCoYpUSKC96ti9uEAHbb/bZVQKQ1JsB7RA042nrq0QpXc1IOBNyUS6FLnZUCVg2G4nIfnRoM4P6PJLA1zRKoJmw1rAhTUrx/+xGeR6mIgUsDNEBzK8RflmaK30SQEK3lwUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM5PR15MB1322.namprd15.prod.outlook.com (2603:10b6:3:b6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Fri, 2 Sep
 2022 05:55:31 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 05:55:31 +0000
Date:   Thu, 1 Sep 2022 22:55:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     YiFei Zhu <zhuyifei@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
Message-ID: <20220902055527.knlkzkrwnczpx6xh@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1662058674.git.zhuyifei@google.com>
 <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
X-ClientProxiedBy: SJ0PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::13) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c821dd77-5523-4e71-73e4-08da8ca7be5d
X-MS-TrafficTypeDiagnostic: DM5PR15MB1322:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFCD4YlhBsdhStdfwFjvmpWdepwvLVUD9FdTxccytwlz5Xs9Vyxn01MoGEa0rdPqR/o0yEP6FYfjgkZi0IQOAG0jkue/wHtVAeGRr5HMyKVg6WkR34pT28q9Yz7eh2+pPWIgX+jnS5gkH72pvkbtOBskQPzqWSgKyJ+0vkbgaoAtt/q2c0f82tZ+YAL9QGXYhC2iSOst9fOg6VJ6BlxfICW3Pfw7MFkYTdruu2hTorNqeLTjGKsq6vsnRXJic8lNuEdbjdFJ3GzErpewTVr0SulYmDXjDeGJXmgVd5CRn/MIo2B/oDWYTfydkcXeMFppi9hzKXc/8d8XpFo8DBeaCG4Dz2huoJ0qcwEswN6tp8X6ci76oaKQBMB2jgo+WAdz8aiUp9nXPlt3OjgO0Q3Snsq6WrYri29YoApDxoBbAKy+ULP18EkYH/TVxa1fIjgji3ok9Q5CXMCuhKBOVEy5BMAMDOXA19NUpTREiHge/7vxyD7Kz/gKnwei8YU7B6zkc8sqAqXCdBFKIFQ85bQXHcxQDXFkWL/GfQ0r0WYQhnXr4fLHa2qM3i2+X+6rDCFYnV6seUF5bbBA34ffEShgjhy2cKiyhHfEGJ/aIxY/zZS37ux4q3Lm0UVErSHTe50Vls+w6a0Q8NpzmtHWqwy/L9YG1Cb5/ZX5fOSX9xLoOiPeTkbV3VgblAbKG+C2SmZKtS7mGgxZs2OqWV3kcwRhzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(83380400001)(86362001)(1076003)(186003)(38100700002)(52116002)(4326008)(66476007)(8676002)(54906003)(66556008)(66946007)(5660300002)(316002)(7416002)(6916009)(41300700001)(8936002)(478600001)(6486002)(9686003)(6512007)(6666004)(2906002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yWoZqQxaGo3bHvhuy2YPwBWGi0l0yuXnuceWDxL8C2o4dcCRXQwIM5MYKQI4?=
 =?us-ascii?Q?vt9vChRybBSferIcpci58djzL35mX6YEgxANGnmjbLMpEXNWsxBbUkZW9T/c?=
 =?us-ascii?Q?7To5tzgFBqPCn9KNOgqgZoqHx1GLG7gyrVV1X1CwqsGoWCGPFWQNLlcgEj5Y?=
 =?us-ascii?Q?8ScrQU9yhMkN9/55FyG1qauAIPT0Ms11c5RKW1pR6PiI1h04zujk/OozwnMs?=
 =?us-ascii?Q?Z9iWUG9Oyhu6eT5dZHC1mGvSkYxjYbXjlUb87XgVg6LzadqU5ei/ILC4cyOr?=
 =?us-ascii?Q?hGpv4dGu0XK46Oh1+eho8Rcs+4/XB3h+7cXOlZvzDE3fBdLbvgEOefMHrtrP?=
 =?us-ascii?Q?Ru8zXkB06G7L3ngb84DpGlM7I2lQzQPBCAHA1kiVZm94Vrlt021KQ0oZ28qE?=
 =?us-ascii?Q?keccQHGFgRNQEGAsMpOlBjsfqcT0GhLmAOD+6AZJLk/TJ5WMTnlXbpvlCzLn?=
 =?us-ascii?Q?JG+eMC2oyID4JancV9deZW1ghCyM/3PbxnU9cMJIwhH2eApcQ9lINDuOccqs?=
 =?us-ascii?Q?Vdu5p0B/mXCaZOzIdOPOZ0fcbgo9mSW7LRVk/fSn6cH2Q3hoK7i9WHlFUscz?=
 =?us-ascii?Q?8oIrEsKtlbpJrT6JmLEMGIg3iAua4gK+sD5o/oAqN65dbTLdfIJ5HnEdUObj?=
 =?us-ascii?Q?w5ZjSQV+A+zE6feDimVOzZV0gPsozuXiI3v4a+ChdD9nuxu/ftlRReXgciJO?=
 =?us-ascii?Q?wGW7yYPFZ82yZq6gTBcYIJE2LsiAZxlI4v1BM/IqEEeKQX/2mrWvp8YdCrm8?=
 =?us-ascii?Q?O9zFzohPs8E+OzS0CxIFAq1ZQxZArogIHSfR2sKiHtf33oTkmlpwsV54EHbb?=
 =?us-ascii?Q?H6s2LE+3sorfw/t7lwTdZ5A23ui5brDK/ko7ni3xhF1Z9aQBSp+/AxEJBmHC?=
 =?us-ascii?Q?vDau0DQOP6V/KpoGG8vJEKPD2NMCeu77SofRXCzI7bM+X+Yg5HRUqF9Mftxk?=
 =?us-ascii?Q?PMk89JmIc2AtbhVBfBvyH/nLp51LgrM9/xSaj658OF7ZJy1loew7tuUPIglL?=
 =?us-ascii?Q?V8SSUYPXRezH9iQXPbacmUAxzOpPSP59sMfCLedBaWZNSbXvumt4Z34969FV?=
 =?us-ascii?Q?PchQ0ZAd1JoP31pRwJUQDeEcCLskezWnf868TYzKipG9dXkVuWCpOdlU/jHj?=
 =?us-ascii?Q?4Ppk1CPdkYDyaorn4odpQ+KWS5F7L1QBPc0+EjNwdiwLkv5y7FHeUlWIzSGc?=
 =?us-ascii?Q?EFTSuzqumosj9OkCmV48Qe04djaaaCFb7Q4sgbLxzgaWNsEQrwJpYTF8z9LL?=
 =?us-ascii?Q?IRgwmBp4EU44hPkxoAfjVTUwlbFwJJddT9ORf3Rjd4FTRK/T6qKdeH70j3qr?=
 =?us-ascii?Q?XBYtzjAszh04QD1QIDg53qDIeay9879sbJxVLwvNCmhc0vITBWLlNBzwsPMD?=
 =?us-ascii?Q?LP9PyAGlD6OzG/QMrVi9rh8iuhPoxbbfxoRjGd8dnd32UZLO++HtODYPckVk?=
 =?us-ascii?Q?nPpmDhLizepBLfWS3HOPB312ClWF8swIt3C8YEjRwiVPltTS7KyEkVsuL7uf?=
 =?us-ascii?Q?td8rQzLIIMWpyGfshBjeYbjWWhsbLMNtFCIKodn/KDN9XOHk7w/ucpyjZkm/?=
 =?us-ascii?Q?Gw9DH1fFb3putCtmZ/dFS0ilBm8eAlBGTQCvpg04pey8NRS6EDy0lScw2PzC?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c821dd77-5523-4e71-73e4-08da8ca7be5d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 05:55:30.9600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vG1s35b8Ntg4tHCOrd+NzlH6MJPj7HviwGEr9V+OuZJ+wvlG1QK64IFbAmkMZS8y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1322
X-Proofpoint-GUID: f0_aWGOfCJFgEA9uIaHT-_WOIJtAeB-f
X-Proofpoint-ORIG-GUID: f0_aWGOfCJFgEA9uIaHT-_WOIJtAeB-f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 07:15:10PM +0000, YiFei Zhu wrote:
> diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> new file mode 100644
> index 0000000000000..99b1a2f0c4921
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> @@ -0,0 +1,318 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/*
> + * Copyright 2022 Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +#include <sys/mount.h>
> +
> +#include <test_progs.h>
> +#include <cgroup_helpers.h>
> +#include <network_helpers.h>
> +
> +#include "connect_ping.skel.h"
> +
> +/* 2001:db8::1 */
> +#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
> +const struct in6_addr bindaddr_v6 = BINDADDR_V6;
static

> +
> +static bool write_sysctl(const char *sysctl, const char *value)
This has been copied >2 times now which probably shows it will
also be useful in the future.
Take this chance to move it to testing_helpers.{h,c}.

> +{
> +	int fd, err, len;
> +
> +	fd = open(sysctl, O_WRONLY);
> +	if (!ASSERT_GE(fd, 0, "open-sysctl"))
> +		return false;
> +
> +	len = strlen(value);
> +	err = write(fd, value, len);
> +	close(fd);
> +	if (!ASSERT_EQ(err, len, "write-sysctl"))
> +		return false;
> +
> +	return true;
> +}
> +
> +static void test_ipv4(int cgroup_fd)
> +{
> +	struct sockaddr_in sa = {
> +		.sin_family = AF_INET,
> +		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> +	};
> +	socklen_t sa_len = sizeof(sa);
> +	struct connect_ping *obj;
> +	int sock_fd;
> +
> +	sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
> +	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
> +		return;
> +
> +	obj = connect_ping__open_and_load();
> +	if (!ASSERT_OK_PTR(obj, "skel-load"))
> +		goto close_sock;
> +
> +	obj->bss->do_bind = 0;
> +
> +	/* Attach connect v4 and connect v6 progs, connect a v4 ping socket to
> +	 * localhost, assert that only v4 is called, and called exactly once,
> +	 * and that the socket's bound address is original loopback address.
> +	 */
> +	obj->links.connect_v4_prog =
> +		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
> +		goto close_bpf_object;
> +	obj->links.connect_v6_prog =
> +		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
> +		goto close_bpf_object;
Overall, it seems like a lot of dup code can be saved
between test_ipv4, test_ipv6, and their _bind() version.

eg. The skel setup can be done once and the bss variables can be reset
at the beginning of each test by memset(skel->bss, 0, sizeof(*skel->bss)).
The result checking part is essentially checking the expected bss values
and the getsockname result also.

btw, does it make sense to do it as a subtest in
connect_force_port.c or they are very different?
