Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFB44B86CC
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiBPLfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:35:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBPLfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:35:20 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6047564
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:35:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLbBaASrN6ZRC6zmfSfI6+htd7vbpCr0NQDz4TL36ooQTcw85f4bzPT8jjGb9tmRUqzOMVmo7BvZW0GMIlVCln1B8lPrumoZUfk1UBw3EWmnbRbNs6I9QoJJry8SZ6p9N8TcA1j56DPP3eoas+tHS0iMf+0cm2hbSAaNaf47VLFw4jE3+CXJLDxb7Tk5YYnwWIDgiYvrZxxI35jxNj2FdWsWNMobgxWRpr+mwHAGtLxoVxpd0+fThjPrM1Y8UnsB+AboQXbefJmTnKN9XQCSeB7930NuD78kV3qYux8n07rQ4ddMAFOou4i0gi4zpyqmE3HFoyCXYNX/lmxP41hN+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AalBj5CkuGZpxRR+7W5XxjOkgLIdgzxO9smkD/1Q3NY=;
 b=PwW9oEQ1pfNR2PXz6ccbnnTL5NBjWse2732ie3mUhfSSmn4vspxti3CHEn9qi4KVISSGJ04u682DNUVlMUtnEC8aXQ+FnD5ppFcEuHGC4f7a5Qp7t/c9Cdi+AmnFaUyXSsDL66AlHJaZE+A800T+9wrGS7fShBivE4r5zykk1WoECE/EygRdPekCcinFLsayGJMjUCiIdINPunske72Uhf8LB840EUftP63fKrFK371Matt1wdkdLzI7slR0heIJ70LYcHl8z3gOFq5gk92QEdPjLvIRB14djbLI9JytSKBjCjxwodd9oaYoaEMfuN8DWsBxNlPqkocooMlGcxF0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AalBj5CkuGZpxRR+7W5XxjOkgLIdgzxO9smkD/1Q3NY=;
 b=iaradIAz23CEZWUMh49/dzMlQPhOiKA79yeg4J145HNdHYw65ZWtElviens2iduuKeL7fqTimz5scTsBlca1b8jTHv8Iat/AawRxxaLxoE+DgBYaMVLt8cotrI4wfol5KqCMskd4zyST0AFzScA+Xo7W1kTjV0gonV9F+CJtIDTYukm1jpHKqK2SBLac2zH3gIfU5g8/QVsBgGf8JZTM+2A6AA81xTck1wRTn/MqXzeLzxrTLhWooJbI3N1UUb3kBH3skOBFiyWdSiiPt6PZKczTo/Zr0XT8DXyZFH1q0NtyLbDzGflSP9KcA42spgx2HnPXAhzVMUFHV0+ycDE6vA==
Received: from DM6PR11CA0017.namprd11.prod.outlook.com (2603:10b6:5:190::30)
 by DM5PR1201MB0233.namprd12.prod.outlook.com (2603:10b6:4:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 11:34:59 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::19) by DM6PR11CA0017.outlook.office365.com
 (2603:10b6:5:190::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Wed, 16 Feb 2022 11:34:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:34:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:34:57 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:34:50 -0800
Message-ID: <b6960732-02c1-1d0f-38cd-ea0312130e67@nvidia.com>
Date:   Wed, 16 Feb 2022 13:34:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 06/11] net: bridge: make
 nbp_switchdev_unsync_objs() follow reverse order of sync()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-7-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2312a12b-26f6-4423-fad7-08d9f1405cf3
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0233:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02330A61A8F5E40044D6854FDF359@DM5PR1201MB0233.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZ+1wt9bsctFiktbqFVkaO9o6LIh3BUn++3cDabQfTsqHQFJcFT8Ukkf9jxf1g6u1SOg6Wm8J/8Qgo3LYYFThXrs5a5fNg7eh9OP6cEq8z2tmiRCYKMZHeniwLsId2jrLgm8K69RVnMAf7tc6cFmiPyiArJ4CVACwbeJFUIe0rzHiq0HB8Qgu5ZV8I0SQSHh34r4GaQKH/df7mV5kQWvZEKFbpj16yNfTxmx0x5L7RBGp/P4b5ESZoe+8czvKLX6TWY8K9k8hHnDXdKP+HH3pZtVMNk1nnGX5dZiUXLaosGSrhwH3pfFsG9Eb+y01lAtacVUnpmVwlkSxHOYBAWSJQ+hmGi/SN0mEWboltVf9U4InhD0NDp4UgIA0MgNiIQKUZtpwWDjUuRBFQOsZ7rNF1wfHbsBDOfeJlr+F//ku6ycWzm1o7wUVY4242HhJQ5xdV2rhzcir8Xp40q/wqby++MnIw7L5w2nVwGt9Hs8FGE1EH2wCTwxc8jmCoWoAiNLyYB68oQe+4tD9ySephf+jCjnkjyBIquOLMbc6TPnKBCv+K7CEIxi1E7A6SHHiVS2DvF/MHBvgETnEUZrVz6WOx+TTMvdu51/1yuSzHTmlPONXp1zYBcMBGujgVWu7WinVK53qe5DwnIKFlw9KZXghPc8T+bBa3Xud2Nz0/oesspVNbMX+pBw1C++fyjYR1euYjODnT9weC93cOQydCbnQLgrvq7cI1gKU8VA7iOLuHi2rmyijWP8K2w5TGAggIVL
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(336012)(54906003)(426003)(110136005)(70586007)(316002)(86362001)(70206006)(4326008)(8676002)(356005)(31696002)(82310400004)(26005)(2616005)(81166007)(53546011)(186003)(16526019)(16576012)(2906002)(6666004)(83380400001)(508600001)(47076005)(40460700003)(36756003)(31686004)(36860700001)(5660300002)(7416002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:34:58.8080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2312a12b-26f6-4423-fad7-08d9f1405cf3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0233
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

On 15/02/2022 19:02, Vladimir Oltean wrote:
> There may be switchdev drivers that can add/remove a FDB or MDB entry
> only as long as the VLAN it's in has been notified and offloaded first.
> The nbp_switchdev_sync_objs() method satisfies this requirement on
> addition, but nbp_switchdev_unsync_objs() first deletes VLANs, then
> deletes MDBs and FDBs. Reverse the order of the function calls to cater
> to this requirement.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: none
> v1->v2: patch is new
> 
>  net/bridge/br_switchdev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index fb5115387d82..b7c13f8cfce5 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -707,11 +707,11 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
>  	struct net_device *br_dev = p->br->dev;
>  	struct net_device *dev = p->dev;
>  
> -	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
> +	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
>  
>  	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
>  
> -	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
> +	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
>  }
>  
>  /* Let the bridge know that this port is offloaded, so that it can assign a

Now correctly matches the sync order.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
