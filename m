Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308045A14F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfF1Qrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:47:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39321 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1Qrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:47:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so9599352wma.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 09:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XDifCmSYheya3/iXuagYObaq3c8c0KvxjcfJivxt2q4=;
        b=plj/eAlKbejZtyHlmGXXO9l1kGwjgc2NuaitBQUCpl9PWagqC5AwwCh0O7WIeL7mu8
         ftci5QL0+soxrVDZG3PGWGSSj8Mcj/N0LemOhHpRkzw1d13C7oq/ZpK0aZGu4Ze1lnTa
         HwwExg/BLDBb+g4C2PE3mAfnL+f6Fwp+Jmc2sC4hC+caNdU7U7nrJlZi5zmp8g9gemCf
         4c24JKhRydtoad3+EEGGiidS7Cy95ClSGd0p+FOJ42HXGKORc+0KdnKRiHi9kNthebPC
         BOVdn9+3yq0jRUVfv20+91po+lPQT60kq/oC1DrRvoGJVkN8LAxlfSbKoMUmsnMpnfDk
         Ru9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XDifCmSYheya3/iXuagYObaq3c8c0KvxjcfJivxt2q4=;
        b=Ob9KivsneIKbnEK/qDFp3rg7ob35ynwgU1ZSDyLgj9BfvVzYItDuJn34twVXalxxpz
         aSpPTLBsL0gR5BpqXJvCKU6h6I+YOuyWQ0E0wBOGfftt3jbwDmZ1h9naMkUrSZRUA3uu
         QwTOogO973I1YHTlFMkUg90c2cle/WslR2EHaGiDE2ULdtAUnphuJWpTxrgdWXE+F7GE
         vxyMbNbQP4D67Ptj9q4mZA75ET+Vhbx6lAdtUw18qR15i2wAux+/zheXOi5j8AeToFHR
         5WW4eAxu/9rqGQcv8H/yXC1aj+/j0imbNwZYSRsFu7CylFgWyw9nSHhixsUl5mUt8wIT
         yjWA==
X-Gm-Message-State: APjAAAUt51kC8o1TyCe4wXc99M4AlQ8bGNaoMrZETqR4EbToD9ZkYcOV
        L1MRBqhJOoAyhiY/xDRwBP+l/Q==
X-Google-Smtp-Source: APXvYqzcitAXtBs0CLpu7VHvJdg+y5o+0EC4EwzK1kKFwFOTxfSBYlr63afoylKwrGl4lT9G6wqqzw==
X-Received: by 2002:a7b:c933:: with SMTP id h19mr2799771wml.52.1561740465762;
        Fri, 28 Jun 2019 09:47:45 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id a81sm2814652wmh.3.2019.06.28.09.47.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 09:47:45 -0700 (PDT)
Date:   Fri, 28 Jun 2019 19:47:41 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 3/3, net-next] net: netsec: add XDP support
Message-ID: <20190628164741.GA27936@apalos>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190628153552.78a8c5ad@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628153552.78a8c5ad@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 03:35:52PM +0200, Jesper Dangaard Brouer wrote:
> On Fri, 28 Jun 2019 13:39:15 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > +static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> > +			    struct netlink_ext_ack *extack)
> > +{
> > +	struct net_device *dev = priv->ndev;
> > +	struct bpf_prog *old_prog;
> > +
> > +	/* For now just support only the usual MTU sized frames */
> > +	if (prog && dev->mtu > 1500) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (netif_running(dev))
> > +		netsec_netdev_stop(dev);
> > +
> > +	/* Detach old prog, if any */
> > +	old_prog = xchg(&priv->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	if (netif_running(dev))
> > +		netsec_netdev_open(dev);
> 
> Shouldn't the if-statement be if (!netif_running(dev))
> 
> > +
This is there to restart the device if it's up already (to rebuild the rings).
This should be fine as-is

> > +	return 0;
> > +}

Thanks
/Ilias
