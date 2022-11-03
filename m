Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD45618832
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiKCTHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKCTHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:07:19 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC771C919;
        Thu,  3 Nov 2022 12:07:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtnlcgcH8BEJ88kcVakJ80eNYNAZwpHfkxnRpwlWZPURoh1sfqq2bel10Vf9O3veFsfJ4E6/CWmaFxsSMS7hiUvRmNPdxlZnPqoxntoBlk0sNJ0LYG+XNVkaAmO07EsqLRM6oYsbO1adf/tFHkNzIFMgomfk8FbZBEanMU3TDLooqZ1/kNt5G9z8+w0RyunMYHvT4YFzCwzZI6UwZ/fRWOO1t6frd4dGdmgmGgGRwnvGZRRzo7r68fHso9totE4NHYwJMgHHfFEpSQkYFjsFQ8jVodJevrl4u2TbVR4PwywDEOOwm1DkrTzuRwap8eBRD2SdOgan0u0Z4FHWHZrP8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63vOloDgoOkq7GvtJQjCA45p3V5uvPt2kBFLRl1OzhA=;
 b=XSVf5dmQZVBLNxBzUXJLION2tOVS7zfcJTgFD/Yye65PIudhgqFuPdatKJET5HDeF9SHPoIA2KHDOBrJ5tDdR/I2/J9lPYx2lJNtophavS5FdCCF/w/ixit/pLhgtr4F7j48ZKDKWE+mKxfQRgzl2Yk9VWZ9ydUPhySechTsyTWN0ECUvLzBdTnApzJ46Q3Ai4yvMez8AYLIHi0/lIjFcu/2lektKmiEFvgQ7tOOFw/mFGYeSqXRkH7NCVHShk/crMxVqK/nNwloSEmjoweU0Nyc2FdRlWMs2cm9IMTIRzRCjSvGjbdoXl+VuVdXS9TasuBMt/LXv/zU6VYlDiLqZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63vOloDgoOkq7GvtJQjCA45p3V5uvPt2kBFLRl1OzhA=;
 b=nGuVAzbO6+Hphn/z/TpstJKLo/AnnHN+jI/7IvdxEFnqpbhmm9uxnDn8ayL4j3f6PIaL94H/L6HcXhF60w/waI/zKg2xw9yziXHA1z0vl3DIhPO9mOPDcak4OOlYq2McsCF7+v1DZ/0Y00XCHypzefLGUPwlteDb3kCokoTgdjKSfTl7u5Y/jYPwUmRcV3Zk0Qeo1xf5l+f3gISKbwbimkXF0C6S8s0jibO7IzDkkRwFgDMZrgti1aM/q1jTF4qcG5y6Mvs/eiV+uAjOZvKTmA0L4kJymLR6k7rimkFS7x/5jBW/fp6unD6RP9clpDJgnsk4ioPMqp/oAHYbvTXgrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB9PR03MB8397.eurprd03.prod.outlook.com (2603:10a6:10:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 19:07:14 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 19:07:14 +0000
Message-ID: <00d3b2e3-6c93-0e48-e87b-ebd9c6574e00@seco.com>
Date:   Thu, 3 Nov 2022 15:07:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] net: fman: Unregister ethernet device on removal
Content-Language: en-US
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>, linux-kernel@vger.kernel.org
References: <20221103182831.2248833-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221103182831.2248833-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0276.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::11) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB9PR03MB8397:EE_
X-MS-Office365-Filtering-Correlation-Id: abc85213-a7e0-4efa-9059-08dabdce9e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NnfMt66GIQxF0dVcJGVBioSbw0la2F5agTijMyyhP1U32VehUYdzBYIOpmuwaG5MoGYxeGPLqasuaH2nwjsGhQQFhF/GZntD5STRy0bILi4yrqFv1AQ4/N7WHpIV+wemRYYpttLOTXvYiqjtcwqF2m6JGeGqSHB7DvnejglrdM6P1gVQ5MjOztQXzuFRHDwNGLsL6t8ez4REPLTEue2DoUSFhMH6EKoCnQShqu0Us6XwzGrqEKGpRcvHATS98cV2jNYVB47IuejJ0GFhqPmmNlo+Y3TQ5vLwUk6kHlKhYnQAz0pLDTdCC0aVA7K8xT33641iYLXF2/jMQBkKxdSQygvkV/cq6sOel60CUt1T5FDct3fcjallEvxqu89cPufovzd6QJAKIycaq2o9Ovr56STh4MowLi33lgokrLxMcxc3dIHLF3D1+2VLF64qk+H2XU0M+NaIiJmcwZ5tvlodaP+GXOJ8VBfY/9POLKFzdrxvsWe3+ZdSzBv76b++FSelaVAsvYvJPO6/rESQsgZBugZccT/+Gh5ePlGpPwo0pTPi1wxq5oo1Y+w8VBEIWnqttNHSJi0DRefYyfu6dcYgw4YRo4l3kaHxplz6dIfVzl9wmsKuIqwamIdOI7WEqrmdfWTRQGOgrBsOxZaNxtS+FUpV8z6iJxifJt887yXBz+oZQB5u9jQqdQMQuEmSdNq37UnbnO7dChZiB2lbpLzHIpjpVIZC5TQqOReOMJVlbDW8xfBiwS5bWW6ulza0INTlj4zJDAsZEX8XtpBx/39mdv7kkDNrs9583x9KkO8OdzbH/s8/j4j5XWk+Ek/MtX7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(396003)(136003)(366004)(376002)(346002)(451199015)(38350700002)(110136005)(5660300002)(36756003)(66556008)(66946007)(8676002)(186003)(6512007)(6506007)(4326008)(2906002)(26005)(53546011)(66476007)(41300700001)(31696002)(38100700002)(316002)(8936002)(52116002)(86362001)(6666004)(44832011)(6486002)(31686004)(2616005)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFJGcWpLcVRIa2ViWDI0UWdlcUlIUUNRaE1TOUtyVWdob09HTWxORGJVQURs?=
 =?utf-8?B?MkpMdlo2d2p2ZXUzQ2E4KzNxVEcxa0g1dHJXVHNnT0pDVDJ4bEFMcUN2QmhN?=
 =?utf-8?B?UHNsQndHNXpOVDNEc2c5Nmt3akVTUHI4bVJ0Z2tmRDNYcEJzL01ZTmlCb0Rr?=
 =?utf-8?B?UFN6cEN4NmtPbXZsc2kzU1k0aFplTkFTZnJSbUNzNWV6QkFEaDRZd3dXV1Zo?=
 =?utf-8?B?TE15ejlwdXNqRzNKRGlBbmZsSzlqQ0pWNkVKM3AranlxaHFyNG5rOElvM25X?=
 =?utf-8?B?bVdRRmRNZ2Iwak1wSjMzbERyb2xlRmtHak1vaktMUXhiaUV1M05VYjdlNngw?=
 =?utf-8?B?bFM5bmRBTDFvN1Q3UDdUNHJxN0doZnoyT0xHOC8vay82YVN3SklodE5JRDdS?=
 =?utf-8?B?Q2NKL1NVWE40clpIZVhhaFJoaHNReHkwa1ZVUDBad0xmQkNPemZPOGtOU1JL?=
 =?utf-8?B?eTBWbTlTSGlWYlpIQVo1bTNndTVDR20rS3JFZmpBSmJENDVPOGNOM05YbnJ0?=
 =?utf-8?B?S2dWektyYnI5eG1pR0d6b2ZBRkQvUHg1VnI4ZGtOMzUwSWR1TUFubEw4NEYy?=
 =?utf-8?B?SUpKeVBCT2Q5SjRxeitRSVpISkRGNnBCb2ZtNlE4aWEvSml2VUhIQ3A0RVN0?=
 =?utf-8?B?enlHWWJIajlrdVRGTWxrUTd2VHEzTm9IL0hqZ1g4YmhlMXNRVHhxaFBLeWt3?=
 =?utf-8?B?cTR5YkFYS2dNS3QzQVYvZUlJRHJvS0FiR3JnT2I3VEt4ZkFvWm9RWWVoVGlS?=
 =?utf-8?B?Sm5OTVpIM0l4ZWIwei9Xc0o5MmZHVnlaVVlxWGRVM3djQWVHLzFYRVA0SFBP?=
 =?utf-8?B?dFJITHMvV3g3UW9TV3Fsc1QySUdMZlg1SUIzZ080UElpWTFNQmRBd3Q3MlI5?=
 =?utf-8?B?U0ZkTnNBOEtsZUJHcHFOekwrNk5QUSt0b1l2UVJOWWxyYkFGdGV6RzRRbVdp?=
 =?utf-8?B?WGpFUHdJU3dPWE9YdG8wK0ZmbTh5VHEveVN3TjBMVmlYZWNMNEs3em9qQmg2?=
 =?utf-8?B?WWhKYWRIZmhSRGJFbHNqV2ZmT1JJcEdOOFBTbnU4THkwNFBXbEdxWFovMTRY?=
 =?utf-8?B?RDZIaGlmNnZGY0s5SGJhWS9mUUdQNWVYNW5zaUdqaFZqbFdEdTlqZU5NWWdQ?=
 =?utf-8?B?VnpuckFTV256T25hVFBlQmJ2VUlja2NLZ3o3dlFzbFpUbUdnWm9PcWROcXY2?=
 =?utf-8?B?aWhOZFllYzJPQjlwSkNRdDdYM2dvWXRmcDhEQnBseng5aXFaMDJZOU05ZEJn?=
 =?utf-8?B?bHhnemZqcW1PWUhtNnM1c0ltR1V3dXZDQVBiN29Fa1Fiem5QR1JSSGE5ZEVZ?=
 =?utf-8?B?TWZhSjlLVG9IaldWQkRJTzV1dll5djQzLy83WmkrUmpiU0xVRDI5YWg5TmVk?=
 =?utf-8?B?RUs1UXVqWWZ2WGZJdVVHMi9tRTZYWWxueEd5TDlLUS83OEZiS09SMHRvZEFU?=
 =?utf-8?B?Y2p3dC91VDRyZVB1RkdMSjBCTDg3Y2tvRXg4c0psN3Rqb016VW9hN0kxbCtn?=
 =?utf-8?B?Nno1cmhSWVdyVnRtZ3BvRzcrZHpRUi9ZN05HbUFkWGs4WjREMDZFRjk3SXVM?=
 =?utf-8?B?Q1hHZ2RXZU9jTGZVcnZUMGtRbWdiQm1Rd1dySmtkWjd5Mng5SmNmdXAvekVM?=
 =?utf-8?B?K0xJWUtodlU0cnpFWTJjd21KMmp6RGRORlIrNkdJckdMYUc5RFZ3NVRqeWZa?=
 =?utf-8?B?RkxVTVc1WTB3VTQrT0x6M0ZDQUNvdFkxdmVxOGlCWE16M2lsMjBWWmg1Tkpp?=
 =?utf-8?B?UlZ4Q3AvaDBwYVpQbkpOYWZlaVJuNDBjM2hBN08vUTlOeW1GQUlSVVB3a2lY?=
 =?utf-8?B?bEF4ODhRbkVBcTJBTzcvRHg3RjBLMzVkdFY3QVpqZ1lPRmtxamNZSU91M2oz?=
 =?utf-8?B?UFhmOHhEOC9QMENNMmI2UHk5SUtNUGlaM3gxQWJYU3ROYSs1NDRSM1pZUzdZ?=
 =?utf-8?B?bGJMZ2UvSHNaUS9sUFZQQ3JhaTNZUWljY3BTaDRNdVUwQnhrUGo2UTJCK0Vz?=
 =?utf-8?B?WklaY2QxeWhTTTV3NVZQZTMxMVIzMHdTdWp3VXB6YWJnQ2JPa21vNGFkaHhW?=
 =?utf-8?B?M0FHTE1KR2kxYTNZdUZ5RkhYZXRJbWtYT0J0UzB0QjlieVc2MjJHcFY2cnJo?=
 =?utf-8?B?cFRvSWJiZFFYd0Ira2hSL1BDMUVDVENBSkt6dXMxTzFscytDVHp0NGZ1QzdO?=
 =?utf-8?B?VGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc85213-a7e0-4efa-9059-08dabdce9e5c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 19:07:14.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5k8+ha3fLRaZJeXZ86n6sNr2TQk2yXfHacNPnCIrbThYIgwQc718q9XGkAurshCDS7FtxPp8DILcP/upkHDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8397
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 14:28, Sean Anderson wrote:
> When the mac device gets removed, it leaves behind the ethernet device.
> This will result in a segfault next time the ethernet device accesses
> mac_dev. Remove the ethernet device when we get removed to prevent
> this. This is not completely reversible, since some resources aren't
> cleaned up properly, but that can be addressed later.
> 
> Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> So... why *do* we have a separate device for the ethernet interface?
> Can't the mac device just register the netdev itself?
> 
>  drivers/net/ethernet/freescale/fman/mac.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index 65df308bad97..13e67f2864be 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -487,12 +487,21 @@ static int mac_probe(struct platform_device *_of_dev)
>  	return err;
>  }
>  
> +static int mac_remove(struct platform_device *pdev)
> +{
> +	struct mac_device *mac_dev = platform_get_drvdata(pdev);
> +
> +	platform_device_unregister(mac_dev->priv->eth_dev);
> +	return 0;
> +}
> +
>  static struct platform_driver mac_driver = {
>  	.driver = {
>  		.name		= KBUILD_MODNAME,
>  		.of_match_table	= mac_match,
>  	},
>  	.probe		= mac_probe,
> +	.remove		= mac_remove,
>  };
>  
>  builtin_platform_driver(mac_driver);

err, this should be [PATCH net]. Sorry, will fix if necessary for a v2.

--Sena
