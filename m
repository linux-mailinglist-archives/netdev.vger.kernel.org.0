Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDDE301F9B
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 00:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbhAXXqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 18:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbhAXXpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 18:45:54 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FF2C061573;
        Sun, 24 Jan 2021 15:45:13 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so15422167ejf.11;
        Sun, 24 Jan 2021 15:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wHikCNAG5FYFyR/IsoRvLpRbiKDpnYK8CiW4RxJd0gg=;
        b=gteQIfljHT0Dy32fAsEpHjoAiLao8cU2FNk9onC8L6zKJiSboIpcUDbsnj5J8SOwwA
         iTqCzJUcZGU/ELK8Yp1EIfOnGriq8FFrjt3IeFmUZKYIGpIT58FbGQEoSXf4LiD3uOXj
         mfR0hnxCNWsBAMmUW+Zkr9WnwqCInjAOad77txkdB7MDuih7Oh2nLSl+r3qcvKmsZDZh
         VsSfhFUB7OKCkK791qEaPQ4Mhk8Kn/6lrMzFrw1fA9TKvxHdP7xg35Dw4yYCF2u8huZd
         5Lso3SZqDSH6xASy3t2YrzGzeBm1bRdfJSKlk+Ke+jLQZGiT5eQzCNwUmgp0BGzXmGJ5
         z2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wHikCNAG5FYFyR/IsoRvLpRbiKDpnYK8CiW4RxJd0gg=;
        b=mqC7/gQYfVqTro1pYScwJ/EsgicKwp6KLN/AhWFbVEJT94c9dNw4F6ibWXQfJpf6lh
         avH4la3F5Mjt2om39JVpTqKWmILfJWma4zmau/F4kos/iuueXsvS56rc1mHga/yvsADc
         kQHO4/wrvyOptGc0L3PVMEpwQq6gPmqM2JkM7d2On0NuAqnRivIfOMwkU5cZ+J6J3dkp
         IcOB9jOYIG/zkO1K4OhSfmR27SjS580QKdHmyENBOQVwBWHymLaDLcttnwDovCeEdVrq
         FOEUrclCI5EiiDlPMYvgg+hLs2wo4HiDCXMhoSD4xbrPJmdxGhMknFy9jmSN2FTfLc/F
         pPMA==
X-Gm-Message-State: AOAM532Q5h3yPkJEIxu1xZH0YkVI1v8oWD/SRrpOkNHYRKeS/FTu6CSG
        phvtJiWZMNjc1H0KKHEIIKU=
X-Google-Smtp-Source: ABdhPJxY4e9l4n/TSl/mCra29K0icn+/xE3vPxCVMQkUoN4OWWTD/uUPtfnFbEvPnvZ6mgLDDaSLPg==
X-Received: by 2002:a17:906:f950:: with SMTP id ld16mr856152ejb.553.1611531912011;
        Sun, 24 Jan 2021 15:45:12 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cx6sm9906385edb.53.2021.01.24.15.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 15:45:11 -0800 (PST)
Date:   Mon, 25 Jan 2021 01:45:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
Message-ID: <20210124234509.c4wkoauiqchv4aan@skbuf>
References: <20210120063019.1989081-1-paweldembicki@gmail.com>
 <20210121224505.nwfipzncw2h5d3rw@skbuf>
 <CACRpkdb4n5g6vtZ7sHyPXGJXDYAm=kPPrc9TE6+zjCPB+aQsgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb4n5g6vtZ7sHyPXGJXDYAm=kPPrc9TE6+zjCPB+aQsgw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 12:19:55AM +0100, Linus Walleij wrote:
> This is due to the internal architecture of the switch, while it does
> have an internal tagging format, this is stripped off before letting
> it exit through the CPU port, and tagged on by the hardware
> whenever the CPU transmits something. So these tags are
> invisible to the CPU.
>
> Itr would be neat if there was some bit in the switch we could
> flick and then  the internal tagging format would come out on
> the CPU port, but sadly this does not exist.
>
> The vendors idea is that the switch should be programmed
> internally as it contains an 8051 processor that can indeed see
> the internal tags. This makes a lot of sense when the chips are
> used for a hardware switch, i.e. a box with several ethernet ports
> on it. Sadly it is not very well adopted for the usecase of smart
> operating system like linux hogging into the CPU port and
> using it as a managed switch. :/
>
> We currently have the 8051 processor in the switch disabled.

The sad part of me not having access to any Sparx-G5e documentation
other than product briefs is that I can't actually be fully convinced
that this is true without seeing it. Other Vitesse switches support
DSA tagging towards an external CPU, so if these ones don't, the
Node Processor Interface feature must have been added later.

Anyhow, you did not approve or disprove the tag_8021q idea.
With VLAN trunking on the CPU port, how would per-port traffic be
managed? Would it be compatible with hardware-accelerated bridging
(which this driver still does not support)?
