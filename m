Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E106312C9
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 08:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKTHIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 02:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKTHH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 02:07:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F269CF62;
        Sat, 19 Nov 2022 23:07:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELtftb/vTkoHtr+V7tHJTwkwM7kgl1DaapWbsA9yoY4UrAzMD4jtJ1WI2sRGzch/QWSWqHA4SnwIiif1rV9pRhpCHOPwWDK/4ep2JDyw7+ROYMwJtD0fL/4QX/rTSp5s/TccmtorS6GMb3AXAgMSg7WTWRpzB8Yd7zFhwlTwwiLd15kkAjPUX01scBYTEfLhPzOtOrpKDsg4uDxFgL4qWh3L7fXpsnypdFuqiufbyYw2HftigCsVAz8T56eofQZ3KXD8EpCNyjTB7mIzeoeNVHT9Ycce7jsfuFC/mGRbY9BEHOGEdCL76wrZ4MJJvupjhuCX7ybZ6mDAm3cq7Bexeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flfHM8wZ1day02cgrxDcc3fcM+ZKpCsr5deN0fYYtwU=;
 b=aoYt8UeRbgJUN6EuPcULFRX3qGEQ/Mb60NAElslW3l9h5Fbq83hWhYT+hjLgSrTfTos2orAwOhkbJbyf4zcqPW8rDvC6ufFeTBPRgau0/zDhHpohqAZ4zHEH/bVib7k3ze2UBzBJcbnfeYP4u1ozTZoO6qNwr942cuee4vg4nuspfST+1bmBE/QNBiiuHWiRg4YdZqbfCUP70g/Ylo8/6axZeFjGaV06NMmO8tUPm0FRK3MrDZRXh/v1uv/wSQX0+0UFDuIONpahxAx5zpqOCxu9aPMmoE6+e1SN9Q2uINhf258zJerZ12ac18m2lubVhBp6fjt0NmtVgMRRUbZE6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flfHM8wZ1day02cgrxDcc3fcM+ZKpCsr5deN0fYYtwU=;
 b=kpJ9rGUSk/aTdx7lAcxSLZI9humO7TLnRjIMOI7fMuZV+7arF+V/78td/hddbju6mmDEozi73V+tFIyH//xAEA7T14JNzn57vllYkKfdhObHfNUXS6iYwkikY7Fwj2CdpuqFwFPjEaS7WLuBKT3/qtVPo55O0F5GRBVMbTT8fCl4P/hgtmz3L9lWRXeVIa/5CSrXowcx0XKBQs9txW+WoLUf9Xj6jsu2SJMf5Ly6Ai5HklSGgg1+/Wrlvszc/jPHLMZbdxKRkhuAWM13G2YHfTqpwRoY5wBQ8lMtGbMrYh86a0f/UapyxhFIo4HnaCwejbEq0aCbRWOHeVWwmUQxag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4272.namprd12.prod.outlook.com (2603:10b6:208:1de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Sun, 20 Nov
 2022 07:07:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5834.011; Sun, 20 Nov 2022
 07:07:47 +0000
Date:   Sun, 20 Nov 2022 09:07:41 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@kernel.org>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-i2c@vger.kernel.org,
        kernel@pengutronix.de,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 500/606] net/mlx5: Convert to i2c's .probe_new()
Message-ID: <Y3nSPYlgl89cserh@shredder>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
 <20221118224540.619276-501-uwe@kleine-koenig.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221118224540.619276-501-uwe@kleine-koenig.org>
X-ClientProxiedBy: LNXP265CA0060.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: 6149afb7-c03a-4a49-121c-08dacac5ed85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rc8d2lGK4E1SvHCtbMr7UlvhdCdCpg+aoZkDWEWWDi9099Hm0YM6uT4fr6sELmlN99f9tWtb7unrZTtiUrumahDhUBwBQ61zaU8XDg2R003d+neYFI2fGIzwF12kyjhsO8IuRYNVvGBp77WJE+oU0SNJtZVLBm/Ypq7EFf9ecLcczIokmuYsFdNAsafJZYrAtIZR9v+r0+vkS1jvkFZm5J2OslLwGu7Z+WqOnzEWqJ/XlLwxCGeP7m5XPeCZQl+Ic7v/0TUMKyl8XfcOKgcnjv/2qK1IZd3rBL+SSF/Jr/BEgjckXYad7jVWuGjpQxYsiSx7OQPzAfwT1vr+DRcuUtc2gF35KK5RXNc6yKXOEVeypERtb7pK026zkh/UN9GJ1qJD1SI4uA0ZGGqeTZbxXB9cIraM9POCGJR/kgnWOb3G6DcXyHan5r1g4t8deYh+1FmMvJVNTcE1qiPn9LwEgDYcRd870Rik51MZCaG/RnurdNjdP/Kdn/u99h4ik5iy8yNBARewEPEz7z2WDyhwqLhLjsZPp41WnIg3xLHekFAfhupxS7fDZJvuVZOtbu8ha+88N6h760qwhxuwVvC8JEQpiNJVoN2cekjtIlKV1MNKLt7U4diGfMZ7qY92U+3OhVyfc3tzT67YNG7VT+8foB4k9b02oAVB7KlsIKwg/i2+mZRXgrfSzf5iR8eW78db
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(6666004)(186003)(8936002)(6486002)(54906003)(6506007)(6916009)(86362001)(33716001)(26005)(38100700002)(6512007)(9686003)(66946007)(4326008)(66556008)(66476007)(8676002)(4744005)(478600001)(2906002)(41300700001)(7416002)(316002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?bkBTKMzrF3SCzR+n8obudeJGvaDIEcI2sdeQ1CTQHzVG2FqwEwxCBi13Cs?=
 =?iso-8859-1?Q?XcRHiwIfNx6AgyZ2+ac1AiXtZDfJUd1ogCrvFrV16P/iC8P7FMwb3e8tkN?=
 =?iso-8859-1?Q?R+vQcv+0QqWQQQNnbCPVndhzUsQqKlkALMZYGnLMDNHaro+lJnD6zpbQcn?=
 =?iso-8859-1?Q?2EHQH18nsMjZPuWO1P3vLUZ2Qp/EFfStT6UElSfIQbyVSr7HGHDg1WzmWN?=
 =?iso-8859-1?Q?Zgg6SL1REksBBvKU0uRFAAj1PgFu5zyTqgaFmEOoHVJ656RjyF3bsagkml?=
 =?iso-8859-1?Q?VtaHaE3rp3ZC91Tuov8WY2LNyneGODK75Xu5R9sXCFddDSb3JgX4hEE4bd?=
 =?iso-8859-1?Q?ryItREBWP6DqF4o4E7RO350sAM+DvD7Ey8WVS5jna10TDcaj39a7wvSPkr?=
 =?iso-8859-1?Q?lY8/ZHzIO/aEfVjcJO5vzA0G1pX5QAzTfgL9osJWtWxBXOGW1pBQArcsJ7?=
 =?iso-8859-1?Q?CnfWNFdwu68U00kqcQ174ZHVqSIWOfV/uGbm4aR1+eBZaXzzwAqG6w0J7L?=
 =?iso-8859-1?Q?Bg+0K3EN5NLrugy7m7JCCCe7v96uPpL4vTa15roYlz9yminXnyWT0kLWYM?=
 =?iso-8859-1?Q?Bs4Rn0piq3zq+PUilEIPcicLUba0BpmtCLFj+y/0Pqf7IqRpnSVnEom6Fm?=
 =?iso-8859-1?Q?F1vJVwqS6OIaI5dcdYtCowf4b2EQh7VdcZImavpYRYGhaY7aNsFqVmLuJI?=
 =?iso-8859-1?Q?r44yRwMkOn/nP4XHNJB3bl0aPoIIrAA740WRWws2doTpMG2VgMdAuf3SaP?=
 =?iso-8859-1?Q?3JNG8uOUocaecxj/hhNLo8yo3RNir6W8pnslQnwWNsjFIFUsHu0ml4k3zr?=
 =?iso-8859-1?Q?wsyDhzT6nIhgbsb187gE+0IVBHNKbcts2DwADhWuOxPNEm1kbFL4ycTO77?=
 =?iso-8859-1?Q?8aCDffsNa+FaOMOOg/eTILmibvLwnw7WhoNVh4vrsOBQyran7NlZohZelT?=
 =?iso-8859-1?Q?h23JLtyLWquXxfIloTB/5klsoOgdLuT//eVFa/3pckCGjb4g3miUVQ6Ym+?=
 =?iso-8859-1?Q?f2MI4r+XUNiIovCUHrn6GVdoNNl7Pj4GQt0h4kTbs4a46j8iBsrOpK1jia?=
 =?iso-8859-1?Q?UNKG4QicXYhTKRio6iNnNdKh/eBqEJ0I2Qn5R4DmlQ4YZkcgncxIrykySX?=
 =?iso-8859-1?Q?faiWMRl43McxFNCOijdT+eCpTu/lJ2jzfusuQzMXtfTHNPSCrKm9c2knAU?=
 =?iso-8859-1?Q?5g/uAJPROjtY6t1rjjr2nLVsdyDOlkehTD5DagxtoEYRg4ycCXMk6z79M2?=
 =?iso-8859-1?Q?NSPxi4/FNO8uMFHKcaAu8Qv82nDWmfOWE9Cihhz03RfhPLK9JrpWdxYnuw?=
 =?iso-8859-1?Q?MDqJBrhnrc5szUqV1HWNMkaJmj2MYSiXED8Qe02agDPi2HZYT6u6Jx7HN2?=
 =?iso-8859-1?Q?/nK/6zLVzCoGO6FUF8XdkH11PmbkrU4qHv9DBgqZSwlRihX+3U7eptSsNF?=
 =?iso-8859-1?Q?wWp7lVEbAhGl5X8nK7lTayXEzIPuUYg+hKW4N8PUBFPQ6m/2f7gB/2MVvR?=
 =?iso-8859-1?Q?lzhzQzl30dFX0hc3OVhVMKnMIrY1wA5vLqYO8uFAqSEjAVNxOQylx8cd+0?=
 =?iso-8859-1?Q?krHk+JZpHnCsus362D8y58dYav/fV1Ccd4sQR/5W559AA7fjpFLbDsVCvD?=
 =?iso-8859-1?Q?VwGJli4Ne1q5WgvHx6/GW0vGB+OsSAioLm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6149afb7-c03a-4a49-121c-08dacac5ed85
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 07:07:47.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YOruc1/HP6Ne1UD4+fH2zQT2RRjeWoOq/aAhDA3oNZXAingvmlN+jNqjAd13wYp5HEMi5yiRdVw5d6zwY6Q/iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4272
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In subject: s/mlx5/mlxsw/

On Fri, Nov 18, 2022 at 11:43:54PM +0100, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> .probe_new() doesn't get the i2c_device_id * parameter, so determine
> that explicitly in the probe function.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
