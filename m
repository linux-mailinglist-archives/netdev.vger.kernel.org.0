Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81275BD305
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiISRBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiISRA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:00:58 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2213ED4F;
        Mon, 19 Sep 2022 10:00:25 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id j8so120336qvt.13;
        Mon, 19 Sep 2022 10:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9fk3wP6VoZWuK519A5QoLgeR5c2eU5kZ2jgqyaYxiIQ=;
        b=UnK4UlEHEst1azMj0iPNMcb3Wjzgs1b08yjCbFbjy5F60H7/bTvu4FxakYSiNZUJBv
         NqmM2wB9oO9RquIRlUe9476hMQtyefBJrADQWsZ2OLC/OqVW6woeSjC1kO5sFZG7q/kc
         T6pA7/SKT3K8MIWyx9KjYw0+J+uHRQn7XrBnMGDbiyemX+ewMEmKL3O25ihpwButvZtc
         30QvCpCtgqpwzs17Y6RWgP7rt0fH7PHeNzfv9YfukCvLSOW6k1Yx71LwO0w6TpCfZ+J6
         EOYQgNsWQ7krjy/j+uq0QvuyJ/9I9L8eA9ooJMRfvpWEnq3ELn7o/ZGYOVC17XbpZQE0
         pkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9fk3wP6VoZWuK519A5QoLgeR5c2eU5kZ2jgqyaYxiIQ=;
        b=7paHPzwhonaYamN7UIvePWEDk8cDGXH1K38wtRqfFWF481tdslSZg1qeDxLjGtiBJl
         RvUv7ZjKrqwqrz3U4XAGzWLf96EmfQBfYWkQPQa0yaEyk0NXYEWNi2AHrUnoVqriK/ee
         zR5tg5OiwLVHnI1KFcrB4j11qNQ+zz6Rtu54/QzJaza8vjyu+syBQd5pnnCaOv88c1WC
         nwOdWKWDMXgSRwdNs0gb4mm4TY7g49XmYo6B1icpSxgNiiuxU1EL9ErBPHGStDx1Gb0M
         Jj8WkHn2h0vYuOJAsAfKr09iK27e5TXuIRW753JYuN24uq/QKHyAQf1uqoX5JOSXp1O4
         lSbw==
X-Gm-Message-State: ACrzQf2f+sPIlSpIci1XAlqorysENURWaasyuy1UdtJAxsz219VAgXtC
        mqU46+N0hQQShZhHckjLeLU=
X-Google-Smtp-Source: AMsMyM4Dlbf6+qpsC+ledJcwU12yXVlxnfAod1ndW/8lsLL9KVJVUjJ0nxJ3xgofIMOl7SorXL5YLw==
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id 5-20020a0562140d0500b004acdaacf1c4mr15506531qvh.84.1663606818811;
        Mon, 19 Sep 2022 10:00:18 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e599:ec9f:997f:2930])
        by smtp.gmail.com with ESMTPSA id x5-20020a05620a258500b006bc1512986esm13332097qko.97.2022.09.19.10.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 10:00:17 -0700 (PDT)
Date:   Mon, 19 Sep 2022 10:00:15 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure
 infrastructure
Message-ID: <YyigH0IvLZ8iGIvf@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <cover.1661158173.git.peilin.ye@bytedance.com>
 <20220822091737.4b870dbb@kernel.org>
 <Ywzu/ey83T8QCT/Z@pop-os.localdomain>
 <20220829172111.4471d913@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829172111.4471d913@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 05:21:11PM -0700, Jakub Kicinski wrote:
> On Mon, 29 Aug 2022 09:53:17 -0700 Cong Wang wrote:
> > > Similarly to Eric's comments on v1 I'm not seeing the clear motivation
> > > here. Modern high speed UDP users will have a CC in user space, back
> > > off and set transmission time on the packets. Could you describe your
> > > _actual_ use case / application in more detail?  
> > 
> > Not everyone implements QUIC or CC, it is really hard to implement CC
> > from scratch. This backpressure mechnism is much simpler than CC (TCP or
> > QUIC), as clearly it does not deal with any remote congestions.
> > 
> > And, although this patchset only implements UDP backpressure, it can be
> > applied to any other protocol easily, it is protocol-independent.
> 
> No disagreement on any of your points. But I don't feel like 
> you answered my question about the details of the use case.

Do you need a use case for UDP w/o QUIC? Seriously??? There must be
tons of it...

Take a look at UDP tunnels, for instance, wireguard which is our use
case. ByteDance has wireguard-based VPN solution for bussiness. (I hate
to brand ourselves, but you are asking for it...)

Please do research on your side, as a netdev maintainer, you are
supposed to know this much better than me.

Thanks.
