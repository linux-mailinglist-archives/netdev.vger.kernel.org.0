Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FEC12B468
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfL0MFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 07:05:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbfL0MFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 07:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577448342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q5XXULvPBCdPqhDyApB0SLhznAFY7NUhBbt1TjCPMF0=;
        b=OcykDk3QmPDxoXCnixeHEpreRwv60SuqDxKPA3PPhCW0InbQcs6e7D9mmKFI4Xr5+GaigY
        f1gb7jJCj4PkKg4Z/amxPuTavlTeYsdqQdK2p+HcH5ZBKcK3CUFhcVFSuBIFZp0P6V6KCD
        /yHqe+ZcytmcTMl6cGD58Yh/6BoF3RU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-1XOmruHMOYyizbRrHB3tzg-1; Fri, 27 Dec 2019 07:05:40 -0500
X-MC-Unique: 1XOmruHMOYyizbRrHB3tzg-1
Received: by mail-wm1-f69.google.com with SMTP id y125so2005243wmg.1
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 04:05:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q5XXULvPBCdPqhDyApB0SLhznAFY7NUhBbt1TjCPMF0=;
        b=hreiuci00Hkd41X0P/gnVMYNxDsJznFQ14Uk1ah169u83W8APA/26cNbcgg6uSu7aH
         6Hhyxh7N3mb0A3AR71hfmUh2RA2bhJ7Wx1M666f9h4e9XNs+CLWu6hAfLKVSvMjeNDhj
         qRhuuXg/eKeiM9ywbc2r58Hb2bpu0cbcsSYP7tuPs3ADcfH2hxWPNPwkm2qqEDD7DaBy
         B1h1pNv7JJVNApOeErbQByng73LLZnHOkc/2KcfUwmWXtMZpxxBpwhJVdF4jnQkHs2Pu
         Yz2WuW5qDH19h4ZCJcIF755sYgrMFLYmPXDtfwR6F2UzYj8SDdujPyONEIygq+syCWH6
         uYTQ==
X-Gm-Message-State: APjAAAVf1/sp7/7e83yGrDzrewXdQ+WrxbPcTzMrQX/tLhiRJjZDaIKg
        I+QZNEFd0kG3w4Uv4wfrOzPyeUxoAV62mcRrX46gpvziQEGk4khhCu1DRDwS/9NxDmajgaBpb4n
        5LmsJH18Tf4Nz16ZT
X-Received: by 2002:adf:f850:: with SMTP id d16mr51411894wrq.161.1577448339455;
        Fri, 27 Dec 2019 04:05:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqxIUH/iXdbActUcnfV2oV6Gg5J5xnzokN2jSRLSiWh+2/KOUFQxi7yrQhQWMqgwNXmx/uukAw==
X-Received: by 2002:adf:f850:: with SMTP id d16mr51411867wrq.161.1577448339208;
        Fri, 27 Dec 2019 04:05:39 -0800 (PST)
Received: from linux-2.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id k13sm33967659wrx.59.2019.12.27.04.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 04:05:38 -0800 (PST)
Date:   Fri, 27 Dec 2019 13:05:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ppp: Remove redundant BUG_ON() check in ppp_pernet
Message-ID: <20191227120536.GA32264@linux-2.home>
References: <1577243224-1923-1-git-send-email-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577243224-1923-1-git-send-email-vulab@iscas.ac.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 03:07:04AM +0000, Xu Wang wrote:
> Passing NULL to ppp_pernet causes a crash via BUG_ON.
> Dereferencing net in net_generic() also has the same effect.
> This patch removes the redundant BUG_ON check on the same parameter.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/net/ppp/ppp_generic.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 3bf8a8b..22cc2cb 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -296,8 +296,6 @@ static struct class *ppp_class;
>  /* per net-namespace data */
>  static inline struct ppp_net *ppp_pernet(struct net *net)
>  {
> -	BUG_ON(!net);
> -
>  	return net_generic(net, ppp_net_id);
>  }
Acked-by: Guillaume Nault <gnault@redhat.com>

