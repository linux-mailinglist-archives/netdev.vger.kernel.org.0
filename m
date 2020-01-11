Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA81383E1
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 23:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgAKW6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 17:58:21 -0500
Received: from mail-il1-f177.google.com ([209.85.166.177]:33439 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbgAKW6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 17:58:20 -0500
Received: by mail-il1-f177.google.com with SMTP id v15so4848332iln.0;
        Sat, 11 Jan 2020 14:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=e3cJBG4UgdJbniWY+dA61AMSnuqYTNCPy5lZtPxjOvQ=;
        b=vWagqjdDOEV8f71QgrvEXMowoiyquCf5njDk6oNcmfWBg0tG6h+rksSlmrpmHiojSY
         7ty+7Yh8829KR8hVfkuiCdds3uUhrjsoOTYkJcHb7QMjK4KpIKAzozOxl+52Zju3Uvo9
         kw9S0ZQ8NR5UanNl6gxidUyRh0gF1/7S80lD+6zPeSx+aKu/0ZkrSvv0QJ4jHv2DA6GL
         b351OsnBg/dty8Kve/6AFh9G0L8nf7JBZwdGF7kwZQNVOLx/G+KQV3E0Gs4yFwZlMGrI
         0KopRIZ29M1I/eamXvi+cYkqNFbnVa0EAtQaqkgHXdnEVs2AbepRkaZ+0HieKWC4xymW
         Nq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=e3cJBG4UgdJbniWY+dA61AMSnuqYTNCPy5lZtPxjOvQ=;
        b=qjI+YzzmOp/FFV9wZbm0jf+rAMrobFtvrljibYztq1h2OgNWlL1ZHFNRsWsHnXglTv
         o8vj41gft/EzL3Ns6YsXXzQnfKvC+tquJmXW/yIquWtfkUWd6IZEriNJh3mHi5Mq877O
         KK5XP/6hrLesSeyeXG2Bqwt++WMv/Sz2qWOvdeNrCLbyaJNTg1ryUGm2kYTJm9ijn7ms
         hL0LwzLUlXZic83bNmGhJCAYLNcj3WTixUoWJ65WN8Oba4Y6dQT4PVsGtWf5Gwxe5xgx
         xd8FwbopQh+rDFr/WOcKVAxoGiK6SzSKJMmEooWn6uf6vUuBjlPLn4qKtjWL+n/GDusK
         eURA==
X-Gm-Message-State: APjAAAXoTTQagJxgbt+xXrLH5tULSTlfDd/91nmxJZDhVvhJm/QYMj7A
        1yY8TbaLVbwaDV7xnvAOHl4=
X-Google-Smtp-Source: APXvYqxiBkejkzsqa5ClIiF0hE3zr9u/XqCn+x8ScT6rHctxqlbWCXyZl4PB5yyCs0bZ3n3Iq/rINw==
X-Received: by 2002:a92:ba93:: with SMTP id t19mr9218396ill.0.1578783039950;
        Sat, 11 Jan 2020 14:50:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i11sm1601511ion.1.2020.01.11.14.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 14:50:39 -0800 (PST)
Date:   Sat, 11 Jan 2020 14:50:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a5138b2ba5_1e7f2b0c859c45c05a@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-2-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 01/11] bpf, sk_msg: Don't reset saved sock
 proto on restore
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> There is no need to reset psock->sk_proto when restoring socket protocol
> callbacks (sk->sk_prot). The psock is about to get detached from the sock
> and eventually destroyed.
> 
> No harm done if we restore the protocol callbacks twice, while it makes
> reasoning about psock state easier, that is once psock was initialized, we
> can assume psock->sk_proto is set.
> 
> Also, we don't need a fallback for when socket is not using ULP.
> tcp_update_ulp already does this for us.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
