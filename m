Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1935E1D5E5C
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgEPEEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:04:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbgEPEEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589601851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bPuMwbOjUImOtjQj+iLZNHFF2rUtvqlmQymq+yZrOyo=;
        b=idTY6zd1fVWMm1xtpNQ535joVsaFj1ahxn4nq26b6BU0Aix9147mTAec6n5fXXGMgo6S/7
        X5HEU9CfoIskiUPiAEzxKOlaBodcIxwsxHgPycR9Nx0NrIW7SjDdmIXKKBBtV4Aue6BbQZ
        lbKfMG9KvB/rb9BgzhJ/p/8Wy6Sadvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-mGNI0z85MFWhHnb1rh4xKw-1; Sat, 16 May 2020 00:04:06 -0400
X-MC-Unique: mGNI0z85MFWhHnb1rh4xKw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E1FB1800D42;
        Sat, 16 May 2020 04:04:03 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67D615D9C9;
        Sat, 16 May 2020 04:03:52 +0000 (UTC)
Date:   Sat, 16 May 2020 00:03:48 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, cai@lca.pw,
        dyoung@redhat.com, bhe@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, gpiccoli@canonical.com, pmladek@suse.com,
        tiwai@suse.de, schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] taint: add module firmware crash taint support
Message-ID: <20200516040348.GA3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-2-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:32PM +0000, Luis Chamberlain wrote:
> Device driver firmware can crash, and sometimes, this can leave your
> system in a state which makes the device or subsystem completely
> useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> of scraping some magical words from the kernel log, which is driver
> specific, is much easier. So instead provide a helper which lets drivers
> annotate this.
> 
> Once this happens, scrapers can easily look for modules taint flags
> for a firmware crash. This will taint both the kernel and respective
> calling module.
> 
> The new helper module_firmware_crashed() uses LOCKDEP_STILL_OK as this
> fact should in no way shape or form affect lockdep. This taint is device
> driver specific.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  Documentation/admin-guide/tainted-kernels.rst |  6 ++++++
>  include/linux/kernel.h                        |  3 ++-
>  include/linux/module.h                        | 13 +++++++++++++
>  include/trace/events/module.h                 |  3 ++-
>  kernel/module.c                               |  5 +++--
>  kernel/panic.c                                |  1 +
>  tools/debugging/kernel-chktaint               |  7 +++++++
>  7 files changed, 34 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rafael Aquini <aquini@redhat.com>

