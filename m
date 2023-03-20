Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDA36C21E9
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCTTuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCTTt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:49:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C024093DF;
        Mon, 20 Mar 2023 12:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5cYrBqwqBqDv5AM6eAuYg0VFLsGNgfQ5vnrFRL+ycgyIM1JZ4k25Bjg9ST2Htk6jRBwYAlk2813jtQuLK43aBH9i6tO8sacvChgkC3IvYMf/g+rVhutn/KezMMfirbf9/8US78duuGe37lveULgaJY4Q+7pU1y7FyeEH2hQJPyhehHSx533UA4CvpXrWEr+hwKWPyro4ZlpJBI1GJ+ZWwM+Av4dU8PVYu1vS577a37zTiO2HFhF/kl49FJVVTLxkwStZPnQF3hgB4nOtvrOMvmCmDdMwWe761HcqmBv+fPcb2flg19S+U8KiFAJln5neXDXlN1b2zo9R0QDtI0O1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ8IGwvar8/2jH3qswEhHAHKVWjDlZtQuTlnY3oasUE=;
 b=KF9QXJmBSt94BRekg0pHrykWFYX87pYYy8Nw/9QKHfccO9eqftbTyptPmHC4Hf2XhXiADKwDLeRwifIJxXJ0ghvJXfhdhsLPEHFXmm4bKR2jaE8YN/4FKtg304J8jogqzh+m88oqu/3PdZss8j+avsA2mRsrws0Lf781Fomnwj5M/+K/WYvDYNcMVR3ggzx999jThqcsRvK/cw0TKWfKRMDMJnfiCcyGUxsCM9K8R9INLaa2Iu98L0uBjI0DctQOEhZQX91d0CPT3wHNCPwhigCC3LGWmb98qAJ1UEyBwyxiBdaTW1+ugcq+QBnbvoUU+50eCG6x32iE04I6w2vSJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ8IGwvar8/2jH3qswEhHAHKVWjDlZtQuTlnY3oasUE=;
 b=QHWeZ6ZBXzeEZfU3OhT+YV1rZ1iNW+LGM9wT2nBhtUTXT27NOtajoEOeMgSgQdAlfwfZEj5ngRqUaDrDIXvtmh7LUOOVn8oNIiunSYqQhvSdP6c0dzPmD3ert+NcK7nEQU7HzRFGAYG8Afm7epWJWQuRdhxB5n2QOMaMTW/E2yk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5777.namprd13.prod.outlook.com (2603:10b6:510:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:49:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:49:53 +0000
Date:   Mon, 20 Mar 2023 20:49:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: net: dsa: b53: add more 63xx SoCs
Message-ID: <ZBi42ZRZ3jfvgvRp@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-2-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320155024.164523-2-noltari@gmail.com>
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ce2858-3d47-47fb-7ac2-08db297c4610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcBJ9mKC+MPQETaydYIiJwuYhI5zi1xDceM215lz6jykr0CTO29Q6ngawlddslAQ0EVtoiG5odCxvxyjr3TEQo+ZAGYWr4AO6WdUWS4eJAPSvEeOniikLJpywdl2ZrXAckmzgXcJ2wg9LWHrX1l2yc2PaMH2b83nM1lJCQfDBQNPC/Ig3JaylydyPXdEF25YLu9T9A7JghIB8L7Ogy2ziq8o1eYJiMQ49iZ5/ceKAD+T7UPhHtS9ZjwFkOZTbh7RAwt0qQArV51MNNlqRRYn6xLn68Ak3JFxjwghPGOAIfi3rVMj/a2rz4+py8ZC/4KUep1DqBqgBywUxhQOXZsGoiPhVJwqyhbWeNIcZkQBMdIokZCSTcuToDeOP8IQhdMU93U1+srOd+wbSwkLGYX3yiHxV0CDz+40SX0bXtPbrBYBOO4tvtl/C7icEQ5UwL6xfTtOERZQBw2T1rcq7e6lM65zDWVbUwVrvWrZ/UGHVo1Od0vlb+60MhwkShKjTEllt/Cl4O9bPD6tQqherxdBPK0FMU57Fa8evQR/wuy/Dv8x8U50Q63GKzF/oZ/eeh0IhKY6uQySSpDGAcJBzrpVyf0Q0k6nYHH98kJj0UdHD+uLJznTw/Wj55FA0cL4Gpum6Hem0wccIS4rSnzsv46nK0Pr25hmeqIFrzALEGa+vyuZ/MKsILWFotnIcaegX61Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199018)(2616005)(6506007)(6512007)(6666004)(186003)(6486002)(66946007)(66556008)(66476007)(316002)(478600001)(8676002)(4326008)(5660300002)(7416002)(44832011)(41300700001)(8936002)(2906002)(6916009)(38100700002)(86362001)(558084003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aExOemhEdVB6QlpxNE1UVFlhNlFselFKRkpQckMvM2hkTWh3a2traTZwT0xB?=
 =?utf-8?B?UWI5UlE4MWVnbXViTVY0RkNkU1BweW1GTVN2VnloS0lOQ2xoTTBKYXdlTFps?=
 =?utf-8?B?QWxrczhGOVQzR01NZWJvOGk5YldIbW1HVjVkdEltWThsV1RJSG9EWUZWY3FM?=
 =?utf-8?B?ZFBHbDg5NVpRNkdyRWc5SFZ2SXlxNXRlbko3TzVEdmRhZFpoOEcwYUhXVW4z?=
 =?utf-8?B?VGsrK3ZPQk81czlLdFp0SlNqZTFSN0IyL0MwdFJJUVRJMXkyWmthWHBNSFo3?=
 =?utf-8?B?TEdVWHNqdWc5UnYvdWp6K0llYVE1Ris1MGFJNXhVV016R2FPL3lTRU1VM05j?=
 =?utf-8?B?YmJiTUxIQUt5aHFyYUFUMlJPNDBtbVY5elBOMnRMTHhBTTVwNHNDckVzbytq?=
 =?utf-8?B?cFo3QlRXTnMxSzhudnVHQ2lWSFlUS3UxajBpZUdQSzdZd1k3Q1ZVVUc1VGdK?=
 =?utf-8?B?UFMveTBVd2FpTTZOV3RhY2RGNDlIYThEY2tMUWYzRys4QjRoemhTYnlnZE1N?=
 =?utf-8?B?Sno4VnlSR3YydDE5cDZDeld5M2hpZHVVRDd1bFhiU2c0K1hQRUFpRk1xaXM5?=
 =?utf-8?B?blhyUm1ySEdwOEdFZTQyQ0NwQUVid21hYmxMY1JUY0dxUG8xVVVvaUpXWHlZ?=
 =?utf-8?B?d1RhYXVhWkE2ckJrM056WXYydWtER2xCTElpZk41YzdRVDJqSWhIY0JlcFhT?=
 =?utf-8?B?SmFlcGQrN2ZuSHNNRGhsbG1tUG4xNTFzZ005bStacldNSjEveTQ0RHBUb2VO?=
 =?utf-8?B?N1BZUkFsRlYyY29ENzRUVkdsRWlNWGpoRXdicGtaVEdKMkhseHZDenN1V2F6?=
 =?utf-8?B?YTFBQjFUcWNzcklQNnlFOTI1eGJ2aVZmNnQvSDUzRGt2Q01ROWdPNG05OGx5?=
 =?utf-8?B?VlNicVlLNUZSa0VmWnFHTHNoejhweWxhc0tYZUdOZkpXd3dtSVRZcnFPRGcz?=
 =?utf-8?B?RUxpbCszd3ZXTi9WK0prZ0RNbExBVXlRQmdwQzhLTXBTTGxLSGxoenQ2WWlj?=
 =?utf-8?B?MXdBYzluQ3ZtUTlmVkNSa3E2NjBMWjc3NUR0dnNxaWdFc2R5WmJUZ1B2TnVq?=
 =?utf-8?B?d2hIQllENnA0VjhMbjQ5WW84aEFlelFQbzhVRmRZbktoZ2ZQTG1XekxGOHE2?=
 =?utf-8?B?OHdrbTIwb2RxYWRDeHZzWEpBUnBPZTlCU0hEamVSRmIvdGkxTk9WaGR5Nmwx?=
 =?utf-8?B?N2dFaGVnazR2MjZOeEZuZXNYU1dwM01hOUVnRHFLaEpJVTd3NHdzcms3Ky9X?=
 =?utf-8?B?SDVwekp3bjR1OFJqMDlXMndMQm13UDR0ZXlNV0JORU1qQzlYRkVTY3pRTktw?=
 =?utf-8?B?ckNYUlRDYnpYN2wyTmJZQkNhelVuTGFBbmV4d2VyRjEwUlZtM2JXNjVkb0h6?=
 =?utf-8?B?dEZvWEp0aVY1dk5GSkpRSHFadnpIQlp0U29ISTVZaFRxQkxBNHQ5bWY1ZmFG?=
 =?utf-8?B?ZVB6N1E3NytZV1ZZN3FtU05sZ1QxbkN1a0V6aVdkcnRxUnN4Ri9GTW9PRVFn?=
 =?utf-8?B?K2E5S3o3L3NUanc1WXh2R2dXa0NRTVg1T2g1b2dUY3A0U0NPbXNVQThsT1pF?=
 =?utf-8?B?Nm5TT0Jya0xURHREUkJiQ1VNbEVnTCs4R2s2ZDlTdWlmWENKWnRscWxyemVP?=
 =?utf-8?B?dHo1TXJaRk9WMTVEMlVMVVVRKzk0V3p2N1YrSmNWSmdicjJ2Ty9wSW5IelV1?=
 =?utf-8?B?TkEvN0JHU0k3dkFubkVaTDhjVGNrR1QzQUM4MXBXMFZuUjVlWG5XUHlWZzlu?=
 =?utf-8?B?cmY3RURrbXRHZzN6UkFBSzlhcVNUc3BHRWVtSHhNbnBHSXRDdG1uYlVrc2Jz?=
 =?utf-8?B?WG5ZdUYyRms1cFpXTFJqT3QyZzdBZENraEdFRTVDcHA1eFd4Z0djbUQrRGx6?=
 =?utf-8?B?TURoajlFN1ZOSU1qdUlENUJweVkvclB2N1dPcWhMOEkyaDdCZS80cEVlRngr?=
 =?utf-8?B?WGt3akpZcTYyeko5d1VLcXJ2b2gvQTNlTjJRenRkWndURktpUjREU1RwZFdP?=
 =?utf-8?B?cE15eHRzL0lhVks4QjZlNUtYZE96dVRpQXhyYWtuVGRkcU1DdHZ4cjZvdGMr?=
 =?utf-8?B?WnlRNkVZVkpra3FKU2crME9nOVFiWjdCZGYxZEs1M1QzeE1ZZ0E4Y2o0aGtp?=
 =?utf-8?B?Qy9Hd1IvVi9SaDZwVTZZa3lvZ3gvTkY4MUEzRmlNaElYTktCMzRORzlPa1VF?=
 =?utf-8?B?Mis4TkRrN1B3VS9sRDhYeEs0bDU5dDdYNTVZR25DU3JSWEZHcDc3KzJSdHNT?=
 =?utf-8?B?ZjAxTUZXc0NxWWt3ZHlJc0d4UklBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ce2858-3d47-47fb-7ac2-08db297c4610
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:49:53.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fB/cNwhTyCGS31cXGuSev+vbXDEzziScOY5Un2vX7kMw93OXS4Yp4dn2FG/VgKdsmvpGLrlyDEyw36JQpfDgLkaVs6ldPF7pckFmNsBTOaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5777
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:50:21PM +0100, Álvaro Fernández Rojas wrote:
> BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

