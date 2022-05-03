Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E48518427
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiECMXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235091AbiECMXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:23:46 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B484426E
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hz7+6WCh5iU4yQtStcwIe8yH3eHTAfVy3rSvWoQ0py4a4cMu3Ol/wjsNcQbGpjsYlx7WY9BoXMuY3xSIKq6NxdYJO/Sn9hJMfw5bcjGprreAQYFKsSoJHVV2O/iD1Gyr9LpUCGjDz4m9sWthfLLroCEh7fWVb5KXDGS+z5vGJSeEhNJws0VJdpN7/1Xoy/hp7ocCqlOMrV+SYXTzVQw/EtbgkCU+Ki5e+o6BAzApz5EV3hMK3YgcL0bjqQW7nqgp0JrhBx9i7Bu8aWe9WqKm55g/U70L+IS/jzpjd3YRnIH0TXidARcjhKHEDP/I34AFj8d3/FCWffO+mhcmIxww2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s06rzfSioxTDZ7BWFcllBqzY02QIn04C9NSykT35Vfg=;
 b=cjd0viwPu/YeGFM/+MfCiBhumegEVZr7ltanKwft/2CSN1C1XoS2GTtVyttMMrtG6/B8wGt73lZ/Z8kJ+5PNC0E22puexbE0m3hc06xlU8XrmorZfmKYMbj/uZugfRNHzEI90pP8xypMV7pXgFN4D2uJUDoRw4TNdc2TS8MsSWCanSmr5atN77qqEO49Axbdke5ZIMPd49XHQ5O6QNkkE7fpNPg7aSXSNorzytizQ6km1ZenzBvZ9+dg8PkO/VkNuMy+oEOagzRN4F9PtFv83V0HZ07uQJT1Z1FCQZJ9LyqVt4RDr3qjdM4j78FkEiBtZ9zvyk34yMfI/I0zHi6pkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s06rzfSioxTDZ7BWFcllBqzY02QIn04C9NSykT35Vfg=;
 b=utRhDs7dMhmBjz9YvYI2/Nc2ngAH6LDhGiNvhtz53oZ3nPninHGReEDIlCvYI0Vl/33HCXpkZvDS0eaJSfYGSEJYmFHqjkUdBxsW72eQK5SjcpWuOavdQB3QGyrQwBdM2xNoZnYFe4vJ0AaL8P1e7oVGITRQ+qFkJVYbAYirZzWz+7UBlZAA8+DDj/XBL6mUQyTT6O5PnwDFuvmBzZ6z3vbS4TNbJHkkSGBUNcJbP6556LwL1u1llsrRQcOP6LPf0orOCuy0B+H7n8gbrfqsxKZc0YN1/EjJYLFGDdHgC6BIC314GA/KCW1JBEjEncLmVyX9kX8lZMN+PPQgqutQEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB2478.namprd12.prod.outlook.com (2603:10b6:300:e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 3 May
 2022 12:20:11 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Tue, 3 May 2022
 12:20:11 +0000
Date:   Tue, 3 May 2022 15:20:05 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: Re: [PATCH net] selftests: ocelot: tc_flower_chains: specify
 conform-exceed action for policer
Message-ID: <YnEd9f5KisUvnDzg@shredder>
References: <20220503121428.842906-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503121428.842906-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1P195CA0032.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38c25d28-fafe-4fb6-f3d8-08da2cff4535
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2478:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB24780DA0C34CAEDFF085AFA7B2C09@MWHPR1201MB2478.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmkkZO+bmvEvKc4RJFpmS3TzrcS02Udm7JoHO96F7S+q3pbF8D6Qfbsc26E1KUNqERbIbZl+UXkYiwkmcRaeyes0NRXDJFCQoojRtVojPTYLu1Rt9B6LwQJyetEszUGWYiDBt0HWHijwKXGtPJ2BTYnbQ3aK/MklrjtSpFjtlmZECDSFoh7VJxJ6gvznElDgo86aLH/m3gmelGY4uB4h7QNdS6IZ54wxORHGSO2maRr5A6BWS8h9HiBkEiH9P4U0JNOmmqaPpDl/VnTvPVLR51/RazwjtFaPUYSICeG9U0WmTkRWgwGGO1LdgGGefSJtwxVEqmgKSNq5x+ZZ5wfJNN1DbTJf93ybP5yQfHDqs800e//Kb7v17c8pIXgLESAv5neZbAEuUPqs0r3P6H5FABA9Sh9v3vbFheTnG3I/W1ZLDUUh9qOm828ab4kNyp3OhW3SzlRpRks9ZjQxFRQ3jlLOVkqQqfu2zP0nBXorn3OWAvGIKrKx5wmc7FjCi8sEwdTytPTseg0ozSK0HKqt3EsekWWgggORQ++KusgQN2OH3yMlUrmTokfmCCKV+8n5Hpe1hA4Odl9c4a/Msx9Z813sISOk3SQ+oUhU9bFjzSQ14JAdAGVpc68izYB8HL8Oc0ajXyAuXcpjHeKfRo/PhbQv/MIUVtLU7My0DmNzrzOLw2gy+xKV7JYXxwBuPBT0ZCjoOANrTb2WjhslGLs83IVdEgjkI+CmKI3sq+SLfkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(186003)(83380400001)(2906002)(26005)(66946007)(8936002)(7416002)(4744005)(9686003)(6512007)(5660300002)(6506007)(6666004)(508600001)(66476007)(86362001)(8676002)(4326008)(66556008)(6916009)(316002)(54906003)(38100700002)(6486002)(33716001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2CgTXiZQtO6Z2T9yM/pv7H+DtJxhznrt9nFc8CNZzJTYy3xQTKXzf6Wmnimo?=
 =?us-ascii?Q?lhftHB7mIC/RZNB5jhpWtdfkMmdAH1XLELw0J+/Q1ECnApg6CLQtRIhGDlA/?=
 =?us-ascii?Q?R3bqUHG+X2lrGKVZBjVG9AX0xwtyqvKDWFXnAhowj9GeGyyxm28vfbtjtKpd?=
 =?us-ascii?Q?J+HHtbLu7jQ40appOyOPnXhJ7dS/F5xxszQFM11sKi6Skq61mtVXjeeMvh1/?=
 =?us-ascii?Q?g2BrgJY21gugnAS63Dk/VLXK0Fd/QMfV5OIU07WTWbnOpWKIDtemp55BhuEb?=
 =?us-ascii?Q?zg78WexfF+yh1YOF6/ABayXYjubqYPMsBIkmoNBT6Owg9YGoFAFumG+D9cqb?=
 =?us-ascii?Q?rr00TqvSeui/2NOIzUVr78Da+Iz9KKOy99wTK7YQ18yQa2B1THFdfehcgwNJ?=
 =?us-ascii?Q?QMI2FmGHNAfAxKls81C2s6htQ/auEglLqE7XBhXYwxaC1t24n9YLrFf9g9SH?=
 =?us-ascii?Q?1pwUdkbs0CzTk0yKnFjaWSkli20ow8U+S7ikUVD+kHWu38vPav+SzSnRC/Xu?=
 =?us-ascii?Q?5liqxI1Cv1U0mNWP2fgIugaJxQw9V0o1tw9LuhvB3OUm0tJ4EjduZ1/tTGmR?=
 =?us-ascii?Q?+SNHyP3F4api5K10/r+pav8PbVnqukHOOeaxdSHmWOxs6ng8HRlC4bm+vZd9?=
 =?us-ascii?Q?QBUUhNRfyjOdI+0YQ+hWEpYTaqcBoVnWuKEkxJwOnimVVTOXKpFbWMoIzBDO?=
 =?us-ascii?Q?fox/nRn7y0CfOU+dKmlmEQq6wZFjhSRwLYHt5MYhLI2oYWRqIN3USm5ItbWB?=
 =?us-ascii?Q?WvkptL0EeTB64TaIRfvO2jLA/b9xZy/1xKmVEv8JwNSKGwJ7r4dXQ5hVQXM/?=
 =?us-ascii?Q?jp8IaH17fUbClXYqcMxdBtILRstpnz0Naf8Et0ex2XUwS3B47nnl+1MJkp9E?=
 =?us-ascii?Q?be6wUtjbZsN7EeBwOFe79vxxaZEs4FuxIOwsYLRSo43/xm+gtF+5KIespNvH?=
 =?us-ascii?Q?1gban87aRl0ITjgcNhUbOiyRvQzP++qMYmALau3mOn7BknSEApwl/ABPV4dz?=
 =?us-ascii?Q?KR9h6VJhNv0FFJStR+QU26vpLVxiSQ6GQi4Hw4T1tUg3f6g6in3Pnq158xii?=
 =?us-ascii?Q?57vC1+zX6hmgWtCuIp2pUp/etWg8qSovaeDaw+DjxNAffMZIBNx5ImnCztVE?=
 =?us-ascii?Q?aCsF3ed5P36P5oy3UHjMH6fyS8SXaK5Mp6cZjXE6aGg7JsRul0/RQIv3P2Sw?=
 =?us-ascii?Q?SjlaZ+G1LoRSjn1M5ID8P6t+eVMiOIClOLf2+39mbmrJkfBn6G8mYgwINRFU?=
 =?us-ascii?Q?iDaIEWDHwN0IRfuZAKTe0emw184MXePeJ/FIwvKWGoBq/rSive/DbHtVbY6B?=
 =?us-ascii?Q?8RWER6DsmkSqX1hver34bWT5VF12mVxUzPokpFc6Vhk2CfQKllfPtDfDkF18?=
 =?us-ascii?Q?p79OHWxT8+ZiEozlTgdvQ/GZJpkRfGeCM6FTk+K4LMZnWr5LhietfSA0agb3?=
 =?us-ascii?Q?YHA29hmzAD0vO9CQW4vvfYmdh8BYp7bANcU1UxJMr1Is19ovLs7pmKwzl881?=
 =?us-ascii?Q?GNs3ywP7t1esusPOt810AX+Jc7REABvt2RzoGdcL8Dz7CGzqdiQrrgYu6B9K?=
 =?us-ascii?Q?1SP4tmIHyDoqrg6i85vhahE7TbtR0hs+MQAvEzYBYqGVg64ICQEYw/lQBnkJ?=
 =?us-ascii?Q?nPArf4kRJIrU7z0ytavnntOAWt6wLHEtGNdA4Da+LCG73S8H9Dtko5wf/bb4?=
 =?us-ascii?Q?GN2yHIclTTSoacXJvrfbmSVaGn3vQEfrLLi1F5C8cWJ7pLVo+WUR5tS+6KdF?=
 =?us-ascii?Q?5TJeMp9ceA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c25d28-fafe-4fb6-f3d8-08da2cff4535
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:20:11.7679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIz7yUpLnD2CC5wuT6e/mTaPaXCilyI2NqA+Sz0rgTeWvFRbb4Q4m4n2YyEgS7wcJZBW9nNQZw1WW9v1uEgHUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2478
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:14:28PM +0300, Vladimir Oltean wrote:
> As discussed here with Ido Schimmel:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220224102908.5255-2-jianbol@nvidia.com/
> 
> the default conform-exceed action is "reclassify", for a reason we don't
> really understand.
> 
> The point is that hardware can't offload that police action, so not
> specifying "conform-exceed" was always wrong, even though the command
> used to work in hardware (but not in software) until the kernel started
> adding validation for it.
> 
> Fix the command used by the selftest by making the policer drop on
> exceed, and pass the packet to the next action (goto) on conform.
> 
> Fixes: 8cd6b020b644 ("selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
