Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FAF623E74
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiKJJUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKJJUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:20:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A1468C58
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668071956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mRhfyzeDPw3g9U5XBTFxj73do0F4gOUemug9wWR34NM=;
        b=fdWkjKzWjon8EpxFPG64xT/zMl/KNguNzWIWFm+qRa1vLV79cUgCYyvpjvLcVYaH2od9uD
        Nw/LjjMkDakBAGSX7muGropBUmlu9iFNPmAtFt+Go1WPDGFGuwCyAWryNRFwF60RLS9o6P
        DqdqCj0AKfHbjsPAcJiNPakk13A0WS8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-_28fJSuZNMKNoMvIR4k39Q-1; Thu, 10 Nov 2022 04:19:15 -0500
X-MC-Unique: _28fJSuZNMKNoMvIR4k39Q-1
Received: by mail-qk1-f200.google.com with SMTP id br12-20020a05620a460c00b006fa52448320so1434184qkb.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mRhfyzeDPw3g9U5XBTFxj73do0F4gOUemug9wWR34NM=;
        b=vddW1B6lmf+JhB6bsq87FL1WLmgiC54ID8mjcbSwIbPYbmSTwdNfnELDdaSQnqQqLW
         vn8Gf3DMvAixqd/Bq6goB/0Pa6CofVo5WcthXmLKTpTbHsM8dOj3En/5zq9P4GdUAbRS
         5SFf5yCyfESMAcGqiV1Bmqwzu67z5/MzIB8Z0GCHgnif4nN3/6F/7fYD7EQ753LHkoEy
         adWBx74s3hYTHW4AXy9XiZOH2TMtbzdNvcGErP00O1uu9V3od1b0en201w9vE70OY82k
         GjfuN026+drWICMm+fEQdzF/peO9k2wrzQtYANheO9BMCVT8xswHVuFDgDp1U39hgyNT
         ljkg==
X-Gm-Message-State: ACrzQf1Wr3IRpYRSxcM4xyWTBZr3I730mTsBIQ2ON2YMN/ghVW4rz/Yo
        pNwx1Hw7g6ljjh0oVP3qCnT/wmn0vivVGhSWdhhgd8xZ8kLDH8f1HhoHBwbRJUKewyUeZCYoq8X
        RFtkYXLsJzq33OyXJ
X-Received: by 2002:ae9:ef15:0:b0:6fa:bb6:3485 with SMTP id d21-20020ae9ef15000000b006fa0bb63485mr46193763qkg.322.1668071954860;
        Thu, 10 Nov 2022 01:19:14 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6IhpuYlxtWq9PAV8lHyJISssibYZtX0N0LUjYMJbGH8QnRLUIdLs2qcQ3jtLyRVPQ5BEGRYA==
X-Received: by 2002:ae9:ef15:0:b0:6fa:bb6:3485 with SMTP id d21-20020ae9ef15000000b006fa0bb63485mr46193747qkg.322.1668071954570;
        Thu, 10 Nov 2022 01:19:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-116.dyn.eolo.it. [146.241.96.116])
        by smtp.gmail.com with ESMTPSA id cd3-20020a05622a418300b00399edda03dfsm11000220qtb.67.2022.11.10.01.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 01:19:13 -0800 (PST)
Message-ID: <4c78a1d842899ca9a1a9ee9a79066db9489afe61.camel@redhat.com>
Subject: Re: [PATCH v1 net] dccp/tcp: Reset saddr on failure after
 inet6?_hash_connect().
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        dccp@vger.kernel.org
Date:   Thu, 10 Nov 2022 10:19:09 +0100
In-Reply-To: <20221103172419.20977-1-kuniyu@amazon.com>
References: <20221103172419.20977-1-kuniyu@amazon.com>
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

On Thu, 2022-11-03 at 10:24 -0700, Kuniyuki Iwashima wrote:
> When connect() is called on a socket bound to the wildcard address,
> we change the socket's saddr to a local address.  If the socket
> fails to connect() to the destination, we have to reset the saddr.
> 
> However, when an error occurs after inet_hash6?_connect() in
> (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> the socket bound to the address.
> 
> From the user's point of view, whether saddr is reset or not varies
> with errno.  Let's fix this inconsistent behaviour.
> 
> Note that with this patch, the repro [0] will trigger the WARN_ON()
> in inet_csk_get_port() again, but this patch is not buggy and rather
> fixes a bug papering over the bhash2's bug [1] for which we need
> another fix.
> 
> For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> by this sequence:
> 
>   s1 = socket()
>   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s1.bind(('127.0.0.1', 10000))
>   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
>   # or s1.connect(('127.0.0.1', 10000))
> 
>   s2 = socket()
>   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s2.bind(('0.0.0.0', 10000))
>   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
> 
>   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> 
> [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> [1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
> 
> Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

As there is discussion on the correct approach here, I'm dropping this
patch from pw.

Eventually we can revive it later as needed.

Cheers,

Paolo

