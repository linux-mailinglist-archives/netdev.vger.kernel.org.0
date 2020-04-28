Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0F1BB349
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD1BPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1BPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:15:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2077BC03C1A8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:15:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so9859972pfc.12
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=67KICxj1fkakMnOE+vK6KDXEZO2fAMpfMkaNGDEuqMs=;
        b=1+sHT980vyGTQpr0Fb68UfzG48xxSc+GqxkWpZWJ7OS8327A5ABMgTu34nGQpk98ZY
         ox2l/m125pE+JQn94RSgJckJJ6/mWX1biI+gktYXRA8psYidGElp9mVLM+OHsgyiHTbp
         CqKJiHBcVO2kcmRB0R4d7pseKk2cRqfg8Tj4ER6hxZGc45GaFIeZPxg6eSPuWVSbeuJb
         sQS4chr1nWhrUFsZdNGmeI/a7Q3WXgdNYJ+/kPR0H3HskW9SI+8t2jF0grdlJU/xmpta
         tuxKZXXknaVP+noSw53EsZ3AF+79YtLLfiVao3LlNJcmjy24tU+4NSgQrCaeT9gKqg9i
         2mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=67KICxj1fkakMnOE+vK6KDXEZO2fAMpfMkaNGDEuqMs=;
        b=idSlelvSyc4UmH0t6YVAYTJZ3wxTaUIsQbpc06Bd9xHmdPUA14lbVCnyY2WVRR/aTz
         AJVG3cgXa6fHizxPsZHzIRQU+gYL0MdkNVMNT972043z8RCO4K3FC9OVuY15SqS8Se01
         3xhNQYdvOZtxX2m8hFP6oizRVovHkL9MaHI/lcc1fjxbYU28WCEW/d6FVgZXs5LDKrXv
         j5H0qy/mhX2jzQ1ucoovdgAfnXEMvJwP+GIdvxvlIyzXDr3qE8jsEELyC5Tf/Ctpp+gP
         0yOVjrzr/Twb64J+k/Hxw4IkyW2EBqu0D1MyQJ7ra51z8Oo9cAIKT9gxgXuiZVoPnEZW
         C6Ng==
X-Gm-Message-State: AGi0Pub32VscJWIaabAOcQG+7+dVuLR9TxSWemlcPEoyudJM7eRsIrul
        FXcMgbJ46h8dyb4dEjpZGylJ/g==
X-Google-Smtp-Source: APiQypL49gfDjfeDhpj61RE1mkkuFSf9AMsjUFdopISAXUQ0JVyCFmV61wObjDU9birfM4dmA5a43Q==
X-Received: by 2002:aa7:9491:: with SMTP id z17mr27313736pfk.264.1588036512634;
        Mon, 27 Apr 2020 18:15:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y16sm14022740pfp.45.2020.04.27.18.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:15:12 -0700 (PDT)
Date:   Mon, 27 Apr 2020 18:15:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        aclaudi@redhat.com
Subject: Re: [PATCH iproute2] xfrm: also check for ipv6 state in
 xfrm_state_keep
Message-ID: <20200427181509.3f408bbd@hermes.lan>
In-Reply-To: <a5e26e7eb3172c2ddebdc5b006f3afaf3e4adb5c.1587971664.git.lucien.xin@gmail.com>
References: <a5e26e7eb3172c2ddebdc5b006f3afaf3e4adb5c.1587971664.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 15:14:24 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> As commit f9d696cf414c ("xfrm: not try to delete ipcomp states when using
> deleteall") does, this patch is to fix the same issue for ip6 state where
> xsinfo->id.proto == IPPROTO_IPV6.
> 
>   # ip xfrm state add src 2000::1 dst 2000::2 spi 0x1000 \
>     proto comp comp deflate mode tunnel sel src 2000::1 dst \
>     2000::2 proto gre
>   # ip xfrm sta deleteall
>   Failed to send delete-all request
>   : Operation not permitted
> 
> Note that the xsinfo->proto in common states can never be IPPROTO_IPV6.
> 
> Fixes: f9d696cf414c ("xfrm: not try to delete ipcomp states when using deleteall")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied
