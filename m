Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA803157F53
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 17:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBJQBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 11:01:19 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39692 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgBJQBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 11:01:18 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so3910730pfy.6;
        Mon, 10 Feb 2020 08:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=cbKanf+tA6F0D95pERsnfD3BjonYsBX69BhpG0W+VPk=;
        b=XzACNNvNIdlFqYsaAMhi0ncU95qHSIFaPnwh31zwfrK3+LwEUkYaQkvPcWWMQWQYFJ
         jm6Nyp2FeDiV1EONti/QaSUyQWaPZ5PgMxzJDjqTIxZt2Es6VrhIJtAXvFqTRLupo8ob
         9eMaddn7jsZBrKm2cAuB2fRQfC+mGaxoNMLM1poZUDUx45Ka/Qlkk7qDvdaCzh6K+ngI
         Tae5LJ2xM9PezD1sY2ptlyiZj9yV+IxmsQaYG502nIer8Ndm/czPtPrD0D3ah7G+RyRy
         rooEIJoxyjrp++JSNA19m1KVsTp+/FtOY2LYfBLEVqimyTp9tCDSoFcFZzAgno7FypJu
         qm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=cbKanf+tA6F0D95pERsnfD3BjonYsBX69BhpG0W+VPk=;
        b=g86tbVF5baPPhB6LqznN+JIkcf0cvzqiT2AoP5dLNyxtXSEMuGI5gI+EUVjDZ2WSa0
         ff2ybU7+8OtR0jHkoUtwh+I0zQllRqeQA+LTI/0OhtfzZGfFxWLG2smOfOUYppZIe3tC
         EmtRcU6QxP/KzenC/ZxHv2Da2rvHmFvhZeo+49ywZ832Bc9MfYBoTrgkm81DkEVY0wLb
         DZwfejv7HyQqZJFWk7xNHv8SJZ7WMFr0ymGhZA115v4KwqsiUyOPV4V6oh/zOULRcbd8
         r7ax3oSYJwpzHFvxHkBPnqbApbKBqfdV1WpnLnRCQKoaEsB8s7/MkbbuixItKnJUyJnD
         zlCA==
X-Gm-Message-State: APjAAAV9b7vyl1LHFrR40bcgJe3yuirEIXMaWSDB/YFQ0/OuummayHPY
        bKDI4XhSL1B6JwuL2hjMj43AFJFW
X-Google-Smtp-Source: APXvYqwQn33MQiCd1UqJhYOXgX4eUFvs54EiBGJFQe5OlP6a8JHqSE7T9gT8L3Y25VddwDRUCmNhNQ==
X-Received: by 2002:a63:520a:: with SMTP id g10mr2150675pgb.298.1581350478040;
        Mon, 10 Feb 2020 08:01:18 -0800 (PST)
Received: from [172.26.120.14] ([2620:10d:c090:180::6c4])
        by smtp.gmail.com with ESMTPSA id c1sm923234pfa.51.2020.02.10.08.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2020 08:01:17 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     maximmi@mellanox.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, rgoodfel@isi.edu,
        bpf@vger.kernel.org, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finished
Date:   Mon, 10 Feb 2020 08:01:16 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <F64155CD-D3BB-4730-8168-6F6A4C18193F@gmail.com>
In-Reply-To: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
References: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10 Feb 2020, at 7:27, Magnus Karlsson wrote:

> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> introduced a much more lazy way of updating the global consumer
> pointers from the kernel side, by only doing so when running out of
> entries in the fill or Tx rings (the rings consumed by the
> kernel). This can result in a deadlock with the user application if
> the kernel requires more than one entry to proceed and the application
> cannot put these entries in the fill ring because the kernel has not
> updated the global consumer pointer since the ring is not empty.
>
> Fix this by publishing the local kernel side consumer pointer whenever
> we have completed Rx or Tx processing in the kernel. This way, user
> space will have an up-to-date view of the consumer pointers whenever it
> gets to execute in the one core case (application and driver on the
> same core), or after a certain number of packets have been processed
> in the two core case (application and driver on different cores).
>
> A side effect of this patch is that the one core case gets better
> performance, but the two core case gets worse. The reason that the one
> core case improves is that updating the global consumer pointer is
> relatively cheap since the application by definition is not running
> when the kernel is (they are on the same core) and it is beneficial
> for the application, once it gets to run, to have pointers that are
> as up to date as possible since it then can operate on more packets
> and buffers. In the two core case, the most important performance
> aspect is to minimize the number of accesses to the global pointers
> since they are shared between two cores and bounces between the caches
> of those cores. This patch results in more updates to global state,
> which means lower performance in the two core case.
>
> Fixes: 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
> Reported-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
