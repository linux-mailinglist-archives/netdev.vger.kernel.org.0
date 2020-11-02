Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A552A35D6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKBVN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:13:57 -0500
Received: from mail-eopbgr40084.outbound.protection.outlook.com ([40.107.4.84]:6659
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726447AbgKBVN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 16:13:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyWxA/6X8rKINNcv9L6+m3i7bP8wPQ6p+cXBYFMBFlIEznTyq3DkiB0b75nszdXORfcE4FzDSXOFtFtV7LKI8AQVFqhycfO1tai8ZCArYp9bL3A0w7e+RXJLzRtu/Box+vzgfyIHWm/nsPq55umDA5L4wCcNVlbN3S8huNVNy3tvRly3Nz5pabbhg05zXuuEyG3EOOs4PAftIEiwqr8MFjMBRBYqTYG4dAcHR6xyYoqkSTvu9hcDBHiPRlQmXrCVbDbdS3KMRdsEDbtVZQLNVWpuQdo/a4KMbWk6f9IuZnvLp9hm9IdUc2x1698dXepVvKEcO7RIvOlXATP+LI6uMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av6vl/QsxIvXTDPoA+3o12mvjdaLL38Ki/dyo+EPfXQ=;
 b=mbTKp+uX97j8RyXDnEBCVitFBGfr6Zho4mTVRHnzWayO1XYXcKk1ZUm4ALlFgDwYBfG13ljHfrxsWJtlsCnn8kEja+qdJ3OnIMZEr2/dDLc43+jxlsFX6jnm2rcq289078dzwudgY8eHp3EKUP33U88rovPU6JHd3V8DMvkgmWM4zm8XyDITUOj5CIikAwB+XTsmIW2vP2ovZIsYqN6LdJz0GRy7eNnbUQp58XE9Cpje+dIsodXRSlhTer/xoGXI/23WawP9zCWJ5yIL5zgWEvQAgtsHNuUWOLi/GWpvT7ZRtobjRZqZxc0thVNhTdNDN8xVko1H08OtMcCCdPvSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av6vl/QsxIvXTDPoA+3o12mvjdaLL38Ki/dyo+EPfXQ=;
 b=FgmPWUA/mfFLefFZ71yHBCWW4+f5HMrm15Tox4wB3Qr9iR/pAyQpBZDtlsFEhmXCnrZKBh7T54OVa1ZjA1/ZbpZxXKEkbAF3Ja9tif9j4VddzmqyMF5L1TksoUaqr2l6Byt9iI8P+toqcsmgD4SJdglhsrRnzqKY+SYdVDsMFeI=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0401MB2317.eurprd04.prod.outlook.com (2603:10a6:800:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 21:13:52 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::dcb4:903:81f8:a8e2]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::dcb4:903:81f8:a8e2%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 21:13:52 +0000
Subject: Re: [PATCH v2 net-next 3/3] crypto: caam: Replace in_irq() usage.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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
 <20201101232257.3028508-4-bigeasy@linutronix.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <5307ee7c-8d2b-5edd-a5e6-d6c70d8828d2@nxp.com>
Date:   Mon, 2 Nov 2020 23:13:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <20201101232257.3028508-4-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM4P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::18) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM4P190CA0008.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 21:13:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60092d5d-8214-4584-6ef1-08d87f743344
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23170DBF064D7CF4C129DFFE98100@VI1PR0401MB2317.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0vB1fFmxSKHcv88cF7qV68km4itJ/ihBNyAnbT9/ibVCGmG9giLiynuU2oXWalP8pSC26JvXSW1miuAztyGgYlHZp9JGB8ppzUEUVKB+Ql/Z9gGHzrt4qnVAhk2fw3B7tpotE/dvLDMhK0WzEhgyhECFXPRnIzduWMq1rMjfNAoZm5nLdxxaB4E4dVO80p/qnE/EdScZnClCcccYRzbKm2oHVtGA+Q4mAcIL53xHv8VFh16blyqSdYuulIO6s8c0mEdKfILH17YCXMOewGkF+BWo9+YG7Be6yT2RvU+7Dkd+lX336YyLO2urZOU/bh8jFrFgSW8tccHnMD8bwZ8w6Ti3wO0HeFUu/wkPfYLPO4pekhuIjSF+6C/kQINCi1+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39850400004)(376002)(346002)(316002)(110136005)(54906003)(16576012)(31686004)(956004)(2616005)(86362001)(478600001)(4326008)(66556008)(66476007)(186003)(16526019)(66946007)(52116002)(26005)(8676002)(31696002)(2906002)(53546011)(36756003)(6486002)(8936002)(83380400001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SsnRAe2qVH0ihkzPkT5qXw3jW41WRRBGxZBCgo4FbfQHCT1zr6QP3iujZwoslkMnmbxZTIjgD05zbYdS+gPkI3Fck3vvyeqh4g9ST/fzFvJPde6wCQkd/zq9BTsB8nPZQC40WBRhQgDWcxOYpXK7ehI+aZ+4QjNPccWwwo5SKYI9Mae9ENIFvPJ7mUCHIjhIkCBC+neYV0zp0EdU3eEdM7RoCOQdmtLWtiPMTUuROo+mKTkMgKNGALW/hPITkbZNTaXiWDSXKq0Hw2Z/IKfcY2szKLE5ZyHOqJj4QBfoC7D2Yptm1ScSEXFS/4oY0ZmV2vbJhR32OGQVxLQzr85xQFqut3+KNbSPEVBNDnEag11kAILbkD3z4RIc6HIYiWv7lYcG2K7ivKIAhgOjWW1gmeP13his5cEINnHlOHdD8swEsqeaIixzaEwbf9DGkovErzPTskyM6QqqXHSdvu9cJvolgeX/2gV8Sg4cnzbaDqGxkbFOXNrv9XoikWOSYLeuICpLTdVjLpOY9tB/VOTM7XqtaMt7qSOKO7n+LDZ1jpsIWVIJh9nGnp/pi6LG6OfdxUKVv9jHog3Fw2Afr1iCDf6i0v3CSWCvN+yockI50X0ct2l3oxf5wTC/St/0ilMg1F/s+oY9eAF1NdM/G/lvsw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60092d5d-8214-4584-6ef1-08d87f743344
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 21:13:52.8060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZ1u/pexk20WiLugtoZUtdWve4aRLXNtkEJwdZy3P62zvDxz3Z+e3GBPM+avuNJyTjfhf2/08Pws7hdk2jDTcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2317
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/2020 1:23 AM, Sebastian Andrzej Siewior wrote:
> The driver uses in_irq() + in_serving_softirq() magic to decide if NAPI
> scheduling is required or packet processing.
> 
> The usage of in_*() in drivers is phased out and Linus clearly requested
> that code which changes behaviour depending on context should either be
> separated or the context be conveyed in an argument passed by the caller,
> which usually knows the context.
> 
> Use the `sched_napi' argument passed by the callback. It is set true if
> called from the interrupt handler and NAPI should be scheduled.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
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
