Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0EA6C2224
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCTUCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjCTUCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:02:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D964E28E68;
        Mon, 20 Mar 2023 13:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyfrdYP+BXvEutNZyVtkyriEF3LNg0s+JsDoAjtzBh0sHkwmGS+UzRrVSx8Y329Rt19VX1txEYyxDWba93wHVzyxHZiTdMk92HWDpLfLCqDy9tuEeNj0RgnLtcGK7bpMDZ4tvEx+8spiXrOyyJpmpYzdykGDyoqvkgH4Y+OEOo2N21KT0cK3Sgtkf87jie1m5nLU9ZETMufF4euaaYaqZ+22+tfKxq8pY1YU5+7dGNFwyOOjhXl1pdm5GWrBha8Y3K4rpZX2Qqjj6hVInpyZpGKW+0PSLL/hvvYve1zBzqO9gF7TP5gg1BVi4xNTutCey5BhfwjINlUztd2V1Em0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkMQd3YVqtuTkYlF0z/M7AXMbX4JuOdH4jTwM//kYMI=;
 b=Tkz+KKH/8ht38TRpTU0p+arrnpdqzQETADTb0Oj0NU/FP4fVt0KDl+jAJ2h7pBmfhRpL89vuu2Vt9FAJRMo+XA0NiDOUdxLzjHxDHHeTxikEoTcWQtKg88q/gLM3n1YHgrFL2HOdq1ouvVU+KEz1im+QEZ0JjDPBi9bvAlBgBzLlVZ+YHBs0rXC/FUnN7LxrtRauZZzXaFp3A+KPKTYyYndNDvhjN7jljuQh90xIVPdsHzjQl/iWE2315U1E16qZ4I3viunlCTSkOo4Cz0Xr11XDS4bws/xc5lwAXEg5076l3wfPRgGIMUbxqGHZN47piYeCSj4e+xj4Qk3WyZOsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkMQd3YVqtuTkYlF0z/M7AXMbX4JuOdH4jTwM//kYMI=;
 b=uVHDdbAB2w4UHKIlbynJj5N2b5143HEiy5esDxlZI+3vqAer8z7l95ZDcjSzRopjFpD8YlnUF6sPjw1obesUTJPO6lbT2CMi7hVMWj5tRJxr5alv5x1s6sLaZoDB9nlvrAwApYRe+rv98WnRRize8uPIkfcTiYX0RrftB28hDcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5220.namprd13.prod.outlook.com (2603:10b6:610:f4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 20:01:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 20:01:36 +0000
Date:   Mon, 20 Mar 2023 21:01:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: b53: mmap: allow passing a chip ID
Message-ID: <ZBi7maQHCUMhLA+5@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-4-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320155024.164523-4-noltari@gmail.com>
X-ClientProxiedBy: AS4P190CA0041.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5220:EE_
X-MS-Office365-Filtering-Correlation-Id: ce27704a-4500-45b8-953e-08db297de934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u3oOGwHdAruX1ilu+tYbmnpuAq6hjMMAVltDGtLURTcz5f36WhWRVMvXNhVHQYV+F5EIR3dy6WIB/4vrMuana9BoIRFucLWHkRLvDDFk55/iHPDPVdPQt/D33d62rkpETpyXem4Yh5HLehf/ZIH3aRBKREJVe4Ddm7dV4llgyBvJnybowjxlD+PUHB896wan7YSGeLhh5h67OOdxZhh4zo4TobbZnKeX9zNEoiJ1rQbvTfczNIeW/6P+QYcn1Cp9Qasa94E+5Bu0s5JrBqE9D9K95U6/jESqmWLA0R1BlhXLpQBa9vDtJsqA8HwRWNlB4qSBcdkac+MLJ3LfYXdTmkUStkrRkPLKq4X+N0kgSB4+6SJGcngkL88LL1rKJNVK6hZj0ZWhZVmRaWF2Zjk/n8BtXDqR1qHamFplMT6dop3tZPBw4XgMx4VBWliPZN2Z8idpENxogY88Rw4UG8S6+jtQXN7NQZ2DbncaChdD+OXtvoEUTcPSSF9g77N+hWq8wlwjeHu6g4Jzs3OBW/E0CYZExlJuAkxPGJivi0TpRWfNoRWlVU0/HMHF1OqKqX75HEt5t8ue9fFYSGTf/ZqHdPUNAkvosI6SDpHKRR6dF7k9Q+q4U3ZDss/LVhMjU2gpwHmuPje+zphCoUbnizeAsCmUwPFlIWgqV6BPtkVDtoRrHfJICjcqPFxpF3Fsa252qCAReqbKmLbkkXSW/V+b+UEHKWkT8UtzTee5OMVuYghA3nply8MCj/s39tz6wu0a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(451199018)(66899018)(8936002)(6916009)(8676002)(2906002)(66556008)(66946007)(44832011)(5660300002)(7416002)(4326008)(36756003)(86362001)(38100700002)(478600001)(316002)(6506007)(66476007)(6486002)(6666004)(41300700001)(186003)(83380400001)(6512007)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWUwYk5pY0JDWjIzOXF3aTgzbHBIMzl5T1dWdDBSdGhNRTBaVTNnSTJrUmpw?=
 =?utf-8?B?UUFZQU1lRFJtckZsS0VBWVFXb2dYZlZ0cTM0V3JUY0MydTBobDFtZG1obHVt?=
 =?utf-8?B?SXd4cTkvalRNSnBscmF0Y2Rvby9wOG9OQXNvZ2Z0cVJHOGxuOFpNTXF4RjV5?=
 =?utf-8?B?T3NlSnpoMHFoeFdzbG82SE5wVERMTWR6VzFROEorMWsvT2ZQY041cGI0ZXNP?=
 =?utf-8?B?VWptNGN2VnJ6MVV1V0FXT0hSbjFZTzErTnpIT2l4YlBibFJBdHVXcE9wcWhG?=
 =?utf-8?B?amJXbTBKYy9Pa2NrN3B1bEZGMWd4OEgrLzZUVC8ybVJUbHNFVmovZXZSazU1?=
 =?utf-8?B?MjFXanpub1B5dktWRFluTnBWWVlUUlBYejdLQkZIMUhES0NKYWhsY0x5Q3g4?=
 =?utf-8?B?elNWSjBPZHNKQXRlNDNrc1RlVU8xcExpQUVadGU3ZmxUZk9FZTBld2xHZ1c4?=
 =?utf-8?B?QnBTVDlId0FKYk9DOHNGNzBhSE1oZ0Q3ZzU2MEwzTlZDVFpiTmNrS2ovaG0w?=
 =?utf-8?B?NnNQTnFORFhxVlQ5ek5iQ2JvWGx2T0I1WnRXZHhRSWtxOWtnUGViUDhtK1JJ?=
 =?utf-8?B?ZFVpMHFZYmNPZGdvL1NLTTdCNThxbkJoTGN0UWd1ZDRSZUJFRjByb1p1dEVC?=
 =?utf-8?B?cjlmaDFpd203eVN4VmYzS1VGYUZzbG1kOVhiK1dHN241cFA1MnRpSG1aWXhB?=
 =?utf-8?B?eURwb09iNlhsRkIwck1ITTBTMWlBTDdkSjg0K1RMU1NoRndueW1DdFFvZzQx?=
 =?utf-8?B?eFYwbG8wc2tYeHFVM1FGSVFobVV1cHhYZE9sdTh3MFR1RGtaM3JOZGRLYXAr?=
 =?utf-8?B?NGgwcXFxTlRsSzFsdjNVcVpwS3p5MGpUM20rNXpvcFdnN3hqRkhFMmdpUVRk?=
 =?utf-8?B?bmpkS1RCRlF4bE5SbzN2WFc3UmJidktUYWtseHdobGdXRDhscVBmc202S1Bu?=
 =?utf-8?B?dGk4bURZZGdwMU5OektnbmRZeDlsMmJza0JtdE5pa0dLeDRrdE5vNzhPakxt?=
 =?utf-8?B?a2ZKVVNaaUxjMzd3M2FOM1lNOUt3K3p6K0ZIU3Iyc3pTMFg0Wm9zSTZvVFEw?=
 =?utf-8?B?cEFLSE9OSWRaMDM5TFdxUlZ0dk9OUzBxWmJOanRMcHJ0V0d0aWlpVjQrVjYy?=
 =?utf-8?B?WmZwNnhrMUFLWmxIQlpEbGhZYlRTZjFoM3h3WEZIVHBaMW1DTDFmR0dVN2JX?=
 =?utf-8?B?cjBYaHRiZjM2MGd4Q0hFMHJpVlYydko3UXdhVnVzeGJaWU9lbTdhMkxkR2lo?=
 =?utf-8?B?V2Z4cHE2VUtndWNHOCtZcFplZ3owMUJDRUFxb25FUHU4eThsRDYrNzkyZ0J5?=
 =?utf-8?B?SUg5ejZYc2pxWWllZm42alZobGFDcnRqcDlkeGtFdmF5NzJsQkZ3RWViLzNP?=
 =?utf-8?B?OHVxR2FMU3BzT2RUK3dDYXFhalZuS09GeEE5QUxWdUZDSTY2aWQ5MGg3UFpn?=
 =?utf-8?B?aXJyY3ZnUGxMU2VQaTZ5dU9nYVRlOWE0S2NVci9XdzJuV3gwb0NiQ0svMnNE?=
 =?utf-8?B?cGxseVFYREdkTVVvNno1SWtCcHpBYitaTzd2RDFpRWFCYlRiOTE2T1MvV0Q5?=
 =?utf-8?B?Z3lGdWRPNVYrMFliUCsrWWdMbi9XZ2NwMFkrOGR4S01iM2tTOFI5VGpNS0Y3?=
 =?utf-8?B?NEZNWlQ0a2hUUWY2ZTBLc2lzcGRrMytPQ3c3cS9VdkNZUHUzV1NSeHRWTXlF?=
 =?utf-8?B?ZGZOSThsTVNiWW5Kam5lR21nN0djNit2Q1gyMFJKdm1kS1pxZWZHc0ZCS0pK?=
 =?utf-8?B?d29YajRRYjVOUUhNcmRBS1VucituSTdpSDVnek1IU2toMDVNTFlKZGJ6TEdt?=
 =?utf-8?B?SUtDZ1Azdmt1SVllaFFsemhKS3dIclhPMEZzRXU0SFd5TlY2RGZuU2c3RzFC?=
 =?utf-8?B?V1RBYnFDdFpYQ0NTYWRBb2VTeVUxL3ArbjhlODkrSVc2YXhFUi9ranBtdGkx?=
 =?utf-8?B?dUluUFB3WUdTMFBUeWdQa0UyZHhnTFJDZG4rYW05b0RpMnpFTThPaUZvZGRu?=
 =?utf-8?B?VnZhM1g2cmgwMWl2T29tYTNNeHk2bnd0ekxrdW81RkFMeGxvWnJtL3NXemwz?=
 =?utf-8?B?Q2tMTXA3cXNuK1FrbTlSR1Ftd3dtNjhnNEp1d1E0SHRCYU1LY2xGSkJEZmlR?=
 =?utf-8?B?NkVKc0lNM0ZzRlVTZkxVc0h0VFAwLzhXYWxmMmtvWWZpSjY5eUJWNkFLY29G?=
 =?utf-8?B?VFNVdjJGblVtWlI3dEdmS1JWNTZqSU9ua1hkZFkzWHduVGEyUkFFYitUb1NE?=
 =?utf-8?B?RXFCQ3lreHlsN0JGWHNVQ0J3a05nPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce27704a-4500-45b8-953e-08db297de934
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 20:01:36.6369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6KskxLJleJruPgbuVuvJBvkTcztzhfyce0gLA3DnpkNpe8m/Y+WjiscD+mrpmXH0YLMPdySfd2ik4MMT22EbIIAFyLgOMZqNZJ9UQSAepc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5220
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:50:23PM +0100, Álvaro Fernández Rojas wrote:
> BCM63268 SoCs require a special handling for their RGMIIs, so we should be
> able to identify them as a special BCM63xx switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c | 32 +++++++++++++++++++++++---------
>  drivers/net/dsa/b53/b53_priv.h |  9 ++++++++-
>  2 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> index 464c77e10f60..706df04b6cee 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -248,7 +248,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
>  		return -ENOMEM;
>  
>  	pdata->regs = mem;
> -	pdata->chip_id = BCM63XX_DEVICE_ID;
> +	pdata->chip_id = (u32)device_get_match_data(dev);

make W=1 with gcc-12 tells me:

drivers/net/dsa/b53/b53_mmap.c: In function 'b53_mmap_probe_of':
drivers/net/dsa/b53/b53_mmap.c:251:26: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
  251 |         pdata->chip_id = (u32)device_get_match_data(dev);

I don't like casts much, but looking in b53_srab.c I see what appears to be
a solution to this problem:

	 pdata->chip_id = (u32)(unsigned long)of_id->data;

>  	pdata->big_endian = of_property_read_bool(np, "big-endian");
>  
>  	of_ports = of_get_child_by_name(np, "ports");
> @@ -330,14 +330,28 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
>  }
>  
>  static const struct of_device_id b53_mmap_of_table[] = {
> -	{ .compatible = "brcm,bcm3384-switch" },
> -	{ .compatible = "brcm,bcm6318-switch" },
> -	{ .compatible = "brcm,bcm6328-switch" },
> -	{ .compatible = "brcm,bcm6362-switch" },
> -	{ .compatible = "brcm,bcm6368-switch" },
> -	{ .compatible = "brcm,bcm63268-switch" },
> -	{ .compatible = "brcm,bcm63xx-switch" },
> -	{ /* sentinel */ },
> +	{
> +		.compatible = "brcm,bcm3384-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm6318-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm6328-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm6362-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm6368-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm63268-switch",
> +		.data = (void *)BCM63268_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm63xx-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, { /* sentinel */ }

This boilerplate doesn't seem ideal.
But it does seem to follow other examples in drivers/net/dsa/

FWIIW, I might have used of_device_is_compatible() without .data.
Or only provided data for the exception case(s) and used something like this.
(*completely untested*!)

	pdata->chip_id = (u32)(unsigned long)of_id->data ? : BCM63XX_DEVICE_ID;

>  };
>  MODULE_DEVICE_TABLE(of, b53_mmap_of_table);
>  
> diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
> index 4cf9f540696e..a689a6950189 100644
> --- a/drivers/net/dsa/b53/b53_priv.h
> +++ b/drivers/net/dsa/b53/b53_priv.h
> @@ -70,6 +70,7 @@ enum {
>  	BCM53125_DEVICE_ID = 0x53125,
>  	BCM53128_DEVICE_ID = 0x53128,
>  	BCM63XX_DEVICE_ID = 0x6300,
> +	BCM63268_DEVICE_ID = 0x63268,
>  	BCM53010_DEVICE_ID = 0x53010,
>  	BCM53011_DEVICE_ID = 0x53011,
>  	BCM53012_DEVICE_ID = 0x53012,
> @@ -191,7 +192,13 @@ static inline int is531x5(struct b53_device *dev)
>  
>  static inline int is63xx(struct b53_device *dev)
>  {
> -	return dev->chip_id == BCM63XX_DEVICE_ID;
> +	return dev->chip_id == BCM63XX_DEVICE_ID ||
> +		dev->chip_id == BCM63268_DEVICE_ID;
> +}
> +
> +static inline int is63268(struct b53_device *dev)
> +{
> +	return dev->chip_id == BCM63268_DEVICE_ID;
>  }
>  
>  static inline int is5301x(struct b53_device *dev)
> -- 
> 2.30.2
> 
