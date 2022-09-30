Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A46A5F0D78
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiI3OYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiI3OY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:24:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFC31A88EF
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:23:16 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so2333610wmb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=Q+K17a8hUK/A4pihm1n7V5b6vqDIcOGg+PRWT6sP7tg=;
        b=V3j6+SlXlcxzrMmeRetgpiqxi/JZmLX30wy6bO+n4W3d5Cfi80wL3rb4Wmpx6sluta
         wpwOZnbmkEfQxeDEbx4bJOck22t/+IQoeEKU0NO8LUz9w3AVRjoBohMxTvFRGGFWnYDN
         rRQW3S/5/pALNk/dOSJmmGt64Q/O+HY+SjVO48NFxEwLKYklNEDkv9wTyZoy29t6YkAc
         wdhgw3MhfjA90EBTEruAmWXx0cscmql9tTfoNWcmVTEYkOyaskYvk5CME88wNUO7Rr80
         GgapGuE+BnTh7v8zrms818HdjYcdUl2q0nLbGZarCGuqXjBjEx4OofXLfJM6Z/Xl9ZDy
         /x2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Q+K17a8hUK/A4pihm1n7V5b6vqDIcOGg+PRWT6sP7tg=;
        b=5ZvN2zXyawVN1wbl3hP3M4lLyKQheg5MmiZATQEpvS/Xyv4oyevuLu9T8XBR760QkQ
         WmKDo08n0KOSEDo08Gn3eSOMYgSjf2WS4EKiWBBSOcbCpvVvztTeJ638cJQG+JFzM18U
         A9IR2BUJtEA8lVg/NHRx40FaOhVVxDuUC1yH7DTK3VlNB4fcVroEskWH7jHTDEIjHzkI
         6Y6SzXru4NpQ423QUsYoJpBl9mzwF+fD/vOwcGFaQTwPVWHtldV5ehI29bMEHZrdXY8Q
         4ivEDb9VyRpvTkfonj8Wp2KsJp0cOJhdeyeAS1wqmrnP9GYsi6CvC+rh4QTOUHN4NqXu
         7ocA==
X-Gm-Message-State: ACrzQf3uAi0s0AJYGfKFvH8LgxQoQVMAPFrvY+8OWq2+ov8lRXSXJxcp
        c4e9QLYyJMP6GsXJUeTYS9ccsKWwhxE4EQ==
X-Google-Smtp-Source: AMsMyM4vPT5aU3+PEJUTKL+dPzTJukSae3pGzytbCFPo9MS4uwoQD+KTdE33yEJ5kbhaG56jpCxPwQ==
X-Received: by 2002:a05:600c:3d17:b0:3b4:adc7:976c with SMTP id bh23-20020a05600c3d1700b003b4adc7976cmr14099120wmb.108.1664547788645;
        Fri, 30 Sep 2022 07:23:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5? ([2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5])
        by smtp.gmail.com with ESMTPSA id bg33-20020a05600c3ca100b003a5f4fccd4asm7320300wmb.35.2022.09.30.07.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 07:23:08 -0700 (PDT)
Message-ID: <aae1926b-fbc3-41ff-aa80-a1196599eacb@6wind.com>
Date:   Fri, 30 Sep 2022 16:23:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCHv5 net-next 2/4] net: add new helper
 unregister_netdevice_many_notify
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-3-liuhangbin@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220930094506.712538-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
> Add new helper unregister_netdevice_many_notify(), pass netlink message
> header and port id, which could be used to notify userspace when flag
> NLM_F_ECHO is set.
> 
> Make the unregister_netdevice_many() as a wrapper of new function
> unregister_netdevice_many_notify().
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

[snip]

> @@ -10860,7 +10864,7 @@ void unregister_netdevice_many(struct list_head *head)
>  			dev->netdev_ops->ndo_uninit(dev);
>  
>  		if (skb)
> -			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
> +			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, pid, nlh);
>  
>  		/* Notifier chain MUST detach us all upper devices. */
>  		WARN_ON(netdev_has_any_upper_dev(dev));
> @@ -10883,6 +10887,12 @@ void unregister_netdevice_many(struct list_head *head)
>  
>  	list_del(head);
>  }
> +EXPORT_SYMBOL(unregister_netdevice_many_notify);
Is this export really needed?

> +
> +void unregister_netdevice_many(struct list_head *head)
> +{
> +	unregister_netdevice_many_notify(head, NULL, 0);
> +}
>  EXPORT_SYMBOL(unregister_netdevice_many);
>  
>  /**
