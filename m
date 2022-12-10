Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A09F648D0D
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLJEBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiLJEBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:01:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1184567A2B
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 20:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A01A261526
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73D1C433EF;
        Sat, 10 Dec 2022 04:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670644911;
        bh=+FKGa1oq72Oq+r910C1bHpgTL8ZhJFQ+saWR2Tg1X1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MUaw7v5h5HPpjbiyWu/ADs1T0FxKv0GhryROLTIAyjfhM4Qis/3PmGcJG/ap3UX1V
         GXFUFBOh0q1QZlZnmc+sgIUfkH+MoD04umkmqDWOAvtTZENpRJEcjwFbhPf46sSs3f
         j2Sw6QS3gMCtA4CgyGuEi0gmK3ohbfmK+K3raeUAh7gwBUDZPk2JqbYsrd6opUrESt
         2MrxLBTBp8/g1gM32A3wfVV+UHWWpzbkdh6PYyWR+84KN8LpuPLu8sKLtPA0n0zEZc
         RrgfpwkBpCyUYL/oMP6VT1L0S2I35ehhN223EM7xniNppMRVvl+viy1f8nbmJ6h0pV
         uAqE1wIAfJ5oQ==
Date:   Fri, 9 Dec 2022 20:01:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] JSON output support for Netlink implementation
 of --show-coalesce option
Message-ID: <20221209200150.18490ed6@kernel.org>
In-Reply-To: <CAP5jrPHr2UMpKK45NTUVLtW9OiBctZhWP-0yVvb9_SBO3pC7LA@mail.gmail.com>
References: <CAP5jrPHr2UMpKK45NTUVLtW9OiBctZhWP-0yVvb9_SBO3pC7LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 19:16:10 -0700 Max Georgiev wrote:
> JSON output support for Netlink implementation of --show-coalesce option
> 
> Add --json support for Netlink implementation of --show-coalesce option
> No changes for non-JSON output for this feature.

Nice!

> Same output with --json:
> $ sudo ./ethtool --json --show-coalesce enp9s0u2u1u2
> [ {
>         "ifname": "enp9s0u2u1u2",
>         "rx-usecs: ": 15000,
>         "tx-usecs: ": 0

looks like we have double spurious ': ' in the key?

> +       if (silent && !is_json_context())
>                 putchar('\n');

perhaps we can use show_cr() here as well?

> +                       print_uint(PRINT_JSON, label, NULL,
> mnl_attr_get_u32(attr));
> +       } else {

This looks line-wrapped, perhaps try git send-email for v2?
Also subject should say [PATCH ethtool-next], since it's for
the "next" release.
