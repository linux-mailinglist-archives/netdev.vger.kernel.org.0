Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFAE68F400
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBHRI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBHRIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:08:24 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8E0CDD2;
        Wed,  8 Feb 2023 09:08:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msjsSBUPYD4f2iTXzIOyWE8Np+KtrSqX9Y6mr03BqGejq4cUriCUd+/pqmCYxCBnOdvt2DcVjxaJzm3nZrxNL4rdyWaq2vP3W92w4beiFB3OOWG9v5DHEAWCxJFzQhXciCPpVrEatRvuJd3ljgnPd+9f6nr+S7RPL/JGLG56qoVZcs0cDq/OxYUoWDCHOQCMOeR1Hf9f9c/444ltq5nwLSbintP3HA0YvI+iK7ByicDtRUvmrdzqudJyKpoLohw6L1FK15lW9mM60oZCi98+a9gNo6YtI4+qX+XdR0fjjzWcv6ONnXwtgolYUcCjM5Zn7O0dqQm2HKLOZe7zM4Q0Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+B5Pz5oTzo9h0iUEsVuEtp2795+jQK0c39uqDQ+z4iI=;
 b=dRJRKCos7HOQciyTS4f2Qk0artoweiiZCmpNn96hW3e0t9Rl3K7AsboU5E9kDHGTAeZPCXTA1Ekt/1h4k+S/NIXi6XnYrdaqKpKBdxGQIj+F5tXFEYflnq6oURxhhjY0bvhJoorLlcc77HDFMUa9KT7hEuEL2B3yn9SrKWxfzKQhBrr/AI+hy6z3r3RX2IW3pxSgq/ygP/DruvpCqOD/uH8KGRmjRkmTCTnRPhmSwvnHmv48HF+AcouJ98Ddq4StezHEPTx4TjMcwT1SikUGI8lcVVasw/Q/86A6gYQD9BW8L2pIoP1kzjP0ZDlinEpd7iJEm9KkkQ5eU5l/8Nb7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+B5Pz5oTzo9h0iUEsVuEtp2795+jQK0c39uqDQ+z4iI=;
 b=YUbrq3RhmNtVS/UBO+BxvAwJQx5l/G5tYcaZwTndhpZDTfyRTBhOUu28kzB/H/1AT/nkYu5aZi6ECniJ2u2qw2wdXF69dF03tZ4ILU0NVcXbqxyqNmnIw6aA/6JsBVIjm+peTG57Xuei6135nk2HgFDs50FU8Yq2GsTWG1izqXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7313.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 17:08:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 17:08:20 +0000
Date:   Wed, 8 Feb 2023 19:08:15 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <20230208170815.nsq77mpkpf7aamhg@skbuf>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
 <Y+PPzz4AHRxZgs9r@boxer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+PPzz4AHRxZgs9r@boxer>
X-ClientProxiedBy: MR1P264CA0179.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:58::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: 47edca94-5ae5-430d-b729-08db09f713e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BtjGy6/X19AJELE3ct1xZZiznp1evDHbtgsHcV9KZ5X/OzZWNP8mIzZHJfSThOKiq19oPX3K83bgqr3ZRFEwe4uMxhhHw9apRVmutdmKZp+HpVwIyO6igiyrPPacEP+cTwDl7tzbQcNiciCxrXwwm8lgKl0Rl2gGrWifzxKa3Axs6yPJ3Ajaz+RCIti/rNvCKwuv1ntnz/hUU2qRBJNJtRC4P8qFic2aIgjNJHe8xBcOqt70yiGZ3dMis7PSQHG7CLAjvsmJECnsA3h9/tyMOsb0+YMYTz/sGvnM+d752OXot/DqO8ouDaVNN3CKU7/g8R13GpqlpBFuAe2HVtau2EhDGWCyEMLB3CiL4x6HA42vJhl4gzSoeIyAdzGe521r5oLCr009qF+rHA2T4tImpRA/sBB+NeJO/09T+d1lE9DeYrLiXbJnhpFfnqKsSZoE2d/hjnqI3LZ/J+yIbhhy3kCcm83RqZ5bDwpkTMy3DekhjeFTw2zLz9fAWaOpJPKmikzxsbiwV3lbzs2Jwbe3W2mW3mO6FMkcrcCT7cKMLzOk4z0uvfXOhTENI8KmXSkMyrZmTD7QWQi+XASBGiBiGJNUlxxpqxOByI5E9O5HsIVBIWbut/C89H5zG0wnHErdVB91NmZ1ORvq+KM1XLCmxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199018)(83380400001)(54906003)(2906002)(316002)(478600001)(6486002)(38100700002)(44832011)(33716001)(66556008)(4326008)(66946007)(8676002)(41300700001)(1076003)(6506007)(6916009)(8936002)(5660300002)(7416002)(86362001)(9686003)(6512007)(186003)(26005)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FWKYLlaY1n23XDliVEiJSNSv9eLX6yZeZRW9RfM0MLwZdFQQRsL1D+6qFYQB?=
 =?us-ascii?Q?3UcbV/p3OxHCgzN+0Ms64oPhIkYJFeexMelWpLnfpCH/xHaSJlyZO8hxFnyL?=
 =?us-ascii?Q?53a3V4oOB42Ai2M8+2KoM+52mISiCeRzxRkBws4s0tgT1wnFy13Xq60CVwzK?=
 =?us-ascii?Q?0fyK7/KiQ8LwTaa6IJKacAMP3S4ItW+nDXakie7e5UxbA+QpdnXOPXS+Dr+v?=
 =?us-ascii?Q?ahdLP+XKLIxJG9lGVRpsny9CGJpDeBeHXtP0UvjvnZiXq5MeHdChVPy7ZVzf?=
 =?us-ascii?Q?xYyYhJHSauQVxvIvV5021BlDMSY7RUzFUHnAIH53ljvYt6u3oSNdC5sF2my6?=
 =?us-ascii?Q?HYN2PWFoagay7heZAaCWc2Wi6jkOw9q/rJ9/Z+Z4Wk6KGsnyzUh4eT+gP0BQ?=
 =?us-ascii?Q?dDCzAwuT/jJcDsjgprLqS9baFie8k/PCDCX5DVPMHWcyHhojP3UOBgnG1QwM?=
 =?us-ascii?Q?RnPRU6Sg5OUwHxoJMo4ttDHQjTZpO3tExicMR/CoFDHf4nCMvYkBKDghVYLa?=
 =?us-ascii?Q?ghCU81UplCHjKyWymRLbNlYVxSO1md6PLzAAEpqGUEEPpkSUqOB0N/V//oUK?=
 =?us-ascii?Q?tTOizZZeOhUcVOd4zYSC1NsrHyd3aRYFZHdru81ZJFMjGuQi9aoGlyF+d+Li?=
 =?us-ascii?Q?6Q3u1ilrGdvsG7k/+XMw8zZ04QmVyiH3kr6QUR3DLEJZ847SnjhM5CFCG2GA?=
 =?us-ascii?Q?iBi3sLoTDiYTPNP5NKDRBXktQ5fONmnNq9JUiWhUf1XsdmDWCbseYyPd1Y1h?=
 =?us-ascii?Q?4raoSc1gZ2IkY97whssKYIJYMb19E4OW/Hq4kF1eGlobF73OI75M1DclRlt3?=
 =?us-ascii?Q?WG8Dou5Y3DZayRLjLoZhjdUB4dzkfc2Eu0TJy+HWnRLDzJNZSYzHCxoHKRMR?=
 =?us-ascii?Q?+l6xM+nPDVG+xCti6uE4vjFX9bwxEIcJaww5oEAQL644+Qq6YXn2u0aMnuKw?=
 =?us-ascii?Q?fYXDR7KRZoWs8so7GhvGTFmVhKQIPjgR78IynSW4+Io2W4FHpzrVS5fnxPbL?=
 =?us-ascii?Q?jjpYWEadrOrpE8xBv0ZgQjThQkdXp6Idm2EM+Am02q0O7lsfY8gWrSIvM96Z?=
 =?us-ascii?Q?Sz32Jga+cJldsdBxT6ycoSYy9DYsVegc6VPy7AJjffGoVwxUb7Zov2TRg38k?=
 =?us-ascii?Q?j54Q900/5nbw3/wL8EkxJa0WUNN18g7uDb/DuHaJo8pwJxWAO80kYYV9rwq9?=
 =?us-ascii?Q?G7ceG9hMHSruKiUUUjA1SoRTq3ELUjyT/dNZZcS7ZZm+jBbnXV+5LKpbBwrh?=
 =?us-ascii?Q?xyEgCmgfIpwnn5BQ7gtOo1WSTq+ScWFRn2/20jWRTtM3yO1KjpnJVaPTKNO+?=
 =?us-ascii?Q?4CA37KRKX6Dm/25B1DvqW2GSXJROwX5pBmNjmf6qmaaPBCCJcDJx3Dx3sMj9?=
 =?us-ascii?Q?75vg8i6nPOHZ2F5qqFkvmY8zJWuLOX1XuQeUZidwvYOh5LipDm0a9n3+4vvi?=
 =?us-ascii?Q?f3YIw8aV9/3xp/CaQt62/lMynXcyIolyhRXkN+u+SEvXwmeDmVmnLE+einJa?=
 =?us-ascii?Q?uueubliZ446q3UPrGpdMpaTdNMNBcHbY8owSTGkxgIJWggnUSTk4ktIary+X?=
 =?us-ascii?Q?MORULMtTISOhzLFkyoEfQmdK3ttmW4d/sta+yMAfWTpgq9XXimhmFoXzXS+i?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47edca94-5ae5-430d-b729-08db09f713e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 17:08:20.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dreyLdhTxd6qQV/mIZ9LSrUTdkjJc5lS+fVLZLwGGLFau0TtQCM4KjmVw/UFVzigKpziTaetLHRhU1Mb73tqMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

On Wed, Feb 08, 2023 at 05:37:35PM +0100, Maciej Fijalkowski wrote:
> On Mon, Feb 06, 2023 at 12:08:37PM +0200, Vladimir Oltean wrote:
> 
> Hey Vladimir,
> 
> > Schedule NAPI by hand from enetc_xsk_wakeup(), and send frames from the
> > XSK TX queue from NAPI context. Add them to the completion queue from
> > the enetc_clean_tx_ring() procedure which is common for all kinds of
> > traffic.
> > 
> > We reuse one of the TX rings for XDP (XDP_TX/XDP_REDIRECT) for XSK as
> > well. They are already cropped from the TX rings that the network stack
> > can use when XDP is enabled (with or without AF_XDP).
> > 
> > As for XDP_REDIRECT calling enetc's ndo_xdp_xmit, I'm not sure if that
> > can run simultaneously with enetc_poll() (on different CPUs, but towards
> > the same TXQ). I guess it probably can, but idk what to do about it.
> > The problem is that enetc_xdp_xmit() sends to
> > priv->xdp_tx_ring[smp_processor_id()], while enetc_xsk_xmit() and XDP_TX
> > send to priv->xdp_tx_ring[NAPI instance]. So when the NAPI instance runs
> 
> Why not use cpu id on the latter then?

Hmm, because I want the sendto() syscall to trigger wakeup of the NAPI
that sends traffic to the proper queue_id, rather than to the queue_id
affine to the CPU that the sendto() syscall was made?
