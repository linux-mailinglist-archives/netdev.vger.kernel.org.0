Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC35F0D04
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiI3OFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiI3OFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:05:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB36C5BF6;
        Fri, 30 Sep 2022 07:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhbnGNm9xyK9v5V9+ka6hHZMgHBrhS1vTvb+tA/9txHqsav+EZtvvHymEkznUreWHtAqsLUvgyZTgzU4ojxzvDf1OPGekNaKKBkPysTRJRzr4Z9+eusLjludjRez9VP2KyXpqcVYJ2/vfQ04ZKlcBVKPGVO+R+CinzdSVo1/w8sJoX2lahydxyeMMu0lmCfvDNcMFDAdYxuJyZbrvLNruLK+cEJsDBNxFxBgSTQ+iBMyv3Xmasjg1GwLUXiOzCizpRQKZm/VcQC1tp8+ksyt8WcXLn3xCAmQZLr600duWmSKMLOMHfFPc52qPNYZ3jFF0ZsylhoG2hPVnHaTHRGC2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lIYefaSOYiraQUJOth+slAJpWZICGu/4rJ81nJHNbs=;
 b=kXECHsD+P9oSWykdOOSml7SAJQM0V8CqRGTSk8NABmgVOgCqEBMWQakg5gt1Uzp8LeYmb0W3H3irS2VIIRQFa+YiScCx9z5yIiGm7JjJJOG/nvNlf03ia4snv2F0pESj+4dF8CowTV1zothUHCOeCChDJNjoflPNkqP8pvg7EvwWEK+9eF8lumPxaSlo15zS89dUAGshmZWxD7VOt3HKWBq3R354rKq+fletg5EuUrRWLIWoBfr8iTFTAcALkG1ascOVDTfY+rWauTZ87ZgBjw9wqygyy22394aRKmA6MZ6MFdAMbswQxmm4DNMv3sxylzdNWcY1+GQjLnjekcJkCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lIYefaSOYiraQUJOth+slAJpWZICGu/4rJ81nJHNbs=;
 b=Hkpq6F8KKI22CIYyl4Ef7W3sd5RqzqEmhp4acJ0k1zFf5CRVr+GGORuDoAH4u2UIA34oQwWePCezrK63W1+UAdHAGlM93154mPkehovAn8XGIW9UMQn/4N/w6huovPln5xhHZHRdMgpNifo4SFqi3o9h9qOLWQjS+16OdHcGrdoJlbMeSKJyOLcRYf6ARc0xJL7rVq+/oA3nP9y/kKi4Y8Itv8KBgkBC7IAkyyqFBm+ETXdVPPO8JT5JbzQkiPYnY4/IsXcvA7aV/DA+dbstYgJDV0qJ8WTDTryINxOIUrTDZPJ+LlMIqw+5e0BoyEKl5kTk4P5D+UBzDhV0pcmhWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7356.namprd12.prod.outlook.com (2603:10b6:510:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 14:05:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.017; Fri, 30 Sep 2022
 14:05:25 +0000
Date:   Fri, 30 Sep 2022 17:05:20 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <Yzb3oNGNtq4GCS3M@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220929091036.3812327f@kernel.org>
 <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
 <20220929112744.27cc969b@kernel.org>
 <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
X-ClientProxiedBy: VI1PR08CA0173.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: b62bd0fa-99bd-495d-0755-08daa2ecd233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xVXGp53JhGSo5FgPu/sFbn9qcr4f660CLEjQJR8cuO+4N2oe5XZJQPWrt38V+ahNiWO4bJzRf98xMTyWPRGhPTghp5OKtD9Aq25GNVfwO702siggf2UsY9XCiMTyAmLOuNNp3W2/E4tKs+3jKI5JNDIs4UGxymyKzimPRFO30nQ+zk6bIAIGo4f/tbhHHqHqUqupIG1xXybjvpa3Hd0FoarV5hzJfypHxENcgyejspbOjK769AnrxhiI48xVl6GgKcfTXuGhZBjdYyCmaJkSRnumJKyzQl33S+OdToKdHfoMZLZByuyXdkSipT+TMEeRiM96T+szZvIpsXaSKysOjglDmUaoZVXsBMRhTPBlkFNw+4DSOEHyUdODrGSjAjT1UEZ6yWqs8uiS0bWqFu6WA1wO8REbzrTcbjCiXbSc3Aodxj8VATP4pi5rqoNwO7m7rAGkpsrQn136V1n97ab+B5asfRPvngRj5JnvKW98e2RA7gP3jXm1ZC0Geanxif+TjfEwieJQMHPw0H1KyDz1UcDUPrzmdbFJXaKrDovkQi+JKTPO3APgZKYfq5GzV8Lpd6fY174RAe5gu5tuPI0wIg5nPA0uU1SPW1Q1DTAzQU2t5NNw8NmSBDEEtH0VwykDkGzYJF3LgL+o0iI7ZitK/TVGMNN07CY72ra0dHKUYPBTw0Vi83M+Dgd0+3Wnjq/pAE6RSuP7VlHogAY5RPm9XXZ9mQMNSWB3To0VMPcWZFiZZwTr0WOlmjqTT0nuY6FnXpqrEYWZ2LVaTOW7C9j9tG7xbwDgpowRp0iO7rk9xQFOk6s3+Lq/0sJp4hTp7jijEPubeBNPpZoFzU54D3PCsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(41300700001)(7406005)(7416002)(8936002)(5660300002)(2906002)(966005)(33716001)(38100700002)(6486002)(6506007)(186003)(478600001)(66946007)(66556008)(66476007)(316002)(8676002)(4326008)(86362001)(83380400001)(26005)(6666004)(6512007)(9686003)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bf6k4DoCmEAmetUiRY1OBbt7G7+M5Bm6pSJzJJBBFV2fpqoSLLyih4OtojzP?=
 =?us-ascii?Q?GamijKt6hl1Lk4ftIdcZcBFVfDWd21ZFmt1x/P2uwtwQMkFe+hIkHYiyo6Yr?=
 =?us-ascii?Q?GiJpfQa0tTku2ZZYwSRe8QdpBlJ4ifzQVlyrT1kvSsYhoybqA/evIGZSkmsm?=
 =?us-ascii?Q?TvmHLv+sR+fE9SLmSOBHLwvG097HdjKJ/aVVAYNSUMgFefAJDG6q8KlO1UT9?=
 =?us-ascii?Q?2c7zKgfkrrptImGqKon3r8C+3BkGvAV3jhsZNs+T6jf4GU42N5iRH/FdgRT1?=
 =?us-ascii?Q?uw4I5Q3VM6ozePw07Oo1CnDLz5izbNErhF3HopoQTySL+EfwKiAaBICNXlet?=
 =?us-ascii?Q?MCPusOyjf2ku6x36sg59u6EXcxNoSXrnLdJ4hQ3whMG11iiIf0Qr1lATQJcv?=
 =?us-ascii?Q?Sj0ctUZFxbVcRG+Kuy1OboSAH0PgO/Ax/V/CSn/HKAYSbnfBcu0zTc2F/qMX?=
 =?us-ascii?Q?fUCEqxIFmFxhY02OWhnTvaLPcBptb9Hq8TrZQ10Fdbm1AbCfs9JFQcreW+ky?=
 =?us-ascii?Q?e943S8YF+yj5zf6rXsYGfYL0XXMPrnyycsUQ+LdnmVO4cV7rxYBJC1A6ITGv?=
 =?us-ascii?Q?br4i2/cOawcceptAW8BePTeGS1Zyfew74P97D69BSZml/2Fl/aVblBSu3CEY?=
 =?us-ascii?Q?4vjoE3Cg8BVRWuYeVMWbo6yRFitRgp9kM4CgYTZdYbMEvukic+D+s6/GMGe1?=
 =?us-ascii?Q?c6UkKBh8N6zeV7We8rQVW0a7VayCSj0iN1l8V0vzcqdQhlz7A4THShyY5n63?=
 =?us-ascii?Q?55lpXMz6f841CmUYRkPNEbs0kIjRZJ8daZjFBytMj5hxWUXOjAI/LqTUER+c?=
 =?us-ascii?Q?ptoBDNsoXxqLSNyeeaYmLw2GJq45B/v02Lk5qDagGEI8ImcZoVp7mQ/s1dPM?=
 =?us-ascii?Q?OEN7KwmQjOTvwWO2KdLgMx3cxFqL1EGyWL6+tjjIFV2edC/+gn+NoJsSKfTH?=
 =?us-ascii?Q?qkgX7mJA9kbVzXsgveDiCPgYdf8dnuFreLKm2DA+s2jauFDBArz8zpVZWExD?=
 =?us-ascii?Q?cpTYHZ1/83NNdpM4zjHPGaMZor6rY4i6nrfVlv7pvxVL94Y/9q9usaXsRb2X?=
 =?us-ascii?Q?OM8QKxvfP0sGRYyHo/VNY8ZOKx0VUpx+xl2/NG635FqfLPvy8DXvxhfFTznC?=
 =?us-ascii?Q?xQlUE9tcjRPyFrlO/XzZm7O5swKS6IlzKxRQEMtVPhbY74yVPH1IyCTIRkZd?=
 =?us-ascii?Q?2Cwqa/ZMVzehBmnD7JnhupSgjxWUptar8Va5YhgmbUcz1zwk+BqOPK5KyxdK?=
 =?us-ascii?Q?uUpGzJI8y/LzPMJtySgjy6Mydrc3ILU7ceDgTRpWfIyMO4wsJkbEiP4ru63n?=
 =?us-ascii?Q?Dt7Ksioe6r/lywSZJDHXhTmneDzwS++6h/tJMKYtCEn2ktHFOZEMgqhropRh?=
 =?us-ascii?Q?FBpii6+tdCU5z3wCbyJWkFRYGqCOyj8wsVPCncQmhM32kVPC4a+BoRguawEJ?=
 =?us-ascii?Q?0mX/5TADP8j+WpemQDciRJbfJ0695MF5CaiU5HcbQ6y6LKwQCbuqoSYpL41R?=
 =?us-ascii?Q?MXwklsG5ybmTQf0amGGVL8oPIimLj+j7F4Spnrp8bBEldLAHyWUjueNFUUXc?=
 =?us-ascii?Q?Gjj1aqyPZVqicFRSvQVHnT87Wlf5D/OX5GCB/9TA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62bd0fa-99bd-495d-0755-08daa2ecd233
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 14:05:25.1230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSwU4XRH4cyxyBHNoqgOyjNqhnQ3p/MVhdNIFuPTi6I+T2bGjWKADwLsunEzPjRODRbrsos/28zfQaNh2X7gqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7356
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 07:42:37AM +0200, netdev@kapio-technology.com wrote:
> Obviously my method of selecting all switchcore drivers with sub-options
> under menuconfig was not sufficient, and I didn't know of the allmodconfig
> option, otherwise I would have used it.

You can see build issues on patchwork:

https://patchwork.kernel.org/project/netdevbpf/patch/20220928150256.115248-6-netdev@kapio-technology.com/

Also:

https://docs.kernel.org/next/process/maintainer-netdev.html#what-level-of-testing-is-expected-before-i-submit-my-change

https://docs.kernel.org/next/process/maintainer-netdev.html#can-i-reproduce-the-checks-from-patchwork-on-my-local-machine

https://docs.kernel.org/next/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them

> So the question is if I should repost the fixed patch-set or I need to make
> a new version?

A new fixed version (v7) is required, but wait for this version to be
reviewed first.

> Anyhow I hope that there will not be problems when running the selftests, as
> I have not been able to do so with my system, so there can be more that
> needs to be changed.

It's not really acceptable to post tests that you haven't run... What
exactly is the issue? You should be able to run the tests with veth
pairs in a VM.
