Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63782F1461
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733122AbhAKNSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:18:32 -0500
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:6881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732741AbhAKNSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnFLvcs01Lm0zGWB+QKgt8FO2+egDMzqxVkPdleiZTtK/sEWF255AQyV6zWYg8rBvv7AM04bfBaEosr+OSYrqJpsy9s1ldYggyX81e9iJ2/trH+0f7ggeBQYaIny9ksYkiUQcJCH02KHGR3W5TR4Di9kvhjj30APQOTpopvHgddgeH/Y5QAJTEXm1r+5hrck70hcT2M71sage229wKv1xv7tf6GM3Ip4eoMMUbQ4wLTDU39ZqXT1ZNV3+xxPvf0VcwQ8uaAKcheFVrjbcXr1rZZCOdG0YawA9Z6IvG0ogzszQjb3cI0MYLQudH6nYWVmqtVr9b17cOUO4twhxVyXyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FiAg89HaHrYAtGB4GtD4ba0xj+K6EELFhl0ms6cIvE=;
 b=ItJn0ukdMJXU/s2XjxX71VumX0Q1+ztDUGABpLkldv9qBFt4rP/kS0jinrIDNOk1czCdd08HAh11k4TnosSjudKWdY0fXO4VUBEuOS9Oukqn2uofnuh6XOQlHfvjbNovYFSrGXw7sotcxyYFUKpFEYe0F4cLE9EC6jC3F2zbgqmcowCZy7G4aqTxE5BqooR6+wCmSW06BkvO0d3romHW5X+OLjm/klmZa2vhQOT7BxxK0/xa1ha3HlOupMjwKjpz2d8sYpJt68h8ATNBkDVfdwwo9LNFkoiiEwXCUOTnrWZWgUWWWhYIbx1IHuKkonR+QWbvrqhwJnaYkT1DZpfhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=alphalink.fr; dmarc=pass action=none header.from=alphalink.fr;
 dkim=pass header.d=alphalink.fr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ALPHALINKDEVELOPPEMENT.onmicrosoft.com;
 s=selector2-ALPHALINKDEVELOPPEMENT-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FiAg89HaHrYAtGB4GtD4ba0xj+K6EELFhl0ms6cIvE=;
 b=LjbKcraKf6oO4eqdLLL/V3JPYQ8ItB3Jdxi9FXW9CtzP89pz2MGXSfH22ZEEFTkM3TrFINEA69dtW1yLRrUg6UOMdza/IIEj+6Mh0Cklbdph0Cql5EIs9Q002tQCgKinZ12E1UCCTKotSjVmSu4ztA1hGgrsrxReNe5Kc70S0oI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=alphalink.fr;
Received: from DBBPR04MB7785.eurprd04.prod.outlook.com (2603:10a6:10:1e7::21)
 by DB6PR04MB2999.eurprd04.prod.outlook.com (2603:10a6:6:5::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 13:17:14 +0000
Received: from DBBPR04MB7785.eurprd04.prod.outlook.com
 ([fe80::d5ae:667a:81f6:37eb]) by DBBPR04MB7785.eurprd04.prod.outlook.com
 ([fe80::d5ae:667a:81f6:37eb%7]) with mapi id 15.20.3721.028; Mon, 11 Jan 2021
 13:17:14 +0000
Subject: Re: [PATCH v4 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
Cc:     gnault@redhat.com
References: <20201210155058.14518-1-tparkin@katalix.com>
 <20201210155058.14518-2-tparkin@katalix.com>
From:   Simon Chopin <s.chopin@alphalink.fr>
Message-ID: <ebc3b218-ab1c-30b1-144b-413b168631b1@alphalink.fr>
Date:   Mon, 11 Jan 2021 14:17:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20201210155058.14518-2-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Originating-IP: [82.120.54.119]
X-ClientProxiedBy: PR3P193CA0052.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::27) To DBBPR04MB7785.eurprd04.prod.outlook.com
 (2603:10a6:10:1e7::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Simons-MacBook-Pro.local (82.120.54.119) by PR3P193CA0052.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 13:17:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16c71766-a601-47f4-b941-08d8b633368c
X-MS-TrafficTypeDiagnostic: DB6PR04MB2999:
X-Microsoft-Antispam-PRVS: <DB6PR04MB2999278BD78B9F4569344417FAAB0@DB6PR04MB2999.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKUctanfvevg2GxEQtEm9FhaecNeGlG1Zd+Pjuc86J2MrUj+C7bjH/DK9D8R6a030lk3n6GJ/1Dgcj3X0aGD/3rrdDotI1+4cbZyCmIvP64niTDlPuT7oj354dVBGUioeJwNaTAbzh1+wdkjYrHcaKjXweGKOTgno4m0j67hkXF4JjnT5ndE4pCc3jpz7WOWm20kTMiONUPT/SINLqdUWUQwwZeoNhP2/zV9xt45mv6Kjt9ERlhhX4GRvILZt+6Y4BoddC6jOoGENaJSeUrw/Anh3/zmuT//pdurtwSbnXWZIyHQ+Y28sdL/fzMSKwX2TUf+lnKoC8qujUlpmsIr/aw5C6XZgE/zmjKdBtBJVIN8MFGdF1pmbzvv7dEPGR3WY5HhXGnowvUfXNfy5uOYN8YE/+dCshGUsy9RhHASeV4xv5fnKQOFgGxyackiHNMUOEplNpGfvUf4eAOC4WS+H8JR1agmQZ6oqhmWVOhGioM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(31686004)(8676002)(5660300002)(83380400001)(6512007)(16526019)(6506007)(26005)(66574015)(478600001)(956004)(2616005)(4326008)(2906002)(8936002)(36756003)(316002)(6486002)(66556008)(31696002)(186003)(66946007)(86362001)(66476007)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFpENzNGNmdEWmRBZXVTTGNWc3lrREl2Wm5FWkFKTzJOTGxjMU9ZTWExc05p?=
 =?utf-8?B?SlRtT0hFWGpIUFJDSmd5MjRXRXpla21XWTQwY1ZGQzBuODUrTUR5bmdDZDF4?=
 =?utf-8?B?WUdrM29CdnBvTnU1TUNMSGdwSXROVTdINzZJUlI5MWNXbndKWkFDUTFjc2U2?=
 =?utf-8?B?WjRSZnlIczZHMENua3ZITWFwNnJMekxCL2thTllKZXptcHQ3ZjdwZUttc2d3?=
 =?utf-8?B?M3YyODNWMEV5QnBETnFwSUFlZ2RteVFtOHNhcGFNZHQ3MGFQYmo1ajJtd2hh?=
 =?utf-8?B?RjA3Q2UxZWdWQks3dkFGa1MrSS9IR2xLTm1jTWVEWTljSTF4UUFEcUdtUVlz?=
 =?utf-8?B?ZFN5ajFMYjVNbnhnYXM4azJkbWZrUFVRMzlKRHVacjBKREx2QW9tdmtLNXpT?=
 =?utf-8?B?UXlTYk1mYnpGNDZua2p4THdTMXRrcHltQndubHRlQ1pjM0QyRm9vQ0pGU2ZV?=
 =?utf-8?B?RW5SaXlNT0ZuL3RPbi9Hd2hqTDdjdW45eDRNcWYydGtaUjNad04xU3NUVHd5?=
 =?utf-8?B?T0tSR1FUdDdvaVRseFhSL1YxeDkrU3VIWHRlSW02NXNxbkMyeE9pekU1VllS?=
 =?utf-8?B?MGRhSWZhdjBCYVc3SWxRL1BkcW15bVg4YUwrMnN6WGhSZklUTVUrYnRHdytH?=
 =?utf-8?B?SXZiTmY2OXZvSDE3S3BMM0UzUlJCem9aekptUVpXWFJpd2JJUnlyL0Z5Z1Zh?=
 =?utf-8?B?SDB6b0JldnJTK1NuS1VXZytCZnBqMzZ5a3VOVGtPWWdtdEFoYzBjMEphZUlv?=
 =?utf-8?B?aUErbUYrS2NqV08zVldHNENGYlBPK3pXWTdxM0orVDBXQUU5SllDVW9GcDRj?=
 =?utf-8?B?VnhSako1QXhVaUpoU3l6SjdhV1FrY0FBQ2IzVlhVWUFVdXo2S3RsaTY3YzQw?=
 =?utf-8?B?Nmp3KzVaNHcxZVBhUDRPVXFWaHVjZFZYWFhVWlp0bTlSR0FmZnRtSjZIZzFx?=
 =?utf-8?B?blNpR0hPNkdWQ3c5dUZaeDNkU1B5cFVDODZRODU4em8vcURzblFTMmREbWp2?=
 =?utf-8?B?RklhdC8ybE5iZ0xFMnVNaHdqNFlUdlZJQTRrWmwzNTJ3SEhCYjN5eTRuZkJa?=
 =?utf-8?B?OXM4VzJWc2xHb2NGU3BwUjNGU0MyR0RpTVVHZU5adXlCdlRDOGNFajZ0SHhl?=
 =?utf-8?B?N2pzV3d4MXJZa25zMklrKzJxbzFsTEtCNmtxV3JqT1RuM3NaLzE3ZGNMU1dx?=
 =?utf-8?B?a1g5MkdFcks4SzBWazdKem15a21BcHlBeG9Xa09pZ3VDRmswMHZtZnloK3VH?=
 =?utf-8?B?RnhhNUhqcG5ja2tTWmRCeWg1Mm1NSkFoRU9hZDVvbTUyaDBNQnlyRzBrUUhN?=
 =?utf-8?Q?4eh9I1Z+M4jH2XZOsVcFDVmfuaPqyO1HLF?=
X-OriginatorOrg: alphalink.fr
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 13:17:14.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 32fd31f1-2987-4877-88ec-5af0c8aaa426
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c71766-a601-47f4-b941-08d8b633368c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Nfrcs+KIcTI4wLuGHo89ktTV0ztLJQyTfuOkzjERYsy+uY+fnpZYiA+kEDWxz7jRTfcgcBN7PfvZtRSwTGLhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2999
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Le 10/12/2020 à 16:50, Tom Parkin a écrit :
> This new ioctl pair allows two ppp channels to be bridged together:
> frames arriving in one channel are transmitted in the other channel
> and vice versa.
> 
> The practical use for this is primarily to support the L2TP Access
> Concentrator use-case.  The end-user session is presented as a ppp
> channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
> over a serial link) and is switched into a PPPoL2TP session for
> transmission to the LNS.  At the LNS the PPP session is terminated in
> the ISP's network.
> 
> When a PPP channel is bridged to another it takes a reference on the
> other's struct ppp_file.  This reference is dropped when the channels
> are unbridged, which can occur either explicitly on userspace calling
> the PPPIOCUNBRIDGECHAN ioctl, or implicitly when either channel in the
> bridge is unregistered.
> 
> In order to implement the channel bridge, struct channel is extended
> with a new field, 'bridge', which points to the other struct channel
> making up the bridge.
> 
> This pointer is RCU protected to avoid adding another lock to the data
> path.
> 
> To guard against concurrent writes to the pointer, the existing struct
> channel lock 'upl' coverage is extended rather than adding a new lock.
> 
> The 'upl' lock is used to protect the existing unit pointer.  Since the
> bridge effectively replaces the unit (they're mutually exclusive for a
> channel) it makes coding easier to use the same lock to cover them
> both.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>
> ---
>  drivers/net/ppp/ppp_generic.c  | 152 ++++++++++++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h |   2 +
>  2 files changed, 151 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 7d005896a0f9..09c27f7773f9 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -174,7 +174,8 @@ struct channel {
>  	struct ppp	*ppp;		/* ppp unit we're connected to */
>  	struct net	*chan_net;	/* the net channel belongs to */
>  	struct list_head clist;		/* link in list of channels per unit */
> -	rwlock_t	upl;		/* protects `ppp' */
> +	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
> +	struct channel __rcu *bridge;	/* "bridged" ppp channel */
>  #ifdef CONFIG_PPP_MULTILINK
>  	u8		avail;		/* flag used in multilink stuff */
>  	u8		had_frag;	/* >= 1 fragments have been sent */
> @@ -606,6 +607,83 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
>  #endif
>  #endif
>  
> +/* Bridge one PPP channel to another.
> + * When two channels are bridged, ppp_input on one channel is redirected to
> + * the other's ops->start_xmit handler.
> + * In order to safely bridge channels we must reject channels which are already
> + * part of a bridge instance, or which form part of an existing unit.
> + * Once successfully bridged, each channel holds a reference on the other
> + * to prevent it being freed while the bridge is extant.
> + */
> +static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
> +{
> +	write_lock_bh(&pch->upl);
> +	if (pch->ppp ||
> +	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
> +		write_unlock_bh(&pch->upl);
> +		return -EALREADY;
> +	}
> +	rcu_assign_pointer(pch->bridge, pchb);
> +	write_unlock_bh(&pch->upl);
> +
This is mostly for my own education:

I might be misunderstanding something, but is there anything
that would prevent a packet from being forwarded from pch to pchb at this
precise moment? If not, then it might be theoretically possible to have
any answer to said packet (say, a LCP ACK) to be received before the 
pchb->bridge is set?


> +	write_lock_bh(&pchb->upl);
> +	if (pchb->ppp ||
> +	    rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl))) {
> +		write_unlock_bh(&pchb->upl);
> +		goto err_unset;
> +	}
> +	rcu_assign_pointer(pchb->bridge, pch);
> +	write_unlock_bh(&pchb->upl);
> +
> +	refcount_inc(&pch->file.refcnt);
> +	refcount_inc(&pchb->file.refcnt);
> +
> +	return 0;
> +
> +err_unset:
> +	write_lock_bh(&pch->upl);
> +	RCU_INIT_POINTER(pch->bridge, NULL);
> +	write_unlock_bh(&pch->upl);
> +	synchronize_rcu();
> +	return -EALREADY;
> +}
