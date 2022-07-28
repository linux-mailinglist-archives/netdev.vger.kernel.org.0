Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D13584645
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiG1TQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiG1TQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:16:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9EBFD1B;
        Thu, 28 Jul 2022 12:16:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id tk8so4742829ejc.7;
        Thu, 28 Jul 2022 12:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ONx1ehxLnyTHA9EEGrHgivf8zt6D9uVlNbHw8cqH7Sk=;
        b=KK9jYcf06DPw+7mBE+NSCi7mIdNf0VdhFuxJN3OVwAoC9vZ3h7Fzv1vGpzQqibX/E6
         QdePBfbEky1h1dDfMpY9OV7kVZ9DOzZyexZZ1gCl4Zu6IxGTSxQA3HlCgPWF5eAtgTBw
         XTQL4+pprLMLE3bR4khWfg+zX8FV+Q+GMVYsMV7ELlAIqtGbtfdS4JeSe0G173QMN+19
         oCl6oxERPFsnlkwoJ9PV6GlJMhBIfVlUcP4R40NqRQ63j8giGu6ZiBygBsDdp/E0wQ5m
         QWF+vgiEA09hMAsIT+/wzQCP7By8QhzFPZJhWwvmtw7x3Wsx8VFtxWfUlbAOx43FlBPq
         p2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ONx1ehxLnyTHA9EEGrHgivf8zt6D9uVlNbHw8cqH7Sk=;
        b=q2ru8zLOlgWLF+LzzQip5CenRn9DTuoUvt6m62/f/uxOkgC25wvRjwT61+SuoKikIH
         ZTEQAWWESFHtlkCOu8F2FlSIFiigBjqPfX1L4zp2Wh3FWs+ss8j+m/SZrvMMpjJOY4sC
         OpuhjwXzSvadYu7/kjUUs9McI7TzQvQ8hZfDtuXaoEhdEH9l96PzJ9pNmc5WduYDXwBk
         h96BYPWkP9hj8cNZ7NEcy10IE+eE38GIz5eGWO5t0V3hrXUYT+FSQfO9n25MusEtOl43
         nqCHL5QUHXDTtAVNjmupMM7jxKYnoXEIipn0vb3VyOInFFygPnrPMzgPIzT74P2cm/nT
         5pyg==
X-Gm-Message-State: AJIora+tILHM2h6ruLt0YQAx1tXGpGFZnoYpwwzY1LsScTm4pfV5o58b
        y0UBd79VJOzQenu+OdpAQO4=
X-Google-Smtp-Source: AGRyM1ssXfbw9msFBGK474SB5QXexyS2qmqCE9sNJQNzZlgkPSJvj2VLHWMtJLgmp9JqJnF0aGCjLQ==
X-Received: by 2002:a17:907:8a0e:b0:72b:9ca3:507 with SMTP id sc14-20020a1709078a0e00b0072b9ca30507mr269063ejc.477.1659035794827;
        Thu, 28 Jul 2022 12:16:34 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id ay15-20020a170906d28f00b00726dbb16b8dsm720901ejb.65.2022.07.28.12.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 12:16:33 -0700 (PDT)
Date:   Thu, 28 Jul 2022 22:16:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220728191630.wjmm4mfbhrvbolqq@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
 <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com>
 <20220728091643.m6c5d36pseenrw6l@skbuf>
 <CAPv3WKd0rbwN2AyGRSG1hUji3KzCdG2S=HfCxk7=Ut3VbmPXGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKd0rbwN2AyGRSG1hUji3KzCdG2S=HfCxk7=Ut3VbmPXGA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 06:56:48PM +0200, Marcin Wojtas wrote:
> There was a regression even for OF in v1, but after switching to
> device_match_fwnode() it works indeed. Anyway patch v4 is imo useful,
> I'll only reword the commit message.

Do you mean patch 4 or patch v4? If patch 4, of course it's useful, but
not for avoiding a regression with OF (case in which I drop all my claims
made earlier about fw_find_net_device_by_node), but rather to actually
get something working with actual ACPI (although perhaps not in this
series, you'll need to add ACPI IDs in the mv88e6xxx driver some time
later as well, maybe you could focus this series just on converting DSA
to play nice with fwnodes). If you're already thinking about the v4 of
this patch set, I'll respond to that in a separate email shortly.
