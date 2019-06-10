Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8C3BDD1
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbfFJUvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:51:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37111 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbfFJUvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 16:51:40 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so16454057eds.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 13:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LwPRrFIFVpFh7windfuH8fQym2aENAjRfJxjWELiSBU=;
        b=Zb5w8rP85WrEmAp+Zr/D+9qTV1RoeJ9+bGxf6ZGFaz//eje5o8iDyuC629FdHNoZHM
         M6NOkiKW5X94YWAH/0ShGapQoZma0hlhSk6PpQEgi915CF1Dv1mhkO/conE2CVt3RObX
         ksdmzpJiEaaT8Yjo9vuQP3/LNVzAO7x6LBf7L7PR+g89d/pcyU9i67wPGHBkQEiC2ISG
         qdF9toeA0vtNzb1Fd88YeDnqmdHXoZrEQoob4+rUi/sJyLbrlfMfj4RPQBeM7Zhz4UQr
         Rps++y3zxLadol/OIc8Cv+L+LUVb9gstJIM2XJOSfG/oNJXv+6ypGOgTjXRr43Utd7px
         oGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LwPRrFIFVpFh7windfuH8fQym2aENAjRfJxjWELiSBU=;
        b=JU0JMiuYTTilDbOkU7tEVdFNntQdeNUfQlj49Y1CmcCUas5NujeotRYfk/ivmQZdTS
         HT3OnmZ1npjNMZzd79P16tA5qIkrC4r8y1hvKQoOtmsnZ5lnolXBk5j7wVqHAIUn4ITy
         Nr8iAuZx8Yy0ml/2oY02CVaoUStsOGokpbiRzGREzUC9mDOMmEGQBJj+jX9gzDKHBavn
         yyTo7t91CH0JrEHjF7OCdXL+7ekzYLzLi0RlcKBpHd/zd976K/HdQlYX89jF1dnSXn46
         MJHvblz61RnxJI9LNpKYyoTs/y5L9hZVvYPJfI/Bt106cr3nHcAiTJ+slUoxuuvL2ukp
         dIqA==
X-Gm-Message-State: APjAAAVcGU1cbtAbt0eIgAGZwYxuYEZfl2rjXCoR6gVf1cIDkHKjOwb/
        YhGwkq6rJWSy9EDpXnWcK3Iqsg==
X-Google-Smtp-Source: APXvYqwi/4K4O7p3F5fWVp5YvhiOxBsgwx+PVV7Ojw/tfOBJ/2puw1O0OPD6xnMpmS+Mb4sPcC1x7Q==
X-Received: by 2002:a17:906:d7aa:: with SMTP id pk10mr1184294ejb.125.1560199899038;
        Mon, 10 Jun 2019 13:51:39 -0700 (PDT)
Received: from brauner.io ([2a02:8109:9cc0:6dac:cd8f:f6e9:1b84:bbb1])
        by smtp.gmail.com with ESMTPSA id k9sm1976063eja.72.2019.06.10.13.51.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 13:51:38 -0700 (PDT)
Date:   Mon, 10 Jun 2019 22:51:36 +0200
From:   Christian Brauner <christian@brauner.io>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de
Subject: Re: [PATCH net-next v1 1/1] br_netfilter: namespace bridge netfilter
 sysctls
Message-ID: <20190610205134.6wqparmtsdzbiutv@brauner.io>
References: <20190609162304.3388-1-christian@brauner.io>
 <20190609162304.3388-2-christian@brauner.io>
 <20190610174136.p3fbcbn33en5bb7f@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190610174136.p3fbcbn33en5bb7f@salvia>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 07:41:36PM +0200, Pablo Neira Ayuso wrote:
> Thanks for updating this patch to use struct brnf_net.
> 
> A few comments below.
> 
> On Sun, Jun 09, 2019 at 06:23:04PM +0200, Christian Brauner wrote:
> [...]
> > diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
> > index 89808ce293c4..302fcd3aade2 100644
> > --- a/include/net/netfilter/br_netfilter.h
> > +++ b/include/net/netfilter/br_netfilter.h
> > @@ -85,17 +82,42 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
> >  		return 0;
> >  }
> >  
> > -#define IS_VLAN_IP(skb) \
> > -	(vlan_proto(skb) == htons(ETH_P_IP) && \
> > -	 brnf_filter_vlan_tagged)
> > +static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
> > +{
> 
> I like this conversion from macro to static inline a lot.
> 
> But if you let me ask for one more change, would you split this in two
> patches? One to replace #defines by static inline.

Sure.
