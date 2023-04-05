Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49A6D8577
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjDESBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDESB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:01:29 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2080.outbound.protection.outlook.com [40.107.13.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3156759EA
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 11:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9i47PUml9MBvrWOCy4GuQh8uWfWs3bueSg9+xcno2ca2CLOsISvGsm6mLNHezS3o+x4LL3ECeE6Vkbb68M747zh/Bw80WS/zaHW9aNm1vyKluHVW3+2pYtgqgD970XcDt3K0rVmQ+kCB0TYty6YrDG5+ITgMeGQIEnaR4s9mlWAGydu1Y6LwygrOKj1RBohI8yPCnUOXESgnTqYQcAnpjJd9A7iD7zU8nxoJ7+TYo/2oY+Y5NxdTJRuNXrEfM3WjwSvMMVfJtS42w1NqEZTyLUtlPoeA5cdWmcy3mpTM4xQzW5spu6AnDrCvcaH0+fg76xcC2CNjVcxsmjsUG1y5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bF4aRoxXZDWuU/XrQIAFA4zN2XBCAZQ9NWATN/dYGw=;
 b=V8EnRIEzGxFq8CHZ0BBXczgPKYJxKQ+ViNXoD2VZ4/yVEfN7Hhj6sA7+pwdalfFKX/n/ZejXknAWUrAfT3zrN3ukfpArqdixaXTUzFRkSJBjWWjf3/hS8YkxlGoukQlmDZzHdIZO+D6qIdLtbpqW7AyZs0fs0OtE6dBTp3f7omA1+tiK9qdxi+lVS0Nvb57VE3wJPTkiWxyIoV5G9bATbXKN9UQGXrM08XcAztlCFlKnJ8Khy8z2IzrFmvq3/lFHHvA1lPCeUQzRxSH7gpYzNnM5w1a1gaQtKgUvX1CfozyGlsMVxnzWOnuiPKD3Q5LfKuZ5g0geUSOkG93LaLR6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bF4aRoxXZDWuU/XrQIAFA4zN2XBCAZQ9NWATN/dYGw=;
 b=JGQnfnYILMHccg9Izl6OBnTDgW+jXy0h7grAwF80ZhuRPzKN3uRPIVPB4jItiNCpJMNYLwvnVnHGpaAD3IcK5BAXcKYkc4jc5DJhlM1jdMavLqhjxqe6i+kM+k9+gmrQp/zINWMBf6WZeVeRGgJD5/QpVeIb/gqEkisLP8INph0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU0PR04MB9394.eurprd04.prod.outlook.com (2603:10a6:10:359::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Wed, 5 Apr
 2023 18:01:25 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 18:01:25 +0000
Date:   Wed, 5 Apr 2023 21:01:21 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405180121.cefhbjlejuisywhk@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf>
 <20230405104253.23a3f5de@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405104253.23a3f5de@kernel.org>
X-ClientProxiedBy: VI1PR0901CA0092.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU0PR04MB9394:EE_
X-MS-Office365-Filtering-Correlation-Id: f066342d-3055-402a-cd4f-08db35ffc591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ts8/X7Qxg3J101+InpXU53Db0pLR2nbUXkJUaRzAehamPejmRy6k1KwaxV9Jf4U17eGngS05msD4JwKHZZCvhmXnlFyH8RJwV3sMDCKog1jSpD3OoqBicHztLX3QXf/hgVqEYqQHpK2vll688y1pwyA4LBf8yCv509DVqcoquhnEOKZt4OzogGltRXFyi7ZY+TPFOPNuNuBpXjYesyVAXxzja+bzkyCtv3PuvXpyyrCGlAWqD/U1fTGlZrJ+1Bm4iHWVd6kfAojDj1Pi543cfkzcJTRTod+eKRXsjI0jzTBS0xCKxG5dgVTpknHx4+vlXnVKqZBRjCM9IUMF3GqDjeZNwdDjDZbtNDi3LDgw1BxFSEisHhKnsemheA714BgLYhJEftWpRlQgffz9t9/RxxQb5ky16f3nRL7WP/87kafOKO2TVp62nWxDf3FJJnbSqg6LVQAxRvgYP7nf+EQopEl/UzyMosSbPMtoPwEQKITNnzWIWhpfgfv0kWrvlp7t2dvrTe9/A5sFkHhimH+FzXmkW6z5NluWDc2O0ZPtwQg1T19S8aI7JcNn2YgVA5Xj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199021)(86362001)(2906002)(33716001)(3716004)(1076003)(186003)(83380400001)(6486002)(6506007)(9686003)(26005)(6666004)(66476007)(6916009)(478600001)(6512007)(4326008)(66946007)(41300700001)(8676002)(44832011)(66556008)(5660300002)(38100700002)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a+EGc8jz9AaE3Z1ol+c7eb8BpNoSmbyW9eOVIffqQkPlc3nsyEYvknbsi89L?=
 =?us-ascii?Q?NKs6LDZgz3pV7OnV1WbPL8e1D/HkykKm2BR/C3+m23YLXp/FHNBb/j98rGiX?=
 =?us-ascii?Q?DdeDtJaOI4t6Pq3Eeiuz8DNqhXa6bg3TgzrIIIpo6QzXF3M1j49xGcPmQqK8?=
 =?us-ascii?Q?tjBXoK6m6DeNHhZrOKqBVo3FKqjrhckIIFcX0W9XXfr9h4WJS1iBekUmUR6H?=
 =?us-ascii?Q?bkEGEdoTMNxCSMlGIVHokkWMxbodBC9L75aSxsP4H6jttCRnDHhXFpAf7EZv?=
 =?us-ascii?Q?59qjakGYJQTVWcwRtKiiPHTk9PJ6GRvXsNcLrgB1WsxtOpXhrCZGLRcW8Hzb?=
 =?us-ascii?Q?CE3tQUE9Wnvt+uUMaZ9uq32RF5afHG9ClNI5X7sc7JuqK26wpT6LniriGfP0?=
 =?us-ascii?Q?LwimEzay5wkuasl6/MgKJh1nj23qHIR3Dt40g1XqVRkf6XeBnd2Nl4bpVzI8?=
 =?us-ascii?Q?/1owvOs11o7z1iAKbuyimKY/e16zGGmpJLnFPdiby5jxo9Sug7dkgesqAwpB?=
 =?us-ascii?Q?/7IvVPAerkpjOXFG9/V7mg8wTRq1ZQU/VlROPnoPhIDzwCQiRCBrGS6GGg+e?=
 =?us-ascii?Q?X5cXeVFGntOE5w+74b1kHVF6xeaoC26f5oyeG1tTEXhlT9x1WHS9gN3IiTwx?=
 =?us-ascii?Q?QZvg4xCHGBMhFIugnv6DCMbpno/LPenx542I7PIZbdAWALAuNtaEAbASV24u?=
 =?us-ascii?Q?Oa4RoKAu23S6i/iQiTrJzX+odGBGY25U5N8lXQMmnS+6xNvcRjMOwudJ/e5W?=
 =?us-ascii?Q?Fs89T8UUPz3mZAGz6MVxleEsbkllmtpCxFfapUvLsTS5SWqxBEJr601uaCiT?=
 =?us-ascii?Q?DdbNqLvDgcFRtjCMFUD9HRZoNQgO5pMrbCnx+Y5mwhedlhDe6k0UzhlEhEk2?=
 =?us-ascii?Q?qXMNNbXcRJgjmMLX0yKEdoAESUHQStfCZxFu95sayrPo+kcAVezYeY3DY31b?=
 =?us-ascii?Q?AjTlrxbIC9yp8fbXif4DzzzUDCC3CWw/e6rWdPg1da40Qgz6Fv/IaLqKlUQm?=
 =?us-ascii?Q?GKWI0kyNYyeiaD00+B0NYxbgCWVy+Y+eZpEPu+nqW4xEnQ68h4WLi4CdUl6v?=
 =?us-ascii?Q?UpAuA5VxZI0Ph7RIQkF0jEFHTII6fYkVoiSoEL9kmaUHD9xvdjC9DutIBgpB?=
 =?us-ascii?Q?TVjwSe01Wof1kJ2M71oICq3pqbQAGkImaGFBraiTMvlb8K8eouies3UKxG38?=
 =?us-ascii?Q?ZZDOrAxVNg8ElNO9TuYairGompalycDTWx/b3Ce9iXl7hhDnVXte5BjzoVOS?=
 =?us-ascii?Q?uLhkebfu/Y8hsd+fOKDT2HNLpA07W2D35oPQsddMUUPy+Zqbd4SpM0PKn8N8?=
 =?us-ascii?Q?KHuuaESkKtc/6Bqoqda4xSrZU5hnZeEfCJ9PDc6Qo6CmNeWJLnoIoRctslMG?=
 =?us-ascii?Q?bC8Q/+Seb59EFutgMFuO2ipeI6isU3eEGDWnkQjSWMfSPLQynNxI25ar3Hbb?=
 =?us-ascii?Q?7HnREPFZ9HO6bpfyRq2cON0pltJj+3AvGVm/WTekTmcT9mIL35VXZdl6HzP/?=
 =?us-ascii?Q?Q5SiXqtPOOk+VtUHw157UNUm5ay0HAg0yt6puuDv1cyrspX/ab/XpWToh09C?=
 =?us-ascii?Q?u7Lwyhn87tHJOZGesFbFlFQDGEBhdemHnhQk+dp6BHIG9FGwl5/l9avdYkI9?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f066342d-3055-402a-cd4f-08db35ffc591
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:01:25.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rB82GGuKNjScKr/+1mSpuX9zZ0noRojOb/rJmvQVcB8MWZpNvFxJXbm0d2X7EXF/5cjIDif9KkOir4LabQcGjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9394
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:42:53AM -0700, Jakub Kicinski wrote:
> On Wed, 5 Apr 2023 20:28:40 +0300 Vladimir Oltean wrote:
> > So what do you suggest doing with bonding, then? Not use the generic
> > helper at all?
> 
> It'd seem most natural to me to split the generic "descend" helper into
> two functions, one which retrieves the lower and one which does the
> appropriate calling dance (ndo vs ioctl, and DSA, which I guess is now
> gone?).

There's nothing DSA-related to be done. DSA masters can't be lowers of
any other virtual interface kinds except bridge or bonding/team, and:
- bridge doesn't support hwtstamping
- bonding is also DSA master when it has a DSA master as lower, so the
  DSA master restriction has already run once - on the bonding device
  itself

> The latter could be used for the first descend as well I'd presume.
> And it can be exported for the use of more complex drivers like
> bonding which want to walk the lowers themselves.
> 
> > - it requires cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX to be set in
> >   SET requests
> > 
> > - it sets cfg.flags | HWTSTAMP_FLAG_BONDED_PHC_INDEX in GET responses
> 
> IIRC that was to indicate to user space that the real PHC may change
> for this netdev so it needs to pay attention to netlink notifications.
> Shouldn't apply to *vlans?

No, this shouldn't apply to *vlans, but I didn't suggest that it should.
I don't think my proposal was clear enough, so here's some code
(untested, written in email client).

static int macvlan_hwtstamp_get(struct net_device *dev,
				struct kernel_hwtstamp_config *cfg,
				struct netlink_ext_ack *extack)
{
	struct net_device *real_dev = macvlan_dev_real_dev(dev);

	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
}

static int macvlan_hwtstamp_set(struct net_device *dev,
				struct kernel_hwtstamp_config *cfg,
				struct netlink_ext_ack *extack)
{
	struct net_device *real_dev = macvlan_dev_real_dev(dev);

	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
}

static int vlan_hwtstamp_get(struct net_device *dev,
			     struct kernel_hwtstamp_config *cfg,
			     struct netlink_ext_ack *extack)
{
	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;

	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
}

static int vlan_hwtstamp_set(struct net_device *dev,
			     struct kernel_hwtstamp_config *cfg,
			     struct netlink_ext_ack *extack)
{
	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;

	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
}

static int bond_hwtstamp_get(struct net_device *bond_dev,
			     struct kernel_hwtstamp_config *cfg,
			     struct netlink_ext_ack *extack)
{
	struct bonding *bond = netdev_priv(bond_dev);
	struct net_device *real_dev = bond_option_active_slave_get_rcu(bond);
	int err;

	if (!real_dev)
		return -EOPNOTSUPP;

	err = generic_hwtstamp_get_lower(real_dev, cfg, extack);
	if (err)
		return err;

	/* Set the BOND_PHC_INDEX flag to notify user space */
	cfg->flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;

	return 0;
}

static int bond_hwtstamp_set(struct net_device *bond_dev,
			     struct kernel_hwtstamp_config *cfg,
			     struct netlink_ext_ack *extack)
{
	struct bonding *bond = netdev_priv(bond_dev);
	struct net_device *real_dev = bond_option_active_slave_get_rcu(bond);
	int err;

	if (!real_dev)
		return -EOPNOTSUPP;

	if (!(cfg->flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
		return -EOPNOTSUPP;

	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
}

Doesn't seem in any way necessary to complicate things with the netdev
adjacence lists?

> Yes, user space must be involved anyway, because the entire clock will
> change. IMHO implementing the pass thru for timestamping requests on
> bonding is checkbox engineering, kernel can't make it work
> transparently. But nobody else spoke up when it was proposed so...

ok, but that's a bit beside the point here.
