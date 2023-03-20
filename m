Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199AE6C1BE0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjCTQg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjCTQgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:36:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3110511E83;
        Mon, 20 Mar 2023 09:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679329826; x=1710865826;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LaQ5Ky3yNuZg+7kCdijI2So4iGAwB0u0uWkrAD2VGko=;
  b=FZeDU0DLv8xwDeXY08BdGrifGJqZ4Qb3qeRvwjt5PbMQHu/cYWHJUsSu
   LRZSUPGMgaWeF8obxQA4QJBNuSdMATDN/0zQ7TGsPDURJQjawHGb0xTrE
   UwUmAwKbb4LIPWzp+Uu8JH7EMur/1nJ2CsWeRKDRw5RfqYwToE5QUonkv
   CUi915Lmqz/wgJuU2XFx/XiKRtXNlatiWZZlIVzBTB6KKrJ2tZ3sWMQED
   H8O+96ECTlgrJ3+Mu5UaYUr74kLuX7tbkslXimzZBtMlHlIUHB43rKdbF
   8P/ay7nLGpuSBbZBnaPaa0XEp+LnAexZd6xmDG4AjW1T3JavbB2FBRvI2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="327084368"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="327084368"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:30:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="927018189"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="927018189"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2023 09:30:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:30:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 09:30:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 09:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPbYoVq2K5LMPCTkFRmU/522whIADrFfBrWkQdUAZ1QLV3Yg6/fywvPBHUeySHEBF6BZQjTCvIcz60IYnIMDFtdUNmJ3l+VueQrKmfKjNUu0UlZa9vHAZPYkjtajq+EtVZmAJqWUNdicYBeJ9FzEie44D2xaCdwb3shg2eSrQ5gSWUU5qKUDqVqj7WFRzLJwCUVbiwE1dxCYsikX00EOxd+aRqeG3jx8+lFTSR0mUlZ+wjjgdqx0Bsyv73vNKVrUJef57nCMth5gGas0LBy3tnEptcQ+Emv2XncxR7BTVa/dIcO3wyMwm0HckPfhiYcyZX4GcGnOGckIl6KR4fgQTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+J/IiMa1ZkGXdF7x04WiYq08+WqBRvN5UIZvYH0XTA=;
 b=e+ygjGvjdOtCvTB2OzJb4/atSfyp4PIekIVpfQIfK/RfOOQaO300rDlESF1IunozhJ0BiKlc13zUGWUfs1VXyrnt1Dz1e58tdO44Kcf/d650MhMRoJ3WHNnIWBnElD0rQcFRFtm5on0pjGjagNj1RrOxWGFPt3MvA/HVf+aENsJ63GyBFeH3IlA3+l/ySvmq/xUW0fDNvtzhiQDQfG+j+XFxmMIi4jyx6F1xoKPdFDnMIt+3kGZYfY5In1GAbnYtVqMQk1Y43sK16S5ecvOFnbm6kLm9kO2dRxFkMG3NQ6yJpmIpIoT1UqhDk/CA0j2Npoq9CNZMgk7p/KFCURwHpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 16:30:19 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:30:19 +0000
Date:   Mon, 20 Mar 2023 17:30:05 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: Re: [net-next PATCH v5 02/15] net: dsa: qca8k: add LEDs basic support
Message-ID: <ZBiKDX/WJPfJey/+@localhost.localdomain>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-3-ansuelsmth@gmail.com>
X-ClientProxiedBy: LO2P265CA0405.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::33) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM6PR11MB4625:EE_
X-MS-Office365-Filtering-Correlation-Id: add06640-825a-4619-002c-08db29606507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tg41bBBEOUCH4GzHdhG+gTAV8mBtSlQBQic2/Kjgfdgg2fdB1uRsuBCqZIy3cNHSM++AZ1Wi19FtWYWtaKjnGxswpo6+kQ0Y5oq9I5zMVt0pLPtQcgqZlcI1gUBbWmIOB8CX4U89yWqogQ0kPuxaHPfYTcglfY2BOcLJoBit3ETjNm9YdS09m84ZtAM+FCm3QzD5H5gGHky8FYnvwWlWlw1VIAulAy8PD2MFXWmb5IOk98Pi1kkM1e9JXQrvPst9+Jmc6tSEYZ7ylCA/IsDBmse3Ul7vqHipBEDBPNJJaxJK2oy8Up/bAlRqjwvvH55loplJABslZ8iO9zEDO1flYzSzmu8xULou9SzjbJc4oJPpJt3M9YZkvXN8oDMw7cs2sFzzzVBWKa2tEtbKWGcwCvndQfHsY3Q9FZJmxgTRvLMfV6NftNvtL7zX12yjO1DJBdFRU9jQORHo+hkkNYvVH68rVSmBv+Rju8IJRyGvBjVZPiCmFbMwYOOgGyLFJ9vwGonuOORRLNoBo85CGvzd9tSKbKcn1a9d9TrVRitXAR0aHRID5VWbJH10e7sqOxEf3P7vZzOrsZzW0zyygb9nWEIdXD6/O6yh869HfYeKjIGqoeZU2oVFdvrM56+irc1R5FeEnsx98IgZ1ALce5HMhUCMH5OH6lWYp49EnkMzHWAQx2HULHO+JHUmv0mDYME0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(44832011)(7416002)(41300700001)(86362001)(38100700002)(82960400001)(2906002)(4326008)(6486002)(83380400001)(478600001)(6666004)(186003)(26005)(6506007)(6512007)(9686003)(54906003)(66476007)(316002)(8676002)(66946007)(66556008)(6916009)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xs7J2Y4b5yAF+gx+V/PgjyzjD77aINykeli7+eJvDwLm9wGhpnevy/gCn5Mz?=
 =?us-ascii?Q?pewSxcNoalnOVzzfLsGULWKRPjE9oty/2DeYZhTpApOu/plo/65CiaAE7vMF?=
 =?us-ascii?Q?RPl8dU7E7M23mxasRDHvGU4SRgktg9g5dBWpuUM+zHOLC+ekOamZ8lDJWuUe?=
 =?us-ascii?Q?eVWL1YEyTVu2T8dhKqhACs0D29kqEftbbw7EUc7qSNX0vxDJI5SH8lVdLLxW?=
 =?us-ascii?Q?ZuKIaiAwSTnrlSUEEPGxQGD4q4pRVb2ieHY5Knpr+amjnA2LU007t1y5/2Wx?=
 =?us-ascii?Q?Z5cSSoVPymIWJTT/eC3GqNEM+ZFb6NdPLMUGczPp07F0EBhpZEhPup1wZFGs?=
 =?us-ascii?Q?0qVLFnJtUJBvrg0VLveeTIbR15Pso8d2YPxPjpO1IC3ITwwNx1bhYrVvlqRx?=
 =?us-ascii?Q?kebAiXasIriPw6xyql7QJb7E0RiIA2viz5B2clnR39lhAyiKbSXa/KMzuE5p?=
 =?us-ascii?Q?ZI3gCH0hGqGl6nAMyjXPEW+vid7KxCGAojfsC7MZdSWWWWYSaobKpzyFvTfd?=
 =?us-ascii?Q?c9kGAhpTDezkk1BKY+p95QkUQcb8h3S5WunvBlUolzXm+g0VG8H2EHSW50yC?=
 =?us-ascii?Q?8+zT1+N5ykuvQzWjPiNQxkLQkqdPGsErZp8qcCslD9/flMn89CBvcINH4HrQ?=
 =?us-ascii?Q?0Y/C+fu3nDrAcWLjREU+ZHfbDlFry6lhAMJ5FePgqXBKiPEwFWwfrXkk9lRe?=
 =?us-ascii?Q?SBJKxhdE4gl8iZuo06q/6qUF/qOseDUWF01At06nFtz9tV5DnqKHL7mIh2IR?=
 =?us-ascii?Q?ynL4L3jrcFDdvdHQMCDzaAVa+QkD7sc8pLkMiPbYJoSfW0T1WH3LkxVGYCil?=
 =?us-ascii?Q?0bV0kBK4V0AYlwtPQ8LCDY7P9vckEG8Tcv+TpsDpsYVEiNpXZT6yDnfRxazA?=
 =?us-ascii?Q?VdZwRR56kyaPbcRyVpTiN6lXBQp/RCPYnDWhur+xRLiQVcOchc5q67GsvXAN?=
 =?us-ascii?Q?HdJwQBvKV3hMDuSLa6zHTJK8z4Fmm2RHgO/uAGO+h+fVgyVOiqzS0qVY52y9?=
 =?us-ascii?Q?EUeeKKMCMzbBdDJE+Q+t0x9grjc9i+n1zNVqLzSsVhDNZFXGyVkcxW3mTJfo?=
 =?us-ascii?Q?MHyEqJ6wMR34n7vMe0snhW5Z7w2Dt3lO6W/T+gkOAh+c73oOGsbcHZPJL34m?=
 =?us-ascii?Q?CVQ9mVAtcY2S1HmGAMhm4AguCQOfEUCT0sCNj5zBYUpwTurPBCSB0OREtuSX?=
 =?us-ascii?Q?hXwEIlQcQhQHC6bNGe4G/AmDNkFIc980SJMh5f4Ov8fJbbtbxtwVVJZyX8Tm?=
 =?us-ascii?Q?dxHL/xrfZF2X1uvcZwrQbqauVnXT176ppQjwBrciaP0eRVzx34KVgpmJLrLv?=
 =?us-ascii?Q?pRtrF17WyJQz+OtaVdZEJucDss8V3i9MSy0gabLlE7WEfMAgn0F2AR7Bh7xl?=
 =?us-ascii?Q?0GwBou2ULmjsQfjgqk9S67KpHJJU7Wu0SU80+Z0sxR8Bv2/0K0uNY0Eh2Ct+?=
 =?us-ascii?Q?clGXmL77/vTK0YjN7Ix6QBjwk8WCkCc9ne7VAmCiGIzbtuQeaAxrO0FRhYMO?=
 =?us-ascii?Q?SshfvRn9RH1E+j9qCta+VbieWTeb7zD5bm47J0F2ELiHU4ujI1LDNy2Vpy5q?=
 =?us-ascii?Q?jXLyvfe9Y82nKUDvSLtRH37qL/+cE4hqT5bqMhSFD+wIKnDZW74zFCmdd4c4?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: add06640-825a-4619-002c-08db29606507
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:30:19.3957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neXp1FVLNF7qLbhBem/xKmPv6TTCxBEedwpknf/6oWfYRNfSeyB9oqvccqtvKAhMmsLWh3DDXxs1jE3uGd41jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:01PM +0100, Christian Marangi wrote:
> Add LEDs basic support for qca8k Switch Family by adding basic
> brightness_set() support.
> 
> Since these LEDs refelect port status, the default label is set to
> ":port". DT binding should describe the color, function and number of
> the leds using standard LEDs api.
> 
> These LEDs supports only blocking variant of the brightness_set()
> function since they can sleep during access of the switch leds to set
> the brightness.
> 
> While at it add to the qca8k header file each mode defined by the Switch
> Documentation for future use.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Hi Christian,

The patch looks good to me. I just found one nitpick in the comment.

Thanks,
Michal

> +static int
> +qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> +{
> +	struct fwnode_handle *led = NULL, *leds = NULL;
> +	struct led_init_data init_data = { };
> +	enum led_default_state state;
> +	struct qca8k_led *port_led;
> +	int led_num, led_index;
> +	int ret;
> +
> +	leds = fwnode_get_named_child_node(port, "leds");
> +	if (!leds) {
> +		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
> +			port_num);
> +		return 0;
> +	}
> +
> +	fwnode_for_each_child_node(leds, led) {
> +		/* Reg represent the led number of the port.
> +		 * Each port can have at least 3 leds attached

Nitpick: "at least" -> "at most"

