Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6136957367D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiGMMjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiGMMjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:39:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55A1F78B5;
        Wed, 13 Jul 2022 05:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWKXzWn1uhmMUIiNhwwVqA/8itKUW6nUDAQCDv10JE6eS2dFPgZ7QUnpO7qyEGu65MlF7F8KJkK1TdLT3Vlv+Sff6Z/muNjvIXXLNX1Weyuu0oq98RAqlI98XxtkX3h5dTtCBaMdq4JxOmFSl0+0bgMSQtEmnw5PkdsOUoJYJKEP/U0F/aVKPJqpOctFa5D7LPwBwm0yRvqoRJFNkmNQf7trmczt+UKYx2PQigVGlYIhD7TvjRCtMRB0/LbcTK5IWRkVUxADjrLBOPULEperYZwWjfV6e2XUzZW4trxg9GlXMQlnDHkFPRxeBx05g2NLntGC2bcZvJHTx85XPDqu4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORd5OE6IejCWSajkAb9baeZu3snvfbor2sPsyw37s7M=;
 b=LUkj8vIJtrh0LCoDip0C42/zm77GZxXIT3gSK+F4kNvd1twPi5bRtueDiTfsyM9nWyW+2P469DmMMhJl6Bei60sXSFnXOryPztUqUJtMJZ4kEUlxkefvtDDvmkVejRcXg2qhWj0O2cfbaqvGWrt4iNKchaj+rLKQZgk20T4Gpv53+nkV2x1lvfqJDsIZz7uuz5UG46XHUwK0e28tvOALaC/N1fhytFBMOAf6f4E4mbFu8GiXRcnTihHrXU8jve/N/uFCiN+uDphoeTraqzplobk1OWV9tvKV5UgpbOAzlhW828VE7gmQZuadOp/CipurMzfFwVZQyHFaAhjzobo1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORd5OE6IejCWSajkAb9baeZu3snvfbor2sPsyw37s7M=;
 b=LfNvPxKtRCCWWZopRfp4ep8hAmwxEA3+I8t9kHfFjUhNOuYi76FSBAilxuqt51+rQO82+Y1lVPdxvH0Jx1iA5T5r1cBPfI9dSFZeK/tLncuQMrDv68lYwphriLXbbCxmyNvAuvxsYkGTJcrXuof17sRvwFRakJBk8p994rPz4V59mg4Vu7CHDB0I4gyxECz6UMC6ZdIfA9xH0iHHoExw0wsW7fVHVYS1HjEEs7v5mMMILw0MCRdSpfo7urPkQPRUfdelyq5i4mHuOVm/0zRguPe38f7jPJHmtfNq7zYXHVsU/cXA5ykmGCjL/BwS3WejG6l0FxsrwkXhSJCTvAHH0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5145.namprd12.prod.outlook.com (2603:10b6:408:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 12:39:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 12:39:49 +0000
Date:   Wed, 13 Jul 2022 15:39:42 +0300
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
Message-ID: <Ys69DiAwT0Md+6ai@shredder>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
X-ClientProxiedBy: VI1PR09CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:28::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fd98c67-59cf-4b5c-9d9a-08da64ccc63a
X-MS-TrafficTypeDiagnostic: BN9PR12MB5145:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+8q7XQAzOog+Sd5+nBAep5ZEfdxayiznUK+yn1BTavJVaNjqxmtETggknXRaOroYY9erqxadJGLw0VCaZpcwwpb6GwhJsSbjpzmr9CgrpImEQuyyT7lKU8DQGQM5fmpN/9sbRjKkgUSWSHRbDq/1Un4pgER+V9J++j5uy0nt8ukjQ8jAb9yjZsh98Y95sLS1aMHQu07MpusIjj7C8vet3DDy3sjx0/zKd97mvaD4lSqjQ8rz0LalRyj6XNd7SSPZFSDYlLSmmDtsboGAOkErFc4gFYvtJpp8m0x/yl0YcOKhzs3m0qaC4DEf3mtzltT4NNS6fOIWGXlGPgT+25GbQZOO1mD8c23MuaRVYLea3mX9ToKsp8PXBkxhgVi8cXnwe65Z6kjF/IsgYJ0hwRqff1wG6xXJy8PxVrszMk5++2vjw41tl66LBbOtxhID3zS313/X/ANeM6k1R2KV+ibFjcFFOIR2n1K56UGZ7BwGkWiomYrWJhLFOIa7ipQ6Dh85trijqh7zxUl4Re5bwfgeEd1w5sdHJIALlCurNhkvrTQLgHJGF0IX2wPL3cY1qrUWg6ijntrCIqNPIE4GTxe4hz2jD7E3acNkJmMp7wOLlqLPstifBoAQUPOSXT1wYf4RU+O5w4HFkLkhdXkCGEs2Fz1ZWsYiNB6+VdTDcCjQ8Y+NkMLP7DvkIUee0sHcTNDzhpd7m0NXpjAYYGMfjYUfPdo2Z3eDeZsp146dQHKQAqw6F8K3AiPd223RSKOlgnHv3j7ei9RzyygCUfJ5tJyZ2M9JZXh9aZUA8Zz5Hwg75AbffwNE+jX5xO1I3xyot54f8y+VbwMk855WCHpZO/LWAFNn5BiqaRjomiRdiAv4O44OqvKNyK1cVrsuoTwZ4Efk2X9Ucxj3w7eJX3CogvlrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(39860400002)(366004)(396003)(84040400005)(186003)(33716001)(38100700002)(7416002)(2906002)(8936002)(5660300002)(6916009)(66476007)(66946007)(66556008)(8676002)(41300700001)(478600001)(26005)(6506007)(6666004)(966005)(9686003)(6512007)(6486002)(53546011)(4326008)(83380400001)(86362001)(54906003)(316002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lZpOd9tyZz+hATbz19fLNbzUEihLwakdAGC+351n+TMEhWXXS2DJAz7ifQEV?=
 =?us-ascii?Q?ehJ1gOxpliuXyuglH8PKJ8QFymCJNEWjQjT3SqD3naxywxsMTT93L3ji/IvP?=
 =?us-ascii?Q?FI8nMLRmI7KIp0yjMNcL8YU2Xh8NGIuprV1PDmz+sHl8j+6LqP9+HacoLGpE?=
 =?us-ascii?Q?T9E1mtU7nsOFkJ1rRmsBqO9JB7nu5PR86fuuG7bNUUsGjdP9sQTcdZ30nF+2?=
 =?us-ascii?Q?TumnF0LiSR0oF2CTvsEiaK8GR2Rb5S/8pVJf2YbYfwjLlb9pjGEC+gKB7g0H?=
 =?us-ascii?Q?EuyokYG2mt538/Md4NUxMZ7faRw9l1RhGmw8Pb7AaHBsI8DNH1aDqY3h+XoV?=
 =?us-ascii?Q?hLnUriryaJMwRf5N8RT4XDTAPGbU2yRy7dmXGNqi8oV+LxTrRVzRUf11gkZ3?=
 =?us-ascii?Q?5h2iynqliRJ2iimxjkxNyEbAqk02ycsuxc6KpKynoaV7QTVTZlQDHNNg1iP9?=
 =?us-ascii?Q?IjWm1ZZqXGyCtnBzJyT04j4uM5wuZEBU/ZvWqe7dM5C+pfyhL+wdmDd7i7T9?=
 =?us-ascii?Q?YoQg26aVyMYgjy1AVvcxE7zcRsW9RzMJdGSXzNOC8O6Xgr8kUtAYxjRny2Rb?=
 =?us-ascii?Q?0RtQz3dPK9SB+3c2jYxW93t4onfRRlloXI30qVoLQrAzsiaPSEARGa9C7cm1?=
 =?us-ascii?Q?3KsZcTT1lVxnN4kxoH2xhKalhKIYPe96w7B8mSWJj4hBDWNnpmx86kC2OQxg?=
 =?us-ascii?Q?3r1suMfHI5ds5XcYkEyTDrU7FvW/OZ8q8sridGGm1V06iYMC36hDQ+ENYgA5?=
 =?us-ascii?Q?20+eFve/knwPCxueirA3V8m3L8DKGL6ykj4nllZDPeEd0Dk6oLj6PFG5NJmx?=
 =?us-ascii?Q?3XLTclrRYW9oPTicZy74ft3IUOovGWDj2lxqej/cSxt8CwS6d8qrbkC92oQ8?=
 =?us-ascii?Q?hr0L4paoU87A668phxfrfOfHz4T5ZYDuVawbOdQmJ5hOssGewzvWDvqwT68k?=
 =?us-ascii?Q?rpvGSnWR5jmGgiLarYApAmuQuES6roh5M5b9zM4qG+CncEDvcpkd7EkUfWbm?=
 =?us-ascii?Q?xQ0bKK9uIwoQBkAN/1SK7rEyhya4S8z+42+Y30qAEHtjwuqvquyiIhXdo16N?=
 =?us-ascii?Q?RkY2tIMaCziyHZrGVqir01BJRl+Qbq/B3vcGT5DtZ3LcyaT50+La2IU5gZCG?=
 =?us-ascii?Q?9b0TwWKDL30Gm12WnC7C6LAUsfdjwmQJCrd/dPhhITmcCDuRXfL3AD5p5oFB?=
 =?us-ascii?Q?ERXIdflprqI10++qkCdYMLN3aRg08Znyqr/VZDbIBLBuM8g9K9VzT98bNk5i?=
 =?us-ascii?Q?3ALs3j+qA4PMY+wn1JkXLXT7gGuMxN0SWLmfT3OGN89BWBelbSV0nG41UlXE?=
 =?us-ascii?Q?6F6X9UcV2zqHYYX1+FSooOGsmyp8Y50MFpTk1SCX/Jm2rsprHW3WBDmVutrW?=
 =?us-ascii?Q?ezFWVH/ttML7kOIJbyb/TU3ptIZ4hLVubYDOQ1qNtqVCtB0aJgbdiDti2ri/?=
 =?us-ascii?Q?AZ4MJN5tZAi1dOmVTmyQsDjYYjD2UicvMj8YKVPlkfC1QwXCrHTecOIHB5mB?=
 =?us-ascii?Q?RdtWjkeVvlrtmPKfv36emOBcfYEeIXELtQtDahanGPhiMhTbIXpQJs9WW3Jo?=
 =?us-ascii?Q?Q1HIkPRRIN3CUz2U1q3m/pRgWQ4tVn4yHUHdjOlm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd98c67-59cf-4b5c-9d9a-08da64ccc63a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 12:39:49.1308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDgETA2X9R1P/5ypKEwBVPqXW/yQ/bBxWmzU2I6UJd5wlIBeaFurmCTwjkdM5EQ7ggy5s00lVgfMM9U7sOCjVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5145
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-10 10:35, Ido Schimmel wrote:
> > On Fri, Jul 08, 2022 at 02:34:25PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-07-08 13:56, Vladimir Oltean wrote:
> > > > On Fri, Jul 08, 2022 at 11:50:33AM +0200, netdev@kapio-technology.com
> > > > wrote:
> > > > > On 2022-07-08 11:15, Vladimir Oltean wrote:
> > > > > > When the possibility for it to be true will exist, _all_ switchdev
> > > > > > drivers will need to be updated to ignore that (mlxsw, cpss, ocelot,
> > > > > > rocker, prestera, etc etc), not just DSA. And you don't need to
> > > > > > propagate the is_locked flag to all individual DSA sub-drivers when none
> > > > > > care about is_locked in the ADD_TO_DEVICE direction, you can just ignore
> > > > > > within DSA until needed otherwise.
> > > > > >
> > > > >
> > > > > Maybe I have it wrong, but I think that Ido requested me to send it
> > > > > to all
> > > > > the drivers, and have them ignore entries with is_locked=true ...
> > > >
> > > > I don't think Ido requested you to ignore is_locked from all DSA
> > > > drivers, but instead from all switchdev drivers maybe. Quite different.
> > > 
> > > So without changing the signature on port_fdb_add(). If that is to
> > > avoid
> > > changing that signature, which needs to be changed anyhow for any
> > > switchcore
> > > driver to act on it, then my next patch set will change the
> > > signarure also
> > > as it is needed for creating dynamic ATU entries from userspace,
> > > which is
> > > needed to make the whole thing complete.
> > > 
> > > As it is already done (with the is_locked to the drivers) and needed
> > > for
> > > future application, I would like Ido to comment on it before I take
> > > action.
> > 
> > It's related to my reply here [1]. AFAICT, we have two classes of device
> > drivers:
> > 
> > 1. Drivers like mv88e6xxx that report locked entries to the bridge
> > driver via 'SWITCHDEV_FDB_ADD_TO_BRIDGE'.
> > 
> > 2. Drivers like mlxsw that trap packets that incurred an FDB miss to the
> > bridge driver. These packets will cause the bridge driver to emit
> > 'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications with the locked flag.
> > 
> > If we can agree that locked entries are only meant to signal to user
> > space that a certain MAC tried to gain authorization and that the bridge
> > should ignore them while forwarding, then there is no point in
> > generating the 'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications. We should
> > teach the bridge driver to suppress these so that there is no need to
> > patch all the device drivers.
> 
> I do not know of all about what other switchcores there are and how they
> work, but those that I have knowledge of, it has been prudent in connection
> with the locked port feature to install Storm Prevention or zero-DPV
> (Destination Port Vector) FDB entries.

What are "Storm Prevention" and "zero-DPV" FDB entries?

> I would think that that should be the case for other switchcores too.
> Those entries cannot normally be installed from userspace (of course special
> tools can do anything).
> 
> But if the decision is to drop locked entries at the DSA layer, I can do
> that. I just want to ensure that all considerations have been taken.

There is no decision that I'm aware of. I'm simply trying to understand
how FDB entries that have 'BR_FDB_ENTRY_LOCKED' set are handled in
mv88e6xxx and other devices in this class. We have at least three
different implementations to consolidate:

1. The bridge driver, pure software forwarding. The locked entry is
dynamically created by the bridge. Packets received via the locked port
with a SA corresponding to the locked entry will be dropped, but will
refresh the entry. On the other hand, packets with a DA corresponding to
the locked entry will be forwarded as known unicast through the locked
port.

2. Hardware implementations like Spectrum that can be programmed to trap
packets that incurred an FDB miss. Like in the first case, the locked
entry is dynamically created by the bridge driver and also aged by it.
Unlike in the first case, since this entry is not present in hardware,
packets with a DA corresponding to the locked entry will be flooded as
unknown unicast.

3. Hardware implementations like mv88e6xxx that fire an interrupt upon
FDB miss. Need your help to understand how the above works there and
why. Specifically, how locked entries are represented in hardware (if at
all) and what is the significance of not installing corresponding
entries in hardware.

> 
> > 
> > [1] https://lore.kernel.org/netdev/YsqLyxTRtUjzDj6D@shredder/
> > 
> > > 
> > > >
> > > > In any case I'm going to take a look at this patch set more closely and
> > > > run the selftest on my Marvell switch, but I can't do this today
> > > > unfortunately. I'll return with more comments.
> > > 
> > > Yes :-)
