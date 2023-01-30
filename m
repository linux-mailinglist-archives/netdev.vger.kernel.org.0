Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D27681581
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbjA3Ptc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236739AbjA3PtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:49:18 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413B14ED3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8jPDr5JdxTFBGJU6Io5K0hyk80gz+Nm5J88jx5DLPYpx7xhGTE/IFHPHRqeAzGil/bn16FiHFSQlq50eN7nN1h5aAGSHFVOP1M1qY9zQvNI6AuwqPIXOteO48oAqq7VZv/51Yr5A441Eet56C6j3vmFjiNWWT0pOntsrXoVpAAJpIiJH666SUOVV2HLgMetAwK/BDiQzq5+M6oUy0FNzGB9GBh4e9HGW8qt1GyMkZj0BtynOTpXrWksdctKBTblDwEKz89tFyqmmFkvW1xFkfH93f9ZI50Kw5w5EfgIuOoOqWAOmkylD0zCayH7quSMQBtFo2gLa+zCCNaDpobVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMG6WauqKhgIWHUSEv1L/F0leQMvyek/gjyf4WFylv0=;
 b=YmDFaMgXhGRnYFYHYtuCRdCgiHgvyyQRLhXa98ebCB8ZY7TdIjORBlbd732nY+wMc01AtJ35/RWdhYn2ETOYb+itFoOmNpA68WLzLLwormqiwMtoxcTguBLYCKgYluSSvjMTA7KoJcXvgoRdbHiOrpmMnxKFysAx+4y5x4Vse0vxBBp72yDKro9RGPgtT+Kiaefcw5e8H1xnuqmN60khOOv96hQxXg19Ag0nzOcDAzqtqi2dqK+EO4SejW1ss+DjYY1k2uqsWEL11hWxAaTysBhcmmB5AcA6x5Twc71aTRZxNdTk9gsl909qMIcHXDC7tsoE2a2BtWO8u1YVGEf2Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMG6WauqKhgIWHUSEv1L/F0leQMvyek/gjyf4WFylv0=;
 b=ndbq4mYnFi6Dsp1YU7APD3a+oiwKJCFY8ap4wo2oO6QuzLmwuyehWXKNK2QTs5wceMHhuDEu+AQqI3vv51/S3ThgVERQAhvuFYM8Vfzo8Q4+Ca1pVJvPCNfKpa+hqocembQsfzJfPOpLlBecKDEUtaDY/8fZ9rvsAxZL0hcS2GQZU39P9plUbEEUtBnLc5W8bQ9al7zqBG91nSl1LEHKoELN02f46WhVDh+RTBOuW0ar2xhURur3qLP7hOSkQ7VGme5xjdhDDxywb4S+1PzSTmbLVxtC2ET0u/j/w73vTXLTO8dcJaL5To0VVnIaFEftDfBjFlmaE77essjWV7ietw==
Received: from DS7PR06CA0022.namprd06.prod.outlook.com (2603:10b6:8:2a::10) by
 SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 15:49:11 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::fa) by DS7PR06CA0022.outlook.office365.com
 (2603:10b6:8:2a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.37 via Frontend
 Transport; Mon, 30 Jan 2023 15:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.28 via Frontend Transport; Mon, 30 Jan 2023 15:49:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 07:49:01 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 07:48:58 -0800
References: <cover.1674752051.git.petrm@nvidia.com>
 <1bb4bfeaeb14e4b484c6d71adef0b21686468153.1674752051.git.petrm@nvidia.com>
 <e46f0af5-ef19-5260-5524-e53b4e4438f1@blackwall.org>
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
Subject: Re: [PATCH net-next 08/16] net: bridge: Add netlink knobs for
 number / maximum MDB entries
Date:   Mon, 30 Jan 2023 12:07:27 +0100
In-Reply-To: <e46f0af5-ef19-5260-5524-e53b4e4438f1@blackwall.org>
Message-ID: <87mt60f2fr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|SN7PR12MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: 424f9a25-806c-4d7e-7a03-08db02d98803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d65IdaYQ2UXzatm3UQVITbmeQwITfIQxdzXbDyR5DnKl106RdkYyWhSbkEqrONuFed9RdE3eOxxpelj3jqAQPGFwoNfcb3uyyykEdvX+nMnWB7FnJjPLueHxHuvJlMjuso3iaZdLO09aWBlFR0dLLyY7/qGtha8Bgox+LrYgA+weCUfDPBaAlv7cpq77o1HMS0nzw4m0gGOvnxQ8nZfsTTq9xW0div1ODUC0b1PKQX1Kh3L97aTdiFneq+8QsYXbpiqRBx0I3mwF/mk8b/yT+C25I0JsXGa65j63ZClvpQcAVIIHpL7RgkiV7yQ3GX890nfWecOavimFG5Q9ebpuo/nPnyj187lRmue8+vqVQ30PAHy1XhY2pboOhEYGSKS6kgzRvoYVHoI3aNmDqeCs2q9LS8uWW7/xBePOssj2FbGO/D9I8lXpZfISANF9mDcuoVBS7k7p4cknB2G/gQFrsOS7dvz257+2/gmPOeP6ow+9TNbghaL8gyxVS6IdTOjTGUv33OpkZJQZlHrdjzyhHDbYgC8YnMwN/8mMQBcR7sMqEEVNKw48nw4hngCmLzQKKvnfoZ5hayMLrA+nWYAebjc1pVwFUFhGNafGZk7Ey8Y++jPI5HH6l3GtA4Ta6CBh5e4nD/jiVAMobPB5wcVGm6XjzJr/eUZHe62Lt8oJhUKHIAIbfyRyjtABau6p8LM7WYUDoBCh93FqnSrd880hFA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(83380400001)(86362001)(2616005)(426003)(336012)(47076005)(7636003)(82740400003)(82310400005)(356005)(2906002)(40460700003)(36756003)(36860700001)(53546011)(186003)(26005)(478600001)(16526019)(6666004)(107886003)(40480700001)(8676002)(6916009)(8936002)(41300700001)(4326008)(66899018)(54906003)(5660300002)(70206006)(316002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 15:49:11.4582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 424f9a25-806c-4d7e-7a03-08db02d98803
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nikolay Aleksandrov <razor@blackwall.org> writes:

> On 26/01/2023 19:01, Petr Machata wrote:
>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>> index de531109b947..04261dd2380b 100644
>> --- a/net/bridge/br_multicast.c
>> +++ b/net/bridge/br_multicast.c
>> @@ -766,6 +766,102 @@ static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
>>  	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
>>  }
>>  
>> +static int
>> +br_multicast_pmctx_ngroups_set_max(struct net_bridge_mcast_port *pmctx,
>> +				   u32 max, struct netlink_ext_ack *extack)
>> +{
>> +	if (max && max < pmctx->mdb_n_entries) {
>> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Can't set mcast_max_groups=%u, which is below mcast_n_groups=%u",
>> +				       max, pmctx->mdb_n_entries);
>
> Why not? All new entries will be rejected anyway, at most some will expire and make room.

Yeah, as I wrote in the other thread, I can relax the relationship
between max and n.

>> +		return -EINVAL;
>> +	}
>> +
>> +	pmctx->mdb_max_entries = max;
>> +	return 0;
>> +}
>> +
>> +u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port)
>> +{
>> +	u32 n;
>> +
>> +	spin_lock_bh(&port->br->multicast_lock);
>> +	n = port->multicast_ctx.mdb_n_entries;
>> +	spin_unlock_bh(&port->br->multicast_lock);
>
> This is too much just to read the value, we block all IGMP/MLD processing and potentially
> block packet processing on the same core just to read it. These reads are done for notifications,
> getlink and also for fill_slave_info. I think we can just use WRITE/READ_ONCE helpers to access
> it. Especially since the lock is taken for both values (max and current count). We still get a
> snapshop that can be wrong by the time it's returned and about changing it we'll start enforcing
> the new limit with a minor delay which is not a big deal.

Makes sense.

>> +
>> +	return n;
>> +}
>> +
>> +int br_multicast_vlan_ngroups_get(struct net_bridge *br,
>> +				  const struct net_bridge_vlan *v,
>> +				  u32 *n)
>> +{
>> +	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
>> +		return -EINVAL;
>> +
>> +	spin_lock_bh(&br->multicast_lock);
>> +	*n = v->port_mcast_ctx.mdb_n_entries;
>> +	spin_unlock_bh(&br->multicast_lock);
>> +
>
> ditto and for all accesses below that require the lock..

Yah.
