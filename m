Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5663250BF9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHXW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgHXW5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:57:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51E7C061755;
        Mon, 24 Aug 2020 15:57:18 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id oz20so9051045ejb.5;
        Mon, 24 Aug 2020 15:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ptxh3FMwnetu3bSBY1W6iEPH5vawebKoGdalAVvQO4g=;
        b=jlrivj0FqnDRBRtx8smru1UJ/xYxEGLFCStoHxYPPWofgLh7ixf2lLZpRYJykcM4Ka
         3WZnvlP0vwBbthB+suu62H8l9lETkNf/sLugHVHdWyIn/Ftt+jeU08wIV5hRM6/R9IMo
         9UOYnV2jb5ZCWkVGOPaGW31mn8nW9jK+PAK0bcXy0ykUfa2EqJ6imXdtdLILe63V2xNZ
         04CrwKzBeavRziztR/5uQalsw/BH4kPPrHqVm2CCNgP//wwtbBR8VuAq64BpzP+aKWpe
         ISZPKFN4r4h4iucPZn88wCj0WgiwLD1yfkv7moeJb+8G59NY7d9WVjAMMhhp8iDLirnD
         fbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ptxh3FMwnetu3bSBY1W6iEPH5vawebKoGdalAVvQO4g=;
        b=cltR8/8m7LUsXO2FuZfwk+vBTAlZL7s5YOCYvMYYTOrkLvwyJ7zmwXijpsEvsW7KaC
         xGEMm4CLx3FdmuHm4XLGBHjZAg2cxvrIPv35DuRuauhnvfTE1YhPjBNt63aUAmGkgSMw
         IacFmC20ClDGvL2ZRUXXZO/3JN8FvYiwQXivfLxbMgBw89ne1iFpiZBUC+YBOwdZ9LLB
         75vC8mSki42Ez+XqN2+uNJuGjWUQIgQCAtEV8mkL8xBYUZ/Mu36AJucaXve+wew8on/J
         toXfStxM4ufmYAYiCqcLDR78bSBKOB76mrDEmDfpzzM53hPdbswU//KEYSOxETgmtqz9
         L1cw==
X-Gm-Message-State: AOAM530zmmNMWDGuOkSoaWzgUIHsDB9DxWPjkGMj81WY1RzHX5ekdHEB
        cgk0p+sw9eZbXdv4Ude5yEA=
X-Google-Smtp-Source: ABdhPJzBSXALTGMDNfg6GkduPlCOaQ+L6uEuMrLwxTE0nrugJya5ef22hEjKg1Bw+/N3p/3KEinmmg==
X-Received: by 2002:a17:906:a116:: with SMTP id t22mr8040589ejy.353.1598309837386;
        Mon, 24 Aug 2020 15:57:17 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id l7sm10958038edn.45.2020.08.24.15.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:57:16 -0700 (PDT)
Date:   Tue, 25 Aug 2020 01:57:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, kurt@linutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, ivan.khoronzhuk@linaro.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com, Po.Liu@nxp.com
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
Message-ID: <20200824225714.ddcsfd2njfm7oc4y@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
 <20200824220203.atjmjrydq4qyt33x@skbuf>
 <20200824.153518.700546598086140133.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824.153518.700546598086140133.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 03:35:18PM -0700, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 25 Aug 2020 01:02:03 +0300
> 
> > Just my comment on patch 5/8 about netdev->tc_to_txq. There are 2
> > distinct things about that:
> > - accessing struct net_device directly hurts the DSA model a little bit.
> > - I think there's some confusion regarding the use of netdev->tc_to_txq
> >   itself. I don't think that's the right place to setup a VLAN PCP to
> >   traffic class mapping. That's simply "what traffic class does each
> >   netdev queue have". I would even go as far as say that Linux doesn't
> >   support a VLAN PCP to TC mapping (similar to the DSCP to TC mapping
> >   from the DCB ops) at all, except for the ingress-qos-map and
> >   egress-qos-map of the 8021q driver, which can't be offloaded and don't
> >   map nicely over existing hardware anyway (what hardware has an
> >   ingress-qos-map and an egress-qos-map per individual VLAN?!).
> >   Although I do really see the need for having a mapping between VLAN
> >   PCP and traffic class, I would suggest Kurt to not expose this through
> >   taprio/mqprio (hardcode the PCP mapping as 1-to-1 with TC, as other
> >   drivers do), and let's try to come up separately with an abstraction
> >   for that.
> 
> Agreed, Kurt can you repost this series without the TAPRIO support for
> now since it's controversial and needs more discussion and changes?
> 
> Thank you.

To be clear, the most important part of the taprio qdisc offload
(setting up the gate control list) does not need to be postponed. It's
just the VLAN PCP mapping that is a bit controversial.

Thanks,
-Vladimir
