Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9500E6C94CF
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjCZN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjCZNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:55:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E724868D;
        Sun, 26 Mar 2023 06:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIboPYzsujIclQRIGgzqPOmkynzLqyS8UHG15vEkEgmiIUWWCzn9t0sheI7fGAVCsHyxbqNhGUhXe3nc2kv0o3Yejd+uSjP+CdBwjpV3SAkwzWNMe5Sudl5cnlo/73EhCzGkoe5I7pw2i5x7WLH1wpkKMwcEh7R5mBDCebkNsrJj1ycBVAzhaEvSGiwy4VLcOd8dj9n7siJdQU0V8CVf2hfrcTVQyHFFAV7YaBIvg4hPXNL2axd/MIscxsWpMCpRL/bnlBlzwH4vk6ckXmknKuRxrsW2qqWj9xy0TQLUZQSdvP8u9MJy5eImQZM5/g/lSidUkjuEgS2Eyk1ALii7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5RFpX79GJ2EZKenEJTdJ0qq+oRW7Q15gudkYHnnaQA=;
 b=VTSFBjLs80pwqWS2oh+9gqFhRHhJTHgu4fawkpzQDYqHQjpl33EMfMqLwZ8eaRPnUmW7QKENaIq25NU/+mPXQyF5/0nGNGA2587JNyiiQswpgKKRoLuxEj+Bahl6cv4kZb2jD3m2X7b5jlISQrJ5MCjdkZmdTEQRU4o/WuQlM9Axd4p9nPIwGlXWKXg5FUIlVjqUMIoiOTUr9c1mBXLprmGNdLzKXNpweMc7v3EY2pULGoxeCGaWSwJQCmfKxwCi5SfmSNUYiCx/QhIcj1Z2hFA4CCIbV9XshF9SFXc4GlYnY6gmKretbzr7V+86cLHzHBhniyXEQMSsd80/udgLMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5RFpX79GJ2EZKenEJTdJ0qq+oRW7Q15gudkYHnnaQA=;
 b=aoyD+hGxv+4N1BTb96L+MLaPFUoUZ5lh3rVRQEM4XC3hBbwpxCgTJcKMPR6MbExMWxKDqO/ICoN8tXhHFaSk2ODM1I0eHG8yt+WjEnmtdCrjIK/zIuWZSQZg3EdVg4JXo4EXVamGflsmIozxdJFXTk3x3IvYEFzsvcgXYFBy4EQ5s2B59aLgwdTAXTC8MIT8DP5khbOEPXfmSBF26R5DSjNKXR05vpEJqq2jymGCyjD7z778Yl9QYsTYuAmkU7E4aAKsoVY9EboJgOzToxlblHnPTFLkXgi/YT3pCfjvteXTXO2fC4e8ZJAxqlMQr5GERiBrv+8QYpSRaXT7aO+9Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB8466.namprd12.prod.outlook.com (2603:10b6:208:44b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 13:54:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.038; Sun, 26 Mar 2023
 13:54:05 +0000
Date:   Sun, 26 Mar 2023 16:53:58 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <ZCBOdunTNYsufhcn@shredder>
References: <c61d07469ecf5d3053442e24d4d050405f466b76.1679502371.git.petrm@nvidia.com>
 <20230323165115.GA2557618@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323165115.GA2557618@bhelgaas>
X-ClientProxiedBy: LO2P265CA0244.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bae1877-738d-451d-ce6b-08db2e018fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMTyPk3JaQCn8p6Xb3v7kL9WOjszTo4GIV1Lip/JDKFwQhU2bvbgA9ylChIAeHRa3eu/wGpnf7Ath17ubX6hMm5tgJoea/OHwS2BqPG+r75Katss8rSidt5aiSyLrIvaOV4iBItW70tEXALud/6K3zDAsL5ydBDL2qJiD/PYu5q1T/7Zuz53mQS6EIYXCoD4+8zgoInKoTbgELWkEK1XNAbxI5uaRr1grCYD0Z1tDy90skeX8tOps44HiiVwz5NxQkWRHSrjkghnvyyC5Iz5UAgVqusfo4zRYOfeDSFvRCvl/AFyn/fy2nYkCOXJiA8K6igHbA4RLzfdsl+3Y9Gr368STbWP0iuggSElC95u42Xt0h0Fu2A4+m0AQWH3gH2Nym3lS32T8rgWFZFUQjITdAYUIibdjGE+pvPiKzeoHso5izfhD3dayDmxg29nBZXHrr49o30w7gc9TdK9TbI5b7ADuVqw4bWroYLdKnDbhQDYIjQMG52SyZJFZ/uVCiiITxy2gJjLHNojCgU3k4QlXOZ1q1/oHXY0CiORaC5zQtNeL6L0f3Krp6AMn2ykeBoi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(66946007)(66556008)(5660300002)(66476007)(6486002)(316002)(54906003)(4326008)(8676002)(6916009)(8936002)(9686003)(186003)(478600001)(41300700001)(6512007)(26005)(6506007)(83380400001)(38100700002)(33716001)(86362001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TsXVY6w4dhoRsNd8toA7jnhlC2I1+7XxRdYDpNPcfnCLZQh0OfP7h4kqewqG?=
 =?us-ascii?Q?DpxhEAIhPNTqMSVtucnITmUyeekjHodJ2880APMVNUmJZjfdJVZ1luK6lqlu?=
 =?us-ascii?Q?mHnobAJuRmNMFE7/6nYHUX8qfkJ7aCS7wewjPOcZc2tygBskUChfqMRbPfQH?=
 =?us-ascii?Q?yKFgTFXvBNnc92RyY1TCZH5BKQEmrwfMpYhwG/Wt2ima5nlJdOPFmZtAljUx?=
 =?us-ascii?Q?LWj4tpMh9KUjJQ/YdZ+W0IEcSHMpO57xFCUWySmxVcHnLbHUUvlvl00tPgBG?=
 =?us-ascii?Q?J5GTHQjnfuLbGF/IUjasiUm+AHJy3BMdQocJoOGEHcmZz+ApIoMYl9uqOpbH?=
 =?us-ascii?Q?k4xGkK4t3xpbZ1EYGcuwwAAvNfmb6f/tTvFdZExtdUCg5Cvw4YtXWOunWnq6?=
 =?us-ascii?Q?TOpVmS+e+YNKxhhiVLfqdw/P8R+iBQMhMtdCW4mFI4lzdveo+uUFkqH7DeAd?=
 =?us-ascii?Q?9jRTzppfXNlMbjKF3c1o2pbT2a7abuEzILVP7c/waLGIxlgCFDLY3lw0aIWq?=
 =?us-ascii?Q?4EMBwSrNHF2Y1b98m5l7OSSlHYJnCTuZjR9mXhkfe3dTGf1HstBUxapQuFpX?=
 =?us-ascii?Q?0EVMXGDZaDWFdEsgDcwUvCLgRd4MOQyrfyOJE9VLmJBR17vm3heZugfHxtOK?=
 =?us-ascii?Q?aHIMDXr4ipnXgxZ0pOtLwMTGxGxzIS10mh7tE6Ts5g0ACoZcBkvEZUd5Jtq7?=
 =?us-ascii?Q?Kk3gTWRvb8TasJF+E5RJDeseeu3N54wwH+wjMgQyJ4uux0fG63SZdjwUlUGK?=
 =?us-ascii?Q?ELUbYICUbC5gp3GH23f7ZlBoGVkf6nLiDijdB9MyOew6mEcQaiVm3iWjZobC?=
 =?us-ascii?Q?lZS0GK82weXG7Pv8aRE7NSSTXoJVOUnVp/B9cOnziRpcpyIUjuDFEReiYmcp?=
 =?us-ascii?Q?N8qfCaCd0XqpsqHTgKPtPV+j7MjjE5m9wAaT/XHOkhlmk+Iba1pquv2poTXW?=
 =?us-ascii?Q?eEEUJlgSlJvXSEXX9OEPHbTegeW7ZYJ+jqecC9hYmlfuMQZKz8OxZOablXvz?=
 =?us-ascii?Q?Cb8thfgJIL2sWL2ZlCk90cmPTe04cJrs8vFl36k9IN90ArvM31TV2zSrKbXX?=
 =?us-ascii?Q?c6sdLVTlICPWO2Ft5RQbXVOsEt+DTRLuFm5ec+kczXw/L8D7D8Z6MFAmAheR?=
 =?us-ascii?Q?L7z8dG6At2oCbkL41t47wBGuh1OL9tYswwsKdLcVpLAz2HSsj/GcvKwD1bTx?=
 =?us-ascii?Q?6xfjCvdDZBApQTD7bfSDXrdOZ+7BRdPDxiR2xhtRX/lJlQFg+CvHrOnCtv1F?=
 =?us-ascii?Q?LiLYL451WvHHeJjJ8RZxRiX6oXDyagzCq+wmK2wQQg/PMcQiHaKONo6slSfM?=
 =?us-ascii?Q?2pFAc43eUYekoJSgzkPNyaeAX+o26XbSFY06Q3sCCo3ZrdcT29mAdmvL1IAE?=
 =?us-ascii?Q?F9qSkFK7oEngaEprk5Z53XgJ9//GZVhX0hpxErkKo8237C0j97qlL+dkW/uA?=
 =?us-ascii?Q?9Khd1QNMLus4Hiskv5GDjLshA2D0yelUxyr0cowe43+SlG/QKCQNdAS+CBfd?=
 =?us-ascii?Q?cu0w5ewdcp5IHDTGNI6rM+lZAnYSrkNUmxgyRfn37CW6HSYDM/kBp1uRI7pE?=
 =?us-ascii?Q?HBEtM7QaG90NeuJ29xjXlNq/GpdTephq0WoVexq/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bae1877-738d-451d-ce6b-08db2e018fd7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:54:05.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEJgp0PSgRpUzjS35E2nM8ngNHd3DqCvxYfp9mcwGBsF+PJL9G8ewmVifpCsUfNatzpKBlnB3AokipAROnWlsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8466
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

On Thu, Mar 23, 2023 at 11:51:15AM -0500, Bjorn Helgaas wrote:
> Hi Petr, thanks for pointing me here.
> 
> On Wed, Mar 22, 2023 at 05:49:35PM +0100, Petr Machata wrote:
> > From: Amit Cohen <amcohen@nvidia.com>
> > 
> > The driver resets the device during probe and during a devlink reload.
> > The current reset method reloads the current firmware version or a pending
> > one, if one was previously flashed using devlink. However, the reset does
> > not take down the PCI link, preventing the PCI firmware from being
> > upgraded, unless the system is rebooted.
> 
> Just to make sure I understand this correctly, the above sounds like
> "firmware" includes two parts that have different rules for loading:
> 
>   - Current reset method is completely mlxsw-specific and resets the
>     mlxsw core but not the PCIe interface; this loads only firmware
>     part A
> 
>   - A PCIe reset resets both the mlxsw core and the PCIe interface;
>     this loads both firmware part A and part B

Yes. A few years ago I had to flash a new firmware in order to test a
fix in the PCIe firmware and the bug still reproduced after a devlink
reload. Only after a reboot the new PCIe firmware was loaded and the bug
was fixed. Bugs in PCIe firmware are not common, but we would like to
avoid the scenario where users must reboot the machine in order to load
the new firmware.

> 
> > To solve this problem, a new reset command (6) was implemented in the
> > firmware. Unlike the current command (1), after issuing the new command
> > the device will not start the reset immediately, but only after the PCI
> > link was disabled. The driver is expected to wait for 500ms before
> > re-enabling the link to give the firmware enough time to start the reset.
> 
> I guess the idea here is that the mlxsw driver:
> 
>   - Tells the firmware we're going to reset
>     (MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> 
>   - Saves PCI config state
> 
>   - Disables the link (mlxsw_pci_link_toggle()), which causes a PCIe
>     hot reset
> 
>   - The firmware notices the link disable and starts its own internal
>     reset
> 
>   - The mlxsw driver waits 500ms
>     (MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS)
> 
>   - Enables link and waits for it to be active
>     (mlxsw_pci_link_active_check()
> 
>   - Waits for device to be ready again (mlxsw_pci_device_id_read())

Correct.

> 
> So the first question is why you don't simply use
> pci_reset_function(), since it is supposed to cause a reset and do all
> the necessary waiting for the device to be ready.  This is quite
> complicated to do correctly; in fact, we still discover issues there
> regularly.  There are many special cases in PCIe r6.0, sec 6.6.1, and
> it would be much better if we can avoid trying to handle them all in
> individual drivers.

I see that this function takes the device lock and I think (didn't try)
it will deadlock if we were to replace the current code with it since we
also perform a reset during probe where I believe the device lock is
already taken.

__pci_reset_function_locked() is another option, but it assumes the
device lock was already taken, which is correct during probe, but not
when reset is performed as part of devlink reload.

Let's put the locking issues aside and assume we can use
__pci_reset_function_locked(). I'm trying to figure out what it can
allow us to remove from the driver in favor of common PCI code. It
essentially invokes one of the supported reset methods. Looking at my
device, I see the following:

 # cat /sys/class/pci_bus/0000\:01/device/0000\:01\:00.0/reset_method 
 pm bus

So I assume it will invoke pci_pm_reset(). I'm not sure it can work for
us as our reset procedure requires us to disable the link on the
downstream port as a way of notifying the device that it should start
the reset procedure.

We might be able to use the "device_specific" method and add quirks in
"pci_dev_reset_methods". However, I'm not sure what would be the
benefit, as it basically means moving the code in
mlxsw_pci_link_toggle() to drivers/pci/quirks.c. Also, when the "probe"
argument is "true" we can't actually determine if this reset method is
supported or not, as we can't query that from the configuration space of
the device in the current implementation. It's queried using a command
interface that is specific to mlxsw and resides in the driver itself.
Not usable from drivers/pci/quirks.c.

> 
> Of course, pci_reset_function() does *not* include details like
> MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS.
> 
> I assume that flashing the firmware to the device followed by a power
> cycle (without ever doing MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> would load the new firmware everywhere.  Can we not do the same with a
> PCIe reset?

Yes, that's what we would like to achieve.

Thanks for the feedback!
