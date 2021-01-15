Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A972F89AA
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAOX4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbhAOX4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:56:30 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E8BC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:55:49 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b2so11412498edm.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rmy7eDUAKJVTH1hR3pF8K5Bg8E3k1iDNIr4A/Q6N9A4=;
        b=BPMwQMcFVu0aRYzogfUwDHCEn/4LNqoe2k1nhEfWHSXqC2ReEPqFytT4Upe6HfLMwP
         FKJw12DNTndhwAWMgazlp6ighGcU4VIiP8sf7ZY+X1eKly7XoYFv/juxqJIyilVZew1q
         EjFdI7DnC8RHlRSAg49M5+pz9dWyWR4fhVqsGFMsfJTfwyKKqo0iaMjvEL359CHMwkmm
         bGRdrSjfYkRS/sZd+ew6Vh2wKAlfHolbe0+/nYbSHLTzbYXqECYYz9IHLqoeqjUlRrQw
         jmmLMS/Xw7hlmYUvKjrqXq+rAhpJ+dIDrXLa/kQasQH2oXzNZvigzpeELLtr9iheBkKj
         1kew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rmy7eDUAKJVTH1hR3pF8K5Bg8E3k1iDNIr4A/Q6N9A4=;
        b=MJlgfEkbn7MfHtXl2HbhT1FkjicIf+7nlkz7abS4baTZCUap3mCASkq0dcQoKYQKSb
         4XPqxIf8e/KqwioIfx2vSGM483iuNVmWq2qusP6v55x4teN+B/9OFRmJAHIrZSGU2b6D
         TVdHRC64bGkaWQegwAF3b+L1aPBXlGDKQT0mQ7dLs/AjixgID/uy4ILZOq5nN7YtA4Xr
         dbQE87qZFJAiECm1UV+62Q2eMVCicZfeJnIP0seZlhU2S4Hsg8oVyF3pHCRaxVHIpVZ2
         QyvzhvgjoULCKfS/beXdlFOlQUmjbID4q+nPIy4EnrkVesArpKQwKw0DWp709ZAdB0VQ
         8F+w==
X-Gm-Message-State: AOAM532BWQHLD2LgVC0paU1T8VY7le+6oC7LcElLfatuPo6cDoNV8zYu
        HekahDHl+IM6/XnShIvKs4SI+yYHqTk=
X-Google-Smtp-Source: ABdhPJxyawr3Qo+52JkY9hvlkPh4W/skQWF8VTuqP2E8xCXJuyuPUqFVOMxlSgGRHuRUhXOMNsDzkg==
X-Received: by 2002:a05:6402:8d9:: with SMTP id d25mr11370793edz.278.1610754948668;
        Fri, 15 Jan 2021 15:55:48 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rp8sm4243121ejb.86.2021.01.15.15.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 15:55:48 -0800 (PST)
Date:   Sat, 16 Jan 2021 01:55:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Message-ID: <20210115235547.a6jrzm7arxxyctck@skbuf>
References: <20210115125259.22542-1-tobias@waldekranz.com>
 <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115232435.gqeify2w35ddvsyi@skbuf>
 <20210115154622.1db7557d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115154622.1db7557d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:46:22PM -0800, Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 01:24:35 +0200 Vladimir Oltean wrote:
> > On Fri, Jan 15, 2021 at 03:02:46PM -0800, Jakub Kicinski wrote:
> > > On Fri, 15 Jan 2021 13:52:57 +0100 Tobias Waldekranz wrote:
> > > > The kernel test robot kindly pointed out that Global 2 support in
> > > > mv88e6xxx is optional.
> > > >
> > > > This also made me realize that we should verify that the hardware
> > > > actually supports LAG offloading before trying to configure it.
> > > >
> > > > v1 -> v2:
> > > > - Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
> > > > - Simplify _has_lag predicate (Vladimir).
> > >
> > > If I'm reading the discussion on v1 right there will be a v3,
> > > LMK if I got it wrong.
> >
> > I don't think a v3 was supposed to be coming, what made you think that?
>
> I thought you concluded that the entire CONFIG_NET_DSA_MV88E6XXX_GLOBAL2
> should go, you said:
>
> > So, roughly, you save 10%/13k. That hardly justifies the complexity IMO.

That would be the first time that I hear of fixing a build failure due
to a missing shim by refactoring a driver... Punctual issue, punctual
fix, no?
