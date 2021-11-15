Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1041C4516DB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348954AbhKOVrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351184AbhKOVps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 16:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576FD61B2C;
        Mon, 15 Nov 2021 21:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637012569;
        bh=LVsPdaw2yY7qWBTlOQrq7wYxukq/AP9opsWvdVtsMmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqkD3GfTytoMGYLQ5dXGmYjfMgpBUh/3gTTpinb9tYV/suVLU0EYuVg2ADRV+5Kg3
         sZcYfzrcwmXpyTAzz3Q6u5CEZ/fJGhwoq+vr28dO5Z+T5fox2MNJQhQNeG/0cJxl9v
         vcslsPEb0h49jfKWUABZYDqf/eBEA2NFd6jifzYkJseGOdFm062QuHB7MlDAlwpomE
         1J2j4xBNOTZu7Qm+MR0a0sKFyn0vqpkp4PeGqBIM2MGsdxnZFjbsdA6JGvULL4di7f
         s1R3O9qYO7tqUoTEdnKiffTE/X5gBUvCRCp1D6v1EJkUHtI+YMYmmkSPQDNfFmTkkX
         kPUyjALAmgHYQ==
Date:   Mon, 15 Nov 2021 13:42:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Message-ID: <20211115134248.5d111036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MW5PR11MB58121DC2755B9AADA3516E75EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
        <20211105205331.2024623-7-maciej.machnikowski@intel.com>
        <87r1bqcyto.fsf@nvidia.com>
        <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
        <87mtmdcrf2.fsf@nvidia.com>
        <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
        <87bl2scnly.fsf@nvidia.com>
        <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
        <874k8kca9t.fsf@nvidia.com>
        <MW5PR11MB5812757CFF0ACED1D9CFC5A2EA939@MW5PR11MB5812.namprd11.prod.outlook.com>
        <87y25vbu19.fsf@nvidia.com>
        <MW5PR11MB58121DC2755B9AADA3516E75EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 10:12:25 +0000 Machnikowski, Maciej wrote:
> > > Netdev owns the PHY, so it needs to enable/disable clock from a given
> > > port/lane - other than that it's EECs task. Technically - those subsystems
> > > are separate.  
> > 
> > So why is the UAPI conflating the two?  
> 
> Because EEC can be a separate external device, but also can be integrated
> inside the netdev. In the second case it makes more sense to just return
> the state from a netdev 

I mentioned that we are in a need of such API to Vadim who, among other
things, works on the OCP Timecard. He indicated interest in developing
the separate netlink interface for "DPLLs" (the timecard is just an
atomic clock + GPS, no netdev to hang from). Let's wait for Vadim's work
to materialize and build on top of that.
