Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD835E76C1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiIWJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiIWJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:22:00 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC51110F71E;
        Fri, 23 Sep 2022 02:21:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u132so11851242pfc.6;
        Fri, 23 Sep 2022 02:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=a5o3HQq6PSNNKoplcJhBieGyZ7YmfPEPc/HaZ7kVhr4=;
        b=l71XoG0FVmOwkkF/Xj22eRs2n5QDgNPRp4MbOz4jmVTzbNZZraimNFPMIVPztWI3vG
         ioNmWO593a2VQs1jNMECzKD3dRoI/Lamyr3TKnR8pe/rUKxjqcm3Qle9RwJAbWbYXkF4
         nZQzSFWOoYSpQWurMiKZX4VSk7ApIUMnBZepZ2NLi3lI9QBuQvKSljtW2rqMJmABturk
         i99Ma8Of9y8VZyjlGi7+ABK0pBtdE3N7lbNzdRnZ1K3wM1DUw8VpqHH2n3IbgbNGSEdA
         HZP8gVV/BWZsU4R+PcSf/bkARKxMhAVCgGR80Srg3m76MDV7J3zIeEfVT5iffRifB97d
         caig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=a5o3HQq6PSNNKoplcJhBieGyZ7YmfPEPc/HaZ7kVhr4=;
        b=p++RDEuNQcE+kpTsNISZt2kgpA9TjWcfGR/mkaQCM+3Gs/W0ct4plAiLejHb2fSKei
         CbVJ8bSbvtkMkN5dZqGDQWFUN9YlyymPYy/sPqDDvX/cbKRirr9KX6KoGcFojsVgGBVO
         4GcEwJ0DxdSY/oOzukkHb4i0P5vcrwu60RLRI3IlxlEiId1oGP7+AoxW08GkBErkgnHI
         2JhAoWZHLmGcK3LW0OFdtoq9opga1WoumiFQC2t7fMobZKVkkcMen5mGAjZrXrZW4I1b
         sHOSr68G9juRpqRISdpHJysjFDQDJL9yRnxom+q0oZyUkZQx3vH1TZkNxWXJQcEg7Rfc
         NvXw==
X-Gm-Message-State: ACrzQf3Vf+ZTFpnSoHwrKvTiN1x4WcIENErS5JxP4aS3PHHrvLiYIhzr
        KoCkqEecFgVOjfk1SB5l18E=
X-Google-Smtp-Source: AMsMyM5gIYBlKzCErfVrcNr4eZD55tbAVqTAfLwBlBY6b5tcExKhBJD1Lsw2vKSd1DatDY3Cp3fQGA==
X-Received: by 2002:a63:4f19:0:b0:43b:ddc9:387c with SMTP id d25-20020a634f19000000b0043bddc9387cmr6639971pgb.333.1663924919179;
        Fri, 23 Sep 2022 02:21:59 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902ea0e00b0016edd557412sm5595120plg.201.2022.09.23.02.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 02:21:58 -0700 (PDT)
Date:   Fri, 23 Sep 2022 17:21:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] selftests/bonding: re-add lladdr target test
Message-ID: <Yy16saDPo5tnkXdp@Laptop-X1>
References: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 10:23:06AM +0200, Matthieu Baerts wrote:
> It looks like this test has been accidentally dropped when resolving
> conflicts in this Makefile.
> 
> Most probably because there were 3 different patches modifying this file
> in parallel:
> 
>   commit 152e8ec77640 ("selftests/bonding: add a test for bonding lladdr target")
>   commit bbb774d921e2 ("net: Add tests for bonding and team address list management")
>   commit 2ffd57327ff1 ("selftests: bonding: cause oops in bond_rr_gen_slave_id")
> 
> The first one was applied in 'net-next' while the two other ones were
> recently applied in the 'net' tree.

Thanks for the fix. Before re-post to net-next, I should wait for some more
time so lladdr test could be applied to net tree.

Hangbin

> 
> But that's alright, easy to fix by re-adding the missing one!
> 
> Fixes: 0140a7168f8b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>  tools/testing/selftests/drivers/net/bonding/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index d14846fcf3d1..e9dab5f9d773 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -4,6 +4,7 @@
>  TEST_PROGS := \
>  	bond-arp-interval-causes-panic.sh \
>  	bond-break-lacpdu-tx.sh \
> +	bond-lladdr-target.sh \
>  	dev_addr_lists.sh
>  
>  TEST_FILES := lag_lib.sh
> 
> base-commit: d05d9eb79d0cd0f7a978621b4a56a1f2db444f86
> -- 
> 2.37.2
> 
