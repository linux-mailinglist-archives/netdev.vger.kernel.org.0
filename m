Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5B5624F00
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiKKAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKKAjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:39:02 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E73101E4;
        Thu, 10 Nov 2022 16:38:59 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q83so3575462oib.10;
        Thu, 10 Nov 2022 16:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc4DaRH+ala0GtFq0J+qadcKyncnuGmklGpHg962wB0=;
        b=MQUddlCPl2TrKtW3feLQPAqy9ChlVt8k4M7YFA0M4y0MMgL13bul5KqQLYN/mFIP4m
         FTyBR5GkGZBQ470RhoEcgHZuyn6BHIK35fIw2eUFwT7yEDXjiW8hveYn/atIm++E6tnO
         lisrTj0Mxoso4a6DKDyxl/6ud1AzTVE0g8UEnrF+ivClPud3b4kQMl6YlNCes1EZSBZI
         v1qQECCZyUbSWul6wZq1tCXEPEryyezGpfIiPFiSO+Vx6aKQhZCzByIMvxvPw29duWt5
         ehFw5aicJJ9u7wN9qEEPRaxWI8jfWx2QMhZ6IXw20o2LCGpDWfcenM2lmOAFQayKJHOK
         VV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fc4DaRH+ala0GtFq0J+qadcKyncnuGmklGpHg962wB0=;
        b=0rmSfxr3hnqI6ZENn7q7gU73nlEYvUCUJt1TssjoTfhnILTuaTO5wpHp1EQB2xUeIz
         tip0po7g7fahZi3GcpEltpH4lWUGTSvrE5w9H8k1jSyZClCGnDRtTcOaRQF30P/aXm2Z
         993Clrt4/Zqfn+Htc4Llz+ivhMO/E6U1WJJPVRghobb8V3FEMGanbb/ugRk8xAnC5j7X
         61bKrBGGuDByzSaMo2F5ytVE+Ie3jyoU1tIU6ex7fSmLlXOlQFLvnEE1uGiIJSOr9pos
         OmNULqtau4Iv52kkf0neHNlZKyGTNYAPmrevXf45k9NapMMc3qCAJ8UG1ag5y4hy6njd
         ZO5A==
X-Gm-Message-State: ANoB5pmnfITIEuq/Sku3mXlf+leyWQ7mIZ3F6c6A5yN/tFLl71a7wrhZ
        Jg+irhsIzVgdP+l77YUBKLNjA1CBvI/GNz/G4g5whDr7VHU=
X-Google-Smtp-Source: AA0mqf4FojmGLGgV7wnPqHYC4ZinNnoHHJ4iLU5B66vZWN56qpfd1tvsA/KEe8Nb0Et4nNh23pxJRFQ4/Ye6dyozi7Q=
X-Received: by 2002:a05:6808:1996:b0:35a:8bcb:1b30 with SMTP id
 bj22-20020a056808199600b0035a8bcb1b30mr1968572oib.88.1668127139198; Thu, 10
 Nov 2022 16:38:59 -0800 (PST)
MIME-Version: 1.0
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
 <20221110153901.7daa86e1@hermes.local>
In-Reply-To: <20221110153901.7daa86e1@hermes.local>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Fri, 11 Nov 2022 10:38:48 +1000
Message-ID: <CAAvyFNiojSM-8euLLuuuZ5bDi0CKmoevncs3OQVLzrao1-Q4Jg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
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

On Fri, 11 Nov 2022 at 09:39, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 10 Nov 2022 21:21:06 +1100
> Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
>
> > +         xchg(&queue->synflood_warned, 1) == 0) {
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +             if (sk->sk_family == AF_INET6) {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
> > +                                     proto, sk->sk_num,
> > +                                     &sk->sk_v6_rcv_saddr, msg);
> > +             } else
> > +#endif
> > +             {
> > +                     net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI4. %s.  Check SNMP counters.\n",
> > +                                     proto, sk->sk_num, &sk->sk_rcv_saddr, msg);
> > +             }
> > +     }
> >
>
> Port number is unsigned not signed.
> Message also seems overly wordy to me.

Thanks for bringing this up. I agree with you.

I'd like to remove "Check SNMP counters" as it's not helpful to users.

How do they do that? (note userspace has changed from net-tools
"netstat -s" to iproute "nstat" since this message was added). Check
counters for what? If they even figure out the LISTEN stats are
growing, there's still troubleshooting to determine if the SYNs are
genuine or malicious, check/increase somaxconn and the socket listen()
backlog, check/improve application accept() performance, etc...

This is way too much to describe in a kernel log message, and it's the
job of the log message to be "descriptive" of what happened, not
"prescriptive" of policy to follow and cover every troubleshooting
possibility.

I will re-submit with a second patch removing this phrase.

Jamie
