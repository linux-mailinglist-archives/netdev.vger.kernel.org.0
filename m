Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0944D66EA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiCKQ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiCKQ6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:58:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F112C67A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:57:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csZMqfarJBJzEfECZrK0Ry0FZFdgKWg07BortKAMsh/eh4fxSnZf8DborOG5Xtpn6R3vl6DJixLbaRGolIj/+sc+0gycVQ2SrIiX10xb+tZO/BKR8jtYs199ATc3n4XigiLMPqXGwiMavgzd3ZU2NAE2LgLjUasRL4AJM6GIMK1WtDIOZtwsZ5iIpKH1HMOPDf+0KqIrEi99P/VX+Id3JjUq5ui4UQ/BWwTSdvADx0ZRcMVADFkQJWbYEhgwYzC4lQ3zn01qB0qhO0XWakSPmmlO1gwKkCZNAJwWhN2wZe/iY9j2ZIYIMWW2kTUcZeBX2oKgA6bGffMYRL5gknAQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvyTXvhisDpOFiRzBbNzzF4AaZ599s/mc1HpGopjPBE=;
 b=aYInm4aIPfG8e/vXpXRqD+puwiXlpgu9Mcj7Lcjd/o/Jgh27x9pPs6AnbrnwZXWAXHrMmpdofZSC8J8QQ+o6xihsqldSjON9V/zk3BoOGZyPg+/aeI7UPSMi6c6wevazMNIy4h4lXpXlkHhG2wdNsQ8498hVCxMnlHaUGeUEpNVZ1GQpdIzMJLwCLeX11gevcv7LZSVE4wAW9Ur+WVYJyuf2gJHz6RhKZ2sDoBTQ1ZiHoC7A2CxJmvmxrviotuNvNiqFO7ss3OH3XvUk+ynMf5mMrj25Q1nTtjZUgVqE09ImWvt+eRjzqW9mvjtxs4rTPcwbnbMmhXTZHva1fpjgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvyTXvhisDpOFiRzBbNzzF4AaZ599s/mc1HpGopjPBE=;
 b=OIIzo5gO/yguuimjpAiHkUkBY6So/DnGc6MZ0e7A5GRpFyLTukRKmaRmI3MfsqsziQrI7hyyqbYRITgTBmwYNoKa7uENHJh7Fci5LfucbN3msuVR0HlyU3uKMw7iK5+4eFrk4mCfV55TgJc4UaXIgfxooRSlQ1mYLJabexjDqRJZV/xulL7183WEolmXy7P4W53NZytuB58LJym2PCm+WoPlacb1k+Vwod0w51ai6XnIQy00VuYLLETs7/Gye5mGOIiUKemR5xRqEyOAf8a4rRMxsU80zRUxDzCBcu8B4lOVtcDoCGGBT76H5c4shSxHOcu0YFx8zqxA7lWzwWAErw==
Received: from BN6PR13CA0064.namprd13.prod.outlook.com (2603:10b6:404:11::26)
 by BYAPR12MB4792.namprd12.prod.outlook.com (2603:10b6:a03:108::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 16:57:42 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::d6) by BN6PR13CA0064.outlook.office365.com
 (2603:10b6:404:11::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9 via Frontend
 Transport; Fri, 11 Mar 2022 16:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:57:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:57:40 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:57:39 -0800
Date:   Fri, 11 Mar 2022 18:57:35 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <Yit/f9MQWusTmsJW@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
 <Yit0QFjt7HAHFNnq@unreal>
 <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f0346ef-5396-4d1c-3b57-08da0380416c
X-MS-TrafficTypeDiagnostic: BYAPR12MB4792:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB47928C0AE975921963626452BD0C9@BYAPR12MB4792.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cehayiFztPoEoQXBhVOSCtAcDfn3pRewPVHBww8X+ofIQDjO5bdIWguQYxNSJAiMJmXl0AIZ/evMQcviW4RPjMHOyZXgoU1VzGV3QVF9U+LsuktfsiDX/rHs1RmXXx+RpWg1jlO9tjCBsWe5TToD6Yj2oVI1RijNCUSGA2Yf0pVLv1303zEUxN9zrReCBFwTD2PIRKBWhIstWctqfFBAHq4t0947ZZfST0dBJVKv38B+vnnLZBa5aCEJOOX1fy6E25Vk32RRny0uy3E/eZkqybdzJlhtrbyGsBq+m8EUqyULnP3ErN/FQBL0QKh4qJ382lmWaBccYHafBv6lucSN1B6hQnL/wrchQzhLvSnuQpI6/wIrIGkyCDBzQOgLaQcIFfmTe5jg9keUoWz1b1VK11n4/DwbyCGr3OmQafoxw914HlNa872hWickC2P3CNJEBsBn80oQHFpWOSerUsIgwMa9PlmdmjbCLfBrNO11n+4k1mqoXpsMduGgXVaFgnM3c4nNFA+RE1FOQLF77/WFub7n6UjJw7G3QM563P3CTtW778HHMFcViJCUB8ZJd26FoyVY1YmAdkXudKEvF4rY8R89YU6tzUA3AnTZCrvTTMd6t6vsBIgiFWijSFR8EvmQ+xuIQOPedzGgQVsRCTAHHRFqyq5pbM9c2kISYJMp0IwFf/Zt7xAAZfTlDqxp3gvLWNqb5XqTdvMhKOIZcvO7lQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(46966006)(36840700001)(47076005)(83380400001)(508600001)(54906003)(82310400004)(5660300002)(8936002)(6666004)(33716001)(70206006)(36860700001)(9686003)(16526019)(336012)(26005)(8676002)(4326008)(186003)(426003)(70586007)(86362001)(40460700003)(316002)(356005)(6916009)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:57:41.2937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0346ef-5396-4d1c-3b57-08da0380416c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4792
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 08:26:11AM -0800, Jakub Kicinski wrote:
> On Fri, 11 Mar 2022 18:09:36 +0200 Leon Romanovsky wrote:
> > What about this?
> 
> Is it better? 

I think so. It doesn't create shadow dependency on LOCKDEP.
In your variant, all users of this call will generate WARN
in production systems that run without lockdep.

So if you want the "eliminate" thing like you wrote in the comment,
the ifdef is a common solution.

> Can do it you prefer, but I'd lean towards a version
> without an ifdef myself.

So you need to add CONFIG_LOCKDEP dependency in devlink Kconfig.

Thanks

> 
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index 8d5349d2fb68..33b47d1a6800 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -1762,5 +1762,12 @@ devlink_compat_switch_id_get(struct net_device *dev,
> >  }
> >  
> >  #endif
> > -
> > +#if IS_ENABLED(CONFIG_LOCKDEP)
> > +bool devl_lock_is_held(struct devlink *devlink);
> > +#else
> > +static inline bool devl_lock_is_held(struct devlink *devlink)
> > +{
> > +       return true;
> > +}
> > +#endif
> >  #endif /* _NET_DEVLINK_H_ */
