Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5985A2F5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfF1R71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:59:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47008 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1R71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:59:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so7139023wrw.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bpSDVv1LQKCnJhMg+sb3EeN2ipsKnwmSPWeBBANEZqg=;
        b=BKWI0YJGFb11iQSo+C68gwVN5hrY8rhWKYffmyIPrVHvd2ogU4Hra8MD5W3hPsKLXI
         U5CffKoRCDtiB/Ad27iTW8ejAmuuZVvrgSljS3rckCb8jc4282W7yiCRSjbnoMfgtZVv
         sk4KPfqnlD+whapvh40gF16Kmtxil/GIuZFWM4wt9WYebSoTrYZEwyQ0Nr3Y0lpJUxTf
         NaA+/hxXyM+AytwN5n24TSZQANO9ECCu4npWcwJs0AKzopsYygCXQNQirIcaj3KgYXoI
         xvoyh1mDoS637K4EK8K0e6WM8cPizSks7NAE/L9mxIem2xt8dFB2iliA/Kb4JxAtf3Tx
         21VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bpSDVv1LQKCnJhMg+sb3EeN2ipsKnwmSPWeBBANEZqg=;
        b=dL8CCIqYIF2TjniRbUNIY/NjUl5l7aHalP8c6s5cyUdt6sx7JDIwlbi3oozlWIhN/w
         8Jv26E0nicItNP7OuIb8Vk7d91dJL0v8S4qZHOjgObJj2gTo/xqJLEkvxOy8vzD9Y0dN
         JxvwmCp46yB+ISg063wUl/gPGHtG1wgcKkcTczjKkYAWFcIgIQVExXRQ9lWuaFgAZrnZ
         6Z+nzsUXV6CnFRjvjP1URJefIvJo6MbCCsMZ7uM0pGgr5EPbLnegQhlQaFMsVIOOUyJU
         I5nB1/tv+3kMIJc+f8za/fNnK6qZ9AidURuPlhxtfFZPqEQOLO+U9a2eog6YYJxnHYS4
         9ZMA==
X-Gm-Message-State: APjAAAVrOYmKGJDLnffdOD9X3zHnJpifeh9xSlmntU4BuQ/rTn9Cmsh7
        RjrnKvPJpe8sZ0DkrO+g4msR5A==
X-Google-Smtp-Source: APXvYqyCU20o6xShb3Dlzx5ob6sClBu9NLxEZzXtpqzlCQ0yG9+iMLV6avMQ4rA5Jb7V2SGxYk9/Fg==
X-Received: by 2002:adf:e910:: with SMTP id f16mr8920003wrm.183.1561744764951;
        Fri, 28 Jun 2019 10:59:24 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id l8sm5796579wrg.40.2019.06.28.10.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 10:59:24 -0700 (PDT)
Date:   Fri, 28 Jun 2019 20:59:21 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net
Subject: Re: [PATCH 3/3, net-next] net: netsec: add XDP support
Message-ID: <20190628175921.GA979@apalos>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190628153552.78a8c5ad@carbon>
 <20190628164741.GA27936@apalos>
 <20190628192351.00003555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628192351.00003555@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

> > On Fri, Jun 28, 2019 at 03:35:52PM +0200, Jesper Dangaard Brouer wrote:
> > > On Fri, 28 Jun 2019 13:39:15 +0300
> > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > >   
> > > > +static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> > > > +			    struct netlink_ext_ack *extack)
> > > > +{
> > > > +	struct net_device *dev = priv->ndev;
> > > > +	struct bpf_prog *old_prog;
> > > > +
> > > > +	/* For now just support only the usual MTU sized frames */
> > > > +	if (prog && dev->mtu > 1500) {
> > > > +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> > > > +		return -EOPNOTSUPP;
> > > > +	}
> > > > +
> > > > +	if (netif_running(dev))
> > > > +		netsec_netdev_stop(dev);
> > > > +
> > > > +	/* Detach old prog, if any */
> > > > +	old_prog = xchg(&priv->xdp_prog, prog);
> > > > +	if (old_prog)
> > > > +		bpf_prog_put(old_prog);
> > > > +
> > > > +	if (netif_running(dev))
> > > > +		netsec_netdev_open(dev);  
> > > 
> > > Shouldn't the if-statement be if (!netif_running(dev))
> > >   
> > > > +  
> > This is there to restart the device if it's up already (to rebuild the rings).
> > This should be fine as-is
> 
> I think that Jesper's concern was about that you could have already stopped the
> netdev earlier via netsec_netdev_stop (before the xchg)? So at this point
> __LINK_STATE_START might be not set.
> 
> Maybe initially store what netif_running(dev) returns in stack variable and
> act on it, so your stop/open are symmetric?
I did not write the open/close originally but to my understanding, 
netsec_netdev_stop() won't change that the .ndo_close will. 
So this check is there to ensure a user won't bring the interface down during 
loading/re-loading of the program. Keeping in the stack would break that,
wouldn't it?

Thanks
/Ilias

> 
> > 
> > > > +	return 0;
> > > > +}  
> > 
> > Thanks
> > /Ilias
> 
