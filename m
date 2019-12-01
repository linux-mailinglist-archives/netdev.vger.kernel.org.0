Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0307210E37C
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 21:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLAU40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 15:56:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfLAU4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 15:56:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59A8114F64DD2;
        Sun,  1 Dec 2019 12:56:24 -0800 (PST)
Date:   Sun, 01 Dec 2019 12:56:21 -0800 (PST)
Message-Id: <20191201.125621.1568040486743628333.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     prashantbhole.linux@gmail.com, mst@redhat.com, jasowang@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
        <20191126100744.5083-9-prashantbhole.linux@gmail.com>
        <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 12:56:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Sun, 1 Dec 2019 09:39:54 -0700

> Below you just drop the packet which is going to be a bad user
> experience. A better user experience is to detect XDP return codes a
> program uses, catch those that are not supported for this use case and
> fail the install of the program.

This is not universally possible.

Return codes can be calculated dynamically, come from maps potentially
shared with other bpf programs, etc.

So unfortunately this suggestion is not tenable.
