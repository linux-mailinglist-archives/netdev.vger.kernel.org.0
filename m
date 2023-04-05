Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FB6D84FC
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjDERev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjDERel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:34:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370106182
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xw8Hg1EoQvU1YPhS9O8T0AJMX3o6xlBKpYqIbaL1ZG3C00tLQa++WAVVah3lPWQHwdEITrH9uckzS8SpQFMfz7gIb642cP0kBOdSTn2eULRKY/ezqy/NpwoiVEkr4JWgyVs4ZHFnpLVNi0XKvpF1Qv74MXEzjCaC30aWEUOzOHCUZuneqfnA8bozddU0DFjRNMhK3THKlIBpGji7ZYO7QEXvh4RBJY2tZ0GLtC1KGHk6KwMgStyyitaajiVyljYmmzt7/rPQRPmEqlgcAiQ4B4HLXCCfr8UKrLQAUYsvad/yDU8vNnyPhiTm2p/1VvqALTjgfLkKDQJpHwMOh2rV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jXUs4GZ8gX3RtbODlpKyez51QuZ4LBSsth0pbLFolM=;
 b=Ln00lzABTCIkypTNDjvketRem+hiJGmLFn4mg7PytRTcfa8YiEkdiMG7k3RtZn8ethnpQiuSmmccEjBK9kxlgs/Uic3PLnWZ0s2qdG3kBcH1Fjwz32fSiVtpG18cMjdrOQlhd9n1mbyrbkgldM+Ux/p1aU8P63QTgKHCjYtZ1sqlOT7TmVtqdDBDroe4t5TJDKxiFtHxDfo9Lt5rht6IAy9fDpidIV7uQA88fxdhPPsV2ln3zJrGZGDC2S36ozBBnNYpB7aoTKQ2Jf5bxU9phLyLfd0Yv6A8cxxuW3KciAtLtyD4bnQ/8yqHBPhF9jNcXs1m0yBCZnkmsNuwwW2RmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jXUs4GZ8gX3RtbODlpKyez51QuZ4LBSsth0pbLFolM=;
 b=i0mKdN0VCuIdyK5T36srcn0yETFDZfn7p63Mw8E0LLwE3pGMuet/RAZrqojVK5s8jr91th+jaUavLZFg3uJicmUjGgl/nKRsku2ZMZABRZR4RuHNv3fupej5osdDPKAjOHUDtenKi705mvcSWnogJCzeLiscU/4mUuwxa2bxuC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 17:34:35 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 17:34:35 +0000
Date:   Wed, 5 Apr 2023 20:34:32 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405173432.pc4xssyd3g6v3ket@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405172840.onxjhr34l7jruofs@skbuf>
X-ClientProxiedBy: FR2P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8603:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e293f48-a65c-4870-93e9-08db35fc0632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jql3cCUbOcPImIcp4GaLMbGzY9PXBuAr1AFEMJ33EwSkZRCBlfElKuzBlLYOZ+kfgL8FvHpR5/6TU2SpuOs9CXbHjgV00imzGc6WS/PGCGEwAq2h/sPJq1l4ILTezLDXwQLOGjg/NosaXUQQvBBsz+jhzxUPFPJGDUPaPPuYIZpcNDn3ANP/f8Ldvvw8eSLd1eBzJYMMrXCRNZDltTlLP3dq3IT7ulu73PcLv44K5tetYxPkPPHmUqU46NfdbIVrhxVgEIxUfx9j4fIs5AggBdla1z/lPghwJVLwaZ9pBEwDdzXk3VWAZo4oH+UEi38fZtX4xZ1n8Usn4pe8Tho6KjDBW1QzDeRt4Lkyx0bhLeXtUTE9bIoNP92Nb3Wi9+wjYu+tw3AnRTWR4VxoFhs7DTOgC9OyGaUGU3ehdeYgPGiCITe9LOZSEkg+Mbvc/cHKdx4n7pc3sWrlZCTchWfMOkdw0jVE+sSZmY5UTPVP/ywWRMPdgxV9S79/IwtN2wuIKeFPRUen+Xdh8XG6ZRxQM/+XDY5wrS0BSXxl7V/1ymBRclIK9ZesN1KTQyPDwF1T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(6486002)(66946007)(186003)(66556008)(38100700002)(66476007)(41300700001)(6506007)(6666004)(9686003)(1076003)(6512007)(26005)(316002)(478600001)(44832011)(2906002)(86362001)(4326008)(4744005)(8676002)(6916009)(33716001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ezzE0HR4T7o4ZiS7nF50YZG2JuYRpzqVcaasIdSfRreRluINSVa+/LcLwIY4?=
 =?us-ascii?Q?yiY/cT3slYfDVVwMSsCHcjJL2j5uLP8bXGklGMTmIx+Sm2BGjLhFbtgrksTD?=
 =?us-ascii?Q?4+NMTgGHBOhDl6ydJB2CQz6SRgfUQBYGU/YADTEqGFPgLYEeYWwb8xuYcAhd?=
 =?us-ascii?Q?zG8snFiiqm+sCMdc2AT6HrSHeXvqp7f2IEQM4N/aDL89KDXjNJFZ2iakt6Fe?=
 =?us-ascii?Q?OiDVFKTHZVAPh3/Mdu8PLHNEXibOX3D2e+JLIq0bz4U37zGI6BKHUK/oVPg4?=
 =?us-ascii?Q?CDk6D54h6z2e2YusXSD0p8zOHnrenvalC+FDNtwITJ/KPNWCwmCaInzHpFl9?=
 =?us-ascii?Q?V70zW9kCARKqaMcVdOfgqQMvhA4KAeJUilSOtdYypnVO3CfXczTfLWph96AA?=
 =?us-ascii?Q?y/eMIWbVv2mqF+1V72ptiWNaDq54Y3aN7kn3PnE11ym65P4+ZGmWZaUWaa3o?=
 =?us-ascii?Q?34ja7XVIIROCUVLEBNUccuDtu0h/dtJUVyNvcem0GiQv7QjN0ixjCcHdaMeK?=
 =?us-ascii?Q?u5/jpjEUvEt92GPq4VBNZsF2ap0JztpK3Xia3JindwX58gL52Ofl/DR2SUxt?=
 =?us-ascii?Q?n2GRBOGUMbLKoAEi9CFmd8zUKOdOTR6pp2ckuojYl3DdX/JIuvitw5CYMJmn?=
 =?us-ascii?Q?q2j5t9qvBXztW0PMQf1yQHDwIr6+5lgJWls6tvvRRYmHW/ravT+iANz5yPeq?=
 =?us-ascii?Q?Vr2pb6Gzj/lsiPTshlZq7sxw87qdJGigcNJDqG1WU5dQWuveFULG9P7wJUq7?=
 =?us-ascii?Q?bkzMH0X/8Dp3auqXwDe/mr3XII+0z/xY40/9cE3aBf4JyE2TibGShqERm/Zd?=
 =?us-ascii?Q?xDrzTpXZWOXjIZUcbF+1OYC/so0hfam1Ql4K1Tm0lvX45UaophoUyTvycRgP?=
 =?us-ascii?Q?SWvWCFVsqEeYfVfIAm+Fj9RYsF/GCVYwJOoIpnFt3CAF58MXCy77lYhB1DwW?=
 =?us-ascii?Q?ZVEoN4ZzNptq94/9xcLXdtKXwTbJgzmgepiLiIqXVQVR+kcmjZjTMQzhrz7Q?=
 =?us-ascii?Q?vjqQTA8RNMHeD1FSQjfIkCyxJbRokXlh693lWFTQA69GvxwvcwyDKpappXSJ?=
 =?us-ascii?Q?T1pfjIxgx5tAplbxQeF7JXaMY0ylv3a6R0wSSXwMIvkBW2TOYPSSvlptkoPf?=
 =?us-ascii?Q?gzcJ84WmYARJCXj9QBSvq7KXHnUTR0Vk9UAObnGx1KigvV6SX6/99YYRthj4?=
 =?us-ascii?Q?KvBZKoVhYtWxm8IF4vtKt2pWmMSvtU/E/D7pmuesKL4jka0zDU7YG31AwtG2?=
 =?us-ascii?Q?zLzVrYzKg9XG6UispbUsNaNt0bhQshncWNG45qEquoCJsC7s4Jz8XXrLaCTq?=
 =?us-ascii?Q?XdjDHSvFGDE6gOktsRpDav19GFZixuX4rHDVWxZGDXb/wOcSIIyIqM45O7bV?=
 =?us-ascii?Q?qkeBdCIJqNNUWFPw1JHQQKbFfMQJR+e9ublY16rv9rOWXXqk5jJc/vxIj1ko?=
 =?us-ascii?Q?9C/TWyggN6dkj4gzRoysdSsSmQ7Ppx2pswq5RZYKI90F9wcdrpKRoULt04+E?=
 =?us-ascii?Q?FV/2p02NCAzKYiZjsgNAqWOF2HJLHsnP2F8gtvraPbirmU8viRUl5gfj3QV3?=
 =?us-ascii?Q?9P80NVMq5IBmvaNpmRfHNgxXDaRrvEz6aWDBPqi6bFfaVfPMbFThtG+eDKWJ?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e293f48-a65c-4870-93e9-08db35fc0632
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:34:35.7730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phlG8ZvHXE5W8pKK8jwIeN449e27FkqCxabTNAp9Y1RfVGslzHDwB2VMuXi/8ZrkctzjrNyzA9kKOyT41zB1XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8603
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 08:28:40PM +0300, Vladimir Oltean wrote:
> - it changes ifrr.ifr_name with real_dev->name for a reason I can't
>   really determine or find in commit 94dd016ae538 ("bond: pass
>   get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device"). Since vlan
>   and macvlan don't do it, and operate with lower drivers from the same
>   pool as bonding, I'd imagine it's not needed.

Ah, they do, they do, my bad. So it's down to 2 differences, which can
be handled easily with the wrapper function model - the bonding wrapper
checks, or sets, the HWTSTAMP_FLAG_BONDED_PHC_INDEX flag.
