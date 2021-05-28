Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73C393CB3
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 07:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhE1F3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 01:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhE1F3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 01:29:21 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6E8C061574;
        Thu, 27 May 2021 22:27:46 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h15so2338515ilr.2;
        Thu, 27 May 2021 22:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=C1HxIyaejSZRjsKBjpiaFzzVIRivGO1bL18j7u8f+t4=;
        b=X/xnvkD6bHsohq3H5bH8UyMf2iw4flQi2XVulGJThYS9n/FywCwxl70splXl41aZIE
         RnLuLfb3QhoM3fLt6BsvMyYZ8QSj7sYC3A8aAcOl0KpNGtnj2mmWuDVXY4vVeMw7x72I
         rZgnbPmy7qjZgeFz6y9iwRLD7WwuOQ0TdhPKIkZkqY5Z6mgy3EgUzf75meZAWPCGE9Eu
         n3+F/4gl6JrbpB24EQs45P6SfLR7oe1cls8tw39n1Hbnui1Xw3ljoBuSL84J4tLeyER3
         MUvOEemqLT3+XzSCK2h9cavsVNNTzkmaQxmTlCEEMGBuA8yQnXkYNL8F9Q39yZ1OTsek
         aYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=C1HxIyaejSZRjsKBjpiaFzzVIRivGO1bL18j7u8f+t4=;
        b=GWTg5TOYdAUg62zdrxCA7na4wT37RDDnooxnl6TioL2w4szTayY+6n+y+WLhZuQWWe
         g1VlPeZHusEt9QqQyq4U3tmRBM/4hdtOI1OeTnnRnLNZZ3CeagOvpuEKtI4K/rNNo6eP
         fgcdL1OjfMQB4EAXjaxWqosVJmMUWVoeKXF4ueyICtACA6YUATLI3b5ur2D86tIOEZSo
         o0i/lIYS0qRecBg22peSFgjgkrHwUp8w9x0WEyMb/1MqcU/MFrXGCok+XB8v2idMNTX6
         OSelQab+fU7/dmh3XZJKlxqjZr4AsQrN468rdTy2CGoCqsTsMWB5Ge+jXXSvQT5/H47e
         We8g==
X-Gm-Message-State: AOAM531/4aDDkz8B0xz3dFcMDUeGUgj+VT8FgWWXhh0NgAxZKOdpNOF9
        OkTWr+KxFctqUPJ9H8Xc/hY=
X-Google-Smtp-Source: ABdhPJwjuXahO9RSHrB4acdFLUwAJbSBQ4SwnTaH+qOKicuyIOb3E/ZCmv7jVA8M6a+joNNZwFDYuQ==
X-Received: by 2002:a05:6e02:1c2c:: with SMTP id m12mr5597930ilh.188.1622179665486;
        Thu, 27 May 2021 22:27:45 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l1sm912204ilc.66.2021.05.27.22.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 22:27:44 -0700 (PDT)
Date:   Thu, 27 May 2021 22:27:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60b07f49377b6_1cf82088d@john-XPS-13-9370.notmuch>
In-Reply-To: <20210527011155.10097-9-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
 <20210527011155.10097-9-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v3 8/8] skmsg: increase sk->sk_drops when dropping
 packets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> It is hard to observe packet drops without increasing relevant
> drop counters, here we should increase sk->sk_drops which is
> a protocol-independent counter. Fortunately psock is always
> associated with a struct sock, we can just use psock->sk.
> 
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/skmsg.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 

[...]

> @@ -942,7 +948,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>  	case __SK_DROP:
>  	default:
>  out_free:
> -		kfree_skb(skb);
> +		sock_drop(psock->sk, skb);

I must have missed this on first review.

Why should we mark a packet we intentionally drop as sk_drops? I think
we should leave it as just kfree_skb() this way sk_drops is just
the error cases and if users want this counter they can always add
it to the bpf prog itself.

>  	}
>  
>  	return err;
