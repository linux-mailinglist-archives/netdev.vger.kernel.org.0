Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9625322BE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 07:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiEXF5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 01:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiEXF5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 01:57:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897F93D1E4;
        Mon, 23 May 2022 22:57:25 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NKGo07007206;
        Mon, 23 May 2022 22:57:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hKRditzXi/fO5Z5PCUqvTydR1XuPQYs5eStym9ICnV4=;
 b=KeWecp/XeIlhL1+5/6zQIHYg9Zjz2W685KNvZvMKB5FRo2oonAUD1QtueCgzH204p6xO
 3NVdp0u2XeLWHLktWTlzHd+JPDX28+J9MHFtENWBDdyY8nXBXKAfHJUddlhJZYMOdolI
 YbeGpjh1/X5As+fjbxIPlhHfSkfZiMvLNkE= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g7g6d2x06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 22:57:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tr/fumUtO4ggcS05r2EitkFDHMEX1eH0rESiFZmkpWsE49+DPoyYoQ/pNWYfnbt9FPkA720D5QeoLVjuzl2H4XCgADtsUolKwWT+TKe8t+hW8oZxxHIRPHc3nTG4tEMLAvwf2XWLkije/m7GnFptQCHIXlPCgHmediz5rc+Phz/i11f99ox5FJLKL2rjxPUQZ71SDqoNsmNW903elfOKf/bAElmKIbhJggXldDhYPHpXtcZbOD56kzd5y6ur/NQrp7iT/0uc93vAbEHDfN03fZc1PaALHDuW1OKJtLAbJTNoxNxclSC61OmYidVi01E3LkjHt+3Ugnt+KUTA17olZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKRditzXi/fO5Z5PCUqvTydR1XuPQYs5eStym9ICnV4=;
 b=YhbiTqrkMU7Pa2S24nl2IlE7dZGJpCNgaLJxDbPUKNCyWmr+4FZzCrhnzvFByQ2n8ZU6ensMsxlieazQc4FHJGzp7n7IB1uB/brhzPb7a1HX7OIRJ7tLIbM4yverfTALlGeRRWpnnZAGmv7m6x1q5qTo6imaN63Y1zNTOPmb2yWKH748DrwapE4adzFaMgocimpCpPwANK200nAuqSdfDFB424j6Sm2Jg2g7p2gswzpg19WijuuArvvjXYnLsplXkFJFZ+LD2TECP/+dqc/abpGC6NNlczq5yZEAS8npvzXvS/7b3ChS8YFVc8lW3HcEyWQ+TDf5hKSNbHzYr3g2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4500.namprd15.prod.outlook.com (2603:10b6:806:19b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 05:57:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 05:57:09 +0000
Date:   Mon, 23 May 2022 22:57:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220524055706.7hhoep74sqap2ii5@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-4-sdf@google.com>
 <20220521005313.3q3w2ventgwrccrd@kafai-mbp>
 <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1f89722-abeb-48a5-0bab-08da3d4a3c78
X-MS-TrafficTypeDiagnostic: SA1PR15MB4500:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB45006531939CF5910FE451A6D5D79@SA1PR15MB4500.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkF/8wyuNDD+WqCowILzyoH8lEbadQw+tyY+taypGRznaozXLoA+DJmK2UuJcbsDvVDxYCfghxE25AnlNwew7+jQu2pkH+d8c1PMS2zkhNDtU8eSCVxZ1V06/Q8bsRV/DhOq5AJuyYOSHWcZDtehDK4Q5oJnIFrXtWPTLPC25DWijQ9WS+/9W6XoAjUxrQwwDbw6Fjx4OvfoeHWs1S4et8YK/cvX7p5/ld1qQSsLiawKGMLCTClkZmsP6asb/wWEev4r+2dwfi8eqVNZRBQSOQlG3pxcLiE9VkrGOZN+KlYjsZNZybLUtd1oYAwr8P3uALpTpDL0ryHDiC+E6zitn7z9pZ42ucszGfD73fs0ViKBW3IDdREKTRTU/64PZZRB7Jj6A7pzYVQGjKAzEvcWCo2Re7eyVN70lTELR8MTybvCLkHNJ8OwES+prdlLwIR3229hjPUDRintHLT0I8IPC7TucESTm7iR/GH8jWQawJaFXggQ/pTF9HD8l3mpo7Qxl2M0RjIJccroY5AwTJZeSBlIKTHTHANNXPhIhGnTPAhO80HhwwUe2IonoVZEPkJSYJQwaKC85IfTHDSJk1gwGca1mCcev/JfsuTx8JXaucP8GUCYadHoh4Q+YQ6R5hC9vFvJPHxGJoRhXJp0LMUoGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(66946007)(6486002)(4326008)(33716001)(6916009)(316002)(8936002)(508600001)(66556008)(2906002)(8676002)(5660300002)(4744005)(66476007)(6666004)(6506007)(6512007)(38100700002)(86362001)(9686003)(1076003)(186003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?emqRrbkVaozBBWsWHJukGs8iYZoPddues0rFZYb6297qxdXyFoKq5TzdvVqu?=
 =?us-ascii?Q?ZZKWk640YiOoQxYYZ1dTZvDGQ9MRZSoIY9niSyg7zWx5KoRL3YRJO2E/Fzc+?=
 =?us-ascii?Q?YTusrxPrsce+fmsYch/kKH68slPed9lVGpJNInLjU9nUgM+GGii/Zjb5k7HK?=
 =?us-ascii?Q?Qon7OXI9OOE9RS/0RTx23W5wG4G1MkVpaMUvhVcknwc9reo6ZHu9G59tKT8B?=
 =?us-ascii?Q?sfKFey+QQeWDIP2e535UcOB62aF6HeRrsRt5ik9XvUuzKg6Z5o2lrM64grTj?=
 =?us-ascii?Q?LTzpPNuwzs1YPWKSMPSUFf/kSvk6L1IGM2NICx9rkQTob7U7i+9kOfYIaQev?=
 =?us-ascii?Q?+aNu7J/IFCErsBhlQIw8RHyrj/KX/TMU5L7rJTpOQurCU4Y4PXI3SiHFybpe?=
 =?us-ascii?Q?4H2Y9spivRrwXu70ZT1mF2xm4zy8ROED0MP6tUCIXaLU+gX/oqqTLgm4gr9t?=
 =?us-ascii?Q?s0GeMSQKLGB+d4nTK3LIjzFni+At9vvEAJQh59+HLuB/9qEwzh8Sqt9MJWWw?=
 =?us-ascii?Q?s65nq5Oh/v5x1BZYQvr2Yz+OhdnXDzyHU+4HSAfKo0L7TPNdeuTncMzXsGo2?=
 =?us-ascii?Q?n9zjhDGo+xvYw2KzPu46Ma+FhMEVNwoEJUtQw8UeJWqRTo0lxsAp1bF8ckmh?=
 =?us-ascii?Q?kMZb+1CUMVqpgSjZ4XfTjpQM/RLfSRtyEAt0v30Emq5Y8AawoRbFmBSbxr4b?=
 =?us-ascii?Q?Cp20bZRoNgamyggEe/m1x/+Z6WIEBtKvgDnBxphK+RGLPCk0YsymoqVASZ1o?=
 =?us-ascii?Q?LDxy9lM/QVDfVocR3X7kP6XuX2kT4QGJda3IGxa4DJxB8cRLgfjG1utY6tpW?=
 =?us-ascii?Q?cR5u4/u7ZuTyrrkKVP2LbJMH1EvEKMx0v5tcc/dI0IKtINxEH5PVVAqrCScS?=
 =?us-ascii?Q?0xzN14Zjy+qRdbP+/uHOkX3+QV0w5oXQceDGgIuA/OPOcATcI/5gy/5dZzFg?=
 =?us-ascii?Q?3HQq9wvVNdkP8s3lMPw6F+SQyDAHcj3NslGRX68XqZ2sfQ8QO7nkP0ntOYA2?=
 =?us-ascii?Q?+EnrTpBuZjHN641QdZnqlR+LoRj5YeL//53nRBmUwQqH4Xgb4JxReWRtT/PK?=
 =?us-ascii?Q?RtF4CqyyHLR/J57MGT3QZFI0Yrviml48kKTkKJxZw3VkT9Sv/dgJYbrB6zFZ?=
 =?us-ascii?Q?/GVASZlqZyTJ/ztgpQiAV0a1lxI2V6Kettl8H6JxOuG2Q4J+nMjmNX1966+B?=
 =?us-ascii?Q?mu2SNGZv3aTEtLgzWXVKqZSVV0EY8e00PbykYpK6WhMw+xeO7Ya3PzzKWAgb?=
 =?us-ascii?Q?/UCprdXnu0WG9Bn9xcVS0AkuB2rf8AoLCT0MfHM9ZBy6CcwXNwnXuOdsgs5t?=
 =?us-ascii?Q?1I4tDGecMIgNUs+Xs8NjOElmCzm4rJwtra8eBaPj+4zz21qnlac5h550mguC?=
 =?us-ascii?Q?04Ochut6CcRhB1u3snk1lDNFSy36lz8PzL4hHy+BcEGW8cgBctflRLVJgP4O?=
 =?us-ascii?Q?J+zfPnyz8vwN8HSB/UgXsrmG4PeVqmZissb1zqUo0iAHZNZ1Y34fgb/Mwpoq?=
 =?us-ascii?Q?nyq16ULcmF3sGsUtuv19Kp/7TQecOoeaQUkv9qq1ytGlcdpP/dgoA1iZNhHj?=
 =?us-ascii?Q?NEymq/CB6luNmZMG3R3mdDqYlKyctk/wrjzH62pn8Egy6sUcPBZD3uOBKeBt?=
 =?us-ascii?Q?AAqhwOQWhfcXlEoUK1UweA62MUvBZNFxs2In9Gjj7rZLYXCVKPXXTpOOnZWI?=
 =?us-ascii?Q?Z5YihH09kwg8oPVOFqzW1dRRs5aZbM15GK/nzADEHj03LxNbtc23k2lOTa3n?=
 =?us-ascii?Q?zu6jh6Cz2PDxxGon9BaNCLQ6CAADHvs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f89722-abeb-48a5-0bab-08da3d4a3c78
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 05:57:09.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMD1eMnqE0K1eaNLIocXf7CpirCQb2BalW/kgPVRdnKTZUb/KlhmEa42nFcY/tKT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4500
X-Proofpoint-ORIG-GUID: W7WAt6UtbiWKiN2269XfFZVqpgrHFzwv
X-Proofpoint-GUID: W7WAt6UtbiWKiN2269XfFZVqpgrHFzwv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 07:15:03PM -0700, Stanislav Fomichev wrote:
> > > +             return;
> > > +
> > > +     WARN_ON_ONCE(__bpf_trampoline_unlink_prog(&shim_link->tramp_link, shim_link->tr));
> > > +     kfree(shim_link);
> > How about shim_link->tramp_link.link.prog, is the prog freed ?
> >
> > Considering the bpf_link_put() does bpf_prog_put(link->prog).
> > Is there a reason the bpf_link_put() not used and needs to
> > manage its own shim_link->refcnt here ?
> 
> Good catch, I've missed the bpf_prog_put(link->prog) part. Let me see
> if I can use the link's refcnt, it seems like I can define my own
> link->ops->dealloc to call __bpf_trampoline_unlink_prog and the rest
> will be taken care of.
From looking at bpf_link_free(), link->ops->release may be a better one
because the link->ops->release() will still need to use the shim_prog
(e.g. shim_prog->aux->cgroup_atype).
