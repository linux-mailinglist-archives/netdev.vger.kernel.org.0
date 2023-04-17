Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B461D6E4954
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDQNGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjDQNFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:05:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2123.outbound.protection.outlook.com [40.107.92.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263329EE8;
        Mon, 17 Apr 2023 06:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXzV4lMOBNE67QKijf3Q3wkmrk8tZOx6XIX0yggmuppO+rKB5YR/f5CgTbcjcdk0VgbUfN5pN+pydgL6Ea0yCs2nL5dWOW6NkT+Tme0Ex0C5KxVYqyXBvvWZDq9urUQAnjkHZAlAM6IMxMrxEz4BMoSgmwfaaFIbyZnBCqGG8YUCVx+fKRsI/NOXZ1FvfCWNN2SSqp7dQAeUj7l8aeLENBJL/89ckNIgAEWIeZAroZMPnHeB0GjINR4xVOs5JLAOhIYL2LkjylZSPZ3W3P8IkCxuh2jy+e/EDgYNI0dxPtjTOW0LXYqCyqTG3xUIpmhOvA3h7TKC0AYB3ecREoHI0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTZlb122MIx5f+mwk0NlOvQjFjOkZUm3H7w8KXQ6GII=;
 b=IXtHq5iDiV30fVyMCI/5HFgT9WzQh6gzTk+vIuY2WZw4Dek7apOaAO9No+tIdS0VyzZCc02uRAPRjeUyuFoEaCBMmzYPEuSS0f4HmExYC48baWvJYxSiDApxwwbDetiELzxDage5T7OwAw9kU5XZQek85K52EQ3JR+nzx8moC2qhTiZJbe6TSPZ5EOKVnbG2cdHyivDFhHvdqjI/lCaaBdEE0rgv7fFgcobgDSyvdm5axti9whldw8UhGYRpYoMNpehyEHNwU3XUuIMSclunVQ28+FERlnbleyJgnbkP0SVxYqww7286fzl1ND+PzpP+M78KuoH58X33BVGK4J1FKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTZlb122MIx5f+mwk0NlOvQjFjOkZUm3H7w8KXQ6GII=;
 b=VxsW2U1st/0pbe9VIT98v8cQCtJYqGBpcLJv+gNs5L3qX2BKCuix/EvslGZtzhAkvW3sj9P0QnNkbNyGrUm7QrXihTsRYlNOOyVRQubN6WHGjHCUxOY+xbYHHKdGS3qMSb1AFwUhnLmN9yQOg7cwVWtLAUqJf3McDz78+/IXGjc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3959.namprd13.prod.outlook.com (2603:10b6:208:24f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:01:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:01:58 +0000
Date:   Mon, 17 Apr 2023 15:01:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: mscc: ocelot: don't rely on cached
 verify_status in ocelot_port_get_mm()
Message-ID: <ZD1DQN8HlSbVC+ci@corigine.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415170551.3939607-5-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P189CA0028.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: 2352a798-8452-46bf-301e-08db3f43edb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnOwGd2pLuaAin3yrETo4JlygGUozoycSRferLCiV/DmWyot8TypcjMlnEvQrIivqj9WUtQZQtct6CxApFYQumg1XV6kS9Tlt4ua8UWN5PHk6F71RW62HOrN9VZKHn2bX99sdpqeD1Lq2yyoL1cRs19Iw6y7DqI86MSyni4oOFtbgNima7DlsIJQQEXX5C0s8dOsh8DVxAR37o6QzR5bjlBh4gV1R8hOdd+hM/gW9xdsK6bfB4sq8JpIq323Y9iwfl/hT37HWQta754sASoDqCL75lkBTuhK3CKE16Kcf4ZKV0n3K9J/pRK5mlplDZLsWO5wBwgTN5rK+mPtiuergO+2qnS7FSGinjTjlTrHVf73w51qnbNbGjxHb98mN/beiCVzU0+YL/e932coDDUNejQ2/By9Io6/blahEkWZ05y3TjfhgrvCHAfG9ZQVzkCzKMNB4Bpi6qGI7/rwFRvs6i0QWFsj2MW+b0G/GqbZlNwAIMJwGj16kbIMAs32hVtSiPPC+VgW1kwbPWLN870Cnim1rU2kM5wgNcgcrqPTxCiUqII3j1/vCS1WH+NgGEWB44oWeCfzqAHFJc0YRNeEsx7INJUMeuiMxkwgLICFDuqHZKIzo1+sVrTFi1YwMFX0+fyojWcEHYgCEti84sjMUjs+Odg56r7jUQJWq056YHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(396003)(376002)(346002)(366004)(451199021)(54906003)(38100700002)(66476007)(478600001)(66946007)(66556008)(86362001)(6916009)(4326008)(316002)(83380400001)(41300700001)(6666004)(2616005)(66899021)(2906002)(4744005)(6512007)(6506007)(8676002)(8936002)(36756003)(6486002)(186003)(5660300002)(7416002)(15650500001)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ySmzw/zoZ3YdCt1SkOa5c141oMYGc8spJDP7A90XDGP+nPX9j2JddTkeYuUW?=
 =?us-ascii?Q?DPBYP86VgWYxC+fp5RYxwpu0Uwyz550YVg1pPOo4vlm+gYCiFmSupHBU/FzI?=
 =?us-ascii?Q?g/ejCx48N+xbH+ex/c8joouJda3fNrHpIM2pnJfLlI4fSo2lsH2NdXrk7MNx?=
 =?us-ascii?Q?740XcSPoPitr4qyKBdmF+mxVlcSvgHY7dUi/bW/ZLawEvtlWIt76u+gzxuEp?=
 =?us-ascii?Q?sAvfQWX8QlNFx/D7wH5atRtw3rPoUDehNOStYO6MhzPZa+K4SYBvVJsyvio0?=
 =?us-ascii?Q?oEZAfgzvFFSWUaWWr0MzfVtqJiSk2C79JFQZD/vZfRRcE5OKG2cIASegjYPL?=
 =?us-ascii?Q?JdnIW/NPoZGvMAD1ynaVz1hJY29QwjpdoV3Zt/QHWMjgmbidHpGXHWunRKX4?=
 =?us-ascii?Q?5iDZP7UqNEWAcsbHpH9ScuGtff7tisPEp2i1KmajO7DzBWkMZzKz4so5dq0s?=
 =?us-ascii?Q?efttg8qst7rpoNhGatVQCxm86uZbjWQbQ5B+fKMojZ7IJmeTUijn/W6mK00R?=
 =?us-ascii?Q?zJ8Xq7L3748W2VMvVIEX9ErHsIZPE/WQRIXeIxSR774Fx4ZVJD1EC0eXNLfx?=
 =?us-ascii?Q?ceO+dl/suLH6rDNgAPM+CJeKsH5gfmXzg5czOxIeSsphEsW65He0ycBr7IgE?=
 =?us-ascii?Q?tWeyABR1ghh7WBc5m9n3LAX3EA+CbuKGOhVr2kINiz2HMsZWB1cfOOENKaZT?=
 =?us-ascii?Q?dtSHh2Ts4PriHP/WXz5k7L7cpT/yebrBZqoY+4MNOdOlHP55YkFtkTGTk3a/?=
 =?us-ascii?Q?obCGtn3z2eZcji9+IlVwTVNfmfSh1+idmnaRi90vGOa38ytGv1prD+RP4mK1?=
 =?us-ascii?Q?CGaiO7s7MMPTto+gipi5x+JzsnQ/mAMdFaY38xnFUMmAPuS0GQ+ApdDqxma+?=
 =?us-ascii?Q?aAdhqd6PgY7ZTlFQaPIlvhOV0flUYT8Q95ixJ7K8VOThxmZW0tr3HQyIanmm?=
 =?us-ascii?Q?SNG8YbeaWalQkHI0GJ3KG53JVKTdsjUeSEiRGZCUc0N1/OZdXo8PAZmVo9rF?=
 =?us-ascii?Q?/j//96XoBgy6u7IWdDmG0SWmItq2hPRESH6xyaIxpUncwUZEFNxQwhE7xDfA?=
 =?us-ascii?Q?QRHxlgiU8fFnoGLtnXfIACxL6FW40SXcZqyyjt04TRYq5j0NKajRy8ZCNkLA?=
 =?us-ascii?Q?TEE7ysgfmXd4Ew6DkakiaUTfVx97Aiy5hZ8iFj4O/xvVYuLfyLYC+RN9A+dq?=
 =?us-ascii?Q?fTeIQ27teoT6y0m4lWL40tJYINYEonpT5ihLl/xKdhamxNZxFyKhVDbqx1W6?=
 =?us-ascii?Q?tWPQjFDBG9HnzpJJM6NpXZBESBXtvQsTJ9N795AnyeFfFHfc8jLtMrEh3bdK?=
 =?us-ascii?Q?2dt8/Yi+o6pt9yAlyhZ0Ap7/U6jS4CaA6pPlLitLHNxnBIFCpnh9XEHYRFYH?=
 =?us-ascii?Q?jLoq0PVuA9GOCQRy9UVotgM1/2RaB/y2iknAxqZZGMonZ8fHI6VznYI5FWze?=
 =?us-ascii?Q?VDzmi4Y2Kz6Y5D5k5MMDojsOl1ZLS+fndNETduTVYsbZTIZeHSlO147enVHH?=
 =?us-ascii?Q?T33LK6A6TLH0fDX+JW2NxsfUyzmIymtNtVCf8uicVjwZAPfbIglkv3R2qivm?=
 =?us-ascii?Q?9hWWYj/vmaDuOo+ew0lR3cCvTwhmLkowGETpyzj7inqbQOuy054g2PxfaXb7?=
 =?us-ascii?Q?AGISp9TqrPIAU97w8OXzD6suu1xXEorSjrBDxHGcghBng0PpPqdiefY5+NaJ?=
 =?us-ascii?Q?5OAAtA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2352a798-8452-46bf-301e-08db3f43edb4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:01:58.7944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/3mVZBv1qqB2ReFdLjphQXJincv2jhUN/DVlkMQG3iNwKHPm4CTLr0WF2uvvsFPKIyXCm99haOi8vrPbFUxfirCNV6A6YXW846CO1KF/XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3959
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 08:05:48PM +0300, Vladimir Oltean wrote:
> ocelot_mm_update_port_status() updates mm->verify_status, but when the
> verification state of a port changes, an IRQ isn't emitted, but rather,
> only when the verification state reaches one of the final states (like
> DISABLED, FAILED, SUCCEEDED) - things that would affect mm->tx_active,
> which is what the IRQ *is* actually emitted for.
> 
> That is to say, user space may miss reports of an intermediary MAC Merge
> verification state (like from INITIAL to VERIFYING), unless there was an
> IRQ notifying the driver of the change in mm->tx_active as well.
> 
> This is not a huge deal, but for reliable reporting to user space, let's
> call ocelot_mm_update_port_status() synchronously from
> ocelot_port_get_mm(), which makes user space see the current MM status.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

