Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34537221E52
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGPI3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPI3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:29:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9126C061755;
        Thu, 16 Jul 2020 01:29:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rk21so5679545ejb.2;
        Thu, 16 Jul 2020 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iCEX1fRcVBPy4bLO4xifKAc2cHrh6Cb5pXfFp4MMl3s=;
        b=rc8nd4SC5uYC3D5FNjGT4r6WgedOIHopEUVWe+EyFYwBj8qLNEjnA9TEEtJAZtS0T1
         K8LmOSVFhlrYpgc8Iq5pWFFJoIbIREEvN4kPYUF3tbHV3xsiPuf4zOzJ4+RnwttqEN7i
         sjN/177qLAAmIqQ2zEuojmKaqqCy/U8oiq2Z/UzsUYTS21mXXpM35Tn3MZ6V0vPFfmXb
         PT7h5TN2X08k61FJ6HVhT/ix7TJIarDDSr+hPTxmGajEnUHHfHVvVD+xQ9Cw0roDecdt
         Z/NE1GhldxuDsYSb/IlwuEDG63hxwn78DwO3d01zPVkRJviapBu7cBqkUHUCIxzqjy5y
         MVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iCEX1fRcVBPy4bLO4xifKAc2cHrh6Cb5pXfFp4MMl3s=;
        b=dGAVTvDejHcAf3453koZhnvqE6KdYdKGCGC38O+KQpxiObUdYgKsX1ayeekKeuPdpi
         rPFhuhrEUT6WIFdEhs7dqKuDF4QUAecaAPaqiQXMdy4RZU0VKEcKlfP5yAIbzc54XD3z
         LtMmMZweuIQotT0A1gsdBby9vrTrimCu8xLwcdd6PvDBhdmmhHYbq9F4Qug73j73sMKj
         oFR+Ow91KA/uUd1DpVY4M/JjQ6AxWw7veTEgJAAqYnPqctlt6aV5Vd3USBJSUK9wAJAL
         Bvcp0SXMPdUr0HkfV7FHhbhvHtUdriOAFFK5mEIWKrMBRepF6Of+ktLRj/T9ut7V6BwS
         1RLQ==
X-Gm-Message-State: AOAM530PFluyQzGz+RjrH5h3QbCyIixfiyqvZDFnheRYlgcgOUIVsQcX
        PE3KXUhEEWT/oz38nFfE88s=
X-Google-Smtp-Source: ABdhPJz/I3Puu8EkaoFdlPJENnRYnrbeJulUqxoDBVvA9WequmYX9KYtyTj5zIffo+qvg8ZybrsC3A==
X-Received: by 2002:a17:906:3a17:: with SMTP id z23mr2564639eje.238.1594888178507;
        Thu, 16 Jul 2020 01:29:38 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id b18sm4362935ejl.52.2020.07.16.01.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 01:29:37 -0700 (PDT)
Date:   Thu, 16 Jul 2020 11:29:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-3-kurt@linutronix.de>
 <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com>
 <87v9islyf2.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9islyf2.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 08:30:25AM +0200, Kurt Kanzenbach wrote:
> On Sat Jul 11 2020, Florian Fainelli wrote:
> > On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> > [snip]
> >
> >> +
> >> +/* Default setup for DSA:
> >> + *  VLAN 2: CPU and Port 1 egress untagged.
> >> + *  VLAN 3: CPU and Port 2 egress untagged.
> >
> > Can you use any of the DSA_TAG_8021Q services to help you with that?
> 
> Maybe dsa_port_setup_8021q_tagging() could be used. It does distinguish
> between RX and TX, but I assume it'd also work. Needs to be tested.
> 

The fundamental role of DSA_TAG_8021Q is not to give you port
separation, but port identification, when there is no hardware tagging
support, or it cannot be used. So in fact, it is quite the contrary:
tag_8021q assumes that port separation will be achieved by external
means. Most switches support a "port forwarding matrix" of sorts (i.e.
"is port i allowed to forward to port j?"), and that is what is used, in
tag_8021q setups, to isolate one port from another on RX (in standalone
mode). I'm not sure what's the status with hellcreek hardware design, it
seems very odd to me to not include any sort of port forwarding matrix,
and to have to rely on port membership on each port's pvid to achieve
that in the .port_bridge_join method. By the way, this brings up another
topic: any 'bridge vlan add' for a pvid will break your setup. You
should avoid that somehow.
Please try to set ds->configure_vlan_while_not_filtering = true; in your
.setup callback.  We're trying to make all switches behave uniformly and
be able to deal with VLANs added straight away by the bridge. Don't be
confused by the fact that it's an option - there's nothing really
optional about it, it is just there to avoid breakage in drivers which
haven't been converted.  Since yours is a new driver, it should enable
this option from day 1.

Thanks,
-Vladimir
