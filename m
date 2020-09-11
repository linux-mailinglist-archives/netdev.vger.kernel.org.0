Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00459265BD4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgIKInM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgIKInL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:43:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1E7C061573;
        Fri, 11 Sep 2020 01:43:10 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k15so10615201wrn.10;
        Fri, 11 Sep 2020 01:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s+k37vDOAFxkHUtEO8otqVl72Kv7/m+MnZOCdDAFY/o=;
        b=AzlNb3VSLO+m0/csJGC/zbcrwXZ/Q8yGtxKeLXUrKYH3mAPOCycql8VnT1MHofoZcl
         ABGWV+Ws+/MLt7JL+zrbMncEYeJkqR1IhtC6Yf84dRBpiR1G9g3YE2qwhL21zGCLS13Q
         r0IcZ0MzlpxrfV6lqz8Jcbp4RLphzw23zwSxyRO8lWGjwyY5/j1xW4nyE7joXJ8wKn5r
         8DjrG9fv6N+hN55Mk1FP9UWtWvvTtgPfWFZw8CIB6qyBQhDfg8vhIYd1+PdWnWDIyXR9
         kg6rd6jH88FfJ1amPyTP0RxvSAmOhRRHYWQzQrKtMcub7/xH0I3ayWjooPDQbbeM1KPv
         C1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+k37vDOAFxkHUtEO8otqVl72Kv7/m+MnZOCdDAFY/o=;
        b=HiDkJsTcRL0cyYpSfwkDl6TfYzs4xUtS98hh9cn4rrav9wdSd7aAXwX48+rZuzxo7u
         AVbQ9D0NGMbzevdifVrBOGAH/RmVOnTmqu2T1W9BhyEPNVGXg6S6Emodb75BLFQk14MX
         CmjF5cFKrOP2TC5vUGlKevVLkNib/9YO5kb5wfkr1zBcqNkWo97mgvPbQNCGZ/0O5G83
         dOsDOaPOuUZv1+kr2Oe6ca5YjrkoHRKibsP3VbSwSqHV5rFk1VN1/vqXMCMf2ouRH8RB
         w3ujIPSsVChtdbpUVruA0oQKqFC1+RIxXuOqffG3u85Tz+tGhOPy8ofQcAd4haNa+Ky/
         NpgA==
X-Gm-Message-State: AOAM5333tey8+z6J/hcupzKTYa6bTFWvyZmA5GBQUNPbdpcM+tcZy6L3
        yLsbWnA/3DbZ2srae9LR4eU=
X-Google-Smtp-Source: ABdhPJyHj/iTMwS1jhMk+VWB9BMRjZplIQFoOmp6Ra5OHrwaFGxVFygbuaFRszGBNJZxurLRRNyk6Q==
X-Received: by 2002:a5d:6301:: with SMTP id i1mr877075wru.323.1599813789391;
        Fri, 11 Sep 2020 01:43:09 -0700 (PDT)
Received: from andrea (userh713.uk.uudial.com. [194.69.103.86])
        by smtp.gmail.com with ESMTPSA id 92sm3358580wra.19.2020.09.11.01.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 01:43:08 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:43:01 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] hv_netvsc: Add validation for untrusted Hyper-V values
Message-ID: <20200911084301.GA14414@andrea>
References: <20200910124748.19217-1-parri.andrea@gmail.com>
 <BL0PR2101MB0930659825AD89FF5A8DC2C4CA270@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB0930659825AD89FF5A8DC2C4CA270@BL0PR2101MB0930.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -740,12 +755,45 @@ static void netvsc_send_completion(struct
> > net_device *ndev,
> >  				   int budget)
> >  {
> >  	const struct nvsp_message *nvsp_packet = hv_pkt_data(desc);
> > +	u32 msglen = hv_pkt_datalen(desc);
> > +
> > +	/* Ensure packet is big enough to read header fields */
> > +	if (msglen < sizeof(struct nvsp_message_header)) {
> > +		netdev_err(ndev, "nvsp_message length too small: %u\n",
> > msglen);
> > +		return;
> > +	}
> > 
> >  	switch (nvsp_packet->hdr.msg_type) {
> >  	case NVSP_MSG_TYPE_INIT_COMPLETE:
> > +		if (msglen < sizeof(struct nvsp_message_init_complete)) {
> 
> This and other similar places should include header size:
> 		if (msglen < sizeof(struct nvsp_message_header) + sizeof(struct nvsp_message_init_complete)) {

Thanks for pointing this out; fixing for v3...

  Andrea
