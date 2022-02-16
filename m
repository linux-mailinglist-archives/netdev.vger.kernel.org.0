Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05924B8680
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiBPLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:12:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBPLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:12:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3244C710CE
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:11:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLfKB+PpmHCqbgEzjnKc20+UeUaFk0ooYTPXBopZ0Z0A+/zx+zsX01iO+bwIXl2TNy08VXekzQAPftiYkz95TusFEqo+qKFopFFCkBcdKfg1KtIRsJEEAv6FqzvO8wdxB+DgJUSNTv3sKGmfCWNcPShBcDP05Y62kEQEHBxuf4Soi5cOKqbceigBeivztoIH7kh/STYWVcyg6Txt4hZUbNyET/7nL/qR86oCaAKAHG5BJvTanrYe+2fvanndu08jT4jUJz8s2SHw/cHhW43WeCACbgxvtJ4U2toIDBwGbOPN4SlxILZiB8gZQviRWG6CoLDEh7jEmccuECZkP4wPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlUlXgXsrYjdWNiDkr2DGcEKtmkdTTHq/nMx0VsCafg=;
 b=AqdVYUqxq2MEcHAhzPg4JWzuokcA/xv/q/QcIkQ0TwQd8Mi/Y9bAhKOVE0mBxufw4CuWeGEFT+eAsDWz2ZHhutwUnZd3HzHwxLP/g8C2ywssVxIjuFsF7Ib74zsHUfurH9YEWoQlBC55ytVPaiUw+Gl7haUMrJ9TzS4OTJGC53au6rm1HHLq3CzA9CJ2vd+Ak8DVKBlFAuNsCzph61wVxiwzmq4fRA/uZpemmddV73k7NOKmdIZ0w+U9tW1rctshHZGRS4QZXP7u0wfPZMGK4fet26rwhr2luyhlJJOBo3cVxFpHz8Bx7+4BhQcjQVQYFr4ynKLsJd707FuYZv+oEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlUlXgXsrYjdWNiDkr2DGcEKtmkdTTHq/nMx0VsCafg=;
 b=kXsK3X2YRkLWXFz+IDB6RPxgwjwXVoK2Q/0pg+pRmEa2NyF6/k6WpkQBJ/sagiLbfGhH0iM0gZE/bY/ljqOmEj4bx41pZqPuJiXqJpABNh3XiKyrXntOhAy+pTdou5dfkpP8ulJ73VPNlOT7w8LihSwvfZ4bOXx31O1/HdhWt8YueHJRgiUYuVxRmXzFKKq4ao8aGUlC9op81wVR4ibTan0nlt62LgMGricGIUVD+Zx80F1skHysQN5k3QhF3+lykmaB1G4pJs7/BiODQKnJtvK4K6nUCE5sL7X6uLXo+AuA20H9R+yB1E0+9FQUKFUO9s0QG3Z+9bTK7fpSmD5Vaw==
Received: from DM5PR16CA0035.namprd16.prod.outlook.com (2603:10b6:4:15::21) by
 DM6PR12MB3066.namprd12.prod.outlook.com (2603:10b6:5:11a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Wed, 16 Feb 2022 11:11:54 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::ae) by DM5PR16CA0035.outlook.office365.com
 (2603:10b6:4:15::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17 via Frontend
 Transport; Wed, 16 Feb 2022 11:11:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:11:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:11:50 +0000
Received: from [172.27.13.137] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:11:43 -0800
Message-ID: <17ded781-e7db-dd31-bc2f-dce6fda6bf39@nvidia.com>
Date:   Wed, 16 Feb 2022 13:11:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 02/11] net: bridge: vlan: don't notify to
 switchdev master VLANs without BRENTRY flag
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-3-vladimir.oltean@nxp.com>
 <630eb889-743c-c455-786e-ce2e58174ea9@nvidia.com>
 <20220216111033.k3dmnoc72kuqfzzn@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220216111033.k3dmnoc72kuqfzzn@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a93a31ae-679e-40ae-2276-08d9f13d239a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3066:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB30663E591D861173703BC9B5DF359@DM6PR12MB3066.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9uyRGgSWMSr5tXfpU8EhoVYW5dfjfNDZMM9of59mrBg4+MJjAaiwU8vvcu+ghyaOCX8CZqdnpX1II2Vin8zjsH9vd2fTaHsGVs02xW3+UWi9Y8/BefyI0YUsmwPLQQ7zuvhvPJk9Ay1q8QyeKPkRsbth/XWDDtTYUDwp0sgiYkusBpvvNgGsP1ONcgBFq1eeoZwpyUSrlOdmP91UuD3GtJl+sI0I9nj3/pcnmxoursxfWQhTc6Vo/MNNLooi/VZR/oiX0AU0UvWWsQW7UT1yjP1T8+lTEn30jHKpotUS9B82XkSiSJAzzLH3oYAyNlSOrrfWy/rCFAO/fLZWl6JwGXENUoNr2B5Cg8XRtG2mgR4JMftUroI5OpAFL5V6G/jg4z+DlAiNWYlYvjWXd6Jl5LD8YQ4MgpVXV5jqhq95B/GNNDgfO6rQQHmCYC0l+9ev5tqY7+cddK8uQxpvWIW5JzmPk1apeI0kdiFXjWueYxJq1Mam/U3CN/olsGF/WOAf+487k5xcWVC5xwPooPR+Iip3/zlZ73/m6gKQmkPZT+a2x+uMc+5veNNTgQSlF79QfzLoH0baF82ImBB1uLU9mt82ZFtlHnu05oDujx0fyI+ri5I2bb0OwWOPCUqzfKQbrziL/TdVAYmsu4wZXq3SMI96VQ5Sgc8PUvkZzkUW39pKlxf4aKgdZAoJ0uWndUulEUbZp/PbEXaAYch4UErttxK8sMOsjtD0E3/zFRPvlBW1PEmv+Tg4FTYEhvWglaW
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(16526019)(2616005)(186003)(26005)(356005)(5660300002)(336012)(426003)(2906002)(7416002)(8936002)(31686004)(508600001)(6666004)(53546011)(36860700001)(86362001)(82310400004)(70586007)(36756003)(16576012)(54906003)(6916009)(40460700003)(47076005)(81166007)(4326008)(70206006)(31696002)(316002)(8676002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:11:54.1145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a93a31ae-679e-40ae-2276-08d9f13d239a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3066
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 13:10, Vladimir Oltean wrote:
> On Wed, Feb 16, 2022 at 01:00:27PM +0200, Nikolay Aleksandrov wrote:
>>> +		if (br_vlan_should_use(v)) {
>>> +			err = br_switchdev_port_vlan_add(dev, v->vid, flags,
>>> +							 extack);
>>> +			if (err && err != -EOPNOTSUPP)
>>> +				goto out;
>>> +		}
>>
>> At some point we should just pass the vlan struct to the switchdev handlers
>> and push all the switchdev-specific checks in there. It would require some
>> care w.r.t kconfig options, but it should be cleaner.
>> The patch looks good.
>>
>> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Here and there we're passing "flags" and not "v->flags", so passing the
> net_bridge_vlan structure to br_switchdev_port_vlan_add() would require
> committing to it the changes we want to do, which is pretty much what
> we've been avoiding since v1.

No, it won't. I didn't say we should stop passing flags.
It will be passed along with the vlan struct where you'd have the old flags
that you pass separately now, so all checks can be done on it.

