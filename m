Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10D34BEA31
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiBUSGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:06:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiBUSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:04:26 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747E31DA56
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:56:29 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id t14so15780715ljh.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYNWLnVbKM4xHO28n29WEcF6mje2egR5or43iUYgI8Y=;
        b=CILXkezCgpPmCclkAHIZIeOknVFw1koxGhh+P/JszB5LU8l0sTxsK3rc3yjaEkvn7V
         HnSuioQZMtItzMYIrJ0Ml3seKrxglaadNPwoI3Y1dyGSq0YFuo5F5KwurP3TV1a0WTjh
         owvIJxAb1noguKZX9Q6wWg6rFVpLS2uL9QrFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYNWLnVbKM4xHO28n29WEcF6mje2egR5or43iUYgI8Y=;
        b=TMCvlvXWEHJZzVjiNoNqpu5GVFoYevdmFeBMUPjpm5r73cFP/4XLD1785Z7gltXlVV
         Wb9OAp7+UyyvhY0EmiRJczWj7ihjo2Ziobeac3fazFpOaRY54zIpANRocqqNl0b6+Rv2
         tDQOLsD2OfSJvtAiCz0Dh4O6JzKvSx3LUP+H2ejwQ5sGQWBVwjFUp09df8YWo8eeu1yp
         6tT4IHcEic6gU6+RWzOrwtY0Or+e3L217DOXXYs6tuMjJYb9U2xTgXkDS+jMFk0fWCKa
         vWkreSzanFUi/E5gLGzfyhiGMrexNvtko31JCQwAEYo7qOdR6/O0v3NCapC6dG9JdiJp
         QReQ==
X-Gm-Message-State: AOAM531CK6Zkyr+vlNYjVLWlytYljwCCbfg+LQA/2xE4Ao7fgIt9nkRV
        xfRegErbM7M3vRR1Iv7XzirWtZYkjIATHDJw
X-Google-Smtp-Source: ABdhPJxI1h4bbZPMnVU5gxcesq4HdTSVMzkjQB66Pw+WKMtmj9aHpiQzMNt5+5sHvzFMfeqh243BRQ==
X-Received: by 2002:a2e:a4ce:0:b0:246:ea3:c384 with SMTP id p14-20020a2ea4ce000000b002460ea3c384mr15342675ljm.70.1645466187568;
        Mon, 21 Feb 2022 09:56:27 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id h21sm775482lji.108.2022.02.21.09.56.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 09:56:26 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id v22so13905578ljh.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:56:26 -0800 (PST)
X-Received: by 2002:a2e:aa1f:0:b0:244:c2ea:7f20 with SMTP id
 bf31-20020a2eaa1f000000b00244c2ea7f20mr14792237ljb.164.1645466186113; Mon, 21
 Feb 2022 09:56:26 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
In-Reply-To: <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Feb 2022 09:56:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
Message-ID: <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
Subject: Re: Linux 5.17-rc5
To:     Woody Suwalski <wsuwalski@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 6:23 AM Woody Suwalski <wsuwalski@gmail.com> wrote:
>
> Compile failed like reported by Robert Gadson in
> https://lkml.org/lkml/2022/2/20/341
>
> As a workaround:
> nf_defrag_ipv6.patch
> --- a/net/netfilter/xt_socket.c    2022-02-21 07:29:21.938263397 -0500
> +++ b/net/netfilter/xt_socket.c    2022-02-21 07:40:16.730022272 -0500
> @@ -17,11 +17,11 @@
>   #include <net/inet_sock.h>
>   #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
>
> -#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +//#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>   #include <linux/netfilter_ipv6/ip6_tables.h>
...

Hmm. That may fix the compile failure, but it looks somewhat broken to me.

Other cases of nf_defrag_ipv6_disable() end up being protected by

   #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)

at the use-point, not by just assuming it always exists even when
CONFIG_NF_TABLES_IPV6 is off.

So I think the proper fix is something along the lines of

  --- a/net/netfilter/xt_socket.c
  +++ b/net/netfilter/xt_socket.c
  @@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct
xt_mtdtor_param *par)
   {
        if (par->family == NFPROTO_IPV4)
                nf_defrag_ipv4_disable(par->net);
  +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
        else if (par->family == NFPROTO_IPV6)
                nf_defrag_ipv6_disable(par->net);
  +#endif
   }

instead. Entirely untested, because that's how I roll, but I suspect
the netfilter people will know what to do.

Added guilty parties and mailing list to the participants.

                Linus
