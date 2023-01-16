Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7523766CA97
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjAPRER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbjAPRDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:03:45 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECA023849
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:46:06 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9so30840777pll.9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G5xdC5LwMD/ipfE3iBN2Q9a4TuaQgAxWb/HGuduCpOc=;
        b=FkgVPuCQoJaG83mIenFRaV1h6dr8Lpo0u4FdurHSkTiUvDh/K1NCM6NMBt1lUIVC5I
         B5llvJjtVidJCXmYYJuyJmy2GPQpopyaV30yr6VCVTZ2g7Q7Dq5rFdiUQiXSuP5p47AO
         2VCvnudRTOwxqWnboMa54xjVN4fJfPpodihbrnTSabtVfXdebfHJzam44oeK8ctOKohx
         zjS1vJ52dTxAmkKN+mXEdkKgVDs50VmWu/cbIuSHSEU3xm5rNiu46QEFEev82BvWKj28
         joYlXbdVgYBuYXSdzkD4TJiLCwSOhDDn/nzOyEJ6JT/pqpIYe6rziH4a4NPqvcBJuLoI
         iRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5xdC5LwMD/ipfE3iBN2Q9a4TuaQgAxWb/HGuduCpOc=;
        b=4wvkFmZprGCUR2arvA5pj/dTzxYJKQhS9yGuf3RiWw/DDgBjboOG8S80qusT9IMjAH
         LckHnKnPIN7F9CBhyBJKXbD5IMx7o/WPEKh9VzVtUzNwlPCh+50PQYFN96XoJUYNj2cd
         TdwU1TSZcLVinxX38vMFmHubOhrFNXnrSMSEA5SN8IIXu1mu1VkouzeVPgSSDWiojqRF
         BYTv+Tsg8XwiwGkD47bWxi3zpf0CQ3cvPqpKqx33ESJMQEFofAHXbXPMkL8j2f+d5mDG
         3SjfW0Dpgdb2GDLKoBuOgFhtADmi5JHq6apMEMsH+XxIpDoyI835msGDEnRp90Cq98SE
         EbjQ==
X-Gm-Message-State: AFqh2ko5b6s/fap49Bhvc97ekbvKjawOmCGqIP2QOySl/DNNa/9rlSXj
        wwnZKNTNGnSq0jL3ZwAiz7SeVVjvobsh05kKqOOV
X-Google-Smtp-Source: AMrXdXuhjDRx9RIlrS1Ms2vAw/943zKKLsuzdWb49Tm3E4s//KHZ4T337iPLXVNRVj22dKXKZYoZh4fDN/JODKOPrDg=
X-Received: by 2002:a17:90a:970a:b0:228:c8ae:ecfd with SMTP id
 x10-20020a17090a970a00b00228c8aeecfdmr2357228pjo.72.1673887566232; Mon, 16
 Jan 2023 08:46:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com> <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
In-Reply-To: <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 16 Jan 2023 11:45:54 -0500
Message-ID: <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
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

On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> > > the iph->tot_len update should use iph_set_totlen().
> > >
> > > Note that for these non GSO packets, the new iph tot_len with extra
> > > iph option len added may become greater than 65535, the old process
> > > will cast it and set iph->tot_len to it, which is a bug. In theory,
> > > iph options shouldn't be added for these big packets in here, a fix
> > > may be needed here in the future. For now this patch is only to set
> > > iph->tot_len to 0 when it happens.
> >
> > I'm not entirely clear on the paragraph above, but we do need to be
> > able to set/modify the IP options in cipso_v4_skbuff_setattr() in
> > order to support CIPSO labeling.  I'm open to better and/or
> > alternative solutions compared to what we are doing now, but I can't
> > support a change that is a bug waiting to bite us.  My apologies if
> > I'm interpreting your comments incorrectly and that isn't the case
> > here.
> setting the IP options may cause the packet size to grow (both iph->tot_len
> and skb->len), for example:
>
> before setting it, iph->tot_len=65535,
> after setting it, iph->tot_len=65535 + 14 (assume the IP option len is 14)
> however, tot_len is 16 bit, and can't be set to "65535 + 14".
>
> Hope the above makes it clearer.

Thanks, it does.

> This problem exists with or without this patch. Not sure how it should
> be fixed in cipso_v4 ...
>
> Not sure if we can skip the big packet, or segment/fragment the big packet
> in cipso_v4_skbuff_setattr().

We can't skip the CIPSO labeling as that would be the network packet
equivalent of not assigning a owner/group/mode to a file on the
filesystem, which is a Very Bad Thing :)

I spent a little bit of time this morning looking at the problem and I
think the right approach is two-fold: first introduce a simple check
in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
grows beyond 65535.  It's rather crude, but it's a tiny patch and
should at least ensure that the upper layers (NetLabel and SELinux)
don't send the packet with a bogus length field; it will result in
packet drops, but honestly that seems preferable to a mangled packet
which will likely be dropped at some point in the network anyway.

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 6cd3b6c559f0..f19c9beda745 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
        * that the security label is applied to the packet - we do the same
        * thing when using the socket options and it hasn't caused a problem,
        * if we need to we can always revisit this choice later */
-
       len_delta = opt_len - opt->optlen;
+       if ((skb->len + len_delta) > 65535)
+               return -E2BIG;
+
       /* if we don't ensure enough headroom we could panic on the skb_push()
        * call below so make sure we have enough, we are also "mangling" the
        * packet so we should probably do a copy-on-write call anyway */

The second step will be to add a max-length IPv4 option filled with
IPOPT_NOOP to the local sockets in the case of
netlbl_sock_setattr()/NETLBL_NLTYPE_ADDRSELECT.  In this case we would
either end up replacing the padding with a proper CIPSO option or
removing it completely in netlbl_skbuff_setattr(); in either case the
total packet length remains the same or decreases so we should be
"safe".

The forwarded packet case is still a bit of an issue, but I think the
likelihood of someone using 64k max-size IPv4 packets on the wire
*and* passing this traffic through a Linux cross-domain router with
CIPSO (re)labeling is about as close to zero as one can possibly get.
At least given the size check present in step one (patchlet above) the
packet will be safely (?) dropped on the Linux system so an admin will
have some idea where to start looking.

I've got some basic patches written for both, but I need to at least
give them a quick sanity test before posting.

--
paul-moore.com
