Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3163A2662FF
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgIKQI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgIKQIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:08:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6446AC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:08:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so1919988pjb.2
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=izrzznmOoirVUIUera9Lalk6QOtGypN3++OJeh5FIuY=;
        b=NCB7T0mLQKHt6WV9aA711VsYPNdi8QsdC+ncR4NSwi9m3o15RBaaFLUM7PoWNaI+uG
         te9N3N2D1CV3GWG1YKBNuhCZVdHTRavD5W0E6haOPXu/ebx9gMnyKuDUtXjxRb2guHGK
         pKR5cWpMiFoThQDinJK/3oNAqYkAVDuPiJL8Oh/DF1MjFfhhQj9vKN7BpxfquUL9if1c
         LLVMAZu2xnxsbmP4a2XmIo1NpnTPzW1TD8RhvVQioJHgkmK86GSzfXmmBs757hdonrRK
         MwVF33tLId5eexNvxgpAJw+dJGyvgnVAcmaeAGNOhnKpHFRrnqrhJYRO5pS2S0zC+YXX
         QoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=izrzznmOoirVUIUera9Lalk6QOtGypN3++OJeh5FIuY=;
        b=Qk82C/qu6XLSXsNR15ae7LHrIf4+wJVn309H4fN7ptcOLRfXfI46YwhCIfILuAGE/M
         qUYf2nWeNVwlFQVUNq1OCMzXxOkpn586+dIa4h2NsJy9WlmpOo3PeLmWqOEDf9E6A5nT
         vUzdT72RrN2yFVKFrjNgUET6uTqTjH/B0kgcfTBy00oXt3v5LWrzfod9ligUN1YOX0Vc
         XgzSswPvmmeSEDApcWwXhWiHtFOKg5U3lhYtHv2iaOOBnup/s01Kli/KJ/wuMClNfnKv
         EP15szkoAIpK8jK2bIEj2WnhGj24yKdmLzk1hMRIyjNrJp6JChZUN/3QZff6t8usDG5E
         H5Cw==
X-Gm-Message-State: AOAM5327YyRfEJOdLzT7w3KomuS5l5xCZR0oTo8JUelAvw+VLLU8rRYK
        WIwK+XN/eVWCyZ5dQ8FRKCI6qNZdiPE=
X-Google-Smtp-Source: ABdhPJwDcEWntaQjqHLFQX1IgVW4+b5WmlVLcc6QVZ8J4dipLbYqMWAnf2fQanwTDtbDaSivLRC/8w==
X-Received: by 2002:a17:90a:474c:: with SMTP id y12mr2685842pjg.150.1599840522872;
        Fri, 11 Sep 2020 09:08:42 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f4sm2748583pfa.125.2020.09.11.09.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 09:08:42 -0700 (PDT)
Date:   Fri, 11 Sep 2020 09:08:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: mvpp2: ptp: add support for
 transmit timestamping
Message-ID: <20200911160839.GA3559@hoboy>
References: <20200908214727.GZ1551@shell.armlinux.org.uk>
 <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
 <20200909180047.GB24551@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909180047.GB24551@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:00:47AM -0700, Richard Cochran wrote:
> On Tue, Sep 08, 2020 at 11:00:41PM +0100, Russell King wrote:
> 
> > +static bool mvpp2_tx_hw_tstamp(struct mvpp2_port *port,
> > +			       struct mvpp2_tx_desc *tx_desc,
> > +			       struct sk_buff *skb)
> > +{
> > +	unsigned int mtype, type, i, offset;
> > +	struct mvpp2_hwtstamp_queue *queue;
> > +	struct ptp_header *hdr;
> > +	u64 ptpdesc;
> > +
> > +	if (port->priv->hw_version == MVPP21 ||
> > +	    port->tx_hwtstamp_type == HWTSTAMP_TX_OFF)
> > +		return false;
> > +
> > +	type = ptp_classify_raw(skb);
> > +	if (!type)
> > +		return false;
> > +
> > +	hdr = ptp_parse_header(skb, type);
> > +	if (!hdr)
> > +		return false;
> 
> At this point, the skb will be queued up to receive a transmit time
> stamp, and so it should be marked with:
> 
> 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;

Russell, since this series went in already, can you follow up with
a patch for this please?

Thanks,
Richard
