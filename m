Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276362B9F2A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgKTARZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:17:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726398AbgKTARY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:17:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AK0AEeU010383;
        Thu, 19 Nov 2020 16:17:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LFYhI0gJltt7pvg+wBng7hlMRIEu6T/5S2UtJjSyZ9I=;
 b=g2Mt6PavNFGOtGyLgbjYwNg7Oh+T2eV0y8r4hfbRKd0zPp2xNexL0KWNMwK/yRerV+hC
 bUg/T5+x87XeOA+z6Gs81DbGTAhWSgmCT6zfBB6Kj2QppLAkG4M82aXyhLwCFfr1olHb
 WMaEZ6cqR7X+wNASXOeb50+Vc2kAzaNL+i0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 34wfdq987e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 16:17:06 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 16:17:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKn9RRFkd+7P+z2Y6Q3bqptv6be4DXwy1ANh6EXyrdho+lpGx385FyldmWrCxEDY+8XXRUjCFk/bAPOA2uzyAd7kCGntAJtkSaQQIirKm8Ab46kBn4+alhIN15qvE2lEIu4ot01kC39/rof/6pPcekbyW7gUkCFsjnq1kicFPv/NzAABo67ckswvwcM1/OWmkoxKCPDIdjlbkQv35cWOHXNUvOPWN4m26jIMRxM5POtYrLs+grvZ9pbyIoSEhJx+9WiwC/RcEr3+4E7bP+q3M1VDhrntLvapa4ZOtKamcbOpUZEzBbSPuwChGEGGup93zg1cunQ7SA+rcfMuiOD6mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFYhI0gJltt7pvg+wBng7hlMRIEu6T/5S2UtJjSyZ9I=;
 b=K34UgpEr2LqYSUbG+N3cj/aGppl//3IxLXgUCQIAmvD/A9rptQhisLuuXUydH0PHwz4/RMOHA+vdnoTYQGo5p6f055xbIj9FRdYnPbosTd+4WRPempnlip/xTN5plJiiDSMk4TdSVpUtTJwUm7ExM+0ZnmBLwkQ1CAzGKebpF8lNA2+mcX2Gh1ic5/+r2JhDIKgplMIGca+tcLF1MlrfPXipM3fAgLgSqVSD/etojE8JBuin5z0HGwsy2DqU2O9KTVtmY1zu/hQDk0up2znNLSIYCe9nhu5CEdoPr+DnEJcUCSknY4PZtN1uPE8tFZU8tV1VybPHqeRMbxKnuXtEQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFYhI0gJltt7pvg+wBng7hlMRIEu6T/5S2UtJjSyZ9I=;
 b=jUZPBHpCJswOKbWYZFcns6ekQIYok8kCIZYgLjVyB2HFyd64MrQzOEMZycpeUzvik3Uiqhr8Ggb7mbdJDmAkF/B29nnVrie3WqKnLF00yPCvwvF6s1ZmTznb5oFXph2ljthk1QoVJeRtt51hzmUm36zwZv5QaYtgFctOr2zv2AM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 00:17:02 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 00:17:02 +0000
Date:   Thu, 19 Nov 2020 16:16:54 -0800
From:   Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] bpf: Add an iterator selftest for
 bpf_sk_storage_delete
Message-ID: <20201120001654.57cf3isbrm2lf3zl@kafai-mbp.dhcp.thefacebook.com>
0;95;0cTo: Florent Revest <revest@chromium.org>
References: <20201119162654.2410685-1-revest@chromium.org>
 <20201119162654.2410685-4-revest@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119162654.2410685-4-revest@chromium.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MW4PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:303:b9::30) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MW4PR03CA0235.namprd03.prod.outlook.com (2603:10b6:303:b9::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:17:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6736091-e5e4-46d2-474e-08d88ce99a8b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2376577897A043A938AF3FCFD5FF0@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkgVM9QlNGqTenoVLVaIzgMiAviIDaluuOjIW+puzr6AEVuB5R6nQTzbgSwmb8EoAlk/mYW9RPIrma5+QDaG3UGRGlKUYAQNdv6FQhqOjPdxdiq8iuPhOHnTfp94//zG+9Szz0hNClSpXwPkwi+hcOCLcEcwAYqhPzsnlgpt/v9rhdTykcsQMlzWttFSowR/NksInx3m/r+iTgzBvFp7NHlt4EafDunDKHhi4xi55THC6Bvvh6UH0enPG/u6A7XspOz3OfONAeCJFeScoGVYczj7qUt+P9QMMo/MRKBjsZKHkxG+WlSRlXOhqVp41JU/3YGah8ueuz2MGrMmWj4d+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(83380400001)(186003)(55016002)(5660300002)(86362001)(66556008)(4744005)(66946007)(66476007)(6666004)(1076003)(52116002)(2906002)(4326008)(7696005)(478600001)(316002)(8936002)(6506007)(8676002)(109986005)(16526019)(7416002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Hp6+SSK8jKMVMadmMCSFjkYq5V6xkH/TCOxCxMe4ePMlwLCm2Bbr8dqCUx8f3efAlQhK50xACvRh7sjuc8WtGX6M57svTQ49AuzR0ju27hzmGtHw3Q+QwPOJtSVBbBzT/VR5xHb/vjNfUcakJL0OWy6y7yxG89w8+RqVJKDm9h5c+jZe7CrBVj9d+Z9x1of1MxaFdycoctVkuILPIrDO2z/QCd9STluyQ9lZFlmek+gaBwnBwgaQ2FaneQgaaupkdQSK8LllAt5OxM5g5VoX+Rbmb0tHf0KMkLKEcD1io0y2gWNn6fPVGNv4BlxeihOasB1lq/QbSxxgyEAXvRCVt7BF8hCpM7hMOsTrZgK95UB49Wmah5o0qiERiSpI1IupbLSFUhJdr4skOH5lqBM3T1KlJ4DypZjziY2tIFFCrWkxyS+itrUyk5KSyTc0WvTHx7yHcFIKrO89pcaniJCGrJs/JNVDkNd4a9wQ8B9uidDFpozpehzUriUJCzIooD53iO35/dk7rp/6JUfD7UCpP0XwKndL09hy931JHNlLkW3zoNL5raz8UT443EcoTJ9Bk2zG3WlSAjefgyQE1qcGYiR+6FE5YJAUaNHkuvmrPDKe7syphiBRXlfda2mxWbNaj29rFjgKoj/yt+tPeiGVzJmV5bb5fzG+2pPKDE3uI9rrH/4D+qQyistJKR8s4oVcpXfESJtfBWQhcqTLdrE6KZKqyGsibNpnADfVAN9/z4rknoPMDxTLn98c4ZCspA/Y+7h1apRwlBqYzOlcm7WwbXaSzUDpok/BxQr7OeIx82q6P/eV2y5sYXYqbZYojHuERwiRiDZK662i8KFrNhM+clgCgl//KNy3nnN6orvV7ecMQfjMbQUbdc1UXsxTEnz26ljtFRJ+244LOGibiQbqvJ1F+NUYCe8GjEjxeazm8vg=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6736091-e5e4-46d2-474e-08d88ce99a8b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:17:02.2661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LV6fwJNOsDix06HEkCrNvmLt3VYU2KvL8hYjNB5yHGq7S4kqI3L4wpQprzJvqDd/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=1
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200000
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:26:53PM +0100, Florent Revest wrote:
> From: Florent Revest <revest@google.com>
> 
> The eBPF program iterates over all entries (well, only one) of a socket
> local storage map and deletes them all. The test makes sure that the
> entry is indeed deleted.
Note that if there are many entries and seq->op->stop() is called (due to
seq_has_overflowed()).  It is possible that not all of the entries will be
iterated (and deleted).  However, I think it is a more generic issue in
resuming the iteration and not specific to this series.

Acked-by: Martin KaFai Lau <kafai@fb.com>
