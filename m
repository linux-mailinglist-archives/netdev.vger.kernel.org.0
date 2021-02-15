Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0BD31C2EC
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBOUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBOUZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:25:41 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767B7C061756;
        Mon, 15 Feb 2021 12:25:01 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e1so6544173ilu.0;
        Mon, 15 Feb 2021 12:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wKWBIv+k9YIhMTEUhQl9LZsBdnk9jLVwai6x/OJFEPc=;
        b=tiGJchjEM6mQEelwEbFGc+exx8+jzp268eC2W6YPN/mo3cJwOwq0oW6/AW+WHlZZ5z
         NYRsPNHub3TlrKRwxZD7xTcSVHYHsbzVKx+5WCK06JCxn8d9CquMgKkWIi8pVS/KsMaQ
         cR4F32hNM0B3NCTblLBw/i3dc9NmvHnVrxooOq4OvneMhXSLpDwbFxWRnF9WPSbrXOl/
         eK75IozzrVZFu5/PIA7vjUoNubN5K1QOtSmNrAoihlLeuI+5a05mScs/0k0TGXe2ZJAJ
         M41CpcbIW0VMHXp4/lzhLtjKIu+gt6XKtm1hEJpCoI4xi/DZbOaT/62++WWz19sGTUM0
         PaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wKWBIv+k9YIhMTEUhQl9LZsBdnk9jLVwai6x/OJFEPc=;
        b=NSkQ2gaaXmGCCEVIFln0mXRZ7VC6v9e+vU1tmEKTmrEOo7HKovbc4W+v00mwz1wFvz
         U0ObH/+Fl/j4J2O5HZh0lMXVC1DhgSpkoEF5GPC0gW3L7D+wHBMnX4nPbUtL8oTBdoCz
         R5wHVAbQphcrBa9cqIS9u6uq74bHFmy/EhsXGZU0gdzKaXIrHoPVqOEleon17bL8m9rB
         H+aDxxgi2YB1hG2BPHJTRiZL+xkRlRV8SfrmM9HxsdkX44RMhNIp1SP5i88idly8MapS
         Mxei1fiQBY54r5mRO+sKLOquE+9SXkC4nTVpkqsSuUAMcVfalr2iKRaQqa/CmcZI6oqE
         w0KQ==
X-Gm-Message-State: AOAM533UmLRRNTiZ1BjrecGwm2IAyNxK8urABWZ5GlHoh4TnySZqAQ+N
        yLCIDJyDJbrXPZUgeC0CJTw=
X-Google-Smtp-Source: ABdhPJwvmBZ7/1MAMff38lhVQXWOWeUOR5ou1vXP3dpDnJWgcnCm5Sv/05TwCYMMGGRaMpwBw3etfg==
X-Received: by 2002:a92:d0d:: with SMTP id 13mr14038901iln.36.1613420700450;
        Mon, 15 Feb 2021 12:25:00 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id h10sm7054965ilj.86.2021.02.15.12.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 12:24:59 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:24:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <602ad895e1810_3ed41208b6@john-XPS-13-9370.notmuch>
In-Reply-To: <20210215154638.4627-4-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-4-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH bpf-next 3/3] samples: bpf: do not unload prog within
 xdpsock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> With the introduction of bpf_link in xsk's libbpf part, there's no
> further need for explicit unload of prog on xdpsock's termination. When
> process dies, the bpf_link's refcount will be decremented and resources
> will be unloaded/freed under the hood in case when there are no more
> active users.
> 
> While at it, don't dump stats on error path.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

Can we also use it from selftests prog so we have a test that is run there
using this? Looks like xdpxceiver.c could do the link step as well?
