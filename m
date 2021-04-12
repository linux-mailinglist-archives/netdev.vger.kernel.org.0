Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64635D145
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244872AbhDLTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbhDLTlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:41:07 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909ECC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:40:49 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e14so756352ils.12
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=b6a5rhgCslcbxY2GXCcPK6wl9sJ6rmGVxfXHW5j+wnI=;
        b=VXBxTjO7rwwUc3p5jtb74eTxDks2amw27HTtUQtHMZnCtCNe1wdBo2ow1womPjviW+
         bxT2e9bnfka2opwlvHyK+NhB+FElMMF0JPMNP8xbyp5/MhnysKavgRkfFsj99Fd3evu0
         Pf7dFehZHorbRovO1oARRxUGme3gUGAPzbA3buhAoTnd05xlkrNK64lH9Fm86/FFmcgh
         irxsPNk+l5yL0TaapgyPVDnrcZ66uKTeIKimUCvwjeTqYSOtFV3tX8IDr6L9acyHpKsw
         9GPH6qVm4NmKgSrwZMH0ivPuxUlbDQ+q5gme4p8RJjceonvVNlAFZAhgGbTet+uGPkFt
         uoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b6a5rhgCslcbxY2GXCcPK6wl9sJ6rmGVxfXHW5j+wnI=;
        b=HF5JpYc7Ow3/smx1yIFMCPPeumuyZ4vKrCmW70MfRbsf9kxQOIcmxUM7eCNiwZ50ZT
         IbZRMrQZa6GutNo1rnNM0sXU5QW5FkkO97hOXCqE648LeQ9/NxUK9qzqo8Z9xYWZA0WB
         PHC0scV1G/n/fD3bYoOzalqDA+OZdLpP6p/jGfecOqMVoCXHgm2KzQXCDiaRihPFj/jZ
         6P1w/DFKHLMlIW8KDMNZByzbfxsMQzr87l+EIWKUTvoAzP82utgqgjeITvw2VvF133gJ
         Eypy80X1mVCyTrx+nGdS2isyNJgWDteL1XVGjLPwOUdN7IqoVXs/J6k6OlL0zbFg9/Jp
         6cBw==
X-Gm-Message-State: AOAM533qXhw25/ruc7keErc2RMc5opsn1+IjDWbof7FF1NPFHcLATYaM
        R2/3INmsjVoPP8R+P15Yn2Y=
X-Google-Smtp-Source: ABdhPJwfy2mdUrpC8QGapJkStkihFc2I6Vld7tdJDC0R13QnXM1/L8vPlki8bb9HIXagJ8z8RgzdPA==
X-Received: by 2002:a05:6e02:15c7:: with SMTP id q7mr25042300ilu.228.1618256449101;
        Mon, 12 Apr 2021 12:40:49 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id x5sm3061640ilu.24.2021.04.12.12.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 12:40:48 -0700 (PDT)
Message-ID: <f969d15083f8f7b7ba9ef001505ad2e16b0c2fdd.camel@gmail.com>
Subject: Re: [PATCH net-next] icmp: pass RFC 8335 reply messages to ping_rcv
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 12 Apr 2021 14:40:48 -0500
In-Reply-To: <CA+FuTSdMpMm9nwFP2u7KDeNUfXXfmQBGMmPfE-MBJTrGs-8stA@mail.gmail.com>
References: <20210412190845.4406-1-andreas.a.roeseler@gmail.com>
         <CA+FuTSdMpMm9nwFP2u7KDeNUfXXfmQBGMmPfE-MBJTrGs-8stA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-12 at 15:28 -0400, Willem de Bruijn wrote:
> On Mon, Apr 12, 2021 at 3:09 PM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
> > 
> > The current icmp_rcv function drops all unknown ICMP types,
> > including
> > ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply
> > messages, we have
> > to pass these packets to the ping_rcv function, which does not do
> > any
> > other filtering and passes the packet to the designated socket.
> > 
> > Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the
> > ping_rcv
> > handler instead of discarding the packet.
> > 
> > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > ---
> >  net/ipv4/icmp.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > index 76990e13a2f9..8bd988fbcb31 100644
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -1196,6 +1196,11 @@ int icmp_rcv(struct sk_buff *skb)
> >                 goto success_check;
> >         }
> > 
> > +       if (icmph->type == ICMP_EXT_ECHOREPLY) {
> > +               success = ping_rcv(skb);
> > +               goto success_check;
> > +       }
> > +
> 
> Do you need the same for ICMPV6_EXT_ECHO_REPLY ?

Yes, but this should be handled in icmpv6_rcv in net/ipv6/icmp.c and
we're thinking of including all icmpv6 support for RFC 8335 (replying
and parsing replies) in a separate patch.


