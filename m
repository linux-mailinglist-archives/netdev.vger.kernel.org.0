Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A122D5A034C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiHXVbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiHXVba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:31:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1B152E46
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJgWxuaBxP1DG+Beb42Uii+DP1IO66WMkjoG7eusuLt2ivLjt6bDBKgq4WU6vORfeaTvC/BzMdL49Gqx8XwjJwKs1XKiXCwrxPec/hlqq01zqy262b80OHKP0wxpgU8Fb5bfasmbvzKsSKwd7XVekReytjpeAS7FXLvYwkfozJo23ik2S2y3ff2zkUu+Nc5vjRiEEXy1RoEexb6/nxjYE26njVYqca2S6mgbzPCeJH/lHlqkabt2MmiIpwhHG2JEdM68+GzPnyMOI7+pcd94Ae7t06v78qr1oAP5CIydLA+9T2gy9PVBkRIUGu53eVyCU9M/nR/P/e4t+iCr0otkPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CN7H8q0ymifIidGGoT9SfygN8s/Adz5WxUGjDEGoIAg=;
 b=d+S4XPCygmpy8PJAQkOjgJVT9wbKJkH9vEtaqG0J2L2QlJdtSxPMvMLW7YijyjcC4JJ0p8486O2kT+WNSYKOyPP8H5JLcwl0q/fSuCPvCrK4HuIYOyor3aLOlolsd0Bk8qVVtR9JgGY8D7Ds++uiVV1I2bqk3sGJVLPsc9LstmBc41dGvMyPSLomRGsyKOL84bce3XqV1jUzZs//WpA55UrqCD+z5adVithuclLhLIpUnoCjigQr+DFSu4rf5+nA9XAmQJjiJRLBauPp6mDKl7CXeIhA3tvBfOhtvWvNksPT36lLzoNDZGbRQNQ2lBrGmyuovgT2ZSLGvNr9guwWJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CN7H8q0ymifIidGGoT9SfygN8s/Adz5WxUGjDEGoIAg=;
 b=bsBNfGtBQcu/NyUBSqltLv21m7qVItFV16q9oinqv9TY4VjMKpd99MYYvR9mVBvEhQThfJylP0pOxmy6HgFNs39PATdmWL7hvwSsqv73pk5NCiMnSM3iFegFsT/nyg6uuGEXWqIwPJGsPpmK03td6qlJ7+nxh2pwW7vDy1uiXVwt3iq6ii06LIwxDyeOMkwnrwZ4EcEZYFNOxJ20i+gBtU13d6WAJaJyF1jKlTU17qAhwc+YrN9EBjxjZk6UIgQwSpZibdTiRXCniHu9TQYvpVhmFjcPpa71k01zGd1aZVtQiwKUR0ieWl/rtfY/B32Tl5ndb+8myBk5BEw/BiFCCQ==
Received: from MW4PR04CA0054.namprd04.prod.outlook.com (2603:10b6:303:6a::29)
 by BN7PR12MB2610.namprd12.prod.outlook.com (2603:10b6:408:22::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 21:31:27 +0000
Received: from CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::c) by MW4PR04CA0054.outlook.office365.com
 (2603:10b6:303:6a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14 via Frontend
 Transport; Wed, 24 Aug 2022 21:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT079.mail.protection.outlook.com (10.13.175.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 21:31:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 21:31:26 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 14:31:23 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Wed, 24 Aug 2022 21:36:54 +0200
In-Reply-To: <YwZoGJXgx/t/Qxam@DEN-LT-70577>
Message-ID: <87k06xjplj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6839bbe-8bbe-4400-9eaf-08da8618006f
X-MS-TrafficTypeDiagnostic: BN7PR12MB2610:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pG5ElA3JGGyKi9N3EdbpRoYHOHAuUkU61+JWbXcQjMYQ+VBbI3l6icNghzAdN68s8Gxzz0blx0lpVNjDQVHFklZSTXSaBWXLA8Lf3MU4FTi1c8v7yVpjFwde8TYrI+WnqKGYm7cvTQsaIWoKNYcknP3qQRUbxiVlT0jfoesYUfwE7ejnS4wq3vygLMV6j/MQTmNHDvmbSx6Yt6m6duiKGxAJ2pCwW31QZn3RuuHhXNhJBt05P0aeJTX0ZYLIYV1Xig/qr2V5aUNepnZ0XiZ3NOeG0/KIgw9JGRNwtWKQ2OwRpBDzvWnQeDmGu7lHd+WO/IN5PXHSng/9lFasD8Xx/jAEfKHIuQ9nG1/iKe9brpQDAeFnk5su3ddw2B9iQqI7NUbdEEM+ckYUe4TmAm/9PD+bQaENKdmW+YiliOMeQGOEoIrzWHApCAYrF070ow1b+wuGWqBmkbQFfrEGUAKFVC2TgR5/iXvjNvxY4qs33HlLW5y/ZfAFXXxO6HYc7dBUCnNY5qU01AH0t7EuoD4MdzMLUUrNG1eHX7veI3kHtojIee54s1eDa9I1fh4WamZf8MKgwD6fMWu9OTVSh1FtwfCfh0yydp+Qzlqo8PxQ8PlK8TiI1IsV9r4HbuIHYUDmuj9gAzCtkPS/C5vGCpmRNj4OtttIiwpaXd/IjvpWQ0J1WEYUzlOQRPUmcMx6vO3cNfhfsNnQWmfkHdTDG3yqg/iqddRfAODunVKHcXfyy0tmN1tms4PWdFAeSjftt6cw2K+oKW9/EQ/isOA5ZgziPmlpdTXKunNTxmsyg77pZv4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(40470700004)(36840700001)(107886003)(83380400001)(2906002)(70206006)(47076005)(8936002)(8676002)(70586007)(82310400005)(426003)(4326008)(5660300002)(26005)(6666004)(41300700001)(36756003)(16526019)(478600001)(2616005)(186003)(336012)(81166007)(40460700003)(36860700001)(40480700001)(86362001)(356005)(6916009)(316002)(82740400003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 21:31:26.9905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6839bbe-8bbe-4400-9eaf-08da8618006f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2610
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > As I hinted earlier, we could also add an entirely new PCP interface
>> > (like with maxrate), this will give us a bit more flexibility and will
>> > not crash with anything. This approach will not give is trust for DSCP,
>> > but maybe we can disregard this and go with a PCP solution initially?
>> 
>> I would like to have a line of sight to how things will be done. Not
>> everything needs to be implemented at once, but we have to understand
>> how to get there when we need to. At least for issues that we can
>> already foresee now, such as the DSCP / PCP / default ordering.
>> 
>> Adding the PCP rules as a new APP selector, and then expressing the
>> ordering as a "selector policy" or whatever, IMHO takes care of this
>> nicely.
>> 
>> But OK, let's talk about the "flexibility" bit that you mention: what
>> does this approach make difficult or impossible?
>
> It was merely a concern of not changing too much on something that is
> already standard. Maybe I dont quite see how the APP interface can be
> extended to accomodate for: pcp/dei, ingress/egress and trust. Lets
> try to break it down:
>
>   - pcp/dei: 
>         this *could* be expressed in app->protocol and map 1:1 to the 
>         pcp table entrise, so that 8*dei+pcp:priority. If I want to map 
>         pcp 3, with dei 1 to priority 2, it would be encoded 11:2.

Yep. In particular something like {sel=255, pid=11, prio=2}.

iproute2 "dcb" would obviously grow brains to let you configure this
stuff semantically, so e.g.:

# dcb app replace dev X pcp-prio 3:3 3de:2 2:2 2de:1

>   - ingress/egress:
>         I guess we need a selector for each? I notice that the mellanox
>         driver uses the dcb_ieee_getapp_prio_dscp_mask_map and
>         dcb_ieee_getapp_dscp_prio_mask_map for priority map and priority
>         rewrite map, but these seems to be the same for both ingress and
>         egress to me?

Ha, I was only thinking about prioritization, not about rewrite at all.

Yeah, mlxsw uses APP rules for rewrite as well. The logic is that if the
network behind port X uses DSCP value D to express priority P, then
packets with priority P leaving that port should have DSCP value of D.
Of course it doesn't work too well, because there are 8 priorities, but
64 DSCP values. So mlxsw arbitrarily chooses the highest DSCP value.

The situation is similar with PCP, where there are 16 PCP+DEI
combinations, but only 8 priorities.

So having a way to configure rewrite would be good. But then we are very
firmly in the extension territory. This would basically need a separate
APP-like object.

> So far only subtle changes. Now how do you see trust going in. Can you
> elaborate a little on the policy selector you mentioned?

Sure. In my mind the policy is a array that describes the order in which
APP rules are applied. "default" is implicitly last.

So "trust DSCP" has a policy of just [DSCP]. "Trust PCP" of [PCP].
"Trust DSCP, then PCP" of [DSCP, PCP]. "Trust port" (i.e. just default)
is simply []. Etc.

Individual drivers validate whether their device can implement the
policy.

I expect most devices to really just support the DSCP and PCP parts, but
this is flexible in allowing more general configuration in devices that
allow it.

ABI-wise it is tempting to reuse APP to assign priority to selectors in
the same way that it currently assigns priority to field values:

# dcb app replace dev X sel-prio dscp:2 pcp:1

But that feels like a hack. It will probably be better to have a
dedicated object for this:

# dcb app-policy set dev X sel-order dscp pcp

This can be sliced in different ways that we can bikeshed to death
later. Does the above basically address your request?
