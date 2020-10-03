Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF20428218A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJCFRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:17:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgJCFRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:17:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0935G1oJ023115;
        Fri, 2 Oct 2020 22:17:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3iTZHp51IQC3XcXDMOrVBlkhSNOA46dws46uYAAVmoI=;
 b=p4dcLuE1gDRzY3jtgbs8mTQhtShnYAYko3c/5vGoVZR+dZrnGrIozh8GndKyvhMOAYZf
 kevB2mpQ6AbKmfadTperdX3PGdV5u5S5dRS3jBKXkh5Ba22xiHIK1Od5hJD4VBZRAMuG
 bc989UHc1UrJUmTFZCspA/ipghvci1DIPmA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33w05ne3sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 22:17:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 22:17:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjN7NcXOnV878dxFM4lOczg7FZgy2LcnA5weMzR/Gv48StnV0+d4iTkN/hWhviFpT34MBp/sLjjGJeFb9PUNHacx6IuoJNSnn9jHDTOfVhUyFnctvIc/8W4L5W436rDlJ3UKlCjbqE8J2xlElXwTqLhkHHZSqUvI/PHJSfkO88/BqjlwFrUZqJ5DkRQ/E0QjUy2q6cNaYvPNxvddZU26sJoJ50NJ2OWP87lSE85qZTDCpF0hxtNfXDd9DoTtFgXU7kG0zLgd2ENfqfelNocBdJIiYpu8UklQido4SACL7Jla04mkEMV33rk1XVD/F61Lfiok1bFHFyJoNlUz9aE44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iTZHp51IQC3XcXDMOrVBlkhSNOA46dws46uYAAVmoI=;
 b=bifPYbZ2ZOvU8uX7Ovg10wrTXI1kpW+TAEr8NkD0Tw+/gXDN5Frl8whyJZgMUO/zzYdLGf9ZgJzE5jbJ5VTF7ewOdu6Dym9JJOte4zMdPvqqrc09ck5Qfs+heXP9dwAUieTSK/8MSSP3qBjVymuNTahQLKbgmMhM0dzc0AKRdMJCGeHYzRFnY+olzcM8OEzfa1IHB+U2gDLvA+ByGjUkpVoWtp10g4dbRdECwoLrh/sDawcKUOSVQig3/D0KFgA3KNWwW2fGjbuMX0I1/D1dn5UVPk9DOMjqzrFyEcqXHWRTKJikvJnhwu4Z6UeN7AY5e+ZS3WYq/C1+JO2+I4oFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iTZHp51IQC3XcXDMOrVBlkhSNOA46dws46uYAAVmoI=;
 b=Y4+p9nQmRMiAFIInqIcXVKb3ZWWwjflR84KEGP6bFY3OuQbimUfAtwqZg7oNZNHutDtK0p/wnEr5B2eQMHjCK57C/2CYY9y8bVHoCePH8gvBRreHrXACiPQTftESQIPQBKFXdEqV5s+4ARVS+59OFgOyFjx9FmLYPuuxZfQPNk8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Sat, 3 Oct
 2020 05:17:27 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.039; Sat, 3 Oct 2020
 05:17:27 +0000
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: split xdpsock stats into new
 struct
To:     Ciara Loftus <ciara.loftus@intel.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20201002133612.31536-1-ciara.loftus@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c2d580da-f9c4-b084-55d4-3034f9472d5e@fb.com>
Date:   Fri, 2 Oct 2020 22:17:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20201002133612.31536-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7b6]
X-ClientProxiedBy: MWHPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:300:115::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1836] (2620:10d:c090:400::5:a7b6) by MWHPR11CA0041.namprd11.prod.outlook.com (2603:10b6:300:115::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Sat, 3 Oct 2020 05:17:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d082ef99-9255-4435-7076-08d8675b9e83
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27271625FEB0A7DEBA7CA08BD30E0@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19S1loWkqAiWxmDPDb8ZqTkJLFvhZEFfabXWkBtWJDDPmudaVB0HaOZ4Xh03fo8JYN8XvOhXIl9mAU1R0+SuxdOMeN2J2dqcVHlSH/vXWbmYCJ66yq2bOxmXXVsSX0q2aLvrDQEwzzceEas1IrKwidIO1DiQc7/Jb/7ilBJlH7bldOmm0fCLjaJn/pbIy2YHzd1PImVFUnhh+Og3PTL/Ux54lTfoIM0/DUPWLsYHyB3MKglhyyzrCV8o9bT73UP/6zHdWu5Huj97q9NBSSvF+eCfuelFq/ayohghpzkHIkv/R0ZpJxcYEH2b2gU+m0vEUcHRPvaJ5+/PMSCRpBoPj5nkP2Usdp5S4JkQzzI/Nj+jmdWfzeMBlEFjUt2v4HahvXTHiCe3zblk37hmPVxfeyV/8280k8zuUED8LBnQF+/jbICFqi3WoUuGeiavdQoC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(376002)(366004)(31696002)(66946007)(86362001)(5660300002)(478600001)(66476007)(8676002)(186003)(8936002)(16526019)(558084003)(316002)(66556008)(36756003)(53546011)(2906002)(52116002)(31686004)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: O+E1RLzXHFWBWGeYXoNZSURMcb8Xy+qwqF+aSyoAYL5RaMm53PPDPyqbJIf/9Vq84WDRt2pl9rmFzYgUC5eNyFjRQvn0zXHCo5cYWmVsprbbEW1yOCjMKpwZk5pMuEJXjkqga4G0wfzJg78prY0yDKvZ7AuJGC7VB/LPwj738sWpzqN6joW0BPE3ljCVezpRCNYzBeEl1tMs0URHz5a3VpjKPKhp1Rc3L1OU0qXg2sniMJAyyd7517b1InPv+Brdr/fpv6WGKHtvuZ1xG7kQ7qEoIwH5Bs55aqJ2pD4QNoG1mXDzgpqRjhzeKGK3nbCvfU9P3hFtBSMTwi4SELc3Q6e2ngKJx6aSh4TmFs6B5SskmU0DLnXpArEQP6b5wiyTERLN/E5YNXKsW2LPfRyMYBT29K/VgaPnsZH5aaD/8j3mZZHf8iUq/jhDSf3RIJO42SS2ZKfLFHJcFPciJIhah4xbUW0DF2RfLH3W4xeIAKgrhKI5MN+Q7tuWVaynizIe8peTBrjzLNrNC/rjkjffjXrSj5cSsEia7BnyV53tbU3H6kUb+LhUbbR0gJ+J4gJZf667KWcYKzfSu0RDjpIlNWssWFc0yluIyBYSHTKkfrGytyoAARR1knqNjvg4qPbq1gZ+DFADi63D7IYGXhpQcQjVe4PCU7/pi/zd0ncsNGs=
X-MS-Exchange-CrossTenant-Network-Message-Id: d082ef99-9255-4435-7076-08d8675b9e83
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 05:17:27.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1cxWPFKC9m55PY1lzvMJmpbpU38sq9SoKGlM7AfBAllNllHz3LLNpYXls0jT2JDt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-03_01:2020-10-02,2020-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1011 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 6:36 AM, Ciara Loftus wrote:
> New statistics will be added in future commits. In preparation for this,
> let's split out the existing statistics into their own struct.
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

Acked-by: Yonghong Song <yhs@fb.com>
