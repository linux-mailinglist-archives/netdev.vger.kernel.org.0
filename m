Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE8E6F0E70
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 00:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbjD0WoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 18:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjD0WoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 18:44:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2216.outbound.protection.outlook.com [52.100.173.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBF62106;
        Thu, 27 Apr 2023 15:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3exyEemg0tZnHCScm/L/PPcRNBW2jC5pQ8tQJRruj3dpPuNfHqktJ1w3h+9xLb77x/94sSSZrVA8yma1V5xtp7epzhHS4QqQf3F7hWyBq3V9l4oy7/cnm0ZITpJwy/lfgEnT0F72Lq8M92p6nAnunvRGsy1iBr4OsXGgQNU25RYdpiKcpKrMO/msrec1hDxwY7/9kSHz0DqkOhWxAdHb7zDo4PAUYWk2NbHcqm2/MYEUvB/LzRpz7hr9SA8vR5ee2CcRjc7qGpTU/ZNycwB7Ue9ZvqsbDMDeMaODIZaAtrkn+bV6uUgdNNDX19chpFAzlmW7rK1U0Mm25wgX3NP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DvYlOMFMeqdTakqg7rVi4ZCoJGePBxddlh4tbAteyc=;
 b=lqFP0uBuvop6iVXkY7rYu3lF1Hbh0lLnV26XtizyzJbPimqCi7DYPOHe9Lr/Rf4V2gnWe+9X63Xmj8lx4lVv5fhdCCZdbO9fpjEHM29SQJyCuiqOjGJZsGr+w6EezsWH6dmGiRF2cud+LyQt0/nz9njiQkvjvuuOBzPYJr3PjU5Khb7AzK+BmMWA1U53IxP8ZRwgeiAaIN1U49JrrcxSB70Yk6n5JPlwApp6we+Wsy+qdO0P3IcjZU8Fqeo5Ii0r+T7pi51RsgGN051aImsdalAZtCaAShk4uX2P4qMlLRBrJXVpf8hpS0/Dw9q6x9r3prXLOPV8zc2/QiuK/YdtAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DvYlOMFMeqdTakqg7rVi4ZCoJGePBxddlh4tbAteyc=;
 b=Sn5w+OHjn2CQUjay8C2O4VfpeG9tCDFiErFlqhIBq16MyS9O62R3R7tiH8MrMBzENFVyhgBKA8w4GlE4TMKFTyRHMvu5ClE4bNbU1TpSh8rRQXzgF3euVVA9+6idwcttV5nipe7WGrsQoTVvTg9x5jJMleCw9uqGlAAioGiElFL/tqz7K999xb7b6xmatMtVontTALZSDD5Cgcbc9DjaD2VrwvH5LluJxUurHKkykGAdotSiXIskwS+zG9hYc8JagGFX9t6UUq8WSPbMWGnVG5LCiSmnGEg3Y5rajTQp6CB3uLFE/B5fM7FXZPBW8XFWdccyze8fnU+1dBtobLRZ8A==
Received: from MW4PR04CA0201.namprd04.prod.outlook.com (2603:10b6:303:86::26)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 22:44:19 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::8d) by MW4PR04CA0201.outlook.office365.com
 (2603:10b6:303:86::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22 via Frontend
 Transport; Thu, 27 Apr 2023 22:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.23 via Frontend Transport; Thu, 27 Apr 2023 22:44:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 27 Apr 2023
 15:44:09 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 27 Apr
 2023 15:44:08 -0700
Message-ID: <92b1040b-dffc-9a4a-340e-99e9822821b0@nvidia.com>
Date:   Thu, 27 Apr 2023 15:44:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Christian Brauner" <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <linux-fsdevel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <7a3ff186-09c4-1059-9cdf-9e793f985251@nvidia.com>
 <09e4a2b5-fb4f-447e-a8b1-ffbba75c5e37@lucifer.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <09e4a2b5-fb4f-447e-a8b1-ffbba75c5e37@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|BL1PR12MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa7e70a-43e7-4231-cb67-08db4770f002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d328OdoW/vTCmovfaRWy4lK4VcMMI19fTzBFgfW57DKqTaufarlu8jHd2XFpJeVg3D5Bol5JwYudahZ9TLs0WmS/FX/p7rpiv/GWFS9qJtqm6AnD/Ncj0JANSGysEFW2At+axa/NzqxpKkZLH8oiAJs44AiFLGaRggMBV7ltdfQzj5Pohm95hlcoYa9YxVgw2TapOurpaOurvUq83GnfDM0dpiO7onIzEzl0Yx4rGpuqossROxiHkqVkQm4tdg6C8BdP8gaEXuf6Simq7sMBkKCgolRJPjBZ2y2KXXWf/kvk39q3Qsn8EvQAwZg5aNmi/FGDyv9JyF8J9ty6mn9edjlA1ndG2Aln9o3QY3cc/BDIJhHAVgUytF2v9XiyzyDV3sGhozKGPVywUOtIH4mD5M0MqT4oL7ngEkwYmtrqp9b6pXS5dhpVJBFVMY40duD55qGtekZ62Jz7rhzmZPzW0ZbBbDHDPmTp9J/nFllUoVSNhYRBwxo9E7pUkVa6kNFBMYy0KtdzVbyUVzib67eqtz3E65SGcVwd59S5pYt/WiGntZU8fItubr0A4kvfUy09xvqw/XSRoXtCDJJSFthVOiDS/2MGO7EgvdpF/CaVdIPMLpYGFXFrN6g9dqpLhMgPxDtC+R9JqaxtyccnfkdobTolRynsFy4vUsCi1gNIxTrSA/HurKfzyBUi/odperzWdbTIUJG0Z1VScr1iAdUpcqC8yot9RvEuqQUW/g0mMiq6dpfB+FyFdMEvtUq4wpM2t0qFiltF0TnWe6F3TeufX5PY02b6dmguRUtueZEDLio=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199021)(5400799015)(40470700004)(36840700001)(46966006)(7406005)(31696002)(86362001)(82310400005)(2906002)(36756003)(31686004)(40460700003)(40480700001)(53546011)(34020700004)(36860700001)(16526019)(47076005)(336012)(186003)(83380400001)(426003)(26005)(2616005)(70206006)(70586007)(16576012)(478600001)(54906003)(356005)(316002)(82740400003)(6916009)(4326008)(5660300002)(7636003)(8676002)(7416002)(41300700001)(8936002)(43740500002)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 22:44:19.0743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa7e70a-43e7-4231-cb67-08db4770f002
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 15:31, Lorenzo Stoakes wrote:
...
>>         bool file_backed = !vma_is_anonymous(vma);
>>
>> would lead to a slightly better reading experience below.
> 
> Well you see, I'm not so sure about that, because vma_is_anonymous() checks
> vm_ops == NULL not vm_file == NULL which can be the case for a special
> mapping like VDSO that is not in fact file-backed :) the horror, the
> horror.
> 

Yes, you are right. It looks like vma_anon is a better name here,
after all.

...
>> ...and now we call it again. I think once should be enough, though.
> 
> Right, this was intentional (I think I mentioned it in the revision
> notes?), because there is a conundrum here - the invocation from
> vma_wants_writenotify() needs to check this _first_ before performing the
> _other_ checks in vma_needs_dirty_tracking(), but external calls need all
> the checks. It'd be ugly to pass a boolean to see if we should check this
> or not, and it's hardly an egregious duplication for the _computer_
> (something likely in a cache line != NULL) which aids readability and
> reduces duplication for the _reader_ of the code for a path that is
> inherently slow (likely going to fault in pages etc.)
> 
> I think it'd be confusing to have yet another split into
> vma_can_track_dirty() or whatever because then suddenly for the check to be
> meaningful you have to _always_ check 2 things.
> 
> Other options like passing an output parameter or returning something other
> than boolean are equally distasteful.

Agreed. (And yes, I overlooked that discussion in the version notes.)

> 
>>
>> Also, with the exception of that double call to
>> vm_ops_needs_writenotify(), these changes to mmap.c are code cleanup
>> that has the same behavior as before. As such, it's better to separate
>> them out from this patch whose goal is very much to change behavior.
> 
> It's not really cleanup, it's separating out some of the logic explicitly
> to be used in this new context, without which the separation would not be
> useful, so I feel it's a bit over the top to turn a small single patch into
> two simply to avoid this.
> 

Sure, OK.

>>
> 
> Thanks for the review, I will respin with the suggestions (other than ones
> I don't quite agree with as explained above) and a clearer description in
> line with Mika's suggestions.
> 
> Hopefully we can move closer to this actually getting some
> reviewed/acked-by tags soon :)

thanks,
-- 
John Hubbard
NVIDIA

