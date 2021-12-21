Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680A647C50C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 18:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhLURbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 12:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhLURbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 12:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640107884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oaxIuP+AGT0eUo4EQT5o99NhD9i1dyTpvZjVc0Vc7OQ=;
        b=F9VT1Jh5tZHUYiaDjg+uSnsT1j10zsa9BAbzZutlqwutfMm8cu4vCF9mjocI1xHGpDTOEi
        WGlv5p1YhT7HSJFDETRDGXvizvo5iVGybWGYlyH/tTJpTmDV2yAq2lWrYFXWyZSgfw13Dq
        +mxA+XGrtj3G02fcwfvipGOLa+D9UlE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-PdvHZME3NJu8XLklz46l3A-1; Tue, 21 Dec 2021 12:31:23 -0500
X-MC-Unique: PdvHZME3NJu8XLklz46l3A-1
Received: by mail-qv1-f70.google.com with SMTP id fw10-20020a056214238a00b003c05d328ad2so13332143qvb.2
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 09:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oaxIuP+AGT0eUo4EQT5o99NhD9i1dyTpvZjVc0Vc7OQ=;
        b=ryOBYevJ9sJ5Hu3hy7LMviCewc9OiuGyVADnAOcn9lq45BtSPpFpgXv4Oln1PgchtA
         Wi4BKe36rn96tQWdg3v+1jKuEHWxONKkqGHOQV4YnYJhVS3/JhQSK6NsbLvq61pexksF
         8MrdCmhSQJKs3lUPURpwUcgpE3zOadaBKUcumgawcaQwI0Mv7OGgBjRRkEIbhy0IpWt1
         SFBl86S6/A/3JSDpRrU5Ca7s+wJLrpfxZ4hwgSuPNw5QKzIfWdOKH8jTfvGmc8gnuFEK
         U4XaElBcw7HDEnjHf4f382IU81yXKFvn+pVkK1AB9O1QkqZdwyUtWzpo4kWbDZwJCpWe
         P7Xw==
X-Gm-Message-State: AOAM531sBSsD1yQ/qWs4Lm947bu8yOTh8uiwEJtRL4GFHqQy4qZ+Aoox
        hTZK4dtaaAjPyjWjDoPTQrAQtpf8TPmkCkusdGBL6iBROe09MUEISIJzqXtmzpMSyCsizL9auuT
        XKZfiRGXh0cN7DAV1
X-Received: by 2002:a05:6214:c2d:: with SMTP id a13mr3574984qvd.28.1640107882839;
        Tue, 21 Dec 2021 09:31:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLWQsfeg63A/7HY/XCcu/wuoKWgDeNdVXDGdsjAktAK4PjjLNyEbN8o0AB/g+Lcr/vS7DFww==
X-Received: by 2002:a05:6214:c2d:: with SMTP id a13mr3574953qvd.28.1640107882596;
        Tue, 21 Dec 2021 09:31:22 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-225-60.dyn.eolo.it. [146.241.225.60])
        by smtp.gmail.com with ESMTPSA id h2sm14914216qkn.136.2021.12.21.09.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 09:31:22 -0800 (PST)
Message-ID: <3d6d818ff01b363ae7ec6740dc3cd3e62aa16682.camel@redhat.com>
Subject: Re: tcp: kernel BUG at net/core/skbuff.c:3574!
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ignat Korchagin <ignat@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Date:   Tue, 21 Dec 2021 18:31:19 +0100
In-Reply-To: <CALrw=nG5-Qyi8f0j6-dmkVts4viX24j755gEiUNTQDoXzXv1XQ@mail.gmail.com>
References: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
         <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com>
         <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
         <CALrw=nG5-Qyi8f0j6-dmkVts4viX24j755gEiUNTQDoXzXv1XQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 17:16 +0000, Ignat Korchagin wrote:
> On Tue, Dec 21, 2021 at 3:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Tue, 2021-12-21 at 06:16 -0800, Eric Dumazet wrote:
> > > On Tue, Dec 21, 2021 at 4:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > > > 
> > > > Hi netdev,
> > > > 
> > > > While trying to reproduce a different rare bug we're seeing in
> > > > production I've triggered below on 5.15.9 kernel and confirmed on the
> > > > latest netdev master tree:
> > > > 
> > > 
> > > Nothing comes to mind. skb_shift() has not been recently changed.
> > > 
> > > Why are you disabling TSO exactly ?
> > > 
> > > Is GRO being used on veth needed to trigger the bug ?
> > > (GRO was added recently to veth, I confess I did not review the patches)
> 
> Yes, it seems enabling GRO for veth actually enables NAPI codepaths,
> which trigger this bug (and actually another one we're investigating).
> Through trial-and-error it seems disabling TSO is more likely to
> trigger it at least in my dev environment. I'm not sure if this bug is
> somehow related to the other one we're investigating, but once we have
> a fix here I can try to verify before posting it to the mailing list.
> 
> > This is very likely my fault. I'm investigating it right now.
> 
> Thank you very much! Let me know if I can help somehow.

I'm testing the following patch. Could you please have a spin in your
testbed, too?

Thanks!

Paolo
---
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 38f6da24f460..b490448ca42c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -711,6 +711,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (unlikely(!xdp_prog)) {
+		if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {
+			struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
+
+			if (!nskb)
+				goto drop;
+			consume_skb(skb);
+			skb = nskb;
+		}
 		rcu_read_unlock();
 		goto out;
 	}



