Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240192912CA
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437755AbgJQP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 11:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437739AbgJQP5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 11:57:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264AC061755;
        Sat, 17 Oct 2020 08:57:55 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p13so5809696edi.7;
        Sat, 17 Oct 2020 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QU+wUH4mzp61/gyqApvRJulgfmdu+EsgpfLNWikbvBA=;
        b=swfIOmV57CYyXF8I4CZ32TjKsbcI5UW0hqexzZkVw0Abw3jmKkR2e2bsuv1Nm9usw1
         5o2ewjOsKeEG0WOeDB4b26MRgxKbBeHdThhBM+RrP62sip0/QrKF4lH0XQ4m29fcONko
         O5N7JUDlp9zfS8NvQApnJCyHOjyLIP8Zd4osWy3zVtsDcqSBkc9MRtaZfSy7FZ+mtIqU
         9wws25hyIXCu4AfS7anjn0fc1CLMGZhTyC91HnjJLFel1RzbrEfibJ6iOyOM5Fa8+Fsr
         ObF7tU0s36+Jy9kNydKo7548m+NmFGs5lxnEqYbdIH0cZmyUh9uzh3viK+BYSJmomuX3
         dWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QU+wUH4mzp61/gyqApvRJulgfmdu+EsgpfLNWikbvBA=;
        b=a04x0TQvZMZ9bVZgTVuBFzd7OtBopNHi7bTA3XEL/IkV/wAvMTb5dzKImIprUwUrl4
         lq3UUTWS0qx/CSH9iItSA4jcd3dHzunr+0I20C/UQEvkN4cMgLDtMRBv8l/BWOk+G/Uv
         o2nud4U5xgi89wtqPET3FnsJhtEx2uKHMm5Tjyj4SzfbzL/0ZCuJrMsH6NtDHUQAXF02
         A64XWi167/rQNllPqPkTX1KtpyU1PieEAggAyJKYrifcTNWSi+72NQzcGVSypmkj9E02
         XQgbKUeZ+6MgO/T3yu9jZq37k7W2RtguZP46S0Pf+7haJKJA9ZLl4rWBea0901kVnOGL
         q3DQ==
X-Gm-Message-State: AOAM531W1Nsc3R0S24PMkAY/8rYRiFQXPdj/X7PA/+8LR0nDlM8ujBlR
        kTxiiVv9ox6h2ZJVy3NUWR8=
X-Google-Smtp-Source: ABdhPJz6sdL4aah6cHyXzQMTR+55rdvBs1si2QTkiQKVFMbrcbCtcNnN+57OGaNP9xaI9CxRsGAHaw==
X-Received: by 2002:a05:6402:b37:: with SMTP id bo23mr9503211edb.170.1602950273813;
        Sat, 17 Oct 2020 08:57:53 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id vr3sm5544449ejb.124.2020.10.17.08.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 08:57:52 -0700 (PDT)
Date:   Sat, 17 Oct 2020 18:57:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201017155751.4qtmrpf6mlrqptcs@skbuf>
References: <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
 <20201006135631.73rm3gka7r7krwca@skbuf>
 <87362lt08b.fsf@kurt>
 <20201011153055.gottyzqv4hv3qaxv@skbuf>
 <87r1q4f1hq.fsf@kurt>
 <87sgaee5gl.fsf@kurt>
 <20201016154336.s2acp5auctn2zzis@skbuf>
 <6cf8acc5-a6aa-5e77-f0a3-09d7d7af1a82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cf8acc5-a6aa-5e77-f0a3-09d7d7af1a82@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 09:56:22AM -0700, Florian Fainelli wrote:
> I probably missed parts of this long discussion, but for this generation
> of switches, does that mean that you will only allow a bridge with
> vlan_filtering=1 to be configured and also refuse toggling of
> vlan_filtering at run time?

No, the bridge vlan_filtering option will be supported as both on or off.
The limitation that you're probably thinking of is that
NETIF_F_HW_VLAN_CTAG_FILTER will be non-optionally forced on. Otherwise
stated, ports in standalone mode will drop VLAN-tagged traffic unless
they have an 8021q upper with that VLAN ID. Which is probably ok
considering that the network stack would drop them anyway in absence of
an 8021q upper, but they won't be visible in tcpdump either, as things
stand. Otherwise stated, standalone hellcreek ports cannot support
promiscuous mode.
I know that currently DSA sets up NETIF_F_HW_VLAN_CTAG_FILTER as
forced-on for everybody, but that limitation could be lifted for some
switches, but not for hellcreek. Just something to keep in mind.
