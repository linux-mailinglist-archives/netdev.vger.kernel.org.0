Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934446A6F31
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCAPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCAPTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:19:05 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4330301A9;
        Wed,  1 Mar 2023 07:19:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlHpgPo8NKOx2sWN1bpiZQLLjbTlGSG23cKdENtp8MCEEdKLEIHl1pYQt5ZVqeTk2SKcDOYDK885iA35Bg4CEdUJ9uRgqoWDJva5UGekmKUoZhV2h7sHIoZ83nANwSlbCiATDVnHl852+tA0Hyi4gC+mHUJMoh3hnjvdJBk9eWRjfCvfPDSqp/ZbzQxYzBoRWY+9EuP7RM3DeVx2ACEACJ3qi/Xr9V/DlzXa0GiJ/w/tUXpQS7oof2SRF5bzscASuyK0TTZo7BHq/WT3c1C/elbAuKP9Bn4gLe3ZoZLvQA9Bc4SxJ9hFxeA1i/1Ymb7dPsmr7BDj+/IuxGx7S2aufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rhEPpYVijhWT1TN/X4RukYEHDS6CMWxdc0ssu6r0bY=;
 b=YqbWOfok+FibIMWiJfu+LWutrLSCxH4Akyw10Wdx8s2dxuP2aRfDqI/Mov/8PgGySqvIwQLa5tYyQy7gmQp7BbpfeSqETdZ/AsFcZ1njyuHbCGbFB5fnzAAWB/ZCNOd5JRhgmasxBpl2YPYrllHCXHWFOy9G61FEDFYQfiA+OqKdAhK9V53m4UmkCT/WVmG7u89+BZ9aQTeV5HKoBsUnxiiJELEFedwR+SFg3btFiA9uEFrxLzSfJcSPHTfjuO9Uzvm2tHEm8+QU6c3S1c2SIbesweMvwHpkSp5O4ffso5DvKOQl79QycArjIY40vWP5bvYTPBc4Vyi4vy1AkPd9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rhEPpYVijhWT1TN/X4RukYEHDS6CMWxdc0ssu6r0bY=;
 b=mKdhnvK8cn921SDm0Pzt5yGI83YfZ8UrO1lrdqtdVgyom6smydzXr73IwKOOFA7tVa+3eG0PB8xIRARKSS6LSJIkHEiFH82p6A4zfoGOOBgsWKYzkqvSL2+Az67INgwYZ4pbZ5C8z1ZlkMEKbLJk2OJnlHaUvIKprT13gEXgYTg=
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by AS8PR04MB7847.eurprd04.prod.outlook.com (2603:10a6:20b:2ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 15:19:01 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%4]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 15:19:01 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "gerrit@erg.abdn.ac.uk" <gerrit@erg.abdn.ac.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vani Namala <vani.namala@nxp.com>
Subject: RE: [EXT] Re: [PATCH] [NETFILTER]: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Topic: [EXT] Re: [PATCH] [NETFILTER]: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Index: AQHZTE3rnUEXfwHF5UmUMZBU58ioLa7mBo6AgAABaYA=
Date:   Wed, 1 Mar 2023 15:19:01 +0000
Message-ID: <DB9PR04MB9648F84755C9894D720F996FFCAD9@DB9PR04MB9648.eurprd04.prod.outlook.com>
References: <20230301145534.421569-1-madhu.koriginja@nxp.com>
 <20230301150747.GB4691@breakpoint.cc>
In-Reply-To: <20230301150747.GB4691@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB9648:EE_|AS8PR04MB7847:EE_
x-ms-office365-filtering-correlation-id: f9a54e24-84ff-4afc-c619-08db1a684993
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q9CUCKWK5qQlIK8xBgy3uaXfVOWHKr8VdHjni6JimNqFJKTS75zlE+mYrKAyiMKi6uTw8YMokJvcrpL82NzQoV1B6C/RG8H1H20HoxnIlSLTkj/wHN1jk6ohqIZ93X1AprsdB7xZwRknSh2JVXqiTa8wqrj3o7p0J4el5IwGvWt4pDJMZXDduZUGWOR7/1ZikQy62IfocxlKDrUhDrgZnCYTJ2P8g3QenKdeFM8nwxz33hFeWW0PmYaVoVNHU7Gar2O2Hf2q/u9AppEKCj2BScYECJLgnh9ZZbGmIe/U4wPAI+Bu6sN08ks8h+ihdR5zjggndu1dxqwL9RtJxQC769LrXOx2lwfqloEX4W8LTBB2742yHED157qiPfoLlUYmWkxQnxi1xfq4emsyjZq7gqXeKwFm5ibXL2rzWDhcocZU2/WdrQc6vCzzzr7Ulv/WjwPxagavu0BQ6s9ca4oWWiETjl9FTm3SrDTt4F+RrShW5V61TRwBYPX6bfOUCCLZFV1qGEuw4D4DptMNK/UsluImwzsZ4tVtyWZHJepTl2/yLuyAyJIAs+6z4JB4Gfkvb9wIo0wzzisw3eOu6H7P91Y88fz1Vh+ZEK3o7rHdLzk3N+e5XAclYViUKpbpxQHxqCxhtHo9Ve8GT8PNepK4GhSn5vqgXgmnebd5PGShmg+zt/h6EWuEx7xVwDiijRptt4r6+EkKtKmrW+fwPqoxVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(4326008)(478600001)(83380400001)(316002)(54906003)(33656002)(122000001)(64756008)(8676002)(76116006)(38100700002)(6916009)(66476007)(66446008)(53546011)(186003)(26005)(9686003)(66946007)(7696005)(71200400001)(6506007)(66556008)(55016003)(44832011)(41300700001)(86362001)(52536014)(5660300002)(8936002)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5ri6xe3VISBXErvJHF0U9x6Ha32eecf2uwRFP8nA3LxfTVnkVuAUiITlDv5c?=
 =?us-ascii?Q?ktCgmIammFWvZjiUkpv5ra1bH8Rx5MJp1cx43Mw1R8PldoL1RKTdm2p3cfwV?=
 =?us-ascii?Q?N4auTjEb2qu4EEcZjTn/OpUHLnQjZcr1pd2B4efOiI9p9wZ8k+N6KzpJ6BfI?=
 =?us-ascii?Q?BbxE+5NnOGEB9BlV+7ueQzeco/AR2QyAIE6FSFK02bkm37DjxzpWPc+EgBsK?=
 =?us-ascii?Q?M7sJ1/LRNuzHeYRjEnat2nsKr9kD46mklJpkniVOcOJXsfpghUCkNWgsCU1L?=
 =?us-ascii?Q?7aq3awSp4sSG7xIcwhFjx6kZCfqfdS/k0FjSFvrf6fKHWQ/D1aRmGjSbMK3F?=
 =?us-ascii?Q?t+KX3B2KUfYWHKfdIVQasPj9QvbFOzKoXLKLPp6HHi7XI2WjL/XrsoNxX8fh?=
 =?us-ascii?Q?y/L9EQO2M6Jh84qFt3HUVZPT5ZXf712JEuBtJEdpLMjgAntc25eYzcYImb8o?=
 =?us-ascii?Q?sMCSaCE7d0XpQVk4BO3jagJMWSZkcXIpLgw8cZJLRflGVfRAQhw6O2OZJpsg?=
 =?us-ascii?Q?rdwfa21PbrlG118hpFO73U9envWuOCulaVkOeqEw4AHwB+7Ity/P5Md3gXQZ?=
 =?us-ascii?Q?Z1xV00ciZZvdIZFSX0VrvNSxszCwSfIDSANjBxCsQMchoWYp82JPJ4tnB3/S?=
 =?us-ascii?Q?jBqGRJb3RzfZfwtTb2fxcqoPGuU9nPQMS+LcBU7Q1NHjpWW/mpnspZ6heUWD?=
 =?us-ascii?Q?701tssoOzYVpFeuwFIDooNX+fjZZukVwU41VydSXDdQ+fpjyqLc3sQ1rqnFQ?=
 =?us-ascii?Q?IYqvjLKaJSa46LtbVKCaxxRDtwLKMCLT2xdtm8q9YoKjFrvH54acgyU/n13Q?=
 =?us-ascii?Q?jZ0lveEeRZRgNiykRRag69cIldPMz0j8QV2Spj6bTx+3NdV/tqHSE59Q2a7B?=
 =?us-ascii?Q?ym+08aWiHEuB4uIjE95qziHTD6/dIGnXM3PyYKfrUO8gdGq7u1cepW7qjPsh?=
 =?us-ascii?Q?0LVgX/p6wcOz4aAMJiOA080jL8bRsEiAOXyqCBt3gW1iRDSi5dPKnEh1fCNp?=
 =?us-ascii?Q?uOc3I5FK7yOcdg6JQlgormNEelqsABME/Y7NET6AKlzCEGfiMhgSg2EyoVOD?=
 =?us-ascii?Q?HfrdQc/DF+WPz+9k15/TMYMvcAe7rVNZbLdZVdYz8WbSiK+HNN1MMlGzNlm1?=
 =?us-ascii?Q?wpxp0wtYeStAD8GAaHuIaS0MmihRaZ+wbRXIlreoUHziNG6vB9ZRtZo5o5q2?=
 =?us-ascii?Q?ozv4U/hxr1xHNptWbHCroT1dfBacuPY47tHz0a1Zjkvc5GTdGavgIxcQBc8j?=
 =?us-ascii?Q?Rps5sVdNP0eaBH0NPh3pWBSGsvXp0XK4tJvBbGGk68Anffc6jPQDiNL3z5ps?=
 =?us-ascii?Q?33l0AgWZb8fQYfdSDwHLoQRMHIgHfjg+o3sQ/1t5uIYroAU25NgFoSq7h83J?=
 =?us-ascii?Q?UZYzvMTHIBrfPmCECNUmyqLyoxGvwS/KocePdsgTZY1MefKxusZoVRo60bQY?=
 =?us-ascii?Q?wrwK6XmeJtbiXD31sTatUV/pV/VMEeBtE+ZRTc+Ezt3X3TahZR5M9s5pk/V+?=
 =?us-ascii?Q?5wwtG4xf9smfpQITM2usf1o1MNDc+o4oR44/ovRRMJgP4bFa512kyAjfM0G3?=
 =?us-ascii?Q?b28TiKn9GiYHHiTcHQpK0HZ00tFIdUyxBTKMNxYv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a54e24-84ff-4afc-c619-08db1a684993
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 15:19:01.5930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CzeS3LtS3fZCxrTtH8bKXwXcH4hY+kRR+d3cRg+dwkAFQh0HXGWOp/m7sAGJwnzWfxedCDsDs7fCQZEi75kh8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7847
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,
Got it, it's typo mistake. I will update the patch.
Thanks for quick review.
Regards,
Madhu K

-----Original Message-----
From: Florian Westphal <fw@strlen.de>=20
Sent: Wednesday, March 1, 2023 8:38 PM
To: Madhu Koriginja <madhu.koriginja@nxp.com>
Cc: gerrit@erg.abdn.ac.uk; davem@davemloft.net; kuznet@ms2.inr.ac.ru; yoshf=
uji@linux-ipv6.org; edumazet@google.com; dccp@vger.kernel.org; netdev@vger.=
kernel.org; linux-kernel@vger.kernel.org; Vani Namala <vani.namala@nxp.com>
Subject: [EXT] Re: [PATCH] [NETFILTER]: Keep conntrack reference until IPse=
cv6 policy checks are done

Caution: EXT Email

Madhu Koriginja <madhu.koriginja@nxp.com> wrote:
> Keep the conntrack reference until policy checks have been performed=20
> for IPsec V6 NAT support. The reference needs to be dropped before a=20
> packet is queued to avoid having the conntrack module unloadable.

In the old days there was no ipv6 nat so its not surpising that ipv6 discar=
ds the conntrack entry earlier than ipv4.

> -             if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
> -                 !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
> -                     goto discard;
> +
> +             if (!ipprot->flags & INET6_PROTO_NOPOLICY) {

This looks wrong, why did you drop the () ?

if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) { ...

rest LGTM.
