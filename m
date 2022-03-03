Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3484CB6D6
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiCCGP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCCGP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:15:27 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE58145ACD;
        Wed,  2 Mar 2022 22:14:41 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id t21so3197300qkg.6;
        Wed, 02 Mar 2022 22:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qdBEAgbWuxxR2o/00VXlWsOSQa7k5j8aT75LEC/xh4g=;
        b=TqFopctsLeF437cCAMgwiayH0ExDBYCvSEpa3OTAPM74UPRSqDqwxc7PJr5L4phAYq
         QlDBrfoZrRNZh6jiwhO0AbtCKjutBChUn8/QRIufwgLGC93hi34/J74XV5KFa6sKBTfJ
         nJyWVLXT7EsOQt0gTqO2fLEj9VJHow9kvXMKdEbebVJxpzYHUCC18mKiME2IdWE3+HXE
         OlJeLV70dyxZiVhtPR34mGESe5LblQeN3cH2tIsafGsZ/KTkmaHi1E6Iaiu565CfNhSh
         rykL5hkZK36TF9mth9e+CSxYBXhVrGQnCnPJmrBSSHMbJyqMIPije/9pdpfcUcldIHkk
         1Zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qdBEAgbWuxxR2o/00VXlWsOSQa7k5j8aT75LEC/xh4g=;
        b=we9wY0tdBMnYCyJpN5fgHVJtx5TnmPFMOWtOFtHfUc1p2BA8ej9oRL4wWX3lxpFtyz
         WSYP67LNhtIcZoNvu1+Wp3ZM+wypV3m8/zoS99lwTv9zLYlfHytdMUlpBNis2xMbcjvQ
         f9cLX5WQ3V15eBeY939h6/gPC3tsEd3xnbVjZuA5tXQNNB/VPV9FmbUXhuTKYi25kJoj
         5CmPAdmk65f5C+Vq2PmNPEQMsFqtx9CyFPu2oRaAovwYcyUm+ACYFUP8YbvUMlP68ZCk
         fblUIntPv4PnMURWDYoNHAWzlQFKZB2ZarkjQw8XcIq4nhFMuqYWYZ8p7uyuqr7wElml
         CUyg==
X-Gm-Message-State: AOAM533RmlSNYrJgPDl8LbAD1lvtGdDfPDFHHfErkXf5HkXBP1XNcGjM
        FZRQv//ciyS6YemWxbvkIyg=
X-Google-Smtp-Source: ABdhPJzbZa7HQwBZqvgMTYMeKJokxtfUEwUSHO/Clg6gZX2ZLzATAPsgLAT4goELV49XJK9ocNoinQ==
X-Received: by 2002:a37:6110:0:b0:60d:ed9f:18da with SMTP id v16-20020a376110000000b0060ded9f18damr18097055qkb.610.1646288080917;
        Wed, 02 Mar 2022 22:14:40 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:2f27:f8bb:e136:eaec])
        by smtp.gmail.com with ESMTPSA id d15-20020a05622a15cf00b002de711a190bsm885885qty.71.2022.03.02.22.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 22:14:40 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:14:38 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] bpf, sockmap: Fix more uncharged while
 msg has more_data
Message-ID: <YiBczo/gN8w9Hl+L@pop-os.localdomain>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
 <20220302022755.3876705-4-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302022755.3876705-4-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:27:54AM +0800, Wang Yufen wrote:
> In tcp_bpf_send_verdict(), if msg has more data after
> tcp_bpf_sendmsg_redir():
> 
> tcp_bpf_send_verdict()
>  tosend = msg->sg.size  //msg->sg.size = 22220
>  case __SK_REDIRECT:
>   sk_msg_return()  //uncharged msg->sg.size(22220) sk->sk_forward_alloc
>   tcp_bpf_sendmsg_redir() //after tcp_bpf_sendmsg_redir, msg->sg.size=11000
>  goto more_data;
>  tosend = msg->sg.size  //msg->sg.size = 11000
>  case __SK_REDIRECT:
>   sk_msg_return()  //uncharged msg->sg.size(11000) to sk->sk_forward_alloc
> 
> The msg->sg.size(11000) has been uncharged twice, to fix we can charge the
> remaining msg->sg.size before goto more data.

It looks like bpf_exec_tx_verdict() has the same issue.

