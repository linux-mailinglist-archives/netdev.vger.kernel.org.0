Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329CF51FEF3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiEIN7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiEIN7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:59:47 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2105.outbound.protection.outlook.com [40.107.215.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B1418B3E;
        Mon,  9 May 2022 06:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEZqPS7pCBexxOlGb5hq6KkibpaYePKdvOzQUq6FjVJp0HN9WtQeq/PicRsYEnVjHeNm1z3aovWZhhpjNvX4Iy6hRSa3k/pU9I/BI0QvVO79JyijohmQPnDu3W2zfwOoeXu3tIbx/vJcE5CvGc+xgKqt54rEeeDLYk9vIaxZ18Qd3uQLry96mUmHV3mfhUmRXe6NGqt5w6PvNa6817RUCHJPpsoD7mzT76hHWTaNCgWS/VnvhgTH5hmll1fWtkroP+THboxUBOfPJN9xdauOOQwULC/+GZWEbLUk/wRpQYFlvxeSijxU6qNyj0rfiRmf0j9LK/uTnSWVW8YFFZGctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oK2rogvgNdkBaBxpL2ZlZZioTUSw/jVf3WKy8JIF7SI=;
 b=gOVKynbDjXuB237iDnIlN/ogHc4cgupwexZDHDz4R5KjVcCh0CZWqM4IwP5jBfo2GnOubJ1HdtlJMx8kbwfBS5MAFhxPDc/oIy0xiBFqhdhtYoEW+X+RTZRVn+VA8gF47WefPQZ+e5uOrsr/ZBs4F+BEqDeSpTlmAKqz2FKOK3SVcyUOlvSmaIrn92ypi/K/csXoERL2DMTls6UkyB+0jFokkpji6gxVyvNPL5M3z+JXIcm8mkRaOdBByze7poA1H3Q30TTFOK/zfp7bzLhBwTcsDvyw7C1jGRbppt1D59JuxLHedYkmriB5mBQcv4L7s0SLOGBWnXlIZ01GnfbU4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK2rogvgNdkBaBxpL2ZlZZioTUSw/jVf3WKy8JIF7SI=;
 b=obOyLiIGJS2BMa/JO6bFoeEtQHAY5EXgBkpCo5pjOH+WjG5tk8HFMYajFrFiTUF1sTGszEn/himzlQ72pB9maS/r7HCDSDpFf28JvWCStM7PU9yymCCPwGNpvvTWHj58OeXzB0QxaV+9A9I0M8hI0Ufpfbn5MvAqGmYUIiIbJ7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2995.apcprd06.prod.outlook.com (2603:1096:203:80::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Mon, 9 May 2022 13:55:48 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 13:55:48 +0000
Message-ID: <8e2e3c34-1aa3-bab4-cdde-256a6eea5e44@vivo.com>
Date:   Mon, 9 May 2022 21:55:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: phy: micrel: Fix incorret variable type in micrel
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509134951.2327924-1-wanjiabing@vivo.com>
 <Ynkcy0VhJ/HTfqMU@lunn.ch>
From:   Jiabing Wan <wanjiabing@vivo.com>
Organization: vivo
In-Reply-To: <Ynkcy0VhJ/HTfqMU@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:404:56::13) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 006b4bf7-916d-4b89-fccd-08da31c39f0a
X-MS-TrafficTypeDiagnostic: HK0PR06MB2995:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB29956D51F956B427119B1631ABC69@HK0PR06MB2995.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q51NHcoElPG0sa4Wwr+iLT67ucZW1x72v11AUW9xs76dHz0Rgd1oceIPxOTsDtoPHYKJdj945CsS8ugttVxUbuiG9SMQL1QyW0lWACdg1DQ2xxV/ZFx4azB4rsbLufzGxIFsGCY3uqiSsxEUzd9Fpl8K/ML4NT2ltMIBtUDAGfQHb6eMw83NOFBr2cQ/c1M6l00gMh4Q9ZGpBqQwJVaMGq1uMaFBYSeiJwWWEbroUyNh5TJs9Ku2fJBtAJ90qdrzaaaWeusjpV3JEtTEdY+mRlnUtj0UMKGmG5lU1i+eutR7itS5pCUCn1T3L77Sp86KqbmObcrJUSTnIempu3YP198zC0i6CEr/j4iFoK2KzNvNiOO9RsYWma1CJIr+LsF+4ATVfH+dkHkV8cTHfQB3+MwPXAk39dFn0lRs8hVkpsWqDc+IX4mEBefw4PpfxqSmdh7J8wVqqU8XGvgc6+42uNTJF/dF+3z1vYY94H6tCRjj0NPO7KzKHacYARmgHfKHe5TtQesEdyOXVakdZrSkT8M+lRxdCKpnsJtsZKjV3IylmkfjPYKF+fqfxqijpWQgIRcMonWk9kITRzdQrxbFj9O8bHlRxJNat9V1hDA2kDKGk4HC5aDZyv2ZODAAnNEQenpl9yzBWbh2aC2vwSgNCaxybaXRG/xXtT1As44cUBdk3+pw+aQJ9Qa7p9iV9BYSEXPPC9ISQhL2M+u0mBbYPuDNyiziqsCTuL2lS1s9AnCgSGrgHlxdgsLa7dBZn/ObwaH1FM+TJrpDdFkJdC8dhn1i3vRaADvvJOl4hu8fE9c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(6512007)(26005)(2906002)(86362001)(186003)(6666004)(6506007)(52116002)(36916002)(5660300002)(49246003)(4744005)(31696002)(2616005)(53546011)(36756003)(316002)(4326008)(8676002)(6916009)(66476007)(54906003)(66946007)(66556008)(38350700002)(38100700002)(31686004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGJEVTZ5YVd3Q1ZWc0sxakRQR2pBVVRWeXlWN05xaXFuOWZ2eEhDdElKMXFQ?=
 =?utf-8?B?WStqV0JQMm5tdkYrdVByL1FoRzgxN1hJYXNubCsyclUwcHJWMzZsS3FqekN6?=
 =?utf-8?B?Q3NXUXJxN3NlWUdzb0NyMUJoVGdVM2dOaGNadlRBK1lVOXpKclhUVHVsZmhj?=
 =?utf-8?B?bXZ6ajB3RHJaODBNd1diYVlPdTFBd0UyV2thb3hITmZJU3dqMkx4dFNJdkEy?=
 =?utf-8?B?dk5DWUZwb0pxbEtyRUtycG02aWZPMU4zeWtzNlZVRzd2Ym56ay9Ybmk0YWlp?=
 =?utf-8?B?SVluQm1wbkQycGdGMWNXSm9BS21LZEFYU29JaHpJWlZLRkltekhsRHdoWW4v?=
 =?utf-8?B?VXNLYzFPcDRMd0tIWjBiZ1AyTHBCKzVGcGZGOWZiM3J6OThKTlRnMWVYcERK?=
 =?utf-8?B?WFkxWitLdlE5VFNLbElCYy91U25hNlhGc3BpSDdXSGVhZWVUb2dUSm1XRzVs?=
 =?utf-8?B?MUt0cTNaV0pwTCtLSy8vVEY1REZWQWplbFlNOFBxR1dXblZpd1lEWDVEQnVH?=
 =?utf-8?B?TFoxLy9LU1FLZVlvQkMyY1V5Rkt6V25PVGkzR3lUSXVEcll3ejhJZUgrc1lu?=
 =?utf-8?B?eVgzNnBDMWpHOUFpOWJ5ek8rcnNjZ3ZVTHpyZzBPZHJBOUxaWm82UURQRHV2?=
 =?utf-8?B?Q0dNMW8ybFA2eWVkRWMwd3gyVkltMnM1d3NhMS9LR2FjVzBGdElYaXhWWlIr?=
 =?utf-8?B?SzFtc3YzemZzQnc0TmhMWHN6Qi9SaXphUDN3S0d1K0ZaY05xZXZaMzFMT1RI?=
 =?utf-8?B?UjFTMU53YnFTNUk4SWYxdjJMQjNNNm42YTdBWkVQZ3RpY1BZZ3RacXFBMnZT?=
 =?utf-8?B?cGRVRHlOcHhUbGU5endQNGZnMU1EeG92d2ltL0NlZlptUHZXV2g0S293NVlQ?=
 =?utf-8?B?TVBIeXFIanFtdVppVU5zbUFxVjFsYlJUaEYzQlNDSENFZXp1QmZKS1VVa2U0?=
 =?utf-8?B?NHpIcWJHb1hqOUpLcERFTjVWRVd1QnRTK1lPRUIxdVhrUGgyTnNWaFlUMjBU?=
 =?utf-8?B?T1BnRGxnY3JwcXNHMUVXMk4rM3ZuZGJpVUZQN3FqVGJXRTFPUTI5cDUycVJ4?=
 =?utf-8?B?dXJLYVJ1MFdOdTRlTDZSUjFxK3BHelVZMEE3d0FpZVlvcE5RbGdRZzJiT1Ev?=
 =?utf-8?B?MnVpOHF1OEx4ZkptTnVsVTBRTm9ya2VrSWhHb05MSnVubU96WW9mZ3JtR1NJ?=
 =?utf-8?B?eHpTZUY0WkJjRlhBTkVxQzJJaCszdk5McHZ6RUdHblFKTnZmQmhGWnEvQTlY?=
 =?utf-8?B?MGV0bXFIQnlUcVVDTzhZMHpwajQ4d2RtMVNpUUhmTGNzajMxSmxzTlhaV2JG?=
 =?utf-8?B?TGtTL3NxOVI0ZzI4OVg3a0ZzYlJCR28wdGEvc2hEOXdHQWtUWlNoUHQyR3VU?=
 =?utf-8?B?dC9MNW5DNG1DL3ErcVpra2k5NVdQZUNXaXRKei90S3VRRTlaUUtsT2J4Qm1x?=
 =?utf-8?B?VTRWekNOaWNwaTR4SHA5R01uK0laRS9IRmdNUU1Ucms3VHhybzliV3llcDRO?=
 =?utf-8?B?bXpncEJscmd5UzY3d0xMemMzU2gydFBRd0RwVDVmSFg1QjUrVFh4NXdsaXBB?=
 =?utf-8?B?M0tFRnplbWl1RWxOODhzTlBZYjkrd3R2NU1VeVBBRjQ3TEtGVUVuTDB6NjZn?=
 =?utf-8?B?UGJJeUk2R3hTRHlJc2Fra1BwRHYyUVRSODR6bHFGZTFSTlZHQ2h6MGZjdGZt?=
 =?utf-8?B?NHlKekVFQ3JMeVA3ZlhqVFdEZitZZTF4WjdXM2duZWZSL1ZaRzFkbENGZExW?=
 =?utf-8?B?S2ZmUUVUR1R5Y1RvKzJGM1ljMTBnd0dQVW00cldzcEhRZU8zYkhvdXJkc09q?=
 =?utf-8?B?VVVTQitNck9xQW1YRHZud1VMb3N2YjcxVkJwWWhSOW9tZmpIU1U1d3pBNFY5?=
 =?utf-8?B?QmlXUTltYmtPUEpYTkoyRkk2Sm5uRWlFZ0dUSlJ6RHlhTzN0N1Vnd0pkZzVa?=
 =?utf-8?B?Wms3RFducjVoc2lyUi9QeVczWDV5TVc1NnpYVldkRVVEZHFVNlJQT21jZDND?=
 =?utf-8?B?MnRtbnJ4QnErN20yK0ZpcG4xS09xTGRobEJabHhuYXViU2gvdEJiTFJBUElp?=
 =?utf-8?B?WkszZDJuQkViOUVsSDNmYWpNbi9rVU5yQUhkTklhTlZYQWl2SWhWSnFEZzNQ?=
 =?utf-8?B?TTBPWStYUEluczEwRWFhSHFqV2cxT0dkVXZWNGNtQUFkTFRmNDZkS0RsNVlt?=
 =?utf-8?B?UmtiTUxjalRDcXFES3RmMERGUE9kbHY3Qlp4cloxUWZ2dWI4M2lSU3BFSGJl?=
 =?utf-8?B?Mjc5V0JDQ3lBRFNrQjZ1UHcvYWtCTUlMK09sT3FEbTlVTTY3TzNmR2tBanQw?=
 =?utf-8?B?bTI2QXhvRFBNbzU4SU1vT3d4UStKNUc1dWxHUW5WbkJqQlg5eHYydz09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006b4bf7-916d-4b89-fccd-08da31c39f0a
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:55:48.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0x+VQUGcL5VV+ue516z6xonQ6tqGJhMSkKQEYe97aE7hV5obGeLaSA5mz7LI4blZze7/gpZ7Y7r0QIdS6IhoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2995
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi, Andrew

On 2022/5/9 21:53, Andrew Lunn wrote:
> On Mon, May 09, 2022 at 09:49:51PM +0800, Wan Jiabing wrote:
>> In lanphy_read_page_reg, calling __phy_read() might return a negative
>> error code. Use 'int' to check the negative error code.
> Hi Wan
>
> As far as the code goes, this looks good.
>
> Please could you add a Fixes: tag, to indicate where the problem was
> introduced. Please also read the netdev FAQ, so you can correctly set
> the patch subject. This should be against the net tree, since it is a
> fix.
>
> Thanks
> 	Andrew

OK, I'll fix it in v2.

Thanks,
Wan Jiabing

