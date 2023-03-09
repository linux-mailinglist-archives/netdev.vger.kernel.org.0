Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6346B2B1F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCIQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjCIQqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:46:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278FB22C9F;
        Thu,  9 Mar 2023 08:35:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lM1mxxfdVBJbbqq0mGtHGHwumZsFFTNnJcwJWbC+jXIrQeoJeK2qlGjJAlkUzzsb5Uh5A6978JxJ5XB8EWrjr1nuMju9t9A9FKH9tocEbbyPMyXuPa+PkcNsKIzJg7Y6ZIsGhvaobE44HPg0I+e2ccY6Q+tgf6NDBVl6rpzVwgmL9RMAYjJn4QT6VCbgctYEpywOuPFOdbD9gzmXg5w8K1szkyvdl8ShvLwhT9yNkV3yMQWw5SR0lbHELRXcoxzhta33nXIh62ZSvk5HwVyCm3SOPhLSYugo+vmz9tRSRfWAiOcULPbSDA9g7XKFMyPiMa9NRwG2LepqN9Eo8Ou76w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBE2SC8BbEutyeOkWwK3IbXF3sYlG+i8jWWjHFi1/Kw=;
 b=Pd0+qyRqQk6m2aOeALRJvEuvr0Y7Mxne3q32fS8HAUnWHj8I/bC7kENC6UTYaOuNkbYLg71pDqWJ+rC7MkFujUP0I3RNxVJp44bIhq1W6R4bOmCoTWLCfu7kF/rXnuUU1OQAXPHZQPlI13NAIPs09Ofe7FJBEWKKi7xW1j6v9kEcLqOgNzPNJ6Ijmxpq5wgZdBIosepWubBys/92taWztLIo8rmM4Fiugmn7fiibcszxFVmvuIsv0Zv/yZ08t9KXWUMbDiAaY/NEcOml8g8025QUThT64Uxhj3tElqWHifpvjJ8uI+w7Gx2jvCSBKd6K3NwA6PFlv1f4+F13DHxz2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBE2SC8BbEutyeOkWwK3IbXF3sYlG+i8jWWjHFi1/Kw=;
 b=b4L+ZNQpJRrTNyUBpiSsKileOVfo4HGIXYpxTTZmLlbM2kC1bDvtSjKFjTndWIsZtoBzGNz2VS7TrquJ2MditoE6aXJAqPtJ9rLIcygHCLSkXXYaMmfSvpmpjD+A/t3a/rNzqDvSn+YQIn25kam2PU+QdQNCWvq740wFokB8aBM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5188.namprd13.prod.outlook.com (2603:10b6:610:fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:35:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:35:03 +0000
Date:   Thu, 9 Mar 2023 17:34:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: call stmmac_finalize_xdp_rx() on a
 condition
Message-ID: <ZAoKr+EtakUhrUVI@corigine.com>
References: <20230308162619.329372-1-lsahn@ooseel.net>
 <ZAnh0TGtDkVUl/1m@corigine.com>
 <e75d2a42-4154-e469-bbd7-9409471ab724@ooseel.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e75d2a42-4154-e469-bbd7-9409471ab724@ooseel.net>
X-ClientProxiedBy: AM0PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:208:122::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: 1282c72e-38d8-402f-38f5-08db20bc3bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wwILUztRzhpshCY1rAlSF8mXZeDbpEqOUWDmMP02BaTKvh1FXMK8S09vTv9n+y+qjorn+uVoiiExj1YCION13jIxTWWZ9IdNl2yYqRdSextKsMM//W6q8fUAcN6w4yP2Ls5w+uw1VuVdHnBSXc9WCq4nVcZI40IiBtXUHsrmEFk75580DPiWfyLuQfyCA5Swp5N4x9C3+QBdudvLTMkLtKAV4Tr8YLL+htZ5kA0sM0ag10iRJmM6CPEaC0ugnAjOYHTxPn/N7A1yE8vumtWUGlaPxnTq4i014985uTuseLaAy1vPDMlzyvgdMwHeZix2L3RDEUpazVUOPpplaxHqGVUztql9JNCER8cN2CWj6nYqTYGt6FDHWnZltkX3zgZmmRG0+bTkny/LzpajMQOPHwsELEA8fOx09xnc5xnRaP58iGwBZwV2obdFtvBNf3l47FBfgxsNeyUSxFqvHZNzxTG0sNAP6MwAya1jNdJy6ND1390D37bRCanIGhx46m2YBHfD7vDrtdqOxis04+ESkcb82ZHMwNKBWwQ2+7vPyjzyPgWcePbLS4h/T4hgojTjDw4vgh16POY2VkAHYUArH7G6GkmnNuu97x7RRAFeoTp/xiCDJAopxoKd8ngcRkPg54Z4WCyLmEo+DtIBIz4nFIYIwxYAfh9ifpvZoHIIkDbNiSLYxmvMRQvkys/qJYt6gGNa7ZzmAviQFzUGQvm4SLFm8LV/IANoQtclzBXfVO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(366004)(376002)(136003)(396003)(451199018)(83380400001)(36756003)(38100700002)(316002)(54906003)(478600001)(966005)(2616005)(186003)(6506007)(6512007)(6666004)(6486002)(8676002)(7416002)(44832011)(5660300002)(41300700001)(8936002)(66476007)(4326008)(86362001)(66946007)(2906002)(6916009)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anIwZkRkQWhHTGE2bkppUmhDSjA5cVFCYmU4T0VVNnZURk90VDVwb2laTTB4?=
 =?utf-8?B?OVZtOWQxbU5lQWw3b2hKa1A1T1lINEZFTTg3NGN0YnVmc0E3ZXM4RlJYbWRu?=
 =?utf-8?B?STVnS1RkTFdNWFVadmk1WnhWdHp4UndzenRFUTIzaGI0d2RlWHUxVTYrdloy?=
 =?utf-8?B?ZVJFNGpVcGE5c3N5MGlWdC9hbjFlZGFoa3dUN2kvL3QzZEloOXJoRnBWc2Fs?=
 =?utf-8?B?aWhBNlEvNlYrSERYVjc3V1QvQ1dlZDVLM1RhbnV4dUs3OGY0VkZsdG0xQTU3?=
 =?utf-8?B?T1UyUmd0QTExM0lqNFVoTkxNdzlwUmRWdFZ1bmtOVWt5Y05KNG1JUHVpd3ZL?=
 =?utf-8?B?aHhQTnlYdGV6enJqdXJzaFZsUDZoRG4xRVNqcEIxeHAxNVZ2NVJpeHRWVHRl?=
 =?utf-8?B?aiszbkhoVXo0c3MzeXY3T2dlaVRqeHIwNktGbmd1bzZUc0ZLMTZaS01RdEY0?=
 =?utf-8?B?Mkg3MEE2dFJtQ0tVM2ZjS3cvZFhyNllYeFd6OGk5SnFVUlhGQ3pVSHkwQWxJ?=
 =?utf-8?B?dENJamhxbjNUMVlvQjdlQmtnWUR1R3ZvVm5CbFRnR1BoVEJ6SXlrY1QvNjMw?=
 =?utf-8?B?dG9pSUlBR204c1dmeEM5SVRtVm1QNkE5RHA2QVNMNy9BWTBteFNNb2tVTWsx?=
 =?utf-8?B?TWNYM3JCM2haVGM3Vml6bzR3czd4OHNWd3M3QWU5ZXlISGxqU0RvdnJKckpC?=
 =?utf-8?B?OUpRSDhmUUZYd3A4WTZMR2ZjVFJUWTRBVkRuRnVJaksrd2h2R3J0NVVqZ3pi?=
 =?utf-8?B?UXFDMHVvZ0tnUzhJL1JaRkpFNWt6ZUoxQmp4RldmVUpMNFRXM3dUTjZ0QWYw?=
 =?utf-8?B?RFlpcFgrblhHN1c0WHZYRlZWb0lQRDc2Qm90RjNwVG1OYnNXSHBBNS9VakFy?=
 =?utf-8?B?dkwrV1lGRVMyWE9mcCtYeDV6bTRwZURsR1BLWVhrb3hEV3YvZm50czl2OFQz?=
 =?utf-8?B?REFvbG1UZDN1ckFJaUhiNThZOHpvM3ZOK3pLNjN1MnEza3NmcXZ5WHpTcS8x?=
 =?utf-8?B?bXRINlAvVm9OUEt6RnlwZU1hSDFBRUZUQ3ljdmJscnZ2Yng0ZzRBT2c1R2Rs?=
 =?utf-8?B?MUZZa2t5YmJKM3p2VjJ2QnlCenRxMWtROVNZQmlXd1cveVI2VGxUZWVST3kx?=
 =?utf-8?B?bUJFM3pNNXoyTUUyVTBjci9IeEUwSHhHYm1tc21IL2FlR050YkxFNWJmaGF1?=
 =?utf-8?B?S0lPeGNLbS9rNSt4cW4vcG4zMzdrRFRwQktmR3JvU240YjBwbjBYUmFxNGFF?=
 =?utf-8?B?SGIwSi81ZjUwQVpub0tXa0dYOHJ1L3VoOWpRNEVtQUpFZjA0Q0VyMU4yWDVS?=
 =?utf-8?B?VjE1UDJrRVVVSmFDclVqN0xGdks3aFUwUlEvajBmT2VLSEt0NXVMRFlKM0FJ?=
 =?utf-8?B?bkJYVGxmS2FNVFgrU0M5a1o1VWhoS0VydU85dlNwamo5RGx1ZXNTYW53Mk5k?=
 =?utf-8?B?bUZWZUZISXlFczNLQlRnY09OKzNLUjBWbm96dENYMUxoZlAxNXBLRXlDSTZ1?=
 =?utf-8?B?K3dxb2IzNkppUkJxQisyNmxhTjBQdXFoL1JBcjZYelJGb29QbFFkTXpjaVNS?=
 =?utf-8?B?S3FBTjFYL202Zjl2Ni9WOGpqM1V1NjhCdzV3VEIrYkIyWHFTeThoNFYvRzNN?=
 =?utf-8?B?VmUyaDFPUktrWk1IbFkxVTBRV05DU0k0YjM1b2tMZVdOaU0rcVZtOHFzMTZF?=
 =?utf-8?B?cXdSRTRqNTY1Q3BYSUdNN0tDTjVNRVhIbVQrOUF0MzhMOS9zWXZWZGMrMnJM?=
 =?utf-8?B?di9kRHJHOUVIZGVtSnBzQnoxQ3pXZC9QNHF2cXVlSnI5elhYYUFBRXRzdTd5?=
 =?utf-8?B?RzI0YjgwNUcvMzEzMExxVnZFVWxVNThnS05IK2ZoU1MwWVFMY0JDNDNDVDky?=
 =?utf-8?B?bFBkN0RqRU51eTFxajRuOWprdU1WbTVvQVBjNHZRRjRSbkdkMFRaRlFMTFcv?=
 =?utf-8?B?dzh6ZFNwT2NRbmwwejIwWTdwTG5rUGxES1hDakUrVm1WbzRCWG9adXRWVmVC?=
 =?utf-8?B?L1pGcWRqN3FZcFR0ZkZqd09NOUU3NmhzMXkzcHhDZVR4TjdkaDViTHoxcWsw?=
 =?utf-8?B?SEZYSENYOWtiaVdIWVVGb1pVRkxjbThyYjMwYnpBV1IzQXFrMXY2RndKQXI3?=
 =?utf-8?B?QXNDeUFNMmhQejBqenJPbytCdVkwbUY5azlzdEF4d25UcDFvV01GcldOS0F5?=
 =?utf-8?B?R0lGZ2w0ZURjdFdCNnRoT2V2NjJYelcwWnpZNWFsTUF4VnFYUDEreHpLWXpP?=
 =?utf-8?B?YVM3RUwxS040ZmMvM3Z4WVUvV3FRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1282c72e-38d8-402f-38f5-08db20bc3bdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:35:03.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE7S7e2/VSky1izBGGWe1ducfa5bUcRhBRTOJzyqf0d8i5Bzj2jpyXCNkw6cgbi4m62GxrfGj+N6gHpYR8FRJxTSXk6OSMFW3vaOv2zOcjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5188
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:08:29AM +0900, Leesoo Ahn wrote:
> 
> 
> On 23. 3. 9. 22:40, Simon Horman wrote:
> > On Thu, Mar 09, 2023 at 01:26:18AM +0900, Leesoo Ahn wrote:
> > > The current codebase calls the function no matter net device has XDP
> > > programs or not. So the finalize function is being called everytime when RX
> > > bottom-half in progress. It needs a few machine instructions for nothing
> > > in the case that XDP programs are not attached at all.
> > > 
> > > Lets it call the function on a condition that if xdp_status variable has
> > > not zero value. That means XDP programs are attached to the net device
> > > and it should be finalized based on the variable.
> > > 
> > > The following instructions show that it's better than calling the function
> > > unconditionally.
> > > 
> > >    0.31 │6b8:   ldr     w0, [sp, #196]
> > >         │    ┌──cbz     w0, 6cc
> > >         │    │  mov     x1, x0
> > >         │    │  mov     x0, x27
> > >         │    │→ bl     stmmac_finalize_xdp_rx
> > >         │6cc:└─→ldr    x1, [sp, #176]
> > > 
> > > with 'if (xdp_status)' statement, jump to '6cc' label if xdp_status has
> > > zero value.
> > > 
> > > Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> > Hi Leesoo,
> > 
> > I am curious to know if you considered going a step further and using
> > a static key.
> > 
> > Link: https://www.kernel.org/doc/html/latest/staging/static-keys.html
> 
> Thank you for the review.
> 
> The function must be called for only XDP_TX or XDP_REDIRECT cases.
> So using a static key doesn't look good and the commit message is not clear
> for 'why' as well.
> I think that's why you suggested for using 'static key' by the latter
> reason.

Yes, my suggestion was based on the performance optimisation
aspect of your patch.

> I will edit the message and post v2 soon.

Thanks
