Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8C638C50
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiKYOgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKYOgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:36:21 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E891631DDA;
        Fri, 25 Nov 2022 06:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669386980; x=1700922980;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8+7LDNTlMPiSJLn9bp+sf8rXmBhihM7fZn3VgkE4cOw=;
  b=XbNutMmKGy5i/RpVvV29mWvW+m74lwlm8GXfcYiPpZFG6RhhC0bl/Tg3
   YsProLMP5dCIpK6LFeVgk7o3peOJvxjzwWDfl2UJNezQU+9Tm2i79LUev
   Y4JDDTXi75F1LxlVg7MLG58sjktbguD84SOfsg+OlNVdvIT1PGfLyIeNd
   627R7qQNezSRG/4+HT182dBvetG1fcXwt6UPeWDSyzQoxZJuoHZiHBBNy
   391wwh1DZMAvkiu5sVhPdgSjdBMs0qbO4yejGGpwSV2z4GoNgTgFMYSZ/
   i7gmWW/grK2lVerahzBICgh0hRu2hBWllrDmDLKDkqCGCuxVawYxlEatW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294195007"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294195007"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:36:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="673559241"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="673559241"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 25 Nov 2022 06:36:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:36:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 06:36:19 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 06:36:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUCBeMpQvOWNstVBfLWtU3Bt0AgpBpkoGKMEttCIAxw6Hd4hebwLaQUNTJiqeoN0HLD7xC9GYT67yoANW892U8hYJzeqBbk8WKuAHasqJDnzN55ZiANSXtez0qil9OrnssZG851uIuGl5cjWMQuAZd03zvgr3Owux53TsuHMkJ7KZB8DZDVCfHVRDSbTJyLfV0U8dyBSNdMqtV5rcG3h24tdMfeTwZ/vs+hG2U87N7i8+GkGSnigkgpf+B0xch7b7x9NdBn6Ty9WuzampU9zZ9MBAmbrb7Nom06q6AiEn9IoJot8QwGx4DFNS3RkPYKXeWLeC7Y4fwiVR01DKuWkGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyLvZhGa2XWtWISvqu4R3CrX9lzHzpC+/YyCfCnj2EI=;
 b=RgJlZ1Xfe6TBFFyXcPQuBEG0y+yvLPJksK+RyqzeidB9otX2W0D+ZrBdqEGpTZUclPAvQslh4+en5c13J4mmCO2DolY7YjzZbINsqN5XB6Iu2FvlQZIO7oaKSlwiH0oYcGkud+YobQ/254zR50CZ8Kh//QS0zJ6EcAoJqIvaUGYdPF1HUCbdo4aneF7sVVNL3RhwAw2d49DXASb7urtHGS4EPzfTNikqxFJD5qLPj6cJrgoEmbgXFNylQdXJnTK/Tq49c8FPPu78DVBzGw0tdDep6Z+LD9ONU4F1VOo4scPkwq8/c9hukFb1IskcgXd74xRMz1gIUGjcCLAHsV4Eeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB4955.namprd11.prod.outlook.com (2603:10b6:806:fa::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 14:36:17 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 14:36:17 +0000
Date:   Fri, 25 Nov 2022 15:36:00 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: fix error handling in
 am65_cpsw_nuss_probe()
Message-ID: <Y4DS0PYdpVeLFrWv@boxer>
References: <1669258989-18277-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1669258989-18277-1-git-send-email-zhangchangzhong@huawei.com>
X-ClientProxiedBy: FR0P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB4955:EE_
X-MS-Office365-Filtering-Correlation-Id: 0642dbc5-bb76-4085-4fbc-08dacef26985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRZU+LIvJaMmAHlY/ye5mjDsB7ilQQVV0IXtdsHgRw163AnWb7oK7yeGIwH+hJ5/6M7GRJ9iT7nEPUAcnIl1dG8rBo6GY0KZckKNwgfmuk4MBUGWS8sGBtVv51cjXg3ciOqF5jytFR8XlzvIEZ/Su9YYgT59XL25gO6O6ZY3JK7WnQ3wDDjI67h7e8h6IjctjiN+4pfNPch0NmQTddLpaF4Nd1FTj1OMePwqX958E95DjCN82/Q79Grr2STQmC6efXn066M4baoqaMTja8VfN+jksjFVmjT32bDHdUjNPKplLOTuuX4sZR1nliA1QG4/5mT6NEmBBJHg2Flod2QdmRR3Rr6/EIFGjXyePe+fUJmEJmXuqtedUhe4sRMiMu0U9Jwpf6lCm2kLEa4IwwnEnfK7mWQ7vso6lIs7l2N+x0TIZ1lniX7JKTfsXkNWDT1+B4iphaKM1SXC3Dm1LDqnWih/VGXjqK2zUssB2yVVuTlOV2jQtMSoFHlr9G9l3BzX0grkWsKKNaqgZN47iYbTg7X9Ni3Mc+BgLGVP3mJssl/ncVfNnvhgXZPPBS4uTI9yOSyM7PQ65qy9hnOKKKeskr0xkdFulaRLY1bq+1vgeU61jbTBPV2SFvod0WplUNILsaqkZT4EJgLkQxG9ut5e9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(478600001)(6486002)(33716001)(6666004)(6506007)(26005)(6512007)(9686003)(83380400001)(54906003)(5660300002)(316002)(6916009)(2906002)(66556008)(66946007)(66476007)(86362001)(8676002)(186003)(4326008)(44832011)(41300700001)(8936002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dbpgOyM/fAwSkh0bZ2deg0fQDDicD5gqBhcXs7Ka2W8g4OB9GSwyIT0C4XCi?=
 =?us-ascii?Q?/Q6sN7A6gFhqvIPufmqdHifZSTfsgZ7Ob3XAUnqM2ThmwKJFnBM3iWtrp1Z5?=
 =?us-ascii?Q?TVTU09u1Vd5Jrl0TnW+VS1Z+sa7bRyaBIifzRktpkvokZxeSLjb3RskXTSNd?=
 =?us-ascii?Q?vvtuouN2Oqohnux8FpOE6UhuYFVnkha6Bd70y1lbEkKljrldM6s/XjnmdjSf?=
 =?us-ascii?Q?wO997hn0bj6UdMV3vDvYlZQ+uuPhJ6JCF3XvefRxrRxMdZB7BYeTTnd/q9y9?=
 =?us-ascii?Q?YPCSbRw3ejEa6dfXoVu/7XnCSwqsQTt9Y4XVL91FDY9RUOfp/rLhGGWsNQI5?=
 =?us-ascii?Q?bA6wsciVTNr2z85S6GCIClx2bkkXRDZ2F50STgD5MkkXP3FquAPBtNGedpMp?=
 =?us-ascii?Q?jzKPii6TPjnox7pHfaF/JIp/a3gusJnzRop/8LwKAWNHPcKv3h4e/YLxFiC7?=
 =?us-ascii?Q?roTLiF5apWoYt057nw/Y7HwsO2bDJY5UXSkWIqC3rL9oN2eZ+rnA/xYDCQWM?=
 =?us-ascii?Q?Z5vql1k8Wp1qwjISPqDHmWxLzSZPgO2e+Yg/kMUHQGEFTxbAhsVOtuCtR0UR?=
 =?us-ascii?Q?UsUbizrhOls1GnOPake232UDhlNLbRhd+jA6VKgLgBBlLFt0CwcW0/1G/RgG?=
 =?us-ascii?Q?59Of0GfudcHF7gAFv1Agh7yrFD1exzg304sDuc3KvyHRRe0V5Tg1y7A1cu1b?=
 =?us-ascii?Q?cs6T6EYokuRCiuQ8lsubSIT8BY8nZ7zo6RZKra+6Cd+9dJET/e4L+kxZ/02t?=
 =?us-ascii?Q?SaM4FWCW8YR3NhcLwJeJRNgqzFoQ5OsdWPXZ3/MdO4oSjE5jmmLeNhMYRE9y?=
 =?us-ascii?Q?F2ZRXSl50PSnYRZumtuVjKzDsHBwmjsndPT50ddDclgP5kOxnheSj7R/B6ol?=
 =?us-ascii?Q?rBjzcWZHOQ29yhlEAPjy+cPbNsId5X7cRP/PsIfmokEtCW6KxrNXvScE6iUE?=
 =?us-ascii?Q?vZ4OALPqVOpOuLQS+nj/9crm5IpvLJFUA1+oO6RdKRzPPLdhQVBecVEPmxf0?=
 =?us-ascii?Q?yubRc89eZp6T8kLpFRVPFfUPiVXM1A0eY+7vLMIZvF4L9xzOy92YznQ4I+Dy?=
 =?us-ascii?Q?LzLWyxZXHebAUz0allisiZHE4w4glkZntTn7lhmck6sWsPI27plI5IPXGsEG?=
 =?us-ascii?Q?0x5dZGatgad6Yh0BurVwU+a22hPQtSJwRAf7xYYVuH9Evdb26ZMhIUupRlAU?=
 =?us-ascii?Q?1K/m3+IENK44i786Y2HJ+mafRVNHe02kjaIvdivmGobfW4MC8+q0k0fqYnqN?=
 =?us-ascii?Q?QGs1yaSw6F5MEwndKFeCPam0VGvntS4nWcIjqQ7HCiIDX7fIK4IZl67ko9vv?=
 =?us-ascii?Q?qiFiky+UwXyj7EvduHF9E5FP12QtwL5bhEpH8qcZvAe3JtmZ1RVu2GULhGlf?=
 =?us-ascii?Q?d0SqAFfgAV0KXGa3nyNH1RSVuhJcqcYjZAOhAKR5lqmx8tFx/XOZQ3k2Q8K/?=
 =?us-ascii?Q?+6sbbkCS4EEcij+az62Wgwhk5fCoQBCHmoHmX9nOIX7Xvu6DruC02tKmdiRB?=
 =?us-ascii?Q?3gjOq4OTTsiAjs5EZuMVXlw5b95VdXaVaTE4vmOCeCl7JNJLwF7Sc8k9ag9u?=
 =?us-ascii?Q?tQ8WCQaTKGl2z5J8xXLQujmRslsrCQiOkIQnfPw6Y4r26Pnr7TBIL5NJYUvG?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0642dbc5-bb76-4085-4fbc-08dacef26985
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:36:17.5191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+ls1AAaOxx87DYVgu7Wz44BfYWTxKXrjrxGZdkYsirCwIVISdcr030P/b9pXpA4RlU+QKCqS45AKMyQ0bGg737Ed6tlxuFFoXiKbhnYxI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4955
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 11:03:08AM +0800, Zhang Changzhong wrote:
> The am65_cpsw_nuss_cleanup_ndev() function calls unregister_netdev()
> even if register_netdev() fails, which triggers WARN_ON(1) in

If this has been only compile tested then I assume you haven't encounter
this WARN_ON(1) trigger by yourself?

> unregister_netdevice_many(). To fix it, make sure that
> unregister_netdev() is called only on registered netdev.
> 
> Compile tested only.
> 
> Fixes: 84b4aa493249 ("net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index c50b137..d04a239 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2082,7 +2082,7 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
>  
>  	for (i = 0; i < common->port_num; i++) {
>  		port = &common->ports[i];
> -		if (port->ndev)
> +		if (port->ndev && port->ndev->reg_state == NETREG_REGISTERED)
>  			unregister_netdev(port->ndev);

It seems that if am65_cpsw_nuss_register_ndevs() fails on
register_netdev() port->ndev is still a valid pointer, so your assumption
looks correct to me.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

>  	}
>  }
> -- 
> 2.9.5
> 
