Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0A6C2247
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCTUL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCTUL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:11:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2127.outbound.protection.outlook.com [40.107.94.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C553D83F3;
        Mon, 20 Mar 2023 13:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+6hyXOnz3TIec7ljs/6Lzt5XmeEaimmiHkwG4Wc+wbIwj4hlZoKjhNZDuhrarLjtgC/uhIwv5JnulkzqOn2DeGg03JsG29XW1DSVvei/D+7nipaxYR2Fbz6ACu3RCvWHeEqoKFqXYRZDRKAnWGBB8DW6TdCgZ/rJRV2vy8/1QziJfZEEM6dF+JXSPB8QF31tpKaP4v2AYoOhbCDJrr3sR1m/Yi9oHsDIwBh22BpAe3SdSrCjh20v6G94zM5foD+HQAkcWNsP7LnVZ7tiebIr2EElw6/evMKNMNmpn1Li3Ez/4FkRXjUTYhwWIdMKtdep8hHiRkt5fXsl3zoXV8tjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7IBPSE2g2uxui4uFnt4ZluZdCuNj5pLtuikQuvSnCU=;
 b=VHBj3GoSSlNQA3aVaIwZA2jDejMTXXNHAkzLKbjxynpo3q8Bw/pKDGWiOdF7Pap8nifIIHs9kq+1DXwkSKZyWLHxpQ28uHltxbRO7nXJyp8v+KLy+8m88JNI8tL6wf2bbjl22gL0dtT2f2SAv++C4pAXILSda8qlZugx61A3Md3vVRe+hMVSni70YzyR7xmIJCa6jICIkoH5zwVZNhxSVTjWDGKuz9pbZAaFcCHELwEm+5oBpaLA86hW7w7AgOUNHnE7OD4jB9PWH85Y+f6StLw2ba/Gt5KIpcufbq8vvBt4EHoU1lSHu0Qtzudd3zy51B6iKQk0UeKTfuGasc0Q+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7IBPSE2g2uxui4uFnt4ZluZdCuNj5pLtuikQuvSnCU=;
 b=XdSASsbF/m0zlu996fpJIjSmpLVSQ+OroO9W/BQa3kCMcnMbQCSlr2xl26+PQ6IceE8yUxtY+U3+vWh+INmNMbNh6kFTec2LMPbS5zL1Kng0/2p5GGPO2aG6dczRsZWGxCCzepWokJsQwMc1Q1Cyu8acYKBtKnd7ETBf5zFiPmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6307.namprd13.prod.outlook.com (2603:10b6:8:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 20:11:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 20:11:51 +0000
Date:   Mon, 20 Mar 2023 21:11:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: dsa: b53: mmap: add more BCM63xx SoCs
Message-ID: <ZBi9+ulgaBxX37MK@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-3-noltari@gmail.com>
 <ZBi56yI4CnY2AAtH@corigine.com>
 <CAKR-sGf1XFP1pE1KmQVQmZADc6udS_8+qqM5NvrNZ266VPkMtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKR-sGf1XFP1pE1KmQVQmZADc6udS_8+qqM5NvrNZ266VPkMtw@mail.gmail.com>
X-ClientProxiedBy: AM3PR03CA0067.eurprd03.prod.outlook.com
 (2603:10a6:207:5::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a4ad888-3ce5-4d4f-ff96-08db297f576f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nafsq95S3CqoodYlb1g1vxqHqcr2YbtL+B6zhTUnDsDGlWgd9hMG0g40/Z4g8nv1ZyNerwTIvdVH8KaqlIYBH+wIkRLrh+MPmyaqX9NxSIRGCjqxvzUxkJQnpI9TDbTWTNDJ3ob5Plz3xKXNjWddiJRC1ZpAQr+VD6SFC4byIG4p7Uj4pDhndlhVVvkeIxC91HzCSECoi/IB8JX4XbVCZOESSLU46ctEmhEapbbxZ3DbYQng0I9i+MkBAiBrVbBrEcqx5iUtmoHxNBL0HxDc6hIPUuiDnlya4kIRVeo1G8mDXB6to4HtyMxO4nKIqGYQzEA5guHGRFhy/GdlArxhCB6GaILHzv60kJ2ezYfHf3t8OPcbSeyiKgoKSgKV89WRsda6bxrtfFM6uko3sfzOmXKcKgDj9VOsWKl8YmUf7P/6JHz+nXmbOlSaXjNyBUf5S9MF7tULd0YwrXCRhhLQkBxnG4H3wWS8+dHpIlg6mgdXROPeKH6rOISs30gf9UiLGIj3ekLJ/bW0djXFK9lADVJvLy/IW1B1MZwcuTUpIDG3rrQg2Ujyjsc1xVQ44iq7wkU4wq3spEWbMHjk0x6f4q9+iXqC3t8J2ZJsd9kGhEcw8je1P+BloK5ZngnPM7ylxYMcWwXM9NKiZ3j+43sPZJXulmHFtvQrXDCWXgmGQhUhQt1odWRzjSMc6BjjSdpt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(4636009)(136003)(366004)(376002)(346002)(39840400004)(396003)(451199018)(2616005)(66574015)(38100700002)(86362001)(44832011)(8676002)(66556008)(36756003)(41300700001)(66476007)(8936002)(6916009)(5660300002)(2906002)(66946007)(4326008)(186003)(7416002)(478600001)(6666004)(316002)(6512007)(6506007)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXpnaWk4SXd1d3NaYWNDUEoycENYdUpEZEJUT3Jobyt2R05EdU9JbStxaWpT?=
 =?utf-8?B?S1RmOE15bnVpUlNUZmdTdnNmZWw3WWg0YUZxZGdnZnAzaExyekZDMlNIS3pD?=
 =?utf-8?B?akl4aHdTaTNYcWpwOGFlYmhpUnZ1OHpSZDhocGFSellYSHI5dmN3dWY2ek1z?=
 =?utf-8?B?RXY4dUkvMVlTZUpFYkNyOVRqNC9RN3JoV3FMTUVET1NtaWRKc0Vtekx2Nno3?=
 =?utf-8?B?NkgzdWJCbEl5S1pjeGNJU1BPTkNsR2k1Vk5GZmlhU2hUaU9kVzJkbE8xVUF0?=
 =?utf-8?B?UFNEVTZrMlR3dUdUaGpBT0VEWm9uSktseEVMOW15d2JtTkFxQmRMeGpXcms4?=
 =?utf-8?B?Y28vRW9KRzhBTEFOM1ZMNm05bHJEc3F0cWdGdlBKbDNzNHRZeDk4YVJvZndY?=
 =?utf-8?B?R2REZVhYck0xZ1ZaV3NSSkNua2JOejZ0QWhvbWNJVkRYYmloMGVaZ1JlRmhp?=
 =?utf-8?B?T0h5bjVjbWNXNGltbWMyZGR2dkh6NzBvayt3K1VKZTB2QlN1eWx4R2R6OTFW?=
 =?utf-8?B?Tkh1SDBJSnRPc3FncXRiZ3VKbTN5L3BQZkJDa295bmFXZUJkbjE3ZHdCeWt5?=
 =?utf-8?B?RjBhWkJYMlR4c0I2WjQ0NnJNdmZKQVYxL0tvZDlUbGdlZ2pEcDlCUFlEcXl0?=
 =?utf-8?B?MUd5eDJyUUhMdzF0OEdHeFRKdGIxaTZsdThHNUVBK3FUUWpmWXVUSE5GUzA2?=
 =?utf-8?B?SHlUQVlJbzNTQUFnWVpTd05IUStqcXZ0VG42THRaUm5Wa0JNcmE0NU4rc3Q3?=
 =?utf-8?B?QTc1YmpMVGRQTnd1TkpNNVFNZktveXB4cDQ1QzNjSm9vZ2tZL2RGWXZCWjlD?=
 =?utf-8?B?U1A2QlJKMEVOS3RHTUhKdVhLdWNxbzJ5cEw4cmFSdVBaZVNFMXJJRldRRXRB?=
 =?utf-8?B?VFdTOUI3ODRzNXBUTHIwc3pYaEsxMXZpWlhsK1VXS09xZ1ZuRkI1ZVhSQzNx?=
 =?utf-8?B?eS80SnZoNi8vOEUxUXNwNlB1Y0Y4NTl6UmlLUnFZOXNnQWtqeGhYSnJRaEkr?=
 =?utf-8?B?OU0zQVpITEJaVU5tTVMrUTVZN0hLdWRFbkVSdXprOVhxbnhPY0hpazFpU1Zo?=
 =?utf-8?B?d1hka0pNNS9CNlc2UHFxb295NDFkSWU4R0UxUlN6am9jVmV5ZU92cnNmcjJx?=
 =?utf-8?B?SFFWbEdVOGYyS3phNjUwVHNiUzdYWTJWdEZLQ1RKbFlqcHFwcUEyNVB1SHVS?=
 =?utf-8?B?OFovR3I2SE4wdDVLOHV6TVVsdlBWZnpJdWU2UnhsNjJ0cnNoTzBTNnlmS2F1?=
 =?utf-8?B?WDFNQmh4dTM1enlwZVk0dFRFWnFlNGczeFEwZm1VQUNHcVpoQlVzaThpU1Q5?=
 =?utf-8?B?dm8wb3JGK1NhWjlsYXRXOW0xck53S0lKajFUMXR3YmJ5SnFTVmovVDZhQTh0?=
 =?utf-8?B?M1dETllQeTZ6RlI5WTFtWVh1bTQrcGtCZThxTGRVOFJTVDdtQ0xwT1NRQ0Rv?=
 =?utf-8?B?VnV1Uksvek9xOUdTeTI0dGhXRDc5RVUwQnU5UFpuN0dFZFZTZUdzeTc4UVVK?=
 =?utf-8?B?STR2YXZ1MEFNMjJHaCtxVGJrQW5PZDJCUW1TSTZXcmtKRlZmY2tmVDA3YVBB?=
 =?utf-8?B?ZWoxTDlxYjZnaFZOVWtZZHorUnlIRDgwQW5GcXVHWW4zZXdwc1ppMUxnWG1N?=
 =?utf-8?B?aEt1UzVUTzhYQ09tamdzMmI2dmt4L09rRzBBenUzVDRzVnBnRlBKTHYyb0FM?=
 =?utf-8?B?R0J6bkFJbld3blViRFIzSUVVTVo4M3BWUHJhVERpUWREYlN4eFk4VnU0amg1?=
 =?utf-8?B?YmdHMTJOazVHdG5GcXBVM0xkdkFkU1MzZHpEREJLdmsvK3FjemZMcUx4YkpC?=
 =?utf-8?B?REM1dUJQVS9FTERwbFhZNWZOdGtnOGd4dVN5RGdjTDAxQ1dQQWsvMjVqVW9H?=
 =?utf-8?B?WTZWRXpUZ0FzWnE4OVVQWVZsY1dzZVU4TEJNbzViVW5SUDdPaHhpenJEc3NO?=
 =?utf-8?B?OWdTNlpuUVBVb0JoZS80TGd6aEQ0c09zZStDcm5XSFU5dUV3dGFCZ2FQcGN0?=
 =?utf-8?B?WU1lUHYwSzlYVmV1RlZRYXBiOVpyZkhjbkk4K2NnQUpFRkNmejFSSjNXRkwv?=
 =?utf-8?B?UzFaVnVaNEFIVDNLNTYwenhuZkltZ1YraWE3bkw4aEZkR1JNWGZlYjJvZTdF?=
 =?utf-8?B?NzNJcWpkREg5akllb1NMU01BT2dadCtmRktlSzQ3U09wY2VmcGY0d0hHcVZv?=
 =?utf-8?B?d2pXaC9uQzdzNE9XbTdkRFNRZlozY2x5dTV2YVQwN0JBM0wxcCs4MDFPc09Y?=
 =?utf-8?B?OGcxR3dzSWJqMFRxaVdYNEZna1ZnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4ad888-3ce5-4d4f-ff96-08db297f576f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 20:11:50.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw1dA5H20IwciTmNLu66bt5ojUkcrYxiZu/X2XFyLHIl9gP0txnKLKiH1KhrJ60eEJNGvtSQwOiOCNdR8cZZRqLjwPUQ8p5maBzW8ToN5rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6307
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 08:56:58PM +0100, Álvaro Fernández Rojas wrote:
> El lun, 20 mar 2023 a las 20:54, Simon Horman
> (<simon.horman@corigine.com>) escribió:
> >
> > On Mon, Mar 20, 2023 at 04:50:22PM +0100, Álvaro Fernández Rojas wrote:
> > > BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> > >
> > > Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> > > ---
> > >  drivers/net/dsa/b53/b53_mmap.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> > > index 70887e0aece3..464c77e10f60 100644
> > > --- a/drivers/net/dsa/b53/b53_mmap.c
> > > +++ b/drivers/net/dsa/b53/b53_mmap.c
> > > @@ -331,8 +331,11 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
> > >
> > >  static const struct of_device_id b53_mmap_of_table[] = {
> > >       { .compatible = "brcm,bcm3384-switch" },
> > > +     { .compatible = "brcm,bcm6318-switch" },
> > >       { .compatible = "brcm,bcm6328-switch" },
> > > +     { .compatible = "brcm,bcm6362-switch" },
> > >       { .compatible = "brcm,bcm6368-switch" },
> > > +     { .compatible = "brcm,bcm63268-switch" },
> >
> > This patch adds support to this driver for "brcm,bcm63268-switch".
> > However, less I am mistaken, this support doesn't work without
> > patches 3/4 and 4/4 of this series.
> 
> It works for those devices which only use ports 0-3 (Comtrend VR-3032u
> for example).
> If the device has a external switch or uses any of the RGMIIs then it
> won't configure those ports properly.

Ok, I guess that all drivers have incomplete support,
so from that point of view I guess this is fine.

> > I think it would be better to re-range this series so
> > that support for "brcm,bcm63268-switch" works when it is
> > added to/enabled in the driver.
> >
> > >       { .compatible = "brcm,bcm63xx-switch" },
> > >       { /* sentinel */ },
> > >  };
> > > --
> > > 2.30.2
> > >
