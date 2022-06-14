Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357CA54B77E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiFNRTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiFNRTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:19:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7272A2AC79;
        Tue, 14 Jun 2022 10:19:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f9so8330407plg.0;
        Tue, 14 Jun 2022 10:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UOK+MIcLlxLZp+N0kSaJi4QDys+wrXHZ5q2Q7igmhhM=;
        b=dgzbVnGEUFM7dcKYRA0BgmyU+xoHAWM9g3GPw+WoKw8vrIZL1Zo5iE9oy2lwJoyFTv
         L4ngI88772kh6VuMv1LtMnDUDQtFie1a7ScswmQBc9zxKxBL7cDiFXECGEk6TUIUmVsB
         kwA+qrV0lfI8UYuNrkzpaGQBebwiOnNEpG/H89kz6M9d1TYP6cgT6e0mckWca+SQP9rF
         1D/YD7Xa8CEZAOVJJvxJZ7b47WdQANciXGB2L6pK5Az7PdvkNNIl81Y0naE3Gt0MX/vS
         wO1ww8NLApe71A2P3E3f/NBb4Ch6XXI8L2xaipH5FgQ5r0ACtORL0DNFmY94ADWHM1bW
         ek1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UOK+MIcLlxLZp+N0kSaJi4QDys+wrXHZ5q2Q7igmhhM=;
        b=bzAl82IPxUTLuDLgInDZ55x74bEE8grclwp+XYrIobKCVpxnJAD1pB1iJYdVUYNOwW
         G7U2vyoBkPQYCn6C4C/WKQXzhFhlOhjjauCaFVI3t8z2hWTRh3dTGHB5Vbdn7jzmj0cu
         k2PrB2hMGmVuNmz+B9WhuW5k1ty+DqO6as1FkByRgX9abUUSKy8QWUPrMKltGuRG8cxF
         3wrxn7jM8GzKxzdsaRuiI8DSFIG1hUCu4ZRBGaZf7+54YZALrhf7yVUtWS6xI0InGGBu
         623N0oUCEsBHS7tmYBXCiBXfZDmSc1fQn0JwKcQ10Wgj5LFLhGnCwwn+e5qAMZxWHp1V
         DSDQ==
X-Gm-Message-State: AJIora8MzM1AhFzBvGKqr+mAJ58R+WGIAPEbtmgo7AMy3UHSjFomSve2
        kHaQ6rlWWu9R+zlHYo4/Q3IPIByVD1IHAPMehVA=
X-Google-Smtp-Source: ABdhPJwzivCPKCJpCs4ti5TvI5TpsL99ROIjZdcEuZlYbn9kSkp4F3nCw/3AYOp238GAILv6hx1DObU4dFGulz8SMuM=
X-Received: by 2002:a17:902:d509:b0:167:6ed8:af9e with SMTP id
 b9-20020a170902d50900b001676ed8af9emr5290063plg.140.1655227180939; Tue, 14
 Jun 2022 10:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
 <20220602012105.58853-2-xiyou.wangcong@gmail.com> <62a20ceaba3d4_b28ac2082c@john.notmuch>
 <CAM_iQpWN-PidFerX+2jdKNaNpx4wTVRbp+gGDow=1qKx12i4qA@mail.gmail.com> <62a2461c2688b_bb7f820876@john.notmuch>
In-Reply-To: <62a2461c2688b_bb7f820876@john.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 14 Jun 2022 10:19:29 -0700
Message-ID: <CAM_iQpVRhBEGGtO+NDppqxDR0jf6W4+OJyvELx+Sxx66LxH13g@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 12:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
> Considering, the other case where we do kfree_skb when consume_skb()
> is correct. We have logic in the Cilium tracing tools (tetragon) to
> trace kfree_skb's and count them. So in the good case here
> we end up tripping that logic even though its expected.
>
> The question is which is better noisy kfree_skb even when
> expected or missing kfree_skb on the drops. I'm leaning
> to consume_skb() is safer instead of noisy kfree_skb().

Oh, sure. As long as we all know neither of them is accurate,
I am 100% fine with changing it to consume_skb() to reduce the noise
for you.

Meanwhile, let me think about how to make it accurate, if possible at
all. But clearly this deserves a separate patch.

Thanks.
