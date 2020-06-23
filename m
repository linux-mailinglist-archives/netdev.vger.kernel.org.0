Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667E82064A4
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393662AbgFWVZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:25:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389861AbgFWVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:25:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NLB9xL007376;
        Tue, 23 Jun 2020 14:25:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=PIIVvxugPe+MyabGntIWlxh1j2B6UZ7b2ruFjrzyjHU=;
 b=o6UcBLOUgicpF/fKIspMKh0z73/yvvjAvWDj0FGC0BLJUhne37/hJqlax2VF6r3Dbvur
 kAOcOkoWrF8N+Ae3wAJ6CW+epa2PsZsenpmg7Q5PGmQSlBWnEZYe7lalVYZ/YIC/bepD
 48NbF3lJcJnYNr3NeajBkhprjM7+kvWBk+w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3cj922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 14:25:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 14:24:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7aPYCbf9VvK7wKMNMHtPBbj6vhN1G+OcmGiqBqclim1FeXIYI8lWYf3bspCwvZgHZIHy5xGGhwu0LrD92WqCviaUBt2QY3mCAQXlY9TOVmz0u7MucVtC8Q/Mpg16jfkaCs8dUvolC7okACkcUKk2+nx3YefasYWAMT0yQ8B5ogfjgdInRDdXIpIdWx3x2q7wCl7PqgqaUSfmtU+ulG1Y5KtiTN4/Ox/geQPl+nbuhR36ggnLeHuLwB94GxZV1tX4LFhfyrsjm30pn3nqxopUX8NJqWhIslRS4kG+mg5/8/JI+n8ag2VUA8YqUiLZxLp+DhXc+xdff2HsgBNxawwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIIVvxugPe+MyabGntIWlxh1j2B6UZ7b2ruFjrzyjHU=;
 b=Dp3oe3sKxp+1GC6mPwwjY/uAWG+mlVRELz33agmgI5o+LMS/7Uue5Rkj/R9NVexf6FOuRfKaJkVXn3ttUOUAus8HxGetoPR5tr1GrsuaGMS3xvULAUkxQVGeZV8n+Qu+D+E3ADX46yZ/3ePpzb0sQSMce207Oqllxyhz8OshcmD1lPJSsS9WnSsEEcU1ya5VumRuiMrWt/qfcQmI2YwP/B6KcjJCsPjo7eajSA5bv/uY4+NfmnsKNrJ5CZAkR9bxAtrKj76N4wF389bEUD76mbHtpiXKeb8pK65hQN0bMZwepQ7AGHiRz2DA1Tw9cAfdQfJxHCRelhrQeKvvkklGfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIIVvxugPe+MyabGntIWlxh1j2B6UZ7b2ruFjrzyjHU=;
 b=k3mkM1Bja6jJwXT49M5V1HRSoZUGon3MXCKH0Rom9U4R1nyrhhnBPzDch92X2G4JH3P9/2H7RGAF2AQF3ZX7OXwlFKTozJ0mywXEDdThURdU76x8jE19gkDxBTD9n69DgnqpfY0zVVIZS4ayVo3kE+tSoAO6WzmB8S3nVQ+QhNY=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB2635.namprd15.prod.outlook.com (2603:10b6:5:1a0::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 23 Jun
 2020 21:24:55 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4%6]) with mapi id 15.20.3109.025; Tue, 23 Jun 2020
 21:24:55 +0000
Date:   Tue, 23 Jun 2020 14:24:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in
 bpf_prog_array
Message-ID: <20200623212452.titgpyrxx56u3lyd@kafai-mbp.dhcp.thefacebook.com>
References: <20200623103459.697774-1-jakub@cloudflare.com>
 <20200623103459.697774-3-jakub@cloudflare.com>
 <20200623193352.4mdmfg4mfmgfeku4@kafai-mbp.dhcp.thefacebook.com>
 <87sgelmrba.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgelmrba.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:a03:100::25) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ddf5) by BYAPR08CA0012.namprd08.prod.outlook.com (2603:10b6:a03:100::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 21:24:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:ddf5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 236bece9-21fc-416e-17ad-08d817bbdf64
X-MS-TrafficTypeDiagnostic: DM6PR15MB2635:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2635159788750206445C1760D5940@DM6PR15MB2635.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsNTGq5RRYv+HlytPEPqFrpm9/IFi5RxZUmIcFaSDszJn5j+zoHmboTsvQFTdCvAN5EGGG5MF+yOqFEwcI0sfOcIGuzeQuYeQB0VVNvUtItcIknTlaDHtBBXNpfc4XcXbdpmouvO+YP/e2a+GDDN2T3csTQ0MEM8sHkkq+ig6EXlLmZdNEFu6EVb3/emK1Njnyeyuc2zt8N9O0Z1JzPHWWK9NkpAroXYOJfHABntDRz9NpqGDb3CYJjY9plM06h+IuVdlMZomU4Qlkl+BUAcA5XU9Koul6x3xLKzOh82LJhE6q3M7mOcYF4lcm95SPOJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(346002)(396003)(136003)(39860400002)(66556008)(4326008)(66946007)(2906002)(86362001)(6916009)(83380400001)(16526019)(316002)(55016002)(186003)(9686003)(5660300002)(478600001)(52116002)(7696005)(66476007)(8936002)(8676002)(6506007)(53546011)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ybjuo00cnVUx138XQoSxcOy9MFyOeLcQTp3E2lChbPfwK/swnEgA9X2NPna/sWU1P6d3iLkGl4coVEvAYBn4Nr1SeDtLK2oZb5pgb8FX2amdCwJJIysz+jo0lWrOmLaI40CRuSmCug565D8jo9lF6UXscg9xWmHffih4K0cPFIes9rn39rdEhmIF9ARxBAJsahVBVow2pDxoeuLAPwxgFoQipLmbuty4eiak4ZRJzV4P3U6MTMoCdhIvxVoNfO+iEhLOVhBLFwwnFO9DjBVmmjj4ghMUhHSWuXZAgIw7W37GA7/+7e65F7S8/Wp/EmuLjJTHMJv2xjqbs1WA80lng/hMvD8BhHIc9GqnYrCqDFDIGymB8AK8oUsDKyjpYf0bTm7qFyQ6wNOHJfMYaV1qRQeCM/lkEDpsFoZonWyibZl/kYw2uH4jeo6F5+8VIEy9VNlJfTmhYIArmmCGxpCMizkIdxjAYvkYoeCErc6TDw1uhHZSnkn+O/2DSUmHFFQ963c2ZiEsHvn4LTD/f1c3Aw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 236bece9-21fc-416e-17ad-08d817bbdf64
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 21:24:55.0035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXCZx5swXW3nxA21/zcHETEDS1jOZQtylwewKOBrK9uWxNHRYW90wqi8p55E85pW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2635
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_13:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=737
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 10:59:37PM +0200, Jakub Sitnicki wrote:
> On Tue, Jun 23, 2020 at 09:33 PM CEST, Martin KaFai Lau wrote:
> > On Tue, Jun 23, 2020 at 12:34:58PM +0200, Jakub Sitnicki wrote:
> >
> > [ ... ]
> >
> >> @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
> >>  		goto out_unlock;
> >>  	}
> >>
> >> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
> >> +					      lockdep_is_held(&netns_bpf_mutex));
> >> +	if (run_array)
> >> +		ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
> >> +	else
> > When will this happen?
> 
> This will never happen, unless there is a bug. As long as there is a
> link attached, run_array should never be detached (null). Because it can
> be handled gracefully, we fail the bpf(LINK_UPDATE) syscall.
> 
> Your question makes me think that perhaps it should trigger a warning,
> with WARN_ON_ONCE, to signal clearly to the reader that this is an
> unexpected state.
> 
> WDYT?
Thanks for confirming and the explanation.

If it will never happen, I would skip the "if (run_array)".  That
will help the code reading in the future.

I would not WARN also.
