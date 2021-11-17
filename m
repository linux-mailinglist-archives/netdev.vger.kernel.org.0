Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654774547DE
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbhKQN5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:57:47 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44288 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKQN5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:57:46 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 150BE1FD35;
        Wed, 17 Nov 2021 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637157287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmVYrj9bSmv1XTSzwcd/4V0mgANHB4/cgRf2N2QFAj0=;
        b=ctPYvlE+DztX3LTIYNxQ34sSypoOozdCTskzMjgtqzrJyqULwOatGkFwV/fCKzxxCr6eIg
        4M2dpE761nxADzXEQ0XvDUx8t9kJ7hoyiaKhG7Lj7mZ3qhe2SqXJFrmmTg7xDY1n7NDcgv
        ohTtK0EI3RXHGIqRxp+XaSmMoPfxOUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637157287;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmVYrj9bSmv1XTSzwcd/4V0mgANHB4/cgRf2N2QFAj0=;
        b=eOEjQN7ESlJg9KXWrgY3zE69c685vfQ4HSSoJdBpX+Bo2sX4HlnOdfM716CcQuCTIzNfUN
        MwCoKlCDQ2Vz6vBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6CD1F13C94;
        Wed, 17 Nov 2021 13:54:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QgubFqYJlWGwaAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 17 Nov 2021 13:54:46 +0000
Subject: Re: include/net/gro.h:413:22: error: implicit declaration of function
 'csum_ipv6_magic
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org
References: <CA+G9fYsFwhPGCmsYoBkx+LTRWqaKrzQTLedZugnK2qieyTFoxQ@mail.gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <5538d955-1679-6a24-d101-11e2eb39f71b@suse.de>
Date:   Wed, 17 Nov 2021 16:54:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsFwhPGCmsYoBkx+LTRWqaKrzQTLedZugnK2qieyTFoxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/21 3:47 PM, Naresh Kamboju пишет:
> Regression found on riscv and arc gcc-11 build.
> Following build warnings / errors reported on linux next 20211117.
> 
> metadata:
>      git_describe: next-20211117
>      git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>      git_short_log: fd96a4057bd0 (\"Add linux-next specific files for 20211117\")
>      target_arch: riscv
>      toolchain: gcc-11
> 
> build error :
> --------------
> In file included from net/core/dev.c:105:
> include/net/gro.h: In function 'ip6_gro_compute_pseudo':
> include/net/gro.h:413:22: error: implicit declaration of function
> 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'?
> [-Werror=implicit-function-declaration]
>    return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
>                        ^~~~~~~~~~~~~~~
>                        csum_tcpudp_magic
> cc1: some warnings being treated as errors

See 
https://patchwork.kernel.org/project/netdevbpf/patch/20211117100130.2368319-1-eric.dumazet@gmail.com/

> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> link:
> https://gitlab.com/Linaro/lkft/mirrors/next/linux-next/-/jobs/1790398957#L73
> 
> build link:
> -----------
> https://builds.tuxbuild.com/211schgBXkq5zjdda7io29wMONF/build.log
> 
> build config:
> -------------
> https://builds.tuxbuild.com/211schgBXkq5zjdda7io29wMONF/config
> 
> # To install tuxmake on your system globally
> # sudo pip3 install -U tuxmake
> tuxmake --runtime podman --target-arch riscv --toolchain gcc-11
> --kconfig defconfig
> 
