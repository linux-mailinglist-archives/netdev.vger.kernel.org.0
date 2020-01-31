Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F00214E6E1
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 02:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgAaBsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 20:48:21 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34984 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgAaBsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 20:48:20 -0500
Received: by mail-oi1-f193.google.com with SMTP id b18so5784991oie.2;
        Thu, 30 Jan 2020 17:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/t1Iw/rvgMdiQA+KEdON9ovsY09UeFDS7ebcSzDoJRU=;
        b=hZ3gcqFEaLGzcztfDvsYCXAw5vC/cMX64SNXyhNRzaLQr1rRlJCAG6eljgrMpSsZQs
         eAcv8clM1CZAc/5XUWi9zlcqimvrfzB0LoMJW5XgWjOaezVvH81MQV3fEq1+Qh4g6x11
         eOsRTnOyVBF+Z6BbUFuIBxQxNGw9xumYdCUKhPYWpLE2aS5mZURLWUvea1NR5BEGt2yh
         qWwYt8Z+mBeFXLBS5QlfvNjSCs1BakW5KjqdL06TgnlWlP7JJS76qQZbUn//0uU1+n6P
         COCfFVkw7t6GJXE8V5Ly/z97nZIuyMN5pSpYD1nhKZOjQlJ09HKuMbgJNMZ8jozXjKOB
         /xNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/t1Iw/rvgMdiQA+KEdON9ovsY09UeFDS7ebcSzDoJRU=;
        b=QJvjhsbhedHo9ut89joPzo6pRk3+wVJP/OO8tIXiXx0zHzhvSGimyCBOqEiNqrsiuS
         YH0LaVuQxgueYwyMuuLSK9S1hgSKNCS6K5RtbQcM4Ay+naaunFiKo3hy2Eir8br6+tWw
         1vFBRNnvSseuyYggVHNpCjSIz7wQEEexRWbOw2nVn9w3YO94uN1M8Fyq2YeYI7j3LuhE
         z2K9CT+3Wb7w1yxRyeHh5bej7tAwIyB8gy9aoTlqsZnpI1H3u6ZnQ3el11do+INgboKs
         /bKstYcv7GHrdn+xqQFxKZENA+b/j6IWhCswge82oBrGVC9CC+ROcN1CEgtwQMDhDQ6x
         JgzQ==
X-Gm-Message-State: APjAAAUIra9Row1mq9nG7YfoFDywvZ+Woec3jYFQ2B27wqy+dEPlWoFq
        pxbbfCJ94PXm3F+Ff92E6ulnKVah
X-Google-Smtp-Source: APXvYqxXqeClvBn3Gqp2i4cYdnn6enXdelNEMfKB0UNkR6CyeKv0oQoNwmbUyEAsfdVB3P4zzIKoLg==
X-Received: by 2002:aca:2207:: with SMTP id b7mr5002807oic.109.1580435300022;
        Thu, 30 Jan 2020 17:48:20 -0800 (PST)
Received: from ubuntu-x2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id t131sm2267801oih.35.2020.01.30.17.48.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jan 2020 17:48:18 -0800 (PST)
Date:   Thu, 30 Jan 2020 18:48:16 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_qdisc: Fix 64-bit division error in
 mlxsw_sp_qdisc_tbf_rate_kbps
Message-ID: <20200131014816.GA54472@ubuntu-x2-xlarge-x86>
References: <20200130232641.51095-1-natechancellor@gmail.com>
 <31537c12-8f17-660d-256d-e702d1121367@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31537c12-8f17-660d-256d-e702d1121367@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 05:43:56PM -0800, Randy Dunlap wrote:
> On 1/30/20 3:26 PM, Nathan Chancellor wrote:
> > When building arm32 allmodconfig:
> > 
> > ERROR: "__aeabi_uldivmod"
> > [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
> > 
> > rate_bytes_ps has type u64, we need to use a 64-bit division helper to
> > avoid a build error.
> > 
> > Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> > index 79a2801d59f6..65e681ef01e8 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> > @@ -614,7 +614,7 @@ mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
> >  	/* TBF interface is in bytes/s, whereas Spectrum ASIC is configured in
> >  	 * Kbits/s.
> >  	 */
> > -	return p->rate.rate_bytes_ps / 1000 * 8;
> > +	return div_u64(p->rate.rate_bytes_ps, 1000 * 8);
> 
> not quite right AFAICT.
> 
> try either
> 	return div_u64(p->rate.rate_bytes_ps * 8, 1000);
> or
> 	return div_u64(p->rate.rate_bytes_ps, 1000) * 8;
> 

Gah, I swear I can math... Thank you for catching this, v2 incoming with
the later because I think it looks better.

Cheers,
Nathan

> >  }
> >  
> >  static int
> > 
> 
> 
> -- 
> ~Randy
> 
