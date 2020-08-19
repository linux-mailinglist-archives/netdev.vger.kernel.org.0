Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04DC24A76F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHSUFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSUFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:05:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F1EC061757;
        Wed, 19 Aug 2020 13:05:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mw10so1618165pjb.2;
        Wed, 19 Aug 2020 13:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0I6TG8OQ4MyMAK10jo0S7S3IILMCgjoAeTh1HO1wd0k=;
        b=Wm3fvNiRAKqxyH/lkvyeYmyjkx8eH1wdX7slQRNcwhkjV72tGjQI8TKWU45YCRbWsN
         trMRTA1G8ep+n21TzY9pC8NXLOHkZ8e1GGr1jCXjgMfsHAsHJaDdzvvIk7NtW2bervC7
         PKKu0poqliI4jdKv8BacQm33kbvuqZ5AGYUW8YEb/EYdXTbigtpEZZfT4a0uMRFKaRm0
         DpxbKyNBc/Pi+LHBsG0oh88qFpUDEzBls35SdNgXXQj+gOpkWeUR5r6/+QjSjvZIpEtW
         ED9otUqtKsQgispUd1/ZMpjkOn5C1WRM4rNj/X7QAiiwxJcAg+65wp536SFoYqlJx426
         GMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0I6TG8OQ4MyMAK10jo0S7S3IILMCgjoAeTh1HO1wd0k=;
        b=jXBdZvWdb5rIH/5zojlQPjBTUKPqVJm3bRaxB/QXFunsOkBSndgYknRHv8K29Ujv3g
         tPk81/vGmv0vd9tsjPEUwZDqWnQIUU7NTaqmo7TQEwBD/ki1OIJ38ZLAuCCHtPs52czj
         Tsx9+rbFYgHGV8LZKI5SE805sUh6ND+O+Gsg7YrOIe/hHnOi+G9hUJe3kSSalW7UXc7r
         ir8UijBhwzlQlCbQRZUkSOCWSD/STnS4/nuhOW6eUCrQ/rZGyWVyRUKdlBC57O8k9lvg
         +lKP2eVckJJunFvJLvrCwwkfSn9warFQn1+e6y94q43jiYt0jyRmGPHngTHxct6VHio6
         uwCA==
X-Gm-Message-State: AOAM531Cypax7y2IVqwTCKRuN64upLTCtDs/d3getBagB1b4qNOvbUYL
        2ogoaqlCrBDTMRC9ovvJuLc=
X-Google-Smtp-Source: ABdhPJwcrV5pwOyfgoe0lNQO5XV3rZza8MUk63iRiaKDKIH8CLCaYLK9IAFivn4tkTWuRq+767obXA==
X-Received: by 2002:a17:90b:10f:: with SMTP id p15mr5535936pjz.171.1597867546130;
        Wed, 19 Aug 2020 13:05:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g5sm23419pfh.168.2020.08.19.13.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:05:45 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:05:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f3d8610d335f_2c9b2adeefb585bcac@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819092436.58232-2-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-2-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 1/6] net: sk_msg: simplify sk_psock
 initialization
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Initializing psock->sk_proto and other saved callbacks is only
> done in sk_psock_update_proto, after sk_psock_init has returned.
> The logic for this is difficult to follow, and needlessly complex.
> 
> Instead, initialize psock->sk_proto whenever we allocate a new
> psock. Additionally, assert the following invariants:
> 
> * The SK has no ULP: ULP does it's own finagling of sk->sk_prot
> * sk_user_data is unused: we need it to store sk_psock
> 
> Protect our access to sk_user_data with sk_callback_lock, which
> is what other users like reuseport arrays, etc. do.
> 
> The result is that an sk_psock is always fully initialized, and
> that psock->sk_proto is always the "original" struct proto.
> The latter allows us to use psock->sk_proto when initializing
> IPv6 TCP / UDP callbacks for sockmap.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Looks like a nice bit of cleanup thanks. I think we might be able to fold
up more of this code as well, but I'll take a look in a bit.

Acked-by: John Fastabend <john.fastabend@gmail.com>
