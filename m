Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A88679313
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjAXI1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjAXI1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:27:19 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81251CA11
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:27:13 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p188so17897090yba.5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I9Nmgh8/9gO9YlhMhew0y38YfcI+lrEjEp9/FtiRBGM=;
        b=M09O0mWVM8G9LKAsx4fg/hpsoshtyrxuqI2SpNuvRf1jfVQ3aGR2z+sqznbVekg6JF
         0ZdkCCyyOwF+v4VXtpKwuSnzpcXSlQ0iBP0Q70/niMtNroMJG3pQZwhNGJs4V4V2YtJY
         NUY8StZrnKsDr3EIIzcuisEJrku98ji4X6LScKs1FSYVG5++QVstX6Kbu3fvGNm3yDJt
         JBtgYq4F9tX3vqkYCgLM+rg2FEQkuN4wjLPx11W37JAwik3qyG3rVZXPylooioEpe6ip
         OzJ863RzJcgMCE0ep1dZ0t/zlZ7JedlFC8ntyygBS7qMGqEgGrHPzOVdOKYraHD2ZJ4e
         Vksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9Nmgh8/9gO9YlhMhew0y38YfcI+lrEjEp9/FtiRBGM=;
        b=N1T5o1DUyfdFrl+bZz2wpWVCcfRL3jM8hc1uXsMmi3+RflgilpvJnsEs1zE93HKLSK
         VrSdCIlKMfX5toWDfNOwiFWBZKrn6490UYiMTmZDilGT6KvZyGbHkt+BhddkhR6f5EyX
         ruVpOkkAwvGbCnlVD5S0kO8InWuqzqRgcRwZCbbuAceQa+A1y+RLRE/bzu5GdSPrrvId
         xUpnhAIbvpewydm1VrWHbsC8sqsHDyNOudF4yuhQLlGmcvrRyOANRCBl7R+3W4OKzvOU
         0v+bjMgC5ljrYIubTt/FSLOX4pPmAKkHwrc93CE4p3xlFk/80p1tWg78q7eKRPX4oN2D
         qw0A==
X-Gm-Message-State: AFqh2kp8ux7hfb4LGYHSxAxFU0XzxTxFJDRn5PPbStYt09yzbwMAlRQB
        qXPBIfENKN27dQ5/dUUTBPBhr0oxPFasppNAVDZBjg==
X-Google-Smtp-Source: AMrXdXt3NjWurP7TP23M0OmT+L3EuZrLYCMHUa1qXBzKvnMloMJCPWMP+P1igRYP2qdCfwlAddOBgY9+N4f8M1pK1vQ=
X-Received: by 2002:a5b:948:0:b0:7ed:9f15:d71c with SMTP id
 x8-20020a5b0948000000b007ed9f15d71cmr2540384ybq.55.1674548832425; Tue, 24 Jan
 2023 00:27:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674526718.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 09:27:01 +0100
Message-ID: <CANn89iKZKgzOZRj+yp-OBG=y6Lq4VZhU+c9vno=1VXixaijMWw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 00/10] net: support ipv4 big tcp
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
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

On Tue, Jan 24, 2023 at 3:20 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This is similar to the BIG TCP patchset added by Eric for IPv6:
>
>   https://lwn.net/Articles/895398/
>
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
>
> This will work safely, as all BIG TCP packets are GSO/GRO packets and
> processed on the same host as they were created; There is no padding
> in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> packet total length; Also, before implementing the feature, all those
> places that may get iph tot_len from BIG TCP packets are taken care
> with some new APIs:
>
> Patch 1 adds some APIs for iph tot_len setting and getting, which are
> used in all these places where IPv4 BIG TCP packets may reach in Patch
> 2-8, and Patch 9 implements this feature and Patch 10 adds a selftest
> for it.
>
> Note that the similar change as in Patch 2-6 are also needed for IPv6
> BIG TCP packets, and will be addressed in another patchset.
>
> The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> and 1.5K MTU:
>
> No BIG TCP:
> for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 168          322          337          3776.49
> 143          236          277          4654.67
> 128          258          288          4772.83
> 171          229          278          4645.77
> 175          228          243          4678.93
> 149          239          279          4599.86
> 164          234          268          4606.94
> 155          276          289          4235.82
> 180          255          268          4418.95
> 168          241          249          4417.82
>

NACK again

You have not addressed my feedback.

Given the experimental nature of BIG TCP, we need separate netlink attributes,
so that we can selectively enable BIG TCP for IPV6, and not for IPV4.

Some of us do not have time to risk breaking IPV4, even if IPV4 for
our networks is less than 0.01 % of the traffic.
