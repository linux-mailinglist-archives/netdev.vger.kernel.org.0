Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6EC6E08A8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjDMILH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjDMILG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:11:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537A42727;
        Thu, 13 Apr 2023 01:11:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAimFhwJwwrrAXHHKYF2LAGwP8cNNNDKbfTQ+gsiKRgl5HCYmL8Ppcj7pU2ioI0sml0EJRtvMVNTe2++S6X4i3PPcKLq1Hgjf+JiVJBtxg9qnxm6T+0//TbAtF59xF95a6E8UxSgWzrwo7ot5TwtlolpNBJyBYhnJ9idR9E1Wfea7/trUewkPX6zx+mBN/709NcwFzPwLHiJwJ9fNmSEOfE7ONgqe5U4qjLaUIpdTPbC3Cu+NFSRzywfDWio5gOjCQUTo2jmPSYKUdWAgsvCRq2tmgUPaRYHYzsOHoKvSFqkZweNTjvWIqZGs9aY7BCab2JGOAX073UZ7lrhruwlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apDKnDVXBOaZweoZQ9t3CUrr6S2/ZbaxSBdDGZp2F4c=;
 b=O+mJhRVDVxEbXjryB/TNh6rHgn3FYgQflno4+O2xPM9QG47ji+YISVS2g8UxIiqhzSgDukJKJiUZpi4Ay7GVY7WHF+lExdKNB++YsAA7dYGDXCjJ+3HsGsZrpMDwXC131ZqQHFnm46FVSWqhOkF0aUM0YgOXYElCmKN/9IUrtG6acKjipvGlnpuyg1l9ZpCp5XaOG6vPIiCq6NfVDho9YPK+zmtyP70WovB+yf2+j7jcBrby/YKsdssBK83+MjKXk4eKtiUcOVpCmZUDF8GP+588639kXrDZy5wW/JilhGLPlV/0GUIbb+z7ePWKfh6AzNT8itZHdLMQURljxdIxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apDKnDVXBOaZweoZQ9t3CUrr6S2/ZbaxSBdDGZp2F4c=;
 b=QiOyuZw/MoMvAH8GfA8NQW3bu7ZWXmP5hpz24IdIp7Ui6/4zYSeTOk+fDfAAVNxoDvB/0npAyMgJGQO3Ti+twwEF4d+Ukk96XY8LgjY7sXQ5Aio+or7rd2TblNa+xhonC6qnUyvTd8Ovqyw9cX+Z53HtbFKk9aQM9AwBgJM9eLCZ+vJDLGcRwYIfgG8UhFKlYj++qqfnMXhpqown5t3R9APtkXxWYPMyoLZguO8l9yn8dFSKy9zBoF4M13nORdncLQd6WJSibPqEtFzr2ZsH+acHq7v9dZQEsAhWXvlxgRa2ODUy2kBL7MNbyc+sfMJYSFH6VaOukTLsUG+w+XUWoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7872.namprd12.prod.outlook.com (2603:10b6:510:27c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 08:11:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 08:11:00 +0000
Date:   Thu, 13 Apr 2023 11:10:54 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <ZDe5DrHY6JjlDpOY@shredder>
References: <ZCBOdunTNYsufhcn@shredder>
 <20230329160144.GA2967030@bhelgaas>
 <20230329111001.44a8c8e0.alex.williamson@redhat.com>
 <ZCVHtk/wqTAR4Ejd@shredder>
 <20230330124958.15a34c3d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330124958.15a34c3d.alex.williamson@redhat.com>
X-ClientProxiedBy: MR1P264CA0219.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:56::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: 068ab47a-daf3-4924-7695-08db3bf69e38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDNvVefrWujpOnflRyMR4qfaRVWihQ5utP5iQdOSPVhSXEXwBQ5ludWyB2Tbbo0h+AgDSBe73ydfqVUcgO6z6nk4mFNWrQZ5xO3ocZXouEfjqjIoxgxP8ijGSUPUtmhGvc2dpD1f3M3TPVbrtaK9eDQF+xI/nZjQT1xwnrBqAr3eS26RdqxaQERGgTVm5aF8gKkui+iETD2x/vlOnSEN8fXKn2FW4xLdPNW5uhW0/3DW2Tuv7FKNho9lGtH9lYSqn2epPE0QwW3f7WvAC1InmjIHxBzFYIkrgk1qNn6RBeiQ6cUoHRMCA9TCAbSCdX2BoTLOQgQODd2uPCJ8I1tCX+3lc28kVINHlSmvVi02dYgD13b49aeWm+iYWilpUi5aMtrpDN8FXg2v6idNAv+et9QOEJkvmWNHC8esf1i2d5Ey5OLKBZ/ROdOQGcdKhIWpHszu/+daz/DNC2HdVgwulq0rA18s5kzcZ5cYidCujTU4XNhG86Cy3+OY4hu8BfKYFcNc6bCG3ziuu9zTSpmFz8mLJKZsxeuw9HXFf7n/xT89D3HGUra9C/mXM8IuomBkYD+NXXlWtvtu6k+1I35W3sxv4PzW7l0vQJDctmqVnks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(66899021)(6916009)(8676002)(66556008)(66476007)(66946007)(6486002)(4326008)(54906003)(478600001)(41300700001)(316002)(86362001)(6512007)(9686003)(6506007)(26005)(6666004)(966005)(83380400001)(33716001)(5660300002)(8936002)(38100700002)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gm5gUVZ3fO5pvd82MoBWFOLnob1FYMdHSsGVQ0gSTGAUkSyr4l1NTvhfwkJ4?=
 =?us-ascii?Q?tK5USYoGgHdnpTWGF4QcLRjEdKGytntXyh0/VLGSx+GnyZhZm2qXxsQUn+AQ?=
 =?us-ascii?Q?D4G0xKdvPHtIHWSTBEJGYC5LL5yKHeBf1HA5SOS2zDcxMLSg/JXooilAfVeg?=
 =?us-ascii?Q?Sag+t2ZKh0QaGu4goUEoF5kviyGyo4KgtxavxHZ/8w57rr/YIN3rVoAt9Xwt?=
 =?us-ascii?Q?1tLXgUkUPMx+bZ/VkGfSfD4FYZDHIH5OemcsfUZsNvysRnJ4W52GM1SJJ9qS?=
 =?us-ascii?Q?YpE0eKCUz9Eat+Q1Usnyg8gJlmB0Mb4qXi6GxkrH1Zt1EvoXaYSVULa7F44h?=
 =?us-ascii?Q?kBmT5u6M1uUmJ7XG8cqM70FA5B+pFFgrVATI39JclfId8J5LeOJZNgcQqJfn?=
 =?us-ascii?Q?6HpDRm4yavbkl2EiSKwqzSVdP2d5HrU3nya+bzdPss9otOUUCKWc85JTk9RA?=
 =?us-ascii?Q?msOfhQeanRn5hJAxhgcn6x9DnWCu8LAqLthuLdaSCh8epDyy3v4g25F1o0dx?=
 =?us-ascii?Q?Cssh6biZbw9UNcDlFj7k7S66LFuOgomtk44sy9rgNnF2+OSFVR22sPFwtgmy?=
 =?us-ascii?Q?lSRW4T7CYze8IfcPSiNTEfJvv0wI7/LFvsi49Hbq0iSH57a/qbhse9J1OOiM?=
 =?us-ascii?Q?Pv7PzxEiTZmikq75HLVgJTlGjDTrqnBti5dfTKRmhDG9hpCe3e3uFBvDEBDG?=
 =?us-ascii?Q?+hpmqqDAb9VRbyQH4V7v8urRTxJsL1QJ6puFI+vEPIXJMOSBEPBh95kFE/2r?=
 =?us-ascii?Q?3Zg2fTI9v8dVZ2+tzuF+d9Sz9VkeVk06DA/O/TIu5TlcMupPler33/MLYXbe?=
 =?us-ascii?Q?imkH6sfUut1yS2G0ZFaYweDpGcDId9D8wJLpXDwfOdgHmK/GQNresPEUin/1?=
 =?us-ascii?Q?f4Xcmh4Ix4LeMYwG0AewF8+yRQDMj4FDIllOVacu/+K4lciEv5kJbhqLxpe3?=
 =?us-ascii?Q?UJg+3U8mkbAp4yfLjvofVZ0TpGOJYq7gcHVragwOeJt+Tijw9Al1Yk8Qa9J+?=
 =?us-ascii?Q?mLLBX954nXhRLwdUt4BZpp+0jvchFVynwC8Ow5QL1x1IVeFcZgIXCJNHToaz?=
 =?us-ascii?Q?ciR7hv4zbuLtseQLebCp8xNhnCP1d7K/Yo1L8oVlQfYlKeXtR/fl50wlWINf?=
 =?us-ascii?Q?PO3sh8qRpclAqeGxYhkIMGFyVZNwn2lgJQYDoCXflyAiwwyuDlOv+8dqIGFu?=
 =?us-ascii?Q?zkzTO9zd1/yE3+wqRR5y88P8tEdyoRRkJc3I+pXAJl+UewktHmrferJLC8H4?=
 =?us-ascii?Q?reDIQ3n4nTrf4XbijLzUZpqUcQ2QRKJ4RcoqAsEVADRhU2l43gC8LWm9D2/Y?=
 =?us-ascii?Q?+nox5A+mzwHdsv+0Lzou7L/65UKEZbLlP3ehCwA09EyvuexzKDoF3WxuGC1I?=
 =?us-ascii?Q?6Q8naH/uDWu8kVY6eF4RiUoGV1pgBFwNVN0QIHj034ydTeRG+TR9hm1JFdTE?=
 =?us-ascii?Q?WhrZXxNDqYvTmvdEHtTXE601qNGHROh+U/mOXxubmctUnTEZJnEOFWCgd3/l?=
 =?us-ascii?Q?B7OWTABbIkxY4UwbMxvDee9Dwc7fCC8/qhqdSBPcDqXXCQ5Mu2hsNz0gFjtl?=
 =?us-ascii?Q?1obWxBfT9i+QCLKABGbmRneZQxfbrDYD5tuWV9NF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068ab47a-daf3-4924-7695-08db3bf69e38
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 08:11:00.7457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WogURb0EAJhm5T8ubirPGlrs2QIQxZxTvwkVKHl2xYqezinD9n31f5kFWtZ7gI1O+ekjBtq7yMvg5Twmk4BN+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7872
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 12:49:58PM -0600, Alex Williamson wrote:
> On Thu, 30 Mar 2023 11:26:30 +0300
> Ido Schimmel <idosch@nvidia.com> wrote:
> 
> > On Wed, Mar 29, 2023 at 11:10:01AM -0600, Alex Williamson wrote:
> > > I think we don't have it because it's unclear how it's actually
> > > different from a secondary bus reset from the bridge control register,
> > > which is what "bus" would do when selected for the example above.  Per
> > > the spec, both must cause a hot reset.  It seems this device needs a
> > > significantly longer delay though.  
> > 
> > Assuming you are referring to the 2ms sleep in
> > pci_reset_secondary_bus(), then yes. In our case, after disabling the
> > link on the downstream port we need to wait for 500ms before enabling
> > it.
> > 
> > > Note that hot resets can be generated by a userspace driver with
> > > ownership of the device and will make use of the pci-core reset
> > > mechanisms.  Therefore if there is not a device specific reset, we'll
> > > use the standard delays and the device ought not to get itself wedged
> > > if the link becomes active at an unexpected point relative to a
> > > firmware update.  This might be a point in favor of a device specific
> > > reset solution in pci-core.  Thanks,  
> > 
> > I assume you referring to something like this:
> > 
> > # echo 1 > /sys/class/pci_bus/0000:03/device/0000:03:00.0/reset
> > 
> > Doesn't seem to have any effect (network ports remain up, at least).
> > Anyway, this device is completely managed by the kernel, not a user
> > space driver. I'm not aware of anyone using this method to reset the
> > device.
> 
> The pci-sysfs reset attribute is only meant to reset the linked device,
> so if this is a single function device then it might be accessing bus
> reset, but it also might be using FLR or PM reset.  There's a
> reset_method attribute to determine and select.
> 
> In any case, if the device is unaffected, that suggests we're dealing
> with a device that doesn't comply with PCIe reset standards, which
> might suggests it needs a device specific reset or to flag broken reset
> methods regardless.
> 
> Note that QEMU is a vfio-pci userspace driver, so assigning the device
> to a VM, where kernel drivers in the guest are managing the device is a
> use case of userspace drivers which should have a functional reset
> mechanism to avoid data leakage between userspace sessions.
>  
> > If I understand Bjorn and you correctly, we have two options:
> > 
> > 1. Keep the current implementation inside the driver.
> > 
> > 2. Call __pci_reset_function_locked() from the driver and move the link
> > toggling to drivers/pci/quirks.c as a "device_specific" method.
> > 
> > Personally, I don't see any benefit in 2, but we can try to implement
> > it, see if it even works and then decide.
> 
> The second option enables use cases like above, where the PCI-core can
> perform an effective reset of the device rather than embedding that
> into a specific driver.  Even if not intended as a primary use case,
> it's a more complete solution and avoids potentially unhappy users that
> assume such use cases are available.  Thanks,

I believe we are discussing three different issues:

1. Reset by PCI core when driver is bound to the device.
2. Reset by PCI core when driver is not bound to the device.
3. Reset by the driver itself during probe / devlink reload.

These are my notes on each:

1. In this case, the reset_prepare() and reset_done() handlers of the
driver are invoked by the PCI core before and after the PCI reset.
Without them, if the used PCI reset method indeed reset the entire
device, then the driver and the device would be out of sync. I have
implemented these handlers for the driver:
https://github.com/idosch/linux/commit/28bc0dc06c01559c19331578bbba9f2b0460ab5d.patch

2. In this case, the handlers are not available and we only need to
ensure that the used PCI reset method reset the device. The method can
be a generic method such as "pm" or "bus" (which are available in my
case) or a "device_specific" method that is implemented in
drivers/pci/quirks.c by accessing the configuration space of the device.

I need to check if one of the generic methods works for this device and
if not, check with the PCI team what we can do about it.

3. In this case, the driver already issues a reset via its command
interface during probe / devlink reload to ensure it is working with a
device in a clean state. The patch we are discussing merely adds another
reset method. Instead of starting the reset when the command is issued,
the reset will start after toggling the link on the downstream port.

To summarize, I would like to proceed as follows:

1. Submit the following patch that implements the PCI reset handlers for
the device:
https://github.com/idosch/linux/commit/28bc0dc06c01559c19331578bbba9f2b0460ab5d.patch

2. Check if one of the generic reset methods works for this device and
if not, check with the PCI team what we can do about it.

3. Re-submit the current patchset for inclusion.

Note that 2 does not block 3 since the solution for 2 would be either in
the firmware or in drivers/pci/quirks.c.

Please let me know if you are OK with the above.

Thanks
