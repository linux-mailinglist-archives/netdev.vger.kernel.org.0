Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C7B6D4C89
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjDCPux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjDCPug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:50:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2110.outbound.protection.outlook.com [40.107.223.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBA426B2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlfwJqrH+v6hEGeInvgIIz1Zr+b01Iwh4CH8QY7n6BRyfd2oabDPFMyOM9gBm3e8ZfUCAdDxr4QFcEW21dP12RmSazxilHkkDcRfAVVfwLS/jNUGfnGQykyx7+d4F8eHUwhefbx8YWih3fkIttUucAeovYnWsh9RXm9YsHDD0N7gfG352kTqBPGRz/sOdOec+5m30+IDCfMtQU9KD+FrOBRrj46xuDhZNugt90dRxLWr2I0J8CuYV1QI3xojJTC97ufVEtxO0hT4TVqtvYhkHmgY8Sm5SiJqP26pJxU7j2d3pS5ROYONtUrPW23ZfZXcxuyJI7ZohsW7y+u1ENSxwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqVY6F0jfYOueB+MzTXuQ7bWNIViS283w5GEh1RZZBg=;
 b=KeY1O9PLgJH490uYB6YCqCAfG5gXETDKD3mHM0czgxNv4wIXcBg9Jt5CDFGqGNb9jH+SzRk31qwVsA06RovkKKBACq5ggw1xsX6k7Je71bNaCfHEo5Mbiz8iv7bJ0RQo5Jg+I5WSadYJirr9nzpEeGBLRgpHh6KzAw4c8l+/QjANyksUnH+qi2Fcvek/tgpu/3hD6LSTYkszm50nqOMilZIkaLRTODKfyU8mS6AviRsgiUMrCll+COXcu2B0FcUB3L2QMCk0L6DnSTOD/ekERgjTOVhaxPdNd7jPbSyfd5uN288pPStw3NjW95Gr55pE6NjRTUZR2KKBJfartjg2dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqVY6F0jfYOueB+MzTXuQ7bWNIViS283w5GEh1RZZBg=;
 b=tC1OYw2NT0AWjomhEKXcNyyxQvwu+O6PwUTpxyxvkE2XMkSi1ahKNXox0Owp6/WE8siTdx/CB5SwdFtv/eqCtqWsboNcPmBHKMXYfJXo6X2inXc4BYe/KSU727FY/KRBpMzm3j+xbQ3svdECP83OHX0CZAq81CdaGroJkTaTqHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5880.namprd13.prod.outlook.com (2603:10b6:303:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Mon, 3 Apr
 2023 15:50:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:50:09 +0000
Date:   Mon, 3 Apr 2023 17:50:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 07/11] net: stmmac: dwmac-rk: Convert to
 platform remove callback returning void
Message-ID: <ZCr1qnxCTCRUSky5@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-8-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-8-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM9P193CA0005.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b7e4492-d62e-4f5a-b61c-08db345b1a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmuZTHj3g6D4gaQuniY3mPYy8sor86jTazYJiwZW0M3k36xzRA8gZpp71bASxSafpNuYklwUS4luP3oClhNYLmM24ZGiUnpR5cdVQyJS6hSzCHeyihZE0vPuNfDKIna2MmBZBYcaml4eM6IfM6wF4Qu3qlkDXgj60mrYYwUpf1n/jObSnMeh05d01rdUIvTjDfCmon37FN6Ya3AIBryQwYpEPPheRNbuNCwrPkEr/+jne71ScS3Xt7IcoSumU7Rdpz7yGaubLSLhppMq61yTFwSZPpcI/Cm//32wv3M1ebz23FBdockfmpz5ugOfPCe7+ZEJL4xuyGo1z1abRFcuwWbkDuKh4tnWGj61UFw8WCHlWCj8sCbzPeiquV6BgzVI/OxnKZDwbbyGeF8FAMz+zCpTMYCCF6ABw0adnUnQqBiSDMnuiG2VfmQo3ekP3+Q0IHPyfPNnY9c7fxehfz/AH3H6z6BjCh5Poxsuf+gKxEkotAHI44oK8OZsc6bYG6LtL3OzzOcYSdsjtFDnveZmf0+34XsEkAMOwV+ORO3HCXW37umbmyzA2bRfQC1DxATPbaFtJODyQeE3vX53rzHX/oD0Q5a2yYPOeg3itMEK5dU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39840400004)(346002)(136003)(451199021)(36756003)(8676002)(66476007)(66556008)(6486002)(4326008)(316002)(66946007)(54906003)(6916009)(478600001)(5660300002)(8936002)(41300700001)(2906002)(7416002)(4744005)(44832011)(86362001)(2616005)(186003)(6666004)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3ZTbExJVndrZVRIS2hjaXRtK1RBdzZ4NmF6S2JnVmUzblk2Ujh5WHI3aUE0?=
 =?utf-8?B?bGpzQ0JCZzhWRVFjWHk4N2hrbHBtSnBlaTN1blFQSmNRSEVLTTZWS0VLSkFS?=
 =?utf-8?B?K3JuNlg0dHZqcU56cGdVNGUyNmNwcldkZVpaSnN0bUZEN0l3NWZrQy8ydWNx?=
 =?utf-8?B?aENhNFN0QzMzUHF0Q0dHL3VCYlJRaGw0RjZPaGRhN0U0WURsZjkyTGx4akEx?=
 =?utf-8?B?MEtTODN0bXVpMVJSUmdPby9qZlJHK2MyZnZOaVdGc3EzSkhQaGI5UERrUGpy?=
 =?utf-8?B?OHZRR2xGaEkxVTdqOXZlKzhYaXJya1lmaTVhS1dyUVpGdzhvQkVtUWI4K0lp?=
 =?utf-8?B?Z3ozOFVQeVFhOXI2bVFUZStQWDFTM3BnRGV0Q2lIZC8rb3J4Z3hhK1I1R2tR?=
 =?utf-8?B?a2lpWUFmd25iVVdpUy9qMjgxWEV5dHY5VlFWT2tIRHZXK3VKK3pyWU9NaW41?=
 =?utf-8?B?WmZXWmkwZkhOV1l6MW9VSkVsZ05uNjlzbG5SU2JsR2ZlR3IrVU5GamxwNGwr?=
 =?utf-8?B?VkMzRllKSlB0RG0zWFVIZmUrZ2VMZndFK0U3VWpMYkxtVlA2MWNodGxPcFcx?=
 =?utf-8?B?RTlvMDVKdUR4Wm1EQkhpT2pDNC9HU0tnbmxTc01CaWJBZUg1bG9ZNGRFVmNT?=
 =?utf-8?B?RUVaZHFNVjRRYUpqK2h1K3dHQnR2WXFxUDcwbHF4dUVpczRvc0FDb3VDdFRq?=
 =?utf-8?B?UTNNMGNZeTgvYlQ2MXAvSEljMnJqRklPRTZqU3dScDhTYUpIaEFwMW9id1Mx?=
 =?utf-8?B?Q1o5WlJYZ2ExcFdSM3BzWHY4QnFsZ3p1bmIxdWJjOHhQRnJKZjE0SGVDbnlL?=
 =?utf-8?B?ZXBsdmJhUC8rNDlRb2hmenZwa1ppVm9SMHFpNjVvcHIwcnRKTkI2MHkzMklH?=
 =?utf-8?B?ZUp6TUFyNW1TOVd6OVp2VmJUdWVxVko3REh0WUx0VXg1M3hFeWdXaFp0ZnVv?=
 =?utf-8?B?UWozQWY1VXVSWnRrVWNWNXRVSWx0YlRYdGUvalhuN2tsdzFBZ0tYUDk0QnFN?=
 =?utf-8?B?TlV0RUZhWFNJK1J3S2luY0R3NVByL1B0bnZoYXp6b0orUTBCaEcyOFJoSWk0?=
 =?utf-8?B?SmRmaUlFK09kUXA3K2dvQVZ6ZUJGYyszMFdRK3FWb3dWeEJFeEZGd3VzWkJI?=
 =?utf-8?B?K0dEUi9rMVV6NHdGNThER1MyYTZsTmFRazNXQ1F1eTQ4YmhXOFpKV3ljR1U5?=
 =?utf-8?B?d0MyYVlhcWc4K1hvWVdBOG1iQVRFR0YxN1BCclhxVHllQnJQY2xlUUlSU3Nq?=
 =?utf-8?B?R2p1NDJrQWtDWE9OaldkZkVNN1ZIWE9BWGZMdTFYOFN3VmNQejRYRnVWK2hr?=
 =?utf-8?B?TU8zaC82eFpDa2ZSTTkvb0tsd2dnak9sWWcyR2N4cEJxazA2c2RwZDdQd0dZ?=
 =?utf-8?B?TE5RWEIzamd5Vy8zdlB5TW4yR3BmUzBLbGRQanYrTWEwR01IS1JWK2N0cENS?=
 =?utf-8?B?WmI0S3J5WFZZV2lTM3hQbXJxMnNBSHBnUnZQMXBUNG8wSFpKK1VIdGc3ZVBi?=
 =?utf-8?B?L01QVDhWUk1RazlBdk5XMTBxZGtiVkFSSUhzN0RnNkxndm1QR1RTb2dvdWRN?=
 =?utf-8?B?VEZuc3NWZ294Q3pUNVpudUNVOWY5M09sODRhaHRlQ2tocGpIRVZrNTRMQzVw?=
 =?utf-8?B?SGNxZzdLWWZLeGg4dWNYekxGNnViM2puTGlCc2xtOHRSeUU5OGdzL3l0cGlZ?=
 =?utf-8?B?dGlQNm83OUROelNwVGV4QWxuZm1hSW1qTHFiSE1OTnZRUHlERW9oNUZXdjIy?=
 =?utf-8?B?SjdKQnZPREZhNFJCN3Zrd24rRWRCdVFjY3dNazJyM3FQVDNCU1dSVko1MlE1?=
 =?utf-8?B?QnFYbndFU1ZoNExFZEErRnJ1TDU1SU9Da2JZQWtaZW0vazZKMG1TRmttaVFV?=
 =?utf-8?B?YVJOazRXM2NDdlloTTJCdEhVV0RjMG1jd0o5dGNBbjNVOElqdlRmQXY3alRJ?=
 =?utf-8?B?b3AvMzJldlBkb0RrNm5oZzhvTkNuelY0VlZMbkd4TzhHbFUzZ1ViQTBzTHpw?=
 =?utf-8?B?dlNreHlqRjM2Z3hKSytvVVhtZE82THhnZUxVUlZRLzVFbkJJVTh0cGdveC9V?=
 =?utf-8?B?VDdESCtqbTVWKzdSQ3dFTGE4UWljZFcvcmtwMTlYQ0VING5GM0ZpWk84VlR1?=
 =?utf-8?B?VnJ3eDNvUU1CMkhJTWVxOFNVZTBqcCt4ZE1BdnlZaTd5dFNheXNXV1RjcWZp?=
 =?utf-8?B?TkR0SzhVRUUwaW1jWEE1c1NLRDlpbmw3dW5RaDU0cmMyMklCMnFaMmxGQVdK?=
 =?utf-8?B?dGNBSTdtWjRHWVZiTmxEQkRwbjZnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7e4492-d62e-4f5a-b61c-08db345b1a1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:50:09.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJV7StEXEO4EaRG2j8IE5JvGxekzXVB8hd+0VCicpzNN8YvCoSE1rrS5GE3KFQ9JJbtNhwOV5CF0j6lvc36WOveuKSg96RZS6EHZoGw67Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5880
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:21PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

