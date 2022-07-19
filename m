Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AABF57A3E2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbiGSQBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238478AbiGSQBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:01:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCEA4B4B4;
        Tue, 19 Jul 2022 09:01:21 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y8so20250674eda.3;
        Tue, 19 Jul 2022 09:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R5NV8lh/QLSBV5SugqSDICrSggFKXremEtlOyKUbbQU=;
        b=Fs1ZG2nAZzCgWO5nKCe1YjXiuNItgQzGKlnH0D9WO0+nhW67uyq5/Tn60RJu7HEych
         HemK1Xq8ceBRUn+Oez7ARmmYMqkMEGFs0wQFSTNqZ4Fp1W64NbM6IhKC/1KInHGvXYpA
         FYjAZIzBKd7w736WfUOOoJ8yLy/9qSfsE38hdhOipYSMEIrliOj/I5l1Gr8v/dDz1Xzz
         xhEk9Q2iqQJSUVxmDiedQ+cXjMZoUO24H6y1Dap899dJ4L/Sh46Y83umL7JYd6cDgTxT
         VBBuH5nV3hIf1iX8KcC5jFwfRsfg7gY+Y3ayprCegXfyWuz1BKEgeGBhT6mxZUvvqUbc
         PC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R5NV8lh/QLSBV5SugqSDICrSggFKXremEtlOyKUbbQU=;
        b=L85+SQ13mjzWAR+8y4owf6joO0qkWPT76KuAheXcaR2udO2pf+54idVpkEh1KO+ywz
         gIBXw2X6tFlbpMtHKxRe7SJXdy5qABAWyBIgOf3j+nUc8V4MFtWSeCdaEf/Bz+vzBHj+
         8EwXHfJSOfhZhQ0lgF6g4SXnvCBOJkjIlr6ncgd9KMRd2mXxr+Z7Jev0ouKyHlHbmZS1
         53J/94VVOMod+sjKwa2NjDmRP/IRjvtJ3TJV1tk915ygpZtKn76dTEy6wkW2bkD6T3AG
         hey/givANpPYlWrLpypq3vjqs7bXX4+wBIot20apppySVdMdaZYhe7XvvsIDgyMatRB6
         Rr/Q==
X-Gm-Message-State: AJIora8ywhb3pBea0rKgqCIOIo2cn6Fs5Lkxsc3XUNl3TeB/TVRwJqEG
        RYpGXCNtN6TmvvLdHtNWK2A=
X-Google-Smtp-Source: AGRyM1tYQiiEUmjS3ra7wGFU09/02p9zdPam6rfl1aAJ+JXhmwTUJNMRYCS75qzDwDCSaAeO/1aliA==
X-Received: by 2002:a05:6402:149:b0:431:7dde:9b59 with SMTP id s9-20020a056402014900b004317dde9b59mr44945835edu.339.1658246480420;
        Tue, 19 Jul 2022 09:01:20 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id b6-20020a170906038600b00711edab7622sm6811992eja.40.2022.07.19.09.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 09:01:19 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:01:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 4/9] net: pcs: lynx: Convert to an mdio
 driver
Message-ID: <20220719160117.7pftbeytuqkjagsm@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-5-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711160519.741990-5-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:05:14PM -0400, Sean Anderson wrote:
> This converts the lynx PCS driver to a proper MDIO driver. This allows
> using a more conventional driver lifecycle (e.g. with a probe and
> remove). For compatibility with existing device trees lacking a
> compatible property, we bind the driver in lynx_pcs_create. This is
> intended only as a transitional method. After compatible properties are
> added to all existing device trees (and a reasonable amount of time has
> passed), then lynx_pcs_create can be removed, and users can be converted
> to pcs_get_fwnode.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---

I'm compiling and testing patch by patch now. Here's how things go on
LS1028A at this stage:

[    6.317357] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000110
[    6.326219] Mem abort info:
[    6.329027]   ESR = 0x0000000096000004
[    6.332815]   EC = 0x25: DABT (current EL), IL = 32 bits
[    6.338182]   SET = 0, FnV = 0
[    6.341252]   EA = 0, S1PTW = 0
[    6.344436]   FSC = 0x04: level 0 translation fault
[    6.349378] Data abort info:
[    6.352273]   ISV = 0, ISS = 0x00000004
[    6.356154]   CM = 0, WnR = 0
[    6.359164] [0000000000000110] user address but active_mm is swapper
[    6.365629] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    6.371221] Modules linked in:
[    6.374284] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3317
[    6.383364] Hardware name: LS1028A RDB Board (DT)
[    6.388081] Workqueue: events_unbound deferred_probe_work_func
[    6.393939] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    6.400926] pc : __driver_probe_device+0x1c/0x150
[    6.405646] lr : device_driver_attach+0x58/0xc0
[    6.410190] sp : ffff8000085639c0
[    6.413510] x29: ffff8000085639c0 x28: ffffb1a2587dae50 x27: ffff2b6943304bc0
[    6.420676] x26: ffff2b694330c000 x25: ffff2b69433010a0 x24: ffff2b69bf719898
[    6.427840] x23: ffff2b6941074000 x22: ffff2b6943304000 x21: ffff2b6943301880
[    6.435004] x20: ffff2b6943301800 x19: ffffb1a259faf3d0 x18: ffffffffffffffff
[    6.442168] x17: 000000002b64f81b x16: 000000006d50a0b2 x15: ffff2b6943307196
[    6.449332] x14: 0000000000000002 x13: ffff2b6943307194 x12: 0000000000000003
[    6.456497] x11: ffff2b69433018f0 x10: 0000000000000003 x9 : ffffb1a2578b1e08
[    6.463662] x8 : ffff2b6940b36200 x7 : ffffb1a25a0da000 x6 : 000000003225858e
[    6.470826] x5 : 0000000000000000 x4 : ffff79c76227a000 x3 : 0000000000000000
[    6.477989] x2 : 0000000000000000 x1 : ffff2b6943301800 x0 : ffffb1a259faf3d0
[    6.485153] Call trace:
[    6.487601]  __driver_probe_device+0x1c/0x150
[    6.491971]  device_driver_attach+0x58/0xc0
[    6.496167]  lynx_pcs_create+0x30/0x7c
[    6.499927]  enetc_pf_probe+0x984/0xeb0
[    6.503775]  local_pci_probe+0x4c/0xc0
[    6.507536]  pci_device_probe+0xb8/0x210
[    6.511470]  really_probe.part.0+0xa4/0x2b0
[    6.515665]  __driver_probe_device+0xa0/0x150
[    6.520033]  driver_probe_device+0xb4/0x150
[    6.524228]  __device_attach_driver+0xc4/0x130
[    6.528684]  bus_for_each_drv+0x84/0xe0
[    6.532529]  __device_attach+0xb0/0x1d0
[    6.536375]  device_initial_probe+0x20/0x2c
[    6.540569]  bus_probe_device+0xac/0xb4
[    6.544414]  deferred_probe_work_func+0x98/0xd4
[    6.548956]  process_one_work+0x294/0x6d0
[    6.552979]  worker_thread+0x80/0x460
[    6.556651]  kthread+0x124/0x130
[    6.559887]  ret_from_fork+0x10/0x20
[    6.563475] Code: a9bd7bfd 910003fd a90153f3 f9402422 (39444042)

Disassembly of drivers/base/dd.c shows that dev->p is a NULL pointer,
and dev->p->dead goes right through it. How did we even get here...
device_private_init() should be called by device_add().

Curiously enough, mdio_device_create() only calls device_initialize().
It's mdio_device_register() that calls device_add(). So after this
patch, we cannot call lynx_pcs_create() without calling
mdio_device_register().
