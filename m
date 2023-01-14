Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2954F66AC2F
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjANPjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjANPjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:39:12 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207567A9C
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:39:11 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 7so16857270pga.1
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ksDCogpM44p1MYL9LvFyCbpk9oMtoefLtPsNaDS+1Uw=;
        b=IThA4Qp/47WBuI8os4H/m5l293jq3yndtbTSIqr6XNO4cHloGhTf4aQC+MrbVp/iCg
         uQUFidWlLHRRd+h6RcmveluRwt5NZoo2An/ZrpKUusSIBQtWwpEke2+cvnxAvRBHtHLn
         RgYxP8kmNXGdxXI3I/NGNv1AVMLLxyQB+nIQVYY65yK5WtqyLqwXo/aIyA2PTaUbJf3x
         7gB93AeEoKRWKe6ebRVReiDQucBx/ON1ULR2srNsmWevrdVVSgPuAe1wvJR5eBHrGpwe
         f0wYNYh56HFn2p+lw/2LgcxemNgqos5uyxPZZJwz8Y6x5DkpKBMS/7pS536sxtq8Yj34
         5wrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksDCogpM44p1MYL9LvFyCbpk9oMtoefLtPsNaDS+1Uw=;
        b=FJBwWDCKrgYAXQfYn/CZVAOPf6SF5J6itSHdfWu0iPpgP+Q00da0nYKyCpR4fmkKCG
         zOlYyj9pvZmbcATR96LupWkFIv/lwneRCx2THZXeu0q5uwvo/l/slvduewSgWiyn1eys
         f+kEMG3XOcjot1lJ3ai6UDrozyERlhM9DUKd1fDKi65EKPetamIL0SPXKmdxtRyzg2qO
         3NA5ATffCswpREQeIkQfm1swtaxRhMkqYu71IzXQUW8JxJB/Z8YGpdFV6uVp8oFmfud+
         w/bF8WbyJvLdcRtvfJK7tHIZpbEVQrlIoCDxwUENh4JRSwtXBeHjqZFr6xsJeEJSoAjR
         +tsg==
X-Gm-Message-State: AFqh2koIf6zp+aV4Et7gZQBZgpRU2AdU+PXgLxsXFFFdsuZ1Y3uNQ9Ra
        vVd8fdlI6HSarRqYlUXmV4jHAaXwE4wC2RhM29A/
X-Google-Smtp-Source: AMrXdXv4BoDUHdpVNEYbOge+hC2COffpE8YpFO3Rq+AKRcoghZ8QDj5/8j6P++J0htEwejt6n9QXCwzM9ZhEw+/GTlc=
X-Received: by 2002:a63:ea10:0:b0:4c7:ac8f:9e9c with SMTP id
 c16-20020a63ea10000000b004c7ac8f9e9cmr99166pgi.92.1673710750546; Sat, 14 Jan
 2023 07:39:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
In-Reply-To: <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 14 Jan 2023 10:38:59 -0500
Message-ID: <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> the iph->tot_len update should use iph_set_totlen().
>
> Note that for these non GSO packets, the new iph tot_len with extra
> iph option len added may become greater than 65535, the old process
> will cast it and set iph->tot_len to it, which is a bug. In theory,
> iph options shouldn't be added for these big packets in here, a fix
> may be needed here in the future. For now this patch is only to set
> iph->tot_len to 0 when it happens.

I'm not entirely clear on the paragraph above, but we do need to be
able to set/modify the IP options in cipso_v4_skbuff_setattr() in
order to support CIPSO labeling.  I'm open to better and/or
alternative solutions compared to what we are doing now, but I can't
support a change that is a bug waiting to bite us.  My apologies if
I'm interpreting your comments incorrectly and that isn't the case
here.

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/cipso_ipv4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 6cd3b6c559f0..79ae7204e8ed 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -2222,7 +2222,7 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
>                 memset((char *)(iph + 1) + buf_len, 0, opt_len - buf_len);
>         if (len_delta != 0) {
>                 iph->ihl = 5 + (opt_len >> 2);
> -               iph->tot_len = htons(skb->len);
> +               iph_set_totlen(iph, skb->len);
>         }
>         ip_send_check(iph);
>
> --
> 2.31.1

--
paul-moore.com
