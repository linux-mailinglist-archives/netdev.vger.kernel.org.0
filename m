Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01754295691
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895265AbgJVDCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895253AbgJVDCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 23:02:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C60C0613CE;
        Wed, 21 Oct 2020 20:02:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so235624pfa.10;
        Wed, 21 Oct 2020 20:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ts8pOOblpYnY0bOhm+5e9A57wwcNdyc/jhqQYESpses=;
        b=h4Vbm4QxQ76pizoWaBUzmuBGyJo8Roa9+IxGJpoKaoZMINgwBo4asgXbMdzxvrm/Y9
         GULFAxAjAj6qzWsl0hTfMmI4K2eAgZLZHyzhUVLdTSTdlEm09fJ1l3il+q0qO/YCmq8L
         qY5DyK4kogWcy7MkdKJJ5CiyHjbY5Zoom0uCCG2MnvSNv74ToqNyGaeHzX8ilC52Knp1
         FE2lnvNru9cl96f3i0Oc7RynH+I6ZJapQrxKnbl4yeAn8T+ypL1sN/bYx5UWYa3sBU0s
         rUXk5w/XcTHZYQIVvsw9AXPNv/jE7HoNQvpNZ/HLaKlB+aA4wiKxmE6pCKARE/t5/zTg
         ACNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ts8pOOblpYnY0bOhm+5e9A57wwcNdyc/jhqQYESpses=;
        b=Frj5qj9FIqKpqRbHriJ3Fn2cT/qAjWFPGE4skpVueuhdP7o3ncm+XDjqMHHUvWxoUx
         YyjaURt8zurfvd1atKxawfWSOW1CyuhdwRJ6GTJRzVq/TwnNknsRXPY+33zzKNfAb3Se
         ms/leywyTRR9xvMpKl0PvNVL639a+fw9QxHTf3ycjU/ymZdffEt1TApYcn0MwIk4at7a
         /Fn+yBNmyM1Yh8m15Y7jgYmeg2jRRNL0N3XJ/6cl3/g774eLrcOoaiPwHpmIYv4a15jV
         ibWJxPl29DrDjILS0n8WCM9OHLpMS211jO//zI0Vb+IbrTKWY+/ivwSq6ZOue3hcyUC0
         /Dwg==
X-Gm-Message-State: AOAM532TGFUYCbI4928OhBiGJNs7rDKbxES7pwal48JfMH2isowPR+Oc
        u7sKEpWVW3lkjKo1VYl0Pg8=
X-Google-Smtp-Source: ABdhPJztk6MH9/EJ3t+rws0K8jsWAzPEIgqDVH/kuW/U8w7R6xI9z5kkhR9bO2/bVNvi75UNztBnrA==
X-Received: by 2002:a05:6a00:150a:b029:159:53cd:86db with SMTP id q10-20020a056a00150ab029015953cd86dbmr435588pfu.11.1603335740973;
        Wed, 21 Oct 2020 20:02:20 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j37sm242414pgi.20.2020.10.21.20.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 20:02:20 -0700 (PDT)
Date:   Wed, 21 Oct 2020 20:02:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201022030217.GA2105@hoboy.vegasvil.org>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
 <20201021233935.ocj5dnbdz7t7hleu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021233935.ocj5dnbdz7t7hleu@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> So how _does_ that work for TI PHYTER?
> 
> As far as we understand, the PHYTER appears to autonomously mangle PTP packets
> in the following way:
> - subtracting t2 on RX from the correctionField of the Pdelay_Req
> - adding t3 on TX to the correctionField of the Pdelay_Resp

The Phyter does not support peer-to-peer one step.

The only driver that implements it is ptp_ines.c.

And *that* driver/HW implements it correctly.

Thanks,
Richard

