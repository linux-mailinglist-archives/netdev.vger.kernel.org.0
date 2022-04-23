Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361F050CA96
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiDWNaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiDWN2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64180167E0;
        Sat, 23 Apr 2022 06:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9330A611D7;
        Sat, 23 Apr 2022 13:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B15C385A5;
        Sat, 23 Apr 2022 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650720330;
        bh=zxVPO5bmDECXatmB0RKWLBnS085dQKZW1VzRai5v08M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R5+kayZkQBvr37gPmZ+FaFEoi3LGSBZo1BiDxuzOy6am0QFEyTWM20L7gZnXugQHr
         Z/zVy5Q7pvp+Wj8PG7qe9xJqubhp6/HroCzjXyD4i8iiM1v4RDT8NTuboXz6AmGWVx
         YhdXmqwC1P7lzxXPjORq2Y0cRhEkcJZ930z3ghhrS5YqrHsAsMDfLH/NVY/rAg7DyJ
         8nno9NlDqbLmm3lWWEUdZpYfmWWWwuu7f4wv1W25O4dLsLUbgF0iLAsSqJpTkQ64yO
         yh63Ha+I1l+xNFObKpUzWy2GKw/qzwb3yql/RNIOAz9cXE+KnKpQhLbq40RkJQogNx
         Y+dR4YLt83pGQ==
Date:   Sat, 23 Apr 2022 15:25:23 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Skip cmode writable for mv88e6*41
 if unchanged
Message-ID: <20220423152523.1f38e2d8@thinkpad>
In-Reply-To: <20220423132035.238704-1-nathan@nathanrossi.com>
References: <20220423132035.238704-1-nathan@nathanrossi.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Apr 2022 13:20:35 +0000
Nathan Rossi <nathan@nathanrossi.com> wrote:

> The mv88e6341_port_set_cmode function always calls the set writable
> regardless of whether the current cmode is different from the desired
> cmode. This is problematic for specific configurations of the mv88e6341
> and mv88e6141 (in single chip adddressing mode?) where the hidden
> registers are not accessible.

I don't have a problem with skipping setting cmode writable if cmode is
not being changed. But hidden registers should be accessible regardless
of whether you are using single chip addressing mode or not. You need
to find why it isn't working for you, this is a bug.

Marek
