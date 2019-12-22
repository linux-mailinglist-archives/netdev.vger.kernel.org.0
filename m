Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4635A128EF0
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 17:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLVQwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 11:52:12 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45019 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfLVQwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 11:52:12 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so14074609iof.11
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 08:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+q+0cCzz/RomIT1h762ErUkI/mh0yOGLAaQS6h5Vvw=;
        b=FGIU1RJSqcg/j0Gw4doGoeLsoweHSFl7qfNB+ro5RYV9HhUJyDYc6zowQ97rWYEJB+
         /wpFNgW/26MD8Wc51fSXaKx5BnkukCxPX8Ri595jZavHQAse3QBZdLcm/W4b/i8XQzFB
         TYCk0UoxLFcDQOcF5jChql46SnfnqvkruBs5exATC3hIe25GBBFmVvRZ/sx3WwIMt28+
         xnXgrnBzbhAdLrWVqxKxMnd6IkCrsd9aXSJrioZfG3uEUoxngTkLN0TJKMlgRBxeCpeD
         aGwky+e+qQPM0ijhq/ekIq4aTbXrB9Uo0NkXEV2TTFDqkBMSIVWcET71barKF3IchydE
         ypTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+q+0cCzz/RomIT1h762ErUkI/mh0yOGLAaQS6h5Vvw=;
        b=m14kj0UTY7a2EIVrad54VwtwThrj2Os7I6VDkrQv/Dj5zM4v+keqzkifwbj6V5VANG
         8y8QhHCNYe92t7XRI/jLl6zMAWjX7KZ8nEi5YzLaeavca8eMUgz5KoWFP45qacKSSAL+
         zuYC3ksVIxu/pYn7jetyd5kdgpRhGh3C7vpRvD1PtJ2eUr4Wty71ilqIrsTam/cZPzYM
         dUgkarPavDx4SZcrsgPHIZ1/pp8x9nhnOh9Yi+bkBqzTo4thLni5vrnaf2g+Pg866a0G
         oI1uZytXEjwcT+hCntAW1RAA6O+04SZ+74ianBoU5FH4VzO19jI2pGPJk+q1wTfIk6fz
         molg==
X-Gm-Message-State: APjAAAXnAjqKG48zfzT2Mm/9fKzlszTOij2PVTx97H9WlDE3sGrY8CAE
        3gLsrRbj4RfdTVmpd5QoRQLWGuP/AKB/NylMpWk=
X-Google-Smtp-Source: APXvYqxdw/C5EcbgRru7Hzx7qr7z/qgj5MxTJ48SaaLxDZj8Dz3D/+/7YJm7Be8Yjf6/oX9NQ+gPkjfY3DmY3C98vtw=
X-Received: by 2002:a6b:4e08:: with SMTP id c8mr16425050iob.64.1577033531424;
 Sun, 22 Dec 2019 08:52:11 -0800 (PST)
MIME-Version: 1.0
References: <201912220313.FgL3fS3o%lkp@intel.com> <20191222032542.GA44059@ubuntu-m2-xlarge-x86>
In-Reply-To: <20191222032542.GA44059@ubuntu-m2-xlarge-x86>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 22 Dec 2019 08:52:00 -0800
Message-ID: <CAKgT0UdgFyzADHTp7AEpdbF+XZsd8YhrxcPOVSa-05t5vdBjSA@mail.gmail.com>
Subject: Re: [jkirsher-net-queue:dev-queue 5/5] drivers/net/ethernet/intel/e1000e/netdev.c:7604:7:
 warning: address of function 'down' will always evaluate to 'true'
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, kbuild@lists.01.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, it looks like the patch called out below reverted part of my earlier patch:
commit daee5598e491d8d3979bd4ad6c447d89ce57b446
Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date:   Fri Oct 11 08:34:59 2019 -0700

    e1000e: Drop unnecessary __E1000_DOWN bit twiddling

    Since we no longer check for __E1000_DOWN in e1000e_close we can drop the
    spot where we were restoring the bit. This saves us a bit of unnecessary
    complexity.

    Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
    Tested-by: Aaron Brown <aaron.f.brown@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

On Sat, Dec 21, 2019 at 7:37 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Hi Jeff,
>
> We received this build report from the 0day team with clang, seems
> legit. Mind taking a look into it?
>
> Cheers,
> Nathan
>
> On Sun, Dec 22, 2019 at 03:36:15AM +0800, kbuild test robot wrote:
> > CC: kbuild-all@lists.01.org
> > CC: intel-wired-lan@lists.osuosl.org
> > TO: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue.git dev-queue
> > head:   831655569c70675c1622f8c52ed271dc7fdce42f
> > commit: 831655569c70675c1622f8c52ed271dc7fdce42f [5/5] e1000e: Revert "e1000e: Make watchdog use delayed work"
> > config: arm64-defconfig (attached as .config)
> > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 3ced23976aa8a86a17017c87821c873b4ca80bc2)
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout 831655569c70675c1622f8c52ed271dc7fdce42f
> >         # save the attached .config to linux build tree
> >         make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/net/ethernet/intel/e1000e/netdev.c:7604:7: warning: address of function 'down' will always evaluate to 'true' [-Wpointer-bool-conversion]
> >            if (!down)
> >                ~^~~~
> >    drivers/net/ethernet/intel/e1000e/netdev.c:7604:7: note: prefix with the address-of operator to silence this warning
> >            if (!down)
> >                 ^
> >                 &
> >    1 warning generated.
> >
> > vim +7604 drivers/net/ethernet/intel/e1000e/netdev.c
> >
> >   7584
> >   7585        /**
> >   7586         * e1000_remove - Device Removal Routine
> >   7587         * @pdev: PCI device information struct
> >   7588         *
> >   7589         * e1000_remove is called by the PCI subsystem to alert the driver
> >   7590         * that it should release a PCI device.  The could be caused by a
> >   7591         * Hot-Plug event, or because the driver is going to be removed from
> >   7592         * memory.
> >   7593         **/
> >   7594        static void e1000_remove(struct pci_dev *pdev)
> >   7595        {
> >   7596                struct net_device *netdev = pci_get_drvdata(pdev);
> >   7597                struct e1000_adapter *adapter = netdev_priv(netdev);
> >   7598
> >   7599                e1000e_ptp_remove(adapter);
> >   7600
> >   7601                /* The timers may be rescheduled, so explicitly disable them
> >   7602                 * from being rescheduled.
> >   7603                 */
> > > 7604                if (!down)
> >   7605                        set_bit(__E1000_DOWN, &adapter->state);
> >   7606                del_timer_sync(&adapter->watchdog_timer);
> >   7607                del_timer_sync(&adapter->phy_info_timer);
> >   7608
> >   7609                cancel_work_sync(&adapter->reset_task);
> >   7610                cancel_work_sync(&adapter->watchdog_task);
> >   7611                cancel_work_sync(&adapter->downshift_task);
> >   7612                cancel_work_sync(&adapter->update_phy_task);
> >   7613                cancel_work_sync(&adapter->print_hang_task);
> >   7614
> >   7615                if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
> >   7616                        cancel_work_sync(&adapter->tx_hwtstamp_work);
> >   7617                        if (adapter->tx_hwtstamp_skb) {
> >   7618                                dev_consume_skb_any(adapter->tx_hwtstamp_skb);
> >   7619                                adapter->tx_hwtstamp_skb = NULL;
> >   7620                        }
> >   7621                }
> >   7622
> >   7623                unregister_netdev(netdev);
> >   7624
> >   7625                if (pci_dev_run_wake(pdev))
> >   7626                        pm_runtime_get_noresume(&pdev->dev);
> >   7627
> >   7628                /* Release control of h/w to f/w.  If f/w is AMT enabled, this
> >   7629                 * would have already happened in close and is redundant.
> >   7630                 */
> >   7631                e1000e_release_hw_control(adapter);
> >   7632
> >   7633                e1000e_reset_interrupt_capability(adapter);
> >   7634                kfree(adapter->tx_ring);
> >   7635                kfree(adapter->rx_ring);
> >   7636
> >   7637                iounmap(adapter->hw.hw_addr);
> >   7638                if ((adapter->hw.flash_address) &&
> >   7639                    (adapter->hw.mac.type < e1000_pch_spt))
> >   7640                        iounmap(adapter->hw.flash_address);
> >   7641                pci_release_mem_regions(pdev);
> >   7642
> >   7643                free_netdev(netdev);
> >   7644
> >   7645                /* AER disable */
> >   7646                pci_disable_pcie_error_reporting(pdev);
> >   7647
> >   7648                pci_disable_device(pdev);
> >   7649        }
> >   7650
> >
> > ---
> > 0-DAY kernel test infrastructure                 Open Source Technology Center
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
> >
> > --
> > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/201912220313.FgL3fS3o%25lkp%40intel.com.
>
>
