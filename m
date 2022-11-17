Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D1362D515
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiKQIel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKQIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:34:40 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25BF2F3BB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:34:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so1287393pjl.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0KWVLK0AlthorLxUQYbsDOBUnc7LcEa/asmJrVzf3rM=;
        b=SNgOEcws6CZTQlfCXd7JePiM9LIKqE2Ri/2Jjmmr7usziFEY4Bq9DO2g9HCHsOPgb3
         c0V1VDlG9eltez2SLMwf0tssxiyF1XoALdylL8j0foPRQ9FFartK4qwr5i1ARCGOlSHX
         xptYtAJ9Oe0SqiBXbe6l/IgTt5TburEM52JqnxqP+G26lq6lvBHdre12whkH8oMvOkR9
         fN8Ft8vF8W/O4Ysyx2CCzUGlYToh1RLBzc+dJPCkCe5riEUyVKsqlNdTYAB1qIaqg7T4
         YFfPN+nMc2O0jZloE3p7+KCChd6+yn8IO8HbTkkK/HsLhGvfyoPpFtVNHr3Kq6gcLsVt
         P6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0KWVLK0AlthorLxUQYbsDOBUnc7LcEa/asmJrVzf3rM=;
        b=qqHDmYsFbe+dH3Xtht4x9Gdi66gUM19V+HJIbiv2/cBCZpLiMULa+sfEBKr8jVpFUO
         J+FV6NmKVOWRV75KPQ2jYYhNiUJCAL0MzMfZshKk4h397KMDoYvpp20WSwvXBO2iK6Rl
         09zyQAgZllHNA60uEMWGjGqXzrKyv6n6tak2cDvO8n5Vi8tWPD9LU/n3MozgPvbupzg7
         bCOpoqczEN5wAfPOE3CbYqFCIluR5cSLYy1RDgNilMxkCLcwZu6MSZSUbWpFGGvsJUae
         vVcqdfP7Dq4INcnEoupo/Vo+DcrLW9AuDHXVYftHIvpiSfV9T9o0MUJ/l2e4aPnNkOcq
         JTVw==
X-Gm-Message-State: ANoB5pkNIZersiBr4OsYS5xodJ4yqupa8Jrsu5wbo59R+Re1yk8g7Cz6
        zwaRqzBOQuBhBBInwJz3Sqs=
X-Google-Smtp-Source: AA0mqf5j0lbudDGCQp6+HdmU9siIADztZhWS9+Ev8aKZMd2RewGXJU62tNmQB5YMEfeIyfQJq8EvCQ==
X-Received: by 2002:a17:902:c613:b0:182:bccf:619f with SMTP id r19-20020a170902c61300b00182bccf619fmr1876872plr.9.1668674079440;
        Thu, 17 Nov 2022 00:34:39 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c14-20020a624e0e000000b0056bd6b14144sm452499pfb.180.2022.11.17.00.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 00:34:38 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:34:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y3XyGIVnX2xvZ/bU@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
 <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
 <17540.1668026368@famine>
 <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
 <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
 <Y3SEXh0x4G7jNSi9@Laptop-X1>
 <17663.1668611774@famine>
 <Y3WgFgLlRQSaguqv@Laptop-X1>
 <22985.1668659398@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22985.1668659398@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 08:29:58PM -0800, Jay Vosburgh wrote:
> > #if IS_ENABLED(CONFIG_IPV6)
> >-	} else if (is_ipv6) {
> >+	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &ip6_hdr)) {
> > 		return bond_na_rcv(skb, bond, slave);
> > #endif
> > 	} else {
> >
> >What do you think?
> 
> 	I don't see how this solves the icmp6_hdr() / ipv6_hdr() problem
> in bond_na_rcv(); skb_header_pointer() doesn't do a pull, it just copies
> into the supplied struct (if necessary).

Hmm... Maybe I didn't get what you and Eric means. If we can copy the
supplied buffer success, doesn't this make sure IPv6 header is in skb?

Thanks
Hangbin
