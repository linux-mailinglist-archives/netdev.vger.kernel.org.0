Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3785B5E33
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiILQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiILQ0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:26:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076361EC46
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiuHkGEZ2VCfOJQQPW/jTdSiwFse5i1mdpYCgTvfizEtQbkOLxKQbtDRjwl70GaPC5Fb6S18M5WM6MgB4s6B07+DoXEhWV6j+0aUrCD6XZNRp5TpCwAkKl6FLsnE7nEvpCNN3LGKKExqLywhfPmpBhkHSxuyV7kQgqZvkzPrtQSgkoreFDiMAK5sCkynMdgDA0d0hAPThps5TDEsuNcnxGbWqWpuw3LgDxycxcPf4NbUZ11/xT83gtItSxFluvtuvUcweOy6S3XC6eVZ/qo8xHFIBHsJW1H6g59H2TtSugKQtjeWOr28I32dR9nRFccWjfG7oK+Dl4RzNQhru3qSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGMm9XkFnFRWBLZud61JAd6bzFoW2cqRjQyBVphV4jU=;
 b=PNbE7V3ceVpqU3TuhD/fbCH+c/UB2h+4FjwEeOUYdYF2H394M+OMFNc0gsMUrcmTEp8cmEB6oxyzRPszw6O8qG85k6vuA62GU7XJnizAIFCW8soeJ2ByydChe82peywe6Yk6yEBT7BrvPCAl+4U7A7C1xzobrm/dyg6aLq2mr3hslx+nAkD9Wa48EbtO0ucDFUvjVhiRsBsR4gvYO1NCbf0foMAA9p359hPMz2zoDCb95XrcGia1bz+jk/ODc50zW6CcRWSv/Nsjz8CFJ2HPdEsXAfSCv/n1sF5X6cFyBDYOT2ZrAb6lpD7WSR0GA06oO4rqw84OI+D8JrLcVvF5Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGMm9XkFnFRWBLZud61JAd6bzFoW2cqRjQyBVphV4jU=;
 b=e7cJXZR0eQ1SIvuIwp3ODdVJPpNmx2qnp8wDZ2pJGM/nJ3D3Rs1Tb72fkOaK6vaiIv4V7r92P38dbfBebrhAara0l4KZqJF6p9ZFczZg/xTvulN2959+jJZOf0k0R/EsAfA0ozh7y3Nd7mcAU3A8o3a06LwTOUmJAmQwXn4STNEm8IVd2gAJK5GdeAMxGeOBAGKJMzkr/XJeMDmtLv4ojy+tZiRD5IfbwbXJ2D+R7XzV/vXuqU4KVieUZIKMNHHldDNri0uVQGO9bW6Rjb22UUtd6wygxvz8Maev7glVYFYLmZyIzHgnbDdYIbN39qftld41AwWxo2IBDskWtlf6+A==
Received: from SJ0PR13CA0114.namprd13.prod.outlook.com (2603:10b6:a03:2c5::29)
 by MN0PR12MB5787.namprd12.prod.outlook.com (2603:10b6:208:376::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 16:26:21 +0000
Received: from CO1PEPF00001A5D.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::1e) by SJ0PR13CA0114.outlook.office365.com
 (2603:10b6:a03:2c5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12 via Frontend
 Transport; Mon, 12 Sep 2022 16:26:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1PEPF00001A5D.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.9 via Frontend Transport; Mon, 12 Sep 2022 16:26:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 12 Sep
 2022 16:26:19 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 09:26:16 -0700
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-2-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dcb: add new pcp selector to app
 object
Date:   Mon, 12 Sep 2022 18:15:01 +0200
In-Reply-To: <20220908120442.3069771-2-daniel.machon@microchip.com>
Message-ID: <878rmoeezf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5D:EE_|MN0PR12MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 94df583c-9eca-4a85-1b30-08da94db8672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/nEWRBzGfk3N66/Iqmn81/AC9DYvVbrdxkJ9QmexTCCQk4zYFHrazx8a2NlVL4zn2L5R/zdszqfPnrouSUTvisnUo6cpYLgYls82lUra1Lk1wkZQQQntn8yPF21JStBNoSsXXdkrFas7RYJzP19uZUy7UiFyI0w+vCR/TdisiwwmR6Uh1e4wBaSVPvWWcNM/V7pqyVZEtrTe4NpRnMaS67DKddGelt0SCPw3ICyS19Y3+Zegs/r/ErWZFGqH8YprGx3/4yvhGSVzSKAQg9B2pa9dZsHtvdxeDWdOBdQTY+rYS97rf6CJzKKUTPSX9QDFrBkLKCyiiygkwxCewWaUWXl6xOgvWn931pxZotKMUu0pkY9zkJLmUz9mh/DhG0oU/KzrE9mf5CIB1QPZdxM9cf7YCsUML/UzfIC576dZPu772ZyeuqYvC+yESklLyQE9umt9NXkD62yhoUbzwCnFfMfQyOuHn0mamPOtq6eoERf/AScNuXxRB3vGdXy/5lwFhfnX/WR3jHM2Jw4NQNwfRvCbGk2EtfcBBAJ7IWHeI69yxE68oKL2B0+HqBdHpe4AfoUoWD7nbhs4HD75AQnJ0gbkMu0vtruD2CFhCFDC2jO6DzGZzygDHQV42ds7UsEbU1HfPp/octQMfh4hHONfsEUfIJGvTXPn8sBDqmNuvyPDZr6Kp87oOg6rgHpMwH2CCu7XIrmZjymGrYs2b1SVXN+wVpB4QxFp8LrzSizkBjgWecEOts+kyvAiSl2GY0/8d0kanTYpXYwmv+O7MDZO9FPkuEWI+TkDK6cPnFttJA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230017)(4636009)(346002)(376002)(39860400002)(136003)(396003)(36840700001)(46966006)(40470700004)(82310400005)(426003)(47076005)(478600001)(2616005)(16526019)(336012)(186003)(6666004)(40480700001)(40460700003)(86362001)(6916009)(54906003)(36756003)(316002)(4326008)(70206006)(8676002)(70586007)(36860700001)(83380400001)(82740400003)(81166007)(356005)(41300700001)(26005)(2906002)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:26:19.9625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94df583c-9eca-4a85-1b30-08da94db8672
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5787
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new PCP selector for the 8021Qaz APP managed object.
>
> The purpose of adding the PCP selector, is to be able to offload
> PCP-based queue classification to the 8021Q Priority Code Point table,
> see 6.9.3 of IEEE Std 802.1Q-2018.
>
> PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
>
> While PCP is not a standard 8021Qaz selector, it seems very convenient
> to add it to the APP object, as this is where similar priority mapping
> is handled, and it perfectly fits the {selector, protocol, priority}
> triplet.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  include/uapi/linux/dcbnl.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> index a791a94013a6..8eab16e5bc13 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -217,6 +217,7 @@ struct cee_pfc {
>  #define IEEE_8021QAZ_APP_SEL_DGRAM	3
>  #define IEEE_8021QAZ_APP_SEL_ANY	4
>  #define IEEE_8021QAZ_APP_SEL_DSCP       5
> +#define IEEE_8021QAZ_APP_SEL_PCP	255
>  
>  /* This structure contains the IEEE 802.1Qaz APP managed object. This
>   * object is also used for the CEE std as well.

I'm thinking how to further isolate this from the IEEE standard values.
I think it would be better to pass the non-standard APP contributions in
a different attribute. IIUIC, this is how the APP table is passed:

DCB_ATTR_IEEE_APP_TABLE {
    DCB_ATTR_IEEE_APP {
        struct dcb_app { ... };
    }
    DCB_ATTR_IEEE_APP {
        struct dcb_app { ... };
    }
}

Well, instead, the non-standard stuff could be passed in a different
attribute:

DCB_ATTR_IEEE_APP_TABLE {
    DCB_ATTR_IEEE_APP {
        struct dcb_app { ... }; // standard contribution to APP table
    }
    DCB_ATTR_DCB_APP {
        struct dcb_app { ... }; // non-standard contribution
    }
}

The new selector could still stay as 255. This will allow us to keep the
internal bookkeeping simple for the likely case that 255 never becomes a
valid IEEE selector. But if it ever does, the UAPI can stay the same,
just the internals will need to be updated.
