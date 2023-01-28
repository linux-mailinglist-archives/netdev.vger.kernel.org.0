Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3BD67FA75
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjA1Tb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjA1Tb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:31:27 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF77290;
        Sat, 28 Jan 2023 11:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeYyofIdOB2at+6Bf5XiY7xDveG55kvey9jADj6UTRu43jepm0M6Mrwkpb6+rRNFO2oNFxXgzmr/GfP7Bhgtlgs7dnT9x6FlpHczaeuaXa3ruknzgB95+s5wWrgqIvu3EQYti6KOXIFwb7MV0psPNXt57qrQs8SHdkY5iHaqZ/Gb3Fc5GKcVd3pFbtUOrgStE45C4uXLBTYS4YGmgKTP+3Xgeg4JabPzWSdxtf02TgWcrmco7OqzufLOmJtD+1rheH8ojM5XzziojKeK4H5w7KZe5wqkT84IOzx4iIxrOwvDXpYPgMcOLDBdvlf/IvMQhsZvlqoPiKBLvX9cwuQi6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yfsa47LraUt9o/M5mGpUnxNGslWrcC+ejZ0Rw+2PrAY=;
 b=PMXZk27e3yxP8ufOY0J9b1Ns2gT25LX4Ma0Qh3UMpIwlpYPoO6JBLX972a6ioFb0maw5SC/+OXFBnY4+8BLddBy3377ZTgcll1IREpUJaIYTADvyKKiWcoYQDT/b1QX7l0gsNGIGaYMAmGU+oisOBr0OKL/VdbwKg6qFzT+JbGQWtShFML1/gYLc8dO39N88sVuDgEP9YTnmzL9EpazlfPoUUqVsS9WPDf+9UvBzICn7VrRYQABW46ZTGF7lXCsMUaIhaWx9k9mV2rkFU07TgpriVgTJxsCD91MYxrMmnhaGiCLNxegD6oD7AziSciQ0KI4cuvsJDUej3c3kfbTKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yfsa47LraUt9o/M5mGpUnxNGslWrcC+ejZ0Rw+2PrAY=;
 b=DHLEyBKALWNPfgh+f9S9VAMmxcb6oHfeSru94+WRfYOSsk9/75GrnjwDgkbz3lLilVoprsBLPXs8RGALVupfoZ3+MHaWGq5rPfUqWFw5WhV5PVl05Za2Uw9APqWvzCy0cAeWfYnrdOsBS7yAq+ieMq6XmnFMv0yeeQeiS6RKGRuV/si43QISrBjuNz0ecLx8V7zyJbLvTbzfI6JxUd8sctudVquGQ21zT6y7kRiKj8iy1q7FkidsSI1DpNOi3Q9zZRVEIHpKA0qZSnBPI/U1qzGmmcGJOt4C4QbW29ZYw7lejMHLOOM4juVvO/FpRMmTsFrUQCx7bHP8HDx1vu9lPQ==
Received: from DM6PR04CA0019.namprd04.prod.outlook.com (2603:10b6:5:334::24)
 by SN7PR12MB8129.namprd12.prod.outlook.com (2603:10b6:806:323::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 19:31:24 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::af) by DM6PR04CA0019.outlook.office365.com
 (2603:10b6:5:334::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30 via Frontend
 Transport; Sat, 28 Jan 2023 19:31:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.30 via Frontend Transport; Sat, 28 Jan 2023 19:31:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 11:31:16 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 11:31:13 -0800
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-3-vladbu@nvidia.com> <Y9U++4pospqBZugS@salvia>
 <87mt62ejd1.fsf@nvidia.com> <Y9VzBcDwtXIRDPkq@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v5 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Date:   Sat, 28 Jan 2023 21:30:36 +0200
In-Reply-To: <Y9VzBcDwtXIRDPkq@salvia>
Message-ID: <87a622e9s0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT074:EE_|SN7PR12MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcdf53c-1f60-4dd0-1f0f-08db01663e18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlPuG3RlN+BNPb1XOO5T5uwX3+HfcbexL4YB6iSsKLMNHQI3LWhqAx1ms5Zefx3utGcMz2ZSidY13cPMfLrUgBnl+JX3QFxsjG9LENzvq+TLuhARUDTTCqd0uGNjlANgK9CYgdD/RI+3ESTg0tlBqa8nHYQHOoRXSCrcHZOZX7ZHjlAlQkO8lGZKWw1bxvBpaMhxrTEwf+EfvDs5uyISYCsCaPw7d0mI9PR3VTGTL/QnMAe05sDjVhs9cGzpNeWeYzwsaFJEv7rG/LROtxKaP/t0LjRR84N36stxKyK6iT2PZ3KgxlDZOjWssJ5R3SXy9NbEFpD81LmofJzVrKL6p/1LqE/mt6Al5jXwKLcCbhpVihu9KmuHxFxd4PtXw8UJ5lb18z7kbRo7++8aJyFGBrCnrb0DJrEnRuYNJVDkQz4Gb6c+13Dc8kEoPNO9FK6/PH7k/nvTkzguLbnvr+UtKH/slkuEkx14emAIxX2uoaAU4iCRtB8EPzKsZSw5bp3tiJ+647UiydfXxHwZ6wSg2MlbfdCMYpK8Ay7gXRJ8wgtpN1nKfO3q9ceXQ2X86x5j8u31FLpZ6LuvPDJYQW/kMnTboQ7Qd89dkPnd8iucbyLvXsTgMvER0Dlm784cz5773pJoA3Yy82URl/fOSFbeF+1zptuY/HhH+R/5qSQt2sH5pI0+RqbCZQM/+5gA8iJYebzeMUnjAGBGplId1HxDx1OJ+vlNYu8DbrWM4SwkGlPjZbeWBqC66WXoo5gV4cNZ+47Oiuz7JCHWxjuvYj4T1XdmPF1GMVPqUTgU3+twM6I=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(36756003)(2906002)(16526019)(86362001)(26005)(4326008)(70586007)(6916009)(8676002)(2616005)(186003)(47076005)(70206006)(336012)(426003)(7696005)(6666004)(316002)(40460700003)(54906003)(966005)(478600001)(40480700001)(7416002)(5660300002)(356005)(7636003)(82740400003)(41300700001)(8936002)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 19:31:24.1711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcdf53c-1f60-4dd0-1f0f-08db01663e18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Jan 2023 at 20:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jan 28, 2023 at 06:03:37PM +0200, Vlad Buslov wrote:
>> 
>> On Sat 28 Jan 2023 at 16:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > Hi,
>> >
>> > On Fri, Jan 27, 2023 at 07:38:40PM +0100, Vlad Buslov wrote:
>> >> Currently flow_offload_fixup_ct() function assumes that only replied UDP
>> >> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
>> >> Allow users to modify timeout calculation by implementing new flowtable
>> >> type callback 'timeout' and use the existing algorithm otherwise.
>> >> 
>> >> To enable UDP NEW connection offload in following patches implement
>> >> 'timeout' callback in flowtable_ct of act_ct which extracts the actual
>> >> connections state from ct->status and set the timeout according to it.
>> >
>> > I found a way to fix the netfilter flowtable after your original v3
>> > update.
>> >
>> > Could you use your original patch in v3 for this fixup?
>> 
>> Sure, please send me the fixup.
>
> What I mean is if you could use your original v3 2/7 for this
> conntrack timeout fixup:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230119195104.3371966-3-vladbu@nvidia.com/
>
> I will send a patch for netfilter's flowtable datapath to address the
> original issue I mentioned, so there is no need for this new timeout
> callback.

Got it. Will restore the original version of this patch in v6.

