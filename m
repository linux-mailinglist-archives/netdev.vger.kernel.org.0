Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80B166DA6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgBUD2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:28:43 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42450 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729725AbgBUD2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:28:40 -0500
Received: by mail-pf1-f172.google.com with SMTP id 4so461456pfz.9;
        Thu, 20 Feb 2020 19:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8+0Ca6vkf+ttBL2H8QYsjAwrxnDG0wb4opbsFtoqt7g=;
        b=BcEj+pHCttkH5VSVtX1ZuTBqTQwrgTMYf8jvlNlyopwWz2gyVR1kb5DJ3LPaDmLNBi
         +0KOgDPh1nJ1gFij981sS2qgJWGPWpApdUUFKP80DkyNoRrAZsA7Rg89HiNZ1vuLIAap
         8onXSZHrNAo0U9TpD5Ij8sDGMuyaELJiiGXRuWtPum2Ejx8Hlg3fJCfyLTf/IIOr+npy
         1tviaGfi27cnygjYVB3k2+yjJ8+ybDW5gAJtYMlrGd8FJDe+JGkZtdZm3LN7qCWGNnBd
         iJgLSVsmRLCVK9g8+9n21rmJkF1t+TKbq2t4ITGo2UWaiHAnJgCMYRLgdn6gEH5BFf+U
         n6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8+0Ca6vkf+ttBL2H8QYsjAwrxnDG0wb4opbsFtoqt7g=;
        b=KHwR6ksX8gL/x0VUg2x/Ws+H5VHiB6Kz+Wn5TgIZf0VzShKZYft8k73rGpyrH29VYr
         k4oe/Cx1mPyT19fukiYwyE3lDFVosLTA1U8m+7c5hUZtsmjm5m+RtoT14K0s/jPBd0i8
         l9VRHJU1Au899I4MGCs0Qery2HXwyKUZsyNs9G5KvtGo6fH1aYOf8mx34dZXbohgfJ8p
         uCJ10U5+uRASMtjAmD48dvvzi0Q5Aaea3M/EtHZLK5CtoGGAoknllLU/sqN5nnIiJK2X
         Du5ikGv7peIFX1VU3IjDhAwVh+pYtDv0cJ2FblUmQaY5A04cDVKrmktEKnoHYkrDT/bO
         UdPQ==
X-Gm-Message-State: APjAAAV2ElZr+Qm5oeDxHtUXleqFPMwwA+WCFZlIrXs03eAgDwu56Q64
        TBkZ8bkUw8FHxyZuKc/cDN6TDjoR
X-Google-Smtp-Source: APXvYqzNK1AS04Hz8hdfHrO0McRpZDmJapObT9xs76DHKZEtr+n3P7a/i5ukocCPzf0wrdmkbWWvrg==
X-Received: by 2002:a63:1044:: with SMTP id 4mr37537094pgq.412.1582255719900;
        Thu, 20 Feb 2020 19:28:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g13sm667103pgh.82.2020.02.20.19.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:28:39 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:28:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>,
        eric.dumazet@gmail.com
Message-ID: <5e4f4e5dbc315_18d22b0a1febc5b82a@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-4-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 03/11] tcp_bpf: Don't let child socket inherit
 parent protocol ops on copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Prepare for cloning listening sockets that have their protocol callbacks
> overridden by sk_msg. Child sockets must not inherit parent callbacks that
> access state stored in sk_user_data owned by the parent.
> 
> Restore the child socket protocol callbacks before it gets hashed and any
> of the callbacks can get invoked.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Looks reasonable to me. CC'ing Eric as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>
