Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB51377B0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfFFPTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:19:51 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42856 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbfFFPTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:19:51 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so1696338pff.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+dI5swD1+omNHneKtJgThPzt3z+a6zgCfryKXerEk+I=;
        b=KpUcO0CnhBIu8G6mnGGrqCHe1Kkx45ZcW+oH2HZ2Kz7r+idRSFJWy0DVbMKv3k/uE/
         M/nUZ0pa9SZekl54rp6x3Vwe/QiB8ICNkwPBthR6RzgpCENAMQ0CMK5v9H1NIKzq+olP
         5EoyF3PiLb/LovgHPn8jgagX52/cJeJ6x4VhmFCbZD/1E1kCD/j6y9NP1SgkRn7jDKBX
         TK7bIdcWa3UO/PLu8KRVgxtvdv0xe6UzdcZAcp8XWK6uKNBvP5XB89OZC2ssq/cjozdJ
         MthlBYbsYBUoAD1Xr+9AYhFzp4WY04PuKZ3n1u8UdrzfLx0rRYn5pGDQVhNIHD2mHIES
         RqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+dI5swD1+omNHneKtJgThPzt3z+a6zgCfryKXerEk+I=;
        b=honq9D8FyNz0hpzNjN0H1Gg155nKrz7D3lbpJUvZGAWYV2ecUCWHBXgebAqKfmyk+X
         mXWUR5inLyFTXA1tCDEU+Z1xJoq0W23rWIQ6Sb7o5U+2iAaTwGsj/WtmrmTdydvS/kxA
         c7QDnAlyw/7BQDBAdnhTPrbm4NjWDg+LOMQX2n2LckZy2rxDRmEu0JJ+54j4wSdjHdvi
         cyKvuwGypJ4J7ok12leBkgUX1O/JnSWT1rbQ83VP/iwBTqVZKmjSbA86v2U6qayaGrDS
         GgR002ORKFuAaiA1Jd19wFfijmnsvsY0O3i+BFiOAhJe/D2JLQFIIsOmsLKDu34Mnp5p
         /q6w==
X-Gm-Message-State: APjAAAXuK9wPJ5qEdbHbyWSsC4ZxYcvo3cCCYPBEcFJ9+gt2h/caxYEc
        kkrrmqtSJ/MXPZUlWkTXRJ3wxA==
X-Google-Smtp-Source: APXvYqyJ6WKaIp3QZZDTH+D57pYIq7W1ryRZeSCGj3dL0yG9QANxq3U1mGe4wfmVIuc6w/W6v3LRNg==
X-Received: by 2002:a62:1483:: with SMTP id 125mr53844216pfu.137.1559834390511;
        Thu, 06 Jun 2019 08:19:50 -0700 (PDT)
Received: from brauner.io ([172.56.30.175])
        by smtp.gmail.com with ESMTPSA id i5sm4103104pfk.49.2019.06.06.08.19.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 08:19:49 -0700 (PDT)
Date:   Thu, 6 Jun 2019 17:19:39 +0200
From:   Christian Brauner <christian@brauner.io>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        linux-kernel@vger.kernel.org, richardrose@google.com,
        vapier@chromium.org, bhthompson@google.com, smbarber@chromium.org,
        joelhockey@chromium.org, ueberall@themenzentrisch.de
Subject: Re: [PATCH RESEND net-next 1/2] br_netfilter: add struct netns_brnf
Message-ID: <20190606151937.mdpalfk7urvv74ub@brauner.io>
References: <20190606114142.15972-1-christian@brauner.io>
 <20190606114142.15972-2-christian@brauner.io>
 <20190606081440.61ea1c62@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190606081440.61ea1c62@hermes.lan>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:14:40AM -0700, Stephen Hemminger wrote:
> On Thu,  6 Jun 2019 13:41:41 +0200
> Christian Brauner <christian@brauner.io> wrote:
> 
> > +struct netns_brnf {
> > +#ifdef CONFIG_SYSCTL
> > +	struct ctl_table_header *ctl_hdr;
> > +#endif
> > +
> > +	/* default value is 1 */
> > +	int call_iptables;
> > +	int call_ip6tables;
> > +	int call_arptables;
> > +
> > +	/* default value is 0 */
> > +	int filter_vlan_tagged;
> > +	int filter_pppoe_tagged;
> > +	int pass_vlan_indev;
> > +};
> 
> Do you really need to waste four bytes for each
> flag value. If you use a u8 that would work just as well.

I think we had discussed something like this but the problem why we
can't do this stems from how the sysctl-table stuff is implemented.
I distinctly remember that it couldn't be done with a flag due to that.

Christian
