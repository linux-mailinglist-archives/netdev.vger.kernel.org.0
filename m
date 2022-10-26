Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB56260E3D3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiJZOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiJZOzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:55:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BC620BDA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666796095; x=1698332095;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=daCdkqbOdnrIhHyIy3jfXCNjSB1AGxk8iQvXm6lGDFE=;
  b=RwPRG3hrgbVFKzVVxRGdy1fazTS8u5pB5dLJOkhD7uWDoCk907CgAzND
   H0KtQYT3X0DlDH2NFVn/YJhR39hpbe61D2iX4lz2aOHuAWDQ1+N/Key4I
   aexOc58PfR06yIJs4KTpRVgCRw8MaxoXvtwuGNS4bSl5MxP6eBHkFv1z1
   RPuVRxardcIlDVSu2tqxagGvGeL+OMwO6YQzhLgvOEkEjD002I6aMaogw
   oxexIaCHaCqMZXjfu9hbjjADyPds40vMDfUwQmGzghCNaCqPA/E+Xb2Kt
   hf7W7Ox5frLB2bSQBnfsUApsrv+KoMSPKtiGpDoCLxLJ614tlyddeQfYr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="287679759"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="287679759"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 07:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="877216585"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="877216585"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 26 Oct 2022 07:54:55 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 07:54:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 26 Oct 2022 07:54:54 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 26 Oct 2022 07:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUgcVosAOW3dwufFuXU38rwtI9TlPjPstCmmrKbwT0LU298yAwxnVidCW8l4FSU22V8Ff9KVkIph2XWqkUCnc5RYWasjoUzz8xA3xzAsyl6HDSBeQ2VceIP/042zImib8ovhK/w6O1DlTidZ9KTpZVA6iwSkKEJu3EiXNfqt1Haqg4o5XWl+ZheEANUgSuzhNZKhHJJCmw8B7OpoTaNPNbhOZcxDJhwrq1bX6nSVIESlPaeRoY3daR6YnZqT++TmHpjE1ZVjuM/Bj8GcqTe+hDVcGekJifbRK3tGi288dJ4JXNuvk5iPV0Im0VVZj+mIYDR3u1afqxFOvu3T5WjKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1Ik30WhFq4FyhimXAjJBcgcQIzdhS+9N7sNBNNIYts=;
 b=G+9t7JX83znb0zJMggyQ9CxJg1xjVDmPksIyWPQtO6W9TQGvO2jq/tE/apI0bHXDHecfGFwlyRF6ozUwmzTVkUWrW735JGXFMZXAtMdpO2WQ1pi9gKTCC7IIbPvNqrnTM1xDIWm3vNSY4RtbViGRnhC+I5ombqZHwAJ0l8sgZE0C5lo7g69Uak2l8EjxdbEqQhe9JgMBaREII5RmCJjZHD6+cRzu3Hp0zJ88Y3a0BfxLZQWsObpfb3q6kgZJG2CEO/RbNus4HrbHLXg2w0IxbsOAKA8HIDLbbMata9F4iOYTHE38b3W6fwOgBuEv0/pjybNC/oNkR20ttNJUSyf0Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7133.namprd11.prod.outlook.com (2603:10b6:930:63::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.23; Wed, 26 Oct 2022 14:54:50 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd3d:b715:5212:2291]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd3d:b715:5212:2291%5]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 14:54:50 +0000
Date:   Wed, 26 Oct 2022 16:54:43 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        "Mateusz Palczewski" <mateusz.palczewski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next] ice: Add additional CSR registers
Message-ID: <Y1lKM8RyqnPUbEv4@boxer>
References: <20221026112839.3623579-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221026112839.3623579-1-jacob.e.keller@intel.com>
X-ClientProxiedBy: AS8PR04CA0034.eurprd04.prod.outlook.com
 (2603:10a6:20b:312::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f08b5f4-543c-4131-1429-08dab7620869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6oV2n8BWCf2MySe4HQxxSZ8ZEFfbtydMWiMxsoPsa1jEqqPgVjcT97wxEnA02HX9slblWv+ogl9r21X6kNVOeDP6kLgfiRTRxHdF+MYoS27BNfBGt9WcVxSVwauNLl/voegXMEJp8vyat4PfviN3jnef2Hkxm5J08mFHW/04XsUllgYe2yhM1XJJBCaLpvYR10SJDqdgLHFYNYDoI/SvMGqAppcXt79RFezcv09ZSYQX8WD7Le9+t3VCoCjyKtrz85dRbPS/AImHC/59vMjAQgJcH+chens3E53TzMqMiFPv9eRkoyiu1wdqx3Lo4VKkf/NNRuOcr5VY6582cbaglYocaESgH6U6rAkHfCpxOZqdEBajPnKyvhZhhrorUynNtBkURfcn1zKLeCBurEXGZIX+OyLUcHZdgnJQODqpXK5PMg7UgYkgXtGuj8MhKtzVCdpL2lo20F6p6alYNRgFC0fceW4Cbz0KV9Zop7YJ5byVVn9B4zCNqOtVQIwMgOFkj9jAHxGCLfYRB97rXziiiNIxThHUh+RN3jEo7fbY4en5of7rXzG0W+aJ1cW8BdP8WCBeJ7IdTLfk9ehuIAn36NZrrKXHC2ZTcBZw8C84Ad9glOmyzJbXRAUlEUnSIUsZqNJnpczOwugKHQCKrSCrBLB0spsoCwSBAg4iHJ87aJz4mpnl3E/goSLU+cR06WiaClmbx4/Bp8XNDyu7ZXB1Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(83380400001)(186003)(6666004)(4326008)(86362001)(38100700002)(2906002)(44832011)(82960400001)(8936002)(478600001)(54906003)(33716001)(41300700001)(5660300002)(107886003)(6506007)(6486002)(8676002)(26005)(66556008)(66476007)(9686003)(316002)(6862004)(6512007)(66946007)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cEBRul5vO6HDySUPGvlxAiM6449vX02DvlgKN8JxCMmD//92Dp2T4Mw45id/?=
 =?us-ascii?Q?Ef3SQgAh5xvbKmhysGn0pwx55EYVCDZ+Zu3ChpUYl+eh5LXMIi6HhIwLBNfx?=
 =?us-ascii?Q?eM4C0g1dwpGIwRN/pYDmsGoAyv2n3sHJTfU/HkNjohyAUuOfpeCcj3vTNvfN?=
 =?us-ascii?Q?FMj1HS3sO1Ze4C7RdqKwEKO+KyZcJrQuAM164uTIXTV8EitDtX4rx+iZXCS8?=
 =?us-ascii?Q?Yns1+3qMrle4J5eXj0D6WixAHaSAx0CsoeHJ/SjY45p2aShOfpXHPvaXwdLA?=
 =?us-ascii?Q?p2OKWPSU0uOrdhF+wUGSl8ODAw4mnT0OJuyvUi+DNUc6T7RlVVtqC0wPwhik?=
 =?us-ascii?Q?4j6CGUwSJ5oaVcCUKRZKX8J2gkN6+IV1EYv1sbVHzjLT/W+neHnFFicY2xXW?=
 =?us-ascii?Q?5hwI4jJQIqMhT+nb8tNYhISEwq1q3tIMkZcS7p87AYs3PPWx0Y2jPi9X27oC?=
 =?us-ascii?Q?NHyi2gd/E1Q5X4406lrn8akBKeu8Ld4pyjH3yTc4y2CYX6OzTUUL6FpH2Nvp?=
 =?us-ascii?Q?Z1TaeK1xpkDRo6ybl6n8jsk2hLoi65gp08i/F5WAGS5q1huyY+7Wgk/2hGOW?=
 =?us-ascii?Q?qxIInCanIUsuc3R12lStAKqZb0MkR/92nfdkD3IoRRKZvthmmN65Z/D8a0YU?=
 =?us-ascii?Q?81VDp2Q0roraLxY6QDgHaSzKOpmaTuDcGdDHbYWP/kY4vdY64LDFstMA8qsx?=
 =?us-ascii?Q?t2rKmJ3tp1qnKxURZvi2zAbvTjZc+4tjYu9PibS984djYvuDu/eTosSGSo6O?=
 =?us-ascii?Q?9ApONOjur+Tll0L1QIZGU2ieiBnC4zvUBcyiJcXEhY/IUyiwZ513D7DlY6Rz?=
 =?us-ascii?Q?fpFOcttZ2vzJwvyCO6NSSlByX4mJ1oQMoNZ0frjtxsW1iVBwAdWXccxIy8Cu?=
 =?us-ascii?Q?ds7idp1U60iIKHhPAHN5Eh444LGQuw2w3UhlCQXpflPjJdllRG/XMVCrO9sf?=
 =?us-ascii?Q?ta6lsL43DJQ7pfAKwqrjW91X9QgWfLawA3Fbwf5M8MWyJsZna/ilO7DBpmkM?=
 =?us-ascii?Q?qpj0lKHjSV1e6HUwYMzC5mXCEMAOB6OHinlebbfRqeUL45eD2G+omwt3UWyW?=
 =?us-ascii?Q?KggH9NMQM/GlSvNGLOLxMsHsN9/0NG1akT5cTMWjjeHnT4YTjjMCe8Fa7Gde?=
 =?us-ascii?Q?vptlu5dhlbRyVYGeK9xnF4L5Z6kx3FyemhyXP3zVBTRJAhfkM3guuCfLTPZ4?=
 =?us-ascii?Q?XnwrRCh7GLZ+RoAEo09vV2Wwe07scu0AR8cnx+loU7BXJz2lXB8a8d4JYJff?=
 =?us-ascii?Q?BaK0ufQZyllnuTbm94KY4yS6mRQ8NyBAo9ZhnT1wSKtDG550sivdkHFBJiXP?=
 =?us-ascii?Q?+2bev+11uESpPD3rP020Zi7+PFbAEvM2OPBLmLKrGtGu9RR2uLyb05Dr18I9?=
 =?us-ascii?Q?QaSW0tX8hv8pu5bB8qQSBuShgmiXE0HnYq2dzPi9r9z94IXWGGqjIsSeU/cP?=
 =?us-ascii?Q?pD63relI/O6kdCsDU3SLKN91DTA/1CNc2V1z/fwTXYX9i1C5pRcdVRXuiu2p?=
 =?us-ascii?Q?jhJZ1zDjIZ6AK/1b4ShJYQV2Blt/5Q4dLfHAsla6bsZGCNI7PLQcJb1+Dvw+?=
 =?us-ascii?Q?lVJaPD+plDY1iiMGnvk4akVs5omamWISnqjtQWIGzzu2IRoa+AM9xu1Fjyao?=
 =?us-ascii?Q?1ssGMi8I+PfLTEpIR6a8vmw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f08b5f4-543c-4131-1429-08dab7620869
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 14:54:50.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2L/1OfCrjOvW5jI30bI8As+aYTrSzdeTWClOVTnWbERQEtRkIqrxvzO1h/AUxzWkANuXxr3BL56Xb8N1h16XoJQVz3TDva4VWaB13JpOWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7133
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 04:28:39AM -0700, Jacob Keller wrote:
> From: Lukasz Czapnik <lukasz.czapnik@intel.com>
> 
> Add additional CSR registers that will provide more information
> in the dump that occurs after Tx hang.

So...where is the corresponding commit that would actually utilize some of
these additional regs? :p

> 
> Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 169 +++++++++++++++++++
>  1 file changed, 169 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index b7be84bbe72d..f71a7521c7bd 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -151,6 +151,175 @@ static const u32 ice_regs_dump_list[] = {
>  	QINT_RQCTL(0),
>  	PFINT_OICR_ENA,
>  	QRX_ITR(0),
> +#define GLDCB_TLPM_PCI_DM			0x000A0180
> +	GLDCB_TLPM_PCI_DM,
> +#define GLDCB_TLPM_TC2PFC			0x000A0194
> +	GLDCB_TLPM_TC2PFC,
> +#define TCDCB_TLPM_WAIT_DM(_i)			(0x000A0080 + ((_i) * 4))
> +	TCDCB_TLPM_WAIT_DM(0),
> +	TCDCB_TLPM_WAIT_DM(1),
> +	TCDCB_TLPM_WAIT_DM(2),
> +	TCDCB_TLPM_WAIT_DM(3),
> +	TCDCB_TLPM_WAIT_DM(4),
> +	TCDCB_TLPM_WAIT_DM(5),
> +	TCDCB_TLPM_WAIT_DM(6),
> +	TCDCB_TLPM_WAIT_DM(7),
> +	TCDCB_TLPM_WAIT_DM(8),
> +	TCDCB_TLPM_WAIT_DM(9),
> +	TCDCB_TLPM_WAIT_DM(10),
> +	TCDCB_TLPM_WAIT_DM(11),
> +	TCDCB_TLPM_WAIT_DM(12),
> +	TCDCB_TLPM_WAIT_DM(13),
> +	TCDCB_TLPM_WAIT_DM(14),
> +	TCDCB_TLPM_WAIT_DM(15),
> +	TCDCB_TLPM_WAIT_DM(16),
> +	TCDCB_TLPM_WAIT_DM(17),
> +	TCDCB_TLPM_WAIT_DM(18),
> +	TCDCB_TLPM_WAIT_DM(19),
> +	TCDCB_TLPM_WAIT_DM(20),
> +	TCDCB_TLPM_WAIT_DM(21),
> +	TCDCB_TLPM_WAIT_DM(22),
> +	TCDCB_TLPM_WAIT_DM(23),
> +	TCDCB_TLPM_WAIT_DM(24),
> +	TCDCB_TLPM_WAIT_DM(25),
> +	TCDCB_TLPM_WAIT_DM(26),
> +	TCDCB_TLPM_WAIT_DM(27),
> +	TCDCB_TLPM_WAIT_DM(28),
> +	TCDCB_TLPM_WAIT_DM(29),
> +	TCDCB_TLPM_WAIT_DM(30),
> +	TCDCB_TLPM_WAIT_DM(31),
> +#define GLPCI_WATMK_CLNT_PIPEMON		0x000BFD90
> +	GLPCI_WATMK_CLNT_PIPEMON,
> +#define GLPCI_CUR_CLNT_COMMON			0x000BFD84
> +	GLPCI_CUR_CLNT_COMMON,
> +#define GLPCI_CUR_CLNT_PIPEMON			0x000BFD88
> +	GLPCI_CUR_CLNT_PIPEMON,
> +#define GLPCI_PCIERR				0x0009DEB0
> +	GLPCI_PCIERR,
> +#define GLPSM_DEBUG_CTL_STATUS			0x000B0600
> +	GLPSM_DEBUG_CTL_STATUS,
> +#define GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0680
> +	GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT,
> +#define GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0684
> +	GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT,
> +#define GLPSM0_DEBUG_DT_OUT_OF_WINDOW		0x000B0688
> +	GLPSM0_DEBUG_DT_OUT_OF_WINDOW,
> +#define GLPSM0_DEBUG_INTF_HW_ERROR_DETECT	0x000B069C
> +	GLPSM0_DEBUG_INTF_HW_ERROR_DETECT,
> +#define GLPSM0_DEBUG_MISC_HW_ERROR_DETECT	0x000B06A0
> +	GLPSM0_DEBUG_MISC_HW_ERROR_DETECT,
> +#define GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0E80
> +	GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT,
> +#define GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0E84
> +	GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT,
> +#define GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT	0x000B0E88
> +	GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT,
> +#define GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT  0x000B0E8C
> +	GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT,
> +#define GLPSM1_DEBUG_MISC_HW_ERROR_DETECT       0x000B0E90
> +	GLPSM1_DEBUG_MISC_HW_ERROR_DETECT,
> +#define GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT       0x000B1680
> +	GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT,
> +#define GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT      0x000B1684
> +	GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT,
> +#define GLPSM2_DEBUG_MISC_HW_ERROR_DETECT       0x000B1688
> +	GLPSM2_DEBUG_MISC_HW_ERROR_DETECT,
> +#define GLTDPU_TCLAN_COMP_BOB(_i)               (0x00049ADC + ((_i) * 4))
> +	GLTDPU_TCLAN_COMP_BOB(1),
> +	GLTDPU_TCLAN_COMP_BOB(2),
> +	GLTDPU_TCLAN_COMP_BOB(3),
> +	GLTDPU_TCLAN_COMP_BOB(4),
> +	GLTDPU_TCLAN_COMP_BOB(5),
> +	GLTDPU_TCLAN_COMP_BOB(6),
> +	GLTDPU_TCLAN_COMP_BOB(7),
> +	GLTDPU_TCLAN_COMP_BOB(8),
> +#define GLTDPU_TCB_CMD_BOB(_i)                  (0x0004975C + ((_i) * 4))
> +	GLTDPU_TCB_CMD_BOB(1),
> +	GLTDPU_TCB_CMD_BOB(2),
> +	GLTDPU_TCB_CMD_BOB(3),
> +	GLTDPU_TCB_CMD_BOB(4),
> +	GLTDPU_TCB_CMD_BOB(5),
> +	GLTDPU_TCB_CMD_BOB(6),
> +	GLTDPU_TCB_CMD_BOB(7),
> +	GLTDPU_TCB_CMD_BOB(8),
> +#define GLTDPU_PSM_UPDATE_BOB(_i)               (0x00049B5C + ((_i) * 4))
> +	GLTDPU_PSM_UPDATE_BOB(1),
> +	GLTDPU_PSM_UPDATE_BOB(2),
> +	GLTDPU_PSM_UPDATE_BOB(3),
> +	GLTDPU_PSM_UPDATE_BOB(4),
> +	GLTDPU_PSM_UPDATE_BOB(5),
> +	GLTDPU_PSM_UPDATE_BOB(6),
> +	GLTDPU_PSM_UPDATE_BOB(7),
> +	GLTDPU_PSM_UPDATE_BOB(8),
> +#define GLTCB_CMD_IN_BOB(_i)                    (0x000AE288 + ((_i) * 4))
> +	GLTCB_CMD_IN_BOB(1),
> +	GLTCB_CMD_IN_BOB(2),
> +	GLTCB_CMD_IN_BOB(3),
> +	GLTCB_CMD_IN_BOB(4),
> +	GLTCB_CMD_IN_BOB(5),
> +	GLTCB_CMD_IN_BOB(6),
> +	GLTCB_CMD_IN_BOB(7),
> +	GLTCB_CMD_IN_BOB(8),
> +#define GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(_i)   (0x000FC148 + ((_i) * 4))
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(1),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(2),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(3),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(4),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(5),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(6),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(7),
> +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(8),
> +#define GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(_i) (0x000FC248 + ((_i) * 4))
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(1),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(2),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(3),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(4),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(5),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(6),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(7),
> +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(8),
> +#define GLLAN_TCLAN_CACHE_CTL_BOB_CTL(_i)       (0x000FC1C8 + ((_i) * 4))
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(1),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(2),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(3),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(4),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(5),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(6),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(7),
> +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(8),
> +#define GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(_i)  (0x000FC188 + ((_i) * 4))
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(1),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(2),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(3),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(4),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(5),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(6),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(7),
> +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(8),
> +#define GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(_i) (0x000FC288 + ((_i) * 4))
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(1),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(2),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(3),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(4),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(5),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(6),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(7),
> +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(8),
> +#define PRTDCB_TCUPM_REG_CM(_i)			(0x000BC360 + ((_i) * 4))
> +	PRTDCB_TCUPM_REG_CM(0),
> +	PRTDCB_TCUPM_REG_CM(1),
> +	PRTDCB_TCUPM_REG_CM(2),
> +	PRTDCB_TCUPM_REG_CM(3),
> +#define PRTDCB_TCUPM_REG_DM(_i)			(0x000BC3A0 + ((_i) * 4))
> +	PRTDCB_TCUPM_REG_DM(0),
> +	PRTDCB_TCUPM_REG_DM(1),
> +	PRTDCB_TCUPM_REG_DM(2),
> +	PRTDCB_TCUPM_REG_DM(3),
> +#define PRTDCB_TLPM_REG_DM(_i)			(0x000A0000 + ((_i) * 4))
> +	PRTDCB_TLPM_REG_DM(0),
> +	PRTDCB_TLPM_REG_DM(1),
> +	PRTDCB_TLPM_REG_DM(2),
> +	PRTDCB_TLPM_REG_DM(3),
>  };
>  
>  struct ice_priv_flag {
> 
> base-commit: d0217284cea7d470e4140e98b806cb3cdf8257d6
> -- 
> 2.38.0.83.gd420dda05763
> 
