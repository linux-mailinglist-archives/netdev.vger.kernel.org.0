Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7DA138457
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 01:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbgALAvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 19:51:31 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:38559 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731798AbgALAva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 19:51:30 -0500
Received: by mail-io1-f53.google.com with SMTP id c16so1580230iom.5;
        Sat, 11 Jan 2020 16:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8+5Zi6EPQUI9C9YNOULqQb2kobiRYzXoui8nLxFWWJQ=;
        b=Z/D8M+2kjfGzAlkzdbnPzI3JSmwAGEjG4+vbW14cjLCoBUN2R0Sq574meZAKzcvMqg
         96kggTmOxhmWJnnHdO0T+g9YKxLU/b3O0yA+zTeFqUDSIoynxZK11IGzWidSNLbvfWcd
         9MpeX8sRdJReFmPSghVgYMiMDpTUiRif9oWPU8qEeHk4BNtWxOVkKM3EaMjXZH7M3sHC
         ZQgV8gjieVRHwcBoUt5e2KlYeDBfFhg01WlGaS5jlVZvhKO5H3kvrIv3aozGWn1Dv3L3
         tKORGxpG+dCCK5A4eZzSiuBTTpRnzhYYdAMC8yzoAkWxzS633/vUWtga+ryJNdcgutH/
         huGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8+5Zi6EPQUI9C9YNOULqQb2kobiRYzXoui8nLxFWWJQ=;
        b=sP5R1do77S6g3LDUovoeJBVr8yYL2gwSlF9/6ApEVfhueObrhE0a75pPfR1aIg/Wxr
         Wm4VyadgrBjOdLOc1UsMIBMgBFODziEuiz+bCzpvGavYnuloLW2zhNKW63ecF3K/BCEB
         4eNBkNzP4MU8g3ptJl8/7QANVHZIM90AGgL2BLUirkZIhN/E2tJ7UgplvL+oZ6J/qsNy
         GkWAvHrFQBzy2g7GjjO5Lb5okJZJAPNWJLijMRqhm3DA5XGoV6nzsRyuy+mGP4D2xKP3
         cpAEIHq01SUrumbzWw0iJYOC6z7AjXRj6Vvsr3IwsH917UsJyYWGdMICw6YK7sVLAvnK
         mb5w==
X-Gm-Message-State: APjAAAVz3HDr/1IHoyQqxfxqJqqIS6lCrwgLp/WXZ/LpBKUlGvWKr6AA
        Qy5BIox5Q6+VJ8H3rwyop+s=
X-Google-Smtp-Source: APXvYqxy+BTqRhJQ1dkGmzUWdAchQyRVVTHowMb2yempFncwFMLdBOKAwWEmr7gbbYmvpgGsfGu8BA==
X-Received: by 2002:a5e:941a:: with SMTP id q26mr7847425ioj.135.1578790290109;
        Sat, 11 Jan 2020 16:51:30 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j69sm2237249ilg.67.2020.01.11.16.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 16:51:28 -0800 (PST)
Date:   Sat, 11 Jan 2020 16:51:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a6d8a5de6c_1e7f2b0c859c45c063@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-7-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-7-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 06/11] bpf, sockmap: Don't set up sockmap
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
> Now that sockmap can hold listening sockets, when setting up the psock we
> will (i) grab references to verdict/parser progs, and (2) override socket
> upcalls sk_data_ready and sk_write_space.
> 
> We cannot redirect to listening sockets so we don't need to link the socket
> to the BPF progs, but more importantly we don't want the listening socket
> to have overridden upcalls because they would get inherited by child
> sockets cloned from it.
> 
> Introduce a separate initialization path for listening sockets that does
> not change the upcalls and ignores the BPF progs.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)


Any reason only support for sock_map types are added? We can also support
sock_hash I presume? Could be a follow up patch I guess but if its not
too much trouble would be worth adding now vs trying to detect at run
time later. I think it should be as simple as using similar logic as
below in sock_hash_update_common

Thanks.
