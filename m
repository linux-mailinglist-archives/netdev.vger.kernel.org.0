Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1FD6B78DC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCMN1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCMN1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:27:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970E45CEDA
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:27:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJmk+bjlMztv8cMcMFkNaKileYuKaaMHG+gz93Yao9qol1a9X3Cy/iM/k2o/sfpsQKHPhcSbcQDvGSsC3rOj6yxTt6zxK1H6igBOYGXQ9zpYYikinUawM/Ie+p2u3pg5GPkoJcFELzELiy6dq4ESyELtiUa9uhZ6fh30iKEJysfdtrlP84tXBzv83ehEPWVgo0wBhyPEsYqmyWBkPegpRUZeLRvDbQY7X0ykmePFDXqnFIfcBpyXvqxEXvzyXm9juMcHRN7RcxgyyFSBZFmP+4UUrn2lX7v58ZDtxggGZX/S0WSOOPfykGhZKdteBUKkSjvlY5mQPoLsW7RHVHf8zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qs0XACHJvXCxV9D3FzvfoaIz58Eml35wsqnWucr1e0E=;
 b=eK3BHBFLJv0VEu4gAFVcCBSYIqZo95ag5iLsNipeDyTjdQDjx0lAxyk6nAqlCj0LD8ldGhD6ge7eAJ3RdbzNQsMpLmSlu4d6DeQeSR0tItAxLYKIy516MZc8ayAJgGv/zfzNCzLmhM0USjEotemHSyKt5W3akRrx/umY1kkcbrfptpqAO11VDkGWYBi6teghxJC8c/GM7Lry05KTV+wODEL4yu9ZjSz+2P8BAumGXQvJ3SwbjEzZIlJvCcku7Yq+TnIwBieeUtlfiZqJxjZoBp5wTiG95+vIchrqok0RgJ2n//vZXOnfq04cMdW6yNRUu6EE7idnadnpejqosHww5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs0XACHJvXCxV9D3FzvfoaIz58Eml35wsqnWucr1e0E=;
 b=r36Myzz//Ds3OF0Fr5EQ3ShtdDroNtXoUuaey/CS73Mf+wytisShVOmVfMEz91+U3o5w2FxQhTqcxAhoRQIIm5ACrOKjsX3a/hxI5jLrG17ugm3n7kWcaB2lOqCRH6BFBEjo/8tFAO1rukp33RKUwTcs4882Qa10/+YHnBT0XfQGRLiyO85LUjbgDJbxRhMm3ZHMD6ulAq9JiXuD5m3TlxZJ+Xy2pvTdK4glQoSTgQ8oferX80R4b5Z2m+sY9m5uzMxmYqAQXdlP511Hs0qeiMZdaNUwKbN3/Zk38V3v+9PLiXbH1qL1a1yvTRH/zV/qJ1CLvKjesT0Cte7BHVdqvw==
Received: from DM6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:40::35) by
 CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 13:26:58 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::7d) by DM6PR03CA0022.outlook.office365.com
 (2603:10b6:5:40::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 13:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24 via Frontend Transport; Mon, 13 Mar 2023 13:26:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 06:26:51 -0700
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 06:26:48 -0700
References: <cover.1678448186.git.petrm@nvidia.com>
 <20230310194125.33ca44d7@hermes.local>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Date:   Mon, 13 Mar 2023 14:17:25 +0100
In-Reply-To: <20230310194125.33ca44d7@hermes.local>
Message-ID: <87wn3ksrxl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: b426adce-de5e-439c-de42-08db23c69f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSnBu23LoiXMaWXJXqUMNPYLxYFZDorsdhcjL71V+kR/1ME7MnDLsztCssZ3j2zlXDlouhpUB7UbC8+eaueWEXWXnGO+gO4JrCF+RGgpCiv7yVJuBuoHWEUHgFKZ0LjZpZ94+Sql2lV12U1jV3KyBuc47gnsad2FjAfoc2VnfvDG+YynsmUgZdfAEO/KCxA5lHwbGzLIoB48XCab5Z1B8Iuaup+Z1iuf1WDG63z09Qy3hC9qqm3OaCIW7KT+EeDOJxpO8oTcs3xeNJJup7tJ9xlOoE2KWOiNEXdJvBFNZ0R+hoqeoiSNUZ0gu0A2W99P1OFcLRKQKYVaap2lY7L5kQ8ws6152YTHAGaxdkvJoNr5lSYZmXVtDFItiLhKHLr8h0/CIn7d9MH9HIvTeHuT5+OPBHJCAzntgQ6aXODBX9ZYokU4xu18CvFRDUwHImUuaInFFt6xoVKzDJigPQY0RmfTzkgVIxWBNIdkABt1X/gEOSZFxxYaTedyuD5WnCs8qFsYHklKXkug56YF6tQXdo+3jIRYeRU8/j1iE3TPm8SBwbpHDQhtFP7iliIOemU01gVGbxAAOXEHmu6qyzscGIyQU0KwetXbYz+yycHI5TOhH7NoqZknHEDK1MhzS+7a+FJCjQX21zaCNsE58cFkGle5lJdPlzqy/vnm/EUMAxgHAvLD+4nqxSiQ9ZwOO312zTeFJ6NEmywf/KmUvkhKiJmeFCa1wrHz1Lje7u+Idp1Qk/gS9iJgWZwxgZYqe4h4
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199018)(40470700004)(46966006)(36840700001)(82740400003)(426003)(36860700001)(82310400005)(356005)(2906002)(70206006)(41300700001)(8676002)(70586007)(40480700001)(40460700003)(4326008)(478600001)(316002)(36756003)(6916009)(86362001)(54906003)(7636003)(47076005)(5660300002)(26005)(2616005)(336012)(186003)(16526019)(107886003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 13:26:58.6375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b426adce-de5e-439c-de42-08db23c69f67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Fri, 10 Mar 2023 12:44:53 +0100
> Petr Machata <petrm@nvidia.com> wrote:
>
>> IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
>> which are used for prioritization of IPv6 addresses, these "ip address
>> labels" are simply tags that the userspace can assign to IP addresses
>> arbitrarily.
>> 
>> IPv4 has had support for these tags since before Linux was tracked in GIT.
>> However it has never been possible to change the label after it is once
>> defined. This limits usefulness of this feature. A userspace that wants to
>> change a label might drop and recreate the address, but that disrupts
>> routing and is just impractical.
>> 
>> IPv6 addresses lack support for address labels (in the sense of address
>> tags) altogether.
>> 
>> In this patchset, extend IPv4 to allow changing the label defined at an
>> address (in patch #1). Then, in patches #2 and #3, extend IPv6 with a suite
>> of address label operations fully analogous with those defined for IPv4.
>> Then in patches #4 and #5 add selftest coverage for the feature.
>> 
>> An example session with the feature in action:
>> 
>> 	# ip address add dev d 2001:db8:1::1/64 label foo
>> 	# ip address show dev d
>> 	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
>> 	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
>> 	    inet6 2001:db8:1::1/64 scope global foo <--
>> 	    valid_lft forever preferred_lft forever
>> 	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
>> 	    valid_lft forever preferred_lft forever
>> 
>> 	# ip address replace dev d 2001:db8:1::1/64 label bar
>> 	# ip address show dev d
>> 	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
>> 	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
>> 	    inet6 2001:db8:1::1/64 scope global bar <--
>> 	    valid_lft forever preferred_lft forever
>> 	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
>> 	    valid_lft forever preferred_lft forever
>> 
>> 	# ip address del dev d 2001:db8:1::1/64 label foo
>> 	RTNETLINK answers: Cannot assign requested address
>> 	# ip address del dev d 2001:db8:1::1/64 label bar
>
> This would add a lot of naming confusion with existing IPv6 address labels.
> And MPLS labels.

The confusion, if any, already exists. ip-address just describes address
labels without any regard to ip-addrlabel, and vice versa. I can
actually add verbiage here to make it clear that these are separate
concepts. Likewise for UAPI headers.

> See man ip-addrlabel for more info.  Can't think of better term for this.
> Tag would raise conflicts with vlan/vxlan tag term.
> Name would be confusing vs DNS naming.
>
> Also, most of the real world manages addresses through automated services so
> doing it with ip address isn't going to help.

Yeah. IFA_LABEL exists now, and likely isn't going away.

FWIW I think all it takes to clear up any confusion is a bit of
documentation in man pages and headers.
