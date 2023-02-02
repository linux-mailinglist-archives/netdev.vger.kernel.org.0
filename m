Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5731688104
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBBPEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjBBPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:04:04 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BE31714B
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:03:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoMjQ3LHbhC8fA+zIq5So0gon+axZ4SWMtAj2dUA5viqXAoWxAdBSMoTjIEci3vz/fKVuhshZErrUxC2ZtE4dm+uLXG50W6RZVLyquQxbA9tvvkakexCxC/BTLGW9hb9poUYhAITMNAb5ClNAmQ9J7/P48vKaxFUFwwV3V2FLjUtqJ7JQ8kQbG4gGgVhEUH0QNfOJzTJeKdyQOZ3CWkA2SkmRcLqqO1Lo7SWfKsUMzHs/xaHhdE2O+ROukmJ+wurv9jcP6rIEeTDlCofY9AH0vpp508F1iwQNaNL40Ml290hpiwUZyWs12t7vBwqvmjPugghKsQFBKUcUG0iXXse8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCv5mcp3OevYDuEm0DKpLYtXIRHAu25i6v4vZIFYA7Y=;
 b=He/RYDgPwWbeHDy62vt/C+PnKnRl5oJ/67zoCbXg+G5kMs4k56Bdkb6io3YzBJBi7P4hd/dQJsF9Ml1ar2kQnJH7lFOPsHY0kaiIrPaNIA9FIJo8fCEfDB/YalgLY7Rzm90IXYAI6WE9r/MJzsPC3uanP2tJAyDvHRox+8MAe1DdjMmS/t/5APURTolSzL+hBk5pdUQWrJ3xbpffk/dKlq2NYbxmwg5o02GZHzzoHYHkeD+TEFHilAdYwiMLa0w+b7bjbURIjuEUyxWHFKevmPmd2tdYuirFHq5P5o/zy2R9IF3n8CWTkXbchpEudVtd4phoCiYfqXttuomku7Ih+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCv5mcp3OevYDuEm0DKpLYtXIRHAu25i6v4vZIFYA7Y=;
 b=JqvGXHxHYSpeHyu4hSymUs6BQs2wg3kX160P1ZNky+iKq6Q/wniyj1vUi4t2AAxsr1OfKhrXEW+mQ4UDaKd1tKeYWnIgxqZeDTME2gF7f5NVI6ya2ZlZhN1Unsx6IhDfVcu/8ntQHvUU2nxGbTWGRYrZRQwnL40Pf5wScJCHY0ALAO89iDIqqbKa20dDYAcEnYDwTW577aJ1C+dVLUaJDQrs+Ctw/gDN5GP9Q/0Cy0PEoJT7z8BlCg4WF2SNeicsGn9AxGLuaoeD0jjDuTO6TIWdXJr/RVcEJdOES6/qJqyNdy7RPf+/+NKx5uiU+Zx8NXuGbpn921dvPentkWQdRw==
Received: from MW4PR04CA0036.namprd04.prod.outlook.com (2603:10b6:303:6a::11)
 by PH7PR12MB6718.namprd12.prod.outlook.com (2603:10b6:510:1b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 15:03:56 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::96) by MW4PR04CA0036.outlook.office365.com
 (2603:10b6:303:6a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 15:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 15:03:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 07:03:42 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 07:03:39 -0800
References: <cover.1675271084.git.petrm@nvidia.com>
 <7b9f6524716a9e2ce33b9383e3216fed2f432201.1675271084.git.petrm@nvidia.com>
 <4ce2042b-26f7-00df-a035-567475add7f6@blackwall.org>
 <14fac71d-dc43-bc5c-4d77-3187e066cfc0@blackwall.org>
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
Subject: Re: [PATCH net-next mlxsw v2 08/16] net: bridge: Add netlink knobs
 for number / maximum MDB entries
Date:   Thu, 2 Feb 2023 16:02:20 +0100
In-Reply-To: <14fac71d-dc43-bc5c-4d77-3187e066cfc0@blackwall.org>
Message-ID: <87r0v8ds8m.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT052:EE_|PH7PR12MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e845c01-8b7b-4a8b-28c3-08db052eb3a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsMl/as9UPJkToACzsulx05aRWO7nODb2lipqKBoFsF3zEfzZOacuIq7v/+42wKqYM0xMpDH2DeOcMwgBf/5/qFKq+zTU60/D+6I2LEMY3SLByzaXg6WrxCw/24Mgswysarkxjq/FkyKRPLPvv3IgcHsIyfOQ4dQrkTtm9CaGnX8N4SLcRReNDyVdUP+FVIoPlMcxdUoJqUXyP+viCQjx2vG3r5/sjh+bMeeCBlYRT+mVGlPJoufuXl1WtptPo+r5ZatoGtdbMlTI6wYC8X8jWXA7iMYUCWVROX0YZLmzLwY/pU87utOjInbpl/7OtpQ21chgbsWnkaE0cwqlqzC7WoCuqeX+EgPNl1g/o5+O8Z+5ciGioAo4QpVrKp+SfiACFY+k3kcsQkB5FcBLfG5GF09NAeNvfN8rY2C191kgkaEm45FgRsuHABDl4eq84PcmDXhDHX7EcB+ms3V0ANP8+1/+KBNyn3VzyLzvGmIsrDjMYaqbJPJDoh9nexI2mQWVbl0/7sJ4IPa3yqFnpvg/IHMKRv4Qd2/bs03k8XtoYoTnNFjz2eQsguJti8KZVdT58ycVtRJ2/cCwplrl64c1aHd45t/Ih38Jb+rZrSH3wVRypuDDy9uEydNzdfjEfnu3smYOOBgvS+jzWTPJ5yGGT1btfTQKDKP3msqkaOzNw8SW5lZKYD2+0Ji58wJxDLR01wyE+10cEvMPZiJ11gbZg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(70586007)(478600001)(4326008)(83380400001)(6916009)(8676002)(36860700001)(54906003)(82740400003)(7636003)(316002)(70206006)(82310400005)(53546011)(107886003)(6666004)(26005)(186003)(40460700003)(4744005)(16526019)(5660300002)(41300700001)(47076005)(40480700001)(426003)(356005)(2616005)(8936002)(336012)(86362001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:03:54.2271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e845c01-8b7b-4a8b-28c3-08db052eb3a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6718
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

> On 02/02/2023 10:52, Nikolay Aleksandrov wrote:
>> On 01/02/2023 19:28, Petr Machata wrote:
>>> +int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
>>> +				      struct net_bridge_vlan *v, u32 max,
>>> +				      struct netlink_ext_ack *extack)
>>> +{
>>> +	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
>>> +		NL_SET_ERR_MSG_MOD(extack, "Multicast snooping disabled on this VLAN");
>>> +		return -EINVAL;
>>> +	}
>> 
>> same comment about the check
>
> Ok, not exactly the same. I see that for the max case this check is used, please pull it
> in the vlan code and just drop this helper. Both read/write will be doing the same then.

OK. This actually simplifies the code quite a bit.
