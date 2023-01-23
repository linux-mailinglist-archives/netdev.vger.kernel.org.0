Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9654C67742F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 03:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjAWCtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 21:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWCtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 21:49:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C618618AA4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:49:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knjXUTaqddDBmGge7niYsZAHyxZr9IGCmP1EilsoRyn+r3lqmDQo/FC5P1G1Evvokdci6fMkNBiApa/S3BTQc0H4JaMP3nC2AW//M6jTMBHBOfTcM2TIbs6CGMQQYQRAb9ntsD5X9qz9qDmoK0tOs00JQ/Vl8MZrcGyCZ10CsCCvg3iCFvDMRnvktIz7kK5Q2wqQcF8wgBRObWQb8nMCT3vyAxdsWbeSjfVQBIlILNmp2k6ztCGdt0RK1GIaHY1d751UUbdNRTq83KgB3yJyJoC0Uc8S62DmT/zhvxwXORrjkjSVP/zzMjc8uUYE/RKYob+2TOp5aE5MiPsrftEwDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGUWNh71snv6YaGTgtByit13aEc6HrM9eVj/a+E8t3Q=;
 b=U/LO9AoJjQhkhT1QAY8amUGef/NAw+EDiiYyuxv7wsegG4NG/mKr6c7y2YWqGKtHgZWtgt3hgKnsUhpHi+nntrQSFalnr/e8WhWwF2akpIuUpDiFOgaoXi/N9ls1045TtE0BbOYWQv1uy01QdybDgrKHsa9sqmMvmFwlqqgSTOcBirQ+IIYdDGrEO0Q6Ik719UVDwBHATuV/PnnfOYhtZFxmyEztQ2+EK0J6RoP0C2MUuOKGNtLZ9e6z28ctAp6+wUqsZuBSvW2icJ/IF6H+1YgKZ9TPLY8AR2FNBwyRaQJTO/fqVuj9bGuCddbb8qMd6ykPm92u0NGsCa8Gyjqo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGUWNh71snv6YaGTgtByit13aEc6HrM9eVj/a+E8t3Q=;
 b=e7jWZFJSA/rq1tsHbCytvKuVeFMMT7oTMQLZzkD4TbwuRdQnhzD0VA0TfML8baR/9NemBO7YCSCCjPrjhwtG/2//8KISdrJPjFsQO9DRt1Smg8ciHEeKKQet9rf9VdVIxZgnwDvcEBBAnPJXgxdh7iIP4trb9T8NXr0WxNCPEUi4/e97IuEtX1nqFMVPgv5BcEl5ABa4b1VqVGRkMwUGFGVYPNwxCPl8ay1JKl4wL6nIPGTREzG6SOqDvcEZCeEjWp70korVBwLKqVOVSM6D/6Iai3OtNRYQE2YQcKblO5V7CgCCqKikEs3tQvngR9qUcSRsVtjqYvtRJDxm6PIvqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 02:49:11 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.028; Mon, 23 Jan 2023
 02:49:10 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
References: <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
        <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> <87r0vpcch0.fsf@nvidia.com>
        <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
        <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
        <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
Date:   Sun, 22 Jan 2023 18:48:49 -0800
In-Reply-To: <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> (Richard Cochran's message
        of "Sun, 22 Jan 2023 18:22:58 -0800")
Message-ID: <878rhuj78u.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|BY5PR12MB5000:EE_
X-MS-Office365-Filtering-Correlation-Id: c7523aff-90d8-4381-8fd0-08dafcec6768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wuvNr3NwaqYO5OUeet8LrRUJxgm8foMwv/p65KcY9Td74cFYQsYYHqZglpfJSXeoilQFIDk+yPgE6dhvXmaYITnppnLum0mGFI00a+qtApaf55SfzCVHh3FfPskv19bhnD0nT9HAxA+TLXcia+08QtdLOb94JoDl3z8YyEUS2yiV8YWwz7eRr+3s0JaZMcE/WtM5XCT75lWiEs6SkapDDexNNEJv9M5aqEzNsQfd+hsH6flAMA9tYBVlJb2WEnYLhz7VHu0dIGI7nWR4N1KlZ4xeCWEEkB2U01u1GxaWVYChmBcnB1Kh1rdIXREG++6gghaq21a3QR7tovvVr1SnouU3VuBb6ATKF8h1vge7s38Q7DeUuRUjaIT1NhmZWX/T4hLrRrXU1Zw1tTdqwNThBvgIG2Ca48xmy63GRWE9mGnqo9atCCK8/iYPD8gNZLGjwnADVpZ+B4ZRFo2o0/y39Lu7/FvYVP1XkO3B8w+kwLDwoq8YqfIs6VXhC5c9y5vtMEq/hYdqfcnRVf+7B9HlKKYMUNDvWfXQ/NGAmhJ+WMc6DQ408FMETX+FjjJafzA9U11pqgQFFBmUZMoXp/8xmpm+lwyBH9tNQS5hQqK+rpP5/ulr1IEo7kWan8daGJ9QoFwWlpTyDCQRm4vLneIPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39850400004)(366004)(376002)(451199015)(38100700002)(36756003)(86362001)(478600001)(316002)(54906003)(6486002)(8676002)(66476007)(66946007)(66556008)(6916009)(4326008)(2616005)(2906002)(6506007)(83380400001)(6666004)(5660300002)(6512007)(66899015)(41300700001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yAn3PGP1VNQTEIf5Sx0oylRin/6hi8gRdB9mkGHRBOv3pRHEq05q7gJHsBfa?=
 =?us-ascii?Q?VfuUNHXVASZaF7FB7PNNR90ukwbQQ+JDdFUSwENG3vExlQyK8ZEpgnzMcOgW?=
 =?us-ascii?Q?kcjPPnxRPAnBuNFwJRpDQ+K1OjElFQY/IE1psvF1WIixQNNhhQehY8W+kNaZ?=
 =?us-ascii?Q?gOGFoklX7y7/ilG0EiAxzlJbLICWbbnlgFSvI5DhBnHaHRUJCmLL/CZLV2Lu?=
 =?us-ascii?Q?NJEP2H6iwqdil945HoICS2osMc/o/i5dZFfuh8gTXelUYFdaBLvoRRl45J6Q?=
 =?us-ascii?Q?PDNzU2j9NDIWEKJHseL63B3gZUr13aEyywOLObE3eOT34Uurr7b3291oloZu?=
 =?us-ascii?Q?6b8x6Ikfdzeb3Wl1X7i8SJY8l81m5SdSDdOTsaaOzl79ffpGUMKVZYWNjRwP?=
 =?us-ascii?Q?maQFWAaMBrBFUC1wHXvmf/DrAz0FFi+dNerCRblK/yvzedpa4/WNUj0Nh91w?=
 =?us-ascii?Q?BIgGNyhfnUlPnpwBusPAPmoUW4GuIhqRfUQGfok7XiyN6XDocDNaiFpjAwbU?=
 =?us-ascii?Q?lb51bhCfplwg97iDqh5LyTiT1IXkU5omNwU00i65S+TbIiF7tKCj6dKwvT1O?=
 =?us-ascii?Q?TspMhcvix/9hRXJEo+5m1N/fxbTIyoheixu8kW9WqUSwHOixm168ns8UhARt?=
 =?us-ascii?Q?ngUMm6xq7TuuD66T2lQzdHbKGXnx7CiiWwXbs8v1bVKhd8IT4xuyJV4hY29A?=
 =?us-ascii?Q?UBjHxMz2TXvhSzX8dWZigCVLCpX5GGFlO/bCeeb8hgGU99WPAsgns+OIcJYM?=
 =?us-ascii?Q?iXpR5V+3TC8jZXXfWQDACZxwL3SbVpkCWUYLmphPSLDbUToAXM1YXAxlLv9p?=
 =?us-ascii?Q?TJttyvy8nRmvnEJRPlwKWImmAIhf20+ADZbwCgFGlop4+RXG0z3w3LyNbKIi?=
 =?us-ascii?Q?sdCP3Hi/QmaXcvY/WKw1u9uNEJCD6h3wdWsvo2pYcjSjoocbqoRuyRTkTyt5?=
 =?us-ascii?Q?vSRgo2Wdyc8yckc1p+FO/CCnxSjCL9RptCL3ARydCOYjOq/98rumFfNaOqfI?=
 =?us-ascii?Q?WKzNemeOj3HrgLAEN1vO4mj17seoCkMu6dQ7rsHRNHF/l0lpupjQC7jmMEAL?=
 =?us-ascii?Q?SqhhtwgwhGLdGriQy6stCrbczmRWX6UzW1j94AME46Zcb6gNUklnZfPlYOrn?=
 =?us-ascii?Q?e0BdGL9Wgkk0CvdwNAd/wQ1RbQgHyCxRvJuW5dSxW87YHt3tNl67Zj5saHzU?=
 =?us-ascii?Q?apVdq5Z9re0KJIGfitvE+NgVQV6XilRzzgsFV2iutAfGx3vzo9hoWDqQcGuN?=
 =?us-ascii?Q?lbPrklpLzJj2P+6Y6C6WcZVR5+gUEsGv/nK/YaOtdTNhQlBtwv5IxlXbBKAu?=
 =?us-ascii?Q?1XtT4rDqPcP+t4hoyeMirgRwtpg6Hj3YG31rIhX4xqLVD2VfzVeUf2qu5VfT?=
 =?us-ascii?Q?ACFDtElEUHBYruPKNOuDYFEixyyYIb/yyIkmCeH2WStp831pyTP0IGCCJ4jG?=
 =?us-ascii?Q?HFeGGY5X8pdF4eQNRf48FrmIhm8z0YHV9dWvM4FKgGI1z+REWsFu1AlmZMfp?=
 =?us-ascii?Q?PS8770A0aMNn9iELvaM1BS/9GRCthy6DjQm/7/0ZU9VS6DQt4qmyNXfLH9Tp?=
 =?us-ascii?Q?k1OXebSmKv0u95+VkGTkVr8FM67xD7sSk8LFKFWFVynXdTpH0CkYkFItL7SR?=
 =?us-ascii?Q?JxKnWLRszg2cJ1wY5ZVkEhbnMjzCR6K/corEApPZcPDRv3+p5f2qji7Rb/Jc?=
 =?us-ascii?Q?btzycQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7523aff-90d8-4381-8fd0-08dafcec6768
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 02:49:10.6077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5ZuDS4Q3KQKZPKVzcSergQO2bCoTRrAKJE2uIYrSrhRM7Jo8cn2dwPnqbO/d/jm/WBotga75FVTpCAskay7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Jan, 2023 18:22:58 -0800 Richard Cochran <richardcochran@gmail.com> wrote:
> On Sun, Jan 22, 2023 at 01:11:57PM -0800, Rahul Rameshbabu wrote:
>
>> The way NVIDIA devices internally handle adjphase is to adjust the
>> frequency for a short period of time to make the small time offset
>> adjustments smooth (using some internal calculations) where the time
>> offset "nudge" is applied but frequency is also adjusted to prevent
>> immediate drift after that time adjustment.
>
> Whatever floats your boat.
>
>> However, we aren't sure if
>> this is the only approach possible to achieve accurate corrections for
>> small offset adjustments with adjphase,
>
> Typically one would implement a PI controller.
>
>> so I would suggest that the
>> documentation be updated to state something discussing that adjphase is
>> expected to support small jumps in offset precisely without necessarily
>> bringing up frequency manipulation potentially done to achieve this.
>
> Sorry if the docs aren't clear.  (However, the use of NTP timex
> ADJ_FREQUENCY and ADJ_OFFSET really should be clear to everyone
> familiar with NTP.)
>
> Bottom line: PHC that offers adjphase should implement a clock servo.

adjphase/ADJ_OFFSET is a servo implemented in the kernel space/offloaded
to the device. That makes sense.

Another question then is can adjtime/ADJ_SETOFFSET make use of this
servo implementation on the device or is there a strict expectation that
adjtime/ADJ_SETOFFSET is purely a function that adds the offset to the
current current time? If adjphase is implemented by a driver, should
ADJ_SETOFFSET try to make use of it in the ptp stack if the offset
provided is supported by the adjphase implementation?

This question was asked earlier in the mailing thread.

>
> Thanks,
> Richard
