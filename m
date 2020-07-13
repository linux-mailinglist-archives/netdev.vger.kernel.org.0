Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEB821DA3E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgGMPif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbgGMPie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:38:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC63C061755;
        Mon, 13 Jul 2020 08:38:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t6so2505276plo.3;
        Mon, 13 Jul 2020 08:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EkuY5nTWtYjHN6dlAxhuSPoKlCvkK/wdqr04aL31t4o=;
        b=A+JNrFxppxl73xfHd+hlQqaFZfE2iKKbu7A43CSIk8a5+LopIJtGENZPiCYhgs/gyX
         /8KkoSDz32K4LCHddQAx34yTodb28lKG6+eZUiVfbCGajqhc7SlLoj/oKtj2b1uzK7Ps
         64lGg6lN4nV28DYLPGjA+ZlLA1XTw5qqT1BOShmQxgN9ISQFYWv94rajZkK0eHJKfeVp
         rCjyCz/ybWcP87gDBjCJ7QfNleYSJrut+ARdSQRILVPJ8N9H2NQ1CVX5YbZq9zQ8Hxy6
         I9j/yVUrlyoSUYP4OqqfZI6d08SwFtXXfgskPDEhc8iM53Kkias6nfv/lzUGYiIVQ3to
         6+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EkuY5nTWtYjHN6dlAxhuSPoKlCvkK/wdqr04aL31t4o=;
        b=bYFDyrmurceX4efQ2gET3PfomCSeF/dcYT2yuQliavyVqXaHfNp9HJuwxwC5IlKGEU
         rqpG0XJQ9XVvhsXN8fW5fdYo+HF8eFrPpQLB2Z6FJyJ6BYZIRA5Gvp1fYvXPfsiLCQ68
         DF5RK3bb6bUyscruqHy+xRHTYDhWWN0PPV+FjosZ/qWfAGelCARa46lNAHlW5caMK60c
         RmVPWkCGKMausn1OLl4F+TN6eZDNaxONhWOObcudvtw5bQ4DKa/+GvmYsvxG4sXKQVQ+
         tA4dccCc6qFfSCHTGO1c1jf7NRI7yzMyebCNkJBRuXOCMVYhAAcumzSq4hYla2Ig/zvO
         /3UQ==
X-Gm-Message-State: AOAM532aXi4bycbJHXKEjkS750vgZgi5e81+SGyxL5w3JZc8kUIwoLYC
        1884BDxr/qkSRdNo/lQIGcY=
X-Google-Smtp-Source: ABdhPJy0kUiywZaC/bxx58Daz314s+l4aZe3uztdWBi8TKRWWU3gTwcr1gL27+OzebJ20UptMK4uEw==
X-Received: by 2002:a17:902:7484:: with SMTP id h4mr174821pll.243.1594654714276;
        Mon, 13 Jul 2020 08:38:34 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q13sm16050804pfk.8.2020.07.13.08.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 08:38:33 -0700 (PDT)
Date:   Mon, 13 Jul 2020 08:38:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware
 timestamping
Message-ID: <20200713153831.GA29291@hoboy>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-5-kurt@linutronix.de>
 <20200713095700.rd4u4t6thkzfnlll@skbuf>
 <87k0z7n0m9.fsf@kurt>
 <20200713140112.GB27934@hoboy>
 <20200713141217.ktgh5rtullmrjjsy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713141217.ktgh5rtullmrjjsy@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:12:17PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 13, 2020 at 07:01:12AM -0700, Richard Cochran wrote:
> > I don't think it makes sense for DSA drivers to set this bit, as it
> > serves no purpose in the DSA context.
> > 
> 
> For whom does this bit serve a purpose, though, and how do you tell?

It had a historical purpose.  Originally, the stack delivered either a
hardware or a software time stamp, but not both.  This restriction was
eventually lifted via the SOF_TIMESTAMPING_OPT_TX_SWHW option, but
still the original behavior is preserved as the default.

You can see how SKBTX_IN_PROGRESS is used by the skb_tstamp_tx() path
here:

void __skb_tstamp_tx(struct sk_buff *orig_skb,
		     struct skb_shared_hwtstamps *hwtstamps,
		     struct sock *sk, int tstype)
{
	...

	if (!hwtstamps && !(sk->sk_tsflags & SOF_TIMESTAMPING_OPT_TX_SWHW) &&
	    skb_shinfo(orig_skb)->tx_flags & SKBTX_IN_PROGRESS)
		return;
}

It prevents SW time stamp when the flag is set.

Note that DSA drivers deliver TX time stamps via a different path,
namely skb_complete_tx_timestamp().  Also, DSA drivers don't provide
SW time stamping at all.

Q: When should drivers set SKBTX_IN_PROGRESS?

A: When the interface they represent offers both
   SOF_TIMESTAMPING_TX_HARDWARE and SOF_TIMESTAMPING_TX_SOFTWARE.

HTH,
Richard



