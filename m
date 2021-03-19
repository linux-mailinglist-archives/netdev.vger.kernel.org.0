Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ADB341841
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 10:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCSJ3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 05:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCSJ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 05:29:24 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DF3C06174A;
        Fri, 19 Mar 2021 02:29:23 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v3so5337398ioq.2;
        Fri, 19 Mar 2021 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZyMxyLtGmXc14vPmC2muMVj1bNOjlWFgkRG7lJHAMXw=;
        b=g/oiURC0BQQDygqV+zfzH1xXSqszIlaroYF3lmmkHLOJgZ1VjfTiw3/CMLH//haYts
         KcQ7F9yatZtGxrLIQZvRycTbcWata78hRff67WjUnStSlcGuq8sIEjmS5d76kPdJWTLT
         SH8cyJIahMoN1dcrRssvgntT+2aIVWe+ezgvhpul9vwWJS1UPcq9ZbRF0GzHFy57L+V/
         afPuZ2D6xLh35/8kmQS2e9X9fM52xuQf/37h/Hc97tl2i8hF0ju3yWCoF/vXyobttdjC
         YXpnIHbaxul/+YEtAg8xdAHYB4giTm2WEX8ldUxqW1bNLUGAzAH/Ir4f8otMM57x5arb
         Hujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyMxyLtGmXc14vPmC2muMVj1bNOjlWFgkRG7lJHAMXw=;
        b=N83SdIzkpBpN2E8vi8z9PpkGOzeEGLD2iuYMA8Vr3zxgnaLuKgeUzMosUNTT+yuJr5
         ZaHC055DBqqicBl038UPF9ewV4VLKjvgBDYv2OCYLZficXtBQsA6fRPMm+Q97J7vcpmR
         wm0ORW2kFC53/CpF6qsgGJyJMvdPyfs8kdCydwKlxcfyQmFqzJlA2krabp0326mB0pOZ
         +S5lYmgCzouiNrSsN57Eege6HZoz/prbVmvGYwnNNjPEybT0Mtwvp3sbip8ebWbVdIcM
         0VFYzYcQ8WPYfhjS4RB4EZrpy1sv0qOb0GUSMD41aWyKOT0xPCg1Ixl6EKhzwepZ+1aK
         U/kQ==
X-Gm-Message-State: AOAM530fpENdfAKQvztXqhce4HdD8R4hyEVedoVhcFjFQYCth/zr5UQF
        M3KpUTtnnWDNtbrL1wC42yWqAoLJJ5GyB0NT+0s=
X-Google-Smtp-Source: ABdhPJxX2fhgx8xX/VeZIis9oOuNnkG3fWHsCztWP+PnggdP7W3yla9jfxRwo044GJSDHY9DNE3UtFt7iK0PD19V10I=
X-Received: by 2002:a05:6638:2101:: with SMTP id n1mr439006jaj.7.1616146163046;
 Fri, 19 Mar 2021 02:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-15-olteanv@gmail.com>
 <20210319084025.GA2152639@haswell-ubuntu20> <20210319090642.bzmtlzc5im6xtbkh@skbuf>
In-Reply-To: <20210319090642.bzmtlzc5im6xtbkh@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 19 Mar 2021 17:29:12 +0800
Message-ID: <CALW65janF_yztk7hH5n8wZFpWXxbCwQu3m4W=B-n2mcNG+W=Mw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set
 skb->offload_fwd_mark when not offloading the bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 5:06 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> This is a good point actually, which I thought about, but did not give a
> lot of importance to for the moment. Either we go full steam ahead with
> assisted learning on the CPU port for everybody, and we selectively
> learn the addresses relevant to the bridging funciton only, or we do
> what you say, but then it will be a little bit more complicated IMO, and
> have hardware dependencies, which isn't as nice.

Are skb->offload_fwd_mark and source DSA switch kept in dsa_slave_xmit?
I think SA learning should be bypassed iff skb->offload_fwd_mark == 1 and
source DSA switch == destination DSA switch.
