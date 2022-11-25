Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED3E638AF9
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKYNQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiKYNQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:16:54 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ACA2CE31
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 05:16:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFWlpPpB5NujVUL4Uba8GWGpu0IM4BywDT+/kvTXZrIFlOi28V1uLYNM4gUDXMLSZWwBjlbP0dr8ixmrUM0N+qyI7kDaEctZosuYvGxELVlvypQq9aXOCKQg/mY+rbu3RcNWwVGY3ASWDREU45nJYmVPRf7O4xFL/L28JmEVmY0mOccI3UV/tFCddZGuw4SH9S0JlIfnE5hhHldP5k+NSyN9yxphdYNSaoor2fGDJjbkFx8EGkyQhRsr0bQfjZIOGr1m5a/gcfmGOd7HZKwowS+Mla904sOmoU4EGdU2t9u/IYJRUFZSsEw15QMBSxiDUka0gIsXiK7uiwFcGeJ24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Vjx1oqzGehqdRFgnwCP8fpwU640LmVVjiN9/Zbv7cY=;
 b=m85c6Y4SQCs2BajqcF+p05/tYSZNmUUpq/P3b3PZHP9jw/QwhcxzG7a2LhjbAznqB61aHaHeXG2Vrp65BPtOWvxPPmcZyGQ8aH7PiK//FNKN2mP4QPp4yXpKP0HNqzr6V6GPiiePLhunLd4XGPDZXJ7yYh1CY5JTJO5EvO548Mr0dcaVjAo2bZcsPsHXKqeaWoLiiVeDmoo13iurQM17O5RUqA3ZsTPkI8p/9cMLu4BSobGArkJstntnpWfu+6qpbdLXaOeOyzJ6tGTW+lNPnJ5aeDvNWz0Q505jHMuR6vEG9TZ1Zou+eo35h6gBEI0W5Sk4UdBzKOwUiLLZGLQm2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vjx1oqzGehqdRFgnwCP8fpwU640LmVVjiN9/Zbv7cY=;
 b=D9wzSx/s5ac9CBgDOSJP+rOwNLSzcTaYkb4YaEigVqR6lDrkvZ+O7+UnMYXvefMiZk1gskSccQXIfHyuh2BOw+f8kmtfHc8eLGEuxDuPXCrK72m36ssIu1uITevP3Um2sPB2ODsiWhebu0j6En3ycoCLW1xgG9QsnP47zF2no1AdUyMD2LN+hJBioGW9TJV/J3GJVioRt4UP/FzTO5dOrDRv1fa1aBZpFOJerJHfa+SjEVyX8pTKMWtWAOQt1l9nfZA3gAVVBmnK6Mnh8MfGhmnHMF5H2c1z27MTIMkKxxvcGJwpEraeUKvEIa+PQPvjhY2LBshf1LNpZpzqfClpuw==
Received: from BN9PR03CA0363.namprd03.prod.outlook.com (2603:10b6:408:f7::8)
 by MW4PR12MB7311.namprd12.prod.outlook.com (2603:10b6:303:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 13:16:51 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:408:f7:cafe::b3) by BN9PR03CA0363.outlook.office365.com
 (2603:10b6:408:f7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20 via Frontend
 Transport; Fri, 25 Nov 2022 13:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Fri, 25 Nov 2022 13:16:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 05:16:39 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 05:16:36 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-2-daniel.machon@microchip.com>
 <87wn7kibn8.fsf@nvidia.com> <87k03ki8py.fsf@nvidia.com>
 <Y4CWg3or4zOMh/Ud@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <g@den-lt-70577>, <netdev@vger.kernel.org>,
        <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Fri, 25 Nov 2022 14:12:55 +0100
In-Reply-To: <Y4CWg3or4zOMh/Ud@DEN-LT-70577>
Message-ID: <87bkovi37y.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|MW4PR12MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: 297f05ad-1a80-47a4-9103-08dacee75058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmjcc2mkmmrfyHKE7x5/d0IH0TQRg/FHiemrMW1tH9Jnzgr8RJFz8iMDPmd7Cay3zvoj2yj3Smxj6Gr1mn7fS7SvFLeFvOvgkwAZVOXZom5zybGo7weHA5++D8/AsYEk4WWHOWSGff1xFnxWEvU77QBATe3OZpLEF/7A8d4kj1vJnt2CQUpL4FLU5qXDv0ibLiNDMSVR2FEmUDCiJLX/+qwHei9v5j21l5fpwEUAnlN2VUGBxDpUoMDM13nxCiwoGIDV1DHw6fQgK/2H4tDnhf+69vnTYLTH4ImWgI/RqHHpxJ4szl3jDlw8qbuBi6uS7/dRnhJz41eTIpqyhCRdh5YJqSp8Xh4I8BDELHwalG0354INhnXKBvDBkJZG/cCNGT8273d5ZDhurp/z/ToWtAFq5MoFf/eB3HLKxGsVSET7Q5P0fCftuc7oUKd1SWFnytkTLpjssch/NfhiYM8w7u/tIa+qVrncxXWNDsZAoZGgm7GBqIShkrHiQycrW09r2Gd2mRCpqmQJ9LPhPRfOBD45yLz8kBjZmvmOvNMPtgX20y6qt/RsvRzw+ez6TA4u3/hrSAMdgrUxTw0A2cG/qi66TyITEPcDiXUsy3izV50YDpJ0O9l9eLlEsLWj/VNQrIDzLF0QZwwjMsoUiWiw7lkivKhyIy+BVjToRuaV7LnJWcoiR8fsb2xlg01RWh+yj/gjuS7D98K6Jr136AgEEgriA3IZcIZy1nTYQte6hgzqE2KHiqxAJJRW5uVoZhnR
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(2616005)(336012)(426003)(16526019)(86362001)(186003)(47076005)(6666004)(5660300002)(36756003)(8936002)(41300700001)(82310400005)(26005)(316002)(6916009)(40460700003)(8676002)(4326008)(70206006)(70586007)(478600001)(36860700001)(2906002)(7636003)(356005)(40480700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:16:50.5064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 297f05ad-1a80-47a4-9103-08dacee75058
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7311
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> Petr Machata <petrm@nvidia.com> writes:
>> 
>> > This looks good to me overall, I just have a few nits.
>> 
>> Actually, one more fairly fundamental thing that occurred to me. If a
>> user doesn't care about DEI, they need to do this using two rules: say
>> 1:1 and 1de:1.
>> 
>> I wonder if it would make sense to assume that people are more likely to
>> not care about DEI at all, and make the 1:1 mean that. Then 1:1 would be
>> a shorthand for expressing two rules, one for DE=0, one for DE=1.
>> 
>> If the user does care about DEI, they would either say 1de:1 or 1nd:1,
>> depending on what they want the DEI to be.
>> 
>> If you generally agree with this idea, but don't have spare cycles to
>> code it up, would you please just make the PCP keys "${prio}de" and
>> "${prio}nd"? (Or whatever, but have the syntax reflect the DEI state in
>> both cases.) I think I'll be able to scrape a bit of a free time on some
>> weekend to add the syntax sugar.
>
> I think this could be useful and 'de', 'nd' (not-drop-eligible?) is fine

Yeah, no-drop. It could also be de/nde perhaps, I have no strong
preference here.

> by me. However, it is perfectly useable for me in its current form so I
> wont object if you can find the time to code this addition. Is there any
> reason to add the '${prio}nd' keys upfront?

Yes, so that the semantics do not change. Whatever 1:1 means now, that's
what it will have to mean basically forever. That's why I'm asking you
to change to 1de:1 and 1nd:1, so that the 1:1 syntax remains free.
