Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207665F5CE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfGDJjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:39:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55119 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfGDJjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 05:39:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so2018810wme.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 02:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WSgYNyiVFTsfF9jPEtI+98HkWM1O/G/j6vEHZDtVKWc=;
        b=JKSN5hno96QmLoVsyG+/LZMfrZKCh+mjHRVCXMiVXDzoyv6Fd6bzsSTZFFJpC0KM9A
         aEy1TYiaQlvJ4lMRQtPEwICrqPTPqjznFdCK/DYPW1V7NbbFBiNdyMrGJkvjwInVpBRe
         f56bxQeW1YIif88NOeACq7d58yh+g9UWA1osembho58b0ex9lqgzz0pEBVcx6Ge9/X6X
         Br1XHFa+1DIXw2eCVEsWuRy6glzkQ0Q18u9wuqzwvhflQ73yJQLQhZshL3im/vPCjDz4
         ZKTy/hM6jHC/YHNvkOwaEZFAIpmIjONQXttOVEZAkR5dtUxRdV9/mKpw9Z3FUUcS9jSJ
         YEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WSgYNyiVFTsfF9jPEtI+98HkWM1O/G/j6vEHZDtVKWc=;
        b=QYGcO6+m6upv6o3qnLn7DtWGlbkGjkMjpEHH5ovtXD1g/gW+bJK5ptJnJ9+7C5dInU
         LoDnaqcKzydlFYSbXzOhH5q8HNXi2I4dR8+aS6Sm1d3NV22qkw21vTsm1zzINUsqGQEF
         R3DvaHCLcUrrpUqKb7g6yl/b11uvtfR9oP6ZT7z5SlUjkN1ZERXmCkFEs/nyQ4dH2NI8
         ePQYdkNhMO/LOAx46va4dhWL4VZhJdpUF20+TAH7Ili/Wk5WsYFa7Rx8vsAPdNdVuzIF
         swAYleXqyea8BaKtOzqOI6qmPaxea4NtsNjMvSF7VJUz9gueZ3AAHjG+LAeZGifUYnrj
         F9Ug==
X-Gm-Message-State: APjAAAVWTcX1/AfOZmb1lVNy9+FAB4TSB611iEtOYy8K96WAV6xLX4D0
        oOWtZFwTSkQt4sh7vjAJDcJKBA==
X-Google-Smtp-Source: APXvYqwEKvVGpyCj/sGD0WgccFoXLNcEiyTYrTEKI4A5nhW6vqcEutiZpq75PWGazImk8PIBFv0y0Q==
X-Received: by 2002:a7b:c4d0:: with SMTP id g16mr12146955wmk.88.1562233146315;
        Thu, 04 Jul 2019 02:39:06 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id v65sm5750191wme.31.2019.07.04.02.39.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 02:39:05 -0700 (PDT)
Date:   Thu, 4 Jul 2019 12:39:02 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v6 net-next 5/5] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190704093902.GA26927@apalos>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
 <20190704111939.5d845071@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704111939.5d845071@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 11:19:39AM +0200, Jesper Dangaard Brouer wrote:
> On Wed,  3 Jul 2019 13:19:03 +0300
> Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> 
> > Add XDP support based on rx page_pool allocator, one frame per page.
> > Page pool allocator is used with assumption that only one rx_handler
> > is running simultaneously. DMA map/unmap is reused from page pool
> > despite there is no need to map whole page.
> > 
> > Due to specific of cpsw, the same TX/RX handler can be used by 2
> > network devices, so special fields in buffer are added to identify
> > an interface the frame is destined to. Thus XDP works for both
> > interfaces, that allows to test xdp redirect between two interfaces
> > easily. Aslo, each rx queue have own page pools, but common for both
> > netdevs.
> > 
> > XDP prog is common for all channels till appropriate changes are added
> > in XDP infrastructure. Also, once page_pool recycling becomes part of
> > skb netstack some simplifications can be added, like removing
> > page_pool_release_page() before skb receive.
> > 
> > In order to keep rx_dev while redirect, that can be somehow used in
> > future, do flush in rx_handler, that allows to keep rx dev the same
> > while reidrect. It allows to conform with tracing rx_dev pointed
> > by Jesper.
> 
> So, you simply call xdp_do_flush_map() after each xdp_do_redirect().
> It will kill RX-bulk and performance, but I guess it will work.
> 
> I guess, we can optimized it later, by e.g. in function calling
> cpsw_run_xdp() have a variable that detect if net_device changed
> (priv->ndev) and then call xdp_do_flush_map() when needed.
I tried something similar on the netsec driver on my initial development. 
On the 1gbit speed NICs i saw no difference between flushing per packet vs
flushing on the end of the NAPI handler. 
The latter is obviously better but since the performance impact is negligible on
this particular NIC, i don't think this should be a blocker. 
Please add a clear comment on this and why you do that on this driver,
so people won't go ahead and copy/paste this approach 


Thanks
/Ilias
> 
> 
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> > ---
> >  drivers/net/ethernet/ti/Kconfig        |   1 +
> >  drivers/net/ethernet/ti/cpsw.c         | 485 ++++++++++++++++++++++---
> >  drivers/net/ethernet/ti/cpsw_ethtool.c |  66 +++-
> >  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
> >  4 files changed, 502 insertions(+), 57 deletions(-)
> > 
> [...]
> > +static int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> > +			struct page *page)
> > +{
> > +	struct cpsw_common *cpsw = priv->cpsw;
> > +	struct net_device *ndev = priv->ndev;
> > +	int ret = CPSW_XDP_CONSUMED;
> > +	struct xdp_frame *xdpf;
> > +	struct bpf_prog *prog;
> > +	u32 act;
> > +
> > +	rcu_read_lock();
> > +
> > +	prog = READ_ONCE(priv->xdp_prog);
> > +	if (!prog) {
> > +		ret = CPSW_XDP_PASS;
> > +		goto out;
> > +	}
> > +
> > +	act = bpf_prog_run_xdp(prog, xdp);
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		ret = CPSW_XDP_PASS;
> > +		break;
> > +	case XDP_TX:
> > +		xdpf = convert_to_xdp_frame(xdp);
> > +		if (unlikely(!xdpf))
> > +			goto drop;
> > +
> > +		cpsw_xdp_tx_frame(priv, xdpf, page);
> > +		break;
> > +	case XDP_REDIRECT:
> > +		if (xdp_do_redirect(ndev, xdp, prog))
> > +			goto drop;
> > +
> > +		/* as flush requires rx_dev to be per NAPI handle and there
> > +		 * is can be two devices putting packets on bulk queue,
> > +		 * do flush here avoid this just for sure.
> > +		 */
> > +		xdp_do_flush_map();
> 
> > +		break;
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +		/* fall through */
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(ndev, prog, act);
> > +		/* fall through -- handle aborts by dropping packet */
> > +	case XDP_DROP:
> > +		goto drop;
> > +	}
> > +out:
> > +	rcu_read_unlock();
> > +	return ret;
> > +drop:
> > +	rcu_read_unlock();
> > +	page_pool_recycle_direct(cpsw->page_pool[ch], page);
> > +	return ret;
> > +}
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
