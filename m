Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB833465A3E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353990AbhLBAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354003AbhLBAGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:06:03 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2E5C0613F1;
        Wed,  1 Dec 2021 16:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=eo9PSSZhLF+ujWvVu12T+z44z8Jx8oZ2nHgUZKcohzw=; b=TlXqHaGGYX9pub/QEm+xkRa7fN
        /TN/rPs28Pp/G6ugt56qe6W7pvfSnzx0qkyhNc5CcolkGoAmvk5HqFdAvoEsI7plKK702XL6mtiJp
        xb2KKPOMXiowdAsgjhgs2Cz/xE+NUs5DU2G3VUviwXkCaAMj3JihNDE8UX8dUchCLv8LtZ/QJm3OQ
        8IDpZ7gdLebZ1BlciIeHB9HXBgC+wNsUnlu/Hs1Mc4j7yNZQaHTjCpMxh4IlDLqT/k59Gn+HtiMTN
        1Bq2M5BRI2InPHjqe4PH2x+lC8XmxXog8uBPVnpa4Ty8zj2LKcaPx6EfQ3YrFP47Td9jDNb2VYqoz
        4GWGtXqQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1msZXx-001iDm-Vb; Thu, 02 Dec 2021 00:01:58 +0000
Message-ID: <5b123d5b-04ca-a849-7118-61453755ed7b@infradead.org>
Date:   Wed, 1 Dec 2021 16:01:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: linux-next: Tree for Dec 1
 (drivers/net/ethernet/microchip/lan966x/lan966x_main.o)
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
References: <20211201163741.5b10f466@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20211201163741.5b10f466@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/21 21:37, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20211130:
> 
> The fscache tree gained a conflict against Linus' tree.
> 
> The tip tree still has its build failure for which I reverted 2 commits.
> 
> The gpio-brgl tree still had its build failure so I used the version from
> next-20211115.
> 
> The akpm tree still had its boot failure for which I reverted 6 commits.
> It also gained a build failure for which I applied a patch.
> 
> Non-merge commits (relative to Linus' tree): 4036
>  4605 files changed, 187261 insertions(+), 88751 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log
> files in the Next directory.  Between each merge, the tree was built
> with a ppc64_defconfig for powerpc, an allmodconfig for x86_64, a
> multi_v7_defconfig for arm and a native build of tools/perf. After
> the final fixups (if any), I do an x86_64 modules_install followed by
> builds for x86_64 allnoconfig, powerpc allnoconfig (32 and 64 bit),
> ppc44x_defconfig, allyesconfig and pseries_le_defconfig and i386,
> arm64, sparc and sparc64 defconfig and htmldocs. And finally, a simple
> boot test of the powerpc pseries_le_defconfig kernel in qemu (with and
> without kvm enabled).
> 
> Below is a summary of the state of the merge.
> 
> I am currently merging 344 trees (counting Linus' and 94 trees of bug
> fix patches pending for the current merge release).
> 
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
> 

on i386 or x86_64:
when # CONFIG_PACKING is not set


ld: drivers/net/ethernet/microchip/lan966x/lan966x_main.o: in function `lan966x_xtr_irq_handler':
lan966x_main.c:(.text+0x5ea): undefined reference to `packing'
ld: lan966x_main.c:(.text+0x611): undefined reference to `packing'
ld: drivers/net/ethernet/microchip/lan966x/lan966x_main.o: in function `lan966x_port_xmit':
lan966x_main.c:(.text+0x7f5): undefined reference to `packing'
ld: lan966x_main.c:(.text+0x82e): undefined reference to `packing'
ld: lan966x_main.c:(.text+0x86f): undefined reference to `packing'
ld: drivers/net/ethernet/microchip/lan966x/lan966x_main.o:lan966x_main.c:(.text+0x8b1): more undefined references to `packing' follow


Please add
	select PACKING
to the driver's Kconfig entry.

-- 
~Randy
