Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B176688315
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406394AbfHITB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:01:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41579 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHITB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:01:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so1790927qkk.8
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 12:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pK29k5Iyti2pPb24QjihZ6SDVTvLWzzTGcTq6Ruaqps=;
        b=VtuSGSq80sWjktPKGCW0ndOHndy87WSNTtCEYSadq/yPIyVg+L39tbnMfxocB3QYdb
         LUXyVCt/X3HIapb9Fum4VMYE6/jkX3R3SGIc9j8cKCizTLCYh1YTAtsooGURiWUk5OT1
         Mdbl3fVYWTCje2N3IeAY0HNgiZ8BJMGJUHwLc4h80Xz3l/Yk8ZUqK88QbjefEXde0GQX
         PrF48z1fZKE0wVoSN13tieF3ofjD91TVEkhgOAPyUZR+db9Wtqa+6qAKOq1/cJIK1mNG
         HcWXs+xAb6hPBdUhO7fdgmd60N95S+O8tpYq9Dfp41bPKbcbBVFJMQ/0yb22+JesIGjY
         zhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pK29k5Iyti2pPb24QjihZ6SDVTvLWzzTGcTq6Ruaqps=;
        b=HE1wvHba2AQFQwJ17uO84DWx8NCOABgVg4Fftho36ix4tkWdL/eWW4vR/qWmGelj5B
         Cv7v9Rogz5rOEX5MYEjPUXvOJnDrFxjs2gHDeRW5I4gt+bdKHO01iCiAHwViFyZKpQ08
         RH5aglml3NXepyW+Q/yIG1AzWi8dfGB9m/iT1DfewNOzyYRU4+kppKWJzRXLQNl+iEGn
         5l39XLVzOL7BsJs/YFjvei4M6+LsKUJl4VEjJnIO0hNwSl2RAqfW0vlM5Xf3vXW0C4v6
         sCkDb4YtRi6KJpe99cjw3gxnMtxWMm53XbwJqHGNuqQvyxjzg8tvJbQ2YKX1C/c1E7FR
         6LYg==
X-Gm-Message-State: APjAAAU4dvjiKHBbQu7Zfn/0n6lsylDeDsSpKl5G8QZVRw/thrgr1ujy
        I+c5vLZ7ZTz/rHE7aTxIy5IfNKYq4Kg=
X-Google-Smtp-Source: APXvYqzlBSs7wWHcrAm71bex6+OksaI4whyhKr1jhSZrU58vsI/wx4u7bsBvyoITxr8XYf1wf9xTOQ==
X-Received: by 2002:a37:c12:: with SMTP id 18mr18016603qkm.331.1565377286169;
        Fri, 09 Aug 2019 12:01:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g35sm52998676qtg.92.2019.08.09.12.01.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 12:01:25 -0700 (PDT)
Date:   Fri, 9 Aug 2019 12:01:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets
 for ARFS
Message-ID: <20190809120123.5506217a@cakuba.netronome.com>
In-Reply-To: <02ebed305b6bb50f272c7f3decfa204dc72311f0.camel@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
        <20190808202025.11303-2-saeedm@mellanox.com>
        <20190808181514.4cd68a37@cakuba.netronome.com>
        <02ebed305b6bb50f272c7f3decfa204dc72311f0.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 18:49:50 +0000, Saeed Mahameed wrote:
> On Thu, 2019-08-08 at 18:15 -0700, Jakub Kicinski wrote:
> > On Thu, 8 Aug 2019 20:22:00 +0000, Saeed Mahameed wrote:  
> > > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > 
> > > The current ARFS code relies on certain fields to be set in the SKB
> > > (e.g. transport_header) and extracts IP addresses and ports by
> > > custom
> > > code that parses the packet. The necessary SKB fields, however, are
> > > not
> > > always set at that point, which leads to an out-of-bounds access.
> > > Use
> > > skb_flow_dissect_flow_keys() to get the necessary information
> > > reliably,
> > > fix the out-of-bounds access and reuse the code.  
> > 
> > The whole series LGTM, FWIW.
> > 
> > I'd be curious to hear which path does not have the skb fully 
> > set up, could you elaborate? (I'm certainly no aRFC expert this
> > is pure curiosity).  
> 
> In our regression we found two use cases that might lead aRFS using un-
> initialized values.
> 1) GRO Disabled, Usually GRO fills the necessary fields.
> 2) Raw socket type of tests.
> 
> And i am sure there are many other use cases. So drivers must use
> skb_flow_dissect_flow_keys() for aRFS parsing and eliminate all
> uncertainties. 

Looking at the code now it makes perfect sense. We could probably
refactor to call the dissector in the core at some point.

Thanks for the explanation!
