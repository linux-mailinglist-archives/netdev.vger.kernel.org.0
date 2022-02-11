Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70ED4B2520
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349815AbiBKMBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:01:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiBKMBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:01:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77D4BF4E
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644580906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZN7OauSkrzB8kkNXHIThygK1KRq+5FKWPYBOV6LXdE=;
        b=Tr/oUiK4xl6rl1vvwsvloJzOP2+kkDT121Vqncc4aEuyzk/HRmloDTMQFwyTjCJ0/HCBeR
        G4/262fNPMjKYs6XfJMErgVEIzSCmo+B4K2dfexP0AFzkWyHv9xzOQ1BfsXPCY2EUUp+aQ
        tBNLn5eia7vzQRbK9n8G5BGaUNOMJ7k=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-I5EZfY-fNCyuCiOqvo9AMg-1; Fri, 11 Feb 2022 07:01:45 -0500
X-MC-Unique: I5EZfY-fNCyuCiOqvo9AMg-1
Received: by mail-qk1-f197.google.com with SMTP id u9-20020ae9c009000000b0049ae89c924aso5422209qkk.9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:01:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MZN7OauSkrzB8kkNXHIThygK1KRq+5FKWPYBOV6LXdE=;
        b=0g2agQUpamDmbtza7YAWGEcgXB+G6NOrhLAGUmbAnyLPAtKmV5RLY3hcaseNq0RGG8
         Tyk24+A09pPRqy0fL2A49vvch8qQ/YV0bhdG7bZNkyIZccLaPEsMHNrW0Hnb/DWrwFZw
         HgMZ0cr93jFdNzpX3QqKZRzV+wjU2pj9StzJWv0DqBOZJC3SNUhLLvg3KaG4RQmh7enG
         xbJN6NBPtO0w7wdpdkmYI2nX/FStxMF3ACs0TxhVnxbJOgBHY1hvGAvSBgppn67Oqm18
         jv3K6lgZwAAVitXywgYRmK3kEn44ilrQHO/A2wr/M1/0jaKsji9GH6tcC0DxowReWbJX
         p6+w==
X-Gm-Message-State: AOAM533kN3bqCS1SmnVOKdzPPp6EGdQXHUf3H/3RZlplDMRZ5q1ezXNw
        Uwrq4dI0qtvnqbK/eUK1spoAqBBFqa8hwejffnrhQoyRPkBX4Fi5Thq0sUnhV1ounRnB1ewiXN1
        WIjUjav39X4O1B/jT
X-Received: by 2002:ac8:5b05:: with SMTP id m5mr780386qtw.188.1644580904784;
        Fri, 11 Feb 2022 04:01:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJc/VtON0iWYFfWZRIw2L6ZBr1jv8fhMSk8u4fEgtSfR588RweyQl8zsqNNmW84bcFXIFlWQ==
X-Received: by 2002:ac8:5b05:: with SMTP id m5mr780368qtw.188.1644580904520;
        Fri, 11 Feb 2022 04:01:44 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id az38sm11473506qkb.124.2022.02.11.04.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:01:44 -0800 (PST)
Message-ID: <cef31c78be439a8f10af13c861a305684a0abd60.camel@redhat.com>
Subject: Re: Why skb->data so far from skb->head after skb_reserve?
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yi Li <lovelylich@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 11 Feb 2022 13:01:41 +0100
In-Reply-To: <CAAA3+Bo6RQjhYom0+RPaDvYZJ90NdqgVBFomDMWyc=nsiJm1Tg@mail.gmail.com>
References: <CAAA3+Bo6RQjhYom0+RPaDvYZJ90NdqgVBFomDMWyc=nsiJm1Tg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-11 at 09:53 +0800, Yi Li wrote:
> Hi list,
> I am digging on skb layout when tcp send packets throught tcp/ip
> stack, but i am stuck on the skb->data now.
> I use the net-next branch, and the commit id
> 6cf7a1ac0fedad8a70c050ade8a27a2071638500, and i think this (problem?)
> is not relevant with specific commit id.
> 
> Firstly I just used systemtap to digging the routines, but when I
> found for every pkt, the data is far way from skb->head, i became
> curious.
> 
> After add some printk logs and analysis, I found the strange behavior
> as follows:
> 
> Let's only look at the tcp syn pkt when we do a tcp connection. I have
> added many logs , but for simply let's only see root cause, the
> following log:
> 
> static inline void skb_reserve(struct sk_buff *skb, int len)
> {
>     printk("%s:%d:  head=%p, data=%p, tail=%d, end=%d, len=%d,
> data_len=%d, transport_header=%d, nr_frags=%d\n",
>                     __func__, __LINE__, skb->head, skb->data,
> skb->tail, skb->end, skb->len, skb->data_len,
>                     skb->transport_header, skb_shinfo(skb)->nr_frags);
> skb->data += len;
>     printk("%s:%d:  head=%p, data=%p, tail=%d, end=%d, len=%d,
> data_len=%d, transport_header=%d, nr_frags=%d\n",
>                     __func__, __LINE__, skb->head, skb->data,
> skb->tail, skb->end, skb->len, skb->data_len,
>                     skb->transport_header, skb_shinfo(skb)->nr_frags);
> skb->tail += len;
> }
> 
> And I got the strange result:
> [  131.750170] skb_reserve:2453:  head=000000000cfe1b70,
> data=000000000cfe1b70, tail=0, end=704, len=0, data_len=0,
> transport_header=65535, nr_frags=0
> [  131.750173] skb_reserve:2457:  head=000000000cfe1b70,
> data=00000000bf8ffb2c, tail=0, end=704, len=0, data_len=0,
> transport_header=65535, nr_frags=0
> 
> Why the skb->data so far from skb->head, i can't understand. Could you
> kindly help me ?

printk by default hases the '%p' aguments, to avoid leaking kernel
information to user-space. You can modify that (Beware! only for debug
purpouse) booting the kernel with no_hash_pointers on the kernel
command line. Or you can cast the ptr to long. 

/P

