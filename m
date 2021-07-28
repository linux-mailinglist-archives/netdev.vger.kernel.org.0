Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8863D8750
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhG1Fpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233751AbhG1Fpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:45:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74CB60F91;
        Wed, 28 Jul 2021 05:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451149;
        bh=zklXSglKzRovjPembkNEGUc2Sg0e8OpQIEb1zbmPiY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTu0LkN+HjpKbvRjkcugi/HAWS+cQ9ElSsonRdt+Pv9CMbs9mHGqBTfJXMppe8P+8
         27QM654pxifW89ApqFgJkzaGjUdQkTDZaHYB4N4mj8gWJ2/tu+jP6ASQ+/rHf6i2IR
         5umYkopMaIPQhOYee5KBr4PvFmBK15Ucv7HJHuuk=
Date:   Wed, 28 Jul 2021 07:45:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 24/64] staging: wlan-ng: Use struct_group() for memcpy()
 region
Message-ID: <YQDvC4CghCazix4w@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-25-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-25-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:15PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct hfa384x_tx_frame around members
> frame_control, duration_id, address[1-4], and sequence_control, so they
> can be referenced together. This will allow memcpy() and sizeof() to
> more easily reason about sizes, improve readability, and avoid future
> warnings about writing beyond the end of frame_control.
> 
> "pahole" shows no size nor member offset changes to struct
> hfa384x_tx_frame. "objdump -d" shows no meaningful object code changes
> (i.e. only source line number induced differences.)
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/wlan-ng/hfa384x.h     | 16 +++++++++-------
>  drivers/staging/wlan-ng/hfa384x_usb.c |  4 +++-
>  2 files changed, 12 insertions(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
