Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA031E007
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhBQUNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhBQUNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:13:31 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF347C061574;
        Wed, 17 Feb 2021 12:12:50 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id q77so3153699iod.2;
        Wed, 17 Feb 2021 12:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xD3xqmZLKLFl8D9bl6zOVotN7gOhOOlYP72KjDNrvlI=;
        b=CxnYjEoBwZGe65kabYHjpetsnAu2LY+1d5CVBjgl71Jx4FuCOpb+8CCYD8DVpC5GXQ
         ghlHs9NXk3yrmfq8ReMmuVjYVKMp2ybvNl3vNgG4XYvV1KGo93NCP6nuE+MI0rOxLLku
         DKbzbnX2q+K0Pm86He/e+sXYWdKTL8Lspuf8HkiOP0A4Lx0ohTjxDg9BFPGcBR2Zq4Of
         JatOWg4yUHj58X47vyBwBm9TMAIzX13TyBYsGZYdVcfVUpmSIh52XytwCUKr5AiudgJl
         2buU3sZaqL4qP5ZaLJhzLBEmTtH/lkArbIKyb5vBUsLu8cn+Rn/xhXfjDaG9VOpQizJQ
         YUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xD3xqmZLKLFl8D9bl6zOVotN7gOhOOlYP72KjDNrvlI=;
        b=YJYxmST1b3UveLQpxhEtlni3RO9GKLWPh5e2Ke/OFVN4mi4j+siso7emStQKkyexCF
         mEpnxkiKaisKr0Aylj8HC6ZWh+9p4bx594fvc5Cfh9ejv9MXlXsgMoofLauoCWFjWibn
         xSvfR6GQs7yY1+xW+Lfid3sLUa8sDwm9ObI30N+KE75k0O9aaBMVTVIhvBhIlZ3OxgLH
         6eBgxUdCBVJeT71MRMDvczDgPwjVh0TbHidWnwZvg+noqVpipLbttv09gOmvIULmOmzh
         sTsbJyWo3QE+DsNXuzwXduYGEX21H4t1F0JXtzJ+P8qZ0ekI+CO/JLfMVARxtDRLWyyV
         9Udw==
X-Gm-Message-State: AOAM531nMm2svx0cXNY/cTX7OdgzPqDIljgh5xME67XdYmi9qGwy3Br3
        jsFzpbsmtNBTigP/gNHD058=
X-Google-Smtp-Source: ABdhPJyia5iYEHFKA/xe4637mg/PzIJ5YYbLvKBeQNKo3T0NUe1KQvdl4xnth60IUlzHgbbyM0d1bw==
X-Received: by 2002:a6b:3b14:: with SMTP id i20mr702579ioa.28.1613592770253;
        Wed, 17 Feb 2021 12:12:50 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id b8sm2039978iow.44.2021.02.17.12.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:12:49 -0800 (PST)
Date:   Wed, 17 Feb 2021 12:12:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602d78bbd1218_ddd220893@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXBC49FBAf2LLANz94OFnVKoJADc9yePJBUuvMARbfq7w@mail.gmail.com>
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
 <20210216064250.38331-5-xiyou.wangcong@gmail.com>
 <602d631877e40_aed9208bc@john-XPS-13-9370.notmuch>
 <CAM_iQpXBC49FBAf2LLANz94OFnVKoJADc9yePJBUuvMARbfq7w@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 4/5] skmsg: move sk_redir from TCP_SKB_CB to
 skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Feb 17, 2021 at 10:40 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> > > @@ -802,9 +809,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
> > >                * TLS context.
> > >                */
> > >               skb->sk = psock->sk;
> > > -             tcp_skb_bpf_redirect_clear(skb);
> > > +             skb_dst_drop(skb);
> > > +             skb_bpf_redirect_clear(skb);
> >
> > Do we really need the skb_dst_drop() I thought we would have already dropped this here
> > but I've not had time to check yet.
> 
> Yes, I got some serious complaints from dst_release() when I didn't
> add skb_dst_drop().
> 
> Thanks.

OK thanks.
