Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE7295B76
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509402AbgJVJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509377AbgJVJMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:12:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E5CC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 02:12:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m3so651707pjf.4
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 02:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=68Id1Td7qZiXpCfHbw0wdh+d+tIk3pr9bl0i80PQwK4=;
        b=UKGk+L8HZXhDadGcbn0A5xC+Tkz1Y7yCiDstWUJmYrfCMD1doAlcn92AaCueGovorb
         3kRftO1gRLvO9l2vDkw1faSN+wzkJrEGUIZxOK8csFj0zlUYLy8ZWnOS6IVZbGw4Woxs
         Eu43dNxMohY8WRRuRa7Y1nexhHR86N4eZhX6JPA+za0e+MpvhBcntp04mr9MnXJG0tc5
         UNGNOFSLdJQMSM5y6y6W/eRvAsxLA8gSKYRQlKZpMbDmKLPKzjzIMj4Xe0F0TC0uFHQe
         YOiazVtEZ0TvSsnEnMzZmeGTXcPphKvqdXfiuNG7g9EzJZ0xpmH9CwpZq+9hWWQHUVJB
         xuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=68Id1Td7qZiXpCfHbw0wdh+d+tIk3pr9bl0i80PQwK4=;
        b=PA+KHfyo4kZ6AWkHQga4RugqW8xgF9tbeUnkxiPnqMWzfzJJPEk3PurMbJaG+Aa4+n
         hd4YlKm+hQ8Xat0lVd+Op15tE5sTKC4BbY1u3yDL56+VpKWfIsv+QaAiQcVoatWLAjl1
         N7g8ARb6tMvWaipLol9JAHdR2nJUSkhlSKP9IoJBYgmNN3d3UEGaZIjDGWFe/LIWh0lL
         WmfIAuoo5cq04ads5/F0IfCb8yTrDtHEOT6+mIz+vmZNtCFVoj2ixqfHUy8KHGjGP7FI
         sToYNSmt2d3BCt3dfqPw5BE6G3I1F1Ftd5bzvkHm/qgjHcQ8J3gatijRlGI8+sQzG1AH
         WJYw==
X-Gm-Message-State: AOAM530IwG8GKJRAIpYsfRA3wUF16WNSoy7GgDuIhUoay5v4JW/sbSy+
        BmE2ooHa08NA0n81ti0NL6s=
X-Google-Smtp-Source: ABdhPJzBaLYd8Y73eza4TnF0hSiUjJZB9h/lcSxajvKtMoGPRU4qjZZDK44/AcV3xamnbqn7QqGvIA==
X-Received: by 2002:a17:902:bcc9:b029:d3:c7de:5cfc with SMTP id o9-20020a170902bcc9b02900d3c7de5cfcmr1734213pls.19.1603357935867;
        Thu, 22 Oct 2020 02:12:15 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 38sm1429126pgx.43.2020.10.22.02.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 02:12:15 -0700 (PDT)
Date:   Thu, 22 Oct 2020 17:12:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv2 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201022091205.GN2531@dhcp-12-153.nay.redhat.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201021042005.736568-1-liuhangbin@gmail.com>
 <20201021042005.736568-3-liuhangbin@gmail.com>
 <CA+FuTSdCG4yVDb85M=fChfrkU9=F7j88TJujJy_y0pv-Ks_MwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdCG4yVDb85M=fChfrkU9=F7j88TJujJy_y0pv-Ks_MwQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thanks for the comments, see replies below.

On Wed, Oct 21, 2020 at 10:02:55AM -0400, Willem de Bruijn wrote:
> > +       is_frag = (ipv6_find_hdr(skb, &offs, NEXTHDR_FRAGMENT, NULL, NULL) == NEXTHDR_FRAGMENT);
> > +
> 
> ipv6_skip_exthdr already walks all headers. Should we not already see
> frag_off != 0 if skipped over a fragment header? Analogous to the test
> in ipv6_frag_rcv below.

Ah, yes, I forgot we can use this check.

> > +       nexthdr = hdr->nexthdr;
> > +       offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > +       if (offset >= 0 && frag_off == htons(IP6_MF) && (offset + 1) > skb->len) {
> 
> Offset +1 does not fully test "all headers through an upper layer
> header". You note the caveat in your commit message. Perhaps for the
> small list of common protocols at least use a length derived from
> nexthdr?

Do you mean check the header like

if (nexthdr == IPPROTO_ICMPV6)
	offset = offset + seizeof(struct icmp6hdr);
else if (nexthdr == ...)
	offset = ...
else
	offset += 1;

if (frag_off == htons(IP6_MF) && offset > skb->len) {
	icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
	return -1;
}

Another questions is how to define the list, does TCP/UDP/SCTP/ICMPv6 enough?

Thanks
Hangbin
