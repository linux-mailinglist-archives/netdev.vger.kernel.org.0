Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944E76265C1
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiKLAAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKLAAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:00:05 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D32E02B;
        Fri, 11 Nov 2022 16:00:04 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-13ae8117023so6993736fac.9;
        Fri, 11 Nov 2022 16:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=moCSFxRiLvV27l+5RN9Db0meX3ftFtMnZPLvMDi5JNo=;
        b=W82OTe/i5MxaU8UNp+X0dlIBF0zGwVzwvtpY+wQutiWTqqjkKe3m91JSqo1Abmy8YP
         SDDXfFqzzYHfl1xGQJWhJI4wfzBh3Gk9ZBnSvsWZjg0EquRq5jE8YzdT3/iyUrbPqGM4
         Pnsz6Kr4z8IvrkfSxLsMwiRrkZs5F/SRib1i+w2VdKn7jVNAgfkjeEb2JJkFeSUf/j4f
         cgOUdvsMGSSzUJOg+UmGs3U8F0QhZ+p+uqJUsLC4RJC18lhCuIOIxfcoq9y90EDDBkiW
         7O0r2rhcWqsFYfuFZSZfKa1tfc0qqQzJ8zcoU/hu2jr7ZTNxJQ+WCqNxCCWWoeGsJlUy
         oorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=moCSFxRiLvV27l+5RN9Db0meX3ftFtMnZPLvMDi5JNo=;
        b=z4Bj11MJDZtb53r/gpAF1wqOcdCmDkTTc8wWq4laHVF8t4h23mHOAv6h1xSR42YDLO
         vxozg1cRL0UDKm1fVHij0VIpdUjwZoBoKKdGjlcbbdORuAzH3PiVz2SoHGFtoPf/qyTQ
         t/zXlvoQJkuTpxml6fXOTyTMr0KDLTyCp+RQv5hNFr7h6s/qHLMyWFUcPIABzh2vAhxs
         HtSbuLSQEpus0dTkJTY9gWU+MxTqe7AbtuMAmjoqmDw51n/iDfWdOpSmHsugjFOT9Wue
         gN4UEW7xrvcIRG2ti8A1i6VnoW24jgweH4jqXHYnsN361zTTFD8lW3seUoQ0m1vAwHIs
         lmJw==
X-Gm-Message-State: ANoB5plTqP5LL5KolFLEr3HfEPqpcoN7EOtN/oC9PKf/xdvm+tUQoB8m
        Yop/9ESrK8HKC8F2ysZs/5CI7cuxd+6NDhxe4QhLyjqe/Tk=
X-Google-Smtp-Source: AA0mqf4Pc3RMMas7umhpoHwXrqakkxmR3f59f8EQHgrjRo2KJbNyT83vTmO6NlMLh8MqWzLGNDooNAXaRTajLVWGIZM=
X-Received: by 2002:a05:6870:c090:b0:132:a89d:7d40 with SMTP id
 c16-20020a056870c09000b00132a89d7d40mr2213022oad.97.1668211203374; Fri, 11
 Nov 2022 16:00:03 -0800 (PST)
MIME-Version: 1.0
References: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
 <20221111092047.7d33bcd3@hermes.local>
In-Reply-To: <20221111092047.7d33bcd3@hermes.local>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Sat, 12 Nov 2022 10:59:52 +1100
Message-ID: <CAAvyFNhkn2Zv16RMWGCtQh4SpjJX56q8gyEL3Mz6Ru+Ef=SJfA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add listening address to SYN flood message
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Nov 2022 at 04:20, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 11 Nov 2022 14:59:32 +1100
> Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
>
> > +         xchg(&queue->synflood_warned, 1) == 0) {
> > +             if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
> > +                                     proto, &sk->sk_v6_rcv_saddr,
> > +                                     sk->sk_num, msg);
> > +             } else {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
> > +                                     proto, &sk->sk_rcv_saddr,
> > +                                     sk->sk_num, msg);
>
> Minor nit, the standard format for printing addresses would be to use colon seperator before port
>
>                 if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
>                         net_info_ratelimited("%s: Possible SYN flooding on [%pI6c]:%u. %s.\n",
>                                         proto, &sk->sk_v6_rcv_saddr, sk->sk_num, msg);
>                 } else {
>                         net_info_ratelimited("%s: Possible SYN flooding on %pI4:%u. %s.\n",
>                                         proto, &sk->sk_rcv_saddr, sk->sk_num, msg);

I considered this too, though Eric suggested "IP.port" to match tcpdump.

Please let me know which advice to follow?

Jamie
