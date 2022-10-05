Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5024F5F524F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJEKNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJEKNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:13:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857758157;
        Wed,  5 Oct 2022 03:13:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sbd4RqG/HQ9Br/kPJxiD93vpPm3Jm1+7Rva/5pv/34GCPmsWDTGNgf/WccRyEXsmY2UXDkwkzLQ4ROeBoMuR1z4ym8/0608Cr5zw4dzOYmJjpQhzc5a+/Jm/4AFuN64UvKk3g+Lbz+DV0nE94O8yFN0qLbaAcwY4dUxGtzEC82G429TrJjssicZrSwadH7675/9jsK25QfCQfThsqj2l25uZyeGEPqetmuw2LLTdNgYR+DNmrr80loRkZG9SwO2hVkLJ5JogO7YuTns8F2r6Ud3vOLye2LmPXX4Cbo6TF9nXWZqHOLeBtrCkbHUlOsOWJylAG9/7M7KRxAu9Y5Y/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUfQPLPMxtGd6Ph+L5MfqWbnP7Mna7uGDCzItJSUa5Q=;
 b=BCjVZNPSTMs68q6Np0X75WHO3FL+k5L55nUFKFWVAulHh29XVfOE4b0J/mc0DvlzGAIaRteyPyk+C8fEdtTaRoirLRSCZTTuyDPEkCbrQiGJlEUGJU62hR0oeI8Hp2zFdSqsv+hxmg+gJGDNHCzGUSahr0xLc4qk1t3ekPa1QGLlSofpLflyL2mshBrNywb/BlGpHmbITmSChAmr8POXO4T6c67sbC3tnMaFOIJ5Ydx5fiC6RDgwoH0/9EgWHhSsWCzVl+FXr6prnGRMc/2SwMuXGrzWVGXPztb6gkPHaHF86QiqzuozepkzVBl8081a67+kFl8ClKuwS0WToXpkHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUfQPLPMxtGd6Ph+L5MfqWbnP7Mna7uGDCzItJSUa5Q=;
 b=drU4irsnPf2yRD2/IxefsjUtstp4qUqy/F9LzkZtM6kxDEmvNuESKl/rYNZQtCKFa6QKNUXRT3cMU92dYr984mcdrzrxjRF4g+Vp609CoVgyxCOOfXAFK1TtII4iFPBV+lBEn1Qu0oVxg8GwYnIsv1uVoIZxiv7Ownl1ToX5OmW/54lPPgr7CEDT8dqKPulT8ZIEDrLmGt8ovnoIfdx8ZGnTZJ44bzoWYy75EA/VLwDW5yeywIfsS03m1vREPZ4vLr0zdhi4KYrjNtTXXUXTC46zif+LqhHN2bw8Otc6tt+lOtqub/ClRPsamvG8CnPu1dhRAF4cahc3nXfL8qHcAQ==
Received: from DM5PR07CA0102.namprd07.prod.outlook.com (2603:10b6:4:ae::31) by
 DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.32; Wed, 5 Oct 2022 10:13:19 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::3f) by DM5PR07CA0102.outlook.office365.com
 (2603:10b6:4:ae::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Wed, 5 Oct 2022 10:13:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.10 via Frontend Transport; Wed, 5 Oct 2022 10:13:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 5 Oct 2022
 03:13:06 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 5 Oct 2022
 03:13:02 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <YzqH/zuzvh35PVvF@DEN-LT-70577>
 <87czb9xpsi.fsf@nvidia.com> <YzquziZD+T145jo0@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Wed, 5 Oct 2022 12:09:07 +0200
In-Reply-To: <YzquziZD+T145jo0@DEN-LT-70577>
Message-ID: <87bkqqwpcj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: a292349a-5725-4a07-03d8-08daa6ba3a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jv+slg4L2tPR7aKvO5Ax/vgI7p3cXRKkC6zzqK5VXNZtmfSA24VSpggpcCRClaf30CJ2JfHf7IUi39ZW7mAjIe57TQyz7CerAh0jsVPTb+fHZg4YpaKyPdrYkQei3mFfPpzirgeMNPgO09an7AP9EWtKwQbtabq1FMFFRR2TqvpnwDW7eevIR6k/ZNMiVfn8hHmc2Dm8SFbKGme/zTgokvY/9v2FXStLdM3LSLh2vdOGqpINOTzYFdvhc6ua3Ym81UcIjwECVJiSOmzSg+KEltrEWJaqxugg/XtgEG3T518GFUBL9uLSmzajY8/yjeKc09yfOR9G5I1tgurwfZvmrIdkqkyViKVVfG2G9f6CilkDC4sUri2GC5OUjybq6qdPvQe1kGNRNq+eRlOfk80dq3Cw4rSKXH7MOh8jSoku9gUut0AJV6le3kDRyR5Xr85Jkx6IuTJ+qkCp5vBJ3tPxeaRl5uLjEpcWlTjAj6QrZg2Akw5yx2sp+Ss6uqD/XQdfz+vJaGfROoCTsKrR1jMSxFUcZml+LraM3cWZ4q6rcO0N5t5uzNEEaG6iwiAD2dcT8TswXVvVS+0OwYLhqBQKKFUuabGbzmICajJlXtcREwzIajI93gPAvEWDJs0bytUaVbBzZYY6ZM4nD1GZ9bNKV8YjOjASKBqyLtASlXaJmK9wkmmC5YIK7ZchLY8qF2F6P108hTzHGUp4mTwcpxc1w/ZppuFdZpnVx5Y4EHXBdKVW1K9s+PrZ0A/0RPjUcZhHqvEgDnDArdxOkZnyX50VoA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(36860700001)(47076005)(16526019)(336012)(186003)(426003)(356005)(7636003)(40480700001)(82740400003)(70206006)(70586007)(4326008)(8676002)(316002)(6916009)(54906003)(7416002)(2906002)(41300700001)(8936002)(5660300002)(40460700003)(26005)(478600001)(2616005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 10:13:19.4759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a292349a-5725-4a07-03d8-08daa6ba3a2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
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

> Den Mon, Oct 03, 2022 at 10:22:48AM +0200 skrev Petr Machata:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> 
>> <Daniel.Machon@microchip.com> writes:
>> 
>> > Right, I see your point. But. First thought; this starts to look a little
>> > hackish.
>> 
>> So it is. That's what poking backward compatible holes in an existing
>> API gets you. Look at modern C++ syntax for an extreme example :)
>> 
>> But read Jakub's email. It looks like we don't actually need to worry
>> about this.
>> 
>> > Looking through the 802.1Q-2018 std again, sel bits 0, 6 and 7 are
>> > reserved (implicit for future standard implementation?). Do we know of
>> > any cases, where a new standard version would introduce new values beyond
>> > what was reserved in the first place for future use? I dont know myself.
>> >
>> > I am just trying to raise a question of whether using the std APP attr
>> > with a new high (255) selector, really could be preferred over this new
>> > non-std APP attr with new packed payload.
>> 
>> Yeah. We'll need to patch lldpad anyway. We can basically choose which
>> way we patch it. And BTW, using the too-short attribute payload of
>> course breaks it _as well_, because they don't do any payload size
>> validation.
>
> Right, unless we reconstruct std app entry payload from the "too-short"
> attribute payload, before adding it the the app list or passing it to the 
> driver.

The issue is not in drivers, but in lldpad itself. They just iterate the
attribute stream, assume that everything is an APP, and treat is as
such, not even validating the length (I mean, why would they, it's
supposed to be an APP after all...).

So we trip lldpad however we set the API up.

So let's trip it in a way that makes for a reasonable API.

> Anyway. Considering Jakub's mail. I think this patch version with a non-std
> attribute to do non-std app table contributions separates non-std from std
> stuff nicely and is preffered over just adding the new selector. So if we can 
> agree on this, I will prepare a new v. with the other changes suggested.
>
> Wrt. lldpad we can then patch it to react on attrs or selectors > 7.

Yep, agreed.
