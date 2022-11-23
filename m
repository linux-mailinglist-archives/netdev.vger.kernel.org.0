Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA863641E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiKWPj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237248AbiKWPjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:39:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C95F389
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669217921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnE2eJkcAqKQ4xiDRecul9dskC/kiQ0F0H9HqP0ouMw=;
        b=Rg+rrpEwWRfrF0Ipo7DY2fPcgogRyeBvIpy9p0m9KpH3h+L+TJTyNctya+/WE+w0qdEo1F
        V//1I6mTo1rO2AZDZfEQuMgt2XlvO3DBnhfa3ZYSYRusz4k9AHGTlXafB5TIsbeYq79vU8
        JZcfhRK/jPabiIz4r8rDnscigDamtNM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-186-cyvL6cAhMCunS3H6zxplcA-1; Wed, 23 Nov 2022 10:38:40 -0500
X-MC-Unique: cyvL6cAhMCunS3H6zxplcA-1
Received: by mail-wm1-f69.google.com with SMTP id u9-20020a05600c00c900b003cfb12839d6so927364wmm.5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnE2eJkcAqKQ4xiDRecul9dskC/kiQ0F0H9HqP0ouMw=;
        b=wTbDweQVONKFDUpX/HCBH3s9OwokaWz90jzgWHEp7OupsQMXyL7f7pmbq9kznlhF2M
         Oty8z7HvfZznUlv9U3jqXu7N7LI/6jHihdivM5e8JleBsKF0Eb5vvn8Z2ea9WbG1XuxU
         o2rELugyPAs6ef6kQgtuGxO1sUCwKl9U1997o9FXlmFLOS47zPQsm4bSYk4tCul+mcNV
         lng0ZEE/fDv7wPHZgmHUKdSbiIvqwxLbepyb9oalM+uc4vc4AP82aEikqvnXbZWOo3Ho
         rGRybRipxGOllHzr1CkD26sbdWPBK1JfdEQc1AsuV6JCTu/AwbUtGwlILVDqCghoRU7N
         ZJsg==
X-Gm-Message-State: ANoB5plaU3WFRsFp/SW4cQ/nA1jQJa9TY6s/OvokZSs/mulWqSVwKhnl
        HzhjvKiI58fmbGnDHIHBDdnJczp4/7CORdOMpsAo/FTlOGAEsELXfgjNBIdvGvAxJiWiIDWQqNS
        NqTvrKdearn6liY5k
X-Received: by 2002:a5d:4d8f:0:b0:22f:8603:24c5 with SMTP id b15-20020a5d4d8f000000b0022f860324c5mr7495541wru.245.1669217918993;
        Wed, 23 Nov 2022 07:38:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5FmAvih45CnQ02JA4tQfmkCHvQ8SoiSQ5PVemZeqphN4qr8WAeqEjQ6KJwsXkYfK1KCt3Ktw==
X-Received: by 2002:a5d:4d8f:0:b0:22f:8603:24c5 with SMTP id b15-20020a5d4d8f000000b0022f860324c5mr7495525wru.245.1669217918787;
        Wed, 23 Nov 2022 07:38:38 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b00241b95cae91sm16950249wrj.58.2022.11.23.07.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 07:38:38 -0800 (PST)
Message-ID: <73f71d4e6f867a90538b48894249be3902eb38e4.camel@redhat.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket
 lock.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>, harperchen1110@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        syzkaller@googlegroups.com
Date:   Wed, 23 Nov 2022 16:38:37 +0100
In-Reply-To: <20221123152205.79232-1-kuniyu@amazon.com>
References: <CAO4mrfcuDa5hKFksJtBLskA3AAuHUTP_wO9JOfD9Kq0ZvEPPCA@mail.gmail.com>
         <20221123152205.79232-1-kuniyu@amazon.com>
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

On Wed, 2022-11-23 at 07:22 -0800, Kuniyuki Iwashima wrote:
> From:   Wei Chen <harperchen1110@gmail.com>
> Date:   Wed, 23 Nov 2022 23:09:53 +0800
> > Dear Paolo,
> > 
> > Could you explain the meaning of modified "ss" version to reproduce
> > the bug? I'd like to learn how to reproduce the bug in the user space
> > to facilitate the bug fix.
> 
> I think it means to drop NLM_F_DUMP and modify args as needed because
> ss dumps all sockets, not exactly a single socket.

Exactly! Additionally 'ss' must fill udiag_ino and udiag_cookie with
values matching a live unix socket. And before that you have to add
more code to allow 'ss' dumping such values (or fetch them with some
bpf/perf probe).

> 
> Ah, I misunderstood that the found sk is passed to sk_user_ns(), but it's
> skb->sk.

I did not double check the race you outlined in this patch. That could
still possibly be a valid/existing one.

> P.S.  I'm leaving for Japan today and will be bit slow this and next week
> for vacation.

Have a nice trip ;)

/P

