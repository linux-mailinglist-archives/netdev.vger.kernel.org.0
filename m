Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4F653ED2
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiLVLOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 06:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLVLOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 06:14:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCBB2AC8
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 03:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671707629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6wmUSjFPm20MNQz86DYSx27hpB1OpMKe0+xx4dP5io=;
        b=EoYbAJm71hoQB7V8/M4o9qAOEhd/mAr70d/Czwd19zL6kk6HJusd8G8ffS+YJjwt4W3aXH
        rlotRP1tg9/AIZqQURzVWDVUEhgAf39ep69A62Muj4VT3LoVOrXM5XeLZjhUXGujKqumDL
        51RcbwMS7+/T5x76j8qjAK0IvasyrmM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-M9Llzw28Mbe1RoJpYi0OQg-1; Thu, 22 Dec 2022 06:13:47 -0500
X-MC-Unique: M9Llzw28Mbe1RoJpYi0OQg-1
Received: by mail-wr1-f69.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so332323wra.13
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 03:13:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p6wmUSjFPm20MNQz86DYSx27hpB1OpMKe0+xx4dP5io=;
        b=36YHInofpgQ4gxLY2jOj7Ek/1kO+UGixhPKtwCQxZFFn+Wug+IQGHWHLp417bUaGbL
         buyf48GoFbdaBwZqeXeQ1PG0htYUG6JdrFL3LyHD6GDtp9QQDoRT5Bsop8NIhpLdjXFs
         f/9WVJjr68TnSbqgik4IFuzdlzXwZr/r5BlJpbz2vz1XMwG91V5OHcgWLLEduXxgVEJu
         kQP7b4SHzYfpfa+fkEMgnxoM/2+ABspJ77/J3hi9QalVOr8H6WbwigIB9mVSdusPaN8g
         OXnjEPUTXJVmXOk6TnQdB2JLHfgEg8iUwwDzNzqrMHKwS5rbpL6xbmTp/O1qxOmJIdV0
         ulMA==
X-Gm-Message-State: AFqh2koYEZqMZxmw5TP9vtJUlZCmikzzpLTWmOH7FisNrcZMIRPCEn3t
        0m1hYQ1FFvAkTnrA0T8mYekBPJa8tosQONQeU5Qhza0zp1wqDw9sngbxMvoOZAmb4TPR7yOt4pF
        IsMsy0yTb+GTL2+h0
X-Received: by 2002:adf:fe48:0:b0:242:2a13:bbd0 with SMTP id m8-20020adffe48000000b002422a13bbd0mr3444001wrs.65.1671707626648;
        Thu, 22 Dec 2022 03:13:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvFYTsQXXUN7xT2shHzM4FMDAcqZ6mknPwn7aY/S6iGl6EO+PE5M2Bs/eLrVdjOH5CE5aybFA==
X-Received: by 2002:adf:fe48:0:b0:242:2a13:bbd0 with SMTP id m8-20020adffe48000000b002422a13bbd0mr3443996wrs.65.1671707626439;
        Thu, 22 Dec 2022 03:13:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id f8-20020a056000128800b0024216d2e386sm286561wrx.16.2022.12.22.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 03:13:45 -0800 (PST)
Message-ID: <070c6690ad7ea537a7081bc9faa0f78861751bc4.camel@redhat.com>
Subject: Re: [PATCH v3] usbnet: optimize usbnet_bh() to reduce CPU load
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Dec 2022 12:13:44 +0100
In-Reply-To: <20221221075924.1141346-1-lsahn@ooseel.net>
References: <20221221075924.1141346-1-lsahn@ooseel.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-21 at 16:59 +0900, Leesoo Ahn wrote:
> The current source pushes skb into dev->done queue by calling
> skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
> rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
> load, 2.21% (skb_queue_tail) as follows.
> 
> -   11.58%     0.26%  swapper          [k] usbnet_bh
>    - 11.32% usbnet_bh
>       - 6.43% skb_dequeue
>            6.34% _raw_spin_unlock_irqrestore
>       - 2.21% skb_queue_tail
>            2.19% _raw_spin_unlock_irqrestore
>       - 1.68% consume_skb
>          - 0.97% kfree_skbmem
>               0.80% kmem_cache_free
>            0.53% skb_release_data
> 
> To reduce the extra CPU load use return values jumping to rx_cleanup
> state directly to free them instead of calling skb_queue_tail() and
> skb_dequeue() for push/pop respectively.
> 
> -    7.87%     0.25%  swapper          [k] usbnet_bh
>    - 7.62% usbnet_bh
>       - 4.81% skb_dequeue
>            4.74% _raw_spin_unlock_irqrestore
>       - 1.75% consume_skb
>          - 0.98% kfree_skbmem
>               0.78% kmem_cache_free
>            0.58% skb_release_data
>         0.53% smsc95xx_rx_fixup
> 
> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> ---
> v3:
>   - Replace return values with proper -ERR values in rx_process()
> 
> v2:
>   - Replace goto label with return statement to reduce goto entropy
>   - Add CPU load information by perf in commit message
> 
> v1 at:
>   https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/

This looks like net-next material.

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd, including the
expected 'net-next' tag into the subject line.

RFC patches sent for review only are obviously welcome at any time.

[...]

> @@ -1528,13 +1526,14 @@ static void usbnet_bh (struct timer_list *t)
>  		entry = (struct skb_data *) skb->cb;
>  		switch (entry->state) {
>  		case rx_done:
> -			entry->state = rx_cleanup;
> -			rx_process (dev, skb);
> +			if (rx_process(dev, skb))
> +				goto cleanup;

You can avoid this additional label (which is a little confusing inside
a switch) factoring out a usb_free_skb(skb) helper and calling it here
and under the rx_cleanup case.

Cheers,

Paolo

