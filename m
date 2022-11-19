Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CD630C88
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 07:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiKSGjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 01:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSGjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 01:39:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3691B31EF8;
        Fri, 18 Nov 2022 22:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FCB60A6E;
        Sat, 19 Nov 2022 06:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EF3C433C1;
        Sat, 19 Nov 2022 06:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668839957;
        bh=0ZYQtq1F3G/XBZWSJnxz7MelVEcYtwYDFTPJ7e6klDk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=b2ewwj12u+8qQ9la7a3VkF3YX9TT/oaO1OzVym4OxAOctVF9H92uNbnTz/pC5N7NO
         32nan4aq2ko3K4ND6uy23SWIMiGyZ6KLI5TIRfK2OIKAYSYqup4ya3HpdPtEzEnZuo
         VDFloO/Ol/kOo8IQ7hjvdfQFVi7cxHuuDjwiSgPqHMSctEpoSNA9Vn16dgdewcg+0I
         86YugInfEqONPevJZgh3wV3N3em8/En8girb8Wl9vRsvUtHRkCYSY0Izv7YeHC5b7A
         tFqqRLuIeqTm3GaM8jemhAWSBAvqh+nX9hPxBrAGqXqAMjRNEmN4JXT9+hVgFsE3jt
         aoUXPhyxfiE3A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] carl9170: Replace zero-length array of trailing structs with flex-array
References: <20221118211146.never.395-kees@kernel.org>
Date:   Sat, 19 Nov 2022 08:39:11 +0200
In-Reply-To: <20221118211146.never.395-kees@kernel.org> (Kees Cook's message
        of "Fri, 18 Nov 2022 13:11:47 -0800")
Message-ID: <877czrqwhc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
>
> Replace zero-length array with flexible-array member.
>
> This results in no differences in binary output.
>
> [1] https://github.com/KSPP/linux/issues/78
>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Nowadays we include "wifi:" in the subject, but I can add that. But
please use this in the future for all wireless patches.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
