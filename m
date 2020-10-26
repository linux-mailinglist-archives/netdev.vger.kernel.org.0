Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CD32988BE
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772074AbgJZIs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:48:28 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:35053 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771239AbgJZIs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:48:28 -0400
Received: by mail-ej1-f66.google.com with SMTP id p5so12196527ejj.2
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 01:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CMq2mLbNL74WkLZ1bSnHIm39p11lGlRAoIf1ew+2tbQ=;
        b=Q/QB3j8/IpxObQY6qPdYa7cbAi0sEDmT6CmkPLR4Ess7CkQJb+PA97JTGmDk/haHkh
         3u5/kJKSIQk33he8fPuND4XRNN3kxTVZvAIg78U+x3nEfXe7F/oVwcUqXGy7GpJrzmKR
         rYuayxbyuURfej5BAoNdDZG1+RV1kYG3XhKuoKwoFmkQGzODd4kin3auiRZwC3aNloaw
         rNBBV7F6a+eAioCj5ftFLI0EhUzInbAr04Wpzi9BvWgkpZHxOh0kuxfar5PAnzfiaIEi
         rjlbKTGkwFXRzTQqSFMWZ/fLtCVbOuQ6gyh2CSHKC6A+PkY7HcmNba4I98LxTWD/K+nJ
         Jlew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CMq2mLbNL74WkLZ1bSnHIm39p11lGlRAoIf1ew+2tbQ=;
        b=DUHTXdBTl4IVmeAzLFum1KLArImM+LM1MH0QeMJCNSJCO8S1z0yop4BxdVb6M6jNlr
         ls791TYgWGXGva2WZKYntiP+qkLy1tiqhaNF3AyRNJF+wSb3BHc21Z9PwfCeolVTWnrL
         1Lqxd+ubLPqD2QkCkT1KUTICSy749yoMAhEA/2BEDCaXDB93K4+mJT+viHwm1RXFUoRi
         Jht5zC8xYnEOqQGuIRg9ay1yWplcTxblQSPN+gvr5q6W33YKmgBcyeuUjPIzOlaENbz8
         cKMji4/k9MyMikEw30RN35CCpnQo19RI/ZZHDHBe/Ryw9UI2/wvgpICc9VC4PlCLc5pp
         LkhQ==
X-Gm-Message-State: AOAM533Rn8DD9vjfd4Nn+3gbt/LmIhSVeHL/koCTzHCb+fgOol8qYmyH
        170Shb5SJwD/19tsDYsiPBzS3w==
X-Google-Smtp-Source: ABdhPJwRK4D9d8sEPV3gB1z/36n0v4t27P8vVnI8CMt3lDfadhwlftbORnaGv4rPAAZEvVAwnOhLkA==
X-Received: by 2002:a17:906:f185:: with SMTP id gs5mr14418155ejb.107.1603702105891;
        Mon, 26 Oct 2020 01:48:25 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id l17sm5441023eji.14.2020.10.26.01.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:48:25 -0700 (PDT)
Date:   Mon, 26 Oct 2020 09:48:24 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Zahari Doychev <zahari.doychev@linux.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com
Subject: Re: [iproute2-next] tc flower: use right ethertype in icmp/arp
 parsing
Message-ID: <20201026084824.GA29950@netronome.com>
References: <20201019114708.1050421-1-zahari.doychev@linux.com>
 <bd0eb394-72a3-1c95-6736-cd47a1d69585@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd0eb394-72a3-1c95-6736-cd47a1d69585@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 03:18:48PM -0600, David Ahern wrote:
> On 10/19/20 5:47 AM, Zahari Doychev wrote:
> > Currently the icmp and arp prsing functions are called with inccorect
> > ethtype in case of vlan or cvlan filter options. In this case either
> > cvlan_ethtype or vlan_ethtype has to be used.
> > 
> > Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> > ---
> >  tc/f_flower.c | 43 ++++++++++++++++++++++++++-----------------
> >  1 file changed, 26 insertions(+), 17 deletions(-)
> > 
> > diff --git a/tc/f_flower.c b/tc/f_flower.c
> > index 00c919fd..dd9f3446 100644
> > --- a/tc/f_flower.c
> > +++ b/tc/f_flower.c
> > @@ -1712,7 +1712,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
> >  			}
> >  		} else if (matches(*argv, "type") == 0) {
> >  			NEXT_ARG();
> > -			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
> > +			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
> > +						cvlan_ethtype : vlan_ethtype ?
> > +						vlan_ethtype : eth_type,
> > +						ip_proto,
> 
> looks correct to me, but would like confirmation of the intent from Simon.

Thanks, this appears to be correct to me as ultimately
the code wants to operate on ETH_P_IP or ETH_P_IPV6 rather
than a VLAN Ether type.

> Also, I am not a fan of the readability of that coding style. Rather
> than repeat that expression multiple times, make a short helper to
> return the relevant eth type and use a temp variable for it. You should
> also comment that relevant eth type changes as arguments are parsed.
> 
> Thanks,
> 
> 
