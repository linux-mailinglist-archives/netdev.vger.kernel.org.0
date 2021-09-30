Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB441D496
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348778AbhI3Hhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:37:38 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:2272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348760AbhI3Hhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 03:37:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb6O27SNG/Q5xPLcRn5MSCgGRMHJzvHd8pJxbUDphPyo2phlcADqiUlyfoaKnUnFdj4k5k6ixbTZDqFZwlbsKgGChc2DQz7o+XupTBfyed5tjqiXxGIHV9a5T7cM04tR5kO0ZCIbuzUU0Wx0XM09EEtbqMVWzXXU1KyxvbinfmLl7zWtVsVMYPpQTzhTvWyZw4JnA0q/Abjluo3Ig/e6n5c5WmEbYwvsAQuE9UfLI77nNbwV3EdBaBl9eoFh9ZUl3MyoR0unYRnFsZ/pMJgxhqWQ2er6qnjK7X3q9BH+E6B+IMJTpittCuALSLeAlfwByj1Pc+z3bwTnrRDpa0FeEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oEleRzA9tSDnNAjsRRsFHX+xRAflNkMvjeLEfZSSxGU=;
 b=n5pE+RreQxK8h6i3yuk7ezuXv15uhw6S6YAUlJqLSos2jNmy0DEFKujp/+8WlDghAJUnpv0AkGMPUU/3PJe5HbkiEMROxqKgf7AvVbdWaMjU7xS3vhhS+LOvft3QF8g/wyLUO+CpKCaCXM07qxggW1CAfsi0ROfBPM8tf6KPaOOYzyP37Asiwlh+cDJIpR02ebJ/+kJT3+l+f71CRzN0sUfAuxeFqvwy5l00M/unnuWMWQxju8yDE6SZEs++u1nB/w0ffMM4ABeIpngYa9+6jB3kox2S1O9vfWBqD+d7Nm6Rf3hIeaEbYRCDdVvKoaD/hUzO9aIr9ClTmHubLntkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEleRzA9tSDnNAjsRRsFHX+xRAflNkMvjeLEfZSSxGU=;
 b=nzO2uO7SiWfKQz16eQU3rVMJtANwuH0A6tSJ7y8/fedD4m+xLV3S7Ime3xDowN5VlxYeA73faLyB9NZtLldvm7PVgRY4xVTjAzq9BwR5f6oSoDKbbbaC8gIAxQFDdTGIwPJPYf6uaoluLf586QveXdAL6gQgJa/IU93vnVqLwwPoa5+EXqqlEew0FZbxVdpKhTco5bThLhf0mLHgjFtO2BUYWXRi/4Wj/QcdZAohGjjjkbo7Hh0lzZO02jtZDNkDxEEO/FK+L9GdO2CO/Q/X/f8eQmPlICAwA5DtDZHLQyungwsU419d9gdEdWBmJC6d4wI+t92p4ZPYUTeYxoJT2g==
Received: from BN6PR1101CA0018.namprd11.prod.outlook.com
 (2603:10b6:405:4a::28) by CY4PR12MB1543.namprd12.prod.outlook.com
 (2603:10b6:910:c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Thu, 30 Sep
 2021 07:35:53 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::d3) by BN6PR1101CA0018.outlook.office365.com
 (2603:10b6:405:4a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend
 Transport; Thu, 30 Sep 2021 07:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 07:35:52 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Thu, 30 Sep 2021 07:35:49 +0000
References: <20210929150849.1051782-1-vladbu@nvidia.com>
 <CAM_iQpWAn+-NKapaBfCHs9MfatzSLsAWv9RvjiCvn85fbxeezw@mail.gmail.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: sched: flower: protect fl_walk() with rcu
In-Reply-To: <CAM_iQpWAn+-NKapaBfCHs9MfatzSLsAWv9RvjiCvn85fbxeezw@mail.gmail.com>
Date:   Thu, 30 Sep 2021 10:35:47 +0300
Message-ID: <ygnhpmsqbjn0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4390ecce-91ec-4133-39cb-08d983e4ee63
X-MS-TrafficTypeDiagnostic: CY4PR12MB1543:
X-Microsoft-Antispam-PRVS: <CY4PR12MB154347191A789F8115A351AAA0AA9@CY4PR12MB1543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79ztQ7DafwC0C2R003bd5NY4eHJwqroFrUxKrwVVYjtsl5p91RIRtBW+2fCb2FBVagWvzH42I4QVVDL9eG4qqfCOtp1cmS0FqZCFS6B57+894l+SEkJucDyspzqqeyaj8zMWFCHlU7+mtf/C76UPnpCUm4y3fjazieeJN7nNJWTRiz/4xuM5Dq1Mtyb+JmfaqjNod5Dx7q5LogEsVpmgWO36yjBn/cmyMtq+MzXUpVYBC72OQcrv/5LAyLxd8lLsSpANls4OTUiK7vrKfNevr9WFjTZzJRQV2eCWgZqTLa2RZRVTgDcdQTYIDjOZBnKndeBkYChHBXQegyydGcQjbuIrdz/tTt4OraKdUN6uCAMreW5Y24+fJxNXPQnj0368sb3O50IZhRg9KcAzC7vDsRySIn1Cyf9BDXm21m+NOy9phLQXvB0CioGy9VDvBv39OdIT/lTUe5aMx523IYA+24rZE5hhekC1tn1Xlm7pSZCHg0pS/Ro3CtaIS6eSl/MaZUv8qN17vfzzM6MJ36/XHR5NLtJuPLdPBZ0V6z+QACMTnieJfZzuOk+bWqq6Fd/YhVGTKkKHVxmWv4rcOjY+4NuAialdJ1vQnykGDpa9FEA0M4uoPM4xo5yG56a5urRfQxMlK0ISLfJ2STSloJoI4UqvJBhgJU1Vv0B5pN9KaOj5VsSd3TpGmKJMi9Fo9XGp36vYsQMZEasOrLqKSvavfQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(316002)(36860700001)(82310400003)(54906003)(36756003)(336012)(2906002)(2616005)(426003)(70586007)(70206006)(6916009)(83380400001)(8936002)(5660300002)(26005)(86362001)(186003)(356005)(4326008)(8676002)(7636003)(508600001)(16526019)(7696005)(53546011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 07:35:52.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4390ecce-91ec-4133-39cb-08d983e4ee63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 30 Sep 2021 at 08:12, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Sep 29, 2021 at 8:09 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> Patch that refactored fl_walk() to use idr_for_each_entry_continue_ul()
>> also removed rcu protection of individual filters which causes following
>> use-after-free when filter is deleted concurrently. Fix fl_walk() to obtain
>> rcu read lock while iterating and taking the filter reference and temporary
>> release the lock while calling arg->fn() callback that can sleep.
>>
> ...
>> Fixes: d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()")
>
> I don't dig the history, but I think this bug is introduced by your commit
> which makes cls_flower lockless. If we still had RTNL lock here, we
> would not have this bug, right?

Original commit that removed RTNL lock dependency from flower used
following helper function to safely iterate over filters in fl_walk():

static struct cls_fl_filter *fl_get_next_filter(struct tcf_proto *tp,
						unsigned long *handle)
{
	struct cls_fl_head *head = fl_head_dereference(tp);
	struct cls_fl_filter *f;

	rcu_read_lock();
	while ((f = idr_get_next_ul(&head->handle_idr, handle))) {
		/* don't return filters that are being deleted */
		if (refcount_inc_not_zero(&f->refcnt))
			break;
		++(*handle);
	}
	rcu_read_unlock();

	return f;
}

Then commit referenced in Fixes tag inlined the code from helper
function into fl_walk(), simultaneously introducing
idr_for_each_entry_continue_ul() for iteration over idr and removing rcu
read lock.

>
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>
> Other than the Fixes tag,
>
> Acked-by: Cong Wang <cong.wang@bytedance.com>
>
> Thanks.

