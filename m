Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27865149CD9
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgAZUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgAZUaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 15:30:16 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56E3D2070A;
        Sun, 26 Jan 2020 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580070615;
        bh=NQ7soPSayXUaDZW3h+uj3ieHG94SiWtcneFYMuD5Tww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GyicbIwIQyw2LT1l6Gq5FfYYbaOx2XF9FztKQpk2jNBBstY5FL1nmltvGqAy9D97p
         XXeJfZ0yPDGNdxTWaeW4Vkvkm0AxXSDI8xfQiJglxQeJki2RoZ1Q7XDL0aQS0qsTGL
         jQWpYBPTZB89qvmO9HFSX5NIzwaNJdwjujxBohIY=
Date:   Sun, 26 Jan 2020 12:30:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
Message-ID: <20200126123014.0983991d@cakuba>
In-Reply-To: <MN2PR18MB318249831CD5207588443F6EA1080@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
        <20200123091629.0291bbaf@cakuba>
        <MN2PR18MB318249831CD5207588443F6EA1080@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 11:29:50 +0000, Michal Kalderon wrote:
> > On Thu, 23 Jan 2020 12:58:23 +0200, Michal Kalderon wrote:  
> > > Changes from V1
> > > ---------------
> > > - Remove epoch + kernel version from device debug dump
> > > - don't bump driver version  
> > 
> > But you haven't fixed the fact that in patch 1 you already strat changing
> > defines for the new FW version, even though the version is only enforced
> > (reportedly) in patch 9?
> 
> Right, I'll move the version change to patch #1 in V3. 
> 
> However,  the entire series is required (except a few patches not prefixed with FW 8.42.2.0 ) to be
> taken to work correctly with the FW.

Right, exactly.

> Our FW is not backward/forward compatible. 

Well, the driver can also be backward/forward compatible 
(even if only for the short period of a series of patches)
as FW is usually more resource constrained.

> I have mentioned this in the cover letter, the split into smaller patches and prefix with
> FW 8.42.2.0 is to ease review and was done due to previous feedback that it is very difficult to review the FW patches:
> 
> https://www.spinics.net/lists/linux-rdma/msg58810.html
> 
> I am fine with squashing all the patches that are required to working with FW8.42.2.0 into one single patch if that is required and acceptable,
> But I believe that would make reviewing the changes more difficult.

The choice is not either one giant unreviewable patch or a driver
broken between commits. There are tens of Ethernet drivers in tree 
and none of them seems to be having this issue.

Maybe Dave will let it fly this time around but you need to take 
a hard look at your process for the future.
