Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2236256B2EF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiGHGp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiGHGp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:45:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692ED4D4FC;
        Thu,  7 Jul 2022 23:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B949B80189;
        Fri,  8 Jul 2022 06:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D42DC341C0;
        Fri,  8 Jul 2022 06:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657262719;
        bh=FlwRiRHtGel2rCGS4TGuYsdGWisqlLhpOiaAc2cCkUU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I3BnsXq93SQnzAOwRFujOtCiPKruJMc25QSMiggQvZ2wBKS0/v4k5PgqgoNOnr9Qj
         C5fu9Clucy3N+DXL+4tnrrWWdwaP1jX0xl+iIQ17n0iDsp6huelUwesErmoSLgVU9g
         +LCFqlQP/PBOEyJEUeyt4Pk2c4MkYDBFhPaZtCfQzFnLRFWBkiCQuHYGqvAXgy3RYF
         pyWKjiGAQQ56Tqpd3pkZQ2N2W8kGLthplZ68UjeVvWCqOjoW/myrx9a2g5z5ka39tx
         R8sXHKcHMegDwNKMJtd7q0DXoETrueJo5UA9rt+k5b5i9fv4qmZOkfrXMAy8WlFrj1
         0t44WfpHnjvDA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH 03/13] tracing/ath: Use the new __vstring() helper
References: <20220705224453.120955146@goodmis.org>
        <20220705224749.430339634@goodmis.org>
Date:   Fri, 08 Jul 2022 09:45:14 +0300
In-Reply-To: <20220705224749.430339634@goodmis.org> (Steven Rostedt's message
        of "Tue, 05 Jul 2022 18:44:56 -0400")
Message-ID: <87edywt85h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Instead of open coding a __dynamic_array() with a fixed length (which
> defeats the purpose of the dynamic array in the first place). Use the new
> __vstring() helper that will use a va_list and only write enough of the
> string into the ring buffer that is needed.
>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: ath11k@lists.infradead.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Feel free to take this via your tree:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
