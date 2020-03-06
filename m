Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5C17C28A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 17:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 11:06:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39232 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCFQGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 11:06:46 -0500
Received: by mail-pf1-f193.google.com with SMTP id w65so774310pfb.6;
        Fri, 06 Mar 2020 08:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FoB8pbaMTn7xOtcRI5SxHt5Alps13ndzQ42kdvedz7Y=;
        b=ihzpSXp2nCZ8RrF30KFh4yW5xSeSG3hoJhPmuoePt+3ipzI1vyh/vWyQLcWb7vsIIY
         C7pFSvP6yTMHaCU7m0hbQ0uLx4JugMKs4qE3BaXhPM874Nj93dVVLzFYwjXU1BZbHufr
         B23JdRbd5mf/iIM7R/XQK6VTl9MbiWtPqaJm7F5lhppOL8qKe1GzTiMBAPLHspsztuAK
         A0/n/DUaeYk/onkr296AhmOvWCblAIajsboCBbUlfW2Cluwqbu+suUSau3LeIavZ2SFp
         FlGDkTNs08xzTwwGE3nu2Ynb8eb/19kOLEruTbHxhQOFKlS+M4RbbIHaCFdN4YzXWh/J
         25ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FoB8pbaMTn7xOtcRI5SxHt5Alps13ndzQ42kdvedz7Y=;
        b=otcSRce0WeUg0nFwGpyl2wEWDkJDplPShcwd01o2jZp9wBgGLg+qQ0Yku+neoniVxQ
         6xkG30IUXlTtPn985BM/pZAdYKSYAZHZp44bqRLCYnUL0jIBCi9JtSGmsskj/ABxqww5
         M6/cFLsPxJyrGYKV53BnVTUYlq/RdfEYruse1yo+/rJjF4SHu816R+5FgwQDs4zsoSIp
         RxY7VO/Ug3r4DRhi4HT5MvFwoRKHSZeeKj/N8SOftWpysW2Hhd1pOxHCTpIFKopTzvBr
         z+ppuUlcNhQEoQ85/pBY/5P294jf/yHCXZG4U/EhiEzqqoEAyPoo/pZWCofDOdZvOdWM
         f1/g==
X-Gm-Message-State: ANhLgQ0RhBOUxNX+s7WAmfzZlGlPIMMrzBd4V24W/pCohcO6nG1Bo7Ts
        K7sYpX/ecmd+MVuC7icn1/U=
X-Google-Smtp-Source: ADFU+vu7gIZk2JCIbkqnw6jTmVXB5bp//n2guZI8aroipP0FrUGzdHAs4+72s+tEfvjXC0U7FmzRxA==
X-Received: by 2002:a65:5c46:: with SMTP id v6mr4160952pgr.333.1583510804612;
        Fri, 06 Mar 2020 08:06:44 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 4sm38519642pfn.90.2020.03.06.08.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:06:43 -0800 (PST)
Date:   Fri, 06 Mar 2020 08:06:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, gamemann@gflclan.com, lrizzo@google.com,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Message-ID: <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
In-Reply-To: <20200303184350.66uzruobalf3y76f@ast-mbp>
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
 <20200303184350.66uzruobalf3y76f@ast-mbp>
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always equal
 XDP_PACKET_HEADROOM
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Mar 03, 2020 at 12:46:58PM +0100, Jesper Dangaard Brouer wrote:
> > The Intel based drivers (ixgbe + i40e) have implemented XDP with
> > headroom 192 bytes and not the recommended 256 bytes defined by
> > XDP_PACKET_HEADROOM.  For generic-XDP, accept that this headroom
> > is also a valid size.

The reason is to fit two packets on a 4k page. The driver itself
is fairly flexible at this point. I think we should reconsider
pushing down the headroom required in the program metadata and
configuring it at runtime. At the moment the drivers are wasting
half a page for no good reason in most cases I suspect. What is the
use case for >192B headroom? I've not found an actual user who
has complained yet.

Resurrecting an old debate here so probably doesn't need to
stall this patch.

> > 
> > Still for generic-XDP if headroom is less, still expand headroom to
> > XDP_PACKET_HEADROOM as this is the default in most XDP drivers.
> > 
> > Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> > - Before: 4,816,430 pps
> > - After : 7,749,678 pps
> > (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> > 

But why do we care about generic-XDP performance? Seems users should
just use XDP proper on ixgbe and i40e its supported.

> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h |    1 +
> >  net/core/dev.c           |    4 ++--
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 906e9f2752db..14dc4f9fb3c8 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3312,6 +3312,7 @@ struct bpf_xdp_sock {
> >  };
> >  
> >  #define XDP_PACKET_HEADROOM 256
> > +#define XDP_PACKET_HEADROOM_MIN 192
> 
> why expose it in uapi?
> 
> >  /* User return codes for XDP prog type.
> >   * A valid XDP program must return one of these defined values. All other
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 4770dde3448d..9c941cd38b13 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4518,11 +4518,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >  		return XDP_PASS;
> >  
> >  	/* XDP packets must be linear and must have sufficient headroom
> > -	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> > +	 * of XDP_PACKET_HEADROOM_MIN bytes. This is the guarantee that also
> >  	 * native XDP provides, thus we need to do it here as well.
> >  	 */
> >  	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> > -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > +	    skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN) {
> >  		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
> 
> this looks odd. It's comparing against 192, but doing math with 256.
> I guess that's ok, but needs a clear comment.
> How about just doing 'skb_headroom(skb) < 192' here.
> Or #define 192 right before this function with a comment about ixgbe?

Or just let ixgbe/i40e be slow? I guess I'm missing some context?
