Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608D746C80A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhLGXSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242411AbhLGXSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:18:23 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDDAC061574;
        Tue,  7 Dec 2021 15:14:52 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so2129268edv.1;
        Tue, 07 Dec 2021 15:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RPog8CITgy/pVwIm1Iz97LmWJz3Ng5W1QmgnQYXTdJU=;
        b=JkOO/PfPVBoQQJ/9wXtWfJupjBUfXDmfisRQPyIQMd5vBiUdv+C6DfopWklGEYpkog
         ZcbwZSWQtK/K8u/Jk6fYaljW8LQWAffIvvACu8SwXh8td+/r641im1EuvD75vQ+/JcA1
         7ivqrvIfbALuzN+/+MEoS8uRylXfnf48/md7P98LG7PDRTUw5/MzdfwTCjXU3YmYjTs/
         xGHsHCCrqhNwAswUb+PMVIbnDs0ohTVyF2JHBgHtH0vYZNajQv6VsqcEK2SFtH33D1ba
         aP2RWMW8j+p+lAtshwzDPzkpu3wexHpGvPhFpCPEq+DUHG4yuJgZkPtzQqBEFhcIee+c
         gwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RPog8CITgy/pVwIm1Iz97LmWJz3Ng5W1QmgnQYXTdJU=;
        b=EgCHGplLu6bngPtKLvVQHHR7XdgHIos58WkO+4Y57evhiFY5HKSXLZSUtdTdeXnP+4
         SK+T+n0/yLbZ7Hol+5eoGdHASpo9gfJ55d4NYMjgV0kw3OMW9+5HQM5FyPydZx2z87zt
         PlB+sTtiX2pg9Pg8HMa0ey9D5u/9f/1pc8+tvMVe7apIBNMz4mXtuiYFkYsBLVXWaxDv
         TbypKx/cmk3DetmxvgiVRkuH3gEdWDlcr6b9AWYtw77GjXEtAi1e3kfwLZle/cwZ5wgT
         W3ZeNogRtP2UM6p2lqZHcLCYYs32J55KhudJOZuWu2Z1wZG/AWAKF7wOLkIwkA+rJGdT
         QIdw==
X-Gm-Message-State: AOAM532iVh7GmIF0erUxXgYfl7BwVATWyIQc7npunLY8KgcBweQWkM0V
        ypxqdipUSBSe0XAVVfd4lcI=
X-Google-Smtp-Source: ABdhPJweMD9Gnr3TxVSoNgSUkV7qjWd/EozhpC73K4CbCMJTFv1CMZnvjzsxlze5eL7DqjXOkWJKEA==
X-Received: by 2002:a05:6402:1d50:: with SMTP id dz16mr13397884edb.385.1638918891347;
        Tue, 07 Dec 2021 15:14:51 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id qk9sm482567ejc.68.2021.12.07.15.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:14:50 -0800 (PST)
Date:   Wed, 8 Dec 2021 01:14:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207231449.bk5mxg3z2o7mmtzg@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <Ya/mD/KUYDLb7qed@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya/mD/KUYDLb7qed@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:54:07PM +0100, Andrew Lunn wrote:
> > I considered a simplified form like this, but I think the tagger private
> > data will still stay in dp->priv, only its ownership will change.
> 
> Isn't dp a port structure. So there is one per port?

Yes, but dp->priv is a pointer. The thing it points to may not
necessarily be per port.

> This is where i think we need to separate shared state from tagger
> private data. Probably tagger private data is not per port. Shared
> state between the switch driver and the tagger maybe is per port?

I don't know whether there's such a big difference between
"shared state" vs "private data"? The dp->priv model is flexible enough
to support both. For example, in tag_sja1105, dp->priv is a struct
sja1105_port. All struct sja1105_port of a switch have a common struct
sja1105_tagger_data *data pointer. We could certainly set up the
tag_ops->connect(dst) function to allocate memory in this way.
