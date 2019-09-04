Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719CEA79DD
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDEbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:31:39 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:42203 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDEbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 00:31:39 -0400
Received: by mail-io1-f52.google.com with SMTP id n197so39302188iod.9
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 21:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=N5geII7JXxDDv7jNW59cIHsiLOpKNNN9PRzqgU4gmT8=;
        b=Pyawq3u9KnSCiRZ3+MixDoFe2xXq860NfaHK+Kp6ZvgPXOksMK3EgqKwkUhIpBj7VJ
         sWR2LW61Xt8SeD0PhIcgM3JLEIyqmt2pX6PeefjB8yZsM2dqC5qdjqgjxwBfk4wAYdy5
         X5tjrEQqp0VKZwqQf4skmXGLSQ+g4K1fM5fm9SbsqVaO344I19UvHbzKtz63JZyKZV6D
         aa0tGgYhW0aM968yN0fcufVEMnfZOp5HhgPdSKbuaEGz611vkrUs1lrgM4Vp7ON0KWWZ
         /tB/z2yHJ57kJWMZjo6+oA+dcnioNjaF67pFbQMKXtgJ/DSUwwODhbYnhgb5CQyMbD5V
         OmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=N5geII7JXxDDv7jNW59cIHsiLOpKNNN9PRzqgU4gmT8=;
        b=J5JdDnuNniyAEbdYePmpKAcFryPMLzmNoWU6Ov4DOGsIdAgToKAMSBu0tQ8oxKbv8R
         4Ewx95+l2FJFpTyL0f9yUL7qKxh/ovcFPmuBe/3H72JiKBEKIp4ltYvBZnYfmxF2aD0d
         kWcUyBnNDzUndVMNhMpywUf83Ir+nLLetk5dGpXssv+ItaLgwcxN9Ckz2asfo1kDWi9M
         YcQReNFJ3j3RX6tjVpufLOnws356RzVWMzdX+TGvJIFpWtGhXLZdkqIOngYGeJtSydKi
         aBSOa6YVnEpDoWwbRGHSsp79iQYCFhQO/jmZGTO5NEU1Y9DKrceOwgtsqK9d7fl0hbs0
         xNRQ==
X-Gm-Message-State: APjAAAUpEphjYRYPYXOCj6B8v7b7YFOtEpwFKFyTyHAVgDkEuOWkyJLR
        4j8Qh/d9gqtsTPhP1ZzZ+eU=
X-Google-Smtp-Source: APXvYqyegdDG6e1ftIBqRKxa0m1W2OQFM763/3TX7ma3ZcYftefA3rVHDoYE8QQlYIPJGuFX9n9y2Q==
X-Received: by 2002:a02:a792:: with SMTP id e18mr40766229jaj.64.1567571498470;
        Tue, 03 Sep 2019 21:31:38 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q74sm33081802iod.72.2019.09.03.21.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 21:31:38 -0700 (PDT)
Date:   Tue, 03 Sep 2019 21:31:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Message-ID: <5d6f3e215ebff_de32af1eb5fc5b40@john-XPS-13-9370.notmuch>
In-Reply-To: <20190903043106.27570-5-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
 <20190903043106.27570-5-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net-next 4/5] net/tls: clean up the number of #ifdefs for
 CONFIG_TLS_DEVICE
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> TLS code has a number of #ifdefs which make the code a little
> harder to follow. Recent fixes removed the ifdef around the
> TLS_HW define, so we can switch to the often used pattern
> of defining tls_device functions as empty static inlines
> in the header when CONFIG_TLS_DEVICE=n.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
>  include/net/tls.h  | 38 ++++++++++++++++++++++++++++++++------
>  net/tls/tls_main.c | 19 +------------------
>  net/tls/tls_sw.c   |  6 ++----
>  3 files changed, 35 insertions(+), 28 deletions(-)

Thanks I've been meaning to do this I agree it looks nicer.

Acked-by: John Fastabend <john.fastabend@gmail.com>
