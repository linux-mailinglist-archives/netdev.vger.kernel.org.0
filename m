Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A5E627421
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 02:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiKNBZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 20:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKNBZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 20:25:23 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36FE10067
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 17:25:22 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id j6-20020a4ab1c6000000b004809a59818cso1411578ooo.0
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 17:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uQKxccK98/K9VJcoGVJq2IDRGQmIt84pMQmm74SS1W8=;
        b=ZOO9S6HIL5APN2+tibYbQvxC7VESX0LWx4QIC5VBNAxlEGIslKK+3ljSERnrO8uLKc
         XdsM4HcfHvApJS19bVt7hLd5hgZ95+gXPUK2fPMzw2jY04Xhnu8tn4AiF98NASdYrnqb
         ekKXkAxeyFrB94GvjQOtIpcA96NE0wVD32MGmMZ7bLTEJMZAPafl805pw1xzsZnUq8qR
         SVC4+MJVaMFYn0KSDGfLlfvWzi+MjRRuNh3/k0P2ZYs8mG3YbH4RmcwX+WeUbTpDPzE6
         NCl4tJOkn3ns88WwGDy6t1QyVJ/LnMUiTJpVjE0O4zbhjigveApmp8laOOAj1+w+IBVt
         HdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQKxccK98/K9VJcoGVJq2IDRGQmIt84pMQmm74SS1W8=;
        b=V8FOgwEj2LMH8z+4IFFrYrodHm75tcSAfv7PB6RPT+6FU4O/ut7Qe1bqjcji/QMIMA
         k6Cr3qeHh91yLSthVr9fP+rjF4m8DewUuupTLVGkmkpap+8sA4sKfwsiLl5ffKIIrBHw
         t78oH9rkeJ38k2zPB83lXWxcGKSCjRSNEXCOEWYeFbEVSdYw2N2+/Y9rY+tCkygDtxyv
         FqI1UPMY/XkWOQkYSSmI6JsrJe/CiaAK7NACX1Nps/4BVUYeou4TWisPK3ZR4QAVPiIg
         eXoCs9ycnA3tL3vdV326jCkZhjirAB7ct6erKPEZlugMNih66wRVd7uUCuZA+3SLXVB0
         GITQ==
X-Gm-Message-State: ANoB5pm8jSFfESE38rWoeCGtqGP+O1CK2LFBK4w1wm+iHS5kishdLuqe
        CJOWTsbKMUebezb/SB6rcbt2iHegb9o=
X-Google-Smtp-Source: AA0mqf6J5R8Q9cqmAIO6kQcMebWk6tpsVq50ey/lmBSlEw9ckYROxglXI52ugJz5rBZsyc6irjP0QQ==
X-Received: by 2002:a4a:95cb:0:b0:481:1274:b65c with SMTP id p11-20020a4a95cb000000b004811274b65cmr4736768ooi.6.1668389122180;
        Sun, 13 Nov 2022 17:25:22 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:6343:42bb:5d9b:dded])
        by smtp.gmail.com with ESMTPSA id a19-20020a056808129300b00359f96eeb47sm3069431oiw.49.2022.11.13.17.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 17:25:21 -0800 (PST)
Date:   Sun, 13 Nov 2022 17:25:20 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     mingkun bian <bianmingkun@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [ISSUE] suspicious sock leak
Message-ID: <Y3GZAEFaO2zp5SbJ@pop-os.localdomain>
References: <CAL87dS2SS9rjLUPnwufh9a0O-Cu-hMAUU7Xa534mXTB9v=KM5g@mail.gmail.com>
 <CAL87dS1Cvbxczdyk_2nviC=M2S91bMRKPXrkp1PLHXFuX=CuKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL87dS1Cvbxczdyk_2nviC=M2S91bMRKPXrkp1PLHXFuX=CuKg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 06:22:22PM +0800, mingkun bian wrote:
> Hi,
> 
> bpf map1:
> key: cookie
> value: addr daddr sport dport cookie sock*
> 
> bpf map2:
> key: sock*
> value: addr daddr sport dport cookie sock*

So none of them is sockmap? Why not use sockmap which takes care
of sock refcnt for you?

> 
> 1. Recv a "HTTP GET" request in user applicatoin
> map1.insert(cookie, value)
> map2.insert(sock*, value)
> 
> 1. kprobe inet_csk_destroy_sock:
> sk->sk_wmem_queued is 0
> sk->sk_wmem_alloc is 4201
> sk->sk_refcnt is 2
> sk->__sk_common.skc_cookie is 173585924
> saddr daddr sport dport is 192.168.10.x 80
> 
> 2. kprobe __sk_free
> can not find the "saddr daddr sport dport 192.168.10.x 80" in kprobe __sk_free
> 
> 3. kprobe __sk_free
> after a while, "kprobe __sk_free" find the "saddr daddr sport dport
> 127.0.0.1 xx"' info
> value = map2.find(sock*)
> value1 = map1.find(sock->cookie)
> if (value) {
>     map2.delete(sock) //print value info, find "saddr daddr sport
> dport" is "192.168.10.x 80“， and value->cookie is 173585924, which is
> the same as "192.168.10.x 80" 's cookie.
> }
> 
> if (value1) {
>     map1.delete(sock->cookie)
> }
> 
> Here is my test flow, commented lines represents that  sock of ”saddr
> daddr sport dport 192.168.10.x 80“ does not come in  __sk_free， but it
> is reused by ” saddr daddr sport dport 127.0.0.1 xx"

I don't see this is a problem yet, the struct sock may be still referenced
by the kernel even after you close its corresponding struct socket from
user-space. And TCP sockets have timewait too, so...

I suggest you try sockmap to store sockets instead.

Thanks.
