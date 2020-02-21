Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9461166DEC
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgBUDmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:42:19 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35973 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgBUDmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:42:18 -0500
Received: by mail-pf1-f175.google.com with SMTP id 185so490934pfv.3;
        Thu, 20 Feb 2020 19:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XhnbVQ6ApCQV5aoHFuO+2Cja+mfXqcArMCHp54JsVvI=;
        b=e5iUfQdb2gUF9y8o1xFdciMpxJNE5PlVOmMZPJVsoS+u6wE5+JUUHghJ+1KMBe+ydt
         BW3Y0JhInwMvPlXupbHARDSYs1wRXNTvYGOVGe1yq8Y38EW3pbZrtXsMLPS65L7hG/yw
         hbX/sUGULqzQA9uFCM+r30k+RX9A0da5ImLAm30pp9Qr9edUMbBOzwIREda+2FPlxfTx
         uLLyOF6RYkGM6PpQu88Ti8sgXtyfd4NazYm5svCUdcSkx9BZuwUDxi9+nN3WRt6i76AT
         kMN47lsbcoeKNucXW/3r2fZg7fsz9RaWTDV7U1b9cEQko/4y4JtToDzjd4Z5rjzw4PFm
         /8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XhnbVQ6ApCQV5aoHFuO+2Cja+mfXqcArMCHp54JsVvI=;
        b=t1VgfJC8+qGmVuy/vPS7TJUGNDgz54KkZQbCAGe48FhqXnfLpBFJINJEkw75abd39A
         oWGZFaopvSg0TafUSvalM8ug8n323Mqsz/i8x3VT48qXF0Pw2IAQkYzDG8KhbF1YE20U
         fLaGJIGWuGam+bwgkrNxKHmjTp3awvUs0VYEgsmDFVtOoBt6NJ+uJ/uvIwZP8MsEJIQU
         jrIGyLl5VDzkYPcKJI/j67n92pETBihCmV8kMhnTAd+46VLXGrgJVrHx0iF97RQ7+RIh
         A3BBv5/8b2irD2/6fo8zbi8PU2nCUhL2z1BF4RvuoWnPKvI91o2rV0zTcDjJ8myWmVXT
         tNGw==
X-Gm-Message-State: APjAAAXNAWAc2GoxysUEPfE6FuTaR6wt2Rcp3pPe6+T71oNqUVo71el5
        TL5aP9TyT2PvMsNoaRTZKAQ=
X-Google-Smtp-Source: APXvYqwaVUZ9E1tXVsZ8AQOx7AbV+ZjGWX/+voclKbNemfLAi/AKqWOcR7MyiqQrheJZST3B55+t/A==
X-Received: by 2002:a63:3117:: with SMTP id x23mr3895286pgx.269.1582256536677;
        Thu, 20 Feb 2020 19:42:16 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b18sm1018191pfb.116.2020.02.20.19.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:42:15 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:42:07 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f518fea591_18d22b0a1febc5b85b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-6-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-6-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 05/11] bpf, sockmap: Don't set up upcalls and
 progs for listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Now that sockmap/sockhash can hold listening sockets, when setting up the
> psock we will (i) grab references to verdict/parser progs, and (2) override
> socket upcalls sk_data_ready and sk_write_space.
> 
> However, since we cannot redirect to listening sockets so we don't need to
> link the socket to the BPF progs. And more importantly we don't want the
> listening socket to have overridden upcalls because they would get
> inherited by child sockets cloned from it.
> 
> Introduce a separate initialization path for listening sockets that does
> not change the upcalls and ignores the BPF progs.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 52 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 7 deletions(-)
> 

Interesting, so after this with listen and established socks in
the same map some will inherit the programs attached to the map and
some will not... I think this is OK when socks are added we know their
state so can reason about it. Anyways the same can happen by attaching
programs after socks are added.

It would probably be more confusing to reject listen socks when progs
are attached so seems like the right design choice to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>
