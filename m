Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC62820FE
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgJCEEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJCEEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:04:33 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECD3C0613D0;
        Fri,  2 Oct 2020 21:04:33 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 16so5444223qkf.4;
        Fri, 02 Oct 2020 21:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bzA4x6TawLJ4d3ZzqizduYXnvQM8gSPQMr7fuFZ7bYo=;
        b=auf7qJ2/k5923oTM/+ES5vTy3XiiFFXbGIQKTnr9/dOjsjAlEapJcBvTe+DNfunFwR
         WKcLLsZZF9UZiKKtElIW0gOb8GgoprMPxpurMt+Giqh6WrZoJZEiIBixdS3glV+stMq1
         q/Q/oOYlHxaemlBBogYSYFAhR7syZfjpPkfoTYNz584uRjtJ4Ryk3gYqUkrW7Ng1hiFb
         9JPiO6fDOHAtZdPwup3Ruq4mWc/N6G6OSneVZkv8iw8hwldEgu+QA/NqalwgSc0e9mX+
         EaHb4ZxV6lscLwcRk2uDXCHQrP/YKIX7vN648yNKLjzAcgL5yW6M2vN4yF0hsZ0QsWfq
         4NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bzA4x6TawLJ4d3ZzqizduYXnvQM8gSPQMr7fuFZ7bYo=;
        b=qnVYwUFEo4ioiZlEcf/mk2geNUzyCJIg9iJu9ARf0awsXpMJ/7cMAaknDLN8P7L6rt
         T7WyDHEJiVo4FUdlw3rz8IZrYGlenyBGC8nRZnPWWgWFKOt9aYV2cvZ6cnZWE7z7BxSo
         s7RAxo5J3V+2AKkj4mP0nEiMBJcySkmGvM4CH//s8rWmWDnNjwwvoJXzMxrEkqb36gdd
         wadEawNK4fhdNW0hDAjO50LkyDnIUMme5C34uOSRhFBdAVAQPtM/OIKipcgfArJ/U70t
         7qv/WZmQ82nT4L43HBnoiYPDbJ3ctyizDc73IO//foXLEThLnq8NlG119VsEWNxpJXYG
         b79A==
X-Gm-Message-State: AOAM532+wGrufh+gKHxMUUljYyNy3trjEzjxnVC59Bx+vLBy0kGXyguC
        uoc28K6RZSpc4TC/zJHPVks=
X-Google-Smtp-Source: ABdhPJzsPYttSsQOzIM7T0K0Btnx91HN41eUL+SntVJ1yt7QjrqFhinEWO8p58rkTkwRGxG0cT63wA==
X-Received: by 2002:a05:620a:1185:: with SMTP id b5mr5002472qkk.386.1601697872313;
        Fri, 02 Oct 2020 21:04:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:4433:ca7a:c22f:8180:c123])
        by smtp.gmail.com with ESMTPSA id r21sm2583285qtj.80.2020.10.02.21.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:04:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 34751C6195; Sat,  3 Oct 2020 01:04:28 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:04:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 03/15] udp: do checksum properly in
 skb_udp_tunnel_segment
Message-ID: <20201003040428.GC70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:48:55PM +0800, Xin Long wrote:
> This patch fixes two things:
> 
>   When skb->ip_summed == CHECKSUM_PARTIAL, skb_checksum_help() should be
>   called do the checksum, instead of gso_make_checksum(), which is used
>   to do the checksum for current proto after calling skb_segment(), not
>   after the inner proto's gso_segment().
> 
>   When offload_csum is disabled, the hardware will not do the checksum
>   for the current proto, udp. So instead of calling gso_make_checksum(),
>   it should calculate checksum for udp itself.

Gotta say, this is odd. It is really flipping the two around. What
about other users of this function, did you test them too?

It makes sense to be, but would be nice if someone else could review
this.
