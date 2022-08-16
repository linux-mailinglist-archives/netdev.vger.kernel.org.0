Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E685955FC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiHPJOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiHPJNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:13:49 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84D520BF1;
        Tue, 16 Aug 2022 00:29:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k14so8673402pfh.0;
        Tue, 16 Aug 2022 00:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mH1RjIhrn3aTtFyCwsCBvghOzpu3SOjgxxeBJokMeGs=;
        b=bQ++3ewJ5b1mkfkRwtY/lFZjK+RQFbmhzW2sFLKkLiDVC/7jLmcJZao4iOMQm4R5Mn
         eYlJPnqeRMLYwfRmHXqCpvxt2NxZ+nptfXn++9q06WT8LY4TgODwtxgXor+tnuYhIDeF
         NFGhZt8MY2PzkWamFGJvCis/qHLTq0V64gIoxYov1ZSz8xJ35YUJxYETm0s/bNwNilvB
         bywig2MG7n7YQDjaTCOPVDs6C3gSTDMjd6U8IIJ8rCejeUGYc9aRuTwdchoN0gaZvcJR
         MX5JokCiDvsUWClL+wLFYSt1IPBWFvxa/uYzmr4tLCCGSADMpUDl7RlZf93DP4/LVBpL
         WAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mH1RjIhrn3aTtFyCwsCBvghOzpu3SOjgxxeBJokMeGs=;
        b=TeFXGQlF7nkn4d1keBTLGFDoQFhOJ2R/OUDDPG4SgEP3mlyxvSFOadifck69Mj+c1g
         VlPYT7BtQiqQB6pOSvQFd724tRc5cTbPn0QdEbPcPjrmzJxYtDmxHYMK+GzMMvVfoGgX
         o65Qvz0RKdgwAZfmP6tdbrvBZQHb6BMgjBHOSlnV4pWlIKdJmRv4FWrxyMTFLwNKZUkc
         TYA1Z3nHqm3kcJ+yry44F/nUAG9fg5PwdRoAC2a8FbNYWxf6mg0E+HyfrY0oiMLxNBNG
         WjSHiSs1TXboOmvfk+y3pmwwyt2b+TeGNdFZXZp7d09TIo60gVLFdTy8bOOL5aUQKWxG
         cNPQ==
X-Gm-Message-State: ACgBeo1f4rBR5qGxsnBER7HoMsGlZK7qOqRwEwP0k+LPy5Wg9nEQ9a8d
        AsLBHHQrQYL/VsncWOL/zH0=
X-Google-Smtp-Source: AA6agR4MGBJnpQx+M7cZDeNam6p/GTiltcfQJBve8I/U3lKM9dJRI6QW9Myzjt6hhQQvP+kf15uDXg==
X-Received: by 2002:a62:7b8e:0:b0:535:2420:7fc2 with SMTP id w136-20020a627b8e000000b0053524207fc2mr3474466pfc.60.1660634951171;
        Tue, 16 Aug 2022 00:29:11 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y85-20020a626458000000b005286124df03sm7675410pfb.87.2022.08.16.00.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:29:10 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:29:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] bonding: 802.3ad: fix no transmission of
 LACPDUs
Message-ID: <YvtHQCkyKBTiP4aw@Laptop-X1>
References: <cover.1660572700.git.jtoppins@redhat.com>
 <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:08:35AM -0400, Jonathan Toppins wrote:
> This is caused by the global variable ad_ticks_per_sec being zero as
> demonstrated by the reproducer script discussed below. This causes
> all timer values in __ad_timer_to_ticks to be zero, resulting
> in the periodic timer to never fire.
> 
> To reproduce:
> Run the script in
> `tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh` which
> puts bonding into a state where it never transmits LACPDUs.
> 
> line 44: ip link add fbond type bond mode 4 miimon 200 \
>             xmit_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
> setting bond param: ad_actor_sys_prio
> given:
>     params.ad_actor_system = 0
> call stack:
>     bond_option_ad_actor_sys_prio()
>     -> bond_3ad_update_ad_actor_settings()
>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>             params.ad_actor_system == 0
> results:
>      ad.system.sys_mac_addr = bond->dev->dev_addr
> 
> line 48: ip link set fbond address 52:54:00:3B:7C:A6
> setting bond MAC addr
> call stack:
>     bond->dev->dev_addr = new_mac
> 
> line 52: ip link set fbond type bond ad_actor_sys_prio 65535
> setting bond param: ad_actor_sys_prio
> given:
>     params.ad_actor_system = 0
> call stack:
>     bond_option_ad_actor_sys_prio()
>     -> bond_3ad_update_ad_actor_settings()
>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>             params.ad_actor_system == 0
> results:
>      ad.system.sys_mac_addr = bond->dev->dev_addr
> 
> line 60: ip link set veth1-bond down master fbond
> given:
>     params.ad_actor_system = 0
>     params.mode = BOND_MODE_8023AD
>     ad.system.sys_mac_addr == bond->dev->dev_addr
> call stack:
>     bond_enslave
>     -> bond_3ad_initialize(); because first slave
>        -> if ad.system.sys_mac_addr != bond->dev->dev_addr
>           return
> results:
>      Nothing is run in bond_3ad_initialize() because dev_add equals
>      sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
>      never initialized anywhere else.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> 
> Notes:
>     v2:
>      * split this fix from the reproducer
>     v3:
>      * rebased to latest net/master
> 
>  drivers/net/bonding/bond_3ad.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
> index d7fb33c078e8..957d30db6f95 100644
> --- a/drivers/net/bonding/bond_3ad.c
> +++ b/drivers/net/bonding/bond_3ad.c
> @@ -84,7 +84,8 @@ enum ad_link_speed_type {
>  static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
>  	0, 0, 0, 0, 0, 0
>  };
> -static u16 ad_ticks_per_sec;
> +
> +static u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
>  static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
>  
>  static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
> -- 
> 2.31.1
> 

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
