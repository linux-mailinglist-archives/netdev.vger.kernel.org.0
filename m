Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C783DBDDE
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhG3RjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhG3RjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:39:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF429C06175F;
        Fri, 30 Jul 2021 10:39:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id qk33so18081852ejc.12;
        Fri, 30 Jul 2021 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rLir4FWjvOp6ZJf+cfDSNyFMYsW5UypVa5Nv92w1F70=;
        b=MAJGdguNvpPgy1tNMEq8I/UA3VztX5ISiW9NO7tWm6lmm2BNH9IZYEwE8DZK1XP9BQ
         2nupAb0ChgKGyhlqvUiJD8ppQGd4sYA3V4F2dMRXWs0tUMNMYsrdd5KmyVZ115teX52w
         zJrxGie4O0qL2RLzKADXuq7I31OTLJLoA5ucT2uJa1/PANbfcl67joxrQImy5HNNe8cq
         CYjGqT3hb0tcbVIOrd/owvLrHlYmUVQE6IVRAq7JAAc93/8gCZBxsJ8XcGychuvQ1yV6
         LOL37mlhXA8Od/mzZ4fyB4PdmsrTftEXLyW/WUX+4rYmuhNz0U/2IkNfm8JVOTvys6fW
         Os6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rLir4FWjvOp6ZJf+cfDSNyFMYsW5UypVa5Nv92w1F70=;
        b=kgW6OfaHGWOdE7aldllCHDRHCL117u6JHmJDmcaSN7ObwmKlw9E3GKcA/FlstBN6qz
         CqURgJ36VRLSpTXv3mGkKVKs4tbF7aMRjjy4Ekjf/TYXz+AOXl0/Bc6N5OLhiPOLMoxF
         xGFqPPqCfiSsimT3dWpvOQCPXVLkbPPbzossSmPjmGHMgb5Dn28Qf1jp05xjSXiPl/Cl
         ZgPPxMAPa7Aw8FhL0HTtegk+puPo1aTNm05IJq1bFxyJkvBTQoqV6PWBNJpIxRVfATlQ
         Va7idwvNHn9Egv6WhmgYLircnLs345CgC2GjT7Stk9yiHZAXm0cz875aaj0favn4s/8n
         pzxQ==
X-Gm-Message-State: AOAM532MPwoCLXJheyUZaUkEV+EOwXeSM2aGNryzSz0cQSNJA04ywSuH
        3JJa6q9oOoXymukx/fXx/dg=
X-Google-Smtp-Source: ABdhPJyMG0+p7JQgo8gwHHSpkpQyBLmzs3tjsdlTyDsl3fj9i3VhlEWin5b66qk2eHuHcPTAx+OYQA==
X-Received: by 2002:a17:906:9c84:: with SMTP id fj4mr3591329ejc.274.1627666744344;
        Fri, 30 Jul 2021 10:39:04 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id s3sm792678ejm.49.2021.07.30.10.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:39:04 -0700 (PDT)
Date:   Fri, 30 Jul 2021 20:39:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on
 transmit to standalone ports
Message-ID: <20210730173902.vezop3n55bk63o6f@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
 <20210728183705.4gea64qlbe64kkpl@skbuf>
 <20210730162403.p2dnwvwwgsxttomg@skbuf>
 <20210730173203.518307-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730173203.518307-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 01:32:03AM +0800, DENG Qingfang wrote:
> On Fri, Jul 30, 2021 at 07:24:03PM +0300, Vladimir Oltean wrote:
> > Considering that you also have the option of setting
> > ds->assisted_learning_on_cpu_port = true and this will have less false
> > positives, what are the reasons why you did not choose that approach?
> 
> You're right. Hardware learning on CPU port does have some limitations.
> 
> I have been testing a multi CPU ports patch, and assisted learning has
> to be used, because FDB entries should be installed like multicast
> ones, which point to all CPU ports.

Ah, mt7530 is one of the switches which has multiple CPU ports, I had
forgotten that. In that case, then static FDB entries are pretty much
the only way to go indeed.

I am going to send a patch series soon to convert sja1105 to assisted
learning too. It doesn't support multiple CPU ports, and it does have
hardware learning on the CPU port, but it can be arranged in cross-chip
topologies where each switch has its own CPU port, so from DSA's
perspective, it is as though we are dealing with a multi-CPU port switch
(the DSA tree does have multiple CPUs, in fact).  I have been
obsessively testing this configuration for the past few weeks and I
think the assisted learning functionality works fairly well by now.
