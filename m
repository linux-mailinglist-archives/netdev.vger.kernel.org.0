Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6500130A5C7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhBAKuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhBAKuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:50:00 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D5AC061574;
        Mon,  1 Feb 2021 02:49:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p21so17857pld.8;
        Mon, 01 Feb 2021 02:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ahVfaMAWzVEmDVakumdMajUgJJioFFzCyRQz4vDITs=;
        b=Rmoj8mVpr1W7qSeYZBZ0qhcys4NlgEkxlzHARgrrzK0bU0xgpWaD8jygwlPmiWCDyU
         NVQqBQNNEJ3++zbaToXcHRYb5fYuyAOUCWC+DDS8cYrEVCjpnU+c8qESkyg/cL3oJVvZ
         E3tQcp0e1yg+yhxAvo+F55prKc+eX2OSK7UCv25a/W1BYXjpc/YJDeAb57L9CbfqLcYR
         apmT+tduUXgHmP2IZ5HMh0gcqpjK+kjO0vbWopdcT0KgGWQCddBniXrT6JgGVMI+14DW
         bH9CQjn6JRX1zArG1tKsQd9kZWycm4Pac3mjCAc1+Nj3ce4WDjzqo3V7jbxqQE7be+E/
         CLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ahVfaMAWzVEmDVakumdMajUgJJioFFzCyRQz4vDITs=;
        b=E/55DDhPx2lnzMfTnCdyoNU+W1eon2ci9nTiGHYNlJ3VYlgkkdD+NMLq76IxC0F0nj
         ZITf7rDuBijK84RUAOArwAHuzJRGFq4S5L+jqI2jVAASEBSBP7QMIbBQMuzxi5izMd+u
         13REZ5iQDUw/RmeOZ6cnjzPCaiiIgImGFvgloAIgfV2P5if8yQYdolLMBE5VDA+hSKm1
         o6v8fhFKPUiN0M1nUb7smRVYuyfTTIjcFwoyjv/aX6uAE3srbqvSNQp4WjdPRt7KYI+v
         /6fdvOkEcbHNgDPG0JXhjuq8DPoHQeVErLF7eFkQI4hwhmLaADSSGi5nMfgXdJqi4IzU
         kmQA==
X-Gm-Message-State: AOAM532UzZ7BDcgCX6VyDHmIqX4btxg8C3advDinbtfFiUDnlBM3Hlh8
        JQPvNIG2QaJenorBsRgW2nm1E0r1d5wAhg0g/PM1To7oU0Q=
X-Google-Smtp-Source: ABdhPJx/V7cJxBaaaN5qkG92D/OmbggN6xscN4orBVppu/kwnEFwvHEBWll8pJC9GhMHDjYGCEk/Iz2YICrByVMa8xY=
X-Received: by 2002:a17:90a:ee8a:: with SMTP id i10mr2471119pjz.210.1612176560078;
 Mon, 01 Feb 2021 02:49:20 -0800 (PST)
MIME-Version: 1.0
References: <20210201055706.415842-1-xie.he.0141@gmail.com> <204c18e95caf2ae84fb567dd4be0c3ac@dev.tdt.de>
In-Reply-To: <204c18e95caf2ae84fb567dd4be0c3ac@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Feb 2021 02:49:09 -0800
Message-ID: <CAJht_EPGk871aqK-1+=W7vGZrX8QY8LDVF26jkFjm3veeQmPWw@mail.gmail.com>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 2:05 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> What kind of packages do you mean are corrupted?
> ETH_P_X25 or ETH_P_HDLC?

I mean ETH_P_X25. I was using "lapbether.c" to test so there was no ETH_P_HDLC.

> I have also sent a patch here in the past that addressed corrupted
> ETH_P_X25 frames on an AF_PACKET socket:
>
> https://lkml.org/lkml/2020/1/13/388
>
> Unfortunately I could not track and describe exactly where the problem
> was.

Ah... Looks like we had the same problem.

> I just wonder when/where is the logically correct place to copy the skb.
> Shouldn't it be copied before removing the pseudo header (as I did in my
> patch)?

I think it's not necessary to copy it before removing the pseudo
header, because "skb_pull" will not change any data in the data
buffer. "skb_pull" will only change the values of "skb->data" and
"skb->len". These values are not shared between clones of skbs, so
it's safe to change them without affecting other clones of the skb.

I also choose to copy the skb in the LAPB module (rather than in the
drivers) because I see all drivers have this problem (including the
recently deleted x25_asy.c driver), so it'd be better to fix this
issue in the LAPB module, for all drivers.
