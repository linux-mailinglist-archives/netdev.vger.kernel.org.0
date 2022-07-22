Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F092957DBAB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiGVIBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiGVIBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E55C3C8ED
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 01:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658476853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1v8asUj8tlWfd7Z0QjLhs0XTx6NlSdvCIlvK96UcLA0=;
        b=hnh3dlAPXFmj6x0h1YBrqyTxvrYbbtov090PMNDHctVM8UlGPtPY/Sm7gybjQPUmVs+Hay
        /3+Ga6bGTO2kVmoCtxvA+nRe274n9BYIuqtdTzmXkpkW+auBmX/cPO/4BlwhE94czRneoD
        +rEcsC4ZFdIpBiBTM5sSTs9KhzCfAbQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-x1mHoJjxO1mXK-XDj1tlKA-1; Fri, 22 Jul 2022 04:00:52 -0400
X-MC-Unique: x1mHoJjxO1mXK-XDj1tlKA-1
Received: by mail-qt1-f198.google.com with SMTP id f18-20020ac84712000000b0031eed29015cso2468462qtp.20
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 01:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1v8asUj8tlWfd7Z0QjLhs0XTx6NlSdvCIlvK96UcLA0=;
        b=uIk+oHAqTZinSASZX+siAnaO5lPUMFtLow5Ntr1kDA/P04wi8sMPq5/QMsgrjULNHe
         jC1KnBY5xi0v+05D6pOl+fj9zR977Oy0BezVZV3nCfZJ4VZk29LhkAhAT0mhI6hMaF+c
         KmdaBv17kQ7/1OhEZeQQAEfF1Y+zvu6uoPxOYZIHFHGgraGDO1cf+f1ocKPVlGK6izPR
         9R4KPa7ZkNrN7ocl8hRYF5j1t/uYKI9RtqZH1pNH5SDBMq/znlK/rYnx74zzpz5zb1qH
         1k8SMreGVBocKdmumGeCK0PAoJ3bSufFf1MJx1v8qwP6j/q28qS9a1yvb20Y9ybv1HZy
         6w4w==
X-Gm-Message-State: AJIora+7tg7VjnYkNiBoGikQG7KJZGg1b4QSax985vNl0BAEZWa7GwG1
        ssA4W50uQDtpubyamwr6I5yHJRdZ+UpWpZY3WtYqKXL2GxLKNFvIOsxvugwNTP9lVwaHvjoh9Wf
        mXT//jlCoQzgL5YN2
X-Received: by 2002:a05:620a:408e:b0:6b5:67b4:fbf9 with SMTP id f14-20020a05620a408e00b006b567b4fbf9mr1645672qko.278.1658476849758;
        Fri, 22 Jul 2022 01:00:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vPZEHUyMEXmAcnsDx6IAufmZ1XpmIyP6mnD8WIOgW+/N+h06LRUwz+pJEgFf65EjaQUeG6yg==
X-Received: by 2002:a05:620a:408e:b0:6b5:67b4:fbf9 with SMTP id f14-20020a05620a408e00b006b567b4fbf9mr1645656qko.278.1658476849481;
        Fri, 22 Jul 2022 01:00:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id v3-20020a05620a0f0300b006b5cdbbfccfsm3298498qkl.79.2022.07.22.01.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 01:00:48 -0700 (PDT)
Message-ID: <9daa8e1cfa2da8662579290281bd4171e72c1917.camel@redhat.com>
Subject: Re: [PATCH net-next v2 5/7] tcp: allow tls to decrypt directly from
 the tcp rcv queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Date:   Fri, 22 Jul 2022 10:00:44 +0200
In-Reply-To: <20220721103538.583907c0@kernel.org>
References: <20220719231129.1870776-1-kuba@kernel.org>
         <20220719231129.1870776-6-kuba@kernel.org>
         <084d3496bfb35de821d2ba42a22fd43ff6087921.camel@redhat.com>
         <20220721103538.583907c0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-21 at 10:35 -0700, Jakub Kicinski wrote:
> On Thu, 21 Jul 2022 12:53:32 +0200 Paolo Abeni wrote:
> > I *think* tcp_recv_skb() is not needed here, the consumed skb has been
> > removed in the above loop. AFAICS tcp_read_sock() needs it because the
> > recv_actor can release and re-acquire the socket lock just after the
> > previous tcp_recv_skb() call. 
> 
> I see, thanks!
> 
> > I guess that retpoline overhead is a concern, to avoid calling
> > tcp_read_sock() with a dummy recv_actor?
> 
> Yes, and I figured the resulting helper is not very large so should 
> be okay. But I can redo it with tcp_read_sock() if you prefer.

I'm personally fine either way, and the new helper looks small enough,
so whatever is easier to you.

Unrealted to this series, I'm wondering if it would makes sense
reworking tcp_read_sock() API to avoid the indirect call? 

Cheers,

Paolo


