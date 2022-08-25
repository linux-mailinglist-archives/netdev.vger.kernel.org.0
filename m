Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9567A5A0CC6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiHYJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240500AbiHYJgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:36:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BB8AB06E;
        Thu, 25 Aug 2022 02:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RobX+dnfoa/oWViwtFUiMqdHD52wDB6uJePeGKHNjp8X1TWXQ+vDqGN4Mwure4k3BPGHMZTtcs4Sw71u+lMqceCwibgRR6Pyqh4RvmlDJyovzynyidcEgQNet68hqLxf+Fqh+IbvCnpPZmqjkow5webPqUj1TQoiAw8eP6ivayyy17+FdadouoUGfYJsza+JRjORKDwrbabF1DD/rFMaLxopOaVWIk4GxZojdAtYGuyoXWcOQeOIhnnhRrwXMA836UfBgCEDC0nr8qs7ig4UvoXOIFTJptSX7OVPm4zHYO6l8l9vxQsR1IGjFDaupzxBl84ZNOKM2PB9oqbzQ9adEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+2vMc+urCwl2Sei7QYJVPkYEo3ePjTEdchVm0HaK4I=;
 b=g/m4UZNaiCy8TO8AgOb5inz0RQwCtWj/nq5uXGE606k6Dpg3mADvvDEozK2nQhlmeJPT3z/pGBjWRtseAIQiGr7/vdHy4JqcC8dDfqsjmBR9uO9CpfUOw46FTA+lu5jA3+neBDY90+bpOv7HWv6fwq57OsH5xc7hc8hAQZXqbO9pJsisTtVBfSLBUrLZlIcvxXflSb+xs9tVglCoX1tyX1XRXCLkUHlcD9IKJJ4LEU0cf2jbP5283885Bysylv2n7PiKylV7OgGqmVwTGWtbUo0N0gAIU3tg8f4NUU9+2kzqKtfxkOmHG9R5CJ8xbtgEh7qo/WeL64liNa3eyAERsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+2vMc+urCwl2Sei7QYJVPkYEo3ePjTEdchVm0HaK4I=;
 b=eKVhMwqasjSbU4dzH8v4935OSht3uA/zDjIirDnN9StBCUnuZhUgLgg0F2zmKfdvn0Ih+QP98OX3y5kNU/xu7lrDt6Wz49INbm5+nqJCfEP2vx8C9dDJSW0ul8yMe3G4v78Gldq9fhJI3mtVeistCfZGhKEe+C2UrxBVDpTomBqaDdNshZCU02XL04erCz8o8RtPWv/k46QEu/+GBYd4gdCGP3hGxhBvRVrBVY84YnQEU+t4JcHCQIpazjjR//v4MYwMG2Nt6Atj9F72GaEyDNSIJJRjpbrOFEaQk41d+C7J/GCyWpAFql5RgEzbo7C/KnV2SagDtV2ZFcd9bETXDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by DM5PR1201MB0170.namprd12.prod.outlook.com (2603:10b6:4:59::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Thu, 25 Aug
 2022 09:36:41 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Thu, 25 Aug 2022
 09:36:41 +0000
Date:   Thu, 25 Aug 2022 12:36:34 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YwdCovUbVpmHfl39@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
 <YwR4MQ2xOMlvKocw@shredder>
 <15407e4b247e91fd8326b1013d1a8640@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15407e4b247e91fd8326b1013d1a8640@kapio-technology.com>
X-ClientProxiedBy: VI1PR03CA0055.eurprd03.prod.outlook.com
 (2603:10a6:803:50::26) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a41959a-3753-4757-57b0-08da867d50f6
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0170:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jw5mbp2iWX+9X/W0Lstnvd9EJZrod8rgdBSJJBu5pUPn5j6dNIXtM+PDBkIDsWNA06ElpvZPE9OqyO3U6hW5cB7T6FyuA9qAYTQdMqyBOw93EJRBFx/hFi9UmyZegaDyBWbo+mVyJuAhIu6IJURdhWRHLx6DUQWSj4DRXYflIIFioqxeq37ZbFI5vJYK6blF6qUhE6HgTVGodf3loCxL50HZhnrvN8vqilM/EgLQVm8CcVLalN+t20tdg0wixzspt0GgPyQ4fAenVGXz9jzmmyQpbUWGX6HTPvdjk1zHG30PO0j8Td9D2kcqRC+Y+Q0x/m6V63jLEZLTbovgfiSRPNKGChi/0QIXmLSPt5qRyHzzC+48ipAKw0u5T5/wCHAJl9FgxzDJQjCQ/CNfCmjSWOjRs9DHvkqYgsdwNDkGKfBAnJd6nAAfQCrqMSBZCFT9j+QQcIe8816AO0SCqpWO56eiZFrUk4vAPI1dwEUEftsD2Ht/eypl97xDWtldDjXCDIkEIsVh+ioXhdSGrV7bZBtT16MEPQ4z99fvW37nGVJJvuDvzA2JHVXsCzbupQDiitoL0a2rWisyAsY+IQO10Zw+aWlvQkO3b0Qf35Bbr7yiTQwMo7Du3qOYrJlSyZGQro6x3Lobc4+GnuAnG4HeZ8llz2SmrjjH2ry1RENRAjQn+RHDmHzEY/yeBknddaxgVaa+6fPKWT0TqHeaRxTB+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(366004)(396003)(39860400002)(346002)(66946007)(8676002)(66556008)(54906003)(6916009)(4326008)(66476007)(38100700002)(86362001)(8936002)(186003)(478600001)(9686003)(6512007)(26005)(6666004)(6486002)(41300700001)(316002)(33716001)(5660300002)(7416002)(6506007)(53546011)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fgvYMJC8f9N0rj07oKnAGJ28Yt7sBNP7gjt8dOSlyG2L7E7eTp6VUqpV3Fsq?=
 =?us-ascii?Q?xnI/xh9Jd/2oPHDLptA5+eBCRARmiSNVllpvG42NFgYY/lEIAgqMmciou2En?=
 =?us-ascii?Q?As99OycYePqy48KF8cnaKVdlNbjrIh5xm8/BeObESIfuIjCv/mME3BtiOCdm?=
 =?us-ascii?Q?8E+JkRmoBNio+SYvsWeZ8ztNLDNOwaGcWBJqRIV5f0DGrg0NpsT5D7bX8DwT?=
 =?us-ascii?Q?tRee/aFVSYBQsL2w8BnpUJ6ktqfgKtwuugT/h4UGQnFpp2vKlbQS2F0+WVwn?=
 =?us-ascii?Q?lnLI+zac+gQ3FT0lxnyEw553e6qk5172VALR2AJl0bcuFMVEKCVZZgbbJ1yT?=
 =?us-ascii?Q?d/5P+WFv2awp7W26b4OaKl2/AneTU8OL3LvhzPESCZxu4bcGZ2S/kl4QPlvH?=
 =?us-ascii?Q?rfx/le/8ney5qL0kJ43ri9WoKNSb+V3VNTPC2+HCEjuuYH4s4HWzI0CYVFJe?=
 =?us-ascii?Q?CDh6F3wB3CtfJMFz8LhJDWi5OG+rJ62cKgBKWVIrRC8KgjxAwb84h0ZACjdb?=
 =?us-ascii?Q?3ZCAEHsm0+CvScBX8ob0yjOVJzzm5QFwuyQSGCvJ5K653Weo17u3SpYW96jX?=
 =?us-ascii?Q?h+BBKkv4lQUDFkZ+5W9wBptJmbja1DUr8S3zilIXPwJzytZI4AEThF4dl+vu?=
 =?us-ascii?Q?oMPIyN3p7Sm0ZsGseAbO+vT3saJRuXUbjlLgncM1QtvLM4gYDJH4n44bDsV/?=
 =?us-ascii?Q?OwFlUR7ImT4482C7NK96Y9E3253djpFZyxSIFiu+r7e1OiUkTkkL3fZABnfS?=
 =?us-ascii?Q?XSdSZwhFJ/FuFy11DogEY7EsznTaEqNvyFmu8EWBaMT8MTaxKUZ5OQO7kw1w?=
 =?us-ascii?Q?wt5X9Rti3c7nWi8OasFAm/BQcuqD29hMI1GumvRwODqckZc0lLnhJx2j6aXw?=
 =?us-ascii?Q?KUlelSfaCm4tFrrrK13Fe+WpJs8Oqww27+837sihuUvP+snmuf8PV+mIe3Ok?=
 =?us-ascii?Q?ep7X58+xXNGKd6Eeeqx8qrUAyNgcFmFddYti2F+NqTmmqju4r9O1NzwwQAId?=
 =?us-ascii?Q?1FogIxGKtE4eWEOgI51hSG4dZzAzOxgqhs7a5JEmbYOPYJ3z5eUQylxKcLy6?=
 =?us-ascii?Q?aFSJOCWbRYW5VbjkeoHMAlX40pKRsoWsLu4AG/W9YDC5VSrykt5ZXRjVUZhI?=
 =?us-ascii?Q?ZBkqaKOf78DlBwtyZmMDQTbgSwYCvArdSFgCG7hluaTXpWU28cAy7THfuJYu?=
 =?us-ascii?Q?0n3rA1yls0tH/amt9ewH5LdxFvTXd5T2nbNT4JX458ak7SaChiLJkpyofK1z?=
 =?us-ascii?Q?ziD5oS2z38pWym7NcHieRk+dWqYmyss2e3FBVVpSJRye/Qgg6JtHYbejkyzy?=
 =?us-ascii?Q?u18BgMta8PoCxfyysb9FLbLH7LOCbfNxEfeUx9Q7w3UL+JDHf1XRg6+UkiEZ?=
 =?us-ascii?Q?MUjD7E4dJ64f4+D+/tdqtkrMsUcYOTn3/KcZlawiB9chQU0xQSHsT1slrQEi?=
 =?us-ascii?Q?MQsbF8QqPYrR5T9QKYuXmYahhFcuXlvWRjo5nnwfbG0xrLYkOJTRVGlFwfLR?=
 =?us-ascii?Q?wFQu5imVuTN47NBDAAqCUeVbovZyjUuBlCoXhuMN+krMxYWbJvlAPM9UqcdT?=
 =?us-ascii?Q?ESmyyIhzlB3O6873Fggap/v+25a7DkLmjFYG6a2i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a41959a-3753-4757-57b0-08da867d50f6
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 09:36:41.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0DjLBhncJNP6IebffAaXxMMDNz9c/zH6Pkbj6p4cORvP5Yn120dvgWRfE9DqX2qs+kkAGIgu0ajicAOjjbq6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 01:41:51PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-23 08:48, Ido Schimmel wrote:
> > 
> > I'm not good at naming, but "blackhole" is at least consistent with what
> > we already have for routes and nexthop objects.
> > 
> 
> I have changed it the name "masked", as that is also the term used in the
> documentation for the zero-DPV entries, and I think that it will generally
> be a more accepted term.

"blackhole" is an already accepted term and at least to me it is much
more clear than "masked". Keep in mind that both L2 neighbours (FDB) and
L3 neighbours share the same uAPI and eventually we might want to extend
the use of this flag for L3 neighbours (at least Spectrum supports it),
so it needs to make sense for both.
