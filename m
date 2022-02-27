Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3519A4C5E67
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 20:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiB0TVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 14:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiB0TVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 14:21:51 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE015AA4F;
        Sun, 27 Feb 2022 11:21:14 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id n185so8855401qke.5;
        Sun, 27 Feb 2022 11:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2kTkSUUIcLs9zQI8iWiQZP7AOGs73ov/WhJ7PVeoNzU=;
        b=Wh3kyVlXWHtCXU3c54GBRjurnMkqgcRqdeEgNQjnH7f72dJcNVr/vFJ62OKGxvwsmI
         CyW3OXuV1FtX4CGJ9M1xgrBNZJkwEkTqXmN6w9+ib2DOQC2tnxYqBuxRoq6gi/7+fsnd
         0WsEQTqFfUU0i7t33IxuxJ9qead0vbiX/VNQvzZrzPh3vl86LfwNKngGr6NK8d/PqWGz
         SmrO1D7UA5dBB2JuBHir3EXqilqWyhqSxW/1C90TIYvd856pzM7XIq6YFgmT4MpD0zwB
         2Gu03CDLs5WJ329dr8xHIlTuNi1NHWlleYjE9Pc/Is840nYzBuVUD98+CrNtctVvk46D
         mpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kTkSUUIcLs9zQI8iWiQZP7AOGs73ov/WhJ7PVeoNzU=;
        b=KWHkHTIHFLiblB+bUxIFMYzVtp8xXOe+FFMqzmw9wofOyJpKxO1AykTZMYdYFWgTaR
         f2G/npNIPQXAWobNr4+fqGcqsBRcAnJZ7yHSZTGK61Qrz10lK7o5ZKj1dRwClpt1+E9a
         5hm6W7fO+fFZdMGShlkRnzoQO66Qu+EurfIq7mn9B9nNRoYC18iR/CAz9/EwaUsStwI4
         9+UtUa55A3U93Q5kuTQ5HsRha+ekOg5mKhQxyFqWcWh3GK3sBDwyctAxRYvfcxgFHdZo
         DhWsKvXSWK7oXuHBRZRRRmFmfGDOHtyeHLWK/qWSeG2HwLrkst58T0ESfei+rXbrIxkd
         rQ/g==
X-Gm-Message-State: AOAM530k1ZxfPaCLXYbmDgGyWnbO2orSKiT6g+ronBFUBopkecZzvQYr
        26qMzhU/aAKIqw9qU11cHjE=
X-Google-Smtp-Source: ABdhPJwdIw9DshOjZbeeTS1xcpuDbjWJT+MHr+t3bOAgyyxrKn1mc7Af5OOz+zCqKiBfvQjrBOslJA==
X-Received: by 2002:a37:688c:0:b0:507:db8b:b71a with SMTP id d134-20020a37688c000000b00507db8bb71amr9496711qkc.396.1645989673576;
        Sun, 27 Feb 2022 11:21:13 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:ee9e:a12e:deed:13de])
        by smtp.gmail.com with ESMTPSA id 26-20020a05620a041a00b0062aae550fa2sm4115804qkp.81.2022.02.27.11.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 11:21:13 -0800 (PST)
Date:   Sun, 27 Feb 2022 11:21:12 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        bpf@vger.kernel.org, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
Message-ID: <YhvPKB8O7ml5JSHQ@pop-os.localdomain>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-2-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225014929.942444-2-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 09:49:26AM +0800, Wang Yufen wrote:
> If tcp_bpf_sendmsg is running during a tear down operation we may enqueue
> data on the ingress msg queue while tear down is trying to free it.
> 
>  sk1 (redirect sk2)                         sk2
>  -------------------                      ---------------
> tcp_bpf_sendmsg()
>  tcp_bpf_send_verdict()
>   tcp_bpf_sendmsg_redir()
>    bpf_tcp_ingress()
>                                           sock_map_close()
>                                            lock_sock()
>     lock_sock() ... blocking
>                                            sk_psock_stop
>                                             sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>                                            release_sock(sk);
>     lock_sock()	
>     sk_mem_charge()
>     get_page()
>     sk_psock_queue_msg()
>      sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
>       drop_sk_msg()
>     release_sock()
> 
> While drop_sk_msg(), the msg has charged memory form sk by sk_mem_charge
> and has sg pages need to put. To fix we use sk_msg_free() and then kfee()
> msg.
> 

What about the other code path? That is, sk_psock_skb_ingress_enqueue().
I don't see skmsg is charged there.

Thanks.
