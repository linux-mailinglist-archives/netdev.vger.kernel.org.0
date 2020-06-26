Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9038120AA2E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 03:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFZBis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 21:38:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727781AbgFZBir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 21:38:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05Q1cj1R030204;
        Thu, 25 Jun 2020 18:38:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Vybb1l2L69sNjn+C+62QxDNNI6j2Cb2pvdI2hAYMIz8=;
 b=RmOIC61aIDwIaMchJ/Y5a1vFfZxUxfC0r75CrTABFo2BiMXegwyH1QHAym5nEFKcKWLA
 Yf7VU9ElTZEFp/Sv0u5HJFr7pmLvPnJNzDlxA9NaP7MYrZsr/o0LmR5UJexo9bYlTnqt
 fRkCMDO6vKdnFvyRcUbPJvF17cHKEYkF/7A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31ux1gk5ar-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 18:38:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 18:38:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChtWpBdaim7qQj6rSmzGYsF3m9MJy+iSr+Smx3gwHqxFhVaHQ+0C/v9RKsAaXgkV0dePYkBRvPQnUtX2AUBuHbQJWlxRW2nVIOfuu7uVJvdr9e8t4iML364xmcnnMWZj1hjlEsxQdU/1A+55FWp99ymtvYIOQyw4G0lwH5fRBQol/pEcjrVpg6sxXjOC8gJ/S1KldTCRxFm6rP8FbyeGFpDpaRvGh5LbJb67HYPz+6RyYfG8JfR7L9dW4ur/pQtBHOwYYFf3rVU0I6layD4oy6OotSZFG0FQCtIgyiqHtqgGSA+cmQ3wIXnRctdw6cUgOEcgRP9KrclVEgyMwGLKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vybb1l2L69sNjn+C+62QxDNNI6j2Cb2pvdI2hAYMIz8=;
 b=hZOVJ5PN/+vj25OgXBfCqvkorYJiHxFWoN9u03dXLmMB3hlbNwN4E8fUqYqnBYEizOfDf+r7IGTfxZ6ND2SbRz1LLwxzUCCwTqyIA5t5uhoR1G8PX2gc5+qdwRq58VbTdR5urEzuQAV9cI/ue1jgwjDhZSUeujkEGkC5ZgQgmVvT4ec8W1lV1bd7iiIwvxwD8SzrEomKJcN4ND5/xof9oQvfbfibOo1M3Kr4r/3aVwlCGVM9Gckwe4LP9ohy/h78hqV8iNzgFGP48Vb/aOycMZJjkns+QgYLFVeRfEwkRYdpzeA4SPPa993xDYYNIJx4t7ppEiI5UzhKz63E9aX7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vybb1l2L69sNjn+C+62QxDNNI6j2Cb2pvdI2hAYMIz8=;
 b=VRx4mMCrh1mNJvgrM0/j8/9brF6Meb4yMyBc9bjHJUfe/wO/gqO9nZA0tgYppguJ2ew0MHLYEKG1fwg+5LchAc3R60OJqaeatcuMO6jjIMrTfCRpBZPUInvDJcSF+am+L8X5nT98PuQEas/eiTlXA08KbFQRMrmVI9uvNJunoKc=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM5PR15MB1321.namprd15.prod.outlook.com (2603:10b6:3:b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Fri, 26 Jun
 2020 01:38:04 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 01:38:04 +0000
Date:   Thu, 25 Jun 2020 18:38:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] flow_dissector: Pull BPF program
 assignment up to bpf-netns
Message-ID: <20200626013801.2246uk4zh35ihbos@kafai-mbp.dhcp.thefacebook.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
 <20200625141357.910330-2-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625141357.910330-2-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::20) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:62ad) by BYAPR05CA0079.namprd05.prod.outlook.com (2603:10b6:a03:e0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Fri, 26 Jun 2020 01:38:03 +0000
X-Originating-IP: [2620:10d:c090:400::5:62ad]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9ba6c36-37a8-4f44-93d3-08d8197191b8
X-MS-TrafficTypeDiagnostic: DM5PR15MB1321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB1321EBF3ECB445724A0B8E45D5930@DM5PR15MB1321.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvEXmhRk9JEquFXCbGaSu8Uy6ASQqQkiPNDe4F1G1Cnpl7Dv4HMFxPIN63RBrBzS6NtcRtR4doXJvDA0mfTLmvORjRSl21wivMF7g5IMz/zdxLF2OEJnuO9ELoAATGjUFkhhX1Ot6AWMgg3UmIPT7WD+6gAYEhkWOT6C5Ge31tFFGS8XvI9TqUHkjYYzMYsVQdLkqI+OEJQqZiiiFrdPkGwzAS+9JOahC4/Js4h6eqrzszOSlCchnjgOoOmB+dQzCJtE6F0Lhdqo6VHRaQbcillDfgwFgCgcrdBN/UlMI5iZRqoR1oY2AIoQH7YIoDMndFaS2PRKDOPtVH8u4s9C5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(316002)(6506007)(66476007)(66556008)(52116002)(66946007)(6916009)(16526019)(186003)(7696005)(8676002)(9686003)(4744005)(86362001)(4326008)(2906002)(83380400001)(1076003)(55016002)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LcnpHaK5xlNVkzLed8heMMNLJTlVj6bQaHxrVFjiUbCXQryxNnexPAKx76mN5D9FHDx9AEjs8bY9zEx/iFvp2YcEbxRL4ktAy5W2aiLpLLP+TGeV0gNONU51s6ghRf8Mhg5dR1c7bX+9issU+BxRkYxfkbK6ky4KggJUzQyln62k8MlPS4VT3avmVIxIyBAkn00u/jY74ax7N/JZlthOEWU9M/OVSdQD+MZpHnesfK+px9CAp+95HVgRxGYI33jxeBNPlAD9TO/qoggONMDcGd5K1CkVOkfRXeHaooXcjmS6ihMc7ZPEeYmMPiSFOXraaEFax4j+3rZQeftyhlaKu89pWniDfo/10UBcgwxDmNpOsP/cbWjq3FjSPk1KRispszsiQrRjwhQbw+jo3Ag4Os5oc7WQ1miAhZI5W4ue684UwCXRclTJg5zrvwVdQHLjp8rS1Jo83RJ86izxfA2+TIMSxgTnfqr/Y4Zr0Oj8ORaWJdRaEuQl5eArag1Ea9quiLgUYDgeaC2bOBq33ynF2A==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ba6c36-37a8-4f44-93d3-08d8197191b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 01:38:04.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1P1+AoyxDao8Pl4Z6f1X4VixlwB047brJZw7ZazTKYOoAZqGr++x4Gu4qJjJzyhN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1321
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_20:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=830 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:54PM +0200, Jakub Sitnicki wrote:
> Prepare for using bpf_prog_array to store attached programs by moving out
> code that updates the attached program out of flow dissector.
> 
> Managing bpf_prog_array is more involved than updating a single bpf_prog
> pointer. This will let us do it all from one place, bpf/net_namespace.c, in
> the subsequent patch.
> 
> No functional change intended.
Acked-by: Martin KaFai Lau <kafai@fb.com>
