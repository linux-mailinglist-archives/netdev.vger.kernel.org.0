Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4777672F72
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 04:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjASDR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 22:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjASDPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 22:15:37 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE3F5AB58
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 19:13:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id c124so890290ybb.13
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 19:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MtnTz4MNDLfYsz3YERr3qYCTmCc7P3RtDIf35VFVErk=;
        b=A4DCK9pzC32IZH4NtzpD9LiqwVfixfcWPAYaRAMcrU0pjkZTYidGRoRBb0awgPT2Kr
         vHRQ5thxbJ9Ai9aozh95O2gMWmY+lWEOjGbZJ5g2AuO9Eeq3WRj8K4qe2qpZcM6AMwHz
         02oUYg//1CEmmDp43X4cZiVESQv8foVvOwe7Y36P8aOAUty18aBSpmwOq1sycj4UwId6
         ytVs14RjvtSmocvnXeYbWoNMCGOBAXvjA4fXCMTvH/33S4wBUhLkK+0dMXVwkBe6xz4c
         xXqyUAhoWtU8xbZY292WMnCYcBAQJJmmLm4cfHM1LIGsPT/JZDtUyhd7ml0VelZvgZD9
         YwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MtnTz4MNDLfYsz3YERr3qYCTmCc7P3RtDIf35VFVErk=;
        b=y5hzcajAOrG376+BlaV4OpyCzBADNSTY0TeRx+GhP2L1i7LDiX+Bm+Bt3RGI/Hdj6V
         ZK5Loz3o4HofykT7WJTqT/K9RnSyTQ7jFdm2Fav42aisxTLx62hii7r0i1YVajvPYjRL
         q2vIra3ct9CmGjqULxTUb64LLZwdVEU+sXaChGKJypF2o4HIfY0/xNzR7bFPB9YhPKLN
         UGqjek0tdmUqL5byhNP7HTa5dtpKDL8XlPQyUb9TXWvjUlqPaHC5N5Gpulhp9Zsn/QY2
         +ueHyk9igHDHyVjq9zVQf73G8vQd3M92ZiYbwkrDgYYahyLYYT8wB37n4wxwBJCmf/xP
         y2GQ==
X-Gm-Message-State: AFqh2kp2UtokP6f+2W+7sTV3q8zToa6PjuQXIn48d6OwmdZrLADz109G
        6hb4RViHkn2AmjZ7/RFNOmts+ZO0SEu0Ey8hCoEmRA==
X-Google-Smtp-Source: AMrXdXvN66bjiWexiySIjzvm82kwrr0temoXZg7YCV2bqeNPbxOGKv3nwwytI/lNdbLrKQP4SVGl1CFJu1Pi6dCa2/s=
X-Received: by 2002:a25:9012:0:b0:7b8:a0b8:f7ec with SMTP id
 s18-20020a259012000000b007b8a0b8f7ecmr1356508ybl.36.1674098024361; Wed, 18
 Jan 2023 19:13:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
 <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
 <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com> <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
In-Reply-To: <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 04:13:32 +0100
Message-ID: <CANn89i++s3jhHqsyJT50FePT=icx3_FiYGqJNwQ73a1wt2+m+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
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
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 2:19 AM Xin Long <lucien.xin@gmail.com> wrote:

> I think that IPv6 BIG TCP has a similar problem, below is the tcpdump in
> my env (RHEL-8), and it breaks too:
>
> 19:43:59.964272 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> 19:43:59.964282 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> 19:43:59.964292 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> 19:43:59.964300 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> 19:43:59.964308 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
>

Please make sure to use a not too old tcpdump.

> it doesn't show what we want from the TCP header either.
>
> For the latest tcpdump on upstream, it can display headers well for
> IPv6 BIG TCP. But we can't expect all systems to use the tcpdump
> that supports HBH parsing.

User error. If an admin wants to diagnose TCP potential issues, it should use
a correct version.

>
> For IPv4 BIG TCP, it's just a CFLAGS change to support it in "tcpdump,"
> and 'tshark' even supports it by default.

Not with privacy _requirements_, where only the headers are captured.

I am keeping a NACK, until you make sure you do not break this
important feature.

>
> I think we should NOT go with "adjust tot_len" or "truncate packets" way,
> and it makes more sense to make it supported in "tcpdump" by default,
> just like in "tshark". I believe commit [1] was added for some problems
> they've met, we should enable it for both.
>
> [1] https://github.com/the-tcpdump-group/tcpdump/commit/c8623960f050cb81c12b31107070021f27f14b18
>
> Thanks.
