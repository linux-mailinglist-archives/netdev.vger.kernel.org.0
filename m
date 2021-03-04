Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3EE32DB10
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 21:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhCDUSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238842AbhCDUSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 15:18:09 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576DC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 12:17:28 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id c10so25425668ejx.9
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 12:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WGSKm9Ej383HvL8zn4K7PqViZQdlnhfRtVNVuseUiH0=;
        b=P0PCRhETDy2+TkYDuiKmjXoCFVPJfxBm5KWYdyG2PTkUDg35+WKmZiAN4NGMGI9RbF
         Sls7Uay/VHvUq/9Gty6yjtlhyDVm4tjlKlOLuHvqHmhfJ0Qybf+y+uJtYwLa1hLNHmX7
         gyCmRJzC8FFgpRKlfat8qzNXgEUOVQ+dD7uTYJmU2gj/fyeomR4IqsHotC1+pImFKPtT
         K8SbmFCPRmihFIjc9HZ5YEXCg1oT+CtSBV0s+Q/vQaf+lQKZSr6nsTsj2w7lH4DWhtuZ
         6mKaywYlcJW9nTnzLe2qJs8c5lYvwYrdb/3S7y/3FTO5OmhV+5nTKM/3FVa4h94wnlIv
         2AeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WGSKm9Ej383HvL8zn4K7PqViZQdlnhfRtVNVuseUiH0=;
        b=aUIhAl70PSpXxZF9ETViP+CJx/ObPQeElM8ZSLQsDdfapJp26wKU6/gQOOGvvc2BgH
         oare1lSUpRLfWEYBmDqli8ffKMN+SJftXWmJTcfrtY9e6oMq0ZJRsmhh4QZQhcQf3TsX
         tz9xtAnhJeqng/rSj/zkaMrsq9TUndwhR3wJCfK/984eQD8ImCxaYcGEXIT/p2A+HYLo
         9AsFyzQoz30QcahpqV2HbEVFZNOT/at3A+KRjoZl7KnZavxlNcXV6JBkABnb/WJVMqZf
         Y4ER/Tsfk0Cs8oQw23nMOhutYoWdhASsB/shoBWjlpluuHSKwWY2RofNhC1pRmpfnL8X
         O5zw==
X-Gm-Message-State: AOAM5318TiJAfWIL/anWMhvJbsATWQHIuDWGruKdEtxWloLc6LMpC4mV
        x+y/mTa16IEBSdK6zNYt7Fc0fmCQ5Ac=
X-Google-Smtp-Source: ABdhPJws5XTofFV3fTidST500eVx3c0A0NG+DNts3L/ncGXdMTSpCV6T9Kc6kl7oavMUC0CsMSQNQw==
X-Received: by 2002:a17:906:cecc:: with SMTP id si12mr6257798ejb.461.1614889047189;
        Thu, 04 Mar 2021 12:17:27 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id n16sm207903ejy.35.2021.03.04.12.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 12:17:26 -0800 (PST)
Date:   Thu, 4 Mar 2021 22:17:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     michael-dev@fami-braun.de
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCHv2] gianfar: fix jumbo packets+napi+rx overrun crash
Message-ID: <20210304201725.unm27y2hpezgsqm3@skbuf>
References: <20210304195252.16360-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304195252.16360-1-michael-dev@fami-braun.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Mar 04, 2021 at 08:52:52PM +0100, michael-dev@fami-braun.de wrote:
> From: Michael Braun <michael-dev@fami-braun.de>
>
> When using jumbo packets and overrunning rx queue with napi enabled,
> the following sequence is observed in gfar_add_rx_frag:
>
>    | lstatus                              |       | skb                   |
> t  | lstatus,  size, flags                | first | len, data_len, *ptr   |
> ---+--------------------------------------+-------+-----------------------+
> 13 | 18002348, 9032, INTERRUPT LAST       | 0     | 9600, 8000,  f554c12e |
> 12 | 10000640, 1600, INTERRUPT            | 0     | 8000, 6400,  f554c12e |
> 11 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  f554c12e |
> 10 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  f554c12e |
> 09 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  f554c12e |
> 08 | 14000640, 1600, INTERRUPT FIRST      | 0     | 1600, 0,     f554c12e |
> 07 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     f554c12e |
> 06 | 1c000080, 128,  INTERRUPT LAST FIRST | 1     | 0,    0,     abf3bd6e |
> 05 | 18002348, 9032, INTERRUPT LAST       | 0     | 8000, 6400,  c5a57780 |
> 04 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  c5a57780 |
> 03 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  c5a57780 |
> 02 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  c5a57780 |
> 01 | 10000640, 1600, INTERRUPT            | 0     | 1600, 0,     c5a57780 |
> 00 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     c5a57780 |
>
> So at t=7 a new packets is started but not finished, probably due to rx
> overrun - but rx overrun is not indicated in the flags. Instead a new
> packets starts at t=8. This results in skb->len to exceed size for the LAST
> fragment at t=13 and thus a negative fragment size added to the skb.
>
> This then crashes:
>
> kernel BUG at include/linux/skbuff.h:2277!
> Oops: Exception in kernel mode, sig: 5 [#1]
> ...
> NIP [c04689f4] skb_pull+0x2c/0x48
> LR [c03f62ac] gfar_clean_rx_ring+0x2e4/0x844
> Call Trace:
> [ec4bfd38] [c06a84c4] _raw_spin_unlock_irqrestore+0x60/0x7c (unreliable)
> [ec4bfda8] [c03f6a44] gfar_poll_rx_sq+0x48/0xe4
> [ec4bfdc8] [c048d504] __napi_poll+0x54/0x26c
> [ec4bfdf8] [c048d908] net_rx_action+0x138/0x2c0
> [ec4bfe68] [c06a8f34] __do_softirq+0x3a4/0x4fc
> [ec4bfed8] [c0040150] run_ksoftirqd+0x58/0x70
> [ec4bfee8] [c0066ecc] smpboot_thread_fn+0x184/0x1cc
> [ec4bff08] [c0062718] kthread+0x140/0x144
> [ec4bff38] [c0012350] ret_from_kernel_thread+0x14/0x1c
>
> This patch fixes this by checking for computed LAST fragment size, so a
> negative sized fragment is never added.
> In order to prevent the newer rx frame from getting corrupted, the FIRST
> flag is checked to discard the incomplete older frame.
>
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---

Just for my understanding, do you have a reproducer for the issue?
I notice you haven't answered Claudiu's questions posted on v1.
On LS1021A I cannot trigger this apparent hardware issue even if I force
RX overruns (by reducing the ring size). Judging from the "NIP" register
from your stack trace, this is a PowerPC device, which one is it?
