Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A926C21FF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCTTyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCTTys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:54:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2131.outbound.protection.outlook.com [40.107.100.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34076E38E;
        Mon, 20 Mar 2023 12:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nw/IsA2r5WlZ3cMJPpCiFAJvptsKCLGf7gAW1h561jPYkR6ME1y/sSE9QWLJNUkzvftOA4Rkswr9N0qxcVTCM7hgrnBUmbb5a/JwPcONpmYBfGdhuKmKAqBNy8kR8rmbQEeu+Xx4pgIRxMqD2TqDRsss4RXkWc+cFcfY3z737owGPy0FZvFaTbJ9iFX/FIUkGzFf97FnjrnHhifTJ06GmgMoZoxDYcT6znEnEoskP0tpYGqFDrJDaQTLMg4olekTn/pdKg22PGTGrzQ0A9Y6LaS5EEFc0px1bukHWxLc8e77naTOHcsZf8j0Xg+oCJbonLgkBb4/wOZpJ4DelWbpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfrW1NdjstnmDjRB9vP2G9u2+cXi21aBKAkl64Euhxs=;
 b=BXadN3IEkfz50YHzrFZozRg1oQhAwrolUqr3KGqL9mbumAwCCWMTf1J09XTKObWmO4Jr7tknk3k5y3uQQKzzEKm0SegMf3mO/7V9cjR8r0umsPPAu9CU6I6HxMNkGwnDUdwhmWk9wAIi92v5Oa3K0CzkO1G/uO3RfmsH3pREmwfmBJhzQxdnHK+7x2P0KpNjN5ORasMqszXudo7EeuiflajEpOI/d31k3rsMUVE8u4oKk3NVyvnsJscovc1eL1Pv7LpQBxVAKnqPD8MUi3RzlW9PkpEAASRCdhydy4glQ8X0xhCTR691x++Op3R7a+fBXtZK8EVP6nGSAeTNJI/11Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfrW1NdjstnmDjRB9vP2G9u2+cXi21aBKAkl64Euhxs=;
 b=l0gvkb9utp7SyBIcaYHxJxwlnSt4SE/P8G1nEwAI2sxOSvyVtJpaHtb3zSgbJvjQi4wyIa1TcoFyzAbPMhNZaFcxabdtqeDBA3JzLxvc0uklMHowjYT2GuMTErlCHXUfSzgtMJHcYoIzRlca8ZB0bVb4IQb/GN26iConiFKuNyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6108.namprd13.prod.outlook.com (2603:10b6:510:29b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:54:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:54:27 +0000
Date:   Mon, 20 Mar 2023 20:54:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: dsa: b53: mmap: add more BCM63xx SoCs
Message-ID: <ZBi56yI4CnY2AAtH@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-3-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320155024.164523-3-noltari@gmail.com>
X-ClientProxiedBy: AM0PR01CA0124.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bcd7f7b-1221-41cd-926c-08db297ce93c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUGf/lWCUNoQ9pxk8uJlsDeK5kVRe9VIDvYkY3Nvbyjce0zhkQ/OWMbk3GQamOaZ+zaB3QoQe1OzfyFNG7aeeeMZkSM437YMkIQOsEJjgh2sn08euYzzYJmLPa85cDsds2gjnRJr6R+v2uOcdF3IOaTtq3ZFtO8L3INbGpb4vX15lSWenbNuFIUKFenzyAJwQCeDZ7eFabzV3myLKB+5U6qq2ivhyUjFImlQbFo0Ah9MppENtXL2KMjF9vtI6IZnoQyAr17f//OQaOD/BIXMNvZ7BsO3YOMjiO+AnxgLRIJzLbJeFKV0m0OBuHOXyYG8yC26MZlNDXkiuUMs4HexQ47tnzNoVHkGYa8nvw59nYgM0uZ4QTQjbho49nWsSlE7mCkeFBQUy5IBfLqRqXJLQgwUya8uyjvgC1R4Zs+cQ2xx9epyQM54ubjSBUhC/tKd9wcmoFpiChm0OjEaN3mwt5yNksWhjckgpxQAV8TFTw73IOHkoyk8CMoQfLqh3EFgOoEdW8rBBsW38QiyUpfhhniImNQjKn0PDHZfd2RM3dfyBweUg6fJxUuF/1qKWY3+ycR5tjFukOeWhh4r8U+fvmWCkwrDW65+kLUz+ybNbe8ahMrpPPgdR3f4QH9M5OuZ3AFhYy7ok1KxOrqOYAZkQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(4636009)(376002)(396003)(136003)(346002)(39840400004)(366004)(451199018)(86362001)(38100700002)(316002)(44832011)(66946007)(8676002)(7416002)(5660300002)(36756003)(66556008)(4326008)(6916009)(41300700001)(66476007)(8936002)(2906002)(478600001)(2616005)(6666004)(6512007)(6506007)(186003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEtqV3ZWWFg4WklPRkRKSmcxRkdjQ0hTWVJ3UGlRL0NwU1hFNzFUckFBbDRL?=
 =?utf-8?B?WTlKUzErNXk3S1U4OHI2WU9OMEY5a3lFQlBXVTJ2TFg2VzdSU2VmdFRKSnZI?=
 =?utf-8?B?b0ZWQ2ppTU50dEkvT3dCbHJNd2FkSHc2cUxJVXZmTjZYWkhPenFBbUJvY3Jn?=
 =?utf-8?B?bUFLK2Z0L21VRUttRm9LUWRhQlkraFZpREJkMTk1ZHpkRnBLaFRiZjVjZFIx?=
 =?utf-8?B?a2h4aDFZMG12TW9GaDJlbWk2cC9ONmlmNEhSc1VQZmdmZEF1eUNPM29LM1Bw?=
 =?utf-8?B?ZllOYWJkRU1XaTVFc0lWR3R0NWtTMm9ON2RQMnJ5RWt0dkt6YVN0RnRLK1ZI?=
 =?utf-8?B?NmlmY2xrRzQvTkcyZnMwdEU2eHQvWlFTQWNiVWRHb0lwZ3ZFTnF4U3pBdVcr?=
 =?utf-8?B?YXdsZHZ3eVBQcUZySllOWWJITVpxb21zSDFEWk8wSFZhRlpyQ0ZUb05HUm0z?=
 =?utf-8?B?dWViSm0xUHN1d0lGbG5vRkJhKzhqclZaNDNkdHhGUG1IVFE4REliL3FYdkhC?=
 =?utf-8?B?eU1Zd1RDRmtQYWRCRWdRQ1hHM2U1VUloZ1BrSFlVYnFFa1lQKzg1MzA0Q0Mv?=
 =?utf-8?B?NDhoVkRoZkhoNWdCZlZZK0EvOGpvcFFRS1ZiQkRySzgvNE51WVc3SDRFT3Rj?=
 =?utf-8?B?ZXVveDlpakpkamhNbFV0Mzg2S2ZvdVJ3a1ZwMm9iTURqMDBwdFdFRHVVMTUr?=
 =?utf-8?B?MXFkcW8vanQ2b2llcDhuSzVzZDdHRXBQcVBmT2NaN014czFaV0xQSmZQQ3lE?=
 =?utf-8?B?N3ZiMFJ6VXpJV2JJMnQ0NHJIWVU3bUxzN0dNUVpjcDI1cTJJb1pKa1c4YXNz?=
 =?utf-8?B?T2pBSFdiZTV6ZG9BZTVycmluYWRoSUVWZUZkUzVpa0E0MnVoYm95SWQxZHUw?=
 =?utf-8?B?NUhnbUlhNXZPYXhPMDhPbE9TRzA2M21OYUpZdlloTldOcUZyODNCOXJ6Q1hv?=
 =?utf-8?B?Ym5YaGMxVWtTWGdNYXRyWU43OGhtakRHdmhmTEpWcmpwcGR0THJhZmRYejR0?=
 =?utf-8?B?MUx1Lzg0dHRjNUJnTFdPQWVnYnpoV0p3b0pGY29SdUFqQnVwM0lwNGRKdmxE?=
 =?utf-8?B?RjB2UFRyanYwZGNycGpaN3RuemIrVXFncGFQb2hMN3hRWm50eHNYbnArL0l5?=
 =?utf-8?B?YjhtQjV4V3R5S0xYTHJ1bis1OWZOcGNKKzgxNEpJalZoRm9XeEtCRlViZ3BH?=
 =?utf-8?B?V1dPdEJ3elF4M2M1dm9wZ214SGcxOHcvNWRMbFNLeDNHdjlOSUxCVUJlTXFp?=
 =?utf-8?B?VGU3WGFVSit1eEF6dFFvYkJqRkNraWl5bzF1SHZFZVVlYTlJNEVFVFR2Tmla?=
 =?utf-8?B?QWxDS2ZlN2NxYUsyMzdGOGs2eHM5RzdOR05JV0hsYXdKdmZlM2ptZndhNm5a?=
 =?utf-8?B?STRHMG9qNTFDdTFxbkxTTDlPdEJBQ05WM1plSWsvcXVsQlE3Zk5KOHE4bnNl?=
 =?utf-8?B?UThmS2s3ZjRtT3VFM0lMbHpLT1dENmtHMzBNRk9jMXhWWVk3ZnEyU3NCdVVn?=
 =?utf-8?B?aXlFUDgzZnAwV3A2bWZEZEZFVzdIakpxKzB0bGdrN0thdlI2dGl4QnpCd1ZM?=
 =?utf-8?B?TkxYOC9lblBGbDFzK3hVV3I2RVJsenZoM25OQUd2eFRXT2dHdFpmUjZFR2hN?=
 =?utf-8?B?R0RrQ0dKOFNVTWpJV2lRQ210b1djK2FBdStzalpFdlFsSEU0SGx0TGFzemta?=
 =?utf-8?B?M1d1aVZTcjRNZHhrY2o0MXlKVFFaT05abDBIK09YckxVN1JXUmpYNCt3MkpI?=
 =?utf-8?B?UElLZnNhd0ZoUEhOUmUrR3FzRSt1a2JCL0R6dzI4WGdxeERMVTc2Qjk4UnBp?=
 =?utf-8?B?cURoVlg5U3Zpb0dSMzY0VTNna3RBc2ZrNTBPaXcxTDYyd2N0aTU1R2piTGVK?=
 =?utf-8?B?Sk5KaGgrMHVjN3NBS1E4dUxoQThjdzZET0txRGpmN0tGL2VGai9SVU5pRmhu?=
 =?utf-8?B?NFlYNlU3MVNKbng5ci9VOWlXaklFa3FaN04wMEYwdVc0S3lzc1dTbVZ0b1M2?=
 =?utf-8?B?SzNmSm1Idk00Wkxka0NjK2czcC8vZlh6NXhBallXdXRYWFNWcnc3dkVEM1FU?=
 =?utf-8?B?REZ3Wng2OTFBODB1eThyRE14VGRCc0hGaldPeEdQQ2N1c0szTW5VK0tkSDB3?=
 =?utf-8?B?YjF2TWwwYW9tMHE2cXE3bGNwTXl2UTZybDROZWhwbENVQWZiUkxtMitRelM4?=
 =?utf-8?B?RW9LeHl6TFpsMG94MGNya21DOTFjMU8yU1A5QStOK0tqMG56WEh6amQwdVV0?=
 =?utf-8?B?U0YxQktMVjkxLy9zZGsxRzZsS1pRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcd7f7b-1221-41cd-926c-08db297ce93c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:54:27.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQwB51/8wXn1WoHrKmg1qBE+8T5iTgsSt2dfInZ1XcswNgXxJ6EDL/JHwKKlO9q1CspoprzCkabj5VmPJ8RbFvZvo3xOgpeWpdw9xcojnYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6108
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:50:22PM +0100, Álvaro Fernández Rojas wrote:
> BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> index 70887e0aece3..464c77e10f60 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -331,8 +331,11 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
>  
>  static const struct of_device_id b53_mmap_of_table[] = {
>  	{ .compatible = "brcm,bcm3384-switch" },
> +	{ .compatible = "brcm,bcm6318-switch" },
>  	{ .compatible = "brcm,bcm6328-switch" },
> +	{ .compatible = "brcm,bcm6362-switch" },
>  	{ .compatible = "brcm,bcm6368-switch" },
> +	{ .compatible = "brcm,bcm63268-switch" },

This patch adds support to this driver for "brcm,bcm63268-switch".
However, less I am mistaken, this support doesn't work without
patches 3/4 and 4/4 of this series.

I think it would be better to re-range this series so
that support for "brcm,bcm63268-switch" works when it is
added to/enabled in the driver.

>  	{ .compatible = "brcm,bcm63xx-switch" },
>  	{ /* sentinel */ },
>  };
> -- 
> 2.30.2
> 
