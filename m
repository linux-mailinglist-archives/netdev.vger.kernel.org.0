Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D056D9890
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbjDFNtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbjDFNtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:49:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2106.outbound.protection.outlook.com [40.107.102.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49E710E;
        Thu,  6 Apr 2023 06:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVSR0FPFaXjzNhipHPVgjg6PrsJHXb3Lns08sWV9eZEEJgLTllHiRRqV1tv2pPUNRYmE9TfK3XgCKTP6ndiuSoyOAQde3d+UJPN7+xaXqI0bnHiZczAsiJZDBQ+1U2zDValMgwbrITWjori1OiSoIIH8kNruScG8LUblz9TPvui3Dlq4gOyUXzIM0xBPxmvNzq/MzWskX7vzWX2K8pdpb5o75u8w6n0Hp+ySz1FORR9G7W6mEvOv81T5OXLPixxEkuralZe0AOl7j+KkqxUCzF7AhrUWUq6OE103YEySuH/3FOldkfoAkmzyxmPk2pSSIs7aJOe3qcZ13Rt2O5UNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP+DgAHzoMrVpS9C/U0qHKsPpkYzCdhdnwBg/4c9lBc=;
 b=MDdq4/aKqQmSxVX79QSdqfCU2N/lidhanx6YlfoX9FdI03jU49pRdHrvPrK5ffpoV/HyIaPBObh+rR/CaK2aFhXiHlDQGGHhAIn1fsK0tW7xZUfd5yvufuRhpqIwvKXxcB3SHKwYogwMxxvSK8aszEYYqnxxyOhspyOcis+F70N5HNwOIi+ItN7JwA2SttSBtx2Hq7ehIExvbN+9NV2c2goUV8l9nr1+GRm226SKgGp+n8kj/WA0GUQBZ3L8bVoA7xARLLR03TnCnFfzXeIXnGsX++c6ozecgl2cJ9GVtNcwQo1ZfgJoXly6W0KvFOP7v2dkmWL+bu8B+syGUKAtNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP+DgAHzoMrVpS9C/U0qHKsPpkYzCdhdnwBg/4c9lBc=;
 b=KusKnNKL6Xc+tQonhSAteWK6HH6voh45Al7H2gr4i4uY60azDNf02Wuq4aPpoR4bE2mlCzadxuazxBg3WS4wqE04aZl90tXEdf+bLPAfg2+nzk2bcaJFwwjSozmyCOCQZy0JbztHmFFENemkrBfX6TTYV8KaFhbRJAdLeGd+ers=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4821.namprd13.prod.outlook.com (2603:10b6:303:f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 13:49:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 13:49:13 +0000
Date:   Thu, 6 Apr 2023 15:48:43 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Message-ID: <ZC7Nu5Qzs8DyOfQY@corigine.com>
References: <20230406131127.383006-1-lukma@denx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406131127.383006-1-lukma@denx.de>
X-ClientProxiedBy: AS4P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: 06ab6901-0cf3-4915-3e8b-08db36a5b4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPCshRjAzaxnAFyM5by5sf9Glov1Koetbr7Rr7xF+r4V8OsUes2dLYz4NCWK2Wu2E+qfQand+Mlx1w/72TAfCdHkzVR3lk6efwicqsmFw5Os7n3rEN3DVFFifVz+rR+Ejo2dTTuMJtPMHpiQ3KyNfNeNk+7olBgmKB7zj+4PlfVcwOiqbuzkzScfTLhg/LmSfuGCDfYRwBZZBcSfkJG+AwTGnytnMaQ6jAqdiMswVvgzRAN8F/18PApki28qgT6gTWbJyQGHV3vn2HL0m9MPvL9cjFMj3OpGrgc+j9YwR4e/PtTiH0oUQyALEcHAlXKqHeb196qW56ofodULCIDQNQFiL3hJAfEdbs2zxFgXNWXGyIahiYUv2OuTK9fFY+tHKsHD/qfOqHCbPLtDeFTbCcYtupU9OnAwXw5vDVp/i1env9foFTpgpij9FKwvTYoudKn/hSwsWykdF6NtVdz8NSARkDOox2YA836BdlJlNyrWu8E9SbSVv1+mLRN12wAc9tTxm7Qx969kJUQGeryfp+6DiiDz7U3bUM+54tTG96gfM6jA8SZ4YdQe3ZnxRZ+2egyZk+SC8roFy9lrLFH5csXpPC1PFu/45G8o5xlk22rTjcQsF8oASSIqQOvzXveSOuPUs2TJzL9P5bZKmlphkh1vpuyEcNRqFWEusJRkO0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(366004)(39840400004)(451199021)(478600001)(316002)(5660300002)(54906003)(36756003)(8936002)(4744005)(2906002)(44832011)(7416002)(8676002)(4326008)(6916009)(86362001)(66946007)(38100700002)(41300700001)(186003)(6486002)(6666004)(6506007)(66476007)(66556008)(6512007)(2616005)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kbFdL6aVQrwWzPRE1U81YEcLSLfQgfeixY02KJT1Oxb5d4wXrDWv1o4xlPHV?=
 =?us-ascii?Q?rnUSH5axBuFNUDuIydI5B4jgDpTqhObc7rBa9dlpPw9UCkWKuAwCMZAhT78J?=
 =?us-ascii?Q?AYFk75HjPJ5GXXhyx02C5ycU10PIIbJnmv775+DuhtDaZR5yIhqy35ByVX8x?=
 =?us-ascii?Q?RCRf1dcoepO8FabaUKY8FWZRRJC2sWjbtvawZASsZVZ4VFtFoOLSRlZUdtXW?=
 =?us-ascii?Q?9+xXjeeajC56Oi1XwpNbdYrxymrUL3JEGX6RHxvlW4AlXBKqQTdZo+vhaUh3?=
 =?us-ascii?Q?YYDA+bu4K3oLv10Lybuxg0bPWdKGqrjdU0WSmAUxhQa9WYyszH2wAEaqDwti?=
 =?us-ascii?Q?wdLN28JFU5TVdyWK65YKwQu681unKel/T29nfPiWkqzP0cccfnHN5PHSMrFM?=
 =?us-ascii?Q?ZwFV/kNMDE4V1aGBMZAyO1djmbwjSovAeVM07dJyGBCqzSN6U00f6jM73z7F?=
 =?us-ascii?Q?0XXAIotEDt6XnTvDY8InnpPESmQVqG/MdiAioTzH3n1546fGgGaV23nX+0Qq?=
 =?us-ascii?Q?FfmAL7KHmmWT558JO63Ro3Eakbrj+R+dMs8KYvvmFXIJqHX99pdUQEau0Wfj?=
 =?us-ascii?Q?2vFpydzywy/ri9HRJuEYKY3OU0bKIL7fYlw6LaPtTIv9L8KWdgdw8fnqxzo8?=
 =?us-ascii?Q?or2fdytD5IEzFw/f9MRQiaI5RGSz8WAqiLR/wD3gUbIRMWGH2B2WC7FuVMgC?=
 =?us-ascii?Q?xVM3rbLvyOkkjiXKApISR4OZ0j5Z4LpmUkjoSNMRv8UzbPJMGuwHFh1aOUrj?=
 =?us-ascii?Q?gfnOGu3NYRx4nR6sxK2VKbuQGtKFjZh9FfCVJkv3fDovEqhTZqtkMu8GToZn?=
 =?us-ascii?Q?4GI0JUUtrfzmkPOTPEXRWDSsodhnIVXzR5l/8sPUFQZc3mGVRpbHb2xe6F3r?=
 =?us-ascii?Q?B/2fV1vhUmaeyKkFmV6ijH7B7O8hLQ9OiWkJugfiWB8LxPYyfahx4c/f5tbY?=
 =?us-ascii?Q?fsiWs2nBpJrcbiZcktlVpWqGhz8BwXCP66RgQaN6E2LHBOTkxqwG8B22LJis?=
 =?us-ascii?Q?o/bfFgXOxUib49sFIf/NSO9DaX13ZmmXqFhZMWX8RtBHx3gLVfFlN5HwQ8C4?=
 =?us-ascii?Q?dYCiStBTL606CRCgN7ZWpk5M8BVLRqRkHhudkzCt2a8eX8J2zcXODdIhPrNQ?=
 =?us-ascii?Q?LNeTR5ZcnxXILnM7UujJOFVMcCBTWP8lO8hABRBt22AaOvORPRK6JPJ1Gxur?=
 =?us-ascii?Q?9ibh6Rg1UV6aaroKRxgEePuyYxb3M218LJJ2EVLgQNooPkOWCQghwBlZYNOc?=
 =?us-ascii?Q?m9fCXlpH9YNA5E2EfQo6xKHyEUTtUsnlWaax8OohdT9xvPYvoRFuJ+iMIT+t?=
 =?us-ascii?Q?4kRXxjYBcz+TobnvWAHU8aGNUqpt7v8UtqRwImPF628UPnlZYrC7dHTnpLO+?=
 =?us-ascii?Q?Dp8VRQUOSWNHfEU+b91k5wI9fe2l3fqOyP1NFAq5kPQFdJL+DiDUQBMAc66+?=
 =?us-ascii?Q?n2F9yqZJTLQ2xdMgnGnPR+QrKHRLrdlqrZwY4qyO+hbKuR4r626YAXwYGMQh?=
 =?us-ascii?Q?ehBiXKBFC+HEKE3SEb+8J3/hjjzBVSnoP6Y39XPUyvYDl337/Lahj/Yq8T9v?=
 =?us-ascii?Q?ky8+BqeHzLPUQRGfAbyLROSeRe70/MkNx/scy7D9I3A4v/yNWPowcuftyjis?=
 =?us-ascii?Q?NY9Zu1qV8fYfEnXOEbCYP+h3xq3aw1FVWNvpIThja8yPoKVRX46aTp0BIKT5?=
 =?us-ascii?Q?L8crFA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ab6901-0cf3-4915-3e8b-08db36a5b4a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 13:49:13.3631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6vvlRJ10lCO3GqS0PuxiBSik0LxiA0LLYXzYKHe9Ows6pE1TrGbfqPtcLsN0dTqI0VtFJ25ns/kcAOYYRPXErJPjJsH4tiD7U1ADfOOXao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4821
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:11:27PM +0200, Lukasz Majewski wrote:
> The LAN8720Ai has special bit (12) in the PHY SPECIAL
> CONTROL/STATUS REGISTER (dec 31) to indicate if the
> AutoNeg is finished.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>

Hi Lukasz,

I think you need to rebase this on net-next.

If you repost please also include 'net-next' in the subject:
[PATCH net-next v2].

And a note about the changes between v1 and v2.
