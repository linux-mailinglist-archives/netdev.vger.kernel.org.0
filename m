Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CBE680710
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbjA3IKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbjA3IKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:10:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EEA11EA9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:09:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQFgCwQ0z2ktm5HWVOIXZY/c5a5sPkXtR+HMUlJAFwVukrbI2OUKkI2pDcjW1uOdikB467Mwfhbj+b9YYL4nMzdYPK7kGxs3NJLyyJD6jnRYlxM2B6JqO7Y+XZq/F2XtYFkGmXM74SIU8jH++qYC8Mgw8//10WJt5JHJ1tcTfLmp6RerirS9LQPVq0t6AedmBuhi5AD41oWv5H7jjf3gp6cxvpevKNaVPwqWuMP2il1XBUO91ds08FsUHqxq5szihpRu1NSijmS49H7yWCDKVqpIKThZ3cC65AD+rZ867fo7sx0DyrPpoD7KK6tILw//YlWkx39au35yxpt74AvHsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQSQNHvdmHrZfvTpuOCXzFSzJhBIxeY8EVaGtiQ8U5g=;
 b=LkX1zPZWzsKqUE7oP2jiHFrU+w1pyNCH/vBGa9YsUCUHPp1W7UuCv6/26AAvEUQxJVR2URsu284tMEsrVlamaLOwxpkPXzEs1TrowufRuZkYe9ROsyw8TX/+rQSDd/5gdoZsm3HXizhAsSqeJCZQA5R9fJFhQEoG4tTIj216S0e7UdAWwUiH7WDQqnq5bucamYd0yUtUDoKy5F7GVG2tzZilABU11h43vnLR9oK6JoI+HuIjt95CfnveCekim3S6qsB6uc4Msx6SGZebn/f3DCu/yNJkgUOokH5G+ZtX9nM5jToeb0EA3krPp2iZcjb4NA0ZoftnmzUR9y2fuGkndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQSQNHvdmHrZfvTpuOCXzFSzJhBIxeY8EVaGtiQ8U5g=;
 b=AzsGIliu3kymNjiIOIZAxWDOhptJj31kvUlNGKNiSQAbXRSElcaJ9noaiHzx0dim2lxT/d4mnRq+KatAICqY4pDUteyhgMm2Ort4GP4WpiGJ5m+v3ifdjxhlulW4WLvTq2Te2QFloBXitN4bTVTJ0UqoDd/n8bGEI/mIuZTHsMgy1iMG733XvMQP6aOTG+IxVSE7p8mspeHINsVciu5jyNBXctbQF3KkISmxmABugML+8Si//DqeTIWqJaBNtPBUVM391SY9QdJuY+tXXgWiQvz/K9syzm/sSAvz4rgI4e9BDNgIkvPp2Ngj1ryB8KLshi4c/6SbdqQp3zBpSOWw8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB4311.namprd12.prod.outlook.com (2603:10b6:610:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 08:08:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 08:08:28 +0000
Date:   Mon, 30 Jan 2023 10:08:21 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 07/16] net: bridge: Maintain number of MDB
 entries in net_bridge_mcast_port
Message-ID: <Y9d69bP7tzp/2reQ@shredder>
References: <cover.1674752051.git.petrm@nvidia.com>
 <1dcd4638d78c469eaa2f528de1f69b098222876f.1674752051.git.petrm@nvidia.com>
 <81821548-4839-e7ba-37b0-92966beb7930@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81821548-4839-e7ba-37b0-92966beb7930@blackwall.org>
X-ClientProxiedBy: VI1PR07CA0310.eurprd07.prod.outlook.com
 (2603:10a6:800:130::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH2PR12MB4311:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee37ac8-2076-4d6c-b50e-08db02992b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rTOqvxhsDr9Xw8Ixi+biQMVPk2f/aOb1ZpJsQdkRczgbZBSk4B30xlGbcJONbLeOUv/d7o4hqaCjrFcEfnrFrIVa5BBZ0skWWq8S7IV1Ngg1nkioFt7u+56wx6tB5IMlPJAGqCrSh5qMRqyCzRzUGj1WszbTHJRtImseJsFZzRWjUQegIrg9ZlcO+YuMMKNgPNOecEMlvLRslWiK7MYZowntB8EB5vDuxh2QtAXqBXoljenh7zGxMlhym+UIFFY5VUyrwWn8kNp3rlSVPyXMTA/aKkmqV3OESpC/VSqM2Ycr58hZ269FYJPXv8dX+yQbZ2jspTBnCXOpkVP4+I1J+y+Y6epmzQKQx7vN6qsD2yLMCdd+wD03lwR67qNSUcc0pK14pj7+ykJf90Bd+HTGbrWpuwDmrZoF+pz2ZJGLbNMrmo1rPuxsQppVVXqn6j/9dFxj9+TIL5OyMRzbcoxPsok1qryMYkefQzR5UdnU/1bNY3xzkm2kPupJXDogFjfqMnytX4QLxGPz+V7vOB57QLV+LBqOdXSlEGO8sy2gDy7wN8MAX3nAS+2rpaEEz4BnVFkOuDzmJ0gQlVKt3OUesL0HJgFb0TtFO9HCM5bCJSmlgMEQK6S7o7vKv7JeXE2Ai9AB6CW1WnNuBcRx3b7gMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(33716001)(2906002)(83380400001)(66556008)(41300700001)(8936002)(6512007)(26005)(9686003)(53546011)(6506007)(6666004)(186003)(5660300002)(66476007)(86362001)(38100700002)(4326008)(66946007)(6916009)(8676002)(316002)(54906003)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2U+nJD+ahrbTJoH+4mL33WyCy82ah7effAmOpRYOkp+vtfm1Tqzlg9hhu6j1?=
 =?us-ascii?Q?euiRbyxqbA8DQlwknyWVMSJYE04hwpLyGzYpiOtwOwDqV+6nfR5u4GwlvHTV?=
 =?us-ascii?Q?1YKLwhHynT8HiDgefT+ObtJMvVzgxYMX5CDfOZczlv3yRVyXLX0IMWef5uW0?=
 =?us-ascii?Q?+NlwPBwgJm/oLe3Nn2XgATouviR/sCUJQ4s4Y1cU2cs/wKv6HxiMJWV+Ct+s?=
 =?us-ascii?Q?R6yg7xUojURKWdgjUqTcwROyxWDqNlx8//majbJzN2MfD4uYpbRczh3ixroG?=
 =?us-ascii?Q?lRwqUQfRWDrfXsdOKjgsdnkOkX6W7UtuKl+KB3P6kLBUAn7x5QYggWGB4Luv?=
 =?us-ascii?Q?KfmC68LmGYStCqXlS2sS3O740lbkXdPfvVp3AXsxPuH4kl+C1xysSSj6G8dt?=
 =?us-ascii?Q?ArrrV6rPRb7agMNEgZ5eEEjBaiJjbF7u6Fk9cr6+7pm23Z6TszNi2ETGrq+s?=
 =?us-ascii?Q?0ELOU1ErDSnynPFThr8ycKKa4GUzBVXbDHbBoGpO9bYlnS7ICZVAXfpoWT3v?=
 =?us-ascii?Q?sOycBpDzT5QwFEi4qzGQzTKTk6L3IxnKjYY0WJr6/m4nO5AoqykVB/X68pq6?=
 =?us-ascii?Q?ZnZCf4kbDFpvB+uUStC2WJzpjKqLGmdqQiIRWw5q0Jo5ZU7CRjBt7Y2kcRZC?=
 =?us-ascii?Q?f1IjJBhZlGoPoLx/EX6ELsSgfuOLtmarNVIbFldL/MZPsto+P2/A3kBgUNTH?=
 =?us-ascii?Q?pKcNwkMKdMc9WmFkrWBUbSzh2fQ9pDQ/zU/hbXGaINYv2ZkNxTVL/slvj1jE?=
 =?us-ascii?Q?FWPg7SDCBfunUpAnnllzOdrQcOjqHUHZGJCW2SqC92z0dxqw8oV4zR06pWnp?=
 =?us-ascii?Q?WnJTNEkchIgjJt9TD7ZgqL261Os1wK9NeLGeXxh8ZoKqGEHP+GelreuFPCNL?=
 =?us-ascii?Q?aAk1c4BaXUfa4zmEtpfQoSJwNrWepPvim9P0GwHNl+wuOt2pD/yqQxyDmeGp?=
 =?us-ascii?Q?unL90R28VXR+MXszHuFU1D7oo223kw94uq5k0h/eUn57wDkOSKRTkKZYw6H5?=
 =?us-ascii?Q?9JMkAKMc0Ro0taC0pdnby+LYuUzk+KpIBtGuQ/J4wnI02nig8Yl8SkswPopW?=
 =?us-ascii?Q?+xx2O1zJFjYIvA2qYbVeS/h8S0DSiALdgDChicADe8JaSJFVbPNhDwb+9S9e?=
 =?us-ascii?Q?KkpQLWQTdOfzBhsDkc9/+waVdCodEKHY/u0FttWQysyWW60vivN6tuF8/cZd?=
 =?us-ascii?Q?ghq+i34hcqcAJ2DiXTdKdKv7TQXq56nagouRAwDnpQyDT0ee6MmZFHnI6Hd6?=
 =?us-ascii?Q?7GqO6fPTFxF1bemE/TqNC4MsN4YBo+WL/KHedKhtt/ujmufgN4yNZu2GMFFQ?=
 =?us-ascii?Q?cPwZUSv6hZ5a0ZZu2sA6f/Jyzbv0JJXB9zPg7hULqrULLTCenuQ98RrlT81e?=
 =?us-ascii?Q?t/dJIEZ8Vtc+hbsXjdcxZZy8x10qdxPxZJdisg090jLBLA2KVryj7dXIKBvn?=
 =?us-ascii?Q?Z3KhH2H/w1VbdpDScZ2uX8thoF5oP3knrn91Z+ZcZ4IVv5rLNl1A6GMwdlW7?=
 =?us-ascii?Q?FRcemG3u9N1k7CY8o3bOJ8DSmz0iZIEsDoT2D4awbSNJREJe5OrKAAGrOrM2?=
 =?us-ascii?Q?qOtjv9bUSRU2p+99eexzyExyFbk6iu6jEsHcL4FH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee37ac8-2076-4d6c-b50e-08db02992b31
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 08:08:28.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqfeKhORd7mznvhq/M4HhPMCFvHw0csOEl2seig3TlOvA4knTdjYDP3Ncu0cLOQc82IEptaOMcsjmiCQ0V+Txw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4311
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 06:55:26PM +0200, Nikolay Aleksandrov wrote:
> On 26/01/2023 19:01, Petr Machata wrote:
> > The MDB maintained by the bridge is limited. When the bridge is configured
> > for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
> > capacity. In SW datapath, the capacity is configurable through the
> > IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
> > similar limit exists in the HW datapath for purposes of offloading.
> > 
> > In order to prevent the issue of unilateral exhaustion of MDB resources,
> > introduce two parameters in each of two contexts:
> > 
> > - Per-port and per-port-VLAN number of MDB entries that the port
> >   is member in.
> > 
> > - Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
> >   per-port-VLAN maximum permitted number of MDB entries, or 0 for
> >   no limit.
> > 
> > The per-port multicast context is used for tracking of MDB entries for the
> > port as a whole. This is available for all bridges.
> > 
> > The per-port-VLAN multicast context is then only available on
> > VLAN-filtering bridges on VLANs that have multicast snooping on.
> > 
> > With these changes in place, it will be possible to configure MDB limit for
> > bridge as a whole, or any one port as a whole, or any single port-VLAN.
> > 
> > Note that unlike the global limit, exhaustion of the per-port and
> > per-port-VLAN maximums does not cause disablement of multicast snooping.
> > It is also permitted to configure the local limit larger than hash_max,
> > even though that is not useful.
> > 
> > In this patch, introduce only the accounting for number of entries, and the
> > max field itself, but not the means to toggle the max. The next patch
> > introduces the netlink APIs to toggle and read the values.
> > 
> > Note that the per-port-VLAN mcast_max_groups value gets reset when VLAN
> > snooping is enabled. The reason for this is that while VLAN snooping is
> > disabled, permanent entries can be added above the limit imposed by the
> > configured maximum. Under those circumstances, whatever caused the VLAN
> > context enablement, would need to be rolled back, adding a fair amount of
> > code that would be rarely hit and tricky to maintain. At the same time,
> > the feature that this would enable is IMHO not interesting: I posit that
> > the usefulness of keeping mcast_max_groups intact across
> > mcast_vlan_snooping toggles is marginal at best.
> > 
> 
> Hmm, I keep thinking about this one and I don't completely agree. It would be
> more user-friendly if the max count doesn't get reset when mcast snooping is toggled.
> Imposing order of operations (first enable snooping, then config max entries) isn't necessary
> and it makes sense for someone to first set the limit and then enable vlan snooping.
> Also it would be consistent with port max entries, I'd prefer if we have the same
> behaviour for port and vlan pmctxs. If we allow to set any maximum at any time we
> don't need to rollback anything, also we already always lookup vlans in br_multicast_port_vid_to_port_ctx()
> to check if snooping is enabled so we can keep the count correct regardless, the same as
> it's done for the ports. Keeping both limits with consistent semantics seems better to me.
> 
> WDYT ?

The current approach is strict and prevents user space from performing
configuration that does not make a lot of sense:

1. Setting the maximum to be less than the current count.

2. Increasing the port-VLAN count above port-VLAN maximum when VLAN
snooping is disabled (i.e., maximum is not enforced) and then enabling
VLAN snooping.

However, it is not consistent with similar existing behavior where the
kernel is more liberal. For example:

1. It is possible to set the global maximum to be less than the current
number of entries.

2. Other port-VLAN attributes are not reset when VLAN snooping is
toggled.

And it also results in order of operations problems like you described.

So, it seems to me that we have more good reasons to not reset the
maximum than to reset it. Regardless of which path we take, it is
important to document the behavior in the man page (and in the commit
message, obviously) to avoid "bug reports" later on.
