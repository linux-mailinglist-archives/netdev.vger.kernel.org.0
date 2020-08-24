Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631AC250B49
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgHXWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXWCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:02:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A4C061574;
        Mon, 24 Aug 2020 15:02:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dp2so8574026ejc.4;
        Mon, 24 Aug 2020 15:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eDrs1DwbC5+8TONYybtdQH1gGPGhspdsL18iTrVhGW8=;
        b=k89mJ60CjyOjtzdPYjexfQLXH07LhjNYMlld62dH/8NbkwVGIu9U7moqLtrX2W4SqP
         wqGh2MgPs+2ZhEDU32Jqw5EIURp3BOEnhIu+EauBr92YQ38wesDInxImpQPiIJVoGg9x
         5+cOkMPxoMta9hN/RcCY29BCeca9IfAynGJVstSPMLekv/oVAw/06AzIM5U5YRESJLYo
         AVfTYqAKfJNoRRYIsCb8ivYFkuRyYC/ICIksYWp6u0M82vKFANp/gG0Bna2OB7rPebJz
         h1EvOhZACnzxeyKodkVuBpc+cUwZ/Hny8PeNWk+Be0IE05FlT0ATdUmYln1b2VDx5Lzk
         hFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eDrs1DwbC5+8TONYybtdQH1gGPGhspdsL18iTrVhGW8=;
        b=btm4yOIpZUmbcvrt6kPA6o884+rivIBpEX86hWHva/lmv3bNCQGOF9/Z36ids/+2rF
         fnS79K/HUUQEkWjzTPMowDmyV7vV1x1bmmVHaERDRnzvEQkRHq198DzWt0/4nWmWgCYA
         C8b4FlWqIP4xNga7FXFZH7ItI+NVEoYeo6reYJkd6g0hvCcssyekg9hVOTzdLItNYGnH
         IhSHTArGZKuhZc0eBEtCzFQVTA972g1/Eio6dwhPyf6uzpR2ysIo1WbW9/SyS+iSJym9
         tD4QoJT13EuEjBcdGrrTe/i0FgU0sbH+gYxnhPNjpXoaaYNDVvcK5HgRcR8gxgm0oKjS
         XbfA==
X-Gm-Message-State: AOAM530AoF72s2YaIZVE7AylGfjAzJW/ktaHIuE7/LnEsCKi/+XqZgP8
        eqJ46oUhr8Jh322S/Qeb1y8=
X-Google-Smtp-Source: ABdhPJxaKTXwY/jsO6Hr/Rbx2mOzeZXhjAoW8l1Mn3bCLDieQej4NComAgrLqz5ZGXR+vMoGC8Gk2A==
X-Received: by 2002:a17:906:4a0d:: with SMTP id w13mr6797613eju.156.1598306526569;
        Mon, 24 Aug 2020 15:02:06 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id a19sm10755504edv.49.2020.08.24.15.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:02:06 -0700 (PDT)
Date:   Tue, 25 Aug 2020 01:02:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <Po.Liu@nxp.com>
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
Message-ID: <20200824220203.atjmjrydq4qyt33x@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 02:31:10PM -0700, Jakub Kicinski wrote:
> On Thu, 20 Aug 2020 10:11:10 +0200 Kurt Kanzenbach wrote:
> > this series adds a DSA driver for the Hirschmann Hellcreek TSN switch
> > IP. Characteristics of that IP:
> > 
> >  * Full duplex Ethernet interface at 100/1000 Mbps on three ports
> >  * IEEE 802.1Q-compliant Ethernet Switch
> >  * IEEE 802.1Qbv Time-Aware scheduling support
> >  * IEEE 1588 and IEEE 802.1AS support
> 
> I don't see anything worth complaining about here, but this is not my
> area of expertise.. 
> 
> DSA and TAPRIO folks - does this look good to you?

Just my comment on patch 5/8 about netdev->tc_to_txq. There are 2
distinct things about that:
- accessing struct net_device directly hurts the DSA model a little bit.
- I think there's some confusion regarding the use of netdev->tc_to_txq
  itself. I don't think that's the right place to setup a VLAN PCP to
  traffic class mapping. That's simply "what traffic class does each
  netdev queue have". I would even go as far as say that Linux doesn't
  support a VLAN PCP to TC mapping (similar to the DSCP to TC mapping
  from the DCB ops) at all, except for the ingress-qos-map and
  egress-qos-map of the 8021q driver, which can't be offloaded and don't
  map nicely over existing hardware anyway (what hardware has an
  ingress-qos-map and an egress-qos-map per individual VLAN?!).
  Although I do really see the need for having a mapping between VLAN
  PCP and traffic class, I would suggest Kurt to not expose this through
  taprio/mqprio (hardcode the PCP mapping as 1-to-1 with TC, as other
  drivers do), and let's try to come up separately with an abstraction
  for that.

Thanks,
-Vladimir
