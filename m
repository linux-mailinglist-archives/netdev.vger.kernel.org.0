Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C48473CDE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 07:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhLNGCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 01:02:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53450 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhLNGCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 01:02:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D393AB817EF;
        Tue, 14 Dec 2021 06:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2DFC34604;
        Tue, 14 Dec 2021 06:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639461734;
        bh=Oq5F1xHhWQuZdW7GcGz5FwKlog+bk0yd8vL+ePHpJJ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tXvyQZkCcSalVqCzkdwWo3wNvFc34NsOSSgePKISQ3XtY7koXbk7dCcf6JkuVGG4v
         PpeleWiLti4NoptanODNt6iIaC0B8hkGPov1b9ReOmmJAguG/qhcyTJ/IN+xLN9xGT
         GgAhXd+A3hZcygSqfr3IIRrmFEY8gC3EYgVrd+dsoyRUtkgZq2d/wXhPZWK/Y4LXHV
         wVNBHlrNrw34oNFQi1ceSO3g43JGdiO0dFCyihFtY3mF14dp9i9PkNsoAEu3LgBdnk
         IsL/nA9gvhGQyrkS1tebRNzOv/a4HfBYUjRpCxfinIfumbLferTnAaSvbTuoiUQXFM
         H0PIeG9vIgKOg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] ath11k: Use memset_startat() for clearing queue descriptors
References: <20211213223331.135412-1-keescook@chromium.org>
        <20211213223331.135412-9-keescook@chromium.org>
Date:   Tue, 14 Dec 2021 08:02:07 +0200
In-Reply-To: <20211213223331.135412-9-keescook@chromium.org> (Kees Cook's
        message of "Mon, 13 Dec 2021 14:33:22 -0800")
Message-ID: <87v8zriv1c.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct. Additionally split up a later
> field-spanning memset() so that memset() can reason about the size.
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: ath11k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

What's the plan for this patch? I would like to take this via my ath
tree to avoid conflicts.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
