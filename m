Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A1A6296DE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiKOLLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiKOLKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:10:50 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE272704;
        Tue, 15 Nov 2022 03:10:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id gv23so2433736ejb.3;
        Tue, 15 Nov 2022 03:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mbr+3Oyf/jgtDzTeLLHm4nWo0pnIhfMZ7AtWC3UFAts=;
        b=fRYPLQsoU/BeDgB/PSy9nsXVUqxFPv5U3AdUE3oUr1KgMy+qtuUX+YmLbtb2J2SrF3
         YpH5ynBEZimo6CJMeRvrRpD98VhGeQtlcZkHVy69EIzQoWmCdZKSs/IeQ+c95svRCxhB
         aqToPyqMfjJNw64UYKKt83exoSrwUUzPkZfAyCpfzg2kgcO7Cw2LClSzWBaAoesRQRh0
         pn7Me6rMR/BeanW5gr0FY0uRtKlm9MW04lg/ldRdkkG3HtSIBwIUrA9b/2Aw0IY2w6L/
         4wtZ15F3BCYc+6JSU2Z+25wgBwRMdWEqvEPaTzmHMNLcUWiYDAymOMZEXbP3r83f5vGk
         knjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mbr+3Oyf/jgtDzTeLLHm4nWo0pnIhfMZ7AtWC3UFAts=;
        b=cPLL9ZvGl9/dZi5JFs2jzqAKuEwZVn8588nssqgxm/CMfP9kHcZdPBI7dqnPQgToQ7
         d7JOvpLJ4wRW5x0FH+mycmygoLG2A2/mhqzbnFnq6WgAjXx9V1DoQ8lPLbryWfTxlrMm
         /Z8xJ1Q/2fhdTSaLqvCkDAu4nrZ2Dymaw+nCx68IjNtLzb47RITnbxCv7LNjbeXKLxI+
         Okn3r26pXGHlmLW1gHdLgR9I+l/mKxu+GUHwTFk5cDTBgSBoaSQOsOrHXRh1hb8F3rhF
         u9yypGDu2E/E/+yfRW1dTc93ZOILJ4OPoLrJa9NxiRentpQvjniu4aA5mIjDXlN/dF4L
         Lfaw==
X-Gm-Message-State: ANoB5pmHyGuRCcbtesvyQo5Y6wqxBCM0cwwX6ZyegzUf7llsAXHXsdxU
        DxaSsSM8sbCZOM2odeYV6QQ=
X-Google-Smtp-Source: AA0mqf53CgZfHn+6bAn4nKwqp2JDPLrEsO5ee7Ce55Zvan7XMU28cqB3O6jJZgAXvuK7oDtDfrpIVA==
X-Received: by 2002:a17:906:280c:b0:7ad:88f8:761f with SMTP id r12-20020a170906280c00b007ad88f8761fmr12661981ejc.417.1668510636864;
        Tue, 15 Nov 2022 03:10:36 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id v19-20020aa7cd53000000b0045bd14e241csm6004612edw.76.2022.11.15.03.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:10:36 -0800 (PST)
Date:   Tue, 15 Nov 2022 13:10:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115111034.z5bggxqhdf7kbw64@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:52:40AM +0100, netdev@kapio-technology.com wrote:
> I had a discussion with Jacub, which resulted in me sending a mail to
> maintainers on this. The problem is shown below...
> 
> the phy is marvell/6097/88e3082
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 332 at drivers/net/phy/phy.c:975
> phy_error+0x28/0x54
> Modules linked in:
> CPU: 0 PID: 332 Comm: kworker/0:0 Tainted: G        W          6.0.0 #17
> Hardware name: Freescale i.MX27 (Device Tree Support)
> Workqueue: events_power_efficient phy_state_machine
>   unwind_backtrace from show_stack+0x18/0x1c
>   show_stack from dump_stack_lvl+0x28/0x30
>   dump_stack_lvl from __warn+0xb8/0x114
>   __warn from warn_slowpath_fmt+0x80/0xbc
>   warn_slowpath_fmt from phy_error+0x28/0x54
>   phy_error from phy_state_machine+0xbc/0x218
>   phy_state_machine from process_one_work+0x17c/0x244
>   process_one_work from worker_thread+0x248/0x2cc
>   worker_thread from kthread+0xb0/0xbc
>   kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xc4a71fb0 to 0xc4a71ff8)
> 1fa0:                                     00000000 00000000 00000000 00000000
> 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> ---[ end trace 0000000000000000 ]---

Was that email public on the lists? I don't see it...

The phy_error() is called from phy_state_machine() if one of
phy_check_link_status() or phy_start_aneg() fails.

Could you please print exactly the value of "err", as well as dig deeper
to see which call is failing, all the way into the PHY driver?

Easiest way to do that would probably be something like:

$ trace-cmd record -e mdio sleep 10 &
... do your stuff ...
$ trace-cmd report
    kworker/u4:3-337   [001]    59.054741: mdio_access:          0000:00:00.3 read  phy:0x13 reg:0x01 val:0x7949
    kworker/u4:3-337   [001]    59.054941: mdio_access:          0000:00:00.3 read  phy:0x13 reg:0x09 val:0x0700
    kworker/u4:3-337   [001]    59.055262: mdio_access:          0000:00:00.3 read  phy:0x13 reg:0x0a val:0x4000
    kworker/u4:3-337   [001]    60.075808: mdio_access:          0000:00:00.3 read  phy:0x13 reg:0x1c val:0x3005

"val" will be negative when there is an error. This is to see quicker what fails,
and if some MDIO access ever works.

If you don't want to enable CONFIG_FTRACE or install trace-cmd, you
could also probably do the debugging manually.
