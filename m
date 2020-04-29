Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18561BE432
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgD2QqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:46:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbgD2QqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:46:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TGYIqs025659;
        Wed, 29 Apr 2020 09:45:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=s4hjXIf4ijBjI7d0fnPkECXZ9AEXPhwEW7D2CPhgAfc=;
 b=GHdIcGQa6da/SdFzI7M5EGcWJFh9Zba9Q30Ffg/cQAi0epdxsrzYT1IfsTgPp7dYrRia
 MjXi3fwfkl0Es8yqltDEjAwTC1E9QYJ5hXCtkMYOAeRV8/NgTEn43S8lwy/AUfub0XGv
 24LYSVg1iu97kZdouWHHy6kLYt0NnWZb81U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30q6y0ta62-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 09:45:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 09:45:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ul/80fGkv5ipcNsrXlCUz588W4d7tIcJSLE22uLsqlJvdnF35uflEyPOpmU20WpeDiqHyjb9l6Kb6Z8NJhqsZ5Q1C2VDCWB0iMsZlg2R0vQjZxJ4RxpQYhrLBMZoGOdnFw23oYvaK4NTebuNde5WkIF5HPyzYV+aCkAn8SBaV5bD854cAPEOSwXdaeNhVf7hCS8fl9j3AzOTa+np8eDXAqgZ+qw30rC+2wyBVH6N0/hHUjAsiBoUHlbhuwYllVUdaECReh5NKmm17+u+3dy/YSHIW5n1oyGMfjZz7BLzuimfJx5dRkqoo18zHsrmrysV+jQfPoZbus17po4OdXYt9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4hjXIf4ijBjI7d0fnPkECXZ9AEXPhwEW7D2CPhgAfc=;
 b=W7iOtMMuBT7js8e4k74k//NggD+6RqXmfzEZtYmy7urG8nN3Y6sqbVX3cLewsuK9YYkSW8tWUK4m/YzTqX3y7LjEx09JHMIS4flFy9qsOzhzK6cQOCMp+3JxoXtHazzaOijNNJlo3FNG5+lQiCa2DhvShfmKyHSWV3QkQ8EAwtx8PVxPKvrp109Ou5a5w0K2XoKcSMF7cvSLUgvN6Ut3UEqx6MoUbNIiltXjINTwZNc3dbiYsq1SgqQOLE1yu0EzrGYdRHaLeCGlvvSOhFnYz0F8tdQ6puGpc24qpXRis4rg8+iIX5PupaO1x4nzIaQDGFcFpMHP+s63iasMRfpuBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4hjXIf4ijBjI7d0fnPkECXZ9AEXPhwEW7D2CPhgAfc=;
 b=k4xtiTLnA6FeKlcVKKWEK8c8cN5TvXt2r7X65PZmBLMhkb3MusxrgquZ7pteVJJRaTHZuz8J6FMeNbaRpxwduIC8uIQsEMSK3x+fFKPiNfONGMRnrL+MR5sdy2PIUbBdbhzMAIRKb2Sm3qMtraz15E1L9WaaokDlbMBLdsRtN0s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3753.namprd15.prod.outlook.com (2603:10b6:303:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 29 Apr
 2020 16:45:53 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 16:45:53 +0000
Date:   Wed, 29 Apr 2020 09:45:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] bpf: bpf_{g,s}etsockopt for struct bpf_sock
Message-ID: <20200429164550.xmlklvypzlcjagvw@kafai-mbp>
References: <20200428185719.46815-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428185719.46815-1-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR07CA0051.namprd07.prod.outlook.com (2603:10b6:100::19)
 To MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fdec) by CO2PR07CA0051.namprd07.prod.outlook.com (2603:10b6:100::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 16:45:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:fdec]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4eafcdaa-4b90-4aac-3a15-08d7ec5cc7cb
X-MS-TrafficTypeDiagnostic: MW3PR15MB3753:
X-Microsoft-Antispam-PRVS: <MW3PR15MB375376E27BECB5BE66D38666D5AD0@MW3PR15MB3753.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:142;
X-Forefront-PRVS: 03883BD916
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obveUSN88CxKNmTiEwckYgXrVMi5xR165l2XvfpmrKUClUAJx2fwDo9yeHHgeQLlYsYM/xRAIBOTw4wY+OE+ykmyWgily417+pJtBaXyyEsnrRbJ/JbmBvrL8Cdh55k9/GWAvGpmHeAet1qtzuemEh4sz8wxwaQRm8z4ntgDwR4rrZityKQBIYzys8u0vYN31EEqr2ezM/3bvYvSkDqm7AhpIsNwHjGHXXQ1Urbc+i0OlgDuhpu0L61UdLcvZ8Hl2cloRsrmxR8IcNtHbE3NUEq7tZDir/PvwopyQYkoCr9L7/meDt/RA0teDYwdMFzaBk59th8P92AXiXJPo89AKdc3BeY1k4tHDPVhHn+bd8gG3KC/RF7JoK0Ma6MJZono5cO8PiSHrlpP8KWvbWz6bi+0FcWUVthSGZNHyqF91mPVEZHJ7rVislFO92Vt3jCD8nuBj0VJry6yXZMtU+DOUGcG+PucNTDkimT5q1jKeJIMZMhsl0KnM2ZUyF+TkVSB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(376002)(136003)(346002)(396003)(9686003)(66946007)(55016002)(16526019)(186003)(66476007)(66556008)(6916009)(4326008)(6496006)(52116002)(316002)(1076003)(33716001)(478600001)(3716004)(86362001)(2906002)(8936002)(8676002)(5660300002)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yAq+b+nsZap0p38kzPUvQWUHdveIW72JOCbbphSJGkSqJurlxTb3n9dlMD3MfS2ugBmc5rlx/tR+benWTQWppNip1RuqCXIImHR58Hq+bceSyiK5AWKT3VS6KVpZGQ1c9yRe7LVkgvB38xeL7EtQu1ebfxY5MfmA6veWgLsEmB8n5+8SDOgIHGXRKVYViuJ/04OurGhvgE24ZlhJ90xkN931UQtzhU/uPTe78TEfs2bcGIWjCBxEy+ZIXfy9BTgeCmso8jFxkwg6hLyX7uYjOXSG9I/kYtFAS8qBsx2SxAXKimt3B6r+4RqkM1LZ7hqenE9TZW3A8UkOVsjP22ILcJ/Id6HKMHzN++1FJo6Q8gGQgsjUCDYcycPBA2yEpIbgKjcSCrOuOO5710gsbqG5X34dMAMUo+kvtDoNJPfGguJLy8KG73qjg3RUsKjF+4dT13J6IufVF9X3iYVAtnU3qGSeNgR0j3D37zNy2t8S3MNg8ObUp7RPQAedNi65xppItCCP0YxE9vOVXitVD2An3OfZrZ8UHhtd1o7wAgwa/BEZ1ZeMv1whsv0pMPtPYzcEsCQvQOXjZ7NBDEEWtmlCTjCTqgNMQDg0CziN9zoUHLFOS84yuBhoPzThBhyB+5Bu9ZQChPaiUKvzWUdNDF5l+cZIysmCpKsCLCp+mbI5zf5MEyp3tksEN+NZ8hj0cLz9Cl7+zRX1p/PWkHDAZ0OyLIUDpI2RSfV5rsuB0Iot1Juy7xrAZ5Wih6NBWirpc4132IBX7eF6xejyx9jX//hXRPlCH1h8xDAovOmikIOCmAvgYrH2y3JTbQ9xQRI2BS/iR5fDAjLAV42UjOcw1cTOeA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eafcdaa-4b90-4aac-3a15-08d7ec5cc7cb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 16:45:53.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3nlXEWkKboqM22nu3S3gRIOdnB1kEUGOLRD/HQ6bqUO0BPELg13bBZcL8s66dIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3753
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_08:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=922 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:57:19AM -0700, Stanislav Fomichev wrote:
> Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_CGROUP_SOCKOPT program.
> Let's generalize them and make the first argument be 'struct bpf_sock'.
> That way, in the future, we can allow those helpers in more places.
s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/

Same for the other uses in the commit message and also
the document comment in the uapi (and tools) bpf.h.

Others LGTM.

> 
> BPF_PROG_TYPE_CGROUP_SOCKOPT still has the existing helpers that operate
> on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> we can enable them both and teach verifier to pick the right one
> based on the context (bpf_sock_ops vs bpf_sock).]
> 
> As an example, let's allow those 'struct bpf_sock' based helpers to
> be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> we can override CC before the connection is made.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
