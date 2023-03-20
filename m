Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C506C109C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCTLTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCTLTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:19:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F2A3586
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 04:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5RRX7p4kG1nirhMTNTIlDNhNxv4840lZX4ONGQtGEYFc5PekUj0Q6uSvCSIDfpM4WcmYpvk/0L1bpPmBhZESSQSOBNTpFH0716xvTE9thHsRvkS9h/EPz4Pk5YBbML2YFRJCWxean7+00uPhuwGktfF0YyLX5dwt3GsC90a6XwEejdEONRgYp1u+sfFbwGHSVY5trwEPrumUH/SmspOTddn/sIC4IGGbR5CB11/hCZUmhyiPARI337doSkqRYzxe9a6iuE+vR0nwKxiWVbbDyCR3ky0HaXyL76mGkps0+NH6vTRz9P9NvsjF1hKoVXM+5crIpna1H+T1MfYuqsHwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0//pY4h8JB7ROGWHoxgUhK0XcmAjlb5wGs3apGzcCRs=;
 b=Nq3bZ7LNGDk61fRhFjtf1y11i86Yoj4RreeNyS4IQYa4Dkv0l7bB7QJC+p6/CFg6BsRoPWOwySt6f+E/on7dcoUYzAig8mJcl/A7qPCa6wnsCzQ46zukieh1Wz+ZPK5UOLmuUSU2BITmb4C1ISTr+ZyeVrjcSbYgwbodTKEPPL4Tf7WFYp8FdPB2EaILsSjgph21tz5U1HoJ2AI4wV9Gq6WeL425uFrAJZmlITYurC39atwYaWO75JrPXzTUy+B7VPJyHQiH4tSy/9v6LWoZmB4HbKO3cFNhvQd5jUAeR8D7uKgaPtyUY01pQXCIkp7BZN+AX8cuCfxa3rCusDPKXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0//pY4h8JB7ROGWHoxgUhK0XcmAjlb5wGs3apGzcCRs=;
 b=nzaM5EoTHW0H6qJve6AT57rqtLiOXw51GdpD9POLF8MBIiKi6URuaVQ50TdjqVD1CDyfuiFAiK3CMjf+0ulqsukT/2qJfxB5lsnSMZtvdYhJWwYXg8mOtt+JWnnaaxManA1e0klYswcneRxTRjWelfg7mja1TUvQBxb6BIRJFt6zGLqImk7z1AQeGoLQd/rHo4Nzwab5gc7lxo17FITP6mH02igN00zc8aOIVAiJaaMXhrHbFrHAFwtSpmSuhGLhkZe2XKbmL1MJ9IJFNpL/c6L0+kC/4ruYneWdpU43jRF8kDEJkik6rNKmq3GqIkqQJ8NnGyfSr2pgHSXzHltupQ==
Received: from DS7PR05CA0007.namprd05.prod.outlook.com (2603:10b6:5:3b9::12)
 by BY5PR12MB4966.namprd12.prod.outlook.com (2603:10b6:a03:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 11:18:52 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::d7) by DS7PR05CA0007.outlook.office365.com
 (2603:10b6:5:3b9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.15 via Frontend
 Transport; Mon, 20 Mar 2023 11:18:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.15 via Frontend Transport; Mon, 20 Mar 2023 11:18:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 20 Mar 2023
 04:18:41 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 20 Mar
 2023 04:18:39 -0700
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com> <87y1nxq7dk.fsf@nvidia.com>
 <87ttykreky.fsf@nvidia.com> <871qlnqt7k.fsf@nvidia.com>
 <20230317154541.e74slo6bqh573ge7@skbuf>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Date:   Mon, 20 Mar 2023 11:20:19 +0100
In-Reply-To: <20230317154541.e74slo6bqh573ge7@skbuf>
Message-ID: <87wn3bpt6b.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|BY5PR12MB4966:EE_
X-MS-Office365-Filtering-Correlation-Id: 0202eb0b-de09-4874-ffee-08db2934e553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAiRjyiAF8VyVIYOoOexq3xSx36/gDGCggOmAdH4VkdrIH7HWYIGTuAkBCIog7Mg+yS350I/YBpv7bH2pXXEj5FJoIbZkO5stcV0EMMrBkmwp1/XQ0xNtvYUEKyz3DySMdXaKAITY2Dirp/rncFo62iPPzmBE2lGiUmyygkh7Orq6BMijmf6w+eUG1g30K21JG+IE27PLJ9JyPWSg0/JzAEDKJYZxRaviEvuMeJtKg0fIKtLq/1CDtWNmlxuwOCUu3WSqIv9viOKCNpQ10lrIdR9yMUx2AcFfrz61qxBfcRTwEE5x1z5p30mvodTPd0nSu4f46Ez0i1QWEM00E6p8SD+Oc55hWW6cL2UDNoLT9VnCUeHXPBIj8zYXpc4yzF71K5khDK4Tx8nJguN2hmfxq5r/eLLbRrXHsqT2CnffJ/OElTXwgHRApmvARb8MNKmuqHUPn//h2nX3owRwSm/nMfpHFdFQ2wOtJbR/CY6V57h7z0E4c4epa1+bjBpCvqlFtGqu9detTnPTDZnSodfmmGl07GM454weit92j5/+IPf7EG+8msmKW6owN3qPKElUGwhvxhfv+X4i5HFlhfOkH38Uxt1iJ6S1S9qXNsvnwmlQS1Nh3ri3Vsri0a+2kErsSvlqEyjn6a4FrOwjYmXtfThv7zNe/ojr3GXmCpQ7REVEpkKOYY19Im+mk6LabxN36FmpZe6jIg+REes8gNRKRnYFzd8QbIjvq0Kr4Hv6AhS3+YhmiliwQ5quXUlCTrfBw1IF+F0BEWO/Mm4LmlCuA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39850400004)(376002)(451199018)(46966006)(36840700001)(2616005)(47076005)(16526019)(186003)(426003)(966005)(4326008)(478600001)(83380400001)(6666004)(336012)(54906003)(316002)(70206006)(70586007)(6916009)(26005)(8676002)(66899018)(36860700001)(41300700001)(8936002)(5660300002)(7636003)(82740400003)(2906002)(356005)(82310400005)(86362001)(36756003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 11:18:56.4176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0202eb0b-de09-4874-ffee-08db2934e553
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4966
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Mar 17, 2023 at 04:35:58PM +0100, Petr Machata wrote:
>> 
>> Petr Machata <petrm@nvidia.com> writes:
>> 
>> > Petr Machata <petrm@nvidia.com> writes:
>> >
>> >> Petr Machata <petrm@nvidia.com> writes:
>> >>
>> >>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>> >>>
>> >>>> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> >>>> index c6ce0b448bf3..bf57400e14ee 100755
>> >>>> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> >>>> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> >>>> @@ -2,7 +2,7 @@
>> >>>>  # SPDX-License-Identifier: GPL-2.0
>> >>>>  
>> >>>>  source qos_lib.sh
>> >>>> -bail_on_lldpad
>> >>>> +bail_on_lldpad "configure DCB" "configure Qdiscs"
>> >>>
>> >>> ... lib.sh isn't sourced at this point yet. `source
>> >>> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
>> >>> would need to be below that. But if it is, it won't run until after the
>> >>> test, which is useless.
>> >
>> > I added a shim as shown below. Comments welcome. Your patch then needs a
>> > bit of adaptation, plus I've dropped all the now-useless imports of
>> > qos_lib.sh. I'll pass this through our regression, and if nothing
>> > explodes, I'll point you at a branch tomorrow, and you can make the two
>> > patches a part of your larger patchset?
>> 
>> (I only pushed this to our regression today. The patches are the top two
>> ones here:
>> 
>>     https://github.com/pmachata/linux_mlxsw/commits/petrm_selftests_bail_on_lldpad_move
>> 
>> I'll let you know on Monday whether anything exploded in regression.)
>
> Thanks.
>
> Side question. Your bail_on_lldpad logic wants to avoid lldpad from
> being involved at all in the selftest. In my case, I want to make sure
> that the service is disabled system-wide, so that the selftest can start
> it by itself. Is that the best way to make use of lldpad in general in
> the kselftest framework?

^o^ I don't see why not. You could bail_on_lldpad, then proceed to start
it, then stop it after the test again. Maybe the error message needs
tweaking to work well with this use-case though.
