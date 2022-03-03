Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC2A4CB400
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiCCAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCCAm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:42:29 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6A6488BA;
        Wed,  2 Mar 2022 16:41:44 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id d3so2928889qvb.5;
        Wed, 02 Mar 2022 16:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HPK1WTvE1B28R5Sfb07/BE6k/60BFpLEj3e8MJE0oQM=;
        b=M7kKSmqSto8sYacgEmFjL1NiVFFKx8swBt/TWVyaUgexmwvKm9y0a4tZsaN5YWtBTu
         TidRZkU3ZaFTb37PFWZd6iWF5/WuLMXz2NkpkYppLl1gMrIiGe5p503vSEaaJbp0NcXx
         8L2FlrQ5tvhg5uG8JPiJNqVhmnaSNnhWUUiIFY3z6SBrxxYVvoMdbSBJpuh08IhwV8di
         97EuIgu294BChky/fknlXD+jVL0t3r7ZD+D6/c8Xl1cNj3M7o9NokfzEzcY0nyjh4snL
         98VWvULkqvJ5k38H437Q8GA8hlp2onLwvgQzfds1KmdOC/5pEcnlkmoYHCVIYJquTdj6
         f9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HPK1WTvE1B28R5Sfb07/BE6k/60BFpLEj3e8MJE0oQM=;
        b=2T9w8v4tWmc9AgMA/8ZP/wfBh2C0fr/9QueiE4WABJjQ0+IZaODtRuaYK5ARIyndQS
         0NOKMmsnwqD06OETSDGWU483Fe8dGLghoVc5hHRqkixR86YHv1ttjGzzd7ZQPybdmZu2
         7UxizyboyLJ0Cese//w77hncmmEyrYlbpSackUlPV0adw5iYuSZ9pnc8YANvjjN5U/zU
         oSg6cN5AyY4jAeY3KCtFUVxv9GdbC3WDdchMx9PEWYohEyJc5buuFHN/XbAbXT96AyBQ
         ujP9csl2IECBtHhTeK4pEpeACaI+Z/EaJgDgZQriHIPMnVIxGcnjqXNYVITm+wjo1MP1
         dFiQ==
X-Gm-Message-State: AOAM531xDuvAJzGthJbnh3K5KeqxivguMkX5aIKQ30lvBk9Nfqnn02bm
        PPtcYSOPDFH/nHr97Sd4YQ8=
X-Google-Smtp-Source: ABdhPJxj9OyxWn4Nkvpj8GkycsaZ6Ex/Is+hmsS48In6rwdvPC5BAWbRVXkxf6DPxdX0fh9Q2rka8Q==
X-Received: by 2002:a05:6214:20e9:b0:434:ff41:d773 with SMTP id 9-20020a05621420e900b00434ff41d773mr7405911qvk.115.1646268103497;
        Wed, 02 Mar 2022 16:41:43 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:17f1:53ec:373a:a88a])
        by smtp.gmail.com with ESMTPSA id z14-20020a05622a028e00b002dc8e843596sm395308qtw.61.2022.03.02.16.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 16:41:43 -0800 (PST)
Date:   Wed, 2 Mar 2022 16:41:41 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
Message-ID: <YiAOxRWZBHWDTpAs@pop-os.localdomain>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
 <20220302022755.3876705-2-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302022755.3876705-2-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:27:52AM +0800, Wang Yufen wrote:
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index fdb5375f0562..c5a2d6f50f25 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -304,21 +304,16 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
>  	kfree_skb(skb);
>  }
>  
> -static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
> -{
> -	if (msg->skb)
> -		sock_drop(psock->sk, msg->skb);
> -	kfree(msg);
> -}
> -
>  static inline void sk_psock_queue_msg(struct sk_psock *psock,
>  				      struct sk_msg *msg)
>  {
>  	spin_lock_bh(&psock->ingress_lock);
>  	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
>  		list_add_tail(&msg->list, &psock->ingress_msg);
> -	else
> -		drop_sk_msg(psock, msg);
> +	else {
> +		sk_msg_free(psock->sk, msg);

__sk_msg_free() calls sk_msg_init() at the end.

> +		kfree(msg);

Now you free it, hence the above sk_msg_init() is completely
unnecessary.

Thanks.
