Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762FA4CB40A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiCCAtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCCAtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:49:12 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7314D4E3B6;
        Wed,  2 Mar 2022 16:48:28 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id c7so2776993qka.7;
        Wed, 02 Mar 2022 16:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uoln0TwoeXhapQQ2kgJF3aYfxwyFeRpalFgynBUGE70=;
        b=DRB6EVN7LYOU0szntJypZT7IgNAJOCkTHzI0QVn8onPzwifEsBkenP8zm6gBcOYyNg
         RsjOl6Ti21etCXyLxm1VrfL0mVN12EB9gJiGaM3o4EFDKXK1QTbG1SKmyOs1U0zouSKZ
         4EfRRbRg0vVkbQ6cEnFhEVAg7/oFM7EhJ7OjBOOPNX3PrWvsyVzwfxEME7I8MI0eJzgn
         DCeovsC60HqXlPOCD8TeSTr3At4IcUqamXYVXp6G7bH93fczVB3JwVaKhTTkYBQQGBON
         yoaWmidydwdTLhDXM7/NbJaJCEcFymzwcGz/zMt/ah22qyldDv6bsAwenv6dT5hFLipf
         bJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uoln0TwoeXhapQQ2kgJF3aYfxwyFeRpalFgynBUGE70=;
        b=3G7mUBqvctVV5CDUnQavKyo6fmzsAvSET6Ow7CfkIcrWOHecvTVPpMekngH4btEVF0
         WowyP+kap5GE4PaYpzX6IkEhSlMTFnvu4D2MAj6d3rWD9W+E1IuwG2JnifR7GZZ4enGU
         RBTLqRWKPoaXfoqf+zyUQFTqzu6OkYh1WM3OfE9ZKap1ksZv9dw2yxoetSpv69qrbF2f
         Nzg85EoMv0UX+Gx3NmNfNLwaNbmGczW9Cik0hLDQ8rOW7/1rrqGbXs8uhabFELEOdZYd
         ruXZJ3fw7yES18YZO1/ayFQNyRL/SFyD5mbQgqlkX39zjF4Ktn0bLTGGaGm+QTCuo2nn
         Mm2Q==
X-Gm-Message-State: AOAM530oeiZpWYAFzgnds670cht0snv+KTCzdwTK/cxFLZ2x+NN34b/e
        T5ZjqoTeB0GXcy3N7pYTD2Svfc/QvVI=
X-Google-Smtp-Source: ABdhPJwsOadWkOm35OOSXNRLw0XChfyguz/qkr143FjkHmn4dol2MqQ3CfiP6tOSB/ImCL+MnTaryA==
X-Received: by 2002:a05:620a:2941:b0:47e:144b:84a9 with SMTP id n1-20020a05620a294100b0047e144b84a9mr17755693qkp.32.1646268507582;
        Wed, 02 Mar 2022 16:48:27 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:17f1:53ec:373a:a88a])
        by smtp.gmail.com with ESMTPSA id w1-20020a05620a094100b00648e56836ffsm299922qkw.82.2022.03.02.16.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 16:48:27 -0800 (PST)
Date:   Wed, 2 Mar 2022 16:48:25 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/4] bpf, sockmap: Fix memleak in
 tcp_bpf_sendmsg while sk msg is full
Message-ID: <YiAQWaVPEmfpiale@pop-os.localdomain>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
 <20220302022755.3876705-3-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302022755.3876705-3-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:27:53AM +0800, Wang Yufen wrote:
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 9b9b02052fd3..ac9f491cc139 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -421,8 +421,10 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		osize = msg_tx->sg.size;
>  		err = sk_msg_alloc(sk, msg_tx, msg_tx->sg.size + copy, msg_tx->sg.end - 1);
>  		if (err) {
> -			if (err != -ENOSPC)
> +			if (err != -ENOSPC) {
> +				sk_msg_trim(sk, msg_tx, osize);
>  				goto wait_for_memory;

Is it a good idea to handle this logic inside sk_msg_alloc()?

