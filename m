Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1CA577795
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGQRq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQRqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 13:46:55 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F517DF89;
        Sun, 17 Jul 2022 10:46:54 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id r12so7369144qvm.3;
        Sun, 17 Jul 2022 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uISDuglJUEP8Tg9eISZfCi43e5GRXXZx7JtPVHWEDuw=;
        b=Hz00FMLb+3m8GoLx75yn2Bywr9Fy+w2SOR2U1gKks+4nApkWPmlmN0Geq1Wi8+eY8z
         dM51mu9f2AxGGaj7H4QOHN2D/Zu/l/CfZG3AY3usWfpMqbkuMEoGUB7XGOEhSCU1qw9q
         Lv9oycpD4D7aqPJQCs417oAMfc9NCAiJDXrwu91RRXPM/WT16VA3BMbiKPXe5DaS2PYw
         YheDutCdA/mf9Hlj6h+ZmLdUw1P4lSJqYiyE670tTmS0iQs0GipardPmLBfij5+qvrcc
         7B3uUZIyTFk1nPubSAtAyLk58tTFnG0rK84mfh8IxqwDaVgZU2LdeXEcNAnZF9BP8F7p
         DQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uISDuglJUEP8Tg9eISZfCi43e5GRXXZx7JtPVHWEDuw=;
        b=mM6sqxHHI/qm7YtH8Oc0EmE7aRV/MUP3vCgCtN8FdWBZjMHqO4AeM/S3pqqMywDu4u
         OXb0kXqKEjuXN7GFAkG0OAamu7Q5xsfYliVKcah8cSF7XqkBaXsqljG8MnLPNDvChah/
         HwPf/6wHIFU76MWKflpteWHl6fAd3qooFcrpcve0u5L1OZrKQyNiuSVCHdyKyIHzRvVV
         zUub3wWk/wACoZ043SGJyKMA6/BHmI1v5ymF19MEZ4nc2x0+eMh/B71NcIqR177+oT/2
         oh4jIJSBz2X7Pi9LQZg3mOHz66hO0ZZeNbK+tuMloj7wH0KAkGp5rz0ZEocSqNFAI79Z
         E7rA==
X-Gm-Message-State: AJIora/deXH2M+xWfUabJPQyTJ0tbvIXR8rX+WmDEizPb2PuA7bmE2kC
        Hyok2qCoaajmnZep5tdvikW7P7GQYMzsNQ==
X-Google-Smtp-Source: AGRyM1tUwqjWB2uToaP44zSNVtg5NkHY3sFVAq+Me0/qjW34Yhslkc1mi15DusAL53QM1J9xSbXTsA==
X-Received: by 2002:ad4:5949:0:b0:473:75ec:9f6e with SMTP id eo9-20020ad45949000000b0047375ec9f6emr18416557qvb.17.1658080013304;
        Sun, 17 Jul 2022 10:46:53 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:db10:283b:b16c:9691])
        by smtp.gmail.com with ESMTPSA id s10-20020a05620a254a00b006a6d74f8fc9sm10792781qko.127.2022.07.17.10.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 10:46:52 -0700 (PDT)
Date:   Sun, 17 Jul 2022 10:46:51 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
Message-ID: <YtRLC5ILXZOre8D7@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 01:14:08PM +0200, Toke Høiland-Jørgensen wrote:
> Packet forwarding is an important use case for XDP, which offers
> significant performance improvements compared to forwarding using the
> regular networking stack. However, XDP currently offers no mechanism to
> delay, queue or schedule packets, which limits the practical uses for
> XDP-based forwarding to those where the capacity of input and output links
> always match each other (i.e., no rate transitions or many-to-one
> forwarding). It also prevents an XDP-based router from doing any kind of
> traffic shaping or reordering to enforce policy.
> 

Sorry for forgetting to respond to your email to my patchset.

The most important question from you is actually why I give up on PIFO.
Actually its limitation is already in its name, its name Push In First
Out already says clearly that it only allows to dequeue the first one.
Still confusing?

You can take a look at your pifo_map_pop_elem(), which is the
implementation for bpf_map_pop_elem(), which is:

       long bpf_map_pop_elem(struct bpf_map *map, void *value)

Clearly, there is no even 'key' in its parameter list. If you just
compare it to mine:

	BPF_CALL_2(bpf_skb_map_pop, struct bpf_map *, map, u64, key)

Is their difference now 100% clear? :)

The next question is why this is important (actually it is the most
important)? Because we (I mean for eBPF Qdisc users, not sure about you)
want the programmability, which I have been emphasizing since V1...

Clearly it is already too late to fix bpf_map_pop_elem(), we don't want
to repeat that mistake again.

More importantly, the latter can easily implement the former, as shown below:

bpf_stack_for_min; // Just BPF_MAP_TYPE_STACK

push(map, key, value)
{
  bpf_stack_for_min.push(min(key, bpf_stack_for_min.top()));
  // Insert key value pair here
}

pop_the_first(map, value)
{
   val = pop_any(map, bpf_stack_for_min.top());
   *value = val;
   bpf_stack_for_min.pop();
}


BTW, what is _your_ use case for skb map and user-space PIFO map? I am
sure you have uses case for XDP, it is unclear what you have for other
cases. Please don't piggy back use cases you don't have, we all have to
justify all use cases. :)

Thanks.
