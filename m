Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF15B535D1E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349348AbiE0JVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiE0JVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF236AA6B;
        Fri, 27 May 2022 02:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8F55B823D0;
        Fri, 27 May 2022 09:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4F2C385A9;
        Fri, 27 May 2022 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653643262;
        bh=ez+vHDC1JZcB/q4Ew/Nyp1xMVHDbgDrO5Einjt3rI1Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fp0qRcCM5reRtgw54xqvPVkW6BPvu4O4gz4OU03NnufzAV4is8i2DjZoOq1zQb8c2
         UjvtzMWfTZC8s2apsETWVIzqv60bTNo3unCIl+va6LKfel6wdoK0jx2cNL6O3iwWJv
         n3pwSTz7j5c40e52EJizBgJoxqwF//PPnf4CsBYbn00yREr6BRobJQZAMAsFI808RS
         Mp42fs4uyS5Zp3R4sXMzZFgXAxpWSam3vEuKwagyq2yYpzF7MhZLOZjIELWLiVEuHj
         gnt5g/ARK2DT3sp/hzSbxY/I/BOOZ2rfhGVrITvAdA0VoQ3aFzNMsstZOqvkjLOCcf
         PoCZ35692YRRA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: mainline build failure due to c1918196427b ("iwlwifi: pcie: simplify MSI-X cause mapping")
References: <YpCWIlVFd7JDPfT+@debian>
Date:   Fri, 27 May 2022 12:20:55 +0300
In-Reply-To: <YpCWIlVFd7JDPfT+@debian> (Sudip Mukherjee's message of "Fri, 27
        May 2022 10:13:06 +0100")
Message-ID: <875ylrqqko.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

> The latest mainline kernel branch fails to build for mips allmodconfig
> with the error:
>
> drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1093: error: "CAUSE" redefined [-Werror]
>  1093 | #define CAUSE(reg, mask)                                                \
>       | 
> In file included from ./arch/mips/include/asm/ptrace.h:19,
>                  from ./include/linux/sched/signal.h:14,
>                  from ./include/linux/rcuwait.h:6,
>                  from ./include/linux/percpu-rwsem.h:7,
>                  from ./include/linux/fs.h:33,
>                  from ./arch/mips/include/asm/elf.h:12,
>                  from ./include/linux/elf.h:6,
>                  from ./include/linux/module.h:19,
>                  from ./include/linux/device/driver.h:21,
>                  from ./include/linux/device.h:32,
>                  from ./include/linux/pci.h:37,
>                  from drivers/net/wireless/intel/iwlwifi/pcie/trans.c:7:
> ./arch/mips/include/uapi/asm/ptrace.h:18: note: this is the location of the previous definition
>    18 | #define CAUSE           65
>
> git bisect pointed to c1918196427b ("iwlwifi: pcie: simplify MSI-X cause mapping")
>
> And, reverting it on top of mainline branch has fixed the build failure.

We have a fix:

iwlwifi: pcie: rename CAUSE macro

https://patchwork.kernel.org/project/linux-wireless/patch/20220523220300.682be2029361.I283200b18da589a975a284073dca8ed001ee107a@changeid/

It's marked as accepted but I don't know where it's applied to, Gregory?
This is failing the build, should Linus apply the fix directly to his
tree?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
