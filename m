Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF3234BF7C
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC1Vxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 17:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhC1VxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 17:53:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5442DC061756;
        Sun, 28 Mar 2021 14:53:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a7so16487369ejs.3;
        Sun, 28 Mar 2021 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9uUIeFqykD3mIdpURPO74mzbtwGDbOUFi60bDCyMdr0=;
        b=bAyjqMHNZIGEAV35IwIQitHj3X6hTqoJN5E4WWvGIasb5CRLgoQQ1yHPo7J6hKFRrG
         NTKXe9lVCoAvhXUPu9ZNI0BO8Yo+C9QwTbIbdGPs4BA6AyEeuUNff6upS30k42AbU/Sj
         XRCvNi5ccOhgc/nhMWDGj0c9SoTPXaemaEs8UgRwipkeJbrMI7rB6o1PUlsRtPp1W3on
         MFfkIqUjM+emcQ2sWFNIN0niK2FF3UHV47vWj54QToU/H2rXNUpTM+O4Ooq1XGe9z1MY
         xSGRwFzrgnyg++5XkCjbQHwNNMN4AjLKntj03FYBddXqfkziFzDxEfX//UPxl9Z7l6E/
         fqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9uUIeFqykD3mIdpURPO74mzbtwGDbOUFi60bDCyMdr0=;
        b=jDXRrTdQMQdX5/LKjj48y2hdaievxx00p90WNZRwLZpKRGi1oSEMe7C+PSBG+dYiI6
         2nl5xFfeKVqhpHu8A7slPD1LVh50ashrHiRjE1++fekOypFIbS3t4xf8EYale0cKPz3a
         p9TPmGeiIiIegigZqv7M+N13HDpNBHDDJz1wRVLFJ9ByoJQ9JniKxDbSC5xrsiRMBIki
         hlbCuhQvTQUMp9CbQZjSRNf9D3lFLX1zUFqIvY+rqJ2al5FCIuk+9aJIPzsrqj7QlgE9
         Bmx0GDZOnjesCgfC/OpgjCOQoUvOLIsCjMFl39CQBXSw4WOOad53MexOiJKeSx5yvidf
         4+/g==
X-Gm-Message-State: AOAM530m+0HQcv+zbohba55NzN7gGmAwWwa4RBxlycgOSNjansL0v4ll
        FHwX/Sd9XkL4Si2C1sopcY4=
X-Google-Smtp-Source: ABdhPJzWjPn3IMXCh/zVRGebZp4yRf4xw+iN22nBX1qMIO3SlYMwpuLVlMorQpUv1njBDVSYIgAEZg==
X-Received: by 2002:a17:906:1408:: with SMTP id p8mr25339378ejc.89.1616968391092;
        Sun, 28 Mar 2021 14:53:11 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id lm24sm7132644ejb.53.2021.03.28.14.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 14:53:10 -0700 (PDT)
Date:   Mon, 29 Mar 2021 00:53:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <20210328215309.sgsenja2kmjx45t2@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
 <YGCmS2rcypegGmYa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGCmS2rcypegGmYa@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 05:52:43PM +0200, Andrew Lunn wrote:
> > +static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
> > +{
> > +	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
> > +	struct dsa_switch_tree *dst = ds->dst;
> > +	int port, err;
> > +
> > +	if (tag_ops->proto == dst->default_proto)
> > +		return 0;
> > +
> > +	if (!ds->ops->change_tag_protocol) {
> > +		dev_err(ds->dev, "Tag protocol cannot be modified\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (port = 0; port < ds->num_ports; port++) {
> > +		if (!(dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port)))
> > +			continue;
> 
> dsa_is_dsa_port() is interesting. Do we care about the tagging
> protocol on DSA ports? We never see that traffic?

I believe this comes from me (see dsa_switch_tag_proto_match). I did not
take into consideration at that time the fact that Marvell switches can
translate between DSA and EDSA. So I assumed that every switch in the
tree needs a notification about the tagging protocol, not just the
top-most one.
