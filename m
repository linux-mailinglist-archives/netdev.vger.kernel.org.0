Return-Path: <netdev+bounces-8232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D27472334D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C44D281482
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980BB23D6F;
	Mon,  5 Jun 2023 22:42:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D28AC2F5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:42:34 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C3F3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:42:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33b9a56e261so20884345ab.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 15:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686004951; x=1688596951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YXhRLw6wC+eJIYmYr6kUdF816oXJEgA4OzkVeILGLU=;
        b=jkvsxiWeljrQtZkxhZ4DXjMjxcjFssQ+TYqRIHWL1hp65bxQokSMEHW//kvvjLvKtI
         nGlzYO3IPPRZee7LbadpNMnqZ5UDtRjYYfOCuWaPdYCJyHqSucqh4Mi9Hy+YMYAkSzoI
         dN453Dz4m0xvhbxLks1zkXzFJFOtPmnIxzkJWSWCwO78kdqAu6qlaGOnaaijuh7EupaJ
         0H86U1+q5n8d0pEis5igg60zYHzAdcjRfcRsxXr5b1bAy2D7x/lmepHFPkz3XqqsNOYG
         SnUzjnRQ/mBBMp3uDFvgJ28NNTyWBXBgcBetk0DvRHOGEmxW8QBmI8aFijClhh9GEUPN
         sQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686004951; x=1688596951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YXhRLw6wC+eJIYmYr6kUdF816oXJEgA4OzkVeILGLU=;
        b=iXZMUkZp+gXTSryZxRX2vWQHciPpC77tOOgG7U7BHjzXk6SPRE+SsoJGSrdqQswi3u
         +3VBSam5h8aFq7/JRVpvTFm2+0YYOhpOQ0VCyVkfEyR5fzkmPe32siMBaimTpJCj3duA
         u+yi5gknwTvzIUL5a4yqleGAqv6vEwqkNNmKtc1H+PSezS1+ldyhrE6AmxbRPVDKmqDe
         0JJTF+9jQ6oaj0ob7U4iLi/1+z6I644LUmcTJDPGRMTmpfd7VirnD75v6OB4TzXIf9p5
         yVO/o6nsN+tYiewJtUhQtsTSUUk/yr7P20GfB/iV8MAXb7C8vyOCpl/AjJeU+odm0Odq
         FW2g==
X-Gm-Message-State: AC+VfDyVt/140enKbfgbwGaefETDtBhP8daVWCoF6W/Gy/1Uk6qg4WJw
	LNlCTgMIhYohxYfTjTsuMwXjzHEo2okv1riITfdRpA==
X-Google-Smtp-Source: ACHHUZ4sDtwd+xpW8FVW34Rjxx4jItoc8WeQMCyExoKCQyvyJWOswYKVF2RQnJpv6HS3I9P1VQb5bw==
X-Received: by 2002:a92:cec6:0:b0:335:8dd:cf16 with SMTP id z6-20020a92cec6000000b0033508ddcf16mr397298ilq.9.1686004951330;
        Mon, 05 Jun 2023 15:42:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d2-20020a654242000000b00530621e5ee4sm5686415pgq.9.2023.06.05.15.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 15:42:31 -0700 (PDT)
Date: Mon, 5 Jun 2023 15:42:29 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
Message-ID: <20230605154229.6077983e@hermes.local>
In-Reply-To: <20230605203857.1672816-1-mfreemon@cloudflare.com>
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon,  5 Jun 2023 15:38:57 -0500
Mike Freemon <mfreemon@cloudflare.com> wrote:

> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
> 
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning is ignored, and the receive buffer can grow
> unrestrained until it reaches tcp_rmem[2].
> 
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will fill the tcp receive buffer
> all the way to tcp_rmem[2], ignoring the autotuning limit
> (sk_rcvbuf).
> 
> As a result, a host can have individual tcp sessions with receive
> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
> limits, causing the host to go into tcp memory pressure mode.
> 
> The fundamental issue is the relationship between the granularity
> of the window scaling factor and the number of byte ACKed back
> to the sender.  This problem has previously been identified in
> RFC 7323, appendix F [1].
> 
> The Linux kernel currently adheres to never shrinking the window.
> 
> In addition to the overallocation of memory mentioned above, this
> is also functionally incorrect, because once tcp_rmem[2] is
> reached, the receiver will drop in-window packets resulting in
> retransmissions and an eventual timeout of the tcp session.  A
> receive buffer full condition should instead result in a zero
> window and an indefinite wait.
> 
> In practice, this problem is largely hidden for most flows.  It
> is not applicable to mice flows.  Elephant flows can send data
> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
> triggering a zero window.
> 
> But this problem does show up for other types of flows.  A good
> example are websockets and other type of flows that send small
> amounts of data spaced apart slightly in time.  In these cases,
> we directly encounter the problem described in [1].
> 
> RFC 7323, section 2.4 [2], says there are instances when a retracted
> window can be offered, and that TCP implementations MUST ensure
> that they handle a shrinking window, as specified in RFC 1122,
> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
> management have made clear that sender must accept a shrunk window
> from the receiver, including RFC 793 [4] and RFC 1323 [5].
> 
> This patch implements the functionality to shrink the tcp window
> when necessary to keep the right edge within the memory limit by
> autotuning (sk_rcvbuf).  This new functionality is enabled with
> the following sysctl:
> 
> sysctl: net.ipv4.tcp_shrink_window
> 
> This sysctl changes how the TCP window is calculated.
> 
> If sysctl tcp_shrink_window is zero (the default value), then the
> window is never shrunk.
> 
> If sysctl tcp_shrink_window is non-zero, then the memory limit
> set by autotuning is honored.  This requires that the TCP window
> be shrunk ("retracted") as described in RFC 1122.
> 
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
> 
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>

Does Linux TCP really need another tuning parameter?
Will tests get run with both feature on and off?
What default will distributions ship with?

Sounds like unbounded receive window growth is always a bad
idea and a latent bug.

