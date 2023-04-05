Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E3B6D7C8C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbjDEM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEM1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:27:10 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9569A5592
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:26:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcZQcHvbf3zuZV/JLk4wPc6VK8XM6J9qEC7qkxpOt8gcDEMjJzgHZjYXSYWg3XOsa9IQ6DUt2XXoP3GfPRh4MyOVG0q5FgeSwoT97sfaI+2KOgCHxO6gqUS6XbAYtAKAX2evt2M+wAlZRI6rpUZ68IY7NoxqDy9iZl5/j/4WJ99V4gYGOjkkAuMO6Lo2bfBasDmpFRFd2PVT75CamNG9eLORE8oInh0Pam6E1rFyPBwDYW5hKPeSWK8pkdzRkZw4VYbZftJ6nvwTlCWb4EZMA8TXi/D7bgojk9ZuKRD/XqrNnNh5SQYMrCaJRAhhIK8i+AkTKfSEWZoRiO0DMqMuEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ci1AjlIr80pa9j8BDKfCOuI0kWHiDgdXBGyt2VPIMnw=;
 b=Ng7hS0Nsxk4UYW3ywMGslPujOgwUqTCPZC925ZN9AWwr3qR+lZAJDho3qXbZ/5+EGLoN1+NzZ1VqBSZr02k1XPXFPesV/mbXOU8lRNTZboX84Ul1xj5kzeS9tb0YJpFmNbBQ4Afgo5psX5/y0hkkn357Fi7SFuwBLGgvxHuAIGz1kzUKKTGHASo3eua9Bo2TatOumW+xy0la+z3o5FvaLB+TgV1IkaYe6eLyUNMvBmkJbbwn99vzyZTL1fWQRI316wXLUA8Y+niZ05baMh+wAvt9MvXcvMLOdWQ2FjmCpZC1qhC57lV7ybGm7RaTaTJAB4wRRvVgLwfiRTa56Tw88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ci1AjlIr80pa9j8BDKfCOuI0kWHiDgdXBGyt2VPIMnw=;
 b=sfieWC+NCMjkEWl+KILS1MaSOUTOC6b1HV8JM+WGwtIqRndwpLGbIBdBrJZbece/Lob47/gf8QAyKTW/th5qpD7ixswXfjN2zBdruzWtpiqiMM30B+MZiqDyjnhrJdPWbP6sDgOhEQ/DKT3n4VePoREQmWA0Jl6EfUyPVrfdwPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9375.eurprd04.prod.outlook.com (2603:10a6:102:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 12:26:31 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 12:26:31 +0000
Date:   Wed, 5 Apr 2023 15:26:28 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405122628.4nxnja3hts4axzt5@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230405063323.36270-1-glipus@gmail.com>
X-ClientProxiedBy: FR3P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9375:EE_
X-MS-Office365-Filtering-Correlation-Id: 562e056d-7c05-4cf5-9a8d-08db35d0fcdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMnCDcy/qon9rGWMiLxxWFWHd4XprOvgdKIXJg5S+w9AGCXoDz3aGsg4mrhNXafHoJ4MMLYTeAfVSav66uD976u5gmnYk8jbQDpUeCbwVArwTR7N1AwzlxtkJGHAzYN145egT2au5l8rrwDnx0uI6T+c46HKPp+1/6dDa1evAI1E3z0wYTBMJ/leAoshubSp933AUqBkZSNVZmsk5SlLeeuP+z2Lxfk3ydJS3cIgpSnBGNUZ5JR93q684Z3vR03wpT74+DzsVwkWTE06JFtalJO3pB4LZMuYXizqHMIuT0riB65PvNObs6VkQ9ul3OWlO/7WLpD/8K3Nnh16HHnw//b4r/QRY8N+7jov1r6GbLHer2ecMkbhhnNpBklSBUn0DtcXQyzAemLXDlm8G2qXer3kY782cTAGX9XMxpa9QT2XLyJ5J1OG4eqSUYvbH+/LaQLcdTjJiiHdNNDCAL078mP7BqBlw3AKm9Tk0Zj8k8XhRHdsM45PX5MQX2ZxLk+Hk8gX6P+bpgrLp/BVYjCy111klvzHFEGumvY7p0z4M75YBDgPHp7D4EyoIPb3oc9q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(86362001)(33716001)(478600001)(6666004)(41300700001)(8936002)(38100700002)(8676002)(316002)(66946007)(4326008)(66556008)(66476007)(6916009)(83380400001)(6512007)(6486002)(6506007)(26005)(9686003)(1076003)(186003)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXEyMVRiUFNKVkdIaU1HNnF4c3ZLVEx2KzBJOHNFVnVJVS9OYlRDWC9MYjkv?=
 =?utf-8?B?OWFrM085azBPR2JHcjU0S2gyZmxFQjFucWQveE1tQ1RsSzlFeG91UEkxRVN2?=
 =?utf-8?B?SlROMzByRXpoOVZnR0dOb3hVek1BSkdTREs2eklGelU5R08zNE9peTdDVUFm?=
 =?utf-8?B?dlE3RzNzYWtENFMvMU5sS3ZESUJMbEtrR3JndldLcWVXdlU3RWp4ZW1zdE1l?=
 =?utf-8?B?c0lNNk5UMlNRcmh5SWlwUlp2RzJrd2t3YTZrcDR6UzNoSGEwdVBBT2dMTXlh?=
 =?utf-8?B?ZjNIakt3RmxicEFoclQycUNUQ3lmblFaOXVGTVV5eHJkTUx2anAvNFNxSUpX?=
 =?utf-8?B?U25jQzd0M3F3Y3JIREpJNUt4N1lCcnBvdXp2ODRsZlJYdlprbEpUYkJQWTRi?=
 =?utf-8?B?ZU55THBCanBiS20xajl1NjVhNU9ueTFZdjJnbUZkM3IreWtEZ2QzM1J2d2p4?=
 =?utf-8?B?ekJlOTI4Z1QwSTEzNUl4WkdUeWxmYm1lVHgwSEZPMDRJOFQ1MDk1NmRibzB2?=
 =?utf-8?B?WFM2RGhzRW9Mb3p2bEpQRllOdmpSWUc1UnhoOXY3WGR5U1BxNzdJRUI4QkpD?=
 =?utf-8?B?UDkwb1AxMy9nV0VLU1hweHFDd0hoR1NGaG4xcG5yYVR3MXZiUFkrK3h4UnRB?=
 =?utf-8?B?VUg3OVVwdFllR0p3R1hyMUxabjNoRkE3aDdaU1NRTncyNktLc1FlMVBSVm9w?=
 =?utf-8?B?YTEwY1k1RDVpTnZXMHVHUEM0MmxCQktUZkxxQ1NzdmdHZlR3RzVsaldLZzFx?=
 =?utf-8?B?ODQyTXgwMnVUYmlWM1dMTDRiaU1zaGw5aHVVa1BLWVpxWlIwZnBqMjJONitO?=
 =?utf-8?B?M1ZBZHFadzgvWkFmMkpJWTlDK25iSFJFbGkxMjRoZEY0SzJxMHNIWWlNalhu?=
 =?utf-8?B?RUthUjB5eW54VGN4YTFlNEEwaTlmV3JLWHJJZU5jY3FNSmhtNDVlUnQzelZ2?=
 =?utf-8?B?REIzaHJGaGxTNUp6T1JybDNqcTJNcDYra1lpMnlaQmtwM1V4N2VtUFhST1VB?=
 =?utf-8?B?UW43VlBQUXB5ZkwyVnhCNWVTMWxNRlhiRzFvMFd5ME5aeVhEbElIQjdaQXYz?=
 =?utf-8?B?RHROTVBlTXYwcmVEQzQzS0tPay9PY0F4TGdkNlQvTWtiY28wUEk3U1ExMWRK?=
 =?utf-8?B?QU5QVUJUbHlwV1pYaXVrS3dnTlRaZzFSU2kycTE5V1VYZjcxYVN3aTJtSS95?=
 =?utf-8?B?dlFyVFhzT3VndGVlcTJZZ29hd2FtOWY3TDhhNzVHV2c1eUsvMEFtTlBlUTRL?=
 =?utf-8?B?bGRnU0xBR0xHRlpHMk8ySXFXR2VhR3VvRTVLVHJudjVpMUVhVmxoVytPcThD?=
 =?utf-8?B?eUhNT0d5cG13cXRWWmhoM3R0UWhnZXlUdnhuR2ZIckpLdkxMNTZVelN2MXEv?=
 =?utf-8?B?NDJPUEt3RXl4RUE0aEwyVzR5SkdOeXZqcENaYzJtN0NDM2w3azZjN2ljTWRZ?=
 =?utf-8?B?QTcwaFFxaDNiaWN0cmViZUUzNHdHZDEvKzlxaDQxNmN4cFhqT3NMQjNsR2ln?=
 =?utf-8?B?R2hsN3RSa0gyMDZUbEVwSnhjKzhLUG0wd0k3NWhKMmRNanFMZk1zRkhpQjZX?=
 =?utf-8?B?OVNVaGlHZFdnSjY2RUJqZmpjem5mWGp1dE9qdkZKZGUrQlhzOG1EWUZzc3Fw?=
 =?utf-8?B?U1hPRHhMVTVGSkhEZW16dmF3cDRNbHZHREZQV1RaZGV4QWJUd1Fuc25uNGFm?=
 =?utf-8?B?SittaG5PdmdvQlJXaFFaMy83b28xLzB3NDFMTmV0YStjVGlmcXJNbTJ5R0FF?=
 =?utf-8?B?RktqTVdUajNVLzRES1pESjN2aDdYeE9pa05ZQTlGRFc1ZDFyQlhSVlhFVmZF?=
 =?utf-8?B?d0QyNjhwVTdIVnJkbHpJeTh3Q0pYMmNjL1Bua29WM3J4amkzaEFDWjdhSlI4?=
 =?utf-8?B?ZzdQbzV6QWs2eWM3WGN4a3JxYnBQeUxlQ1RkR29BQ2E1NDBvSTF6UVFIMjdE?=
 =?utf-8?B?VXUwMEhVc05NUTNSa1ZaRmlJOHVLU0RXcTAxODhuM0NEaGFueVNmZjJLbEFY?=
 =?utf-8?B?V3IrcDZsVEh4aCtaemx2dTFoSE01Y2NLMkxmRTVCMTdkVDR6M280aEZwWjBC?=
 =?utf-8?B?Vm9sMVNwcmJ0M0w5Mlg1Yyt6cUJFY1pkUXRibzFlRHB3ckViS2U5SDFUNzRq?=
 =?utf-8?B?NW1rL0JncWNrelBhVHo2dHBYajlvdHBZQm9ubzFyeWRXWFdUSlk3cklLRHRQ?=
 =?utf-8?B?bWc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562e056d-7c05-4cf5-9a8d-08db35d0fcdc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:26:31.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8MkBUYNyqpG9XJ69d93BlyKS155ouDnHgEeCpZIdzro1v1xMMG4GUMrONbtpFHN3L/vkA6hiFsEogz2epLKVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9375
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 12:33:23AM -0600, Maxim Georgiev wrote:
> This patch makes VLAN subsystem to use the newly introduced
> ndo_hwtstamp_get/set API to pass hw timestamp requests to
> underlying NIC drivers in case if these drivers implement
> ndo_hwtstamp_get/set functions. Otherwise VLAN┬Ěsubsystem

Strange symbols (┬Ě).

> falls back to calling ndo_eth_ioctl.
> 
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---
>  net/8021q/vlan_dev.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index 5920544e93e8..66d54c610aa5 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -353,6 +353,44 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
>  	return 0;
>  }
>  
> +static int vlan_dev_hwtstamp(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct kernel_hwtstamp_config kernel_config = {};
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	if ((cmd == SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set) ||
> +	    (cmd == SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get)) {
> +		if (ops->ndo_eth_ioctl) {
> +			return ops->ndo_eth_ioctl(real_dev, &ifr, cmd);
> +		else
> +			return -EOPNOTSUPP;
> +	}
> +
> +	kernel_config.ifr = ifr;
> +	if (cmd == SIOCSHWTSTAMP) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			return -EFAULT;
> +
> +		hwtstamp_config_to_kernel(&kernel_config, &config);
> +		err = ops->ndo_hwtstamp_set(dev, &kernel_config, NULL);
> +	} else if (cmd == SIOCGHWTSTAMP) {
> +		err = ops->ndo_hwtstamp_get(dev, &kernel_config, NULL);
> +	}
> +
> +	if (err)
> +		return err;
> +
> +	hwtstamp_kernel_to_config(&config, &kernel_config);
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  {
>  	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
> @@ -368,10 +406,12 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  		if (!net_eq(dev_net(dev), dev_net(real_dev)))
>  			break;
>  		fallthrough;
> +	case SIOCGHWTSTAMP:
> +		err = vlan_dev_hwtstamp(real_dev, &ifrr, cmd);
> +		break;
>  	case SIOCGMIIPHY:
>  	case SIOCGMIIREG:
>  	case SIOCSMIIREG:
> -	case SIOCGHWTSTAMP:

I would recommend also making vlan_dev_hwtstamp() be called from the
VLAN driver's ndo_hwtstamp_set() rather than from ndo_eth_ioctl().

My understanding of Jakub's suggestion to (temporarily) stuff ifr
inside kernel_config was to do that from top-level net/core/dev_ioctl.c,
not from the VLAN driver.

>  		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
>  			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
>  		break;
> -- 
> 2.39.2
>
