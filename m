Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6553F2CAA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbhHTNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238220AbhHTNCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240D760F91;
        Fri, 20 Aug 2021 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629464507;
        bh=hR9/dWKch9bWcZVekLGpeTN+QgH+wrPKEnQu7sKE6gE=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=iL5B0OnfS09Z6jgzNGIvcQFyqKtx0MIgVwjS6nXRztExcUS2/6XSytizisvwUSaBH
         A0JSHcr9CVtXdkxzt+kWsv5yS6u1cwiRgw5/B3WFYCgaMIs4xP6ri3x92TnItlwdzH
         6kLmpnpPgryp0SPPhYNqZh2RrqypcTQFBX9LbS6VjLhq+qXmPuGwzdRKiDm9GaBC0W
         Moy8HGrP/pCRHSH5Q0Qki/1eY7EPHmaczPRKJqimZYN33s08zrijFsE31SDeyowHxm
         E813jEqNaw7/Y6UHsN6VohsEPFQRSsv7+AeRbyiCVrSmxRUiseUY+uVSBXeikij8vf
         +8lrCMkrSIN7A==
Date:   Fri, 20 Aug 2021 15:01:43 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Kees Cook <keescook@chromium.org>
cc:     linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 22/63] HID: cp2112: Use struct_group() for memcpy()
 region
In-Reply-To: <20210818060533.3569517-23-keescook@chromium.org>
Message-ID: <nycvar.YFH.7.76.2108201501340.15313@cbobk.fhfr.pm>
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-23-keescook@chromium.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021, Kees Cook wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct cp2112_string_report around members report,
> length, type, and string, so they can be referenced together. This will
> allow memcpy() and sizeof() to more easily reason about sizes, improve
> readability, and avoid future warnings about writing beyond the end of
> report.
> 
> "pahole" shows no size nor member offset changes to struct
> cp2112_string_report.  "objdump -d" shows no meaningful object
> code changes (i.e. only source line number induced differences.)
> 
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

