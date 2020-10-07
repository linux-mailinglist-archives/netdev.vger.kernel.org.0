Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DA286B96
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgJGXqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbgJGXqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:46:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35972C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 16:46:23 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q1so4028711ilt.6
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 16:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29DRhcYLqkrngcaMa32yHQsZgMp+nrETWn70lUh5bj4=;
        b=b/3aarRyQ3/sH9moc9ByT4INsEAyojNfJOt+yYy7R/e7I11hV6e7Fu369j9eQqoMpA
         9PiaBzbOvMT725H3/7O1vVQw3oe3rAWfJPA3kddvEsR62FYvsrZB1CAani1PjazVh+QP
         UitOAI0IrwcwcCQCugmpeWDNOngldBbbfkrxfzSSOXOVqoy6XHu0Oh20WoYmIbB4irOD
         zUJ+xn/lpS2Ib1ffDBBJBsKkLCgCmVXpw7Kxb3Po32yz6Za4RO90MqZc0uyT4qH4oc1y
         5cUioyVUrS2EvwUDoMCUx9nGHWfzG9MlpAd/zj81PghSBMrabZXiX5mVTgrmEnpjTkW8
         BQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29DRhcYLqkrngcaMa32yHQsZgMp+nrETWn70lUh5bj4=;
        b=g5SYdrBIeXWnOJoro7oscdJh8ldY3n6NHkKs1zZcJKVed+/PgGoK2aLHyofPlfZQ8U
         METKTqhmf6q5hggJqE3lPfiLvmjX8oGTc3MYjfwQe5uxYakeWmdQvhQRsHDCTxvQqSm7
         q2Np1zVmqmTbUIghw2VXXOgPJSIamzcibdHyS1E9cXTscEpWf9NNLuxdhYMOJwSbOyS8
         SwoGFUERilKXTNmBSq4nfIyviRzV5vZnNOKNbnca52IepTqskGh3QMS+2x/6uTDcM1Ar
         /YIOeu3XTnmGR8ECtBrOz0bQQn4eVPSwQSmI18wv9CNsBzkLGRBLgTVkoV9d5/CnE8Fa
         O5uQ==
X-Gm-Message-State: AOAM5331EnYJhZQP5va1hz9qwed8tGiRDNNbDTXwOQnMHs1ustjML7fN
        Ad2aHfmg8kI4ZFJenfFOeSmZsWKfy0S8rzrtug8moTYxOwg=
X-Google-Smtp-Source: ABdhPJy+XvRVYbzbRMMexrJI9mmQc5sNwIJ4oXPTrPCrl4YwKaW1dLJCIJrK6OQO9SnbXjnZn7NTAU08PW7JXVDI7nM=
X-Received: by 2002:a92:1503:: with SMTP id v3mr4669617ilk.56.1602114381968;
 Wed, 07 Oct 2020 16:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <160208770557.798237.11181325462593441941.stgit@firesoul> <160208776033.798237.4028465222836713720.stgit@firesoul>
In-Reply-To: <160208776033.798237.4028465222836713720.stgit@firesoul>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 7 Oct 2020 16:46:10 -0700
Message-ID: <CANP3RGeU4sMjgAjXHVRc0ES9as0tG2kBUw6jRZhz6vLTTtVEVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 1/6] bpf: Remove MTU check in __bpf_skb_max_len
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>  {
> -       return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -                         SKB_MAX_ALLOC;
> +       return IP_MAX_MTU;
>  }

Shouldn't we just delete this helper instead and replace call sites?
