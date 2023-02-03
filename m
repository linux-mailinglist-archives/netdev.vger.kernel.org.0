Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B0688D79
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 03:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjBCCzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 21:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCCzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 21:55:05 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E743BDBB;
        Thu,  2 Feb 2023 18:55:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTYrU7C+XwMr9da9LpnriCyVTsipIcG6pkkxHqlp55RCSyvjlL5MEiuU2qK9YLMEzc5b2h+31Ziv5iMmg4Ve84GhAwvh0SOJOOLlzSzlZiWdw6RZDBhHBu+WsfeREKvdjQsM63ho1tBqpVQmhe0bs8JsTcDVhXx8g4/0fTimuJqNKUkLmUEgy9rI7XXvALRX+pgWqE4yZCWCaQaV1aZ0edMPkuu1Mh0+kypzOmZERvahgdNQTyW3N8WqPHVRRufuDj0ELDdfaw1CpjBHGoNbOtWImr50fJIVbmDwfRnBlu62hbxbzl0dND6zGlLnghG1EfdDvI2XWI+O/T1NytWbrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0ieNo/1mwhjviWYiHdn6kxjBt1AbsKW14+NLo2+BQU=;
 b=NnMpWdEouvgdnhY9kZfjU6bdITYdQu7mBgSCB4IN15dm5xq5OzWUfhOfovpl5z4JeRCIQ3KhYqHgiC2b1P7ttyqpeb6bqU9H/XdRIDQ2OmskctzooB170sPApth8ff3jjinP+CHHv3lj1MPZp4/+xwfHl+tRcFsxbaC02ymzGYGOl/A7F9VS9JaqYXtsqfBVvPnUIDrb4iwaf6mbxkmyNiCCGfE7VvLwWtCvyElyw2Xj3sfU7dqou7PweJHKGK3W5M6FdD5Q+fvxmeHcuLWB5gmLuHsXiQOl8m4xo+rvU9TmfmjAvHhDUrRPB9116xQHg+lY9RgyLfth3fKYHLdoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0ieNo/1mwhjviWYiHdn6kxjBt1AbsKW14+NLo2+BQU=;
 b=YFEkYeONQLJAZ94rGIVE0wFXs3EVp2BTlJ7RkOVzfZ9Fd3WrlHOiGrOZuv3inGwcMoyM9WRfvsLUFy57FIgYNT85M0s1hvsFqh17LHGStQgoYrvUUqFljXqdFWlLB4DALIJKb5jQUnP8kqolL/Xa7AojFND1aPMBM0ebmoyiwxAtsbRGDeY5M5pu91o3kdMFWFmEwK6xymFT2Sadg4IpuAPaTBmQJ6dtU8xc0X7Hk78ERlbgXvsYC9vmyn9idAhZqwdLHT9yxWv+iASYLT5wrmlmFMFGjcGfn3GUMkmRygkIHzq9s+KyJ4EfyWvKrtvaFllRFGRpVf3kim+UdG4LLw==
Received: from MW4PR04CA0378.namprd04.prod.outlook.com (2603:10b6:303:81::23)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 02:55:01 +0000
Received: from CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::86) by MW4PR04CA0378.outlook.office365.com
 (2603:10b6:303:81::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Fri, 3 Feb 2023 02:55:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT112.mail.protection.outlook.com (10.13.174.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Fri, 3 Feb 2023 02:55:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 18:54:55 -0800
Received: from [10.110.48.28] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 18:54:54 -0800
Message-ID: <72029a93-1150-1994-916f-b15ef0befd49@nvidia.com>
Date:   Thu, 2 Feb 2023 18:54:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@redhat.com>
CC:     syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <hch@lst.de>,
        <johannes@sipsolutions.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller-bugs@googlegroups.com>
References: <e8065d6a-d2f9-60aa-8541-8dfc8e9b608f@redhat.com>
 <000000000000b0b3c005f3a09383@google.com>
 <822863.1675327935@warthog.procyon.org.uk>
 <1265629.1675350909@warthog.procyon.org.uk>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <1265629.1675350909@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT112:EE_|BL1PR12MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ffb76bb-9b07-495b-716c-08db05920a9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gu4+6wG+4zP4phNe6aVBTqUUZWKFV+olLLx66wHBwd6SYtFqB66vu8rwpa7uPhaVAbX/rH7OTbi44v0fGGH3LLkVO9ShYJiQjm3WRhDe+oBdJ3iO/MwwWWhlmMvzkQy6/zyVxH+2btd/OuReHUJWxl6k3r+wAKN+LQV876Oin6S1rjvXQsmlfkoffdEcZjsFoSoReSXsdxrpkxNP5N1GOI16KQ60rsFvCawrn3wip1upg5Q+3CG308lTAUnsXRqw5QjE53stSpKK7ig9fWaq96jqjJz9z3ibsReBzT3ikmKV0U7wc5lmR7IShG8PB4qtcoqHjUtOYOnrVYTF9napxfy6SvuBx0Xy13hOoTinwBMb8Ns+b4/Mk+ynD6C2fGWwB8Nw12eRcV/qiHjJ90i+iE/WZQQ56Y94uO/e1A6IMQLRJJD3lDXgp5JsK+OggTedgVxzZWEpNq01PNs3t9S6Q1D4mC/TqeUOHJ/psBStpbKeGRNvKz4JXYVRUdaTTA+4uSNXRhXT2R4v62bQrK8Dnhkhz7vCcK37N5kUb6RnY5N44fdEYKbsN4u/dWEZ+nTFtgIGPkaS9EEG8ftZY5hLexEjP3cQ30vVA7IDEDDCzcMiAL61WC+dMfr6+piCSWVsuGOczVUnf9jK0c+2fTm4qX1TaNvGrpXeMYYLidHvRlAiZERrg81+TK9X/c1ZK1ckC0v+Cbo8/iCJgCP5kq9W2H0OyfOwUOeJe+d+TAa74GM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(46966006)(40470700004)(36840700001)(8676002)(4326008)(478600001)(36860700001)(70206006)(70586007)(31696002)(47076005)(86362001)(40460700003)(356005)(7636003)(82740400003)(426003)(40480700001)(82310400005)(316002)(54906003)(186003)(16526019)(336012)(110136005)(2616005)(16576012)(36756003)(83380400001)(53546011)(26005)(2906002)(31686004)(5660300002)(41300700001)(7416002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 02:55:00.3014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ffb76bb-9b07-495b-716c-08db05920a9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 07:15, David Howells wrote:
> David Hildenbrand <david@redhat.com> wrote:
> 
>> At first, I wondered if that's related to shared anonymous pages getting
>> pinned R/O that would trigger COW-unsharing ... but I don't even see where we
>> are supposed to use FOLL_PIN vs. FOLL_GET here? IOW, we're not even supposed
>> to access user space memory (neither FOLL_GET nor FOLL_PIN) but still end up
>> with a change in behavior.
> 
> I'm not sure that using FOLL_PIN is part of the problem here.

I agree. It's really not.

> 
> sendfile() is creating a transient buffer attached to a pipe, doing a DIO read
> into it (which uses iov_iter_extract_pages() to populate a bio) and then feeds
> the pages from the pipe one at a time using a BVEC-type iterator to a buffered
> write.
> 
> Note that iov_iter_extract_pages() does not pin/get pages when accessing a
> BVEC, KVEC, XARRAY or PIPE iterator.  However, in this case, this should not
> matter as the pipe is holding refs on the pages in the buffer.
> 
> I have found that the issue goes away if I add an extra get_page() into
> iov_iter_extract_pipe_pages() and don't release it (the page is then leaked).
> 
> This makes me think that the problem might be due to the pages getting
> recycled from the pipe before DIO has finished writing to them - but that
> shouldn't be the case as the splice has to be synchronous - we can't mark data
> in the pipe as 'produced' until we've finished reading it.


So I thought about this for a while, and one really big glaring point
that stands out for me is: before this commit, we had this:

iov_iter_get_pages()
   __iov_iter_get_pages_alloc()
     pipe_get_pages()
       get_page()

But now, based on the claim from various folks that "pipe cases don't
require a get_page()", we have boldly--too boldy, I believe-- moved
directly into case that doesn't do a get_page():

iov_iter_extract_pipe_pages()
   ...(nothing)

And your testing backs this up: adding the get_page() back hides the
failure.

So that's as far as I've got, but I am really suspecting that this is
where the root cause is: pipe references are not as locked down as we
think they are. At least in this case.

thanks,
-- 
John Hubbard
NVIDIA
