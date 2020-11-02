Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5E2A35CD
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKBVK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:10:28 -0500
Received: from mail-eopbgr40084.outbound.protection.outlook.com ([40.107.4.84]:34794
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbgKBVK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 16:10:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUmUrLdMHWJ+XsEQedhyz9FZwykdrQpYyRn0HY7EB1MDp/cf8WkAVOiJ7M/J9qVXLtC0cC3/L2emDPC7q+/V8E1oQncR6gBqzkyOAp33lv8uXEbOezkfUxJ1x/V4zpSly72rktxNOSpo6vkHADQ6ycGKqK91IEda2Mkm2MmLc8Fh0H0AnMStQ+7MJ0fkg2nDqKBRkk2eRMveXCZ83YVsw/5ltX2HhMdARPRHarQTuxKW2+By04LBMdFvfvPv67IrrHGXVdDLcmgIoKH8Uh5hLcx00EOGkIrZLikmYi5LATGcAGG0M79n/l1NuuWUpbnzMm80TeKaT+7VhccLQ75kpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovBsjrh7YRVXAmXkPV7MA7HDbomwBCymIH1Q4A9vc/Q=;
 b=hFhnBh94tNie9yjXuoMVHl7Nys2zswJ/eTlt7BUw6O6REkhwS89DPNgAJjGPlsZ82DPgXleZk0dayHm266BW2QfphcTbkfIB3YQlfDLMvsOs2MD7/fI3oanTvkSArf6xjv0EV663fk5KiC6KWm3l2Nf8XXh2iTcEukFGPGX6IauO0tk6zUvx+MCRJ89qjOXZ4tNuvbQ1f2Pl0daj1Ufj0Ly+oaqiFPyp11lEwLds9QhW31I4y0r+tmxS6kIVAw1sn9XTlSTPPd0ghek83ZMFjYZGkO2+CPiEeRMdM2dxXzB8NxoqIUzQc6NWVGctgjMjK7Q6AyB6K+qEQRCrNfZyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovBsjrh7YRVXAmXkPV7MA7HDbomwBCymIH1Q4A9vc/Q=;
 b=eou7idGmtr5VGJZSAJItK+HDadpK77cidRLfWJiRNCPfixwi/beR/l4xgO2DhPOkVxHT/wBTMDROrqLqrDNQIQa+g+IOICv0afd8zVanwvNa/e2kXn4bLk8Mf7s5GHlNNwuEi9ruUiFitBnZ+EncUL+VF54CC5kGC9QvfPEYNGs=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0401MB2317.eurprd04.prod.outlook.com (2603:10a6:800:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 21:10:22 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::dcb4:903:81f8:a8e2]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::dcb4:903:81f8:a8e2%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 21:10:22 +0000
Subject: Re: [PATCH v2 net-next 1/3] soc/fsl/qbman: Add an argument to signal
 if NAPI processing is required.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Priyanka Jain <priyanka.jain@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
 <20201101232257.3028508-2-bigeasy@linutronix.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <8e25b5d2-0c59-e756-8c04-479d1ad5a775@nxp.com>
Date:   Mon, 2 Nov 2020 23:10:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <20201101232257.3028508-2-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR03CA0101.eurprd03.prod.outlook.com (2603:10a6:208:69::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 21:10:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 027faef6-949c-4642-ed47-08d87f73b5ae
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23170B061B0C48A0513E583198100@VI1PR0401MB2317.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWtRhiRxyY/kjVj5xTBXJ9gvFCBttfedEBNiv+bvyRi523MF6PL2Nd3FBBN1F9Sptc+vfsFOrkASGRspZYhqJs7s3WgSoOqhTpZq67/fyxq9EMt/UEmQaNU4CVJwKyCS8M6wlA4MhA31e1P/T0ZFzT43cBnw+hKG4MadVkpVjt9zbUj6IKFLY7JCyIvekcESS+gD2vdGr6xqbtCj/Jb00aZ33N6cUNeBLruxV7jYeFSxbqU1jexxExi6tuRwZmYNsIJYRg4/3S1xRCAP0sdbhAv81oY7LA+zvInMAF4rSYp9DmAwEKUe1J5eS+FTSto5w1aTO5lg32BLKdHnUgAkcu6ePK+QTfnFCcMMWZ1KhtTky46f2A87qFgnwEsbIfMk6z2C+MWQJ650Gbvl5Ak6ljPBZ6WwlIlMlgFrNrWR/xR/1K8Ec7FhHGxkj+P0e65BF4LOwKX9NoIFMZ19paDz9CuepckYTDxHNTJq0r97qq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39850400004)(376002)(346002)(316002)(110136005)(54906003)(16576012)(31686004)(966005)(956004)(2616005)(86362001)(478600001)(4326008)(66556008)(66476007)(186003)(16526019)(6636002)(66946007)(52116002)(26005)(8676002)(31696002)(2906002)(53546011)(36756003)(6486002)(8936002)(83380400001)(5660300002)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9yGIIKjUE+lgX9oWhO1CCFaFB5leE1dnprbklkZN8ZWBM5bcqgpOa5MKErkjUVbn6JHy7T2Yjzy+Vk99Iz4PG42nzMaBzd8BVHPjxuzQrpg25Vbg+fN8Sn4KGvusDicjKKN7VXEAcBDS/1JW0wcEu2U42ua48mpyF06sYHCd7MRz8Gq0xZ/FI/rpQan1ABqKJN4TdP3E5jD3mFNUwM7eyAcOAAe+mLU6oGQgbsNdvq9E/Oh3tMwLqBN5Yfp93WJwt9y3cjn96tgxZLOhQh4swUX2gJJlVY9uZTPlK9thtdXvLPu3LAErVf2q24sIrw7ZOSQQrJhg6w79PV68pM8iR/dDT7xuUXNZJqFZyiILOmz8uN4rfPnWRXU+nyUilWDRd3kdUquJdJf+QNCVraiCmxtrTv5I1Dh4h+vIZ31k1VaoSD+e/DyojlUepNpRKqiIsnKGjlpqI6Rjs39TcN6J3Di0w5miRl9FzDddTlkFqnUMpn6bwEE4THQMHReGC/665SriqrLvoJzOESN2sxEP2BwHhZ9z9cyiRxpfZ00sxEhAahWx69ezEXB4kGDgEONfVN59L8Dp0zZ9ikvoCC997fnvgfqjB/wiv0VXNZFUN501zm9D/EGfmZ4HTJoHNggW7JInmrdhAaihYHQk89N2jg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 027faef6-949c-4642-ed47-08d87f73b5ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 21:10:22.1650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fb8tGOn+6EkkdSCvA3ZmKUaQmEGQvCNG6j5MvIsUPMF+qIzyes6FMYWYqk7mRuUa9vNljsNZa07SDg1pH9ATuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2317
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/2020 1:23 AM, Sebastian Andrzej Siewior wrote:
> dpaa_eth_napi_schedule() and caam_qi_napi_schedule() schedule NAPI if
> invoked from:
> 
>  - Hard interrupt context
>  - Any context which is not serving soft interrupts
> 
> Any context which is not serving soft interrupts includes hard interrupts
> so the in_irq() check is redundant. caam_qi_napi_schedule() has a comment
> about this:
> 
>         /*
>          * In case of threaded ISR, for RT kernels in_irq() does not return
>          * appropriate value, so use in_serving_softirq to distinguish between
>          * softirq and irq contexts.
>          */
>          if (in_irq() || !in_serving_softirq())
> 
> This has nothing to do with RT. Even on a non RT kernel force threaded
> interrupts run obviously in thread context and therefore in_irq() returns
> false when invoked from the handler.
> 
> The extension of the in_irq() check with !in_serving_softirq() was there
> when the drivers were added, but in the out of tree FSL BSP the original
> condition was in_irq() which got extended due to failures on RT.
> 
Looks like the initial FSL BSP commit adding this check is:
edca0b7a448a ("dpaa_eth: Fix Rx-stall issue in threaded ISR")
https://source.codeaurora.org/external/qoriq/qoriq-yocto-sdk/linux/commit/?h=fsl-sdk-v1.2&id=edca0b7a448ac18ef0a9b1238209b7595d511e19

This was done for dpaa_eth and the same logic was reused in caam.
In the process of upstreaming the development history got lost and
the comment in dpaa_eth was removed.

This was back in 2012 on a v3.0.34 kernel.
Not sure if/how things changed in the meantime, i.e. whether in_irq()
behaviour when called from softirq changed on -rt kernels (assuming this was
the problem Priyanka tried solving).

> The usage of in_xxx() in drivers is phased out and Linus clearly requested
> that code which changes behaviour depending on context should either be
> separated or the context be conveyed in an argument passed by the caller,
> which usually knows the context. Right he is, the above construct is
> clearly showing why.
> 
> The following callchains have been analyzed to end up in
> dpaa_eth_napi_schedule():
> 
> qman_p_poll_dqrr()
>   __poll_portal_fast()
>     fq->cb.dqrr()
>        dpaa_eth_napi_schedule()
> 
> portal_isr()
>   __poll_portal_fast()
>     fq->cb.dqrr()
>        dpaa_eth_napi_schedule()
> 
> Both need to schedule NAPI.
Only the call from interrupt context.

> The crypto part has another code path leading up to this:
>   kill_fq()
>      empty_retired_fq()
>        qman_p_poll_dqrr()
>          __poll_portal_fast()
>             fq->cb.dqrr()
>                dpaa_eth_napi_schedule()
> 
> kill_fq() is called from task context and ends up scheduling NAPI, but
> that's pointless and an unintended side effect of the !in_serving_softirq()
> check.
> 
Correct.

> The code path:
>   caam_qi_poll() -> qman_p_poll_dqrr()
> 
> is invoked from NAPI and I *assume* from crypto's NAPI device and not
> from qbman's NAPI device. I *guess* it is okay to skip scheduling NAPI
> (because this is what happens now) but could be changed if it is wrong
> due to `budget' handling.
> 
Looks good to me.

> Add an argument to __poll_portal_fast() which is true if NAPI needs to be
> scheduled. This requires propagating the value to the caller including
> `qman_cb_dqrr' typedef which is used by the dpaa and the crypto driver.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert XS <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Li Yang <leoyang.li@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
