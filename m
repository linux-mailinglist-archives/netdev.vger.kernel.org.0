Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B459BF58
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiHVMOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiHVMN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:13:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D843F2F395
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 05:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bw1KGYmd1An4BGhg25CS+iL1zw1TS9/CyeJ24c5/VyTf9bwK4ptlo0Az8Hn7KdNDAAQrsaNwodDKV/18x+uMRJnmdXI6iTdUv5RozaWQTYTx6NGywl3q/IhWEsygJfXMK0+qZP4qO/chS0sXFEQVWynclcsQh96zmQq60uRvRLaRZkF5WQLDgX3JLvjA1b9OmqIGRf6yf6GqWJLWEvouPNEpwaIQqxzcpUpC/HIdsQFjPAA9hY2kx9hTaCyWs5DOq9/eKIdDJnR8+6uyJzIkiRVu3FWxGJIQL+gxDtdpRC+2ik3LXS3ZfbvfEQ+aZdCcYMp1R8z27ZThUJEqGLw9og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD03sLubL10YN4tSsHjhX9KVyHHvSUsY0j4OSEA8cvg=;
 b=BkhuremL21zDs1DlFsjXRZbuBMoEQ25YwGWVsIVtQ9GJd/XZpRP2FlYWbrpg39/cF5F0/x7X8xlfJL8lLzOlivgMULhTdExUeLBWeQ/Tg3///QHmocg5JDtyIj1Qfa+aROjCg6fHWZd2nKsOlxMds+5xb4cA1vDf1PpX5e0CKRhZX6srtjGlWg+1CYP9zdniGhWWhiIneHXQkCm7C2cAGSpMeaZgo/g83C+43ZOcU9u2Rd2SQWbDR1L4O+w8AVMTV+/Z9NIvlC0v6ggeYar28QFAPXgFRcIaOyLN80aeOKt4qs3rDv6kY0WTu9iG4FAdG51K/uwXz/V8q4r3QObpHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD03sLubL10YN4tSsHjhX9KVyHHvSUsY0j4OSEA8cvg=;
 b=tt9SZqauZrh4QLnqZ39qSFU2QFqm20GBnKRQ9ggVFMkbWBssFjNibGlWF40aC/fQ/nyAbIQSRt4lT5u+1Btggl4cpKQsEdSpMHXwegLYfCJX8qIFbWeEkkALa0lMBz/Jy1QdBSbEefWbgjfQl3oiIHjyM9XOOep5cXzVrpWAHQ5X7gsEW5r8h8S8EIGolJKpXuKlHdUO5mFhmcuZJF5ENF9OJaUs7kt46qmp/2o7CPHKRzgWNmPxTki2KNMEs+hySPXw4rWbKU/QqU6PGetmdb1qrfgzpNauonV8fr38j6EIkwDDcpRH+pAZw/vrnRIoOseFIhoM+UmMDe3/lKPZSA==
Received: from BN9PR03CA0346.namprd03.prod.outlook.com (2603:10b6:408:f6::21)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 12:13:53 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::b4) by BN9PR03CA0346.outlook.office365.com
 (2603:10b6:408:f6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Mon, 22 Aug 2022 12:13:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Mon, 22 Aug 2022 12:13:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 22 Aug
 2022 12:13:51 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 22 Aug
 2022 05:13:47 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Mon, 22 Aug 2022 12:34:25 +0200
In-Reply-To: <YwKeVQWtVM9WC9Za@DEN-LT-70577>
Message-ID: <87v8qklbly.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2c2266-f83e-4213-cdd1-08da8437c750
X-MS-TrafficTypeDiagnostic: CH2PR12MB4971:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWccO9CJImqYZIjZcEw5DIWsfoUqVJfWF5BCxCCRtvkw9HiY/2CvOSLnPupaLbSu8Pn8Z29Y+3DqqqHcvT3w7aZlA6ZIalHU20fxe186uECaUkj7N2WZO+K+wnZZlTBy/3dHUoxtck0I1NzVK03nUTB9TnzVc6N4M8zYgnaDSfVp53Bzu/Ba9Ecdh0mh1fY6pYO3dTzzGxUJB3Kbc2j4W/p5+cJVEa8BhFy845XuBqAACBkAp2Galv5NzXqn/39cyX8K30omVECpw6COEEGHRcWMab8HP183IFHTS9c7WxsMQl/ZMZh4rPs/so1afcBFCmKGp9ZHMWXjJ9ZrefanMDn9TaRoJ2oXerQMrHAZWau5vLof+HxILOppWkQaP+1DJ3WlY5PpCVk5J/LQpbQab8sj5eX9YiQx7EheGqRnnOtlQIy9vUR803U48vQRkMPulm4JdI7a+TCgCABJ601wR6OWB37OIY9KKrBn4vp5yTa2qrTIJEl5YRzKyGLpvelm5DpPhtAI+dY8n31KjBhBuAtUbeTvQhmdvPtSGkJAjRpglCeEcYiDOuzF8h0LYiZqGkIbskXKnHViQAD/9RhPF9sTvjFdjzAlmdgTlugpPaqM5wjZAn9CnoDySJ7VkHr8iSZCyc5G+sXTxqyb4qOVCry4hRX0QzthmqOEiA7EZmVP0Xb4YM6cn3jyVz3MFVFccIprZ/0ky+Kq8FJJxxICxDi8ubc4RDHQJKquhYmoUI+Y9wjK/K92K/q3CSLxdnGRo9si+pclP8lwXL7P68jwPZc7aCgxuhX0jZDe/yflMQAKA4UrjrJ5wYVaFguy5aHt
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(40470700004)(36840700001)(46966006)(70586007)(4326008)(8676002)(70206006)(82740400003)(40460700003)(86362001)(356005)(81166007)(5660300002)(8936002)(2906002)(6666004)(107886003)(41300700001)(82310400005)(26005)(478600001)(40480700001)(316002)(83380400001)(36860700001)(186003)(2616005)(6916009)(54906003)(16526019)(336012)(47076005)(426003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 12:13:52.6344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2c2266-f83e-4213-cdd1-08da8437c750
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > In the old thread, Maxime has compiled a list of ways we can possibly offload
>> > the queue classification. However none of them is a good match for our purpose,
>> > for the following reasons:
>> >
>> >  - tc-flower / tc-skbedit: The filter and action scheme maps poorly to hardware
>> >    and would require one hardware-table entry per rule. Even less of a match
>> >    when DEI is also considered. These tools are well suited for advanced
>> >    classification, and not so much for basic per-port classification.
>> 
>> Yeah.
>> 
>> Offloading this is a pain. You need to parse out the particular shape of
>> rules (which is not a big deal honestly), and make sure the ordering of
>> the rules is correct and matches what the HW is doing. And tolerate any
>> ACL-/TCAM- like rules as well. And there's mismatch between how a
>> missing rule behaves in SW (fall-through) and HW (likely priority 0 gets
>> assigned).
>> 
>> And configuration is pain as well, because a) it's a whole bunch of
>> rules to configure, and b) you need to be aware of all the limitations
>> from the previous paragraph and manage the coexistence with ACL/TCAM
>> rules.
>> 
>> It's just not a great story for this functionality.
>> 
>> I wonder if a specialized filter or action would make things easier to
>> work with. Something like "matchall action dcb dscp foo bar priority 7".
>> 
>
> I really think that pcp mapping should not go into tc. It is just not 
> user-friendly at all, and I believe better alternatives exists.

"better" along the "more specialized, hence easier to configure" axis.
But DCB in particular doesn't address the SW datapath at all, and if you
want this sort of prioritization in SW, you have to fall back on flower
et.al. anyway.

> So a pcp mapping functionality could very well go into dcb as an extension,
> for the following reasons:
>
>  - dcb already contains non-standard extension (dcb-maxrate)

Yeah, and if the standard DCB ever gets maxrate knobs that are not 1:1
compatible with what we now have, we're in trouble.

Whatever new things is getting added, needs to be added in a way that
makes standard collisions very unlikely.

>  - Adding an extension (dcb-pcp?) for configuring the pcp tables of ieee-802.1q
>    seems to be in line with what dcb-app is doing with the app table. Now, the
>    app table and the pcp tables are different, but they are both inteded to map
>    priority to queue (dscp or pcp/dei).

(Not priority to queue, but header field values to priority. Queue
assignment is "dcb buffer prio-buffer" on ingress and "dcb ets prio-tc"
on egress.)

>  - default prio for non-tagged frames is already possible in dcb-app
>
>  - dscp priority mapping is also possible in dcb-app
>
>  - dcb already has the necessary data structures for mapping priority to queue 
>    (array parameter)
>
>  - Seems conventient to place the priority mapping in one place (dscp and pcp/dei).
>
> Any thoughts?

How do the pcp-prio rules work with the APP rules? There's the dscp-prio
sparse table, then there will be the pcp-prio (sparse?) table, what
happens if a packet arrives that has both headers? In Spectrum switches,
DSCP takes precedence, but that may not be universal.

It looks like adding "PCP" to APP would make the integration easiest.
Maybe we could use an out-of-band sel value for the selector, say 256,
to likely avoid incompatible standardization?

Then the trust level can be an array of selectors that shows how the
rules should be applied. E.g. [TCPUDP, DSCP, PCP]. Some of these
configurations are not supported by the HW and will be bounced by the
driver.

(Am I missing something in the standard? It doesn't seem to deal with
how the APP rules are actually applied at all.)


Another issue: DCB APP is a sparse table. There's a question of what
should happen for the e.g. DSCP values that don't have an APP entry.
Logically I think they should "fall through" to other APP rules as per
the selector array.

Thing is, ASICs probably don't support this "fall-through" feature. So I
don't know what to do with this. Kinda brings back some of that TC
complexity, where you need to add all the rules, otherwise the HW can't
be compatibly configured.
