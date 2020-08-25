Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E92515B4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgHYJqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgHYJqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:46:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42196C061755;
        Tue, 25 Aug 2020 02:46:16 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id u1so471162edi.4;
        Tue, 25 Aug 2020 02:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lTsKS8Pb8K5WIlay+gSpZALJK9CC4vKfRtBondq1rG0=;
        b=WubUU/NVMgDBIGpWM+WY1oTuRzE54vLKnQZjndSsLe89JNw7+MYdJGerAlsZ9ySeTY
         15gwueEu/r8j62UNGT7C2eayRAaY9ZMrNLQzLFkqBWoolNtxGwRDkO9wcOGa5wD14F/R
         HGgEYYU2to8O37h73hzceBTc+qW4IjlqL7r8zKO7qN0kan3RMu7vGNzwlVfvQ1ZnLCg7
         0uqbmd3YZcTHHDuDIajMER0iIoywAtDO/BcLFRPRPcHQOm6GOqRH2U+vRDh89Mbo7kvj
         RPayqch3tZXsTR+Xa5pb2cs8r9yZLqHMOWxBSWYwkvn4tCPJ7Z4I7L2N2voyzE4r70kG
         Hbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lTsKS8Pb8K5WIlay+gSpZALJK9CC4vKfRtBondq1rG0=;
        b=UBuoz5DZkBwjxD8pykLp+xk/4O3UvLneTM1LKQ45HvLzQFIZEgHNpnnNoHyeOIR0DU
         0dAvmWmtiFXclH35PHuEsm6q+tsx8LHIobQ8dieyv6eQWG1P4nM0yDi1g0H1dLnzywjc
         KaliTDPHlnKO8fFOf6mcpEMpcRtVC1bf5zBdg9VS5DYlnxCgTsV+PdBvUMc0Js/Jffin
         W1vjcwqeAAX/dgpAjZddkE2Y1Xjr3wUI/fcQCEOcjn8QYhrXUWOFVeFQviV+Bh02WYXl
         /oczORiT7bjeySmA19m7zhJ7DMJ3xMsYfxvAmIrLNUz9Z+yLsk1uRISPX1Mykhd1PdrZ
         TQJQ==
X-Gm-Message-State: AOAM531OvnsXONHYzhksooMg1k8HpAkCYwWpGS3U3xTuQJPWFpPCvnHY
        5zr35OuSbc2oC64vrgUj644=
X-Google-Smtp-Source: ABdhPJwr9ysM8xXqvCVtvOtSxeedByHPMHO/m8GmhNTtL1ZLM4UWcZ1QRYAdRSipjRxoEdwNIT/VyQ==
X-Received: by 2002:aa7:d688:: with SMTP id d8mr9525604edr.168.1598348774916;
        Tue, 25 Aug 2020 02:46:14 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id p3sm12461605edx.75.2020.08.25.02.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:46:14 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:46:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200825094612.ffdt6xkl552ppc3i@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
 <20200822143922.frjtog4mcyaegtyg@skbuf>
 <87imd8zi8z.fsf@kurt>
 <87y2m3txox.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2m3txox.fsf@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Mon, Aug 24, 2020 at 04:45:50PM -0700, Vinicius Costa Gomes wrote:
> Kurt Kanzenbach <kurt@linutronix.de> writes:
> >
> > With TAPRIO traffic classes and the mapping to queues can be
> > configured. The switch can also map traffic classes. That sounded like a
> > good match to me.
>
> The only reason I could think that you would need this that *right now*
> taprio has pretty glaring oversight: that in the offload parameters each entry
> 'gate_mask' reference the "Traffic Class" (i.e. bit 0 is Traffic Class
> 0), and it really should be the HW queue.
>

Sorry, but could you please explain why having the gate_mask reference
the traffic classes is a glaring oversight, and how changing it would
help here?

Also, Kurt, could you please explain what the
HR_PRTCCFG_PCP_TC_MAP_SHIFT field in HR_PRTCCFG is doing?
To me, it appears that it's configuring ingress QoS classification on
the port (and the reason why this is strange to me is because you're
applying this configuration through an egress qdisc), but I want to make
sure I'm not misunderstanding.

Thanks,
-Vladimir
