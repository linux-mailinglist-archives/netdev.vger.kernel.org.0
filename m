Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624D04D0DD2
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbiCHCGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 21:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiCHCGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:06:07 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5414D387BB;
        Mon,  7 Mar 2022 18:05:12 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 227IXSwD025055;
        Mon, 7 Mar 2022 18:04:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=7yNh6rayjZmL6BaC5pvlMdpj6HXWH5SknH4vxL28B7U=;
 b=Z4pPT4shGT+cRHSxFVxVbWb/iaBNOV1HC2jZTJssxF7UwSX7DD7jYmBsOAPN8itCiGx5
 BEQ7lfcvYWrqdpZQ+LpuMsmZ92Xh+Lv0jChAI+YivJqxsGPT0F/GYB3etneYDbdlFZLS
 0u32bxDMLzVDdPam0Zk6y6YKLWbYra5mxTc= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by m0001303.ppops.net (PPS) with ESMTPS id 3emrxr3brm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 18:04:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fgrt6W8RnV2PqaUVnI1/LuKA4T4Pf2Q+07knQm0dbJ0LbJFkzk9dq4JeaRgMbgNhjToXNAL9FcYhylWsWrXttItkndf7CoNbReXef9OZHX70GWqYzZQgtzfteE9Af7mSkrbbPAPXibsn45wsEM09X8shU0bgndO3gO7LnfQCKTWDWRR85Kc6KGMVwsNmnHZHGRLrBK/B63iaEWmOxrjellPsnDMiqlt3Pk2piiVU6iIwwcuVG7gsg3GADMwPMDenJS3w2BfoOkSGhcDBBwjlVSxWzyDhjhEuAnG/xFwkmtE1MAzFSDtMXUeA+xObgTvZBoTBvzADbIuIDbfwVTNBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAmE6Gk+IpMA2THoCb+hiad41PvcVPG74BsdTvq14sA=;
 b=h60ss99eIfvjGswwxeojgIP836cwMalki3IhXkBZ851/nesnjDtwpW5JqvuwD3BYVkCtL/Jp7yHT8Bj88xqtitZlMVAudtbNwrIZBPt+/EKT9BJUqqsGJfeiVdkgka9TTJFaozfl4kai14yTWsmRGhIX1bqGR0IEuds6mHY8SfjVHpcOoj4lakUQnhg/EpO5B4VYmB7+eOnbxXnoEO/EC4n8PpH/ErluH+0RdTXs4XCjE0u7l7jJXPX2dsSySZo3tw3HhlF81Len57HpOdhWV5d+xdJ3HFVCx97iUfYd/sPp2pkuyAybKH9oIAdgZ8M5e8XMYQ9VuH0BxsdvvP/pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB5130.namprd15.prod.outlook.com (2603:10b6:a03:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Tue, 8 Mar
 2022 02:04:53 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:04:53 +0000
Date:   Mon, 7 Mar 2022 18:04:49 -0800
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Add "live packet" mode for XDP in
 BPF_PROG_RUN
Message-ID: <20220308020449.eyxoq4s5ddurcqxv@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-2-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220306223404.60170-2-toke@redhat.com>
X-ClientProxiedBy: MW4PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:303:87::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f68b723-1e0b-4186-8781-08da00a808f4
X-MS-TrafficTypeDiagnostic: SJ0PR15MB5130:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB5130833FC6CB2A44167F1D65D5099@SJ0PR15MB5130.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LAh5Z7UF4sewQuN7wi7pcqHe3Pz7/vx+5p2olhnmi4M/lBNDlTAvQcZ4IOGRkBn2i/KHNebh4UnIntaRTcKKWQ8UHFJsH0UnK4OMQvQLMsgueZNHm4uV4DK+rqdxBZSEVFErLYEwNgFD/BqEmeQS6xbiE7Ni4KV5g+EDvQfuHFUFNlPzil4WVb1LGrDpquacW6dOJcPfSJUn7VXWE49K9kVfz6T6oEkerDXryJEogU2i8Y294usVgoBtz6Ak4jBnIjia1ECFjTqXE2EcBZTBD43BSxVq6RZFjSfpb2v//MU6Q/inqfRmw/h0DuHf/3Annx8efLf22H9s+ZES3QZOi45h8N/BVm/Nr1Zu7ltYvCDuFCSfh5sIJxFnHID01O4Cj2lBLi4HfMOi+sHqRwjYRcK7U01rSyhee2wsDThzetjyszp3DSuM9pl/eBrbv32l09vCN5GCIoaOjm+RsiMZg2ObK9vxfK1dUIU7taIr7FXJjacNTmJ+qgVvdTXVdNvQxtPJCfiS6S98aBUich2aBmhLIHxZPHOj8OcPkgfN/ddgWrgdgEOWyHMTZqrvRwZNJ2xzBmfkkVNqRWg4pVbZTANeyzZzZgVjQi+KebQEIO40Wq80PGbdpqVdYr48kyTq5LPP5JaVmNk6qOgf7jCSFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(66556008)(6512007)(9686003)(6506007)(4744005)(52116002)(38100700002)(66476007)(66946007)(8936002)(8676002)(6916009)(54906003)(316002)(6486002)(7416002)(508600001)(4326008)(5660300002)(186003)(1076003)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?bz5g3yYG7pCHELs+LVvmiFNam3a4DQQL+49A78nFuYVOWvRxK8V46W8r5o?=
 =?iso-8859-1?Q?gK46C9BOlB8yVqM7PBy3n+9pJ1Ex96g+fRtsJ4hdQwmneYaQyELNADMDxH?=
 =?iso-8859-1?Q?Zsjb+AKluSZULe0U5MM+y0Sl2Rm7uBivSHPDC6X6UR9/gaaLYenEHjeWdx?=
 =?iso-8859-1?Q?iq1H9DKYDCQyQYmb9yqf8LSStoUo/y6pVQugAImrWooYlvISX+Cufiscau?=
 =?iso-8859-1?Q?F0AYgZYXiqAWjOvflcLcax4dYeH+zO715LFQlG8eWPwlrw9eiEDmAuyDc3?=
 =?iso-8859-1?Q?4yetnuJHmtWQWMJ3d9ZNyrmJ63lz8M3xGiFjI4H/dp5Bn2/iosieBm0+sa?=
 =?iso-8859-1?Q?C5pTepCQdKBeoW1y6FD1Ztq2sI5HTTbOTeeXQKX2h1lnRo8FkXyZuwZbZW?=
 =?iso-8859-1?Q?YWp6yzok9+US4UncGfLlXD0U9DBpzYQsokexmIieLFY5jcv/DeISMObc6m?=
 =?iso-8859-1?Q?m1TOTI/Dfg6N4yQW30+tVuut3fpqCFXlqentEHr1z2D2+S6GeuM/xwg3fT?=
 =?iso-8859-1?Q?0gSQrovpRvDz4QKK0fvH2DZaxs9oNIJU0qdzJ61XslHdrp8DBYZl19w/03?=
 =?iso-8859-1?Q?lcB/fyyDtdNEuphYafdqgs44votdd4H3MWmbDvE1xQt7iMP69NdllN0aDi?=
 =?iso-8859-1?Q?bVqXoJ28o7x5Mg+qZ6xAwEJNz9zVdNXpFhq7fijogqep/6Tfh1/3oBIvpW?=
 =?iso-8859-1?Q?+QsNRSnNnQq0f3PF/qKNekJSdYe0W+kDGe2mR9P43LHKuug1y5S3FaY0Az?=
 =?iso-8859-1?Q?JE7prbFDxiLnSQII+EQCC3J48s2hInt4eSYpVUBaYimG2CZmQanQox1tFL?=
 =?iso-8859-1?Q?7/kHhmyKCm+Nzfoi8gjysnA6uKVeVh/M8hO3ziFAU4p1qhNzYUjGgvMl3U?=
 =?iso-8859-1?Q?wYCivwfG2+BHB6rq+Zj2w+dVyF/rkv5JI068TlyJpbiOYOaNlzUX5hzYT4?=
 =?iso-8859-1?Q?KYu6cmit24N62Xv9G1aNN6lhN4JOpxPJOu6tuJ+UDnOHQb1REYGY1GHfLG?=
 =?iso-8859-1?Q?UyjsGDu49Xolz4/ND9/dsUI/16WIGW/SiqfJmsyFNFVg7P7cipnOr7Vwso?=
 =?iso-8859-1?Q?+59Q4ZWK4ImZBZxWRPhNuP740oXTWBeGv1Mpf5pvQvXVbltYVHN+khUUbR?=
 =?iso-8859-1?Q?BA2rGwbEE/wH8hNqjUYRTnEaEpFJ+H6gXixVBnooCSYF4OjMq0zD/orblW?=
 =?iso-8859-1?Q?bDk5wJJKkwg6CRletQpARnMR5porDt6ZuTaf7EXbVg0zE2HA+PfdAH3C9r?=
 =?iso-8859-1?Q?FrQNpTXiqrYp8zpOvXiBPJqz59Ehbr6rHnj7qpuinfY6n4rzsvc52yCFrO?=
 =?iso-8859-1?Q?fmYbQHeYcBdZ/gmWPApQ3mu8tZjFGGWkyCLE3AjLp1Owalzr7l6pcw7QRC?=
 =?iso-8859-1?Q?SqEjLyfMcKEZXS+/kIuDd47XdTZFFSZydTOO6ZadKZz1EDATDlIi4X9n9F?=
 =?iso-8859-1?Q?IfMoreTOLlGYVSSL1qPJJMVWaNJsCrLEC+3N8a3xJUUdMlR/wr6q4AmdGE?=
 =?iso-8859-1?Q?mFSVUskDgv3pXCpX7S72yS45ZGefDK+BUyv2kaYFXy9Lrfbk8YuPCBUzyX?=
 =?iso-8859-1?Q?beQTfI/S70I7E1Ff/oCavNP6BDdMcXgzGBNtAzXWo8JxcUP1bV5LkewRY7?=
 =?iso-8859-1?Q?vU5Y/DVXNryCF29zzm2eowWsOawlq+KeL30WFR5JaiCSB6nzXNAe+h4g?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f68b723-1e0b-4186-8781-08da00a808f4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:04:53.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85ThDj4tQA3ZXCDyac3b8y3jL1DXM6VH3+Zt0TnWYVMU//YGNnDhUP4wDopHaV6J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5130
X-Proofpoint-ORIG-GUID: Fhu42CDpQcvxeqc2j2Ngx8-WxPstmQ1K
X-Proofpoint-GUID: Fhu42CDpQcvxeqc2j2Ngx8-WxPstmQ1K
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

On Sun, Mar 06, 2022 at 11:34:00PM +0100, Toke Høiland-Jørgensen wrote:
> @@ -938,6 +1222,18 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	    prog->expected_attach_type == BPF_XDP_CPUMAP)
>  		return -EINVAL;
>  
> +	if (kattr->test.flags & ~BPF_F_TEST_XDP_LIVE_FRAMES)
> +		return -EINVAL;
> +
> +	if (do_live) {
> +		if (!batch_size)
> +			batch_size = NAPI_POLL_WEIGHT;
> +		else if (batch_size > TEST_XDP_MAX_BATCH)
> +			return -E2BIG;
> +	} else if (batch_size) {
Other bpf_prog_test_run_*() also needs to check for non zero test.batch_size.

> +		return -EINVAL;
> +	}
> +
