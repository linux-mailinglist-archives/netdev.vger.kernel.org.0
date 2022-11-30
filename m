Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9B63D674
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiK3NS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiK3NS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:18:26 -0500
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD4124F0F;
        Wed, 30 Nov 2022 05:18:24 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id s12so23995295edd.5;
        Wed, 30 Nov 2022 05:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3gCSpctzSb5QQ/wDIhVeSSLZMDhkOBRyiGRuBRimuo=;
        b=V+W+YM544wbHcC9G8cXtrINwH3eFIe4dyJqg++CvRKtPI3CBHvk9VYF51BRvbsKhy0
         PJcU4K3iE413N8f9Miuw4UL45VA4VgFSbayTak0hR6x3Q6GshJ19TtxGjNtu2JMYm7lf
         ZdhoGytSXHDYxWL32BnMvIa1vr9zdwdp4ymV+MWKb1mBStgTBqg1uW4/t7juF3bSnjpw
         42Az6/XDi9sY1sgwxqomWEAORnePcuR/e9jm05/Dc01DobNoh8hjSyVevjXT9D18sH9Z
         W81Y1110eGxjvgklL4inpeqxmCi5ZgZ2/NQqnf3UkZiY3CqGnU4fV+GqI1ujfMwhe+Rj
         +SKQ==
X-Gm-Message-State: ANoB5pmH9jvfVk97NlVv7FZKih80+YQgIyCe+2yo4braBMtzALumT+GF
        8SSSzMk+NI06pyj26/iC6cSgyeoyentfCA==
X-Google-Smtp-Source: AA0mqf41seBsYiqkTCekZEaAEFw8V7u/u8Myu8PnrQun9domaFmvcOuaEDBknGeoBBXu3kw8S73r3g==
X-Received: by 2002:a05:6402:144f:b0:46b:51e5:832a with SMTP id d15-20020a056402144f00b0046b51e5832amr11078029edx.331.1669814302988;
        Wed, 30 Nov 2022 05:18:22 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id i9-20020a170906698900b007bff9fb211fsm644089ejr.57.2022.11.30.05.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 05:18:22 -0800 (PST)
Date:   Wed, 30 Nov 2022 05:18:20 -0800
From:   Breno Leitao <leitao@debian.org>
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <Y4dYHLMTtr+QqeLm@gmail.com>
References: <20221124112229.789975-1-leitao@debian.org>
 <20221129010055.75780-1-kuniyu@amazon.com>
 <Y4X/XidkaLaD5Zak@gmail.com>
 <A5D7EBCF-CC49-4575-9DA7-0419BA1F0E9B@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5D7EBCF-CC49-4575-9DA7-0419BA1F0E9B@amazon.co.jp>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 09:16:16PM +0000, Iwashima, Kuniyuki wrote:
> > On Nov 29, 2022, at 21:48, Breno Leitao <leitao@debian.org> wrote:
> >> On Tue, Nov 29, 2022 at 10:00:55AM +0900, Kuniyuki Iwashima wrote:

<snip>

> >>> +void tcp_sock_warn(const struct tcp_sock *tp)
> >>> +{
> >>> +   const struct sock *sk = (const struct sock *)tp;
> >>> +   struct inet_sock *inet = inet_sk(sk);
> >>> +   struct inet_connection_sock *icsk = inet_csk(sk);
> >>> +
> >>> +   WARN_ON(1);
> >>> +
> >>> +   if (!tp)
> >> 
> >> Is this needed ?
> > 
> > We are de-referencing tp/sk in the lines below, so, I think it is safe to
> > check if they are not NULL before the de-refencing it.
> 
> tp->snd_cwnd is accessed just after this WARN, 
> so I thought there were no cases where tp is NULL.

Oh, important to say that we want to re-use this macro on other places
as well. This initial usage (on tcp_snd_cwnd_set()) is just for the
initial patch. I see value replacing some WARN_ON_*() by
TCP_SOCK_WARN_ON_ONCE() in other parts of the code, so, this check is to
protect this warning when TCP_SOCK_WARN_ON_ONCE() is called from
different places.

Anyway, I definitely can remove the check here, but, we might want to
re-add it later, as we replace some WARN_ON_* by TCP_SOCK_WARN_ON_*();

> I think this additional if could confuse future readers and 
> want to make sure if there is such a case.

How come checking if a pointer is valid before de-refencing it could
confuse readers?

Thank you for the review!
