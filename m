Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834316B7EAE
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCMRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCMREq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1B66A7C;
        Mon, 13 Mar 2023 10:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C39461381;
        Mon, 13 Mar 2023 17:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1D8C433D2;
        Mon, 13 Mar 2023 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678726978;
        bh=xB+JXJkfRoMTJReSFxcyBf5NrKfkYEDZMDzq4QLgzOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdx1cZJArXlLNfUys6mf2viumj5jcQzZWFv/2wuM5JbcOHfi6Sha4u605uTeom2px
         chAtdg2hiRMYPnor8OPjp7L/eoOgDjT8yT0TQJAZh+odMBlyOIwv585v2vISXEv/v6
         xtq//Mne1GiJ4Cr/d+kcY5vG0zAhfMp97l5CMVko=
Date:   Mon, 13 Mar 2023 18:02:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jorge Merlino <jorge.merlino@canonical.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Add symlink in /sys/class/net for interface altnames
Message-ID: <ZA9XPysDlEV/KXu7@kroah.com>
References: <20230313164903.839-1-jorge.merlino@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313164903.839-1-jorge.merlino@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 01:49:03PM -0300, Jorge Merlino wrote:
> Currently interface altnames behave almost the same as the interface
> principal name. One difference is that the not have a symlink in
> /sys/class/net as the principal has.
> This was mentioned as a TODO item in the original commit:
> https://lore.kernel.org/netdev/20190719110029.29466-1-jiri@resnulli.us
> This patch adds that symlink when an altname is created and removes it
> when the altname is deleted.
> 
> Signed-off-by: Jorge Merlino <jorge.merlino@canonical.com>
> ---
>  drivers/base/core.c    | 22 ++++++++++++++++++++++
>  include/linux/device.h |  3 +++
>  net/core/dev.c         | 11 +++++++++++
>  3 files changed, 36 insertions(+)
> 

You also forgot the Documentation/ABI/ update for the new symlink :(
