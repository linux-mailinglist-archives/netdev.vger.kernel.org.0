Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163686B7C59
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCMPrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMPr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:47:29 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004935D45D;
        Mon, 13 Mar 2023 08:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYDushW11yKM3lEXJ5dmKg38CqH68eXQyQyVK/0aP9L1b7ISd9wieqeuoJ27vdTQdIsHY92fdULserWrizcU6fz8s6txXj2/3qQDU/o8dUhiyf7Lkn+tT8etS0/YoCjtBi45YBZrv+LjOFDhh9n0w+WMyV8rJWq55QB8cTNDNf13Dvf57NWWJFiojTEzCph4E5x/U9pUTxoXq3xpgD9xqNfTdzBADYS4nMYeHyWlylvBAIhO4PNvnzC0vH5LeYqjg+bFowqBWZ+oyKr27QE4tcDKFArvwWTzb9euZFX+E0taTOfnEZ6sO7fSYrB2h76eBvTM39KUrfHZiIBGNmpQLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29QtUbAOrZ06TQ0+MtSyDA1MjCf2l3qVoC5CcOKIEjE=;
 b=ToH7Ogl5TS8HoDPWNE5AS3SuHG/UoIK4YJ28DRg/q9r35E+jntaQfKqI30qkfQ+thB0qXoG6khqI5gCu5XLEi0sKf3a+mJ7vbh/SPylbRHqBku7TPYmg+w1Qi7KD5d4AIIqyClsYKAU5kkbClOGmoPdB6VibPpReUp7XCA0Rrme+NX6dLsGHFbHEZqRjFOHHgiMz3FQK6B0PO1Fy/LM3yBuhwldOZ/AvEv4/4Y0Onwh2tWdNdeS/+ASvaVMPmu72emwaTLGQgaRWSyqRXvHgwmoJcgiDckAbsMSERwU3MkUg8XW/WiAil0gPEDdlNtbKDL7uBHcGxSYUyp79HtaBDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29QtUbAOrZ06TQ0+MtSyDA1MjCf2l3qVoC5CcOKIEjE=;
 b=V//ggHCcuA73lZpLz1GCRdcBWOB/dDkBquUyD63IOpHvzDFBNENyOJU3VVeQYDNeuMapEYGqMMNQULgUIbcQ7V2QFQec70szNSoWcxdYpK9agSiP1SvdNf8QbYN5s9w/wl+CMzIOD3xjxGk9x0sMWoKuJd+LzDEw+yqjDaH+Kg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by PAXPR04MB8405.eurprd04.prod.outlook.com (2603:10a6:102:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 15:47:25 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f469:ba5b:88ad:3fa0]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f469:ba5b:88ad:3fa0%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 15:47:25 +0000
Message-ID: <b12d1fb1-1ca6-5f9c-c8b9-97c451734923@nxp.com>
Date:   Mon, 13 Mar 2023 17:47:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Content-Language: en-CA
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Stuart Yoder <stuyoder@gmail.com>,
        Roy Pledge <Roy.Pledge@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
In-Reply-To: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::29) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3405:EE_|PAXPR04MB8405:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b99d424-b6ae-4b79-127b-08db23da3d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgO2AseiaSvkGMtZ7axDFoGaT8xZaaKFuW+7dN35XmGxxosu/aXRJ/j2Ac6GsQRvIqkm/f8cCMB27HJrVtVbrcJYLyE4MfosrsKj9O3gNTceve6r08WmGUJReBDfwkKv9ah6303Vo4IfmTkWItLhR/wIF2LqfG3z4VS5bzNMe1ajqm6iPM1YrVVI9WDpkvRoYPWhl/sBY27PYIfZV6m6iErtjTNwQWbFUo83CzlR6GE9qF9M6jY0ei7uECBLwCdRyPiZVAjziOCk8QPon9D9wltD5eAmY98fgHY6CU6t4yOsJd9mdonskugWPd3wbiID347P5KouC1JCrC5rjL3Z0w5yf50uQHxtLcGl7PrpytNxj+VmDTnb55MO7qeN5l3+xbeQzObygnPPA6oHELGkS1KNrZkXdGQX5kt7smG2uUAFwJfjDdPZhmFWj6UWeU7Y8sSlBg6gB9JF5Uhx9D4DneVXpOqGc29zQl2DdnBfx8RjWFceCb7HyKeIyZktxv0kbFDnpzggXqwc5stcuvAf2UvIp5WNnhc87Aqo0p1uTJQdfGg0G6K4Qaxnk1amCXIYfv4OplgiXPdy0sSF3y9NikA8dVF0juZ/diRhQA3pGPTWLswWGso4xd0FIHopgLpWJZgW1xcItUwDp2lY4pt1wnhNY5WO2+DII+Vf0A+UeJtQ9haEMAV1lcSBsaPT/R8HPzA3+pXYzsx/ztodWdX8Mp04BMDtTLbp/bQyRGg50xDdnHy+F6LkckQUA+9l1ZApsc6msXtT6DqLcI2b7o1MS/0kE0MVor2+wRDVUtsscss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199018)(2906002)(31686004)(83380400001)(7416002)(5660300002)(36756003)(44832011)(66946007)(66556008)(8936002)(41300700001)(921005)(4326008)(38100700002)(31696002)(38350700002)(66476007)(86362001)(110136005)(316002)(8676002)(478600001)(66574015)(186003)(2616005)(53546011)(52116002)(6506007)(26005)(6666004)(6512007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU5GdHc5QWZtUVk4YVZCSzFuVFVzbjdEM3B1dlZITnZBTitTVDFCTDRKK1E4?=
 =?utf-8?B?Zk0xWFFnUTRRU2RNTUtpZFNaQUU2VmpPZzhPWVN5MkQ2SlhvZXVlQUphYlFL?=
 =?utf-8?B?dUVGRlR6SVI4cjUyNmtBWFIvc0poS2R6VEl1S1FYL016SGUxdGhlMWQ0Ymdo?=
 =?utf-8?B?V085MHlVdGVNaUZ0RVd3WmVma21PMWJyT0pYWS9VbFUzMlRIN3VweEc5MDh5?=
 =?utf-8?B?REhBcitwbFVuSFBkblBHNkdxeGJIL05scEZhLzlLZU1ETkdqWjB1OVJwaGhF?=
 =?utf-8?B?cFlrVGNqUjZtbFd2eFZhcHZrdmhEeE1Zalp1VG9BWkVxdFNFa09QVkZpdkJo?=
 =?utf-8?B?dGZxWlR2U2I3ZVA5YWNvYWlvZHhVTnMzTlozS0JZRy8wYmRoczdNR0FEalQw?=
 =?utf-8?B?YjF6Sm1CTjdmYXJHWVY1VUdBMnlSbVRnNU1xZlhMWjFlV3IxSzk5eGxGaGNC?=
 =?utf-8?B?N3BjczR6YnBVWFc5QkV5SWtkbVJxRjFhelZJTzQ0Y1NIajQ2TDVpQ3V3VGh1?=
 =?utf-8?B?emlwbW5BTWd2NFc1TFBBMVh0RWVMSGljc0lqKy84UkF5eUw0bVhMUGxVOElH?=
 =?utf-8?B?TW8xV3BrOFFTWjQwVnZFS29HNHZTdkhMRnJEanh6Sm1YZHFKZVRvMjJzT1NE?=
 =?utf-8?B?LzlqcmxZNEpYQjhMcUZuRE94enQzZTBIdkxqMEdhZnAybHhLWHd1Z3lKdmZZ?=
 =?utf-8?B?RTVIT2RpWlNIcVJmU3NMY0o1SlZYVHFTdnRqYzdXTHZlR0pYb28xMVVPemVn?=
 =?utf-8?B?cVd0UUJoMm4xM25hS0tDemlKRG94elc2cXNmd3kvK3dZbmxxbGJWSTVXTWR3?=
 =?utf-8?B?R3ExOUVYbUZuVnVxY0xqUjVVQytFenpZY3BBcjYxTEk0anNxeTYwbjdPRWJ6?=
 =?utf-8?B?aUtVNFYwL2w5a0E5d0dZa0ZZUFVwcVF6MG8rT25MQXFyUDJRaC9veXZzdzI4?=
 =?utf-8?B?Ky9BL284UFMvT3AxeVdiMm9iL0ZpSERQQjM5a2pMcmtPTE1OV0dXL0RRTkxp?=
 =?utf-8?B?dzRjcTV4TjNtbEpGTFZ4dmJkT0wvZHU5N3Y2VjFmbHhmZkJ6TVlURnZkaEYw?=
 =?utf-8?B?dmcranZ6OEFaV2JHYWRVYkZNQUd5T0NNMjlHS0ZDMEpYZ0VVYkhCeXhUMW5H?=
 =?utf-8?B?Ky85REM2SnpZbGJvM2o3MHRtMTJrMlNBbnVibTVzR3d4dmZEd0VJRndTVkh5?=
 =?utf-8?B?bWNUMlpzU3hLWit1RTBxNkJadGM1eUdjTmNzR2U3Ni9nRFg1ci94Vlp5UTlP?=
 =?utf-8?B?bDdvUFRvQkdjK2Mzb0Jwb2RFV0lxRVREU0VRK2Z1NlNrNUJ0QXZGTFR0cFBI?=
 =?utf-8?B?bm5wdmZaVm9MNmYvaXAzSTlLYVpYRXhVMndEMG9hY2hvcXJBWnQzSFRJb2dK?=
 =?utf-8?B?T1JueVJMcWFCNktSVzJOc0FvbGpxdWtGczJ6cVVGZ0p5K3pjdWNmbjNoMENQ?=
 =?utf-8?B?eFhneFNSZHk5enJKYmJrdVVsU1NSdkxjRzFLZHlhTGEvNjVKeloyZHNqaWdQ?=
 =?utf-8?B?TkVwOFEwZ3RGaitWeWp6ZjFWRXRIMjdwNjFFWEcxQXkrZkovUTJ3TXlpU0o4?=
 =?utf-8?B?d1FBR0ZQZmJGamlMTkZlRmpKOXpmY0ZMWjhoMEhTNng3b3ZPVjRXUktNUEQy?=
 =?utf-8?B?bmZDWG5PbzhNcmI5QkxTMzdjSlIyaUxsUVBrOEZiNktQU0JDNWZjOXV5eGYz?=
 =?utf-8?B?L1ovUTczSWhWd2ZoOU5wVVFPVy9YL0RzNXE5L0ZQQUN2b2dFRTBwVTIwOUVX?=
 =?utf-8?B?dzZNbkJHSVljUVRQb2tReEdBNmZ1c2JlVm03M0RnTzQ0SmwwQ3dLN0psRXpF?=
 =?utf-8?B?WDV3bHVMSTdkREo2RlMyeFpla3hnNlVjRytoVzFEREZ6LzJWL0lUZ3V5T2s0?=
 =?utf-8?B?eVN0ZkhXRHlVNHFVbGYraklIM2pTdkNjY3BSWkYwNjZYYklSUHV4bnExMFdV?=
 =?utf-8?B?aGdGem1zWUJOK1hsbzdyVDNMRDg3bzVxeUVoS1JyRGJGc3VualJhUjdiUEFW?=
 =?utf-8?B?R3lZZE9sSWNUaDAzOFI5cmt2UjY0WFZub2NlcUVWM2ZBY2JsaUJuM2J6YklQ?=
 =?utf-8?B?VndiZ25IMG1nOGpFTjY4b2RGZkc2KzBOL3RnYlpqTGJ3cHlXYVpzdExPenAz?=
 =?utf-8?B?ZnRjT2EzejdXK2I5WWtaRTFSODdCbStMS2JNUjY2NklqZ20vbXh3RmxZZjUw?=
 =?utf-8?B?dVE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b99d424-b6ae-4b79-127b-08db23da3d3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 15:47:24.7590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXQ+O3+JIgti9inFtMhQpc6SNR6z2HuYDd3+hQORenDdXaovJX4rnpBh2cJqWHbYQ68vXdUHUpTMI9JvjwW5Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8405
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2023 12:41 AM, Uwe Kleine-König wrote:
> Hello,
> 
> many bus remove functions return an integer which is a historic
> misdesign that makes driver authors assume that there is some kind of
> error handling in the upper layers. This is wrong however and returning
> and error code only yields an error message.
> 
> This series improves the fsl-mc bus by changing the remove callback to
> return no value instead. As a preparation all drivers are changed to
> return zero before so that they don't trigger the error message.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (6):
>    bus: fsl-mc: Only warn once about errors on device unbind
>    bus: fsl-mc: dprc: Push down error message from fsl_mc_driver_remove()
>    bus: fsl-mc: fsl-mc-allocator: Drop if block with always wrong
>      condition
>    bus: fsl-mc: fsl-mc-allocator: Improve error reporting
>    soc: fsl: dpio: Suppress duplicated error reporting on device remove
>    bus: fsl-mc: Make remove function return void
> 

Thanks for the series, Uwe. Did a quick boot test with ACPI, so:

Reviewed-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Tested-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
