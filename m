Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3437A29A770
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895457AbgJ0JLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:11:24 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36186 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895450AbgJ0JLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:11:24 -0400
Received: by mail-ed1-f65.google.com with SMTP id l16so641945eds.3
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 02:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9zQJghU+9XUe8RROu4DdeVFUv0UO4wHjGG2YFOVdDgg=;
        b=J1K3lRL9DLfipbjM5sbnXBs6qnV9LOUwZ7PMbj2P+YwoY+w+Ub3ulnnCusAkL57zH8
         khKdTt7TETkW04yliSq0bVvBlKGVcuuaAN4Ol0boT4KqUhwCE4qFvd4LzOAdn/CSTXYM
         FtVpa8XzBxsI7ZjeWOrS4L5PfNkbVqItlkRyeKOj58aB+u8vjzkeY/jB1h775BM5ohse
         O2bBmsTOLVQQKIRcGJCh3tHsHSuIPOtKtsy9td48xDBIJw9nYRmKYytthG4yCYYKHr2B
         u0Fvu4YePQZTS5vEnMnnELQ8pQZB96bdRqSQ0snpK/x5RFX7CRooAj2CxfOmwf1A/DJY
         lg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9zQJghU+9XUe8RROu4DdeVFUv0UO4wHjGG2YFOVdDgg=;
        b=e4PJrFN+sHGHQsz5GRRneE+Ao0TycEc3Cy7+wm8IyApbRNq8yLyay8pUz3mZJg8Jf5
         +/UK/nUeL7DtI3aTK0nmTYsGB6zmVYOPRcq7398meMMx4djVsQRQOYTeqMpw/9NII/6k
         8Td31biIwmafr45qHlSNQOSwSEJ6Z71W8V/1G7xtY3BldKzxfAczWQ2Yl7Bg3HJAjGg7
         cf1s691OATnKX3XVqUHJiCGa9l+DRXYXBc9scHWPe7akntvxGUj8gwWLo+N/7y7XHAI1
         1nmIsu3eBkmZ14kgX1EB+v4gkNHh7JZNgMzqu8cRgofyHZ6lSM9C9DHNZv291WBV90E4
         8W6w==
X-Gm-Message-State: AOAM530EFHU8yC4oLedFPkQ/YEzFyMYAneRnNu4E5oHdlGy3Ks66lTFe
        oMajL/+UNbEZhzf85ROpVhE=
X-Google-Smtp-Source: ABdhPJwUbdrsbCVGPhvVbcHebc8vhAV3alIj/oP39anBnbMCRQclD2D5/g7NZVyI4+HypKv9GtlKJg==
X-Received: by 2002:a05:6402:1d2c:: with SMTP id dh12mr1138841edb.256.1603789880948;
        Tue, 27 Oct 2020 02:11:20 -0700 (PDT)
Received: from tycho (ipbcc01043.dynamic.kabel-deutschland.de. [188.192.16.67])
        by smtp.gmail.com with ESMTPSA id h26sm528084edr.71.2020.10.27.02.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 02:11:20 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Tue, 27 Oct 2020 10:11:16 +0100
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com
Subject: Re: [iproute2-next] tc flower: use right ethertype in icmp/arp
 parsing
Message-ID: <20201027091116.6mteci6gs3urx4st@tycho>
References: <20201019114708.1050421-1-zahari.doychev@linux.com>
 <bd0eb394-72a3-1c95-6736-cd47a1d69585@gmail.com>
 <20201026084824.GA29950@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026084824.GA29950@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 09:48:24AM +0100, Simon Horman wrote:
> On Sun, Oct 25, 2020 at 03:18:48PM -0600, David Ahern wrote:
> > On 10/19/20 5:47 AM, Zahari Doychev wrote:
> > > Currently the icmp and arp prsing functions are called with inccorect
> > > ethtype in case of vlan or cvlan filter options. In this case either
> > > cvlan_ethtype or vlan_ethtype has to be used.
> > > 
> > > Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> > > ---
> > >  tc/f_flower.c | 43 ++++++++++++++++++++++++++-----------------
> > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/tc/f_flower.c b/tc/f_flower.c
> > > index 00c919fd..dd9f3446 100644
> > > --- a/tc/f_flower.c
> > > +++ b/tc/f_flower.c
> > > @@ -1712,7 +1712,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
> > >  			}
> > >  		} else if (matches(*argv, "type") == 0) {
> > >  			NEXT_ARG();
> > > -			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
> > > +			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
> > > +						cvlan_ethtype : vlan_ethtype ?
> > > +						vlan_ethtype : eth_type,
> > > +						ip_proto,
> > 
> > looks correct to me, but would like confirmation of the intent from Simon.
> 
> Thanks, this appears to be correct to me as ultimately
> the code wants to operate on ETH_P_IP or ETH_P_IPV6 rather
> than a VLAN Ether type.
> 
> > Also, I am not a fan of the readability of that coding style. Rather
> > than repeat that expression multiple times, make a short helper to
> > return the relevant eth type and use a temp variable for it. You should
> > also comment that relevant eth type changes as arguments are parsed.

I will add the helper and resend.

Thanks Zahari

> > 
> > Thanks,
> > 
> > 
