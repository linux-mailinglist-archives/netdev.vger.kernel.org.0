Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B9330BD7C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhBBLyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhBBLyS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 06:54:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B443D64ED7;
        Tue,  2 Feb 2021 11:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612266817;
        bh=yUKKgAc95dVxUp/h48LLTDDmisyVTlZHaXblkD8Tt8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1LeUBJ2Rkv8PEH/Y4eVKpxfVPrA6cTA7N2Q5kA4U9fJ5XPuaiDJVhd/F5TpQCNqF
         KOv/8qZahVIyPbCGOnkAYBuaJQ002ivyvWwyIablm57uAIFWXtRu17uN4zuJNB5vwn
         uTkhCj8fzt5DMiRqvlARnqeO8yhyWY8+vCBkxlV8=
Date:   Tue, 2 Feb 2021 12:53:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wanghongzhe <wanghongzhe@huawei.com>
Cc:     luto@amacapital.net, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, wad@chromium.org,
        yhs@fb.com
Subject: Re: [PATCH v1 1/1] Firstly, as Andy mentioned, this should be
 smp_rmb() instead of rmb(). considering that TSYNC is a cross-thread
 situation, and rmb() is a mandatory barrier which should not be used to
 control SMP effects, since mandatory barriers impose unnecessary overhead on
 both SMP and UP systems, as kernel Documentation said.
Message-ID: <YBk9PLpjGybg9W03@kroah.com>
References: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
 <1612260787-28015-1-git-send-email-wanghongzhe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612260787-28015-1-git-send-email-wanghongzhe@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 06:13:07PM +0800, wanghongzhe wrote:
> Secondly, the smp_rmb() should be put between reading SYSCALL_WORK_SECCOMP and reading

<snip>

Your subject line of the patch is a bit odd :)

