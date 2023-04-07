Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D106DB058
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbjDGQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbjDGQNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:13:24 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2092.outbound.protection.outlook.com [40.107.212.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438FCC154;
        Fri,  7 Apr 2023 09:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1EVSJZlPQc3GdR/AlGoVdAd3kyvLbFYxkIo7uGLG/NZ08TeZj552AhmaQn1zZavkPBQwjkLlOlNiVe4OTQ+ZiQ8KmYS5Icl0tSKntVxbeAfojf+um1MfbVBQRkHGM3ucOI2YZsDTI8TalfYHSu0TQ+D6Sx/3TN2PeMJbXjxZKu42KUA8cmPuCQDV8ldJ71OP4XYeJ0CZ/8CyoofRjH2dmyPgKkxb2yW8aTK+PIn+vZlhUu4ubYbs8zoljChcwhu0xwnd5z+MLUprRQ0pXuARHqO43PpnwM/BgUtauwwGSsxLtHMfbOAIFbxBSLmHh+PnC6/gIjqbS4SkVD0gDfhCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7V2BXXQdP0F5S7rWoPyERvFGB3FY6rQwEHUxmHGLhE=;
 b=jV62hU2TXQJyqGci76i/66D9FId1K8l2LjHkiV0mvw2dLYMZDGgeGhBViUujHbZTArryFZ518HTxmYobk31FRMYLskwNtb/bGF50JB5fW7kc4UZjq5kTKMKdGqKEFYDiclYGqbd968LPLV7IM/TYvd9EDjH/n2pg6CLseuLIXGR06jRwDAdtGeen4EDq+WxHfYZ7a70M7megCvJw9OQqpp099YNk7dNSTp//FC7AVonRzncO1tnFqPPPmYwsDHWD1Rk1mTBcZz/3KG3X3ChssHnFZZ+kZj4EUEb5a+UT8ja52bClk16tw81FCwrcTn2wkRENCqtkq0ovJeNN+QkxaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7V2BXXQdP0F5S7rWoPyERvFGB3FY6rQwEHUxmHGLhE=;
 b=Fc3Fwp1WNh+v9Qwgj5w5RxvLlbEQ3dPgZzz1F17Yl5XGetx/EUsyCseBVsxf1kNDr0ejmQ18y8K2e1M7RupTrS/Vcg/yFbcPl8FTtjdVOnDQXy9lUmCUzeNgDx/W38Ftl4uXLY2adf3fRYJKAz2+kKIvaQEpfFlAFHvQiXLTg/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4916.namprd13.prod.outlook.com (2603:10b6:a03:36f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 16:12:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 16:12:34 +0000
Date:   Fri, 7 Apr 2023 18:12:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jia-Ju Bai <baijiaju@buaa.edu.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: mac80211: Add NULL checks for sta->sdata
Message-ID: <ZDBA7Ay1Y3Yr6Dg5@corigine.com>
References: <20230404124734.201011-1-baijiaju@buaa.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404124734.201011-1-baijiaju@buaa.edu.cn>
X-ClientProxiedBy: AM0PR04CA0068.eurprd04.prod.outlook.com
 (2603:10a6:208:1::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ce5b16-a053-471d-51e4-08db3782e5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ouWUxLfCMGy65kAbiTmKC56+SYDDTJSVtMRkUAW2sB4XbKxtsPUhR63J+xKFVXnrP1sRoYUeR9MhPnVH56hW270qZ/ILQ1CDCX/+vWUWB8Usjnx3KdIWqepXifAcqUcNw13nT01/kxybaPq44ZhCKo8zfi8tXOndClHLUs8tY0OTGNdJk/k7GBtGxdaghJCIpTewHsmEOiWIMrUNXkxrYeRVDNuuq3TGe02Er83yRqFAS2HoPqgfHQGWgvHfqtWVnfm4IiPBvxEb1xybl48apcvIiUXBbXULdMY+qrCsg/YTOA2h9qyECkHfS2yW7dP86riemePnUYYfGnnPZPvvd/NE0ORi1a93WsPqqSE6r32PMc8AaUX/SHTDjD0R9e2DumGunEtP0fNgTTMewVRwVfkZnJxmymtbxelTlPEQMvOPxvYClQBia2RIQ6GRo5MuMRx0DfjmKLl07P8F73LFyOu2m0N4F0ZMjm6+rL39/SqlVgOxEnVUQqe8gM6+dELvY+CBzekESyoldstAlhYJo7u5Xru6PYygLcv/vg46oFrKosmSUh+sB0kxQFKM2UZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199021)(36756003)(38100700002)(2906002)(4326008)(44832011)(5660300002)(8936002)(66476007)(86362001)(66556008)(66946007)(6916009)(41300700001)(8676002)(2616005)(6486002)(83380400001)(186003)(6512007)(6506007)(6666004)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1yN6x9cZ1f611fI9YGxIZW6FN53XBpTZk9WFXqtuccEWTRnOKQaTQ8Q8SoBk?=
 =?us-ascii?Q?w5aq7Zimo+Bax+brdrEGJrqnAmTb2DZaXIMgroQM1HkI30EhHCQqeCVACZo+?=
 =?us-ascii?Q?ItKQM1PFa2vBGnbMYn4vkyXp3FiYTh9XiVCzd++aAk3pC/XM2Ha7DAtaasY8?=
 =?us-ascii?Q?FnqNn9XpxFUgci9tgzpo1cAXEbqgakyH3z+RTuwW66JLKEYXx6tNBffMIrEF?=
 =?us-ascii?Q?Di6KWZDDjgp4e7YmMwxdsgikzSGymafC0GlcpGjTbn8N/c2cylqUYI9roaWV?=
 =?us-ascii?Q?BfC8fLRfTeCbtjgORWzJRIBEqE8d8QVIoeTU6XlaOaLBBnCh3RQMj4O9ISzl?=
 =?us-ascii?Q?6svAPFjjF5xdsJGGRQV1iz3vg6lhb0hyuHUFMPHD7uzRviGt5TJPgA5eI/k7?=
 =?us-ascii?Q?xwNgnWoUVBxutTVv8wtbpjXjNA0GYMiS2mg8iH2axH6dlREQkLbxTpIiva6P?=
 =?us-ascii?Q?kT159LKodN6TRlQNtTWUpqI4AgsMbZiXtoRCqS6VYjjk3eMyPmnsGnthgmaK?=
 =?us-ascii?Q?76yZEVW8sb7v79Qgd4ngfBget0Cl44F1m2Kumu8zYlM4emMmMKIzX/dQ550U?=
 =?us-ascii?Q?VBWuo5Pw/b5OjsP8Bp70k0MI29y2+4Lhtg5TqV5SkluZ/0S826XK9u1zV64A?=
 =?us-ascii?Q?KKniTK0R812cSxLvXKqLt3aRJayTMwUfq7vgGuksIdCK2Sq2mCPOVIKP9oAx?=
 =?us-ascii?Q?8MlAOlmWtPzVR4mofaq/am/KcwRieostdNcPIKTylm+khc0+LL5IH1/FuL8p?=
 =?us-ascii?Q?9LwISjXLvLuZ9NgL4hKtp2YMCNkJ5ZYoJpolcvY26PCB63TtzJjXiTPK25nG?=
 =?us-ascii?Q?UYt5zDjbVT8MdMQVHCvuMzlz6UH/T/9Qh1IrU1QDls8oi8UlLC+ElaLQnGOF?=
 =?us-ascii?Q?WcmRqguMizIuuxNKUhKeAWLP7roUyHSY1zVf9fWLzH81Z29hBbAHMWItPbU4?=
 =?us-ascii?Q?iHBIP+TtY8yjWJjkEM8nbFfFA/r5FO8Hn+iD4uJHWrxxJ3hQOcpigOtMn8nr?=
 =?us-ascii?Q?dW08Fv79x9Bh1UznHWW0dd4qzQYFC/iV9TK/XXtiU67d1dJIeb925z6uofcs?=
 =?us-ascii?Q?A8IM0BYQg4idVSCQgcUebn6P8vZBADhXiT8OxFrpLCpnSKM8qp0K4yvlXfJ9?=
 =?us-ascii?Q?bgSY1LiMJUFC4nnzW/C+K3SSfrY4czWFTYS/eeuQqHThkBHkBPUMa6y6Fga8?=
 =?us-ascii?Q?ejvSGpid/yW8kEVAEE/dJP1eFZN2yD0rK5Z92RHyEG3ZFR/IbV7BDb4ugVsg?=
 =?us-ascii?Q?YPwDQNH8r+XDB374b2307WYoTg5ZOA7+1wN4qPUFdyT1EeRl82I1OQGzjPS/?=
 =?us-ascii?Q?J43jIYp7C2J8nAk/8MIolcHtCXS4JPJTYCiI4Y4t23zvFnqlAIYc3u+FNL2E?=
 =?us-ascii?Q?UFvyciumKfm92LNbv4c+mFOANLWlLosC4qhGrpXWAX41kp0LxOuM2dQEV9BX?=
 =?us-ascii?Q?Q2v+8Eslmdj5h4VYlM4DVgaOhTzAcEotV4CPYXW91DMNpTo0FQpFhCjF/Vn5?=
 =?us-ascii?Q?o79wPUgtogE0lMCHdrQCBi/Nnsct3ASSicgWZCCn5NiL16y9qD5grofLtcme?=
 =?us-ascii?Q?k5esodGmluFvdO667y1Yoq4AUhz6f4BdT+ckTg/c8kZHtfEgklPmswhrX2+M?=
 =?us-ascii?Q?qllOM+DVanFvMHBz/N2moYfX+C4xqfW7UhEoAMndcDrjsK3SxhwqHxLjlcOq?=
 =?us-ascii?Q?JkBJJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ce5b16-a053-471d-51e4-08db3782e5ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:12:34.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TC1blobenalb5SCrqcmRxS+wcZXofLr/5EnYXyAbDQ8N6ry6ihI4mbM8kc7IdqCfHzvzdBL1s7EAQO73rHCL88gIjbZN+7dBruF0xJfVS1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4916
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:47:34PM +0800, Jia-Ju Bai wrote:
> In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
> during AMPDU start"), sta->sdata can be NULL, and thus it should be
> checked before being used.
> 
> However, in the same call stack, sta->sdata is also used in the
> following functions:
> 
> ieee80211_ba_session_work()
>   ___ieee80211_stop_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     sdata_info(sta->sdata, ...); -> No check
>     ieee80211_send_delba(sta->sdata, ...) -> No check
>   ___ieee80211_start_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     ht_dbg_ratelimited(sta->sdata, ...); -> No check
>   ieee80211_tx_ba_session_handle_start(sta)
>     sdata = sta->sdata; if (!sdata) -> Add check by previous commit
>   ___ieee80211_stop_tx_ba_session(sdata)
>     ht_dbg(sta->sdata, ...); -> No check
>   ieee80211_start_tx_ba_cb(sdata)
>     sdata = sta->sdata; local = sdata->local -> No check
>   ieee80211_stop_tx_ba_cb(sdata)
>     ht_dbg(sta->sdata, ...); -> No check
> 
> Thus, to avoid possible null-pointer dereferences, the related checks
> should be added.
> 
> These bugs are reported by a static analysis tool implemented by myself,
> and they are found by extending a known bug fixed in the previous commit.
> Thus, they could be theoretical bugs.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

