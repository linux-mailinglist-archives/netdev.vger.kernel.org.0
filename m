Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B474128744D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgJHMdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgJHMdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:33:44 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF62C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 05:33:44 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id y1so283910uac.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1HqEIIx59zT2Fnp8KY1EDEY0FsrsNtvZJ6XAa9WgS64=;
        b=S1EPyOUFMh+fXq9/+U8w+8dukDP4t1WwGJxcso8XxUkWK7xLi9L5Sckj2d0Kl0RjHG
         KyHAu4yPWqyv/gokB6pwiFi1WsCtUkeRRrYAsQZAvnAdNrRK2zQehaNDP7+zllqJ1LGQ
         iz3kUAOtwtlhbB8FQfww6CChK+LPVttdO5GV5ePnRYaZb9tSogXdnoNDGDS7oCJ4V90E
         0Y99i3aKulNG541JCbNvU3kSUP36MncfXJySkXCBzO69hH5lVQBXp/j0T3BKVl2mjwTG
         pzad1R1qT5ovOniKDfItx8Yfr0gJ4YbIFF5TnhumltVxrw9YmsxTuQ3XH8xXe8I6+sNp
         is7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1HqEIIx59zT2Fnp8KY1EDEY0FsrsNtvZJ6XAa9WgS64=;
        b=FibC0LLBLrYLOZjUvodK/jEDizUXmE8SsfhFE7FV/9AYWSZiW0yzzRR84+T762bYAk
         dEURW6sF9vBix7CtaiwA6Gtr2ZLfJSfovLeAEcjiG4UkuuyeYq/FtD0V4uaG82KH2omO
         rQDiJO29ucnfZjuqjEITpgumUISCMeu58quLuNqRvBK3/OIFSmAx87kc2QpxI39dp07t
         etBRVPTfOeIc+FAcarQy/ikBR30dS45eZQZPrtADsPodp72P98LF8Hg+w1ANN4++VojF
         lxkZi758glYHZtc0/IY2wwinnvuEzYx6auap+xq9xUHeBKztQlJ1qJpwe4/Fb9qwlvX3
         aF7Q==
X-Gm-Message-State: AOAM533zFMMH8nzfOhbjYXhLqtjxdKD9zRg4qSJwEdbBfBBfns86sJIw
        VdqhyPwtgmla1/gXnJmJbt9q5Rfv1z4=
X-Google-Smtp-Source: ABdhPJwQFdaXnmE6/jvuT13stb3JBfcvj9ePvuLYXEZUETFvb71rbHT85x84j0LBAreu5NKpistKQw==
X-Received: by 2002:ab0:36f0:: with SMTP id x16mr4360309uau.4.1602160422633;
        Thu, 08 Oct 2020 05:33:42 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id w6sm713909uan.4.2020.10.08.05.33.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 05:33:41 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id c1so1819228uap.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:33:41 -0700 (PDT)
X-Received: by 2002:ab0:7718:: with SMTP id z24mr4290139uaq.92.1602160420784;
 Thu, 08 Oct 2020 05:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208776033.798237.4028465222836713720.stgit@firesoul> <CANP3RGeU4sMjgAjXHVRc0ES9as0tG2kBUw6jRZhz6vLTTtVEVA@mail.gmail.com>
 <20201008130632.0c407bad@carbon>
In-Reply-To: <20201008130632.0c407bad@carbon>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 08:33:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfXt3_OZD3DoO46ndkBs6y7FCQk3QwaeLkh0QYyLhLhZA@mail.gmail.com>
Message-ID: <CA+FuTSfXt3_OZD3DoO46ndkBs6y7FCQk3QwaeLkh0QYyLhLhZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 1/6] bpf: Remove MTU check in __bpf_skb_max_len
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 7:06 AM Jesper Dangaard Brouer <brouer@redhat.com> w=
rote:
>
> On Wed, 7 Oct 2020 16:46:10 -0700
> Maciej =C5=BBenczykowski <maze@google.com> wrote:
>
> > >  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> > >  {
> > > -       return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > > -                         SKB_MAX_ALLOC;
> > > +       return IP_MAX_MTU;
> > >  }
> >
> > Shouldn't we just delete this helper instead and replace call sites?
>
> It does seem wrong to pass argument skb into this function, as it is
> no-longer used...
>
> Guess I can simply replace __bpf_skb_max_len with IP_MAX_MTU.

Should that be IP6_MAX_MTU, which is larger than IP_MAX_MTU?
