Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CEE5E8797
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiIXCpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiIXCpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:45:51 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2111.outbound.protection.outlook.com [40.107.100.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10BA80F62
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 19:45:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVQTAbbeiS/M1hyvq7VVWb1XMmHSOyCxtCFLXMto8C3rVO5/i0EOfHAMia/DIRJnWiUsJGvtaMWRhas4oFHawrkMLRbTT4tdzWQZb1XOwN8+pCA20PUcATwViF/0Ux5fQYS26Yyn3SkrWzw5CqmbyGFmKXKqI73tBFRel0UEkm2I2HFTjrmGi8iGlLMK/4EGkAKBXzlXezvxFjFK1VKu1NQ/sDMgN9gFvWXLKZp72a6eqTsc6B8V7osefVTnHRpCLBQ6EXBkhQKAEGup2SI8o5sx0ax2bW7NyXPbCkrCd8KlCojAgz1L2An0IyHx4S/6vCUdEaeUWoMhbj/rQvr00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIhc8PXJaPP0+g8hLDUNQZ9xO2NHQA/FhujQ0yHwu6Y=;
 b=N9YbuKXcRReNyY1mok2Irr6nrcxzb0wtA9tzAhUhmxzO2zbReJ+gxjmiSvhLkvLPgXL3WW1FCn+bctCDcDOm6PFywqKkETs7XmEsO6zH7yf+mo+MhxJYBmyRWBwJJX/UxTm5HxxqQhuWqVjXcktq929Dh4AatmhLM81tUxk86qx9KbHJ+j8HY09VfQ4pZpRxqe5+Bt7WLciv6xDgNiKItv7DTVPOQKY9Q8qq4L8w1xc2M3dOxYNpGcYr9YTCZx44YgTp4nlYFg1Qc+ruCmjnWd8AP+hkWI1XexEN3SQAdzXlRBa+dJH7/n7ghyL2T9plzs0aZYReO7JYBARmcZ9eXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIhc8PXJaPP0+g8hLDUNQZ9xO2NHQA/FhujQ0yHwu6Y=;
 b=m/2Z1CuHduqNW995IGXV5X76B0KJ+QH408sTRj+xHljnRfmTJbWlMPv+F6oZyWhuTHhA8EgDQjtY2OCDSL4Q8Sc2flizcQGWLFJe5ZUH6jRu7LB2MdjBPZjhluFPNHtr7WMD7FcsJa/x/qdW2HnEpLgCvieeSwtqg153okBLgW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SA1PR13MB5489.namprd13.prod.outlook.com (2603:10b6:806:230::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.11; Sat, 24 Sep
 2022 02:45:38 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.009; Sat, 24 Sep 2022
 02:45:38 +0000
Date:   Sat, 24 Sep 2022 10:45:30 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
 <20220921121235.169761-3-simon.horman@corigine.com>
 <20220922180040.50dd1af0@kernel.org>
 <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20220923062114.7db02bce@kernel.org>
 <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
 <20220923172410.5af0cc9f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923172410.5af0cc9f@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|SA1PR13MB5489:EE_
X-MS-Office365-Filtering-Correlation-Id: 3696b1bc-5784-41d2-3674-08da9dd6dce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsAtwatExw+iJdqfODhHMVpHs0o4+g9GTr95yuZE1VLC+ywF0Ffb9eihaBkbzi+MoLwXNpwgYJBb9QygfwkKhWNqxJrDv7Y/QPsKrgIFkmhgYaKJxMqPNmfXDaLWRoEa2wsXHiNsMtIyeJ6Teu0cThb+c9AN3abyUDUsEAcLyMVDPIenOHr4KsotdeKAIg4HLGnd/v1A9BNPyGS+8XKAquBmehSkT7ixmcSwGNMRZiHxS5sOiF2L9ZlJacTxJNqqbTwFzRs2B88SJ2UyjxRVcJZVBtIRqeHujGzTLwomenc9z48mLFKAfTwKi4iXEwnz39ZFb+iNiCTmRZic6PrwW9wJijIBPjXZwN0jH7LLgiyzYUVVG8CsSiHNBy9IfkA4/wt1AjMh1M428kugk76/yPVYuQonjdKvJiHIS1tFXjOKJAQNryO30Qj9Qd4fDN1rYPJlvB1SkjCBlYU06DbRu1ICl7wEmL1B8gUaMiHh4AFca37HR4eTgov227W/dYByuJgY231jyRBf+KWW0Xaxs4BxjCZjtFQNO3lSWpqL/ssAO+tmc94f0LG4Et5yLf/7pN1WTKg6KsHVj6UDcXukrMKKsCWLQ6oFF79bREzava1WGyY4LhY17CzJ+1PgIMdZI+2WCkEKL/kJeU/CFcHhTWiLKK9a5tGlqm3MK+lc3KsDyUiOQsQjI3Ac20UQ2ePagbOhsQZQQ5Iw85/Nj/ZaKFHxNEh4vZHRWyiu+1eA9l2JY4d2zr7a3HIr9h1tgUAoJ13tFPlJ7ggVXksvF+xApuB/fSvinRP5bvQL2QSTBV6IyBsFNAuBm5PrnZK+v+Lj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39830400003)(136003)(396003)(346002)(451199015)(41300700001)(5660300002)(38100700002)(38350700002)(6916009)(86362001)(54906003)(107886003)(6666004)(6506007)(52116002)(33656002)(8936002)(2906002)(6512007)(26005)(4744005)(186003)(6486002)(1076003)(66556008)(316002)(66476007)(4326008)(8676002)(478600001)(66946007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3xksnreeLkvblScMnTXYlF0Og/zN6r54a3Dmkzn8kI1z3PgEX1JfUEeqlds?=
 =?us-ascii?Q?kdsbTDJNhl4BZe8kcgmqsyX006C2ot3BRg91lZQIqS0/Uz8T699DKORhciBC?=
 =?us-ascii?Q?uhBlKlEoK5K/BdekmRGEEKwvpNZKvf+EwZKM1iyaArbgpi8dPGcqTvV0g+aL?=
 =?us-ascii?Q?7OelLvyiyjOCbMn3VuScj/9KDtQdgD/YmGpO0gOo7wzQj/HwvMmN5HUKzqQE?=
 =?us-ascii?Q?S5x3jzLXkO3HHCcZ7vlsVXPAVMW8EVnO+SRI6Oeb7NIbTtkcppQb9pfKT3jG?=
 =?us-ascii?Q?F7mewV5NU2ZzLIbeo8mBY6TGfRjKc2PfAVF0DjEHK3aRXbSjVok0idPhqxGC?=
 =?us-ascii?Q?mfsW8MvHPhx3AIcINFiR7fbzxq4QBEYrqD8nKJ7onOs4bs1NYH9jxFHWnnvM?=
 =?us-ascii?Q?8SNQ2oxykt5Xh4g4ntOxdmregTwp4YvZgQgSjFbkepis8b3WvtTrwIfcpaFF?=
 =?us-ascii?Q?6vsSE9NGvROkW0PJJ7/QGae6rWRMaIrw+AkwJ+ViMXP29TFxEOEbl3sE2gnD?=
 =?us-ascii?Q?E+7trTmAbqu2bshAZW1Ao0g7gVL7dNhvhF9fX0cng5h1jJRHlAgyv51OoBGf?=
 =?us-ascii?Q?Ajatf7LPILRXgLjdShcSbiPTpGnmDMP2F6KypnycJZcGpMGpDJhDtfG7jETJ?=
 =?us-ascii?Q?f/Ha1QJbHjSIxwfwfB6+XqqOwdm1a2aODXKr9FwGswV+45Q5SWbawHGNBaJE?=
 =?us-ascii?Q?Av2rwcIxBW8fvGQ9ZcPSrcQZPugTQCfpZSn0hVahhavqpsCFoCbaBYfZqHIh?=
 =?us-ascii?Q?e1gOyoDKNxIogEln/aBPnJ+dHQPVhruqBII+6l+ta2hBrZIVC7Ox4S9RjOK+?=
 =?us-ascii?Q?sRQ5dSnTSh/Bob/YpOxiCNQlS1fyV08uSAoXcISbd+PPwOKmvsMN3MVURVqg?=
 =?us-ascii?Q?zVm/1kHzJ+hj/msdNaREiza98uTXS8o0gw50ZNmx7ZjBRMO2Pbg81KFJhBeZ?=
 =?us-ascii?Q?NmeXfw8qr6fdyAYBd+m0adpOz6hendIFE4gCjGE/LGsAEgB8ctXMIx8StkvL?=
 =?us-ascii?Q?hJWEwIGTfU4kWCK/WG98bBgGUiHix5tAa99Dgr/NfXnpw7hP47zM/8LiumOO?=
 =?us-ascii?Q?B/Rt8fn7TNajsk8kuAKmrOxUTls4UPNygKtQjVkjwHBSsqC4cfywmkHJWA5f?=
 =?us-ascii?Q?h2VrDJPDAw+6bBr+dWWd4lD9pwGPV1EXGpWq9J49wa8SYLgd7mEECGNgZ1H4?=
 =?us-ascii?Q?lqzpXLtW2NutH3k0CTbaD4VBj3M85DqkWzW8j6KJC0YtWmumbwJlO7Ur9bCX?=
 =?us-ascii?Q?hjQu/qYn00ZSL/aub/yBJJ+OoRWoc/pKA4qd7ZbL8jfGR6qH7J4J1NRMUDbn?=
 =?us-ascii?Q?/8LeiuYi3Gho84le3R0vLygJh9rgG/KwlzrzlHc1MVhTAzd8hMBZ3TFabFns?=
 =?us-ascii?Q?rzgsqsKXGBrBZZeJdGyZxXsAiYcEYVL65hHVJ8oqqUHyxLtmIJnv1lDC3Jju?=
 =?us-ascii?Q?NFSL2KQYwsCgJP75rBkFNqENGm8tMqM91Fcd7JLp2qhRIX8vBPH2YUZK3apl?=
 =?us-ascii?Q?7rLNkcXsGt/pm0OoH4XTMRdnjlAVyKCX4x2cV8zSTe6bOtucYCbEx0IlxB+x?=
 =?us-ascii?Q?WIvtrLiaKNUyozQcCRnxBi6b70EOsb8NZdanE3ui8w9HJ+SIPTdBtUo7VR+m?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3696b1bc-5784-41d2-3674-08da9dd6dce3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 02:45:38.2505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pd3s8QwZcIbSa7Achea9vaL97YbP/Pg+lYn+0jBj8HrjXmA8i9YP4JtK4R7tkILy3PoNstwX7tMbHL6XMAMwqz0unmiU5zIbeet46gA9qQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5489
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 05:24:10PM -0700, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 23:41:57 +0800 Yinjun Zhang wrote:
> > > Why is the sp_indif thing configured at the nfp_main layer, before 
> > > the eth table is read? Doing this inside nfp_net_main seems like 
> > > the wrong layering to me.  
> > 
> > Because the value of sp_indiff depends on the loaded application
> > firmware, please ref to previous commit:
> > 2b88354d37ca ("nfp: check if application firmware is indifferent to port speed")
> 
> AFAICT you check if it's flower, you can check that in the main code,
> the app id is just a symbol, right?

Not only check if it's flower, but also check if it's sp_indiff when
it's not flower by parsing the tlv caps.
