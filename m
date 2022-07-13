Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C01573D1F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiGMTbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGMTbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:31:42 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558952A701
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 12:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksMOycTlRqgbV94+LjAaj33Nq8dzVUbg2S2lB/FncgF7HYZZQRIRp7sHu8rGmMvoE5zMrlndsEP2xsBx2StOdPAPNMGHEYTiKFTVo2RuNQFI7hsg04Fe5wTeblPBa86UNiOPgoDoQUR8dnBkaCRNjRb7SY081veicSDwSl4ogCfKU0sAwNPRPF73Y3T9vnR/VbJquo+td0U3RIxWHKDRTzRdcz2FbSySaMTjkpxDtnYSE9ZGQgYzuoi+saS5ppqrrXM8VL3O5+4P1bQaBsSg22Dsfi8rQA8OnmUVoUVUmFtNLlPejor2Na6eVQtIvMWeeK+fm2JgaXNVdOsyOV2Gyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ukVdfw++Fv29QXZ70lkOni2cs9znU/edQ5WPx+e7Y4=;
 b=j9YChWoe5/gYUZtV6QccyiuHNlfWaFHjqnWkeo5Y7KJSwESO8nnIaFmdCkcMdmOrGYpjR1QTl3jvZJ2je+NmctAJHCmkIurFBqLeILjsPIzSGDvMuE0ZMyMw1znMfVrACnB1wpZPsgKgDgS/Lr+O+iyC3h31pSiVe/fv+WJsXgiMWWUhojfZgknXlP/MzrEMqIfbJ/ejxSRiAX+xYUEhJh/ox2vfNG+I7rPj1AepMiUWU2pZ72GhRFOqJIE+2TRDy70rk5y/wZm6dOK1NcdtFNScrCcNhTYqyDOQuV3VbODoXXCnXJ3h4MaeF8G6YSboLm/cG4vfti7nGHuVe564Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ukVdfw++Fv29QXZ70lkOni2cs9znU/edQ5WPx+e7Y4=;
 b=gMOWM8MDHuuhMWcZRv82q6TSdJTTbklrk/MVuxMWHt+k8/eUG/5os9duvzmWLLSnWUXVhAVYnbWm2RayuVpA9WkOnV3rOC+9wIcKY9XBWfU2CBBvak+73gidmFCzygfsUYNHs+bkjbS04E3t0QWL0kOFHh3L085Hv8ok/ApqHW1gDvT+dIr4a9HmkHcjTAAcYXgtSN5su4PTUSNy6CIE06CXNIIgj4nD3lM59wHmIKWQcejt5OGXxzsGymMGqYc39rpexqTKONM9F0l11x6LLk5PLNwObQEiU5ujwJWSinqb3JhZF0PTcrsO0C7ooTNAy9tAssM5HKmnBQytnY9iwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 19:31:39 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1%4]) with mapi id 15.20.5438.013; Wed, 13 Jul 2022
 19:31:39 +0000
Date:   Wed, 13 Jul 2022 12:31:38 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lior Nahmanson <liorna@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Message-ID: <20220713193138.4cak54dqtqm2pisg@sx1>
References: <20220613111942.12726-1-liorna@nvidia.com>
 <20220613111942.12726-3-liorna@nvidia.com>
 <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
 <20220614091438.3d0665d9@kernel.org>
 <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
 <20220621122641.3cba3d38@kernel.org>
 <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
 <20220712170159.6da38d1b@kernel.org>
 <PH0PR12MB544980DAD3694E4F532AB6B1BF899@PH0PR12MB5449.namprd12.prod.outlook.com>
 <20220713113452.3bbf10fd@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220713113452.3bbf10fd@kernel.org>
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89f21a66-2622-470a-ab38-08da65064f05
X-MS-TrafficTypeDiagnostic: PH7PR12MB5902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZdpMob3325Ezj3kLdbKzHVOG29lVkZ2n2HyBOqnNKm/Cdr7xFY2gdE5rsCjA+Vi8nXqyEAjN+71KWkm9W8iOA4O4LLqiBFhJEvncKKitZlQs76N+fiwMHkt/rEY+rpOFmCPKI9aQRdDQk2kDeV3VHpwB+CxjVdX69c1kK3j8AcKBhxAQbB1FPx9Swoh1HzFh40sTvvuWIy7uGqvLRwHlaJRVFUlWwGwgi2lL+2xHTufaNUCADkfPLOeqXaj6n5RBTrNI1PqTQIttvzI8aZo0pOh4hc7z/0cNO2W+QH2RudXSK4Szlh+xCb86BM5Zyi6XNmkkcTx3yGbfqteFnW14fL2yXoNJ8qSSV0gce3qWDc3dopFHs7fOTO7z/tFrUtDDjPQcFmrdOyI/+9evAAS4yZl27GUNd7YxA8LUjtYoJKVgL/YcFp/GC0MfvPi2i9gkxfYQb0dgib0k1i6hRKBK7dvYjS4m0X+mxXNRVElvEsqs+/dr+GEM6dsIOqvAfWOjn7KJD1ypO8zRnzNMYrSesDIhEySKp5m/N3WkMvDpQCBL7EGBpDbmV8jyfT+ENak5S0UXsAGkyecjKz+M3BRaDNBMhku+8Ieh+sFFCsjBZ4qujhPo/hDDHQx9Dg937O0Po+S1ZVE0xtVBPORhmdhJF8yW29qHYk3c+wQmUlNP4LNHnqMqtm2k1l0uEkqF5jx9hbtwj3sXtKRPBjh1FHk3Gg7stBepSh4wApKtL1sOYB3BLacI0Za+Azl1LU+1HRY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(186003)(38100700002)(1076003)(41300700001)(86362001)(107886003)(5660300002)(66476007)(8676002)(8936002)(66946007)(4326008)(83380400001)(33716001)(6506007)(4744005)(66556008)(2906002)(6916009)(54906003)(478600001)(9686003)(26005)(6486002)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wce4OwXuApePBNdUrOAatxmjC04xmqlDEyRB/3OORUgO+Ep34sK6/dzKE4Qe?=
 =?us-ascii?Q?VISwtb9867wuRmDhU0y6vhjaibY8tbA2W2Rdgc4rKzpDr4KeMvUvJ2J1jODd?=
 =?us-ascii?Q?shbkhPSvrZ5G4F6oEImLnuj0fWHJyctifJHkDFHzpsgReYnhopOBKsU9nVz3?=
 =?us-ascii?Q?dYRDpA6qAd6p/Y8xjmgvCOc2LKIhpbMTte4AqqJLXqbbj1QnJm8ppT5GYd1a?=
 =?us-ascii?Q?hP5iTbOWoqTqx1GmcTRn0T9TObWpQTJygMHuULCN2G3AzOpRhIf5sCqc06gy?=
 =?us-ascii?Q?JZdkHsC8MZI3duGotBq6P91ILiL4J+rbwR3eg3B2hdEis/1diIBMgYwDhvrB?=
 =?us-ascii?Q?LqKy9CBbp9lXKDU9W6xtJVf+UjsANDinrfkPpt19FVAaHi19jaRN/O25nRl3?=
 =?us-ascii?Q?y1neKBkCueTRNu3fKHgKZ6FGG8w0zLUpfn9suZb23ZX/1XRdAGSOYdTF4Als?=
 =?us-ascii?Q?qt+HBqGD5KTSk37WO8EZI9kM9lkRaBqfiTtFPp20sBGFJ3xv+aUWXtdy3wBM?=
 =?us-ascii?Q?XwIvRk4I1MhAdfqXy3ecYWA/scqVzrg0PtyYUYEv+4xDktMrROpTTyINcVJB?=
 =?us-ascii?Q?mBXB2Zmp1nq9YzCS0xbUf3ISiGY63ILNQwBrFLoBahXWXnjSpZmN0/dw0xt0?=
 =?us-ascii?Q?pzAfW7kBpRd+H5I/tBIkZ7wBd12fSdMyrFa+6l7suWuiLf2Su6DTPfLFus3e?=
 =?us-ascii?Q?EJF8T1LnSkNKh3fsIInA8B10vC7D4VAvamkb25yFFrqOYSKVZbO0FqIEAveI?=
 =?us-ascii?Q?/4ynVwSD7ywNrKzJ+k6b/IGI0gp4BD+2n+75ZMDUEMaGHBMH2Pp2OElvzuI0?=
 =?us-ascii?Q?yrhzJFzxEPWc1FXNL6KQnQS6jXiLKGkRp4Ycv+3+DL2UielK1DBn/W/UC4mv?=
 =?us-ascii?Q?jMauhPf+/uTR0Zlny57srJK6iDOE+FVCnN2hdShdb4yRgrFIndNe9nSARt0Y?=
 =?us-ascii?Q?eJuPYlVI7QFYJs1w1i79Hks4z7ImtCesTe7wmYOj2btZw1BdU8AAtavHDRag?=
 =?us-ascii?Q?ufWES+bHwneJ9XtQHIVonk16qXPgC6utLUZKIyWBrrewpma+0iq2j2xpn0Vo?=
 =?us-ascii?Q?opXQDh8wkOy/6DzG+RYg+v/3YUfOtoLN3r6k7tLxiWoguPhtcGnBdHccQsBV?=
 =?us-ascii?Q?yfLLLOzggLDvNrdh/CYK+M+e2b8aZtRrybU7ZTUR17rmSOY/dNSy3It19/Tw?=
 =?us-ascii?Q?KM8DDEf2VJgfwhHvTl+PP9cE2sSDcBV/dCJGzg94d8x1MK3upUlQzvLfD6xI?=
 =?us-ascii?Q?ngaeC+WgSwd7PQnaHkfnMPdJ/07NVoKQI/vSeG2od2gu+CWRvdTeP16WSrl6?=
 =?us-ascii?Q?VD497+uJOqkdo7QdE3lu/tu3iJjyShsTfWUR0PUFn1oAq4Y2O5sEvd9PkDiJ?=
 =?us-ascii?Q?2ln+CAw1mQSQEW7hWgCRxeqo9GsGdq0XS28cD9SP4KDkKUpPXyGTNxYHw0Ra?=
 =?us-ascii?Q?HaaTzzlIjbhp4DQN0OOX5k7FcsqroFJFRnwfjqE2f9GWQtGDUU7mZ3jPhdCR?=
 =?us-ascii?Q?k7FoF3lLjJZl3ikiF0NL5oD00+sqXZhXQpwiordSO3spT+zdo+2FQkcLxHGE?=
 =?us-ascii?Q?HPABfuCDGcJECBT+VGVoz4iea1Whksn32KFoJs1a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f21a66-2622-470a-ab38-08da65064f05
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 19:31:39.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpGGSVnGME6UF13he1tWA7UhU5vpZqKnhorOmNkr8eNqkmGKl8PkBT0hbWxH2nFvZjw3HLSZ2ehu27SYxNQO/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Jul 11:34, Jakub Kicinski wrote:
>On Wed, 13 Jul 2022 06:21:25 +0000 Lior Nahmanson wrote:
>> For Rx there is no limitation for the number of different SCIs.
>> from MACsec driver code:
>>
>> struct macsec_secy {
>> ...
>>      struct macsec_rx_sc __rcu *rx_sc; // each rx_sc contains unique SCI
>> };
>>
>> static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>> {
>> ...
>>     rx_sc = create_rx_sc(dev, sci);
>> ...
>> }
>>
>> where create_rx_sc() adds new rx_sc node to the secy->rx_sc list.
>
>Right, so instead of putting them on a list put them in a map (IDR?)

it has to be rcu protected data structure and with a fast lookup, otherwise
multicore performance will tank, so a rhashtable or xarray, rhashtable might
be more efficient as the key (SCI) range is too big and keys can be too
spread out.

>and pre-allocate the metadata dst here. Then the driver just does a
>lookup. If lookup failed then the SCI is not configured and macsec will
>not consume the packet, anyway.
