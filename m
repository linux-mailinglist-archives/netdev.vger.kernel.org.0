Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1700C56CDD0
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 10:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiGJIfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 04:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJIfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 04:35:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64DC13F1F;
        Sun, 10 Jul 2022 01:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P50K5+H9cSs247F0M+lcOnXndyzsLnaLhcU8/pKGh4ZDDqvt4pdPARg0NKdjqOb3kkHmw6e+GxCvmbPBPQTLA+R97XcRMtPBhKP5P/ySBoFVxzPyjZSIPpl+z849K/rM1WLk5zifRk7hfSVe+T37pFb6l4iEdXmHFs2bmpP53pVpoiQX5C5xn4U27IBK3Q0CMOXNjoLTUAErr8PKGmv2G9Z4xdJ6CRd/SnX+VmZt6HgrsP4NEsoynM6dU4eW1LGE85UQksjaPRMNeM9J/VUnfBGMv5PZly55cawGg6Wr/xjGOjBoi0U5zaopH3tnUIV41epvmk+MZjHSDTJM+VpH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaG0H9YVd45cKQL3/FJQcUe93jcyrOYVfC41nfQax6c=;
 b=aN6HCXshtB/jhpFR2/wfeogHnM4H3/CLz2rsEZkFGY2GQcY/D+BDHU3gPqBEnjuSWX6aKR8F/UePkZYvLqdyh+ykKVJigItKLivc1wLzUI7NZCIc3zRCLkG6DlNxBsHUbDjE1NAZQKLpzJ4rl5xY+OFypJXdtL/k6+4VreQa+akWZa1R769ccKC4Kxx/22ySKk1DKzE8M1A71RoHOwl/HTuSUYT1mnbN21lg1rGd0wsLXXq0Qm0kxwDg/IyZQ4q4hoL4hs12Q8DHz/0nzIPuVFIaCZXdwbYsPcrMbmQ9bRdeQhvNCI/0K8z/GrcvZhr1Qwtfk+6MvYF+549SMqYmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaG0H9YVd45cKQL3/FJQcUe93jcyrOYVfC41nfQax6c=;
 b=I4m85fuTMSlf1WqWJ69yvcPuwZJorKgLyqA+dIhQgLM9YD5mEtFHW2fATZcuf4a7n8iky9xfIdfo82cVGmUUbkNAiCMboTSC3BEyC8yRMmDjCoh9KmvafU3cZqZJ19luRaxkWBNdejkyh25cnV7sIeDbAVhvGbUbsK+EGC+2bt/10EXBsOv8T+6WmdY3ifS4ZijqBrfi5fvcvg6kC7TgtnkmNjhx9krN3B44KtIvhEKRWU6AkqA6FVj3iN45d0rPrKUVKPq+d3mc9u4pekwTktasCYQL9xvjdxfWy/dfTUnzrJU/tDY705Xba+3Fhd+118+knZV88HiCFt95QGT3ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Sun, 10 Jul
 2022 08:35:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 08:35:42 +0000
Date:   Sun, 10 Jul 2022 11:35:36 +0300
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
Message-ID: <YsqPWK67U0+Iw2Ru@shredder>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723e2995314b41ff323272536ef27341@kapio-technology.com>
X-ClientProxiedBy: MR2P264CA0033.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::21)
 To CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcc8961a-cf97-4cb1-51b5-08da624f2cda
X-MS-TrafficTypeDiagnostic: DS7PR12MB5719:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vnVx7O60lbWPMbhhzNalkRL02pcUuuaQvxAPPOkyuVJOBSzjAi1OTc0hj/g21JYCQ1xbAt4Lzu+j8WzNedOKV8cSQAxzgJuhhMWN72iIKMwphF40l4W0Skm2L3YxstINm7sfl7zdl06+0yItzP9QFKWwkkL8Xq7+dK5ef4W7TZcweJkgIbHrU0EhTCfn3PS1qlvWZGtH1xUWlVb2coQSq+tGohCpzq6+jCu689F/sxaF2+E8PQ2Oucy4x9IRJHfqSoLfo5oZdZuyL5Ff6JIkVOJ6SEfediNfBpdPmd01A6x3B7LxMPgU0oSap553byKRskwZLsC678PxiCxPwXti54EN7mEpWCEZompK5/1Gy7BTizYza3I/j32K4/F6lmC/4KCaosNXaUHT2aCjpQ3JPYV4Gkp+vbnvZAx0mxLyCd7HThqMCfs8eKiDpWOhctXhiohEzLshDjdlQV2t2sA6lxAP6DLDvH0zWvdZoM6DyzOyU722/IFYeSbf3GmGFlggCdoaQDR797YncLQzdx6l4Os3mzo7H1rwabOUM6TesfxB6RnzF5NiaaqDMbe0kpp9BpQG6pYUtbOG6m2w5bJkASor8+EoOxmq25d5yc4RCN0NZO2A3N3yRnF/LUYwAqq2yWuF02azsymzqdRFWgQUkbdGNwdtUfIVTosbR/EMoDUSlx44bQX4Ps7Tvg7TxXcvnxMtRKpWmxe0278FA8voFShadEsdlQic1LJZjwaJI3k1BbRroVqsN/S3lfFN6LlyPSngyXEzyVFZU/twVyOT1ohmSx2ODqZrXw67CX0MNApzRhaUT+7Dx0hodonHFxPtbVt2tOAStAqzVGK9Bo85Uyg2Gu0mLcpfmeq68J/7j+B+s8YoYXKEFtB4JvWQ5hxFRH/+xr8SZp7TmhiblKsbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(86362001)(66946007)(66476007)(8676002)(4326008)(38100700002)(6916009)(54906003)(316002)(33716001)(186003)(7416002)(66556008)(5660300002)(8936002)(83380400001)(2906002)(478600001)(26005)(6486002)(6506007)(6512007)(53546011)(9686003)(966005)(6666004)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EuMWxCne9cWyL41zMRGDqYjxV48XKvdF0IOerwEg7R2Hr5PgfnBnpqg4EUnU?=
 =?us-ascii?Q?PI+KyEul54NrJwenE8S4c9Q/06rhw2gXQe3Hz35zRAzbr9C3NLWXr0MJd31I?=
 =?us-ascii?Q?/VwFfXKJq8Hq3UemLVX3kOHZZW4T/p42iBO7S6FEOIuwRHSBlr5JksrCR7Pl?=
 =?us-ascii?Q?fxV/R3v1PjwcYM1mmzewPiZHhmIebKz7aYSkme925PC5LaMn7JTSivxLysPt?=
 =?us-ascii?Q?VLWIzuBnQw9938Wohfj27ZgRsHmgPV0gMA4RiT462xJeR7NO2o5K0eH3ASsW?=
 =?us-ascii?Q?ycOpMOWL0KmJVHDs7loYt4HpmRQCiPluaW2y04qFPMTkiUG6Dhxsq2AabtP6?=
 =?us-ascii?Q?OpsYoxx0ru4KZ3IgAoKg0E9LRMJxWJ9Tc5wwYBd2D4/Zuak8akEK8oYOZt2X?=
 =?us-ascii?Q?vW0Q61p/1sm44d6T3SxHB8/0XHWfLUdvleWLfmNrqejwPLT/cPz4NF6isg+v?=
 =?us-ascii?Q?gElPTH6YVSpUcVK9CpwAJkA49bT6yDkHIH13QmhHgJDG1aphi0aggCxOGtS8?=
 =?us-ascii?Q?8cllrEpBgB3W/wWEk97Pd3yE/MUztC5i6Ius4AlTqmWhYg4nb0mLfw4WMQzo?=
 =?us-ascii?Q?ny/baqbph85alAaIF/GBagJuSmirwjqYKS6XNruC6tAKv3FQOkgl2dqZqyyH?=
 =?us-ascii?Q?0DfhzLC04qNnTjpFcUt/jXhD83SAyptAvRR8JtlEXlXBXsWzBF1YjeJ3dSM5?=
 =?us-ascii?Q?x+u4HStAvcjjf0dXSMoW1k9kDxjp/oM+awTWFq6/87coN4igwoGLvBsuXRKt?=
 =?us-ascii?Q?Z1w8d3YggQ7u4umIQpsbVHzZScFIX8QV4/B/THH8SVVKAdAu9y2veZ0ymmqo?=
 =?us-ascii?Q?UxNbIdxphA98KBSdhXx6GHhqrCE8xQrger7XS5KiQ6pCR4c4cRbaWv+LsPwg?=
 =?us-ascii?Q?ZwMWg1Tu9NJj4lsezc61m5gjU+rZXojqClul2pDdV+InTIrE9entlW5O6aKv?=
 =?us-ascii?Q?d7vmOez41EmfVoPxkZeLnj2qYo1sP1auF91riKAWyTBl292nGN+++DcpADI6?=
 =?us-ascii?Q?obbjixhOKS1bGnwy0ByHJ9bsR0r11Xgp4iyPSG3azmzI3APMXANFUVtvOkK3?=
 =?us-ascii?Q?T59Hvmv1vXxczo6BhoTsCdKiuEopt5iP7hQGFO8v1qJoQRcLI6iuc5zDWt1L?=
 =?us-ascii?Q?fBGF4nNMcA8EIuU0YoQf4XT89UWe2ZA84UZgdWCL3GBbkNAAA8aw2FDmLemF?=
 =?us-ascii?Q?5C91dF4Rh+dkNfxD3KkXgpngyFZ7FcRNB2eR2fdIluyez4StDdZiipCbz7/v?=
 =?us-ascii?Q?ey9cd6Jd5VjxR4hg9cUS0D6pKHaa/bFljzqdXz0TgWUmzT0JOyGk9lRVQPmD?=
 =?us-ascii?Q?X5ZEi/YXywDuP0Bnv/vz/u4hs8WPHudnnp/SVlM0sm0zvwn3VRCiLT9GRQoo?=
 =?us-ascii?Q?gYlkQce/LGPShaYcVN/Xn7j0qe6IUGemrLOZsONm2zvaZyhXB/Ed573Hqtfw?=
 =?us-ascii?Q?5ombGMiJPARFYAocUu7Qw9Skg8hRZj+CQ+mikOqmiUh0WTbt950bzLLg97q4?=
 =?us-ascii?Q?HO0n06JUj+Tdtrs9KsX6SnLMFPRV4gF7167oqzh3/y83UJUFFSR3Vac0+4En?=
 =?us-ascii?Q?vDXUQki8GkktrdcTEnNl3v8YNRZvd4yp4o5X4Y5q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc8961a-cf97-4cb1-51b5-08da624f2cda
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 08:35:42.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UreJY/xiZj3t167vrKTgvSFkOL7ZxHVXc7VFojM3+xyLUzGYCBdQvaktEk/alVBcncXBRt4q8CBbYIWF5YMbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5719
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 02:34:25PM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-08 13:56, Vladimir Oltean wrote:
> > On Fri, Jul 08, 2022 at 11:50:33AM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-07-08 11:15, Vladimir Oltean wrote:
> > > > When the possibility for it to be true will exist, _all_ switchdev
> > > > drivers will need to be updated to ignore that (mlxsw, cpss, ocelot,
> > > > rocker, prestera, etc etc), not just DSA. And you don't need to
> > > > propagate the is_locked flag to all individual DSA sub-drivers when none
> > > > care about is_locked in the ADD_TO_DEVICE direction, you can just ignore
> > > > within DSA until needed otherwise.
> > > >
> > > 
> > > Maybe I have it wrong, but I think that Ido requested me to send it
> > > to all
> > > the drivers, and have them ignore entries with is_locked=true ...
> > 
> > I don't think Ido requested you to ignore is_locked from all DSA
> > drivers, but instead from all switchdev drivers maybe. Quite different.
> 
> So without changing the signature on port_fdb_add(). If that is to avoid
> changing that signature, which needs to be changed anyhow for any switchcore
> driver to act on it, then my next patch set will change the signarure also
> as it is needed for creating dynamic ATU entries from userspace, which is
> needed to make the whole thing complete.
> 
> As it is already done (with the is_locked to the drivers) and needed for
> future application, I would like Ido to comment on it before I take action.

It's related to my reply here [1]. AFAICT, we have two classes of device
drivers:

1. Drivers like mv88e6xxx that report locked entries to the bridge
driver via 'SWITCHDEV_FDB_ADD_TO_BRIDGE'.

2. Drivers like mlxsw that trap packets that incurred an FDB miss to the
bridge driver. These packets will cause the bridge driver to emit
'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications with the locked flag.

If we can agree that locked entries are only meant to signal to user
space that a certain MAC tried to gain authorization and that the bridge
should ignore them while forwarding, then there is no point in
generating the 'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications. We should
teach the bridge driver to suppress these so that there is no need to
patch all the device drivers.

[1] https://lore.kernel.org/netdev/YsqLyxTRtUjzDj6D@shredder/

> 
> > 
> > In any case I'm going to take a look at this patch set more closely and
> > run the selftest on my Marvell switch, but I can't do this today
> > unfortunately. I'll return with more comments.
> 
> Yes :-)
