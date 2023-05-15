Return-Path: <netdev+bounces-2766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E913703E56
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE4411C20C0D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A8B19539;
	Mon, 15 May 2023 20:15:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49FD2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:15:08 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECA111B6E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:15:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-966287b0f72so2027571466b.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684181701; x=1686773701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnZql2nXk7XDFUyppjEfqwjPkwjJcAZL9uAyjCnIan0=;
        b=sbUTq9wnYVZ4EyXTNX+BzCd+DCirduHE8I4Rn9CrIVKjSUpkVssZ5TzGPueb5D2a9z
         eiCKu+NbisZkgr6x3uZVLGkoWuTdJttjSSLj8R2w5VtVgFSE0hRnA7BPQ37iHQzAG9j4
         FwKpnrnt4NpHGNczjmo9uKs2mHa5+Z2iMgKaDtA5KiD9sVZwoquTaDDP5Y621SgAlw7c
         wQ6/FT5FH/2D7AG6X1CxOnnTfkdd1VbtJqoCTFuU8tk8Af+9Gqj/hzRtYtSO9ASNlNbz
         e62JNkenQyw8RDOiyLMhUj83sXMPi9qP3mqmClMtz6xGIXqlGZkQrEOO7GvkySEO2k1h
         gfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684181701; x=1686773701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnZql2nXk7XDFUyppjEfqwjPkwjJcAZL9uAyjCnIan0=;
        b=axyLVOWpkx83gzIZF1xVlMiUUsgpt1xmfvECk8vrLzFn138R1xmi81UbJMIE0Zkb8U
         IIhzZRjenS5iVvnklEop8/gnvpFUVQslivtlHuINmoVTReXDGRzfccR+aGh2UaMat/FR
         CHO0rR/zhmvNUjgLmbi4frukcg61DBqtYN42OKucq5aEIx73Q1v3tRNDAl9HRcwY63Ge
         dB8MNc1UwNqPAQJuO6BAblmD0ik/vQ5Y5sTOCmX1BNsFc3OW4YsP8dzUrPjGYS0Fvfsb
         25r6zwEetDPl55kUqT8r6KNsSbfaCVUaBe8OQE5ZHoN2sdn79RQkuaIOH7BLqwdudIBa
         oNSg==
X-Gm-Message-State: AC+VfDz66cdDo/r203vpX1FY9j46SFVO6VkWz0HrtKPOL7J1L2JCozbJ
	4nz2VHDp7wziTlAT6Ozxa95jcLH8ITJo6w==
X-Google-Smtp-Source: ACHHUZ4soY2BvmAXuzzG8gAuAvanpgftElm8hUWvRm8Tn/h128fkYwYm+gUB+GTRgtsocrpHxV0wfg==
X-Received: by 2002:a17:906:5d09:b0:968:c3b5:8b92 with SMTP id g9-20020a1709065d0900b00968c3b58b92mr23718039ejt.57.1684181700975;
        Mon, 15 May 2023 13:15:00 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id nb27-20020a1709071c9b00b00966265be7adsm9944241ejc.22.2023.05.15.13.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 13:15:00 -0700 (PDT)
Date: Mon, 15 May 2023 23:14:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Sundar Nagarajan <sun.nagarajan@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: NET_DSA_SJA1105 config declaration: tristate is not indented
Message-ID: <20230515201458.kkbli7fmqtkvb5ju@skbuf>
References: <CALnajPCaJfR+N=vP0R6bXoUwMbopQK6JsJ+pXxS=T6KT5NXswg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALnajPCaJfR+N=vP0R6bXoUwMbopQK6JsJ+pXxS=T6KT5NXswg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On Fri, May 12, 2023 at 02:38:44PM -0700, Sundar Nagarajan wrote:
> diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
> index 1291bba3f..63c9b049f 100644
> --- a/drivers/net/dsa/sja1105/Kconfig
> +++ b/drivers/net/dsa/sja1105/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config NET_DSA_SJA1105
> -tristate "NXP SJA1105 Ethernet switch family support"
> + tristate "NXP SJA1105 Ethernet switch family support"
>   depends on NET_DSA && SPI
>   depends on PTP_1588_CLOCK_OPTIONAL
>   select NET_DSA_TAG_SJA1105

Thank you for your contribution. It has the following problems:

- the context has been mangled by your email client, replacing tabs with
  spaces, so the patch does not apply. I recommend that you use git
  send-email for sending patches.

- patches to netdev must always be formatted against the most recent
  main branches of net.git or net-next.git trees (depending on whether
  they are bug fixes impacting users or just general refactoring/new
  features), and your intention to target one tree or the other must be
  made through the --subject-prefix "PATCH vN net" or "PATCH vN
  net-next" option. Look at other messages in the archive for a hint:
  https://lore.kernel.org/netdev/

- it lacks the "Developer's Certificate of Origin" (the signed-off tag
  generated by "git commit -s").

- it lacks a proper prefix for the commit title indicating the area of
  the code. A better commit title would have been: "net: dsa: sja1105:
  NET_DSA_SJA1105 tristate text is not indented"

- a good commit body (the part after the one-line title) contains:
  1. Context
  2. Problem
  3. Solution
  Yours is empty. The scripts/checkpatch.pl tool should warn about this,
  if you run it.

I would recommend reading a bit what's in the Documentation/process/
folder before resubmitting a v2, I may have missed some finer aspects.

