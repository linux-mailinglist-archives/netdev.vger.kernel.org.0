Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75628245B0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 03:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfEUBnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 21:43:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfEUBnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 21:43:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC23214249739;
        Mon, 20 May 2019 18:43:38 -0700 (PDT)
Date:   Mon, 20 May 2019 18:43:36 -0700 (PDT)
Message-Id: <20190520.184336.743103388474716249.davem@davemloft.net>
To:     rick.p.edgecombe@intel.com
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        linux-mm@kvack.org, mroos@linux.ee, mingo@redhat.com,
        namit@vmware.com, luto@kernel.org, bp@alien8.de,
        netdev@vger.kernel.org, dave.hansen@intel.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
References: <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
        <20190520.203320.621504228022195532.davem@davemloft.net>
        <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 18:43:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Date: Tue, 21 May 2019 01:20:33 +0000

> Should it handle executing an unmapped page gracefully? Because this
> change is causing that to happen much earlier. If something was relying
> on a cached translation to execute something it could find the mapping
> disappear.

Does this work by not mapping any kernel mappings at the beginning,
and then filling in the BPF mappings in response to faults?
