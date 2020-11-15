Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083572B34BA
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 12:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgKOLo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 06:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgKOLo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 06:44:57 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E61C0613D1;
        Sun, 15 Nov 2020 03:44:57 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gv24so2499567pjb.3;
        Sun, 15 Nov 2020 03:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tmv8ZZeN6TdxknLtX/g558yOOygP5SGuU1C7JA+C4O0=;
        b=hZoP9Ve4d54Ov6C5lzXSlYc/1VBgNVdp0HM83TnmjMByRcWDPDdE/AiipZ+fMHPILu
         nv0KO1bOr+gZZ63oSB1PKd/0nkFSJvtDqpoJ7r/cKuhYnC9YUhFbzZPU0rJTA75P7aEz
         ybhTzNaIzW/3OKuUIDH7Kgq7JpcNtx1GRujzZw56OFK+PIRUDWwui0ZHBHALjd0zEjIl
         FEmhn76n9lCzfYEcsHnZVOY32F9+5SulLnq5RcVFd27I7xg19Zn+dpgh+Mne/ijqgm6l
         yyWqvSQ6eAsCidyw+QwwSRLdr4ZCDIBRLUn2775/ICR6XdtrJqgxLDhJ+4sIY7wnUmL8
         vszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tmv8ZZeN6TdxknLtX/g558yOOygP5SGuU1C7JA+C4O0=;
        b=fFu6QC0JnpzwblZek/MhfL56ov29OfQzwS8dmQPk6R7ByuXZcyKD1aLBDA21y2xl4g
         in1zUwN+sf4vkRWgR+rrCGwpdk2f22/rk8kCTU5HKaGe+SFuJsV558i9y2iXXHPoVynl
         CFMqo/fyuyWqfi/udlRcFhHozRiCLEoXBqnhAz+lNZO3WOwEFry3oTOA7zF1gIaIJDnx
         cE36ctUtyUff/Wsza2THfUDwAEec0hb0+ivV1UTBfNW2sUBDMzYfzyoUHNrTlhxRtkPj
         lq9cAB5K/DpgrPLekAKpc8Yc2sRHbI+iLvioMEBgtSN/zkkfhycp2OnXaZo3Xkb+6Oqi
         /MWA==
X-Gm-Message-State: AOAM532RT4rFmxASC9dp2lV79JluK8IP9dAnZhLOEY2zED+5UbxAMi62
        eFAJAqZUCU/b4yHbfR5TwpM=
X-Google-Smtp-Source: ABdhPJzhd5fE9raRSdPzbL7fsH6jo/q3xiNgphqVH6VKQMapA4fU7Ip8o4uMeQJwCzyNBUPR2pDWxw==
X-Received: by 2002:a17:90b:1098:: with SMTP id gj24mr11401419pjb.140.1605440696679;
        Sun, 15 Nov 2020 03:44:56 -0800 (PST)
Received: from Thinkpad ([45.118.167.196])
        by smtp.gmail.com with ESMTPSA id 21sm15276376pfw.105.2020.11.15.03.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 03:44:55 -0800 (PST)
Date:   Sun, 15 Nov 2020 17:14:48 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ralf@linux-mips.org, davem@davemloft.net, saeed@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH v4 net] rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201115114448.GA40574@Thinkpad>
References: <20201110194518.GA97719@Thinkpad>
 <20201111165954.14743-1-anmol.karan123@gmail.com>
 <20201114111838.03b933af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114111838.03b933af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 11:18:38AM -0800, Jakub Kicinski wrote:
> On Wed, 11 Nov 2020 22:29:54 +0530 Anmol Karn wrote:
> > rose_send_frame() dereferences `neigh->dev` when called from
> > rose_transmit_clear_request(), and the first occurrence of the
> > `neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
> > and it is initialized in rose_add_loopback_neigh() as NULL.
> > i.e when `rose_loopback_neigh` used in rose_loopback_timer()
> > its `->dev` was still NULL and rose_loopback_timer() was calling
> > rose_rx_call_request() without checking for NULL.
> > 
> > - net/rose/rose_link.c
> > This bug seems to get triggered in this line:
> > 
> > rose_call = (ax25_address *)neigh->dev->dev_addr;
> > 
> > Fix it by adding NULL checking for `rose_loopback_neigh->dev`
> > in rose_loopback_timer().
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> > Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> 
> > diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> > index 7b094275ea8b..6a71b6947d92 100644
> > --- a/net/rose/rose_loopback.c
> > +++ b/net/rose/rose_loopback.c
> > @@ -96,10 +96,12 @@ static void rose_loopback_timer(struct timer_list *unused)
> >  		}
> > 
> >  		if (frametype == ROSE_CALL_REQUEST) {
> > -			if ((dev = rose_dev_get(dest)) != NULL) {
> > +			dev = rose_dev_get(dest);
> > +			if (rose_loopback_neigh->dev && dev) {
> >  				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
> >  					kfree_skb(skb);
> >  			} else {
> > +				dev_put(dev);
> >  				kfree_skb(skb);
> >  			}
> >  		} else {
> 
> This is still not correct. With this code dev_put() could be called with
> NULL, which would cause a crash.
> 
> There is also a dev_put() missing if rose_rx_call_request() returns 0.
> 
> I think that this is the correct code:
> 
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 7b094275ea8b..ff252ef73592 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -96,11 +96,22 @@ static void rose_loopback_timer(struct timer_list *unused)
>  		}
>  
>  		if (frametype == ROSE_CALL_REQUEST) {
> -			if ((dev = rose_dev_get(dest)) != NULL) {
> -				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
> -					kfree_skb(skb);
> -			} else {
> +			if (!rose_loopback_neigh->dev) {
>  				kfree_skb(skb);
> +				continue;
> +			}
> +
> +			dev = rose_dev_get(dest);
> +			if (!dev) {
> +				kfree_skb(skb);
> +				continue;
> +			}
> +
> +			if (rose_rx_call_request(skb, dev, rose_loopback_neigh,
> +						 lci_o) == 0) {
> +				dev_put(dev);
> +				kfree_skb(skb);
>  			}
>  		} else {
>  			kfree_skb(skb);
> 
> Please test this and resubmit it if it works.

Sure sir, I will test it and resend, if it works.


Thanks,
Anmol
