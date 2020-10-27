Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6130129A895
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896615AbgJ0J6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:58:43 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36770 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410243AbgJ0J5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:57:24 -0400
Received: by mail-pj1-f68.google.com with SMTP id d22so486468pjz.1
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 02:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CKmiwTaBXMW3QfiozKhoxZUlnI4rlYK7FDU18S0YNLg=;
        b=GNCZ2HZHWwGNy8ivm5Z+lyopOY5v+dpmpNZq++NPPQQz4M8eyhR6EWb5xoo7Jsgn8q
         PSP9RWdagDJ1oPofytp1JUr+T+fDkUTY5wC318+uxiZHzyOeeNSE2vT9cr+UAH3len4P
         HfxZIVLSjYJhQYmW7+R6z7EkSVAO5/yIok66uuLCqBmNKouRWHznQjx6ufcBVXh9PMaE
         k351o1BUS3wBoBSG+Pi279ElnPMgoJuHGAiQbORCvlkPNlet1ht8rhXSIcC7g87vCCbo
         2+mN81w9tNrIKwZ7VyL2tP8e3I2bDyHa8y+CojG0X1VC5LImv4bqhIBHEjT9g1mBw7XD
         ufOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CKmiwTaBXMW3QfiozKhoxZUlnI4rlYK7FDU18S0YNLg=;
        b=UPkshw9PMyyiK3YR8QSuF7YPZwL0AMIuSgw6Xv8WEvy0C2LL6nsyF8scPGuJRAjl3G
         wlgTmSrwvLqgMvTbXVyMpdLFJ8qfmjJ5hUY9IKyobpxiKudDg0CcuUVXgAi7El+3wqc9
         tbmPnY0uAQcIblBu8warVtb4I+oGdw5bX0JuncDuuEADMJt7CM2q4OhyO1wvGELovrcB
         FBaysrGTr0YjZ9f5aTyDB06iCZr9c4y1h6ldOlYp75uOBd1EuPcmMA4kSmNj34Fs0z1w
         D8CHztHQ/XP7xf28jo9WzPqy4Pi+yXAiGpRt+Ygbtzby9zdRkQAx7G1L/NaOQkKnDV2V
         XCvw==
X-Gm-Message-State: AOAM533ifcONbxs+79pl8lS1+VrI875HZzkCMWZMbOS05g0QXhYze9jd
        parDEHKlMeWYKWRhPdswhHk=
X-Google-Smtp-Source: ABdhPJzZyNlx5mV9tuNoY3p7T4VbN2SkFHYhf0XufbiP+l9lyVpfyyLz/5C8Nmo/cc/6QIH0Xoqp9g==
X-Received: by 2002:a17:902:6b09:b029:d3:ec36:35fc with SMTP id o9-20020a1709026b09b02900d3ec3635fcmr1784409plk.4.1603792643819;
        Tue, 27 Oct 2020 02:57:23 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g17sm1571703pfu.130.2020.10.27.02.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 02:57:23 -0700 (PDT)
Date:   Tue, 27 Oct 2020 17:57:12 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Georg Kohmann (geokohma)" <geokohma@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027022833.3697522-3-liuhangbin@gmail.com>
 <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 07:57:06AM +0000, Georg Kohmann (geokohma) wrote:
> > +	/* RFC 8200, Section 4.5 Fragment Header:
> > +	 * If the first fragment does not include all headers through an
> > +	 * Upper-Layer header, then that fragment should be discarded and
> > +	 * an ICMP Parameter Problem, Code 3, message should be sent to
> > +	 * the source of the fragment, with the Pointer field set to zero.
> > +	 */
> > +	nexthdr = hdr->nexthdr;
> > +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > +	if (offset >= 0) {
> > +		/* Check some common protocols' header */
> > +		if (nexthdr == IPPROTO_TCP)
> > +			offset += sizeof(struct tcphdr);
> > +		else if (nexthdr == IPPROTO_UDP)
> > +			offset += sizeof(struct udphdr);
> > +		else if (nexthdr == IPPROTO_ICMPV6)
> > +			offset += sizeof(struct icmp6hdr);
> > +		else
> > +			offset += 1;
> > +
> > +		if (frag_off == htons(ip6_mf) && offset > skb->len) {
> 
> This do not catch atomic fragments (fragmented packet with only one fragment). frag_off also contains two reserved bits (both 0) that might change in the future.

Thanks, I also didn't aware this scenario.

> I suggest you only check that the offset is 0:
> frag_off & htons(IP6_OFFSET)

This will match all other fragment packets. RFC request we reply ICMP for the
first fragment packet, Do you mean

if (!frag_off & htons(IP6_OFFSET) && offset > skb->len)

Thanks
Hangbin
