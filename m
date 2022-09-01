Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD25A9ADC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiIAOu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiIAOuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:50:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F984AD72;
        Thu,  1 Sep 2022 07:50:43 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso1616714wmr.3;
        Thu, 01 Sep 2022 07:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+ZP6o1gBBlBVeWAFEqgtYPLn6+d3r7xqEVeih0fyUso=;
        b=iFrD1NozxA6YVu/pF75I5AvknHZH0pFYr0Ht2CqUidAoEzNuE45O8UivGswS3F+2MO
         tI+GAGT4gXRqxaJpTMNjUivI7L77XgfmnnqwhkJ50GCb3FuakSkrZoL75xX6mzwfjWTQ
         P/HRjyOYZIcBL0/qfDmABdX/0BxlNqU0FAtQkEqfMMHYCSxGdm9rLlcmYLe43pg1cc7h
         WrC5+1ddVMQ9PANwg4bP8KGiX8+1J0Fmr2cT8nvimFiL4wA+FXtebFDs3LAPQm9aJinE
         6jSG5eD0hBWEMBn/s/r8tyiGdnqNkHVGxoIib3crCA772KUd1huXzl5Inl1JdlR9HJbC
         L+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+ZP6o1gBBlBVeWAFEqgtYPLn6+d3r7xqEVeih0fyUso=;
        b=LTvxVjBE9I89pKPLnne1PQzDDrh6PBRwoqlQHFtgIle6f8eloSErGTCFrxEjaOUnBy
         tDZNLXeJF5GSD/0LUvPdxJIYzDno20Q8MQqCd3GGXZWPhgs5kmAGfWxgp4+sBa8RjAc+
         IZU/aKro+UThCt+5CFPJroeofKdOcWWXh+44UbwW9K8jdWYo+p7yjkQ7f7JuWuTfo2ED
         AHpK8haaUF3TdCR/KwCvcLMneVT3LiErcrh230EQf0jXq+fJ2mrz5yKizNpFsGPphrNE
         lZnsHMfSZLyum97xci8XPh3qtWEeQtMqiYbZpZ+mQvCoGsSxQ1ngi3zP2zYsEU37Ig8v
         aYFA==
X-Gm-Message-State: ACgBeo0230T5eL5XTwSiiRKmlVadv2TxpBdxc98ZGcNBa5ummNY1b5NJ
        Djy0Kxvd+Mh6b7G1suiGalY=
X-Google-Smtp-Source: AA6agR6QGHgUJ6JL78VmA9OekXr5ZRCUaKHcp8uzSaCgosq6wKYvw6oMjyK6sGuqR3194MMhIKcKkw==
X-Received: by 2002:a05:600c:3790:b0:3a5:435d:b2d3 with SMTP id o16-20020a05600c379000b003a5435db2d3mr5611084wmr.134.1662043841499;
        Thu, 01 Sep 2022 07:50:41 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id r21-20020adfa155000000b0022585f6679dsm14872979wrr.106.2022.09.01.07.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 07:50:41 -0700 (PDT)
Date:   Thu, 1 Sep 2022 16:48:47 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/4] net-next: ip6: fetch inetpeer in ip6frag_init
Message-ID: <20220901144810.GA31767@debian>
References: <20220829114600.GA2374@debian>
 <CANn89iLH4nDuOHS-0AzYBYOz4f3byZndKXG3_VefVxUbujJZNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLH4nDuOHS-0AzYBYOz4f3byZndKXG3_VefVxUbujJZNg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 03:20:54PM -0700, Eric Dumazet wrote:
> Sorry, this is adding yet another bottleneck, and will make DDOS
> attacks based on fragments more effective.
> 
> Whole concept of 'peers' based on IPv6 addresses is rather weak, as
> hosts with IPv6 can easily
> get millions of different 'addresses'.

I understand the problem with the implementation. Since peers don't 
carry much weight in IPv6, this patch can be dropped.
