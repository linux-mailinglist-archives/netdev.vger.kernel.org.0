Return-Path: <netdev+bounces-845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A08F6FAD9B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A773B1C2093C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEE1171B5;
	Mon,  8 May 2023 11:35:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AD6171A8
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:35:59 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051353F559
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:35:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-965fc25f009so501051466b.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1683545698; x=1686137698;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=wi1WmwjZU1UDCM2ZKZeFH8D7vn1lt5dmnqHCt6P//eQ=;
        b=LdJX/rsi2nKGEs1QqTI7dIviRwYApO3zup4qaPlc5iq1sfHtQTCAa2vaKAsjVCe7BK
         T89MaWSlpfX1fsEshwxjJvocrTJORZalUQAOIc7444X1GExpNgyEr2YJC5rzWX3juwXd
         wxdPd7jI8g7tsH+qNllynHypI26MeDVD6Ajus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683545698; x=1686137698;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wi1WmwjZU1UDCM2ZKZeFH8D7vn1lt5dmnqHCt6P//eQ=;
        b=CDoJ+WAEPQBnTJ4tStlazfbSDX3a11Nxso/7YeXH5ljJiAiUylMRHNiBsYdfpuTZ09
         RRazRGA096QT/oEX3aG5RvKxS1INcp53paGDfvjbOddfPB48P9/RCQslZj3LdqmdUO0H
         7dS7uIAnBbRr1VNXOhSeVFlDC8e4iZIa9rZWGZQ48UUTl6mvtOUkdGyC6iEHm4IlGx3p
         KtkCxArlBxc20wjGMYBZt8R6P4GNo/3LK/bzWDnTcOrQxQoM5jmmC9zAYXs2ydsu7P6P
         SL5fOxf5rqbHRQggzW5+fSDU5hBNAEwkXAPjYQn4X45ioA58jETPNBrU/JEqz4EgGh5E
         dEjg==
X-Gm-Message-State: AC+VfDyCq19zU5ZmA52MxvIOEF8+5ANIQSbE87Iz1B7UoynfYWlHRiXQ
	5qPtEuZHUPkLeVifHRwa5km05Q==
X-Google-Smtp-Source: ACHHUZ7iRk3h5jQ7vP75k8hsdLNZq7bI3KBsYDB9CygdAmVDAdEEtbMNc+LQqEWNbV2/56u+0332Ew==
X-Received: by 2002:a17:907:2689:b0:961:272d:bda5 with SMTP id bn9-20020a170907268900b00961272dbda5mr8169437ejc.49.1683545698476;
        Mon, 08 May 2023 04:34:58 -0700 (PDT)
Received: from cloudflare.com (79.184.132.119.ipv4.supernova.orange.pl. [79.184.132.119])
        by smtp.gmail.com with ESMTPSA id gz8-20020a170907a04800b009686a7dc71csm634403ejc.30.2023.05.08.04.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 04:34:58 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-14-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 13/13] bpf: sockmap, test FIONREAD returns
 correct bytes in rx buffer with drops
Date: Mon, 08 May 2023 13:34:27 +0200
In-reply-to: <20230502155159.305437-14-john.fastabend@gmail.com>
Message-ID: <87bkiv3vkv.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> When BPF program drops pkts the sockmap logic 'eats' the packet and
> updates copied_seq. In the PASS case where the sk_buff is accepted
> we update copied_seq from recvmsg path so we need a new test to
> handle the drop case.
>
> Original patch series broke this resulting in
>
> test_sockmap_skb_verdict_fionread:PASS:ioctl(FIONREAD) error 0 nsec
> test_sockmap_skb_verdict_fionread:FAIL:ioctl(FIONREAD) unexpected ioctl(FIONREAD): actual 1503041772 != expected 256
> #176/17  sockmap_basic/sockmap skb_verdict fionread on drop:FAIL
>
> After updated patch with fix.
>
> #176/16  sockmap_basic/sockmap skb_verdict fionread:OK
> #176/17  sockmap_basic/sockmap skb_verdict fionread on drop:OK
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

