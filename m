Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382931A422B
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 07:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgDJFDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 01:03:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgDJFDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 01:03:53 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A50JrB018839;
        Thu, 9 Apr 2020 22:03:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=emktKNNjIv+OqaMjhQ6/mHKJD0URZ9wAgrfpYDINFHE=;
 b=YOY3tgXsBZa1g6DOCuEbGgHNUqEaoBXM9FJy2ARcV4a3KSy1s7za7znu4Yzvv+7bUpn5
 tF2+uCaSdhaVW4NR3DmYZ1uf5H+qYvFxDF//AAvUyZP67oj5e5zog2zcjHXdqvF6sFrT
 lepHOgqlKWB42XTUKvNeigBV+2JjMHW/160= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30afb80n0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 22:03:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 22:03:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idvu/VFtEP1EvrgI/pBgr+F4pzRx1/wzrzqpAjpo0bQFGmso3lUhSA37sFVlkZGdj/vVV1zQge+I5iZQt8i7zWSFrwJV9MFjpPiulGeG0VO2OiN3MydhMUdmTaQHEoCn2dXKZiLeTmBBWkxk4g7DW+yxnECDmx+Ph1RE4nuvBZlnG4Rco1LLma/sTBYUQTDnFVjqA59RSh22mS4ma+1R3tZn1fpKDov74KwWPRk07ULD+B7mP54Kps37uY9UF30dXIG35CN4Utl0J4bXAKQ2hfNINfqETQsJpff70Z3U3rah9vpzTevRHuOa6xbrnX/l8gC2OxywO6ScYmzJvknVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emktKNNjIv+OqaMjhQ6/mHKJD0URZ9wAgrfpYDINFHE=;
 b=lurWZ0Uz84ADG+CZA5h8inK5LWzqO4Z3bgGC1suc7TJAZE8iXbwjXkcVn6obgFtXz0q6KrolADwvi9A94V3sj6a9tc3PP81zEv4JBus2mqpK60VrjRaM01bkZrE4vGUYbIew5vhVrT0hF4Gqb+i+C63APUcTRIKkvUaktFFbbMUcjb9/cUZFlvZPcXQU53M4Xvk+8Tyv2o1kVEE/UAssI1LLNYbqKzw9LiQ7k7Wl4gMcLPMMFu8sqCrxl9s5R3fvD9VXlX0KrkjFVf49CUfS3JNlP0dqJjherNoZh7bwkzGn8PF2TPodMmZisaugqPAd/Jqt4ZRELiQ5oxzMzj2xOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emktKNNjIv+OqaMjhQ6/mHKJD0URZ9wAgrfpYDINFHE=;
 b=RK8b9xwDEiCGxhagFtWRB4ZD1Gw/CPMnH+GV79nPc3qbyv1Bfpb3C3ru2FXLEYiZQ/BRkTDbpfyzEcpM2n9388cBrRKjpi9KZhQKWMK5I/QT2vzjuoNDqC/tZP0KbEQ3jLVzBeR+pRf5VQPa1NRrUnkpgs4bEEhBrxmJ0piQObk=
Received: from BLAPR15MB4035.namprd15.prod.outlook.com (2603:10b6:208:27b::8)
 by BLAPR15MB3777.namprd15.prod.outlook.com (2603:10b6:208:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Fri, 10 Apr
 2020 05:03:37 +0000
Received: from BLAPR15MB4035.namprd15.prod.outlook.com
 ([fe80::1005:cae:8f47:227c]) by BLAPR15MB4035.namprd15.prod.outlook.com
 ([fe80::1005:cae:8f47:227c%7]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 05:03:37 +0000
Date:   Thu, 9 Apr 2020 22:03:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] tools: bpftool: fix struct_ops command invalid pointer
 free
Message-ID: <20200410050333.qshidymodw3oyn6k@kafai-mbp>
References: <20200410020612.2930667-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410020612.2930667-1-danieltimlee@gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR19CA0067.namprd19.prod.outlook.com
 (2603:10b6:300:94::29) To BLAPR15MB4035.namprd15.prod.outlook.com
 (2603:10b6:208:27b::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:16cb) by MWHPR19CA0067.namprd19.prod.outlook.com (2603:10b6:300:94::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Fri, 10 Apr 2020 05:03:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:16cb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fec2657-cbc0-47b6-a63c-08d7dd0c86ee
X-MS-TrafficTypeDiagnostic: BLAPR15MB3777:
X-Microsoft-Antispam-PRVS: <BLAPR15MB3777E4D1641110982FD97EACD5DE0@BLAPR15MB3777.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB4035.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(39860400002)(376002)(136003)(396003)(366004)(5660300002)(66946007)(52116002)(86362001)(316002)(6496006)(54906003)(66476007)(6916009)(478600001)(66556008)(8936002)(8676002)(1076003)(33716001)(4326008)(186003)(4744005)(55016002)(81156014)(16526019)(9686003)(6666004)(2906002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSk/2zw3csM8IU1gEB4a0AKIS0naUiyr2DMFpwl6Vj5m5xUwWl90uC1kiCLymMSIJdijCbcPIJHNzC1M64R1naTCCkJHwcruZXQpA9anX4CifLuQySzyu3YjIfjhyaF6x/fDlY6j9a7NVDz6Pd/EufJOFAMYmRYOw0LLtoX4uMvBhLanJqPESrE034SPYGQcMNzsA0SA4+Mw1kzHvkrF6M+2Snxtp4hn6x5nU0y8ZfrafYYyLmY8WcFxs9c9sJla1NTJJRJnfaqgxGIbp8+BESTtwEFh/ui5HSvt7qRD9gTLtwix0p/BZB1Rdy2Ex4/A8HOkInJWd0yA+FwjjnjcjIlRT1Hu0s8dFRx/ITp5Hbkt/ZFE9xApGTM6zAlVGIRM5c3SawhjgycW88fwJ+KBjjKf5Iso6+AjE4UnMcADS6YKUq7ci5jk7ksgpNhcX6+B
X-MS-Exchange-AntiSpam-MessageData: CgHOVB2AfHrkWowG8yFEHJ9Dg7Je/0PhglomPrSGlI4IfNcqinzM+Unj0OUi7l34hlOhp0t0BTqgJHFEZOvwEfW96yQ29Fp9xBC33UxVAh1YU/o1kmLMT7+HWAVQwmM/RN4d4RHxpZX3rt/1wbLX9tdS0H405jig1fIyHoJcvrrNRHS6fADhg/MZyy4aOKA6
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fec2657-cbc0-47b6-a63c-08d7dd0c86ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 05:03:37.4445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lH9GHOx/0CcZVzOOW1hipBPhpvdxXZcZzokm1vqksZW94dmpl6DnNoGQsg1LyrOw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3777
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_01:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 suspectscore=2 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=877
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 11:06:12AM +0900, Daniel T. Lee wrote:
> From commit 65c93628599d ("bpftool: Add struct_ops support"),
> a new type of command struct_ops has been added.
> 
> This command requires kernel CONFIG_DEBUG_INFO_BTF=y, and for retrieving
> btf info, get_btf_vmlinux() is used.
> 
> When running this command on kernel without BTF debug info, this will
> lead to 'btf_vmlinux' variable contains invalid(error) pointer. And by
> this, btf_free() causes a segfault when executing 'bpftool struct_ops'.
> 
> This commit adds pointer validation with IS_ERR not to free invalid
> pointer, and this will fix the segfault issue.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Fixes: 65c93628599d ("bpftool: Add struct_ops support")
Acked-by: Martin KaFai Lau

Thanks for the fix!  Please add the Fixes tag in the future.
