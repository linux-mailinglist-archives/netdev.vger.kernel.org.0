Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91523624E85
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiKJXjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiKJXjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:39:07 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1ED52897
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:39:06 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z26so3457572pff.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egD5Tg++8qx4ItNprsKNgzbgrJeq4vL0OWVeOsX4bbk=;
        b=JbrJhXsxnEC6xWL50DeLPpqlBafgykYLTM2Xw/4Z/zI3QEWWvHC2Zymh5PfxYB2Ki/
         GMSCiHP0POQDXpdibgCAIDDk0qB4OGKvRDbzxwE8JVEPGNLhvzGKXc39DeCdggd/k3oq
         0lVaUTtPIv23gKvAObPZgVdVdRMvWruw/Xzr1gA1r2NzkSbCzX+vaem9UKBu1dsWN8nx
         PBj3ujyuQK4tiqGncJ62NDFGd9Iel7tmAjZpHwFZSJ4+5TA4stX9iSa75cuzUSkquBQe
         sBGBeaa6RJKZG1Pl+OCZp6uSwLSrn2j+RpfLJwUcGYe1hESxdU5GT8Cn1ZlOK4hu6eV/
         NRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egD5Tg++8qx4ItNprsKNgzbgrJeq4vL0OWVeOsX4bbk=;
        b=e8WzcU3LZqPKQjn6OsBbvPvmldqlqTFSmO59Keg0Dohkq9MIwike/AYchL81SD4oHt
         51geF5lY6kvXz6kQljHglHDi6W7N2baKoMyJ+WaUzl1FKrFOQchil2UHwtFVlP9JUmlL
         p/bTsEnmBNUDXT0iLNYNe6UivkCLEmHhDe/jCxb9GWygVg6gpKbN3sx4GNeEQhZ0obQQ
         PnNC5PnwXLXb5IsVwFhysoawU2w4cIDgc6XVz9ntlxIraVXsScUY6isVVI1cCtRDBTl0
         zxog9KFdWUIYST+/XWladJCypO4GbzOPtCOMZTK/7Mu9MdlDFKYoG+ehox1bd8RWCNyA
         zUCQ==
X-Gm-Message-State: ACrzQf2wTtN3tEK2WgYeC541oV1BSEDEKnOGXWFNyp4RqIM9FRdOCF45
        NN3LQiGwaTqRUlm5JMVd6W8w6Q==
X-Google-Smtp-Source: AMsMyM5kS/IQV5jAfUUf7aC0Yja0iyMPxgwH8pK9Sci2X/77qGSjw+nGM6+hKorqrSp/vyGe9VF2xQ==
X-Received: by 2002:a63:1250:0:b0:459:a339:89e0 with SMTP id 16-20020a631250000000b00459a33989e0mr3809729pgs.300.1668123546045;
        Thu, 10 Nov 2022 15:39:06 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c188-20020a624ec5000000b0056be7ac5261sm203023pfb.163.2022.11.10.15.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 15:39:05 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:39:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
Message-ID: <20221110153901.7daa86e1@hermes.local>
In-Reply-To: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 21:21:06 +1100
Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:

> +	    xchg(&queue->synflood_warned, 1) == 0) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (sk->sk_family == AF_INET6) {
> +			net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
> +					proto, sk->sk_num,
> +					&sk->sk_v6_rcv_saddr, msg);
> +		} else
> +#endif
> +		{
> +			net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI4. %s.  Check SNMP counters.\n",
> +					proto, sk->sk_num, &sk->sk_rcv_saddr, msg);
> +		}
> +	}
>  

Port number is unsigned not signed.
Message also seems overly wordy to me.
