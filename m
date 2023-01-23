Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721726784F1
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjAWSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbjAWSbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:31:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B498533453
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MM4GI+F/zDqEMDeoUlHQKnI2wzqfAB80/2TlU0HyGnNN4Tuq61BEOEyIUj9qg32xL0zRN0iTxKSEKr9K6+/927g8pR8PVDZ7/yWKqR+B6wcbHWsUg4LM5H4sv63YiR1b9nXvuo+/huOFiW2+vH3rNiB1M055a3OAGIF+bRijWWA18AqmfX9cSuX6MfmZuSjn59SXgFZ7uxCm74c9oDVTxPT1YhPRg6pCXGc4LC+7NutfKOSTFhxyS14r7og3V/ltCfSSF0AiHJZ9ee+X+WXt8jvEg1vpERhHC5UrRTRaBFyj1RQL8DmTOz8UIlMytmR/ol2yN43rdmqcEu6s7gO61w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKYxQ8CxedbtT1FegzgsklfwMejBGrHBr0nPxzqA8ko=;
 b=Asn+u4zNud4YoA9N6gQsGGXfJHH2AeqR+d4Kjx+2khGvZm5Rl5lrjGEeNtLTouZV/Car402lDgXD29djbfTUDDg8eTVRe6FYmcAj2BG4S8ZexD/YHYMRNgo+EeE5rLcuI1Ww1yiQyjvs5POvL/lkYHE9T3f4R/PAY0cCThsrjqSm4Lz+nH/+XNM+TmjuPW9HYwcobbzFYXP4R6Z1ZXBohvXgid/S39MQ/K32JXEGqFXHo/0vUMOSvzFz4E3e472+aCOul485w2tTgrrXUrBL2GZs2kIURvDf/uKR7KPFOOmn2kJ7yWn7m0kNfs9oztAq0IdthE0t2lIUyjGDzyIOgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKYxQ8CxedbtT1FegzgsklfwMejBGrHBr0nPxzqA8ko=;
 b=tTIc3whPmXRBei9+qni9hxbCUT3xnYkyBpUTvNlHa9r8+I2nE5qcvKxEcbW4RkcwsxaexV9ZXAJuj5sw9tdXYhKCPZ1pgPToM2fkWUXOtJ4yc7sy5/cx5kbqAD6cE8/2OAxSmxt1F9pSgyUlLnF0YYiccp273HU7bpIPmSdAzqp+9KBflEHRb9lWUxiNatEIw1ulxofWoD1Am5fFooqm1QfYRVIU9xzUMM21pLDF32KGCex73C6U3HwT10xT4T2MUTBt1y2RRdnEKFq23LzXfvNJp1/AYssjY04bHSpYBkXKlnOjA6/6MCKpAKce0yLFFRW+NXcjKzcDxBNljtPQTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY8PR12MB7220.namprd12.prod.outlook.com (2603:10b6:930:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 18:31:16 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:31:16 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 02/25] net/ethtool: add new stringset
 ETH_SS_ULP_DDP_{CAPS,STATS}
In-Reply-To: <20230119183646.0c85ac52@kernel.org>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
 <20230117153535.1945554-3-aaptel@nvidia.com>
 <20230119183646.0c85ac52@kernel.org>
Date:   Mon, 23 Jan 2023 20:31:10 +0200
Message-ID: <253r0vlrtld.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0642.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY8PR12MB7220:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb01b9b-ca45-47ab-57b2-08dafd70035e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSoN9gWZjFaDQ0d9UQwcI/LVAYM1P6dKc4ClCJaUQ7J96TgPpJ4ykvdx8vPiWNBE7n8TmrIDqJJbfvEjbq5Evcz64EH5g7HirpHE+qK8DWUeeh/Qfx4Zh3BME4EjW/ObaGyohroIFJqwKI18cvNt+KVrhn3t1YRBpax69wduibfX0AMsDhqrXR3gIqRweEfRR4Ppkm/iPdAQ9xXCWbNRAD+9rcWtXN8OcYLw6otl2rYYTRf/Ulf1AKSk3q6P57irTLHEhrpEQLztGpl94a5PK4S7K8sI9A6uvZnQQuOpW1O6VYp3Q/sziMiyQhZ/ngAntU+YPaJZbMTe7RCGfHUzWtMy2BP91MHvtN4wmJNrmWIcYirP5npt3Rp2xSXdE6FRFAln73YB2fPvpj0KEj7i0kixQifj6e9u10m6K4CEmJtRT2XeqEnBQtmNZpw84dryd6t8acEnWxzvudZKitQML0JdivTyCBqE+V14ZcBO3rY+z9/3DiNsPMDiw8pOF/jU3bxMoptssgeWcrAa+oyobpEz+UsQ3eJZRFAv/6WUHbgGT9RZ5R0VvKybcQpmwnPp4dSadHoCTlC+mHCJaL9gOjVJEQaYQA7uNUGQkTNmeFy2dI1esTSGp3cvBtwAGQTHYSKNrrUB5zOz9/AOzzNE2T1DY0dzT/hGaCtYYS5X2twZKHDAmZbZVz9rX8OMUz5AVmcXjA/5Irps0SPB4gNw46CRKmMZIT0FaluNiTE/JHU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(2906002)(5660300002)(7416002)(38100700002)(8936002)(4326008)(4744005)(41300700001)(83380400001)(86362001)(478600001)(966005)(6486002)(66476007)(6916009)(6512007)(6506007)(26005)(186003)(8676002)(9686003)(316002)(66946007)(107886003)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GLIoN3v5CoSLJ+tSAbitYOcw+ZkNqGjqbXgW2OkJlHxLTH46Ls4kVNNM2A0h?=
 =?us-ascii?Q?Pc2mS9Ez2WXcYET8WCKDv4XkFlG8a8cmlZPKqiSOQAFwRO1uCF8cna7dP6KM?=
 =?us-ascii?Q?rDn2upBbx0igl22JsmgtEbtNvTf9wEFS3c3BgeyJxG8NhAnL005Ujj5wVXh0?=
 =?us-ascii?Q?VB/B406ktCrur7CiG5oevy0nK1T6tASYeJBZ1TelVnoMf+FqowAs2nfNiDYj?=
 =?us-ascii?Q?JQYNsfHq7RjpIlZUIPNozjpFlbpGs01Zj460c+TrHrSXbdFwkatxAZvWN2PN?=
 =?us-ascii?Q?dRBvUU7sHKY6YPSy+M0a/vplq2vL0QJGmdFkg9FJ6fk+L4VR3bXiXr8uGqHD?=
 =?us-ascii?Q?iz0r5MXPmpYvA3t/aygbhPxf32gzjfJRhzS/VmcpBgu7ukE+Q148pmT2NON5?=
 =?us-ascii?Q?y4uLEToS0sTLIHpQFC0ZQJwaRMmts0PwyFlWFtOIo9CQhJHSIjVi/g8yBxVN?=
 =?us-ascii?Q?ziXxNTpHFQ8DvUpTemMBhyWdxiYTfvlqyiPmu8eZAE4klKhy4wSgDljbQj1L?=
 =?us-ascii?Q?Hc4D5eZtty7/cRiv0r7GdLmP28sT/aOTChDOZyYtMTcpDPyp3MiwhRoNSpey?=
 =?us-ascii?Q?AoehmxJ4j7EZe7emWY9eTUTp4rsgsVAOPcFqenBiLQ3MY4TdXretapqMsmdt?=
 =?us-ascii?Q?fguI2Idjcioxs7KBd5W35VdfcI8WdVnCsKNHazf4rpHqve/9xtRtPSq3I0ig?=
 =?us-ascii?Q?M3LmN09vMqA1V/Bkj2mFDG8QYU2svKsvwRUdi2kZZaocRIEBJX0XkNzV+4Cn?=
 =?us-ascii?Q?ZhU1zhoBt/QnbM+G7Jry+4QCzIe1b8v/V0R7d108T/JUCqLhOUNiQLauA9Um?=
 =?us-ascii?Q?x0vW43tbT35mGMJVanhQNv4dAZoKpOSH91zGhHz3m6KvD/vZW4FytwHLWAFx?=
 =?us-ascii?Q?/QoPCYv3CkOMNTj8TdqyR/AyEIjooEBAwENA43MXciOAux1W2TQtpzsr4Fav?=
 =?us-ascii?Q?pI0HuNatQmZE2Cc8072FIDCRroXbmOyEDtAeWLAb5BhBCAKWwavIG4NDsnLt?=
 =?us-ascii?Q?vSmxcDGxaGL/RiBMtPS/VB4rT8Sh+hMk1aYqLd+H96Q0GfRNmL8/g4KijLbe?=
 =?us-ascii?Q?TqKm9oZHW0etUxhIfBtyebc2Q3jJD6D7e9Us0278agEHxLU95TrcGaVKXKp/?=
 =?us-ascii?Q?Qnl4GrI+vxYeFdQ5yfxkiKD/9X5oFpKzV5MnYfstLqRkqIEcBhXPRmN5AQRP?=
 =?us-ascii?Q?Ho4q6HhOym4rKJAI/EIT1KiW5OTLCsZxod/zckiDzqls7+YiOx829CekW6Km?=
 =?us-ascii?Q?qig2AFCVlaDTxFuvPHr60ZsEHskcEvGAbPGqLJA6KYOZTt05UemfnBiGsbo3?=
 =?us-ascii?Q?gV5ktiwuta6rWi8WuYAweqpSHZAlqEH9KadbOOy2d6BTRd6stwOfc7aU7rwo?=
 =?us-ascii?Q?9j6tr0RYCBFZQJYaHhFWUfegCIZ2pBdBcnkzOoisVkY7bQOSAOs7fk0ciEg0?=
 =?us-ascii?Q?9gxEE8Jw0cv6dKa2nmizKF6KRXUgUjDVnRcJKvMjVgTCm0XcWkN01fvVWQz6?=
 =?us-ascii?Q?aVJ/GbmGHju5W7M+xsXOz0e3ckJtQb7T5Ywhruvl3pz1lp7mkSTZ3kiHzUlO?=
 =?us-ascii?Q?4SnYHKWPZWLzlZCIPd5KTVHMIjFUdT74snBONnnw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb01b9b-ca45-47ab-57b2-08dafd70035e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:31:16.3525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLwLjhMmyJX3TzQm2+q1IeRP9wMNcBDnWKLxJI8m2wnAYKyLLt9KzluU4aqTPdwIgC0zoWqwrmEW/dplG9iRyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7220
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> This should be in uAPI and used as attribute IDs.

Following the discussion from [1] ("you can add the dynamic string set
if you like.") we deliberately did not expose the enum to userspace so
that ethtool doesn't have to be updated or recompiled to list newer
kernel ULP DDP statistics.

Should we change this approach?

1: https://lore.kernel.org/netdev/20230111204644.040d0a9d@kernel.org/
