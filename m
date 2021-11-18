Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4375B4564F0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 22:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhKRVTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 16:19:20 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:17565
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229521AbhKRVTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 16:19:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOPuClXbkgilvUzHdC6zpEcaD5wCHjKZqhSLONta6x0nFH++0YT8XxrsqZpq1Hw1J/CrveAHC5wg8mOok/PZGU0qjYzTtIOObzLXnIDRWL1U2bjqxIM7OJ5F/S4FwOm2S1WDpdEllyOyXHPCfym01Z/rG3CrVY2C9QC1iiPQjHkm1X/sFO4stQtzbKIkCf5aKimFf34W/j9f7TQvmhheB1QUB5EkVg0/SO2tnTwL78U69KHKbl7KyLRsRJ/UYtyoXyGa4Yat6JZTrsojxIMjuqz3BfjHlXfLaiTw4xXasDEaOat+5SXX+qABPmCwupQSQt3m16gKOy+nTHTzOkdaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIcHC96cODxVuvt/nDoQDnR0+bfG3CbLoZTRJ/bvKHw=;
 b=TENwWJI9gagBLsCl7rI+J/sEMgUhUYh1nYaGvSJ4kfKIFfRVwTaB+4htt5h4qCQ1Dj43ODOUCFxbWbF/Iurz+3h/7jFTDc7jW9ATaE1PuuR+moDCz7SF376PlfthQuhq277G/ZNGAv7vNtoPLMBKPzj0ZBRtA4flJe2+++ygxklRJ+Y2LT/hwjZ8VZ5LRRUTa1vyopUbWlR0XVckAY1Ig0aVlGin56EJ+yEEktNszh29fVaAFllTxnyzY4xcLpRDwbDIpBiAgU11vQHelby4cNVtOlIhfrjEFw1IievsWRQfazlRBb2mjh2JpnvulShz2AIsyIkPghuJ0BZaLpYK5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIcHC96cODxVuvt/nDoQDnR0+bfG3CbLoZTRJ/bvKHw=;
 b=qw03tD/VE6Gs4ij9qwgMiUvv8ta9JPOxQcSjUXZA3UbTVa4yhRQMoQm+oMW9QXjUd7lPC8KxnRLCZC0jhDmqCv0ZJmDICyLA7PKLiUvzrCnYryldmmr7u0d+t6IvixDFK/RIYFCBOYtUOHOQs/M/y6vHEIg1BhFxKUptYAkd4Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7418.eurprd03.prod.outlook.com (2603:10a6:10:22e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 18 Nov
 2021 21:16:17 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 21:16:17 +0000
Subject: Re: [RESEND PATCH net-next v2] net: phylink: Add helpers for c22
 registers without MDIO
To:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211118161430.2547168-1-sean.anderson@seco.com>
 <202111190547.Axd0pXwW-lkp@intel.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <4565f83b-849e-0b12-93ba-5e861bbd8f7a@seco.com>
Date:   Thu, 18 Nov 2021 16:16:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <202111190547.Axd0pXwW-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 21:16:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08947098-8848-4dae-093a-08d9aad8a8aa
X-MS-TrafficTypeDiagnostic: DB9PR03MB7418:
X-Microsoft-Antispam-PRVS: <DB9PR03MB741823F2E74911FACF17DE68969B9@DB9PR03MB7418.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLa6WvRpZ/l1JxkSeSJLq0urnoH4vNRxNNUtmL02jzbPekihXQcwBJw3sv+tgzX/cUJmy2HLJqFJAO6c8w9NsJ2XwSLPBvorleeul02G1NHIkBB8TSCQp7VL6o9jqFwgeSRe4z53Ft6Ie/cKQj3eDDZGrklMQPkOzBpkeL0pMJIxkL8PkJgakQuZjisioOAVh2UcrSl9BY7Lp5iSPUnJcHRqDDvi0aczQohdjMXJ1VZONm9DIT7LxjSOMr6Q05mgbZ3+oMmUS8T8DkJj1InflrIMqqC/dkHsi1lNonSgA5hhFjZLR8EAV7EYlDgYUadFSEPmQmRd7c6LNrIOjYrL90/Qc6792FTNCFgaqhIIzSlRVcjuZ0loACHBAiiew9Pdd8ZL50KVzjZiL8fQNMswZiNiTL+SrRkWm+Gf3zzvAn+MUlyFrJrIftNLvFRD52GbtqKxr6cQ35wnjHBB0hL/Is2DcQLuecLAAJAEoa4Pgq5tqxuXN83zW1hqy6akAvVGrp+E9+H0GMY4UScQtBfd0FUcPpAMBfRv74siv9sb1aIljm3Eh46LFxh+6oHW8wUzVoUfPcJmdJwsn52w9KE2WrfyVjZqfAw3BLZtAW2ToZkLqPjzCdczoKJ5T2elUUv3GeVqkdBQZYNGLIbatvkr8tH41KufdKxcSqZqJwyaAsoKOS09NHtqWJIXJ5qmU+6UsjvPNG3HEm4ax5idkMnPIAshFYIiRNBlhHXQk1c4SsgITYyafff2jHbpZPv5/fO7D+cIt0iEF+sWNrPiUERSj8Rl++O3yTmfop2LkWn36BOS97HycHFuYXB4ppjnQ8HK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(66476007)(83380400001)(54906003)(316002)(6666004)(86362001)(8936002)(66556008)(66946007)(186003)(31696002)(6486002)(31686004)(16576012)(52116002)(44832011)(508600001)(38350700002)(38100700002)(4326008)(2616005)(36756003)(2906002)(8676002)(956004)(53546011)(5660300002)(966005)(26005)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?IXD+ji7e/rqubMHOzb7MD/HuR7mxZoM3lEhLzKC7snL6frSz4OwqYZFU?=
 =?Windows-1252?Q?wB5venodAIpAUgEKdId5gKTLteUpL3XiQe7zyArexgKVHQZuVW3Dvzao?=
 =?Windows-1252?Q?XbNmGQ9nmi1R2sr+Tl12klLCPrjeUb7JoNmzkSKURrfQzT3jPDer92a8?=
 =?Windows-1252?Q?agQ8f66kJMrDM1drjecfA189HD4LNLDxszyY3BUDMmRVieep2wLzA329?=
 =?Windows-1252?Q?MYpJVCbQa6iS6QK+x5O6b629ydLcwVOhrvf4UVn/zNVZejMU4Z/fF9pv?=
 =?Windows-1252?Q?PQvawi70Upa2ZSQvIIBWt8SJELY9AG6GZsv02SPSL9rlurt2t470sgT2?=
 =?Windows-1252?Q?y6t9PioS1DQ7+1uReUTjvrSN/3TMs97fL/W3Rex0fu+aeP/cVrR2e35B?=
 =?Windows-1252?Q?Afkn8a93o3QZP7b0zb2lZ4aLZdrevWaqhqnyDGj+3LUOC5C7vDWHtXWB?=
 =?Windows-1252?Q?BUZ6k8tcgtxTYzGlW3NNVqvKu/oSQkyPhGb3YV00nkbT10HgvnAW8pEk?=
 =?Windows-1252?Q?SjskImgP2JDGCVdE18i2pg+666tBaDXRNVM+v3Rz7QUKd6xm6gk0Xt3D?=
 =?Windows-1252?Q?SXpyrtePIxRGQozRa9l0x9KbdM6+yYN3Rm16TqCOH2QkoOgGyR1wLxGi?=
 =?Windows-1252?Q?dDFH0zbz34wu36fOctoBAy/KBxw0gNWJNUa5JCBw3wkvTj/cz7aI0sZc?=
 =?Windows-1252?Q?EuCCap6zlXrDIO6ttX2Klfm7xSUQC2fFLW9MAWo81wOIdWv8tim0IUUU?=
 =?Windows-1252?Q?YxodRXS8QHyUlP3o6mN1/lSS9QM06KHNm1Q+uZnWk7vubXb0T/UlhHQl?=
 =?Windows-1252?Q?EjuflAJjKoZPdS/8cNbsSS/bS9pgE1kgP7KZVAkFPo09DvrHAKHQgpF6?=
 =?Windows-1252?Q?z+npNDxuYHp7+dkb1h7/AHJEtNLz2imeqTznAgQOfIATIjM78CYCzdlr?=
 =?Windows-1252?Q?c2hfvB70TAtH2PGxKgYgQtRJ9xsOXoYvG/uN5+d173vHU/x0j4eo/xzW?=
 =?Windows-1252?Q?49rAU8JJFudzE9SvOK0COKsmglQTAWXcYkM3mjjeB49i2NSKuDDQ01Wv?=
 =?Windows-1252?Q?Shry1+Ar/U5ctniRhVKoOFbw1gAebxxKwETrmrkDZEz8u4rMxPNcE8xQ?=
 =?Windows-1252?Q?hA4i9SasLtnhVr4OlRyP8GRPails3xBp3P+qQvpu6UTMOvKGBz7ctDhq?=
 =?Windows-1252?Q?MBoKshKIx2LHwNLXK4BNue1IoPNJOi4UW+55fVo53S1YpBXfCmXfqw1V?=
 =?Windows-1252?Q?e7tpEg/g77sj370mu6lj/XCrwbso/ahMm2BtRDczl44m4FFCsBCXpDvR?=
 =?Windows-1252?Q?2I8aJ6huWaIk3yVoGegQYmNVaZXND2I5s6UoB5QxUUtE4ml8Hv1sK7dR?=
 =?Windows-1252?Q?3a+CVnUNuxFOMeBghoMq5FuNyPznA8Z/99MAby6Vgsf3Tb26UIdV/Gpb?=
 =?Windows-1252?Q?Pj0LZP3GS0uPM3FEQ70yenqd4vXcOiRukRWPkzWmF46D6R9u5OjtT/+Y?=
 =?Windows-1252?Q?6ttltoDPCdW/imOJiG/c4E11zHRZpKwQ/TSfdJGe5q7LsUp6IJMpwe3M?=
 =?Windows-1252?Q?3cNJwrAYLMMaV27a+11TB2tSA/XgwPsFb+FYZPwZRXcZCtf/ltaNWT1c?=
 =?Windows-1252?Q?DambnJWQSrEf8ci/+MSrvX7TwpMfuiW6Lo4rQBrSKnep8C4CVp62YO6p?=
 =?Windows-1252?Q?Cdgnx/35G9n2csgXCorXvT4fcLitlhZNm/cYNShC6ySuOqZU02PUpSM2?=
 =?Windows-1252?Q?425/o5gk1IEYd6v3M3A=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08947098-8848-4dae-093a-08d9aad8a8aa
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 21:16:16.9998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heX5NAR4mjsrua46S1/yChnyEJQPYyJjBD6aneQhdW8DKQWI/RjAaoHDV0+FcYpvpFJqv8ijpHpb/GjsUyU8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/21 4:07 PM, kernel test robot wrote:
> Hi Sean,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Sean-Anderson/net-phylink-Add-helpers-for-c22-registers-without-MDIO/20211119-002726
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git bb8cecf8ba127abca8ccd102207a59c55fdae515
> config: hexagon-randconfig-r045-20211118 (attached as .config)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/1af77aa70fbd03602e8db3d621fdaf4e8a301e98
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Sean-Anderson/net-phylink-Add-helpers-for-c22-registers-without-MDIO/20211119-002726
>          git checkout 1af77aa70fbd03602e8db3d621fdaf4e8a301e98
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> drivers/net/phy/phylink.c:2952:10: warning: result of comparison of constant -22 with expression of type 'u16' (aka 'unsigned short') is always true [-Wtautological-constant-out-of-range-compare]
>             if (adv != -EINVAL) {
>                 ~~~ ^  ~~~~~~~
>     1 warning generated.

Hmm, looks like this should be

	ret = phylink_mii_c22_pcs_encode_advertisement();
	if (ret > 0) {
		...
	}

and just eliminate adv

--Sean

>
> vim +2952 drivers/net/phy/phylink.c
> 
>    2930	
>    2931	/**
>    2932	 * phylink_mii_c22_pcs_config() - configure clause 22 PCS
>    2933	 * @pcs: a pointer to a &struct mdio_device.
>    2934	 * @mode: link autonegotiation mode
>    2935	 * @interface: the PHY interface mode being configured
>    2936	 * @advertising: the ethtool advertisement mask
>    2937	 *
>    2938	 * Configure a Clause 22 PCS PHY with the appropriate negotiation
>    2939	 * parameters for the @mode, @interface and @advertising parameters.
>    2940	 * Returns negative error number on failure, zero if the advertisement
>    2941	 * has not changed, or positive if there is a change.
>    2942	 */
>    2943	int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
>    2944				       phy_interface_t interface,
>    2945				       const unsigned long *advertising)
>    2946	{
>    2947		bool changed = 0;
>    2948		u16 adv, bmcr;
>    2949		int ret;
>    2950	
>    2951		adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising);
>> 2952		if (adv != -EINVAL) {
>    2953			ret = mdiobus_modify_changed(pcs->bus, pcs->addr,
>    2954						     MII_ADVERTISE, 0xffff, adv);
>    2955			if (ret < 0)
>    2956				return ret;
>    2957			changed = ret;
>    2958		}
>    2959	
>    2960		/* Ensure ISOLATE bit is disabled */
>    2961		if (mode == MLO_AN_INBAND &&
>    2962		    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising))
>    2963			bmcr = BMCR_ANENABLE;
>    2964		else
>    2965			bmcr = 0;
>    2966	
>    2967		ret = mdiodev_modify(pcs, MII_BMCR, BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
>    2968		if (ret < 0)
>    2969			return ret;
>    2970	
>    2971		return changed;
>    2972	}
>    2973	EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
>    2974	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
