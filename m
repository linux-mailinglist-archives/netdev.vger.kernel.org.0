Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498A96BF8F0
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 09:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCRIXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 04:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCRIXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 04:23:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FCB55B4;
        Sat, 18 Mar 2023 01:23:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HItTlbRlzIa9pty1VKRnzIoCJsOIklJ8a+oURJQSE4LfbzabBv6AmA9RsWkTnQTYdhA7TRadbmTwW2IyhcSFhBZY1+DUSSyxf7e2WrODrFxOpxQe9ZNXLTPLikO883A0bWDLKb/TYKXtDQ6vFmbgaXa/DyeULm7AlX3IcEonYAMxc7d2kZPB/cI0teGLHElvLd1HmiYYv35q5VmkpSqV/jAQh7wbFZBVgxQXr4BbBMAdEw5RrFkUB9/vgYu0k+0c/Bi379h+7cgQAWgDaFMGccrvZipPR4qQO/51QCqTWEjAgZyVsT+zykt6lHJoKemSTf0E8NtLxZXagpJ8E9hzeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duty04dWpYVvzJllBy6v/F813BKg8Fvs4S0Yack++w0=;
 b=TrB9Fedm87iZI/tA7stzpRLwYAL8rOvliVizxYEuDa0fvNvQuCHJqbbWiuml/orld0iDqgbWSaRjJB9gxzw2a6p4sRxOfhWjNkdSrG0M7wPMSa/iMuGbfMWLOj+FkV6oTgS4pI4BECH0m5aCKwCZ8OoY5sxSXqdvMpFn4ZFUZRthltlxeWC0ZLG4f1+DKryFoTSTyRaow9Mq395FyeHFtj7njU8HCuslKSpIQcv0LlxLXwjqCtUbaUmgqu34ybYUitdtWL63YwyPNfUXuQ3wIE/8Kt9qZanyFoyYQhHkniWRWDWp9JhBQ8HKItdb7ZXrvejMHiXUMY+TgQU6Nh/S4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duty04dWpYVvzJllBy6v/F813BKg8Fvs4S0Yack++w0=;
 b=lShkMagUIsahr1RL3sTYOppevA0N7FN53TWxtcUZBKCGHs9pbprTx7Gb9nz/yjz5RDwFgi3+dezatI+gxFk3JyZyHpQrt7C02xgKn5yPn5G8VUTbDpJpXZj2JgNuOakHVYshl0JpRoEyEqi/8/4EMZwzU2jg+QbMMBRYPNQ2BHI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6147.namprd13.prod.outlook.com (2603:10b6:806:333::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Sat, 18 Mar
 2023 08:23:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 08:23:25 +0000
Date:   Sat, 18 Mar 2023 09:23:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/9] net: sunhme: Switch SBUS to devres
Message-ID: <ZBV08tXa5g5PnSP5@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-6-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-6-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR01CA0119.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: 33106112-38d8-407b-5223-08db278a0b34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhiYyCHxLVOsDKj/RV8y9w0x72pYZXHeMHYatWM9UeeB8U50rF32Ygteiy1LnQLxP9F40Y1xtxHvog4EGZ3wQGe5O8p2E6kdftZlXfOoBHgmNs5erQ9FWrhzuE50W8gPNculcpaTVVOiDv/R647YqrjSP0XkIqngNPktv5lsNxBTi11CEDYwWPHosB62RTkqNJx28de1Vpe/7Z8U0V7tCWv8oNFJMwK8ROIgv8OPHkutK7Is7Q2leuEdIaflGEDpG+9Wd6cYpAtOUFLjF/4su1j2VG3/9G+wRU5VbVwh4kJblrEFkQ8RKwRPsrKPUc4OJ+3HW5+6m5K27iKxNtzTxyXuVeDV6ITNsEq7k62UbMpyQgs3iTArN6fiPKIO7quxDgqBJSiGoEpfqNbfzgzWNy/YSH89xrRnXHmED2/dB5U225Mi9vBRTmQDTgy3EYh2oo0m5w50WGMQolKMSlqtLBNjUSvrI1JOtZQf+TviKQKEjlye/cz8uFPSpjE26GELpA9w4CI97a+KxQgGFw3gU3uXhmTfZLR8V1XHllBQEB3XezE2eSk4P4UpcKPnCoQICs85glCCj7ktuXAjqppEn1ZSFEkoruU62NNgHW9EqtoLdVhH2tgaoiLgztRPk/eenclkap7QF/s5C6jPMfjJgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39840400004)(136003)(346002)(396003)(451199018)(41300700001)(2906002)(5660300002)(4326008)(66556008)(6916009)(66946007)(66476007)(38100700002)(8676002)(44832011)(8936002)(6506007)(6512007)(6666004)(558084003)(86362001)(2616005)(54906003)(186003)(36756003)(316002)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pF5alWuGAuMZ+O/tu9kDpJVvr30O95s5yGLSkZLwe+UE82+KcRONSqZPdqiG?=
 =?us-ascii?Q?hxzSJ1WodY0JgPIOwKLmVH2YxvqKSc70hGKBIKIRXPnTge1i78ZrKj5qDzUz?=
 =?us-ascii?Q?92ejLmzWutL796w9TOnZ7Olxh4O1UnYYPb/vcYtQhJJRsOJ7eqXKLznx5U2r?=
 =?us-ascii?Q?jSwJBj4j1d0yCddiCVBy6CttoJrPtAsHLVOuX71xvb7jb14GNwol1w+kBJ2q?=
 =?us-ascii?Q?ndgJj1HYacH2W+QNpwEb1JpNQMRmb3uwHs7qU3RMRoVO7i5GmGetkbgiK2Ko?=
 =?us-ascii?Q?7WPUA7df8cvOAwStakyHG2eEibMndcimSxYfYO2M9c6FxU3/7TrzLVNoH2Xo?=
 =?us-ascii?Q?ZVimn7wLbPyI0nIHDEPVVdR3Mxyr3s8fgUfyCOGj+sEFCSiixPCPjPJwO1bE?=
 =?us-ascii?Q?LF5chRGJm+POb5zqNLb/imqzjJ4LL3SO3fHAwVfc91DcQUHwFTLnJQeybyMg?=
 =?us-ascii?Q?jyZ0sADhBF8vG9lPcf1HwAM9+DYCvQD/dAoMadKCxXSL0E8bmNzWSJsTosn3?=
 =?us-ascii?Q?vQUX0MyyyNLo070hlgMTqDrvEsj6MqjEnMcVmlO74AjmtgK7/U5g3eFwzN7U?=
 =?us-ascii?Q?cHIbA3N+66Ko3eqnHHCTMnQpRWbwYfGgfNo8prQ4/qY/p6mWwPQqZSGcOCdK?=
 =?us-ascii?Q?fepz5yM2w+1sxuWCvW8hsssDo0kk+dxTUdK3ksqpoKZnYhQ7Sf5EFlNkZl0Y?=
 =?us-ascii?Q?wdc7EvEj/NDRil17n4yQi2StA8KdSbFgx7+2WuXBXpgX6FrKSqmTaz8zmk5x?=
 =?us-ascii?Q?VMQ5oBlim5vlwsCI0cSfSBIycH6wEt8lMw2PR01zhKzIPNWbJ/tXOdwgsN91?=
 =?us-ascii?Q?MJwWtITIQWrhRfWNat6YmknnWLs99ixS02cslzA3bg9bvN0+NMrDX5AzPThp?=
 =?us-ascii?Q?LO3zZrAHIHnIFp6BWqhQCzbOPt5KUvTsNiFeCP2OobL4lOfDpu+vzyYK3g4Z?=
 =?us-ascii?Q?6R7ub/XfB5v0IgDnDljltkKJTUYRagSgzSAb0uRPrHtIqlnmEHFxpzTWedoV?=
 =?us-ascii?Q?U0iYRM0Pbt2DrFGSWtPZ12eK/2DfjqJ1At3pcAwvPelk++TyQRYmTFzd/WZN?=
 =?us-ascii?Q?qfNc7Fz//okLgjx3cjPXgJy6qrI2YbpIz0/QmfotC6CMYuim694QTmdG7WzE?=
 =?us-ascii?Q?TgKuiZh1EBToEuNEOv9MPfZhPjJ/WbwI97E1UuNqUbpk8yDG45K14gKfcyO5?=
 =?us-ascii?Q?TAf5gDZR6TE6DBrEdMzpTQDB2C5U8egQa9LsurVraKWlhuPPLl4zlvPh9xx7?=
 =?us-ascii?Q?OkcnBPUqcIddSn5t6/mZQr4bhtFU0wX9kcTleufMk4S6MoqEVv4fpamdi0eX?=
 =?us-ascii?Q?LEaLdMQtG2nh4k3onzvq3/wWjYFPfoXcbj+1EthaugjTA2DXMHp0ja24qWzo?=
 =?us-ascii?Q?6w8j9YwMzAhURmKBzRLY+8jJUNkTs8idhyG0Vz1AJbJoF2mxfvZ9POy+N8lG?=
 =?us-ascii?Q?cH06J+bdGe8xI4vo0tjTwcnQyc5K8UYbuMfbCGhOG5TS3d5z8PzVygYIWd8/?=
 =?us-ascii?Q?Ypvbm/HH1DXkJJL0xTA90dFKM+FEAW2QlPKWcAkcsOg1PZ/bQHrjdSAZYra5?=
 =?us-ascii?Q?gsdTL8XCuAdfBMgS71nTD2W2VOHoiPjYu5HBCq8f3+YqZ12ziiAoy/YmAk8A?=
 =?us-ascii?Q?DSIx1UOFDwLc3xZ0vGBAQm0PkmWsk4PMalzBMwMoaU+CdIpBExSLBcoUtPAe?=
 =?us-ascii?Q?mmkXlQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33106112-38d8-407b-5223-08db278a0b34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 08:23:25.1892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7CqIbxQffRU/Q/xa5zzy65Y7n2AHYBPqh99ux+WvDbaaUWfwgEmjanToaNjQVeRjeTz08lKrK04bg60H6Bv2v5UqD6Wk+Xw+lcA5uN682g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6147
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:09PM -0400, Sean Anderson wrote:
> The PCI half of this driver was converted in commit 914d9b2711dd ("sunhme:
> switch to devres"). Do the same for the SBUS half.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

