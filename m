Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BEA6DFAAE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDLP7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjDLP7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:59:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2116.outbound.protection.outlook.com [40.107.223.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125D95FEA;
        Wed, 12 Apr 2023 08:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVmOd5W7QW33U7N31MR5bQDXqtyM75NqGsMrFQXipsdMIgY6EDJk305iKBUYUF0QMTQkyDoh6j0t2mcOgu9QoH9xpabU1Z87a3sGjVAqM/wcweppTPZl6XXigEvEAPKqTaDZleHHseH3LUyXygqPO1GQWPjZo9cBpEw/drEeNPxjBH49nBSY3+JtrgEai4w8PP7TiKGAYb/Pl43UsUeftwLGK9bkg9kUs/ABU74YkruIBWsMBbkegxbrdLJR2pEmioG+fwkSUnUXEiWOg4ns2JJ5YdMaLs1V729FKimiWop6zeirjECQTTCg7cyi++xEW0VJWhq6+w+nJ2Jd9QYckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbodzPFC2wVP1ltGwLTU3Ip9MOSku5iACHZg4lFXWZ0=;
 b=j81vtQti4wCOhIxAgFYX/APN5TRGdiFHK4t/dO9mOpLFzINsXzvJjMclUSxLWftS/pmRaPwx8yOFmnGpZLIZ/+bjHUx3/71FrVThNqzD8Eu3eUMBkRMGyjxWgpTTMXlnp4LEK44issNZrMG1rwdjZH0GkPoDLvBLcYAMgg3E+JJWPr6adE7uBpq87vaGPQpr8puDaV2zhr2VD/EpixQn5VYL/+CVpMxNfEdIpmIDvFxVQG6J6VNQ/HD3OBxc8lX8CCt1l9RNqiK7/aUhFhUJ7k1n57NjXq5tvMysuHN5B7T4LErZ5Yxx0yTuf7SBRzpTbruY3yY4mn08or3MI4gb9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbodzPFC2wVP1ltGwLTU3Ip9MOSku5iACHZg4lFXWZ0=;
 b=UvRfrl0guXf+1M06WArLFmmyAumtNkFeg5Lgp9ju+WhetGZxY+tBeu/EADsDBmvIbbJjYUeIGF2KQVXSSACr0fmk7s7u4eDGPRtAuFpmq12BECwaK8o+SzyaTArF2ArVa7IypZTOW/1WMhQ1P/miWHp6FvWmYBeTAlRXW/FzcX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BY5PR10MB4131.namprd10.prod.outlook.com
 (2603:10b6:a03:206::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 15:59:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af%4]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 15:59:28 +0000
Date:   Wed, 12 Apr 2023 08:59:24 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: mscc: ocelot: remove blank line at the
 end of ocelot_stats.c
Message-ID: <ZDbVXOnxzv2QbxgJ@colin-ia-desktop>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <20230412124737.2243527-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412124737.2243527-5-vladimir.oltean@nxp.com>
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BY5PR10MB4131:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4de4fa-0fb2-4751-2e85-08db3b6ee560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6nylMT6ikWozNzzxCXB3EBgodIWWSG6Znjv/DR16LODLHwlnasz3CHe5Bcvmk79f+SWPLwI4xGgmcf1WYz8NH36xtRj82JowbF3Btbj0ZPf7n9tyzUEkUYj4zwgzAQ7IgD+vBWeRtLI/HqC73+QsONLYcoYJ493dnmgK5vPZ+vwpXfdEGyxuJ/dKKdpvP3cOcGVm+fOUMp/Xo10SnuCdBZYB7buTqhG4Y8wzZE3OlabORoxqFqARlG+MoRB+1gK4v2YQaq9jCsZd2qgaxVYfNn+WG4ZH/tP12f16F6mB1xlCDbb1SdffhuSMMhdr2Eyzo5GYbqRtLEJrO4CXp4Q/yhb6PwE60ufUV5gcJWaClAEi0E7y6pKvDiKSdnMh99GY9dSLKL6Q8wnFnjqoaIqeqcQtVxf67AGWB1EkhafJYQDF/58LlHldR1swDv48Rp3kRwrP0MEJSB09Gdg0J6UgVYhfwdeXj5GlVDBIaIFY3eTH4Ie5dhNjbbXwEfS3Rbxsaz/bpaeeNW+Jc0yNezxa56zQWdt5dI47DHX5JZZ71ailFZXNhiHmJewotwyX6Z5Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199021)(54906003)(83380400001)(478600001)(6486002)(6666004)(26005)(9686003)(186003)(6506007)(33716001)(6512007)(44832011)(4744005)(2906002)(7416002)(38100700002)(5660300002)(6916009)(41300700001)(4326008)(66556008)(66476007)(8936002)(8676002)(86362001)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rp2Xt0oMEOl9GQHHGSPjxkxvzFWMNdNqx2dOFud+36z/rgByktOn5k+SQbCm?=
 =?us-ascii?Q?mBMNdEEGbRJLYs+JXzEfB2lmEEhgzo3oyINbJ8e7vhyFFr2tXbWfGMep5ZiT?=
 =?us-ascii?Q?gk0Vzov0B6gusDirt7KsGX4odN1EsG9fzIXjsdJFvdwDZbmh3cYmBj4kcpY1?=
 =?us-ascii?Q?95NuNR8RHLAeQPxkbc0VIGGO1+D9a/wCJ3Iwig+VRu3bMPunT5fi/yILyOgD?=
 =?us-ascii?Q?vg8fKspaO8SPNej6sdvB46QTU+37btOi9biRW6vA3WNRioHIjMQbd6hrXdZi?=
 =?us-ascii?Q?w4xucLHDdnolTeLwnqHJ9xZ6sLnxhII+i+xBWESXsdJb9q0ogPXtxM2aJEVM?=
 =?us-ascii?Q?fG0tR+Z2rhgiWI3aznQAklc2qBHR4ySwopb+GCbiWgvhvc41q/+itMztPOd7?=
 =?us-ascii?Q?tgHE5fXLaU5o6K41ZxHiqKCtPIb0SJnEax4geraIsFnxPy5FF8Kn1v5A9m7O?=
 =?us-ascii?Q?Z4HV8mgVeqz2UWHPek7DTEkf9gR9kbIl7RXPIAN9dGagE/fF3jHi6MEdCHDF?=
 =?us-ascii?Q?QudH0pW6l93FA6qqN51WZnGfTfmv8aPrzC6kQxTvRVBxPz04y2ghH1T6qkvi?=
 =?us-ascii?Q?IdjmYEAeIUYkmNjdxv6Jf4G2fCGYzLgudbDeOE9VhP2HyirdQEiQgjFsB7dV?=
 =?us-ascii?Q?WZSKibDavFHNjHIirWGCSq7+xYLq1JH4CEpz0qBtrZjpoDdH5LwJufF0k8Nt?=
 =?us-ascii?Q?tOxVrKgT76lnVnxtPUB4nC5CIdven6BoEU+2S+P8rzXivjf3TRjj4d/hkkWj?=
 =?us-ascii?Q?fl7kqdVO6RejIqVHW5Lhs8SDKTfWwJbA3KKbisD5N4lY67flMzXDMyYkLH2t?=
 =?us-ascii?Q?GZaeKgdycLGg7d+EQlPBSMdEMgF/yIO/IE7q//n6YHhGCVaUbTW/rPh7V0AJ?=
 =?us-ascii?Q?Q8oV2/x5m9a6le/eJY/nSRE2VpxES4YA7q1nH4R3FeffQmrIC6ZuOgCOKk6t?=
 =?us-ascii?Q?XlqdyE1D6dbte9XTG+i2MClcw8sBvZaw1oq5QVN4r58wnqFqbIIkpxCU777W?=
 =?us-ascii?Q?uITa5MJqbvP4jafLCywrHECr93CybU5KYwZXBTmBAgTO7NbDHC1cGWh9cO+w?=
 =?us-ascii?Q?c1sle7gel3GNCyK1E338z7lM31Ha+GRO7B8MqaaV6lYMuhUGwLqy8A9e7L9T?=
 =?us-ascii?Q?JuwXfnArV3f+EPPCSuacxiSpPeXS3j23T70j1OYn20T6vhVnRAENL9qK7ttJ?=
 =?us-ascii?Q?3nofoZGzm5P1EQKB0nPagxFKfnCdS1AwWlI1RvLvGqQsRZ+W5IuWAIGSAZ6a?=
 =?us-ascii?Q?q/mwqtW0JXeQuVFIVpCtaLTFjQKDfZZsMzteZN5CTZz7BGCbnQGIAY7yDm1j?=
 =?us-ascii?Q?jT0VM8JsYG2iQbZnoLtI6fIC4y2G8Qc/6FYoK8SC3zJjjp6NwsWypZS/uQmx?=
 =?us-ascii?Q?gJB9mJUJvH9ahHJX0nBrQ4vNB4zGpX81b1VA6kw9MJPcQuLL7NZjm4HDA0pP?=
 =?us-ascii?Q?ubwDAxUMN0mxWhUq1fHLMv6gczccDRrpsQudj4EuVF9woyRRlL8XR5RHkbMo?=
 =?us-ascii?Q?H91a3SvVmkz4MRH5iBaWFFtEcfSG1rbc636FUGW30kcnRQzfLJnE4VgZVKyD?=
 =?us-ascii?Q?+jbTuz6mbciiYDla/r78ECNNh/2qOok/0By6fyXRJrIpF/Dc7XHI+mtCtaiR?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4de4fa-0fb2-4751-2e85-08db3b6ee560
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 15:59:28.7892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i27gXq6NPoqredCS3iDBmfZdeekmHACumgRIP5fM4CjbdPwp/WfcAandgLvz3hm/ojarWqaEiZb4E1BGvQbS7HSVLDhe5X4TTOO/T53bbEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4131
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:47:33PM +0300, Vladimir Oltean wrote:
> Commit a3bb8f521fd8 ("net: mscc: ocelot: remove unnecessary exposure of
> stats structures") made an unnecessary change which was to add a new
> line at the end of ocelot_stats.c. Remove it.

Yes it did. Apologies.

Acked-by: Colin Foster <colin.foster@in-advantage.com>

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index b50d9d9f8023..99a14a942600 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -981,4 +981,3 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
>  	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
>  }
> -
> -- 
> 2.34.1
> 
