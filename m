Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C202928EC59
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgJOEnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJOEnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:43:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF6C061755;
        Wed, 14 Oct 2020 21:43:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d20so2665896iop.10;
        Wed, 14 Oct 2020 21:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=hp/IQgMH7PxTKUrIjJbWVpSobp0VPSFvyGy6U//MIf0=;
        b=pYcMe0Vgmx0X3sAxtRyoYD58EUUzsgjovx82demcGZg/ctk7mdTMg7OY2w/rRcLB5M
         /+7IMDUvEFqeXXgBfKgbPBWXA31dgx8Uy99HULu50OwafU4RgaiPA16Q+seAl/yPEA3p
         2I7Nf1xfJlaDb/VCtBvNJwi5O0GsJgnGCKito+loPEFdF1R3xGmA0snF1GTFAvkzMZSf
         SvrwWAF8KpFguqZwglfIezg+4fr1G67sEFtsCgCWerHMtiz+GR+FxKPKvbmTVJg27KAk
         79vvn+YM3vx/c/Be2iu1LpZW6pBfyb/D5AGNUE9TrBYZ/8nwWCI3WX+SXbvx6Zf475eQ
         9/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=hp/IQgMH7PxTKUrIjJbWVpSobp0VPSFvyGy6U//MIf0=;
        b=K71xe1q2W43vSWLDLifqe/28/afMxlUFF8ddHas4ZvIC7tC8/hEye6t+U7HUL0MpJw
         3/d0z1nePUFyX0G2Sk/bn24GpG6EV7khLRT2T2aCmQ81fsnYqP2InwSI4EdJoycF0oup
         +FWPTm6enJV5OagOrGsOAy0XKIObxeHuBHtwk7nWL38CP0ebGhNAAm7mVXMRpwL43qtN
         ga2h72gPZuyR/PD4IqnqygxhhioQGwS7KlNd6ECRLrTzVAwCJq0VlitDBX92Ecxt22EO
         LJwDYZzq2GM+QF241tO4o3Phm/fXKm1k6bQDhDzPkRO0HDwbmY5oQn9WKv5xkvV+AIzP
         cX1A==
X-Gm-Message-State: AOAM530Uv+mhWggk/Qf2dFuXNGXfInggWeFGjMrVDK/I9H3EqIIsGqIg
        y2UpsiC8qSlhY8K5/X11nVI=
X-Google-Smtp-Source: ABdhPJyX/6g7d5i1K57Hxs+9ymz+uNQihzvxVKOwYmhCYQhqs8dd7n3/JKPKZ6KLlvdn2zFem8+22A==
X-Received: by 2002:a5e:c70a:: with SMTP id f10mr1933169iop.178.1602737018033;
        Wed, 14 Oct 2020 21:43:38 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g17sm1411630ilq.15.2020.10.14.21.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:43:37 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:43:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alex Dewar <alex.dewar90@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f87d37225c32_b7602083@john-XPS-13-9370.notmuch>
In-Reply-To: <878sc9qi3c.fsf@cloudflare.com>
References: <20201012170952.60750-1-alex.dewar90@gmail.com>
 <878sc9qi3c.fsf@cloudflare.com>
Subject: Re: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Oct 12, 2020 at 07:09 PM CEST, Alex Dewar wrote:
> > If bpf_prog_inc_not_zero() fails for skb_parser, then bpf_prog_put() is
> > called unconditionally on skb_verdict, even though it may be NULL. Fix
> > and tidy up error path.
> >
> > Addresses-Coverity-ID: 1497799: Null pointer dereferences (FORWARD_NULL)
> > Fixes: 743df8b7749f ("bpf, sockmap: Check skb_verdict and skb_parser programs explicitly")
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > ---
> 
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Thanks.

Jakub, any opinions on if we should just throw an error if users try to
add a sock to a map with a parser but no verdict? At the moment we fall
through and add the socket, but it wont do any receive parsing/verdict.
At the moment I think its fine with above fix. The useful cases for RX
are parser+verdict, verdict, and empty. Where empty is just used for
redirects or other socket account tricks. Just something to keep in mind.

Acked-by: John Fastabend <john.fastabend@gmail.com>
