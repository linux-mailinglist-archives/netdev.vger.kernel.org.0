Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070F01F395B
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgFILQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgFILQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 07:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50236207ED;
        Tue,  9 Jun 2020 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591701377;
        bh=xU2wxxxrsLRWawYxncEIYiWeqskYMvCbos9vXfMghc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvtwVxjvZX99zxaniwh1G9/o2C8apo21iA4dq2KWDskckwppNIRJ7QPE53zLAXYIc
         uBRlDf2dbCmgFsC0L1EUriB6WOyjiI5+3kKbIm+iBUHkklkqL/+wNHQlTMei9K6B15
         rbg0aciyOuk2Uh1MInUEg34BZpUyEO9NZkiVt2aA=
Date:   Tue, 9 Jun 2020 13:16:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
Message-ID: <20200609111615.GD780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-2-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:45:58PM +0300, Stanimir Varbanov wrote:
> This adds description of the level bitmask feature.
> 
> Cc: Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  Documentation/admin-guide/dynamic-debug-howto.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/admin-guide/dynamic-debug-howto.rst b/Documentation/admin-guide/dynamic-debug-howto.rst
> index 0dc2eb8e44e5..c2b751fc8a17 100644
> --- a/Documentation/admin-guide/dynamic-debug-howto.rst
> +++ b/Documentation/admin-guide/dynamic-debug-howto.rst
> @@ -208,6 +208,12 @@ line
>  	line -1605          // the 1605 lines from line 1 to line 1605
>  	line 1600-          // all lines from line 1600 to the end of the file
>  
> +level
> +    The given level will be a bitmask ANDed with the level of the each ``pr_debug()``
> +    callsite. This will allow to group debug messages and show only those of the
> +    same level.  The -p flag takes precedence over the given level. Note that we can
> +    have up to five groups of debug messages.

As was pointed out, this isn't a "level", it's some arbitrary type of
"grouping".

But step back, why?  What is wrong with the existing control of dynamic
debug messages that you want to add another type of arbitrary grouping
to it?  And who defines that grouping?  Will it be
driver/subsystem/arch/author specific?  Or kernel-wide?

This feels like it could easily get out of hand really quickly.

Why not just use tracepoints if you really want to be fine-grained?

thanks,

greg k-h
