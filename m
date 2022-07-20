Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3502357B536
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiGTLRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiGTLQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:16:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0421D2D1CA
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:16:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+xG1d2UWALsKoLirNqJQS66SijMPTc5/G/Rf1UFkhY4AA4kWD2CdJx8mDws8NIk2bXSjWQd40jLKiFwaKB1yO0BsZ/XRA031FEQ2LCdBvYFoNF9i/lIwUuDw4XBJrwgfmJmtRlgdmYkQ/IMn56LE6OZxPdj8wSE2ah7x/D5avxYfa2+w5FSc23Clmm1NevwDzclKKem0prAhTVSwVM12avVH9Qa5eF8djxkKqEcLTcOGKViSqD9Plure0mwT3J9Kq7u50KmlS4oII4/adHBA/uP/kmkZgWrJHMhr+cSodAKXhlCW9a5FNYGpOf5mbUWJDl6nYaUMaO0+n2ElfatJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrFkHOvZup0JuQKNPXlLg7xpqnaJZLY44lkT9W4DN3Y=;
 b=PgD/jvH1PIdgHix0ib6DmjMj4iqE7/91GLKokxsunRWMzNrQpJx1syDQzASXQp419liTMt9yJrbttj3WPR7rN2L5myD8Wmf29XAPaoOvCQI4Ciqd88Cyqw/vfi5KhlOB6Bl1iYWYaoSFO64am0yKe0SsGelZLIs6c/JW3tifJWac3Rm81BLnxcoDT0CSRzu5d+QmEMBGM46ONCkAQtwPYgDx6i5RKHOgY8SQBwDmiw1QksDBsE6yL4JHeyYVPY1UomCYFSrxBytLICqrWJCfvYgaZPtNb4OuxTEFvEzMp7NB2wkN/4v8fRrE2ekCItRwH5UIK50vv3j3A0n22icH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrFkHOvZup0JuQKNPXlLg7xpqnaJZLY44lkT9W4DN3Y=;
 b=LxD8d0V9OYqLMmdcaJoocdSXhI5E/2iB8eI3hFXXSLebSNIk+hq9YS8jbFM5gMFflJAk3NoXhhzMBYW0SdQNpu7FL818InpbU7qluafxYf+M1FHnM/Y4tKNXlcqyQtmiTkii5MKJmUXWlednMldbGxr0iWrRiKs3wvhif3fJuvR/LhNs1HXhwHu8iVvQKeogYaSzdl58/fII+9TtqYnZnpNX2QJPiei13fG16yh219iLq3o/nZo2LAGmFXmjYcQL2v+TOWvi5EdZakiuiTyjlQVqCsr8b+dMYX32+IjzZqyuenysYDrW0orNku6C3aZUY8Lsxzcqol585Ksu+tYlXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6122.namprd12.prod.outlook.com (2603:10b6:a03:45b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 11:16:44 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 11:16:44 +0000
Date:   Wed, 20 Jul 2022 14:16:37 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 07/12] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <YtfkFT4A0wa+Q0A0@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-8-jiri@resnulli.us>
 <YtfHgvf7ZRg3V2EA@shredder>
 <YtfeNeebi04zcbs4@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfeNeebi04zcbs4@nanopsycho>
X-ClientProxiedBy: VE1PR08CA0036.eurprd08.prod.outlook.com
 (2603:10a6:803:104::49) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e269ff7f-c93a-4cec-19b8-08da6a4153e5
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6122:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zfi1En6Rf5a34SzthDwqM0GA/+gSzF2sP8pu11xlFS5W6Y0S5XcHzr2g+WLYamORTvv8TDfh75DaSlMWSIgMUohBGYvNcBczaN0DaFRcYDH9wxaSA4FobnMmurErb9tkMvolj0pTgdV8nCwjXanSDyNdbI9twEoFcFY3icSo+/z1gZChCG8EHXmTTfinYz70VA2CMzydEDhu9KSldeWJlrMjYQ9lEKkja+LvIdJdNPC1z6UcNalV8WPmLQWhibCQ83SDS8pkcLJXnLJvWdmb9LdVprp40M39gg4TQc/SJpsghe0ds7k8SXBLNROiSokGPfbnE06YhTVOa7Rs4yvvCiA/ZycdaR0aU1Hcx9ikLlFjFEp3BDbSpuKFLs5NGySvhYoLF4QQTgdzEjvOggma5aiY1vlHpSXFK5tgUYHS7tEW8DrbTwkZEKDNcqBrDUiK0a4+WrIfy8vj9kPjaA+SR+KFpBAY5oCAS8wnSSiw6FOTmnmlkqd55P7QJMENnNQZoCXZQRnBak5Pl8a81CkU4QOgDRp4ebz9LGeZpjcKZb6W0FYBc6HjvCQ8floSkJEbNBVEkjc8CEfkSHP7hkSuYmSyGJfEzG+c7IRPodNm5ulBxSUL86yL6Gw/DR/P/C39aTUtGExamr6neZ/AiM/Gm/NEHKS823JIRL1eKIcqIJOQDTX1hNj8pNEqNE2lbHrK1nFuExpIBC1tE54fWovhECDB7xxnAB0OHa/beMOBsGE5csuxZONE7jSWtqx0Ms2GuDJaLcVYtAeoVk28nGMMTAI5d2spA2hVVJG1+6T/Bls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(6486002)(66946007)(8676002)(66556008)(6512007)(4326008)(186003)(9686003)(478600001)(66476007)(26005)(41300700001)(33716001)(6666004)(8936002)(6506007)(5660300002)(38100700002)(2906002)(86362001)(316002)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WvJ3T1TPZ3Z2f1y3GRI2uRwvppXLtGKrUZQ4pWd647Cqb3p+3S4jwHx7fJ+B?=
 =?us-ascii?Q?STEGDU1vAUBwBTIYKw7G+aGokYSSdV0X5I10tAsQbidCByD4LEO0ynaq9Aqg?=
 =?us-ascii?Q?c321WTzqtXTnywOzeUhyxOsgmsyb/2q05dokvXHdgqzB6/Gfx9KUvqMF7yn3?=
 =?us-ascii?Q?G36OLUr5HQ0xFRRGMYDJTYclKa/cMDgvB36aTwW8f1+V4cgue0Pp/In83UR7?=
 =?us-ascii?Q?3A0FAARDRDYM8Z8aZXhz7mUIC9Yyxa3jyD4Bj8VUXYzyjIlcAsUu6k4ZdXKW?=
 =?us-ascii?Q?lVrPPQVStr6kVlp6te7byVX7WjXm0GXs2dOII8Em5ULWnN+qfVPZqVyOVWUj?=
 =?us-ascii?Q?LdysOe3pEN3EdQRuCOdRHdqqgoQlpfLL2hHXbYYL3SWEta7cmK+jU9bF5B3W?=
 =?us-ascii?Q?OhxYCI4jmmp50zmvHQr8rl8aWdCDWQ/SSoJfQ6FUtkSo7X3vExZB2gQcouAj?=
 =?us-ascii?Q?hIwMVriORCcmBZeNRofsZ1F+cWHJ0RzO6W9cyv9+PuYYU03gb4uwEZ0uVjgh?=
 =?us-ascii?Q?F6tyzaXlTSGjs4EobL/+x4ke3yOU4gOhufV8BBncJpEzNjm59jQZaONvde5A?=
 =?us-ascii?Q?YwJyf332Vjj33+aeOkXZiGyKFAZhjaYpPZkGjrOVifzNnkzzuZnU5cuzxfdZ?=
 =?us-ascii?Q?h9fPbX/FpYPcvArmg/aWBTYYk+M3RyQuCh+K3cVaZO/xkXO3rYirK4arUfmZ?=
 =?us-ascii?Q?WDFa59hzB+d8ctEDkmJ9HyyAdP/2LR8zzY8UQEr26ebwwneT8av+2dnXaBR9?=
 =?us-ascii?Q?oOoe9wMOqAASE/pTclT/X3UHA1g7AcBxlJBV6dHiiWnKS7tSkjMbqGue6PrP?=
 =?us-ascii?Q?uTJ9x1Q0iODk6CKcyWxc/NmMzd5X+uTpU96UYyps8xxolBr9G0BY3mcfVrbV?=
 =?us-ascii?Q?YMA/WfAFd3/yawClzOk1fyP71SuTHlyYpJuZls/91IBraBiWJ1nKZKmJ62Qg?=
 =?us-ascii?Q?IGhwBopf+U5cUN+36pLmcwN0/q1iAYQnaG2qw1odtYSDPWNflpv3OOsl45ka?=
 =?us-ascii?Q?aq2JL/7q1J6R0lGGoKa+3YiSKP/mTX8SXjQ5YDnBKaOBc1odPD/Xw259/DBW?=
 =?us-ascii?Q?SQEtv9gRgB00rD7wR+oDJAY+wD3dQTx4KhtYJYpBZZN1ykEA1UAnrDUJboUi?=
 =?us-ascii?Q?Mkqxcabh8tERd+S8tAoSo9Wq65Hourz9SQK4K0Jp/NuMOclWrtKs6iLN/S/S?=
 =?us-ascii?Q?4pLZHRJrwEnOHZ/K2g2hOb2Rm858RHVgtaXwivKQBbKL1RaM+8JgPsnOhiC0?=
 =?us-ascii?Q?9CIeBccdR3kJAqbd7qQ05SJOHafrOeDUPDxccbiMeENLA7zbLWdLQYDkjb1Y?=
 =?us-ascii?Q?33A/PFUjhMmpE5yY7Yg44MzmXNRIUt7lwOjNAQOhnJmtqLqW/+xcNxSDvxGP?=
 =?us-ascii?Q?4k7o77VNfWz1O7uxYcGfreAl2Qs4mH4w1maaedKpYFhmAICY00Un3FXoHNck?=
 =?us-ascii?Q?CFdZN5sL0WQT3pBq4IhxxZDycjT6TFSJx3ZSnhkbqYx4IO2WF5HepY2mX4MC?=
 =?us-ascii?Q?nzAkVNyaAtvowCClP91t43R0gjZF6dZcn8kA/B/lR4a6kX9ZvB+k8cDq7tB9?=
 =?us-ascii?Q?xjrEmFV0xIyl/lSxvNbXYLv58vZBa3l0HzVwhFiV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e269ff7f-c93a-4cec-19b8-08da6a4153e5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 11:16:44.1797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sj0eJwLJDE6e0I3sC+iToMk3YZaX3Cp4bgKwbz7RG3usbGWI18sdZtEmJnmpC2G3A0izCQdmru/j9s6yxAxl8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6122
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 12:51:33PM +0200, Jiri Pirko wrote:
> Wed, Jul 20, 2022 at 11:14:42AM CEST, idosch@nvidia.com wrote:
> >On Tue, Jul 19, 2022 at 08:48:42AM +0200, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> In case the line card is provisioned, go over all possible existing
> >> devices (gearboxes) on it and expose FW version of the flashable one.
> >
> >I think this is a bit misleading. The FW version is only exposed for
> >line cards that are "ready", which is a temporary state between
> >"provisioned" and "active".
> >
> >Any reason not to expose the FW version only when the line card is
> >"active"? At least this state is exposed to user space.
> 
> When it is active, the ready bool is still set. So it is "since ready".

My point is that sometimes while the line card is still "provisioned"
you will get the FW version and sometimes not. Because it is enabled
based on a transient state not exposed to user space. If you enable it
based on "linecard->active", then there is no race.
