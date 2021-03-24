Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ABD348483
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbhCXWVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238817AbhCXWVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:21:18 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9147FC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:21:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dm8so239410edb.2
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NBXUm2vKXZ84tMJ7ojnsB2u2e7ExNQlFn/yPklS+aW0=;
        b=NBNKCZMxwSQtoFj2SKFL9Af1YdIMmyckUjLs2kHAOKgy6S8l7Jf+4+4k2eRAujCLau
         0Kn+WKkRSiERGYQV5VTO3A5IJLZMaD6hOAelt9v4xPHPzzL34WxuVoZgfJf6vjjIBP8g
         7eaPc2YpuB1w3yzRgGnENPO9d6oKuRbC63u6E56xk0hwdORcNx2Qe7tMduHR2BLaaR6l
         tYbhWEYw4Hvrk3606Kr0ceo5sWVMvAoHoLMGaNlrzFnGSt8H09/hZRndIHx9KB5B3/Ot
         BNN/ycAL1zT8ZdCCDT+fBHDU6AacI4v18shXvpIJe7ym5f4LkfTBF+ewRo+f8RM04n3r
         kivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NBXUm2vKXZ84tMJ7ojnsB2u2e7ExNQlFn/yPklS+aW0=;
        b=NvIykMy6yDDOzsv9x/8jtR8OlxfjgY7RMPxwXTGyvOc7xCiv+ZEaO8jYFQrUvDSxdl
         g7bap/aDbOupJsOhNr4dNlI9vxlGnbA1tM8O6O6EacXS7tsCnUKSen0VUkuYVLCBGxJb
         vpwvlFu9naak6kwAt0HEPe6g6UWurHk9N+hzKmiquDjkg+pPuWjmOpTrUdUTLGa0czbd
         ieVDPyLKJITdpSO0xQql+HhEvekN6bDJSrhHtI9A5WYviLGaZapqcVh1D7nmlstJ6IeQ
         QamModU/+RzgtYBf3tUOstrpkQA5Zns1E0HEOiarHVpmNpsV4ej00Ju3ngbwSpbH+gov
         4fXQ==
X-Gm-Message-State: AOAM532rVJnq9ugg4E5A+OElkpD+rJJyz8IJftIEafYCwr7ia7TXyB9T
        LpfUD0Y6HdvMnvroA+o9ql4=
X-Google-Smtp-Source: ABdhPJwW4lV5a2DvFBRNmE6dpHl9S7ZxaTM15LirLhMnb2FM0Fnhlpb1JKkmKfapD7OAFMxIQ0+Ydw==
X-Received: by 2002:a05:6402:614:: with SMTP id n20mr5746251edv.58.1616624476294;
        Wed, 24 Mar 2021 15:21:16 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bm10sm1807690edb.2.2021.03.24.15.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 15:21:15 -0700 (PDT)
Date:   Thu, 25 Mar 2021 00:21:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
Message-ID: <20210324222114.4uh5modod373njuh@skbuf>
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Mar 24, 2021 at 02:09:02PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/24/2021 1:13 PM, Vladimir Oltean wrote:
> > Hi Martin,
> > 
> > On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
> >> Hello,
> >>
> >> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
> >> support for multiple (TX) queues.
> >> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
> >>
> >> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
> >> The vendor driver (which mixes DSA/switch and MAC functionality in one
> >> driver) uses the following approach:
> >> - eth0 ("lan") uses the first TX queue
> >> - eth1 ("wan") uses the second TX queue
> >>
> >> With the current (mainline) lantiq_xrx200 driver some users are able
> >> to fill up the first (and only) queue.
> >> This is why I am thinking about adding support for the second queue to
> >> the lantiq_xrx200 driver.
> >>
> >> My main question is: how do I do it properly?
> >> Initializing the second TX queue seems simple (calling
> >> netif_tx_napi_add for a second time).
> >> But how do I choose the "right" TX queue in xrx200_start_xmit then?
> 
> If you use DSA you will have a DSA slave network device which will be
> calling into dev_queue_xmit() into the DSA master which will be the
> xrx200 driver, so it's fairly simple for you to implement a queue
> selection within the xrx200 tagger for instance.
> 
> You can take a look at how net/dsa/tag_brcm.c and
> drivers/net/ethernet/broadcom/bcmsysport.c work as far as mapping queues
> from the DSA slave network device queue/port number into a queue number
> for the DSA master.

What are the benefits of mapping packets to TX queues of the DSA master
from the DSA layer?
