Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB688586733
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiHAKAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiHAKAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:00:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 348DB2ED73
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659347998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BeL/NwHha2WvKah/qzanDUP2ebu3unA4D1iMzF5Kg9M=;
        b=N2TmfpMwILcA2OsIY4hTLvBmbTod2BSdRCcVd1pFIorxx5/RDnrUNWLyseJBuzitiKAs5f
        SisrQivA56+GH6Nq5acUTWUMmIJQuGg3U1PoBMjSaDC8wdGdci2ZDRvmVWuklP3ssNSg4J
        Q5Am2ZeHkqWfIl4NSgLv1fK3T1V4xU0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-Vpem8mrdN5aRUKGN8Yxa5g-1; Mon, 01 Aug 2022 05:59:57 -0400
X-MC-Unique: Vpem8mrdN5aRUKGN8Yxa5g-1
Received: by mail-wm1-f72.google.com with SMTP id v11-20020a1cf70b000000b003a318238826so1425680wmh.2
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 02:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BeL/NwHha2WvKah/qzanDUP2ebu3unA4D1iMzF5Kg9M=;
        b=BPZgrorOuw/TYudUEMF40rrAM+oJq5aY3cuzOkNrUDcmwWjLSPI9kbSudxbR5gnBjx
         6SNPcVuqNkrpi6nOWz5UQMTo8nRJniHJ9xZ/y7z+c5t+YottVydfgtNp06sKfDmXWtWv
         GAG6M0tHdcRuhNQLeIffRgCwFtaiXTnxseTRDUXLVJwevAFfLfLlYVnXIwnUZhGJPTLk
         vNflkGjvry/CIIBqnM7Ytv7b/zCBvPk4l4FsgG591Z+H5aPJpY8v6ziEwVlJxkkwzwK0
         eEsLbEAGW5o0nAJG1BgclLr2BP4rhTtTsr/2NPlUkkhtizRzeo575bVVMzXh/PFutLjV
         OaLQ==
X-Gm-Message-State: AJIora/7wTx8etLGKz7PwUJHdCfyTPRIHqYK25drbhIbzcLLyrGjNpUc
        F6PcZadz/Dig0Bl2I29Gc9szO5gEKZhRT4W92hE8BOYoMRdIQtUBetY3IWDKWm9EzV0y60E7Tv5
        cV+taSV7eXvtB5v/H
X-Received: by 2002:a7b:c415:0:b0:3a3:1d20:a4d with SMTP id k21-20020a7bc415000000b003a31d200a4dmr11226044wmi.137.1659347995893;
        Mon, 01 Aug 2022 02:59:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1toTFxLVXweEs2Ln+6fyty/h2Z3VQa3adv4HuN49W9aHaxYz/lf20oAjcNuQXSkEdRhbtxsEw==
X-Received: by 2002:a7b:c415:0:b0:3a3:1d20:a4d with SMTP id k21-20020a7bc415000000b003a31d200a4dmr11226029wmi.137.1659347995649;
        Mon, 01 Aug 2022 02:59:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id v6-20020a5d6b06000000b0021e5adb92desm11321533wrw.60.2022.08.01.02.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:59:55 -0700 (PDT)
Message-ID: <baea599f33ba06873a15fadf4e84a704feaaa652.camel@redhat.com>
Subject: Re: [PATCH] net: skb content must be visible for lockless
 skb_peek() and its variations
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kirill Tkhai <tkhai@ya.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date:   Mon, 01 Aug 2022 11:59:54 +0200
In-Reply-To: <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
         <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
         <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
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

On Mon, 2022-08-01 at 10:00 +0300, Kirill Tkhai wrote:
> On 01.08.2022 09:52, Paolo Abeni wrote:
> > On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
> > > From: Kirill Tkhai <tkhai@ya.ru>
> > > 
> > > Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
> > > In the below example var2 may point to intial_val0 instead of expected var1:
> > > 
> > > [cpu1]					[cpu2]
> > > skb->xxx = initial_val0;
> > > ...
> > > skb->xxx = var1;			skb = READ_ONCE(prev_skb->next);
> > > <no barrier>				<no barrier>
> > > WRITE_ONCE(prev_skb->next, skb);	var2 = skb->xxx;
> > > 
> > > This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
> > > since it's a lowlevel function, and a caller has to understand the things it does (and
> > > also __skb_peek() is used under queue lock in some places).
> > > 
> > > Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> > > ---
> > > Hi, David, Eric and other developers,
> > > 
> > > picking unix sockets code I found this problem, 
> > 
> > Could you please report exactly how/where the problem maifests (e.g.
> > the involved call paths/time sequence)?
> 
> I didn't get why call paths in the patch description are not enough for you. Please, explain
> what you want.

You mentioned the unix socket, so I expect to see something alike (I'm
totally making up the symbols lists just to give an example): 

CPU0					CPU1
unix_stream_read_generic()		unix_stream_sendmsg()
skb_peek()				skb_queue_tail(other->sk_receive_queue)

plus some wording on how the critical race is reached, if not
completely obvious.

>  
> > > and for me it looks like it exists. If there
> > > are arguments that everything is OK and it's expected, please, explain.
> > 
> > I don't see why such barriers are needed for the locked peek/tail
> > variants, as the spin_lock pair implies a full memory barrier.
> 
> This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
> this is not needed. 

But you are also unconditioanlly adding barriers to the locked
append/enqueue functions - which would possibly make sense only when
the latters are paired with lockless read access.

As Eric said, if any new barrier is needed, we want to apply it only
where needed, and not to every skb_queue*()/skb_peek() user, so very
likely a new helper (o a new pair of helpers) will be needed.

Thanks!

Paolo



