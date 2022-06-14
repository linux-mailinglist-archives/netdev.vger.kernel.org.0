Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A954BAFD
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245256AbiFNTz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiFNTz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:55:56 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F13614F;
        Tue, 14 Jun 2022 12:55:55 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y17so7348598ilj.11;
        Tue, 14 Jun 2022 12:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GswxPjj5LlRJS8/1xA3S8U0VTLxjsWU69fZdjcSjxNc=;
        b=qPvCwe+42tFJZm9piIdnp95hZr1vFiUekb//DXTUvWx5+kGlEZBNUnEdHgErDlM5lx
         jor9EB6Rc9OfbpCJqHjJ/B77PUA9fOsZ3fHZPiA8/JZaGS1PAur9aXBARedIz4iDcKcw
         mlHd5wYVxJjPhOgyURLw5M/caSdp5DzInIZTEqXAWrwMUrCjpNeoZYoBh3tzll8Emskf
         QSsBNiabfh9e33xArMY93b6Ub4V30WgTCL61Se2moNFWtRFGFs4ulkG8WciYggms4hoD
         bzjgmadk/kv80olhyiRjCeCTApEAFL2xcMv7mZIhTFKNZAaMme6pU0BSZg2uk2AFD6v5
         hJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GswxPjj5LlRJS8/1xA3S8U0VTLxjsWU69fZdjcSjxNc=;
        b=PdrPNUkCl8rhBwAY9MItro29mRWm3i6MRzhOkYrFc2gjTLp3SohqcdEp2pBn2Oo8Xw
         tZCemsp+Z+0bY5iv033vwNpGL/7gLHGZrg8qKlhvfV3FXWNbqLZF4gwsKoHBL9DUq5Qf
         O/ylrH0vJsptxoC7gfqVhxNMItLabNZ73wTSZYM01gopIbS1lj9Q6R7tJnAXMNDh93CC
         BY0dPUjYRrkzGRVloLXvdZBNUYJYObZZ0Z52+M9XmMjgSvilGeHm+1ZYivsxUj1VTL/h
         xlVaVkW+l54GNevR9OwApeJ/tmOJcI67achfrVR2+//64nvkZpoQ17XZvc+AvyBn7Q3a
         gbFg==
X-Gm-Message-State: AJIora83qZu7OcV/buhSurAhqRB9h59eT9qiWfO3Mt23V2NOCOG8Yg2j
        euvwkGa6Pzw/+hpYatqBtHc=
X-Google-Smtp-Source: AGRyM1suQcVJvpIHswCqg4IOJM3LnlzOerWQcV9DeQ4FCBhvromABH0V+RuImflBp3AO1HdF79dtiA==
X-Received: by 2002:a92:c94e:0:b0:2d3:be50:3e2f with SMTP id i14-20020a92c94e000000b002d3be503e2fmr4072343ilq.143.1655236554292;
        Tue, 14 Jun 2022 12:55:54 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id h5-20020a056602130500b00668d3772a81sm5741342iov.30.2022.06.14.12.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 12:55:53 -0700 (PDT)
Date:   Tue, 14 Jun 2022 12:55:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <62a8e7c340baf_2f2a0208a2@john.notmuch>
In-Reply-To: <CAM_iQpVRhBEGGtO+NDppqxDR0jf6W4+OJyvELx+Sxx66LxH13g@mail.gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
 <20220602012105.58853-2-xiyou.wangcong@gmail.com>
 <62a20ceaba3d4_b28ac2082c@john.notmuch>
 <CAM_iQpWN-PidFerX+2jdKNaNpx4wTVRbp+gGDow=1qKx12i4qA@mail.gmail.com>
 <62a2461c2688b_bb7f820876@john.notmuch>
 <CAM_iQpVRhBEGGtO+NDppqxDR0jf6W4+OJyvELx+Sxx66LxH13g@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Jun 9, 2022 at 12:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > Considering, the other case where we do kfree_skb when consume_skb()
> > is correct. We have logic in the Cilium tracing tools (tetragon) to
> > trace kfree_skb's and count them. So in the good case here
> > we end up tripping that logic even though its expected.
> >
> > The question is which is better noisy kfree_skb even when
> > expected or missing kfree_skb on the drops. I'm leaning
> > to consume_skb() is safer instead of noisy kfree_skb().
> 
> Oh, sure. As long as we all know neither of them is accurate,
> I am 100% fine with changing it to consume_skb() to reduce the noise
> for you.

Thanks that would be great.

> 
> Meanwhile, let me think about how to make it accurate, if possible at
> all. But clearly this deserves a separate patch.

Yep should be ok. We set the error code in desc->error in the verdict
recv handler maybe tracking through this.

> 
> Thanks.


