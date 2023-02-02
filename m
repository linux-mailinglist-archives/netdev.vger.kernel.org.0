Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838DC687BC4
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBBLLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjBBLLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:11:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F9B88980
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:11:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoEZQlb/GK96Hj+9Gmq98120rcW/TSQ3UQKF4MxFuiEtKCHZ6wBb0GCCpuZ61uFZNZFHTbwXb45JsHxLhRlT23iqPQA5pZMyKQ66voThRSi0PylJTUEiPB95aOHWoXPtZ6cHfqq6qh3JSRsolAnDkirhKuJBAYKfQRMMBYV503c47fzKJcLrS93Abcu6UmbvJNCpkT3d7hPxOpt63RtCDCQVQKSQtJAl0hS0kowfm/zDvuGjV0hfP9PoR7JoG7nmOLE19mn7nGnD348DhEcSe5k9NdfCvi0zdozhUaQ5aQdKsGRkiZzNv8lgVHdnWZ4+Q6Bv4QKPieyBcImj1NoRnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKnfzw/ViIlREqwjQaW/erWOkesMY9oYi+bz2iUs/0Y=;
 b=eCmlSLDdNOwBAZoTLjAioeKWd7ZIdWC6JpwE1HZc/fwiez3+ZzM9+3tGJO2HTO6gIUnb2lpWXq9lBpvqLYuYxiwRvLT4nqZ9XqEJnVnGzqC/DuWZq+QNoHtAjfFVwjZ8643wkGvwAnL89BiZiLna2rsVd8UWBVWy5Op6NEQvJmYyMjDxXZ8SWQf1tT1UE4LZytlY19KbEMYA9IEKbn4JRxZ+Y80OW/9Mjn71OxPhflidENq5dJ+TL/vQNE3+z9mx8O2QMVGvirj4YVqZ2FgRBvMa1t4bDHK/Z6w8KDd0sPsMkFwFxC8hfMaV/S656q26garHwc4SFw7h1EnJQDitOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKnfzw/ViIlREqwjQaW/erWOkesMY9oYi+bz2iUs/0Y=;
 b=tREmWIqTEJs+68i9aFFssv5LzhyYKBOfroMf80Qt/YvcvH9a2n4QV1Ewbelby7XD2HbYFYI6xsHdQ3GMGL/P+jKq/iJR+J6+UIonSfbYwRSs03mUpPkpOMIcfTrSrzs5R/QJF31ARLMmBLPSJwGwO59QzqheMgwwGi6xR+O11eBZ5gKB2ak8HN7coG8TAzeh78vj8CTTV9/Z4m7viSUcgO2n0L/LpJ2qM8WmrhnBUZ+3fCN/32N3o0P3IYkWpuTP7KEj61VasEXZQEHnq//lbAqDbmvQU7gtmQ8ah1js5I/ziu0XMf+ZL5Lumj0sciqqYrPxb/PutnrHk3vN8uweQQ==
Received: from DM5PR07CA0050.namprd07.prod.outlook.com (2603:10b6:4:ad::15) by
 SJ0PR12MB5664.namprd12.prod.outlook.com (2603:10b6:a03:42b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 11:11:05 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::3a) by DM5PR07CA0050.outlook.office365.com
 (2603:10b6:4:ad::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 11:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Thu, 2 Feb 2023 11:11:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 03:10:55 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 03:10:52 -0800
References: <cover.1675271084.git.petrm@nvidia.com>
 <706d902460b69454ffeb57908beb8dce46e9b064.1675271084.git.petrm@nvidia.com>
 <18e82e5a-1ee9-94ee-78a7-15bc08b62978@blackwall.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next mlxsw v2 07/16] net: bridge: Maintain number of
 MDB entries in net_bridge_mcast_port
Date:   Thu, 2 Feb 2023 11:09:30 +0100
In-Reply-To: <18e82e5a-1ee9-94ee-78a7-15bc08b62978@blackwall.org>
Message-ID: <87v8kke30l.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|SJ0PR12MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: 4932ef26-27cc-4563-4bac-08db050e2d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+xUy1oHeqCkluiN0bD1t+cBgf6SBKbrf06HBGDGDUXJLuNJaSzieuWN4JX4L8cvmFH6/GtBNc/Ji74NDaT6vPbP+oMY4EV835F6lP5ToPlT/8Q17dmJGafgi6sgXZu7I9be3r0HamSXnBoeUPIwiNGuZmXZrgJ0IkqXtZElDiuK4/07M+BmavcPBnknEdmj4QekBCvEJr3/WFvfqPwOrylXsD5Ev3Lw+pVSpWHE0Hm/PBReK7b4BoP18Xzu8MY3ElL1qQLkyZJpXDzCUP82q2qXPVneINOibh2DKn8PHjDRWQA+blsnBTlK30glf31B8wTjAOgbYQAdRswwE5RbBS2qO2X5xlZaeE14epUvR5CIhGb44YDk5Czpeaz4IZw5A3B4CpuHsNfGKlRP3YZPVKzsfjdERA7CXb40Xa+vo4F+13gXkt5+ss4T6X8AWmeA/gz7xvTrV66/Q7xoLQG7/RPgrMAe4OAjcDzwhvOwPd0Lz0alStKJunfc2LVuShY92qgjwFH46MuZU3xrCf1KVH90l9NfJyOQCoC2neTAy59CLA0L325G4TAYHtANn1iw3DsPCOJClm5YSH2wCfz6qacTVvTn0+8Ws9kW9LvOjpn9EHO+PbkYs2vch1Kcr5hBXXxJrl2cJaZ9i/ecAiuP9iwi45gXZ8ou1ksEitGIZ5t3yNqp1kT4CTy3FOpTGoVBiRFj/+qewq51FmugVS1BDQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(8936002)(4744005)(2616005)(54906003)(5660300002)(4326008)(2906002)(316002)(41300700001)(8676002)(70586007)(70206006)(6916009)(6666004)(107886003)(26005)(478600001)(53546011)(186003)(16526019)(83380400001)(336012)(426003)(82310400005)(356005)(47076005)(7636003)(40480700001)(86362001)(40460700003)(36756003)(36860700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:11:04.8651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4932ef26-27cc-4563-4bac-08db050e2d42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5664
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nikolay Aleksandrov <razor@blackwall.org> writes:

> On 01/02/2023 19:28, Petr Machata wrote:
>> @@ -668,6 +692,82 @@ void br_multicast_del_group_src(struct net_bridge_group_src *src,
>>  	__br_multicast_del_group_src(src);
>>  }
>>  
>> +static int
>> +br_multicast_port_ngroups_inc_one(struct net_bridge_mcast_port *pmctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	if (pmctx->mdb_max_entries &&
>> +	    pmctx->mdb_n_entries >= pmctx->mdb_max_entries)
>
> These should be using *_ONCE() because of the next patch.
> KCSAN might be sad otherwise. :)

I didn't see any (relevant) KCSAN warnings on x86_64. But yeah, it
(and the others you cited) should be *_ONCE.
