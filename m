Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C2423BF6E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 20:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHDSmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 14:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgHDSmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 14:42:21 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5052922B42;
        Tue,  4 Aug 2020 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596566540;
        bh=LbRILdb+eW1GiqP4V+7QLShhSAFkXp6GT1VixGSGaAg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jTp1n/ITmWcNERjixocaNVXPVk1sDRErGs0EJIz5wzrz0cWT/IkvYWbTRRxwbVV9f
         j14ge84hByIKmaOwlHs9M/jqjlgbbQdJew6DEjx1m3+S8rV1w1BPg1RksKptNvYYQr
         ONQCZ0nocSWdtwPAmYs1LjMleW88ppSxcf+ZSAXQ=
Received: by mail-lj1-f172.google.com with SMTP id s16so29523158ljc.8;
        Tue, 04 Aug 2020 11:42:20 -0700 (PDT)
X-Gm-Message-State: AOAM5330Ql4LUbZObraNjBBX5TVMYom11g40lp5ydd9/cb91Ot/hmIX+
        jzcnQhJ6AsLkWvpJUaSkF7ezZaIexS3GsjaJJrQ=
X-Google-Smtp-Source: ABdhPJzO9Px9MUBXcG5PRGc37mJ6xMOVpmtzZs4vWzy/Kjkf2MheLeE3zE110ss0lKMsQFAlrkslHxu2BTd/JCtHwDY=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr11661719ljh.304.1596566538598;
 Tue, 04 Aug 2020 11:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <1595792274-28580-1-git-send-email-ilial@codeaurora.org>
 <20200726194528.GC1661457@lunn.ch> <20200727.103233.2024296985848607297.davem@davemloft.net>
In-Reply-To: <20200727.103233.2024296985848607297.davem@davemloft.net>
From:   Ilia Lin <ilia.lin@kernel.org>
Date:   Tue, 4 Aug 2020 21:42:06 +0300
X-Gmail-Original-Message-ID: <CA+5LGR3SQ=mUvYehkhUk5AMJd4mi7JchdUrO=5zE9wF8xeiYEg@mail.gmail.com>
Message-ID: <CA+5LGR3SQ=mUvYehkhUk5AMJd4mi7JchdUrO=5zE9wF8xeiYEg@mail.gmail.com>
Subject: Re: [PATCH] net: dev: Add API to check net_dev readiness
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, kuba@kernel.org, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, Ilia Lin <ilia.lin@kernel.org>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and David,

Thank you for your comments!

The client driver is still work in progress, but it can be seen here:
https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/platform/msm/ipa/ipa_api.c#n3842

For HW performance reasons, it has to be in subsys_initcall.

Here is the register_netdev call:
https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/platform/msm/ipa/ipa_v3/rmnet_ipa.c#n2497

And it is going to be in the subsys_initcall as well.

Thanks,
Ilia

On Mon, Jul 27, 2020 at 8:32 PM David Miller <davem@davemloft.net> wrote:
>
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sun, 26 Jul 2020 21:45:28 +0200
>
> > I also have to wonder why a network device driver is being probed the
> > subsys_initcall.
>
> This makes me wonder how this interface could even be useful.  The
> only way to fix the problem is to change when the device is probed,
> which would mean changing which initcall it uses.  So at run time,
> this information can't do much.
