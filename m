Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E93F606447
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJTPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJTPXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:23:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E065F199899;
        Thu, 20 Oct 2022 08:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Br+bVtpFquwJnaTg5EyxrLMp/xaWedAWrvQslHMYNiLb5148u32b3b8o/jWezvPYk1lC1o8Vcxg1m4Jcse9K6JVw+WTVYHbViuYNeWwHT6yI2m14wL5AR95ViNGU4eYTf49y6iSLMk2nQhDzU6M138Nk/Ym5TdITlIyNY+5mUWfOsq+3582dGC1nkPNA9ppR2pmiDJfairy9aYOD4PsLVVZ2ST4eAOTHpAMoPjUzEEk1A0DwGlfAItuzFAITLHha+6hQQrzJVugN11uYlpuGtRuiuL0G+u2mUNEvsdwKar76bQsJ9HALcc80O/fZr4GzD/u34aCl60RIwjLuDW0KpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7W92ag0AKiJBJpoYACJvKkZWNE1ZGcagqI+HW9wDrU=;
 b=lsoRndPxJJth6ca+Zh04VmDA/7aPZmAps8V/IFfaAOCbJEWHvrxTzZWD6PrvBtOpa1ZzDgHFPuxUIs5+M7v9K6cxCecb9P6dOX9hCwIyo2w6vBtkkQvlTsetsrbHjkKUAO+DdrgJq1L7DNfepvvOXX8VgBymMNybCGwo9kNiQLKIuuKpxZUsB+9AdgFr2WwzaqF+XjwdktAACDKv7794/REV1KxC5QVA8dITHNmgsLY2kWuLA2GeAA/KZn3WEhTXsmnvueVgO8u6y6B2u3QC4aO7KPyB769KQxZdDetSasF8oYzJzFP36F1zqRVwgsvRTm3OHyG2sImjkIKNawC3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7W92ag0AKiJBJpoYACJvKkZWNE1ZGcagqI+HW9wDrU=;
 b=GyHxvL1MbfwIm5XLS9+oicHdpeWtUXxDVkp45Ns9G5A/OPYGzZLc/Z4jzqlCu2IVR2Ud1oDYyt1a1zwZPE4gu0dmOkZbauID1CoRa46GYBLmz0janab13ARwjR5pRVD4Un5zQEKyNwKdoq38YgGTJQ2Hi5kAFjPhWowYm1C9XjFt06Xjtj0wTsShQa+Y38wEqOLUSnMzauWhe8v0pwSR6z4y9J5ELokizTBwBT/IcL/SR7uPPnqperoi09j3nCZjDE7LAcCHTck8GY0PZEVyAk5N7wgmA5dgXrZHJEBryGYFuu+afZhRyJlf/tj6oL7uf9HpLzTOFj9TX0hsXCPTLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 15:23:43 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 15:23:43 +0000
Date:   Thu, 20 Oct 2022 18:23:37 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <Y1Fn+TnbI/uMH0VR@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
 <Y1FTzyPdTbAF+ODT@shredder>
 <20221020141104.7h7kpau6cnpfqvh4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020141104.7h7kpau6cnpfqvh4@skbuf>
X-ClientProxiedBy: VE1PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM6PR12MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: c91323fe-3204-4185-4e2e-08dab2af12d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxdeFMFKBDXqJdgiV4zJaKHaPIo/th+0Yg+v4EOvQ2deuvyKQXmJoPeu+1I6wTTob/4oPc/5P33sCdPtc3zVc5Pi/J31OkWjlzgxZdBLB3rITuxdncSV5C7+SWvYi3pShMZuaF7BmUgMo5HwKV7/OfMRntld5K2MAOvHHGozHZA/FmDH/HEtlucBj8JiGDcXnGRWPtQ1W0mw9k0hqgI9spHV+FVXxRDJUSApMFGosdpDbXLOgbhz5zHuKMqwcEJ2ZZrU19szFvJw/4OyiAFFWwPxE5NS2oyMJ0HckM+k6nRaVuFEH1dzRzLRF4OUCEWiw9PfgTjCIgrUTgRrzNw8LwWtFDOJsqZ2g7pRgAY9hB/uYKUeROkCI9UHI1j+xM+HB4tFUdAIP0vUnmqtDvnK2VGRq2gXbJlLoG+kt0EbAaSZsmG6ZT26IOoT2lvrhtUdFZOiDOMQhFEFx3P+k7mabuzvjX88mKvqlrgyjCoOZsGMmqXdnygcK6BUV6fQkSl769QCVC5eZJMR01Rdf2qnP8SUpsJWwyQ8KsIIKEsnOn/NpHS3+HgKSSMC0Kh+/4Ba4ppP1eFJj99gSLZbH4BV/3yspkgKfH05VtYjs5NRLj63K1zuknIz5/v2jSDbJu9rE+XAaY0wrEBH7iRUoEP6man/9KqUNvC5WmZcqV1OvXq/xbCzCVuDYs3I5s/8sGHM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(86362001)(33716001)(478600001)(6486002)(7406005)(186003)(8936002)(54906003)(6506007)(9686003)(7416002)(26005)(6512007)(6916009)(316002)(6666004)(2906002)(83380400001)(41300700001)(38100700002)(66556008)(5660300002)(8676002)(66946007)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pguSwecIprCmuKi+4o85laQApBTettX8tbOe1FURkpbOs9uJm/wZNbsPLAtS?=
 =?us-ascii?Q?ffODVCBi74GrTN9nBCOA0dto2z+oVb/l17abZo0TaO5bW6MKzADKgInea6mf?=
 =?us-ascii?Q?rpLwpdwv7pxZmDKljPdN0kYZNuyg84a15kWguC2Is+8R+ozcXfkLuxlW62g8?=
 =?us-ascii?Q?U9QSHkRiqS+r2feYbjhp24f76LP7QJd+ht0otwU+uxzOeFNF6QoDdZ5t3AY4?=
 =?us-ascii?Q?YM9SsOXeAXOvSSw0Dm7JG/KgLzpxnI7njo8unklWiQoENPI/65V5zTgP+Z52?=
 =?us-ascii?Q?v7+XqkGfacaaJ+6tsGCRi2BJiOeh1jo0BFq6q3Zl9VovvHBrfgeW9QWt5Vq9?=
 =?us-ascii?Q?zl5kklFLsIG7wVrABzxKOblCAR7y7hxYJ6bjXb/80sb1p+vBkWQPHjyesWqT?=
 =?us-ascii?Q?YpxXXkoF8l088gFFv2dW6xx4KdT4ldFrDiVJMQfAuoz2RDb99WMt7tD7CrI3?=
 =?us-ascii?Q?bzHWTVqw2PQ0LCBxmDvuqUkCHfveRpblMorOFUdp9V5/g1KiQgn63lSJ6x6C?=
 =?us-ascii?Q?2yreV8/Zt0hD1a8GGVb53dTUkf0Ob/gFlNWJBeNTbHyizG8kSoJosXs9XqOv?=
 =?us-ascii?Q?/tGVFEWL9Svcjvz6yEhmwyYUfAvKVP6ieakmAkSBmuw5RRXKq5DkyHdA6XmZ?=
 =?us-ascii?Q?mgqKr0x2g1kuC+av5cq4yi4pgNCRjvD/pvzA61vJAm+qMq+UEKLltbuk5t0G?=
 =?us-ascii?Q?uHOrzFBnbadLym2I5sVFKOzuk6PmSVlKJR5ESX+FwDwWcZTVN6ZiN5s8cPmC?=
 =?us-ascii?Q?7lIePoB3nmTNVvIId8EU84OdwkDw8C7cexoAG8lV1jWjqB2X5U/SQqmEu68U?=
 =?us-ascii?Q?09nYKtsIZmXkaFLR03UKqnmGqcgNoO/xslHf5FA9Srp/wV7D1cZQAchs8xNm?=
 =?us-ascii?Q?1HbB7rPwyJbjpZt5IBEmzuptE9wB9K0nt+Ouuwn4ogZMlBIAtrifmHzIn5T3?=
 =?us-ascii?Q?Kviq5AO3NFxZ9SJ+8AYl36Kg496OK4IIdKJG8vKc9GJ2DlMPrbFF5pu9DhO1?=
 =?us-ascii?Q?Ad2PFkJi6F4y2dDJr/oRABupVesXjKypYAMViwxVZQX7Xksvk1osFoBpWvtD?=
 =?us-ascii?Q?iSUtxdaA24CA+Wl9u/e4iyFcS2tqF6IehCt7+sP11lkD8BNq//VsyNkih/+u?=
 =?us-ascii?Q?ZRg2Gjkf/CQEUZCAJZcLrrkqxWP0Rcw4HKPMdQQDmMlR6DlH15fveRyypVTo?=
 =?us-ascii?Q?SP/knWH+zuGP/uoXjLTCybLeRIcHuSJpwO8CAgV8DFLI5Z+stbrULakzZ/Po?=
 =?us-ascii?Q?JvBrKTtudQ90K/b+6kwTr8nBUSAyWBeBt+9qrn4+PeL0t1cnaAcj7tyux0J1?=
 =?us-ascii?Q?pmGDUEN2XGZA+7XRozU4iRaS+Dy0fQgI8vnViYXQmrMnBvgoPC7jkETN2Crv?=
 =?us-ascii?Q?yU5yjjqoMM01K8iT9khamV8R6hq/KvfoDJJ3bWNoxKAEUtuJcL9GIb57ODAe?=
 =?us-ascii?Q?Qp7EeJFoOOgiwuLAYxiPLsDkVexW6wdcUR8Bgv9q1+2z2lD2Jlpu73hWLt8Q?=
 =?us-ascii?Q?jiKw7Pr7HEEfRBXrAHB/WkvVeCZkCRVuBc8Vm2OKkBlRmzIKLN3t6nyj5iIY?=
 =?us-ascii?Q?wUFuWdJS/XSwr+XhD0EGdm7TfsPgWCcErPHRIX/C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91323fe-3204-4185-4e2e-08dab2af12d4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:23:43.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCsU+IVPUmFr3w+Z1ttj/V9lXWogR9+JNAe7qt1HbzNFlUNIcz9ok2sE3mvx1MeB3O6piPb/SrUw2jlRRoLdLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 05:11:04PM +0300, Vladimir Oltean wrote:
> On Thu, Oct 20, 2022 at 04:57:35PM +0300, Ido Schimmel wrote:
> > > Right now this packet isn't generated, right?
> > 
> > Right. We don't support BR_PORT_LOCKED so these checks are not currently
> > enabled in hardware. To be clear, only packets received via locked ports
> > are able to trigger the check.
> 
> You mean BR_PORT_MAB, not BR_PORT_LOCKED, right?

I actually meant BR_PORT_LOCKED... The hardware has a single bit per
port that can be used to enable security checks on the port. If security
checks are enabled, then before L2 forwarding the hardware will perform
an FDB lookup with the SMAC and FID (VID), which can have one of three
results:

1. Match. FDB entry found and it points to the ingress port. In this
case the packet continues to the regular L2 pipeline.

2. Mismatch. FDB entry found, but it points to a different port than
ingress port. In this case we want to drop the packet like the software
bridge.

3. Miss. FDB entry not found. Here I was thinking to always tell the
packet to go to the software data path so that it will trigger the
creation of the "locked" entry if MAB is enabled. If MAB is not enabled,
it will simply be dropped by the bridge. We can't control it per port in
hardware, which is why the BR_PORT_MAB flag is not consulted.

> AFAIU, "locked" means drop unknown MAC SA, "mab" means "install
> BR_FDB_LOCKED entry on port" (and also maybe still drop, if "locked"
> is also set on port).

Right, but you can't have "mab" without "locked" (from patch #1):

```
@@ -943,6 +946,13 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
+
+	if (!(p->flags & BR_PORT_LOCKED) && (p->flags & BR_PORT_MAB)) {
+		NL_SET_ERR_MSG(extack, "MAB cannot be enabled when port is unlocked");
+		p->flags = old_flags;
+		return -EINVAL;
+	}
 
 	changed_mask = old_flags ^ p->flags;
```

> Sad there isn't any good documentation about these flags in the patches
> that Hans is proposing.

Will try to comment with better commit messages for patches #1 and #2.
Not sure I will have time today.
