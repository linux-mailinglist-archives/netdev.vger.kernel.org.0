Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1118A1D6497
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgEPWwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726660AbgEPWwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:52:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0CC061A0C;
        Sat, 16 May 2020 15:52:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l21so5575802eji.4;
        Sat, 16 May 2020 15:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PP2WyeWBRcwUtTtauI38pvOTseYMQkKSYN0LmJyoo8=;
        b=UUGwnTauinMgCOPONXeirGZaWszqyGsDCkkRZFlv9pk/19b4omFGbRa9f7FQZf9sHK
         hX33VfjvwvHjTDVsOLW+RXrpt/Da+oNYhJJygZT4CFoez3W8f45H+I4aO+gRnlLlhT0D
         VfIOMlGuEwY0BzDBF0erk4NNT/8qPgvwBZdck7b/+qmHRTfUM4rWkt59j8Ui7J/IMpKW
         t/fjSQrL5ajHU3kuAbQVw/mNxp1h95KTVHDmhMvgq7kbR1andLkIT5ExrNR0TvvSYkUE
         GGfJd0Kx3vBbaG7YKKUX96vWT5vZdnK65komXTA4NCx38nusndthx0A/KSyDEWhZQ4j9
         h+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PP2WyeWBRcwUtTtauI38pvOTseYMQkKSYN0LmJyoo8=;
        b=bj1rYU9jaY5veb2F7q5uH4i+4f6NNDHQMcbeqrvavvDDbDrlv1sAgRbMhPcx85eykC
         EuYZv5WmPI+9tVpK1rI7utijItYQ+RY1aQm9nYlNeMuAFuNs6G46rAU8URygiabdAkkC
         R95nZ7R1w2KPAzHeVnC905qohyYmDGdpMMTBywAC+6BCGxZkejAXkdqgeLTVrPKlVx8w
         sQyctlFV+Sc0aqk5usCX9x8je9a2+xmBZS68arkKHXpgPUvBe41ogaCu5AMEyw1tuVbr
         H3g0q4XKu25QS1ZLEuUB+A3xIG37MoviVyx3qcErQlTytN9wpHYjDCIAh6UhK0jt2IOn
         /lRQ==
X-Gm-Message-State: AOAM530yas24+pfaq4RFIIF+JzUQ3zru1pyydZqyuNTMzhEZqbY0+ZB6
        MfA93MVAWuEqcJm/zRFOT5GlGsrRqg2Be6sS9PnVl0vo
X-Google-Smtp-Source: ABdhPJwO9M9TUgguhHUlsC85u8TGTwawioIh4xacOwmfUKUXMd4Ur6V8FkO88LaQj5Ft1WG8ETDDoFjUGNwhuLjf7Uw=
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr8507711ejp.113.1589669524903;
 Sat, 16 May 2020 15:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200515031813.30283-1-xulin.sun@windriver.com> <20200516.135336.2032300090729040507.davem@davemloft.net>
In-Reply-To: <20200516.135336.2032300090729040507.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 17 May 2020 01:51:53 +0300
Message-ID: <CA+h21hqo+7UAOYkrs3O7J+WkPsQu26r_kP89j0Mr82kYfx_Z0g@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: replace readx_poll_timeout with readx_poll_timeout_atomic
To:     David Miller <davem@davemloft.net>
Cc:     Xulin Sun <xulin.sun@windriver.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, xulinsun@gmail.com,
        steen.hegelund@microchip.com,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 May 2020 at 23:54, David Miller <davem@davemloft.net> wrote:
>
> From: Xulin Sun <xulin.sun@windriver.com>
> Date: Fri, 15 May 2020 11:18:13 +0800
>
> > BUG: sleeping function called from invalid context at drivers/net/ethernet/mscc/ocelot.c:59
> > in_atomic(): 1, irqs_disabled(): 0, pid: 3778, name: ifconfig
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<ffff2b163c83b78c>] dev_set_rx_mode+0x24/0x40
> > Hardware name: LS1028A RDB Board (DT)
> > Call trace:
> > dump_backtrace+0x0/0x140
> > show_stack+0x24/0x30
> > dump_stack+0xc4/0x10c
> > ___might_sleep+0x194/0x230
> > __might_sleep+0x58/0x90
> > ocelot_mact_forget+0x74/0xf8
> > ocelot_mc_unsync+0x2c/0x38
> > __hw_addr_sync_dev+0x6c/0x130
> > ocelot_set_rx_mode+0x8c/0xa0
>
> Vladimir states that this call chain is not possible in mainline.
>
> I'm not applying this.

(but the essence of the problem is legitimate though)

There are 2 specific things I don't like:
- The problem is claimed to reproduce on "LS1028A RDB Board (DT)"
which does not call ocelot_set_rx_mode. So it claims to fix a problem
for which only Xulin has the ability to decide whether it is the right
solution or not.
- On ocelot, it _looks_ like it is indeed a problem which was
introduced in 639c1b2625af ("net: mscc: ocelot: Register poll timeout
should be wall time not attempts"). But there was no attempt to bring
it up with the author of that patch, who very clearly expressed that
he is working on hardware where the polling timeout is in the order of
milliseconds, and the timeout for the driver is currently set at 100
ms. I'm not very sure that it is desirable to spin in atomic context
for 100 ms.

Thanks,
-Vladimir
