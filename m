Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7763A24517
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfEUAdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:33:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfEUAdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:33:21 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B81BD1400F7CA;
        Mon, 20 May 2019 17:33:20 -0700 (PDT)
Date:   Mon, 20 May 2019 20:33:20 -0400 (EDT)
Message-Id: <20190520.203320.621504228022195532.davem@davemloft.net>
To:     rick.p.edgecombe@intel.com
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        linux-mm@kvack.org, mroos@linux.ee, mingo@redhat.com,
        namit@vmware.com, luto@kernel.org, bp@alien8.de,
        netdev@vger.kernel.org, dave.hansen@intel.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
References: <c6020a01e81d08342e1a2b3ae7e03d55858480ba.camel@intel.com>
        <20190520.154855.2207738976381931092.davem@davemloft.net>
        <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:33:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Date: Tue, 21 May 2019 00:20:13 +0000

> This behavior shouldn't happen until modules or BPF are being freed.

Then that would rule out my theory.

The only thing left is whether the permissions are actually set
properly.  If they aren't we'll take an exception when the BPF program
is run and I'm not %100 sure that kernel execute permission violations
are totally handled cleanly.
