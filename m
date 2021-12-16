Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DA6477391
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhLPNuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:50:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42256 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbhLPNug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:50:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DEF3B8242A;
        Thu, 16 Dec 2021 13:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714ACC36AE8;
        Thu, 16 Dec 2021 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639662633;
        bh=AbhvMEHMWIrh7e9CWfIY2JYFJ5gwFAB2jgOuFsthmyo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TKA/FRmozr/tU9ROOvxVLYg3DipKuXOctyxmMbr+Y00XEedVcaedz+AU3/dozv3sZ
         q/M2W8KveteIB15BVbsnZLQ6iMY1tlu0jZWs9oQSP5GS5wJE9aMLirA8VC7YaohsLa
         rH6wpHX2MzlsX0T1V5qucjcz0zP91IkE3JwYNgWOis9h3wBVm8qRhejoeolUgVIfDy
         PcKZ0bByGv1gqQ23Cu+HhYblN5jtReKBHx9BIKLqwRXj17EKkW5WJsaHOYmSCyQEsr
         XkXQuKDFrinrS6WR7DTFRLraLADZUOa5Prd6/wxzbNH9cYLsziwhiZA9bILnWhCl/r
         /Dz/zMWeaYFDw==
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
        <87v8zriv1c.fsf@codeaurora.org> <877dc7i3zc.fsf@codeaurora.org>
        <202112140904.2D64E570@keescook>
Date:   Thu, 16 Dec 2021 15:50:25 +0200
In-Reply-To: <202112140904.2D64E570@keescook> (Kees Cook's message of "Tue, 14
        Dec 2021 09:05:37 -0800")
Message-ID: <875yrod5ge.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Tue, Dec 14, 2021 at 05:46:31PM +0200, Kalle Valo wrote:
>> Kalle Valo <kvalo@kernel.org> writes:
>> 
>> > Kees Cook <keescook@chromium.org> writes:
>> >
>> >> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> >> field bounds checking for memset(), avoid intentionally writing across
>> >> neighboring fields.
>> >>
>> >> Use memset_startat() so memset() doesn't get confused about writing
>> >> beyond the destination member that is intended to be the starting point
>> >> of zeroing through the end of the struct. Additionally split up a later
>> >> field-spanning memset() so that memset() can reason about the size.
>> >>
>> >> Cc: Kalle Valo <kvalo@codeaurora.org>
>> >> Cc: "David S. Miller" <davem@davemloft.net>
>> >> Cc: Jakub Kicinski <kuba@kernel.org>
>> >> Cc: ath11k@lists.infradead.org
>> >> Cc: linux-wireless@vger.kernel.org
>> >> Cc: netdev@vger.kernel.org
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >
>> > What's the plan for this patch? I would like to take this via my ath
>> > tree to avoid conflicts.
>> 
>> Actually this has been already applied:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=d5549e9a6b86
>> 
>> Why are you submitting the same patch twice?
>
> These are all part of a topic branch, and the cover letter mentioned
> that a set of them have already been taken but haven't appeared in -next
> (which was delayed).

Do note that some wireless drivers (at least ath, mt76 and iwlwifi) are
maintained in separate trees, so don't be surprised if it takes several
weeks before they are visible in linux-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
