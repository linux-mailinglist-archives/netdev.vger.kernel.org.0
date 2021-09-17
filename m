Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B006140F572
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbhIQKCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbhIQKCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 06:02:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115FCC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 03:00:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v24so27891460eda.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 03:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6L3QY+CulxUHNW6TLr0UqKB9UfAaqtpAf8dXuyfSdsM=;
        b=C+utRQSNJBqucMvOMp8iQaug1ECdjY1uIN0l/N1UrudEMNhscFzSeoVqZAbfDs6mjM
         jyjdiCwl6ImA/wNjuFmY4XAguoTNmzbuSGbO+bkaWjL3gLDKNrLQSZrGUiqp/oeriFwm
         CNzkNTV5TRnf0zTaN5w3YXwRKys2nCEjtKS+YfEeCReyJX3mcL6lpCD5LJVP+96ac+0s
         cVb5pBh7bW0plKSln+yLj/DiV5NCX75ZoLhlfLu1TKR+GpzH0sguKFfZ2Oxj2xtTqoSz
         zj6qBj3BvN8/GEVf6ZFUEWdrwt4N1O3Sniid1TgjstMlTOZ3Jbex1tITdPEbC1UWprLI
         Rt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6L3QY+CulxUHNW6TLr0UqKB9UfAaqtpAf8dXuyfSdsM=;
        b=fR5cwck1UewQRT3Eg+LXHEWdqHbUYbVvwVmTrv4XU+h21hOoFCeF0TsOuzAbJ2hE84
         ZgSZjeCWxCJQMWQyznsTZTAydpGvsX7ZkdOLuTxagWONlHEGvd0IHxCvi3bL94ZDzpfM
         NCjPavCC+ga4QaBGsQp8M6ZnzmWf/ot8ua24MahLyjv69Bmt3XJWHmI6siUeLHiDDFpc
         aVaSsnejrLFoO/fALS4Dg3Xnb1eS7lZAg0wCR3x40ONXemuICocPUTJw9EMzCX8A7/nZ
         b59FL4LIIIuQpWNi/7EzR1xvYeVo72k65ASXPMSmG9VAL6XTvp3TMSDceaIMHUV5nj9I
         8RNg==
X-Gm-Message-State: AOAM531Y2YeBgKR8bBg7tT23mIV7/3iSn1fx+Eh5Jcv7eOpZS4Nd/VA+
        BMFtg9vWBwfSvuGwiijDgJFanRXeq+c=
X-Google-Smtp-Source: ABdhPJwzh4kLbu1TvKfiZe7puVv6hRR2uIxZ+x5To1nuNeUHxDlk518B5QKUD+fsgEszOUOHlPoQpQ==
X-Received: by 2002:a17:906:c18c:: with SMTP id g12mr11436996ejz.458.1631872854026;
        Fri, 17 Sep 2021 03:00:54 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id g9sm2108300ejo.60.2021.09.17.03.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 03:00:53 -0700 (PDT)
Date:   Fri, 17 Sep 2021 13:00:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
Message-ID: <20210917100051.254mzlfxwvaromcn@skbuf>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
 <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
 <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 12:19:02AM +0200, Rafał Miłecki wrote:
> On 16.09.2021 23:46, Florian Fainelli wrote:
> > On 9/16/21 9:23 AM, Florian Fainelli wrote:
> > > On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> > > > From: Rafał Miłecki <rafal@milecki.pl>
> > > > 
> > > > This has been tested on:
> > > > 
> > > > 1. Luxul XBR-4500 with used CPU port 5
> > > > [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0
> > > > 
> > > > 2. Netgear R8000 with used CPU port 8
> > > > [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5
> > > 
> > > These look good at first glance, let me give them a try on 7445 and 7278
> > > at least before responding with Reviewed-by/Tested-by tags, thanks!
> > > 
> > Found some issues on 7445 and 7278 while moving to the latest net-next
> > which I will be addressing but this worked nicely.
> > 
> > What do you think about removing dev->enabled_ports and
> > b53_for_each_port entirely and using a DSA helper that iterates over the
> > switch's port list? Now that we have dev->num_ports accurately reflect
> > the number of ports it should be equivalent.
> 
> The limitation I see in DSA is skipping unavailable ports. E.g. BCM5301x
> switches that don't have port 6. The closest match for such case I found
> is DSA_PORT_TYPE_UNUSED but I'm not sure if it's enough to handle those
> cases.
> 
> That DSA_PORT_TYPE_UNUSED would probably require investigating DSA & b53
> behaviour *and* discussing it with DSA maintainer to make sure we don't
> abuse that.

How absent are these ports in hardware? For DSA_PORT_TYPE_UNUSED we do
register a devlink port, but if those ports are really not present in
hardware, I'm thinking maybe the easiest way would be to supply a
ds->disabled_port_mask before dsa_register_switch(), and DSA will simply
skip those ports when allocating the dp, the devlink_port etc. So you
will literally have nothing for them.
