Return-Path: <netdev+bounces-3106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 182197057E6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4EB8281016
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1C6847E;
	Tue, 16 May 2023 19:49:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A42910E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:49:43 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993A5421D;
	Tue, 16 May 2023 12:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyRhWVsYx8Vpn0Vw7VscB1K2Td2GfU1WVFUPQeVJN/2mL9N1rktadCDTI+KwYSz9prRQlJRN2EgC5XvN0wCmAS/6qWgT/VD1Z0q4LIiEIhChePktRnH7Pu/1IYtjl0qIqq5KvUzstNt7eq1hJJpalNNjW9o+rw7XaHHuxfIJ3hQGFicexNUFEgTh+k9fRTEJKBiG4YhhOSJlTQ+AVvc2AjeACysrWt53VNN+aXjVIQ+zqD45Q1nUefDVQFGVM2cLsbQg+C/AHWJKAJWz2yCgGkdujMV22pfeVbFK/lDALeD3VAFnZeOAjXYeYZUcq3Repu4OFNdHc11BmA0zOsnbtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ifg390Bd43U7qDnKPG5+yl/THRlujk6tOxKRHh7ukI=;
 b=TL7mBetpHGWiiOnY/LHBal7hlX+vGEs7LLKjROSV8ePNspVVVHpuEgzVg1BmLi1EzjRx7SoFFs59W6r/ubBQKmmFryc/1zrauAMjVMYv+6Ack4FGT45iZHw5X+8BxWnnq8piKDN+iodoTK5o6otBvjl9AWDfGhFVy/OMJCHmxOT4weYqC9l2WJluooiZH9rD4a5P7K+hI2c9NsBh6Qrl+DLS696ny7gS8uCG9ebaRuNy5RBG/yUAm8SqLlAHGFMqNmS80N6bqYKbWhOIz1DCIWK5p77MVd8ohQ7D9avFwNpOC/1lNqlyUfPxP8qrmq0CDH8x+PrFRTGu3ozBla86zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ifg390Bd43U7qDnKPG5+yl/THRlujk6tOxKRHh7ukI=;
 b=rMg6oZhkFQhwonxKtvhF1tfg8HiBRJn//az/pYZ5NR7v+E8i5F47jNWV+o0F/kurTbvF3COmPJ+DgcLmpswpuiqPIUcDoCmcKbom4ncYrUIlip8pp7Ae+yG0xQcO6jE3opUBo6rHKiwiMwFW0eHFpFGA/IkZHv1KTAr9rLp6YVPpVYaAM0cjt//0DgQBIt3VRSnc7P+7uS4FL2gfTvCzCJ8LyCE+pg06pkBZLxqOFXo43Y2VIj0O11jC2ZSP+nBw4dIepw7CiEv6jtf37Fa8q+LX0gPvAmAXgdgpBbk8ciPFRcac8IbPFGZ1yde+3BjFyjDM236N4f1HDjnpuS7LHQ==
Received: from MW4PR03CA0234.namprd03.prod.outlook.com (2603:10b6:303:b9::29)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:49:40 +0000
Received: from CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::c4) by MW4PR03CA0234.outlook.office365.com
 (2603:10b6:303:b9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 19:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT097.mail.protection.outlook.com (10.13.175.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 19:49:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 16 May 2023
 12:49:22 -0700
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 16 May
 2023 12:49:17 -0700
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230508183324.020f3ec7@kernel.org>
 <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
 <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
 <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
 <ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
 <20230516122205.6f198c3e@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Peilin Ye <yepeilin.cs@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Jamal
 Hadi Salim" <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, "Peilin
 Ye" <peilin.ye@bytedance.com>, John Fastabend <john.fastabend@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Tue, 16 May 2023 22:35:51 +0300
In-Reply-To: <20230516122205.6f198c3e@kernel.org>
Message-ID: <87y1lojbus.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT097:EE_|CH2PR12MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: 083d2614-ac0f-4244-86b4-08db5646afac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	psLDMO28Y9OjV7pEhOLKDJ5xqLrrJ4fJK5NdhT+f5N7R6Amv1+zKPxE6OV7mrHK+p30A3NRz44nf7cduTGIq1er38pusOADyQWMYG7bnQN2kstoMC+7ppSd4zG0NlAEdZKx45ix81VZMyL42BoheIdYJUvw1vJ736vtboO/9NKetv0nVHJXS2+ObBsRcjGeMcOVjySWH8C2WtsYhyVfUbmj7BwZ2yKGR2e39ufWncmnR+iPPr3tpcMtfmGUsot0uBKfHnqngLV2RDvNfFDOOq9/flQ+k1vofbxs9duewHI2kuFd/rM4JhBWXyvaqErytENz8wB0KBYmGu3wmXpkT6RKoYszbv/V72+esEmYjGQIjlsttrFumKz81z4XcE0Stu8VDX/IzQrLqY7WZEP06GbRi1PdVwEZrAcDEjPMyh3N32B4CE7TJ1vVMgh/ZOqGqCQt+eXG0QCPupQ8VfoViseCqPwGgIEfoRBgec4OmvnFjuKTgqxCS4NUqUBmLiT3TudDhMfMvlcYjv5LbSnvKcP+aE+Jxa6+XgadYJ4cj8EH3sYMNY05N010RXXCWWgeHZrWs5qGgNtn5nB1BJ9WQqaH86OYcQaZWzbYx9R9uTK0F4YyShTJuRPigwp0aYerwvoLrroNj4LuaECJTlqCgYxIPXSABmCp0O965UphfE3P9afL63+E9Wlux7XDVkHZOniJ0CDs0jQcNqLYH/3E7nGRXuio9qDufETSm8ECm3q+mqh6VLgR82Y5+c0HLYJz0
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(7416002)(5660300002)(7636003)(356005)(82740400003)(8676002)(8936002)(40460700003)(41300700001)(4326008)(36756003)(316002)(82310400005)(36860700001)(70586007)(70206006)(83380400001)(47076005)(336012)(426003)(2616005)(86362001)(186003)(26005)(6666004)(16526019)(54906003)(478600001)(40480700001)(6916009)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:49:39.6669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 083d2614-ac0f-4244-86b4-08db5646afac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 16 May 2023 at 12:22, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 15 May 2023 15:45:15 -0700 Peilin Ye wrote:
>> On Thu, May 11, 2023 at 05:11:23PM -0700, Peilin Ye wrote:
>> > > You're right, it's in qdisc_create(), argh...  
>> >  
>> > ->destroy() is called for all error points between ->init() and  
>> > dev_graft_qdisc().  I'll try handling it in ->destroy().  
>> 
>> Sorry for any confusion: there is no point at all undoing "setting dev
>> pointer to b1" in ->destroy() because datapath has already been affected.
>> 
>> To summarize, grafting B mustn't fail after setting dev pointer to b1, so
>> ->init() is too early, because e.g. if user requested [1] to create a rate  
>> estimator, gen_new_estimator() could fail after ->init() in
>> qdisc_create().
>> 
>> On the other hand, ->attach() is too late because it's later than
>> dev_graft_qdisc(), so concurrent filter requests might see uninitialized
>> dev pointer in theory.
>> 
>> Please suggest; is adding another callback (or calling ->attach()) right
>> before dev_graft_qdisc() for ingress (clsact) Qdiscs too much for this
>> fix?
>> 
>> [1] e.g. $ tc qdisc add dev eth0 estimator 1s 8s clsact
>
> Vlad, could you please clarify how you expect the unlocked filter
> operations to work when the qdisc has global state?

Jakub, I didn't account for per-net_device pointer usage by miniqp code
hence this bug. I didn't comment on the fix because I was away from my
PC last week but Peilin's approach seems reasonable to me. When Peilin
brought up the issue initially I also tried to come up with some trick
to contain the changes to miniqp code instead of changing core but
couldn't think of anything workable due to the limitations already
discussed in this thread. I'm open to explore alternative approaches to
solving this issue, if that is what you suggest.


