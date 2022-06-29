Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB8F55F818
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiF2HD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiF2HDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:03:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7D13BBCE;
        Wed, 29 Jun 2022 00:00:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so18432197pjr.0;
        Wed, 29 Jun 2022 00:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FKirbHGv5NE/OGlSscdI5eG/5EMr2lgsHSJcWhi887Q=;
        b=goBcePxgKcTn948PlfCdpZwfDfETzd2hGB4Pi1rtLCrg3LyScUNbU/6527qUqly074
         eWl9f+RNsQMjv+r9OoFM8PlJPNAjOHZT2zelvBLwz2ov6/865bFPv6nsCbo02Wy6rg2q
         FkDUdK9oV/ky9ZcHCSmd6O2fizd++Py6bmLWAegUYMgFBwEWKLcuR6pLK5IV9R0/78qx
         cKtWJEe2V9ViWbLJgAfQCW2/ohnroJxOJpLPvnomctSQbqwX3kG8r3AHaYm9QjVKz153
         hWZ755dA2/7Hx9IqIKrgQzZ0khNcb9jZZDqryk55XTmjxWrG7addv6AQQWtLQx7RCVA8
         ahCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FKirbHGv5NE/OGlSscdI5eG/5EMr2lgsHSJcWhi887Q=;
        b=KIRagy8K1MtFmewiLeAf6fU3VHNLdCSYdEUyDi2WjZ0Fr++INPL86tPaG+p6b+08lJ
         Bpf7AlohLwAcCYC9HHZNp33Zv1oopc9OhvpHvSYc95MsDK4M2XreWu4AcchYTZlQYZJV
         WImQkO7bsAKBa3y+FwqWvArC0goa6N9dYT2TQ0avUvDfcr5chy/OYHhL6uFjCj54YnKz
         VcXvuUtSVujI4Ptt/2TN7BgXKYINMX4PVz14CS+iTj6+jlsZOtRd3G3F/Sz4nuIFNMOd
         hBjoMhXx0ma+DSH7Ryj8lCkn69HoKNPdo+z0hbPYWPKxrc6IWshjHTU+dF3HczWxW1Jo
         +xjw==
X-Gm-Message-State: AJIora8DDqDe3rH9ElrtFj2z+4UOAVafnK+v99bcBlq6Z0YKTy9rfrwD
        8PV5KfbbjslOor7hzPxaTl4=
X-Google-Smtp-Source: AGRyM1tT72CXyzhWfLUwxOjz4tkjA09Aw1cSPowmdrMLA5o7vMNq1tJD9r9rvKq73Kuv/1CSzYk86Q==
X-Received: by 2002:a17:902:8690:b0:16a:61e9:b9ca with SMTP id g16-20020a170902869000b0016a61e9b9camr7690250plo.126.1656486026094;
        Wed, 29 Jun 2022 00:00:26 -0700 (PDT)
Received: from localhost ([98.97.119.237])
        by smtp.gmail.com with ESMTPSA id jf17-20020a17090b175100b001ec86a0490csm1141594pjb.32.2022.06.29.00.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 00:00:25 -0700 (PDT)
Date:   Wed, 29 Jun 2022 00:00:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Julien Salleyron <julien.salleyron@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Marc Vertes <mvertes@free.fr>
Message-ID: <62bbf87f16223_2181420853@john.notmuch>
In-Reply-To: <20220628103424.5330e046@kernel.org>
References: <20220628152505.298790-1-julien.salleyron@gmail.com>
 <20220628103424.5330e046@kernel.org>
Subject: Re: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
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

Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 17:25:05 +0200 Julien Salleyron wrote:
> > This patch allows to use KTLS on a socket where we apply sk_redirect using a BPF
> > verdict program.
> > 

You'll also need a signed-off-by.

> > Without this patch, we see that the data received after the redirection are
> > decrypted but with an incorrect offset and length. It seems to us that the
> > offset and length are correct in the stream-parser data, but finally not applied
> > in the skb. We have simply applied those values to the skb.
> > 
> > In the case of regular sockets, we saw a big performance improvement from
> > applying redirect. This is not the case now with KTLS, may be related to the
> > following point.
> 
> It's because kTLS does a very expensive reallocation and copy for the
> non-zerocopy case (which currently means all of TLS 1.3). I have
> code almost ready to fix that (just needs to be reshuffled into
> upstreamable patches). Brings us up from 5.9 Gbps to 8.4 Gbps per CPU
> on my test box with 16k records. Probably much more than that with
> smaller records.

Also on my list open-ssl support is lacking ktls support for both
direction in tls1.3 iirc. We have a couple test workloads pinned on
1.2 for example which really isn't great.

> 
> > It is still necessary to perform a read operation (never triggered) from user
> > space despite the redirection. It makes no sense, since this read operation is
> > not necessary on regular sockets without KTLS.
> > 
> > We do not see how to fix this problem without a change of architecture, for
> > example by performing TLS decrypt directly inside the BPF verdict program.
> > 
> > An example program can be found at
> > https://github.com/juliens/ktls-bpf_redirect-example/
> > 
> > Co-authored-by: Marc Vertes <mvertes@free.fr>
> > ---
> >  net/tls/tls_sw.c                           | 6 ++++++
> >  tools/testing/selftests/bpf/test_sockmap.c | 8 +++-----
> >  2 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 0513f82b8537..a409f8a251db 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -1839,8 +1839,14 @@ int tls_sw_recvmsg(struct sock *sk,
> >  			if (bpf_strp_enabled) {
> >  				/* BPF may try to queue the skb */
> >  				__skb_unlink(skb, &ctx->rx_list);
> > +
> >  				err = sk_psock_tls_strp_read(psock, skb);
> > +
> >  				if (err != __SK_PASS) {
> > +                    if (err == __SK_REDIRECT) {
> > +                        skb->data += rxm->offset;
> > +                        skb->len = rxm->full_len;
> > +                    }
> 
> IDK what this is trying to do but I certainly depends on the fact 
> we run skb_cow_data() and is not "generally correct" :S

Ah also we are not handling partially consumed correctly either.
Seems we might pop off the skb even when we need to continue;

Maybe look at how skb_copy_datagram_msg() goes below because it
fixes the skb copy up with the rxm->offset. But, also we need to
do this repair before sk_psock_tls_strp_read I think so that
the BPF program reads the correct data in all cases? I guess
your sample program (and selftests for that matter) just did
the redirect without reading the data?

Thanks!
