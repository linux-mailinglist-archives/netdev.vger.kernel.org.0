Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7322CC433
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbgLBRrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387826AbgLBRrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:47:06 -0500
Date:   Wed, 2 Dec 2020 09:46:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606931185;
        bh=rnF2guEnI16N+4+IaYPByJNMh8T9mtkT04/m4fppx2I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Amn2AhUkH/ZIhD0UPzn3hLfXLaWeZIsPgedEnZMJFxiv3MT7wEPLtOv+9RkHh7iMs
         22wkCEflIqQQOBzalaQm8nsmM/KyqYTZ/5x5ehWzu/n647ZfsvuE2W+v3gzk/Sq4LN
         OScQDOT70OIDfcittmeK+o6wc8UdYsk+ETT4CHV4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [net:master 1/3] ERROR: modpost: "__uio_register_device"
 undefined!
Message-ID: <20201202094624.32a959fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
References: <202012021229.9PwxJvFJ-lkp@intel.com>
        <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 20:41:21 -0800 Randy Dunlap wrote:
> On 12/1/20 8:01 PM, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> > head:   2867e1eac61016f59b3d730e3f7aa488e186e917
> > commit: 14483cbf040fcb38113497161088a1ce8ce5d713 [1/3] net: broadcom CNIC: requires MMU
> > config: microblaze-randconfig-r011-20201201 (attached as .config)
> > compiler: microblaze-linux-gcc (GCC) 9.3.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=14483cbf040fcb38113497161088a1ce8ce5d713
> >         git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
> >         git fetch --no-tags net master
> >         git checkout 14483cbf040fcb38113497161088a1ce8ce5d713
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=microblaze 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>, old ones prefixed by <<):
> >   
> >>> ERROR: modpost: "__uio_register_device" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
> >>> ERROR: modpost: "uio_unregister_device" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
> >>> ERROR: modpost: "uio_event_notify" [drivers/net/ethernet/broadcom/cnic.ko] undefined!  
> 
> Jakub,
> 
> This happens due to CONFIG_SCSI_BNX2_ISCSI=m, which selects CNIC
> when it shouldn't.
> 
> Martin Petersen has already merged the SCSI patch for this (for 5.11,
> sadly):
> 
> https://lore.kernel.org/lkml/20201129070916.3919-1-rdunlap@infradead.org/
> 
> 
> Maybe I should have sent them to one or both of you as a 2-patch series (?).
> 
> What should we do next?

Martin is it an option to drop the patch from scsi-staging and put it
in the queue for 5.10 (yours or ours)?
