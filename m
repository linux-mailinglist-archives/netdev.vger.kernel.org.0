Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2391F3AC2A3
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 06:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhFRE6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 00:58:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231365AbhFRE6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 00:58:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I4u2gU010453;
        Thu, 17 Jun 2021 21:56:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CIWiwxoeS4m5gfUTrVz/SwFgX90V4rHM5pKXJqmhMkQ=;
 b=BAeOqXItWES9Rhr9VlQY6MacytG22KYrOifJzrKEkcN4WROdFIVZHfxJPLAV9szxIaIQ
 tjLAH53tV4VkQSOYatRbzm8DQrQ9PG/uFw1O7GSsDrBNXGeI2brJE76D5CnKJ5u7waYC
 mKG89/9mox3ZaXIIXgZe//JoaT7E/nGj1wM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 398epnhmj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Jun 2021 21:56:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 21:56:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1gvkCQTjH4qwRE9CNJT9XjhwKaogal6XlaQg5GF581c61DYoG2UM2bxN45xJxyhUpjUYzYhoI3jmg5C9hty1Xt7nH7cdF6W5mIKcVZBdFyEQD1Sr4SbaHwysmK/DoLWI3HcRSOR9Z21sbBTUlQdf2x5N5MX98Gj4LeI2QNwjCqnASPFfbtuzMvyjxKt+kwc/Jc912L8kzNBkKFO4jM39gxoVUZWbIH4ogRLGF+D9e3PLaSOuGzO+rcPOGNVusMwmfQQvB+Fc5OTRg/G4HPis5Tt065nz8M/6L3eejT4km5PD+aTHCY+oiwI8gRilmk/lVRAC4EdY/3WN7NznUbgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56NCSE4mhrn/PxubquiFHVtx8/o5zDTaRVxTvScgrdk=;
 b=VtCKY6x1CHAOXsv2VQ8B60AQahsftABrZLxJoz0qKLCNTdo4moWVgQ6M4aYf4xyC/SlU9PvVIobwpGZaAU5UxVVPU2L/bhSz/dkBCUdJv/JfPcv6u6e02F/8j/dlQB4mPGt0wlNTWR7xa6wl/M34IOtpntA2y02aF1iwlwfeih95UW1JCW4b5EofrAkCMHYcb/f338FG1QUFTBqVgBoYM75m05ZXnYXamwRNyz3lb1nlEckoux7bmJZ1Dyih4WU919AldPYTHLXvmr7L/+e+Pb6a/PkksyMARLx2/dj4ld50P5I0T/MShCPAvvxQBLmTZykx/0+1XJnviEGPFdwZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MWHPR15MB1408.namprd15.prod.outlook.com (2603:10b6:300:bc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Fri, 18 Jun
 2021 04:56:01 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b%5]) with mapi id 15.20.4219.026; Fri, 18 Jun 2021
 04:56:00 +0000
Date:   Thu, 17 Jun 2021 21:55:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210618045558.b57uy6pl2rwcmdrb@kafai-mbp.dhcp.thefacebook.com>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20210617212748.32456-4-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:f1fa]
X-ClientProxiedBy: SJ0PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::19) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f1fa) by SJ0PR03CA0134.namprd03.prod.outlook.com (2603:10b6:a03:33c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Fri, 18 Jun 2021 04:56:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c3cf7d7-4589-4961-7990-08d932155e19
X-MS-TrafficTypeDiagnostic: MWHPR15MB1408:
X-Microsoft-Antispam-PRVS: <MWHPR15MB140820FF75EC06A342DD7695D50D9@MWHPR15MB1408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PrZIsCCykt2irjLcgV3anl+oaFM+S6gme9cpRil0zNo6zjwROADlywF/GUa4RDkdsWdqox/6iPwH0+tqLEa0wSUvpCtjzoux9sE+s9XmlWJ2Gwq1v4ho62unJiJmspxojsHhohXXgOIn3cw5ua6sV5xeGAjCcoDmDF2Mi84qUsZ1rO3dcyq7Z8N5PoORsF2kOvdTKSCRwix1kDQQny0FKLw2A1wksTSw8gICDqUapKTnhWQ1B3czCtQ1HZxkJ2QE0TaKxVibyE2wplgz1Pv+hlzigBIuQVCk2rGRDRCCbmjud0vgvFssT1Z4ct+AoR+aUrvJv4JqLOYNbKqL5dhNLpufZCO9FHSRR62b8pCjiSWwdTqdu9F8yvi4YCe5bboRbXF1PIYeb/3RBtIm3lgXVnhnpPsxSrMf6yJEXAomNVw6T4ZiPYciIg6Z5Ee7bZRlrkMeZ4KNLqWyQXQArh/mot6EQeVPMQ5f8PPRoy3pXXrUW7ReDRP0ksTs/yXLe+uZPMoi9ayWq2MA7/6oB/QWo3JOTcI+Bd27IBWCvfksmOF56Xno1ue00akrdNcWj6hFz7p+KPHOQ5I8VBYRnUrTm8IuWHYDMRfu50e+ktAsrxCJs6mhn3mP+SaV9U9cWEg7OgiJlKPiCGT6SDFIl1wHQcPni2argH6vfySInoTeha5LzC6i3OuPekJGk1zmTOZDM+bSoqi3bmCcB3Oi6BwwIhFEhNF780LnfP1jJzEzPHNHVUuenrrYZL1YN4BmKpW/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(966005)(38100700002)(66574015)(6506007)(52116002)(83380400001)(7696005)(16526019)(478600001)(2906002)(4326008)(6916009)(186003)(66476007)(54906003)(1076003)(66556008)(9686003)(55016002)(316002)(86362001)(5660300002)(8676002)(8936002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?DqkNbY3fNMz41jULRVPAC5jkRt50ZHbnGaD1tjixv2DRLXny6mHthDVo7n?=
 =?iso-8859-1?Q?9hxdItndigjJZmodzd8OoJonyVifnz2oo+aUqUHV26NRnL1Y2ka2HdSJaY?=
 =?iso-8859-1?Q?gsihm77AaQ+x/Yi+9lLEnrYXfyXwsYOdfuQq2SRVo75oykvMSthfTo+lLV?=
 =?iso-8859-1?Q?Gh1+nr4wdj5uM8AEdTDZaGvH/AWg5bMR7xnI/Oj2ASgUOIJhwuDkHfBAjU?=
 =?iso-8859-1?Q?7chRPfFl20Jq75iYbYaeFil/kL1ETa0MblChsm56E4AQ6y2V3lfzMWkdN6?=
 =?iso-8859-1?Q?/NHYoxRz5DI4fNeksEhj3mglfftucmNtYp2QSaG5xxuU/jJLuG/xE7aWXA?=
 =?iso-8859-1?Q?nnnEF5QKJ74reM6vbC7qAWtYI6Us7QOSM1lZM3c09PLjgSB1Aat4pXgrhG?=
 =?iso-8859-1?Q?/L3HvuQIt+2pUmjUCDTwxqbs8Ra1/eh6qP/7eqW4A3yA9/sk12zqdgdRW+?=
 =?iso-8859-1?Q?BEo8uHlyVjRK44gTA0Wx6df9cbYt5Je5XfJKRsdxeBzl0FluVdYJr0kbuy?=
 =?iso-8859-1?Q?S8Er+vVE6LX6YJTqSdTUFN9waAkFE9Xduc/MPBpo/11ROyW8oxvZGVVwZo?=
 =?iso-8859-1?Q?C7sG2jfBMU+c7QwNtFY+ASBIK/YJXLsmEE9v5p38Q54a+K9K83SVRuu5PH?=
 =?iso-8859-1?Q?KkIP7sZ6klpvVr6zJn/fpOSV3JC4H5TahbeIWVzsl5hFpylzLFX86HVGgn?=
 =?iso-8859-1?Q?Dosxm4JJ801DHNVNmfmtzXYnQ0x3V6pKSOv6Gn8i+7GBIGnt5yYIswxQfP?=
 =?iso-8859-1?Q?8+XHlCdmlWPuP0otnTnvbe3OpkMPFSk6RF8or9h4CicXXkTpnzag2R5f7s?=
 =?iso-8859-1?Q?NHWF8LaUK1/yxFGE0D1r5vrL3vPhKBFPHWnzBTckbyOB2iB+KS5ph60ctA?=
 =?iso-8859-1?Q?7vjvgzwmcElWF52f3E1tyMaN1ns+wkDXJaW5uerHDsY7WiI6FmBMsM4fGw?=
 =?iso-8859-1?Q?Pugw8EZWihPRAuPW3Cn3CLcn4GXXmEMmrBzRXkjc9hNs1T1s3b6k9rkP0A?=
 =?iso-8859-1?Q?OvewROu8Elczz2fJlwIinpMDHHAYsmjNuMIhDl3wZLZckm9PBDY2ip42J+?=
 =?iso-8859-1?Q?AJuTfSqm/hlb8RNWSvLUuKGonZOf8mt1OliLzIp/PMxH89Tp7x+cr6AvV8?=
 =?iso-8859-1?Q?d1jVnA/bpKkkkIopSjcRMKvejwvnnjZVeMG5ReNAMLSb4wcCoRKpWZPAI3?=
 =?iso-8859-1?Q?jeTmMQ36MFATiy8uWuWemfukR325nJjYTOihAgSLcLsfRaw8UEjW395PQr?=
 =?iso-8859-1?Q?/yvADGcn8WYau1D4WCjJnTbM1TQ/V3E/Oy4jKS9QpwTb4P5pElqL0HCJWe?=
 =?iso-8859-1?Q?PJAxNhOBNPj+IFO2gnxnq3rjy0D4n/3xJrFC+GUbJ6B3cf8fU7j+ItEloW?=
 =?iso-8859-1?Q?XsN00uhmyAPGwlii6xSilOWcaQ1mmtVQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3cf7d7-4589-4961-7990-08d932155e19
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 04:56:00.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERBRGjNQMjxp7ERUoDlTZkGED8C8wxMq0Hnvqkl+IN/4JfypS/g8KbJaPwy7Q89b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1408
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Z4pjk4loPx7edc8HtEwsnwlm60sNzMQ4
X-Proofpoint-ORIG-GUID: Z4pjk4loPx7edc8HtEwsnwlm60sNzMQ4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_17:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 11:27:35PM +0200, Toke Høiland-Jørgensen wrote:
> XDP_REDIRECT works by a three-step process: the bpf_redirect() and
> bpf_redirect_map() helpers will lookup the target of the redirect and store
> it (along with some other metadata) in a per-CPU struct bpf_redirect_info.
> Next, when the program returns the XDP_REDIRECT return code, the driver
> will call xdp_do_redirect() which will use the information thus stored to
> actually enqueue the frame into a bulk queue structure (that differs
> slightly by map type, but shares the same principle). Finally, before
> exiting its NAPI poll loop, the driver will call xdp_do_flush(), which will
> flush all the different bulk queues, thus completing the redirect.
> 
> Pointers to the map entries will be kept around for this whole sequence of
> steps, protected by RCU. However, there is no top-level rcu_read_lock() in
> the core code; instead drivers add their own rcu_read_lock() around the XDP
> portions of the code, but somewhat inconsistently as Martin discovered[0].
> However, things still work because everything happens inside a single NAPI
> poll sequence, which means it's between a pair of calls to
> local_bh_disable()/local_bh_enable(). So Paul suggested[1] that we could
> document this intention by using rcu_dereference_check() with
> rcu_read_lock_bh_held() as a second parameter, thus allowing sparse and
> lockdep to verify that everything is done correctly.
> 
> This patch does just that: we add an __rcu annotation to the map entry
> pointers and remove the various comments explaining the NAPI poll assurance
> strewn through devmap.c in favour of a longer explanation in filter.c. The
> goal is to have one coherent documentation of the entire flow, and rely on
> the RCU annotations as a "standard" way of communicating the flow in the
> map code (which can additionally be understood by sparse and lockdep).
> 
> The RCU annotation replacements result in a fairly straight-forward
> replacement where READ_ONCE() becomes rcu_dereference_check(), WRITE_ONCE()
> becomes rcu_assign_pointer() and xchg() and cmpxchg() gets wrapped in the
> proper constructs to cast the pointer back and forth between __rcu and
> __kernel address space (for the benefit of sparse). The one complication is
> that xskmap has a few constructions where double-pointers are passed back
> and forth; these simply all gain __rcu annotations, and only the final
> reference/dereference to the inner-most pointer gets changed.
> 
> With this, everything can be run through sparse without eliciting
> complaints, and lockdep can verify correctness even without the use of
> rcu_read_lock() in the drivers. Subsequent patches will clean these up from
> the drivers.
> 
> [0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
> [1] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
