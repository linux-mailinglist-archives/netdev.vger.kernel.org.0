Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7786A0A58
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjBWNS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjBWNS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:18:58 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3724A1C6;
        Thu, 23 Feb 2023 05:18:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nsb1As6KHtk6wuA5dkTE1wJuKOYiM8OcUKA7ZPAuSEtWuDUH+/9hL0tcdzpABMZcqEJ0BJs8Muh1Hh8BS7zv7emBRHEItklyWcMjNtWKcJVVyEkketRvRxwusmRxnWEVaidkRdlVpxTYkV5ioo67wt4G6Z40sK2rfU1VCplL7jMz36843qV9Z8cHgGp34uk7LZjTZzFCiY1wQ/X3fp5fGbGg/BWeNCjz7gtLy+xXPcFrwCs6gSv7EB1KuyB0AR/33kdIQmfl+5RPAGGxOTJmtBhtotFxgZVFmUiUldLYe0xHuFGA7lVhOV+63IpyAakKCN5tJG8qsDIsihXi1fXqGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJIidYyZs+nQZAQ3YGxBwaLE/U9Wpg8GbM1CKFGhgyc=;
 b=S6oRlCK2dNZPLy1w6tB//rG0T4NqztHvVa89yMceqTlsrk3joRszQrV1KfXOS1F3ZSzLDKYar8rmIUjPBuA3PDyICA8XIFsLcwqcM4uZD5mkefNGvS9P+s3JoRV3m8OiKINVAS75YzcSJZ2O0WbC5nmqzXUnCR8nVWpITzNprZMUmUeSMKqk5ro9bpVzEwilFWV/XeoKXMRARpdq5mcLdVo6N/D1vs/+zxJGawF2BUcA3eUOzIbxghB4znhobq0eQ9KIlcCtb0ju50dqUcJP0KCEFF0LwvMPGdhHQZ6pl5AQ0yZGHOgViZCpuClM1QApDW0vgYSEaEwCmSDsyIOJ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJIidYyZs+nQZAQ3YGxBwaLE/U9Wpg8GbM1CKFGhgyc=;
 b=cdQh6c9J8hFEVRxTAc6nPWG1VklgZTrXBsIhmvm8zGRCl4yqSAd19wKdYoqouGwmuJ/9dWZDHBv7rY8wi4yA9ceqMmmtbCXMOEpwOmzxTdY+20zAv7wpTCZo784dTh+XR/AjBqBoe4eJRxlwzKbKzgBYTO0aWmu2GznOczVEU/8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM0PR04MB6851.eurprd04.prod.outlook.com (2603:10a6:208:182::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 13:18:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 13:18:54 +0000
Date:   Thu, 23 Feb 2023 15:18:50 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs
Message-ID: <20230223131850.ft43qfpsqahsc5mh@skbuf>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-3-vladimir.oltean@nxp.com>
 <874jrdvluv.fsf@kurt>
 <20230222142507.hapqjfhswhlq42ay@skbuf>
 <Y/dkFcqSdLK+jEMK@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/dkFcqSdLK+jEMK@kroah.com>
X-ClientProxiedBy: VI1PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM0PR04MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d508a11-dc1e-44f8-5acf-08db15a082fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7mbginojyrwZ2Giw8TsWulLLvZA0sclSkT/fWto3FGFBYEYDfwLr2LufZxk9XTHo72D5h1zMKnQe7XjSI3rBtRao2glaS/Uf7K9z6etOYlGtRzGcH/xPcHgAuIeCof+Hc6kfLUdiOgeRLoKlhknESEDbbwkzKWfXpM8x6L2pco76zfK0LszPDKLsMcO5KsQ1EYHIvb6SL9OKk/b1M3HK+UtQmIBwbPPjHbT+iqnm+sKp3+UUqh4kjEwuU9G8RhJlJP6vOl4r3lnlg4AVfuHIh17vPXDkRPwdpJjVJldmOAbu6RIuQJuAEqG+j4pQ7eGe6kCj9UoDz+FXCXlhkq5ITVWapCkgK9xQGM7Xp+NhKCq2ILTK8Db+7W8SOFdK5ra1oaVSpW6jtAKsLAtiX9SYUiJtqc69xJw8LyiPKdNAk0SJyyZiYm5W4wjezmzaTe3jBiRCrOjPGW0OkIJS/9eKgPM9BuGHjsWWF4KycK+w5j4Vv66r9GagjBFOGmQSNg9bz1b1bCU2dFR6caPq01qzxO6+5uB0HuaNkeLaVZojayHgNqRB0oWMW0ORofGUJmjHB6a+j+vGT0laUgwKLltByZ1yMee58p+HFcgAr4E/Go8WDbnpMnGQYscmdZ7jw/LXMu2LknGFanmiQcKJlpn2aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199018)(26005)(186003)(7416002)(6486002)(6512007)(9686003)(6506007)(1076003)(6666004)(54906003)(478600001)(316002)(83380400001)(5660300002)(8676002)(4326008)(6916009)(8936002)(41300700001)(66946007)(66556008)(66476007)(44832011)(38100700002)(86362001)(4744005)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xQzOt+C2nCh/LlrfJmDgczhpM6JbsYyRLnJ7YhQq/G+l2otPAtUQZkjEz1Uq?=
 =?us-ascii?Q?hAIBD8AKbaGvNrr/1NT611JZ7tJFHDVluixSsa4NeUzcHML85+jLqcXErfes?=
 =?us-ascii?Q?cwTr4nTBQilgh6xE2rzKsgGI5T5IC8tmtobUOyhXgfFcASQzo4K4oRHYl8kK?=
 =?us-ascii?Q?C1z0it8OFyH9mB4vAubSRApC+LJyEbTiHlPH2rqL36xuB0JytPdrOuhIgtnv?=
 =?us-ascii?Q?zCqalLSqIguba2iJNYBdqFDCfgAekiE9dhTdxVQ7KJf+ayNb6Td0ulfGWntn?=
 =?us-ascii?Q?OH+i67tsgnT6tUg7FxaiUyKFKvbDnFA+LHG1mnEDkND13yKnkCNzE/qE7gsH?=
 =?us-ascii?Q?pcMv9uzGSc6eHUn2ZoF8vY7hBkZTTqtlaIPC7tBgtcbKrUtENYUgJIL9mc3l?=
 =?us-ascii?Q?p+5ERpy+RVPGOXtwVC81C0+2ApEqW0gxbw9rokiMsl1OLsNwM4UKxXmlj0de?=
 =?us-ascii?Q?4Qe6+V/GkhXDHiQggbafdrGt24DoBmi6bakfsIx19JlTnE5IKh/ntGx5DfjP?=
 =?us-ascii?Q?5SFVaJBBcqts4Vcz1pU20eW66u6RXzpNj2S9BAL9kU0E9qKLPqo5HhXbCj1s?=
 =?us-ascii?Q?ogvx+gl6CM185h/NBJuK6dNKlBcH5uHbknkJnAGejPBsHY/PWAME2PQBQsWK?=
 =?us-ascii?Q?WdfcWMviIQRuCDL957vl3B6PYy0b904dwhX2UuC8CVOjoWt5xKKlu2xo2CSX?=
 =?us-ascii?Q?sgl3aR6skB6mbs8AKv6Tv+KyqjN03E0f3Yl8vCG2lyU8aKVbbscWPp0six8+?=
 =?us-ascii?Q?ZWRCYMKINYBTHw9X9pAfWNRbEQsSZQu4GfRuUkkgh8fhFebqFhphv5x4z53B?=
 =?us-ascii?Q?M1eM0kesyJcFA+pYJrzVnaxwX4MQsz9MKtWTG32ymBv4VIeMdeAZUSyLnbGU?=
 =?us-ascii?Q?DCUUWVOF7RKTXiqLjwfVfZPlQeKhRPavq5kF8qFRtaLkOkO0ZCutsN71m1C0?=
 =?us-ascii?Q?l3+4cZczenPtFVxJAnxkb23RoAGyU1A5u+r/bfp4P2tjgcMtrzJQK6BeMRCE?=
 =?us-ascii?Q?SvkADfmfL1YMS5HfHvPuW04hwoMzslaF+ktNLR7xBeubyd4f1KASHPl/HSGJ?=
 =?us-ascii?Q?rHBrhKUSE31+WXJDS/Y1VimviuWGB1P72VP+aMLvntRMwHaZcDXWFlAMFUrY?=
 =?us-ascii?Q?/UpgswHuTbHFvUm4kcx0knwh7f+qQ5jwR5zVvPwoBw8+ClUXpgoM3ElcWKO0?=
 =?us-ascii?Q?VNkme60+fV26vmLH7/lcAmV7lVaPkh+U4+3DXwNPeDyXTZ1qeQ1FpeSjNMwm?=
 =?us-ascii?Q?DW4cmt/jnvJc2H3KTfBXom9pE/FO8+zW3Bb1RAeBnTRT9TQC4urQexOI/U9X?=
 =?us-ascii?Q?+YWPsW8R2Aycj1+POnjmCybfxrd3zSLstbsO5/6a4n7/qJ4EWY5l/g8+aWyt?=
 =?us-ascii?Q?jJenEmQAtMvZQXldC2o/8h3mDTfGqIgZfoButS/peTa0jZl6cCGV8kUHXSJY?=
 =?us-ascii?Q?F5tKMcZB+g9YN8jDv7adUCNx/3PN6PhijDl+5kpLnwexHGdx9q01xKLxd7J9?=
 =?us-ascii?Q?K7T87Qbe/Q9eeaBAeB+uAT149GBMkG9F+752rmEgIdQkbAbe0Kh4YIEN7iyz?=
 =?us-ascii?Q?wymXkGkJ0nMCKhbR2QqD0ZkREHAspKHeZb3FzyvRacNRf/4Hk+ArPViINyU9?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d508a11-dc1e-44f8-5acf-08db15a082fc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 13:18:54.0990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Z/1J/cMWbJOjM5FxpDmxkZAAtgrBtAS5PkRbA+F3X/5l6nec2oOKXtHfn2WL8Ps2ZL3UtypVUQYV9KKgzRzyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6851
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 02:03:17PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 22, 2023 at 04:25:07PM +0200, Vladimir Oltean wrote:
> > +Greg, Sasha.
> 
> Hint, in the future, please cc: stable@vger.kernel.org with stable
> kernel requests, I know I don't see stuff that isn't cc:ed there
> normally when working on that tree.

Ok, sorry, I got ahead of myself.

> > Greg, Sasha, can you please pick up and backport commit af7b29b1deaa
> > ("Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue
> > pfifo child qdiscs"") to the currently maintained stable kernels?
> 
> Now queued up, thanks.

Thanks! I got email notifications for 5.4, 5.10 and 5.15.
