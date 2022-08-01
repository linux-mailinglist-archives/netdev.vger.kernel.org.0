Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3281558656A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiHAGwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiHAGwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAF65DF48
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659336737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mRRLQaoaI3a9cmnlTacmtLqCW9aahWn0SUgddnX3Tdc=;
        b=Y7GQFZ4A1j5Y2A296QCfrfjZoSZG1Lbt+/1p1AFEi9vGUADNt4Ki2yw8G6k1kPrUWjBlZX
        sLqeKU8SMC3CYKrioKZnr8KFu18AykhFsJsfpjCX3T+bSelN+x9zxQ+WfJvMukquj0fqTu
        qd/aKfLYlQe+mI8CJYS2irpSvhJ65+Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-a5XhLZpCMhOpUhgUqM7sDQ-1; Mon, 01 Aug 2022 02:52:15 -0400
X-MC-Unique: a5XhLZpCMhOpUhgUqM7sDQ-1
Received: by mail-wm1-f71.google.com with SMTP id r82-20020a1c4455000000b003a300020352so4851827wma.5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mRRLQaoaI3a9cmnlTacmtLqCW9aahWn0SUgddnX3Tdc=;
        b=VJK9uF/GS8wA1uOnkIHPqVV6oM/3nGab/uXIESLdBAh9EAglycK7QWpocABtjJiaI1
         bFVbsMwCF4ozXinp4D+fVVdN9BlNL0Vox42TXmRIYmYBvLTnEaAUTjoGZJuh4Fn2LYr9
         vP/Gjgj9enK0l0HFzJ+4dmP4BMWMsHnvdIfD/i1jW6vrgKIw0bN54Mb7nr3lKz3ci4vF
         a1MTJUtRMNzfMK0cC/4miteXNatG2aFnOHX7mqQ/Vlcfdt8oS63/I98J+vB+icJQwVr9
         Ur5qrQsStGuDIEWvLhMbtraYQ8LIPgsZ65TSp5iFeKYr2PlN8c3BEeySUxbaNkqFFGeP
         DwSA==
X-Gm-Message-State: ACgBeo15L4AZR3BulfaKmZWZsAQ3yGPovTEPoAQvCU+3acnU1+r0IpZE
        JuiGit8tHEKSVY8Qwj+lS6ChMsAAbSAjOAJNCOnjhteeqzJsdX/VTzn8zusx5ELhKz70sbUbdRQ
        ivZ/DhPZUYxC6oH0C
X-Received: by 2002:a05:6000:1548:b0:21d:acfc:29f5 with SMTP id 8-20020a056000154800b0021dacfc29f5mr8816572wry.520.1659336734292;
        Sun, 31 Jul 2022 23:52:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5VSXcoFjGxKarm++L16JbcCAK5T2fkPsTrhIGbB4pGy/WNITDwkgQ5m498S6pjO9SfEFukYw==
X-Received: by 2002:a05:6000:1548:b0:21d:acfc:29f5 with SMTP id 8-20020a056000154800b0021dacfc29f5mr8816558wry.520.1659336734059;
        Sun, 31 Jul 2022 23:52:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id b5-20020adff905000000b0021b970a68f9sm10805716wrr.26.2022.07.31.23.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 23:52:13 -0700 (PDT)
Message-ID: <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
Subject: Re: [PATCH] net: skb content must be visible for lockless
 skb_peek() and its variations
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kirill Tkhai <tkhai@ya.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date:   Mon, 01 Aug 2022 08:52:12 +0200
In-Reply-To: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
> From: Kirill Tkhai <tkhai@ya.ru>
> 
> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
> In the below example var2 may point to intial_val0 instead of expected var1:
> 
> [cpu1]					[cpu2]
> skb->xxx = initial_val0;
> ...
> skb->xxx = var1;			skb = READ_ONCE(prev_skb->next);
> <no barrier>				<no barrier>
> WRITE_ONCE(prev_skb->next, skb);	var2 = skb->xxx;
> 
> This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
> since it's a lowlevel function, and a caller has to understand the things it does (and
> also __skb_peek() is used under queue lock in some places).
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> ---
> Hi, David, Eric and other developers,
> 
> picking unix sockets code I found this problem, 

Could you please report exactly how/where the problem maifests (e.g.
the involved call paths/time sequence)? 

> and for me it looks like it exists. If there
> are arguments that everything is OK and it's expected, please, explain.

I don't see why such barriers are needed for the locked peek/tail
variants, as the spin_lock pair implies a full memory barrier.

Cheers,

Paolo


