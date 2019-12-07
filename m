Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D9115DAB
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 18:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLGRET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 12:04:19 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51225 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfLGRET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 12:04:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id g206so11096106wme.1
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 09:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XDMPcHAZQiLX3ieVJ0Hoi8zmIgQax27fEaO5AqLLBRw=;
        b=pnLsNx1wSNaXYK12hPt7vrlzSJ9SrPOeKko3pDibbYPIzN/Jk5yGlGxJ1KQYmLVAl+
         6QaqGdEMxkHMWXnesGKM01U1iO9NxjKwCZHq88lGtHDg6JVxMCcO21XKXnu9QOzsaXt/
         U0PwJbjgL0o2UMSyyJfYzJruI+Hp7Q4v9yg4Ld9ymiuNRIRAnS/D/s5MBaa8HLSlntwA
         fkcwlh/xbL8c6tEcXWSj1VJSnaMe55MTQ8akQxLLu+80QwZ+/n8IO4yjAlNNS+c1Jr9O
         p5cKXg16QlJ38my+3WnaPMMf27VgueeEzU+zdsY1+pERJLKxb0tr7Tz4SKrAe3Y2bJMo
         gqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XDMPcHAZQiLX3ieVJ0Hoi8zmIgQax27fEaO5AqLLBRw=;
        b=XKX1T5AAH+/WFPxVv1Am1mbURWJPKratdIPk3fb44QPVhgNnrWIlsFgsAeqEXVuhYs
         oGnyuT3DvSHWRGQ4IV+u3zGU5SRcXDlLuuOgksLkXVDQdiVpdUJuyonDYIbHv098yx08
         HVji3ouYsqS+jceBQlMeGEAYajhiLhDwcLCPdPAGx/xTtXQTbHOq2NmFWUVeef1lhPTW
         /NbViyHsuUMZ0nAXMdJt7b3kS6N7l6PhfbzbqDz0q32G9BEvdBWJvalMYMVkWIad39Xs
         RJ9fWutSfjwC8R4+h420049Hy8jQF0k7AYeBDpnVoPm+zdfkpcr6y1av+Mfif83zradS
         R2fQ==
X-Gm-Message-State: APjAAAVLbvdb/LHCcS2MC/jLH46bweXJ5d6G7EapxRLXamBs1iFnsJAf
        zmYvFBEGm6VPXlkOhhxt0+3Jjw==
X-Google-Smtp-Source: APXvYqzq4hhjpN54XKkiikGPiSWMl/a4VYs2XD1GhNn2taIaSyS5ZdrbaEVqekMP7bINrq78nTHwyg==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr15797634wml.141.1575738257416;
        Sat, 07 Dec 2019 09:04:17 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id r6sm20645041wrq.92.2019.12.07.09.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 09:04:16 -0800 (PST)
Date:   Sat, 7 Dec 2019 18:04:15 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after
 pskb_may_pull()
Message-ID: <20191207170414.GC26173@netronome.com>
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
 <20191206104212.GE27144@netronome.com>
 <CAJ0CqmWjh1bAOwx25tVE_yDbzCbf9dCXsFE7ZV_1N7Tt-DF64A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmWjh1bAOwx25tVE_yDbzCbf9dCXsFE7ZV_1N7Tt-DF64A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 01:55:25PM +0200, Lorenzo Bianconi wrote:
> >
> > Hi Cong,
> >
> > On Thu, Dec 05, 2019 at 07:39:02PM -0800, Cong Wang wrote:
> > > After pskb_may_pull() we should always refetch the header
> > > pointers from the skb->data in case it got reallocated.
> > >
> > > In gre_parse_header(), the erspan header is still fetched
> > > from the 'options' pointer which is fetched before
> > > pskb_may_pull().
> > >
> > > Found this during code review of a KMSAN bug report.
> > >
> > > Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
> > > Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > > ---
> > >  net/ipv4/gre_demux.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
> > > index 44bfeecac33e..5fd6e8ed02b5 100644
> > > --- a/net/ipv4/gre_demux.c
> > > +++ b/net/ipv4/gre_demux.c
> > > @@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
> > >               if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
> > >                       return -EINVAL;
> > >
> > > -             ershdr = (struct erspan_base_hdr *)options;
> > > +             ershdr = (struct erspan_base_hdr *)(skb->data + nhs + hdr_len);
> >
> > It seems to me that in the case of WCCPv2 hdr_len will be 4 bytes longer
> > than where options would be advanced to. Is that a problem here?
> >
> 
> Hi Simon,
> 
> I guess the two conditions are mutually exclusive since tpi->proto is
> initialized with greh->protocol. Am I missing something?

Thanks Lorenzo,

I see that now and agree that this patch is correct.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> > >               tpi->key = cpu_to_be32(get_session_id(ershdr));
> > >       }
> > >
> > > --
> > > 2.21.0
> > >
> >
> 
