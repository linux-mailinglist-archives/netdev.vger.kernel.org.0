Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0764FFE50
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbiDMTCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbiDMTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:02:25 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5BF387AA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 12:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649876401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqQGWfpIfeDiGToL9hSc963O69Z/dBNZDFn1Y4D0Bs0=;
        b=UKTl9hWW9vPOJ/2opJ+Nk+6KmpS2C4KFdwBjIL8ZhwAKap2urnzICiiP8xLLYOcT7+PG+9
        Dt/79lnSE6koigJezTOeap6oxLejNKwVNGti2rx6Xmjmf30h/fC85xQErsvcMBAPuYmnJc
        MRgm9F3vd/rfCQYHawG5R8x51oYuOBo=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-NLDykzu9Nx6vroPFZFbEKw-2; Wed, 13 Apr 2022 20:59:57 +0200
X-MC-Unique: NLDykzu9Nx6vroPFZFbEKw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0MMKtT2RUxIS262DDJgwsZB/frc1EJt7kMypwtUMBH0SXWGr+mUxKGJsLz1HYSwrmkgLkCuHbaq3o0LVL7cN1aJocTvf7xW6vzJM+d4DVgUoI4DDzChWrnl5nLYiiORwODeKDj5b3y5svXoM5sepJmIIkBL+9B8b4R8zVF+3AeOISYRZ8MawJjmZnO2ephQgeHo+uknpxT7jvF6t96aWmSXYibIqHKTJloznLC3tNqMvzU9rUWmMGcOAeP3ZcethcQz8QVgQMRf34DUZ8QePVqlTIcCxSWYpxW1m/kg2ZbmEfDJbuH5y0Y9A9SZQaarAb/Oz0xmKhnbKxOOFVI83Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBe9radBBck7FPa2DnGhsOrPmQ1dim+AWylykyPWgIc=;
 b=W/jjN7OGsceEs9K5qskn4yogexpLMYIngM1QOpWc+kEAXkpEsaXCLizB6mGpBDm3gktdwzrZQxvymHdQTpUa8mlSSJXyTiBEax54BRCGNGOohNoOs4PJL+z53KV7uKnG/E1k511PX+v2hPcp1Ahy3aH19e1LN27soMzSsdmdzA8q/iTDNTp0okIALaTD5Vg+fc6FXu1SL58dKFuIqMgFxifEfm10R5Tgjs4NGQuJLzFvM1HLbe1qwMgr6SD/ji8Uu/wX1zxpsgpZdnw9yGikz5vz9Gn9kRyGy6qwPH5aYhBeOzAqZuBkYfUcvENsTssOqoG2chyP0T+/hVFvYOzVvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB8PR04MB7178.eurprd04.prod.outlook.com
 (2603:10a6:10:12e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 18:59:53 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 18:59:53 +0000
Message-ID: <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
Date:   Wed, 13 Apr 2022 20:59:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] usbnet: Fix use-after-free on disconnect
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::34) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3be754ba-db57-4563-d941-08da1d7fcacc
X-MS-TrafficTypeDiagnostic: DB8PR04MB7178:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB8PR04MB7178C19E4BB1DC554D960ADDC7EC9@DB8PR04MB7178.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hw/BA4C6LVGyJGlduyhNmpAlMot+/xvuARmHjruKonlgZ/dU4+j5sXDOWbuqVc0Ghmxv0yNkRzyKTADtrh8ZpAgJF9hAON6DD6uZ0jhc1j2zfmv8/4BkpCHgxBO4HuJ4ySG5hX3xV7ZDfP+WcUbf9NMdCSBmwDgELiQtmXfVJ2AZRmJngeD79+tdMxpaI8fpTDjSYIruF1tB1CldPeV70pyi43U2EYyp2uXCQlbBSFkYHQeVFNrzRlNevs5LI6rXttPdkjVs4G6ETOg/XQZYMaWPVJKkv0l8vf7Kh/AJrNnhOR00AlVFIgPqBFseXXaPnAcHrpialbzMRQnzIH5owrl4tmj1ZcJpM3NIqbLPkviq9yN+Mk3heh4KVLoAf9ibFZJ7p/ZEpW26IEdWQH4aQ/h+q0hSIucAOFiG5tC3NYPTzPNYGk81fDM8tEpQW1MibTaMbmqcFeTrFvrul5T+Gmo51QvXOJxNxzTTFxl64O6Wr7qTjPm8OfsN+BTG/WsSlbWKg6g8JiK5w0ewvkB5/veF61xjQ+X/EwE18ViLUTifDcrwA+Ja5MqC3gSG3HZnLdg0Yh3IkkwBVU8TEV14GzAhnz7zrpMRiGOHm4yY9FYW/FQkZUUy7N/hrDvbW7YaeYaVroJjECH11/tkA1mRVlBJQPvM4xHXh5B/KSrr9IVNFy7dD0Gv/vFvCyLRLy9patDoICMA26msPkJvvnCnaHTB/8jLKKVxUQI2nxQt/mg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(31686004)(6666004)(5660300002)(6486002)(36756003)(54906003)(110136005)(8936002)(7416002)(6506007)(8676002)(66556008)(66476007)(53546011)(4326008)(4744005)(2906002)(6512007)(66946007)(86362001)(186003)(508600001)(31696002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yP0IJS8KHWXbIIFlnqDsn+6E23qGrj23+sR2cyiSnqdovvi40EgRSS+ygFsC?=
 =?us-ascii?Q?tNeGgEutI+OC+sLfH7Sp3YGj+ERz03kI863FflrQozOLzn0qvqSrjPL1ikYG?=
 =?us-ascii?Q?bBtoAb4iS4a9sx2ZByRc9pTAzKBM2upsZd9w9NtnhXrkRZzb6zUb+A/zWcXQ?=
 =?us-ascii?Q?zfSCxC+ckBKpSuWmjbVoaAQ2n2P0LiMz6b9XqVmjcGHpKVP7DxQPtcV/YXl6?=
 =?us-ascii?Q?b2Sb+imcIvzfZJTxDO5mXlWAv4zRbB88voacwPbaEBHq0z9f6pkBGI0HLCOW?=
 =?us-ascii?Q?/wfx6RydoRQGsJlKpe4dXZZBBvBaVN+P1157kCK8rtHngfxViEeVDak+/fYV?=
 =?us-ascii?Q?JkpxD+fBupu4vzNghfGVfordoHRSDckA9uUIjsKX1cw2l7iNmxx8u0SDuFku?=
 =?us-ascii?Q?I3ouUw7/WhT/ni8AN9O7YJnsfxHG782361dXQmN8AwrQqggscn6VXWxWmg1m?=
 =?us-ascii?Q?XiGu6e2VItSSzOaK5WEB9JnJrdFX10BOC1jEU1HpMkrwJdDvn0QG1w2htZwI?=
 =?us-ascii?Q?auBRagkEy3cHmaLE8vyPJtES8aTiQmjNwAsYJdLlcWxCWUCwScDlrUWqgIoZ?=
 =?us-ascii?Q?diQP0vd6UrIBD216u98bvvBsLFn8fg/thfnxD6JqFXuXnlpC+R+BEEC5qBD7?=
 =?us-ascii?Q?1G7yVr80iqpjjBe4dEa7zEQN06nZrKyzmLyj3pmupe6/PEc/Hryi306Pw1vS?=
 =?us-ascii?Q?ouIKLRzx9rjVH6pb0eoM3uW4zpOXIPg1s7CcpOJ07J/XMfYVdh3gdpekO1Kt?=
 =?us-ascii?Q?SqlyoHmONmwp8oSvHA0jQVASEg5WhIMOBIYlEUJqu9twgei7iUqMSCJ0ICFt?=
 =?us-ascii?Q?15M5lRbOvIel92oRpbPs5ZpmuMvdkSKpZV1ghQMxqab9V64O/XqyQ1+FgXGq?=
 =?us-ascii?Q?hwODshclfLMpFwzgr2t5HNMAWwfQ2qdv6w5S1TznEGUECW0UqxstGsexTqnm?=
 =?us-ascii?Q?0/YJfGJiKp1BtFjxw2TyFEB+mFM+Zq/SBtTIM2UTylvpWeabcT3lZyMz9Ug5?=
 =?us-ascii?Q?uw53+qHJ+DGbQNiYqC2pa78Tvbu5Fmqd3v3SoRcM+5Is1EaWtyUYnXJg/Xy5?=
 =?us-ascii?Q?hAmvQL9hlI53IR+0Xh0RshQu+Kf4RGIdtF6oA38XbvIIZvZWbCgeUXt6qLKG?=
 =?us-ascii?Q?mZMHuGzxKQphOViA7JrxFHBEiNYaTzDnud8bBlElK6SdPr2gwFw6cr6mKyby?=
 =?us-ascii?Q?UbmYOOChex1nHEUSEMY8JNDmRkxE/K+YjoXQoWzE+VIpcrH4xIrFXguMoTFA?=
 =?us-ascii?Q?U1WGA5IMWm2/cChSm1A8pRofVcekgnPlgPI5b7KrYtK2/ie+YnsHF6w9br3M?=
 =?us-ascii?Q?LO1p/uoHdNdd7aLWG6PLtb/RUuMJdyEwZ3GijnvAZ6cDQK2TmSoud7N1vngV?=
 =?us-ascii?Q?zueV1+Z6ld1er+jFTOXIUkD75nIBiduPTZ7lteDK9GA4yNAswzC9Lq9Bn/Wh?=
 =?us-ascii?Q?IXwLR6jHudchNZOpP3iwVxQoEN9t0MWuIxUYrlOuKx2qUKwBzZ7ekzIBMu9t?=
 =?us-ascii?Q?7PlvtFj51RckkrAGvXAGEbfbDVIi3yCoPVz5MXQpDhIFfUyalEgrZCT1cBkc?=
 =?us-ascii?Q?ljNnuqtkPFesN3jG2h4ONYOgulfxwDDsMGKnYUQXJI2KO+m9vgJk3pg4u52g?=
 =?us-ascii?Q?n2bqaoC4aCLRnUNC9zYPesOvJqnwZP1OlMOQjl2mgUfDzW8qJqXd5bv8cfOe?=
 =?us-ascii?Q?ztOxH4extiOLaJQOWE7zHs4lIquKZhUDP07rEgi+bYx1cLics+pez0vh8xES?=
 =?us-ascii?Q?QeR7tVijhGn/3C7emaJGcvFzxE1t1mgA2SSLOWk+BcbMmqyHZmBcdJu6526e?=
X-MS-Exchange-AntiSpam-MessageData-1: mXsjfWecie40IA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be754ba-db57-4563-d941-08da1d7fcacc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 18:59:52.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: No3a1MlMKoRuUow61QLMa8Py6vHbuZqXXQWiIXVHxJuBPJDD5lwiF4Hgn2HTCJsjG/aXvxGIfxhuGYnXSTjhVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7178
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.04.22 16:16, Lukas Wunner wrote:
> Jann Horn reports a use-after-free on disconnect of a USB Ethernet
> (ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
> different driver (ax88172a.c).
I see. Very good catch
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -469,6 +469,9 @@ static enum skb_state defer_bh(struct usbnet *dev, st=
ruct sk_buff *skb,
>   */
>  void usbnet_defer_kevent (struct usbnet *dev, int work)
>  {
> +	if (dev->intf->condition =3D=3D USB_INTERFACE_UNBINDING)
> +		return;
But, no, you cannot do this. This is a very blatant layering violation.
You cannot use states internal to usb core like that in a driver.

I see two options.
1. A dedicated flag in usbnet (then please with the correct smp barriers)
2. You introduce an API to usb core to query this.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

