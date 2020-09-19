Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFDF270F47
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgISQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 12:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgISQHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 12:07:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBDFC0613CE
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 09:07:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s14so5353465pju.1
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 09:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZR/lqqajwyWKNJqtftB0KtyLuIJGNg2DKJiHLO/BNw=;
        b=WtGUlFfjNHJVYEt1ERCWn/Cbod6m7ovuz/GQfRIOXmQkjfObeyD9iQecdR+BIcnlrM
         83pWqCjIJNT9bXcDSEZEYdMWWhM84Eu682mW9l9wy9zXePipzRDGpujperpWahqcWlL8
         +/8BAiAqyzzPpg5ahGr2HVWrXy/ugN1bOHOJjK292xvLcPDsuAjMb7I5mKlhvLr6vSoB
         xbVWxikkosYZ8XA9kb1Ch11pTddktOkrFMCFqOIaEvaY/hCkhE/xd94Xp+kHx38DzMEv
         4uzx7bfMtUcyZL3G3nNiOcbwB7lLJwY01hqN4MqjQDiMD7PVzcOCvggbrBr4RdpbDKlT
         MfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZR/lqqajwyWKNJqtftB0KtyLuIJGNg2DKJiHLO/BNw=;
        b=gtwssIsVN9diWhz3Ku/ioev5zFeXQBkrqxmIMCZ8s6NAGAVfL6u1CeWNu6AUQcSN3w
         BNBojA1FkmNb14Bog1hqMPS7cK3tyXAIMJG+q4xwV7M2yfMMOj9Z0b1n+Xh1kFffk+Gr
         fBmwf3jTSpK1YhCxnDfjRGXOZAnNHUPcQYVp1bmA4YkiJ8RY3Z4p9klegv9ZvyDr8qpP
         ef6MVnuAOxfQdm95x8TpNmj7XeAB9CUTnHtEyAs/mKhIEtpja4pwdio5XFPzJU39ik0S
         /gARxinh4/N4REKdtIJYOAdofCWDZWBIvgaAob1DAALjUuw+XVNHh+oMLb/1y21nvGV2
         XuyA==
X-Gm-Message-State: AOAM531XRH14Tgb/WcgJZEvw3xzkjjPJyDatillmEO6PLxv32gjFiesa
        6FcjYGHiShYqwA7BmVurXSWxiQ==
X-Google-Smtp-Source: ABdhPJz7YxO14gK3SOp7V1Y92HD/U3s5xmV0Po5u6tSIZi8/DRxswY+gWT/pRfq9yhTft03v/z/V6A==
X-Received: by 2002:a17:902:2:b029:d1:7ed9:613f with SMTP id 2-20020a1709020002b02900d17ed9613fmr38389837pla.32.1600531626958;
        Sat, 19 Sep 2020 09:07:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i17sm6856508pfa.2.2020.09.19.09.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 09:07:06 -0700 (PDT)
Date:   Sat, 19 Sep 2020 09:06:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
Message-ID: <20200919090658.02c9f5f0@hermes.lan>
In-Reply-To: <f936dedf-ee3a-976c-c535-55a2b075b37b@gmail.com>
References: <20200916194249.505389-1-kuba@kernel.org>
        <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
        <20200918084826.14d2cea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f936dedf-ee3a-976c-c535-55a2b075b37b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 22:52:56 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 9/18/20 9:48 AM, Jakub Kicinski wrote:
> > On Fri, 18 Sep 2020 09:44:35 -0600 David Ahern wrote:  
> >> On 9/16/20 1:42 PM, Jakub Kicinski wrote:  
> >>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >>>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
> >>>     RX: bytes  packets  errors  dropped overrun mcast
> >>>     6.04T      4.67G    0       0       0       67.7M
> >>>     RX errors: length   crc     frame   fifo    missed
> >>>                0        0       0       0       7
> >>>     TX: bytes  packets  errors  dropped carrier collsns
> >>>     3.13T      2.76G    0       0       0       0
> >>>     TX errors: aborted  fifo   window heartbeat transns
> >>>                0        0       0       0       6
> >>>
> >>> After:
> >>>
> >>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >>>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
> >>>     RX: bytes  packets  errors  dropped missed  mcast
> >>>     6.04T      4.67G    0       0       7       67.7M
> >>>     RX errors: length   crc     frame   fifo    overrun
> >>>                0        0       0       0       0
> >>>     TX: bytes  packets  errors  dropped carrier collsns
> >>>     3.13T      2.76G    0       0       0       0
> >>>     TX errors: aborted  fifo   window heartbeat transns
> >>>                0        0       0       0       6    
> >>
> >> changes to ip output are usually not allowed.  
> > 
> > Does that mean "no" or "you need to be more convincing"? :)
> > 
> > JSON output is not changed. I don't think we care about screen
> > scrapers. If we cared about people how interpret values based 
> > on their position in the output we would break that with every
> > release, no?
> >   
> 
> In this case you are not adding or inserting a new column, you are
> changing the meaning of an existing column.
> 
> It's an 'error' stat so probably not as sensitive. I do not have a
> strong religion on it since it seems to be making the error stat more up
> to date.

Is there any way to see the old error column at all?

