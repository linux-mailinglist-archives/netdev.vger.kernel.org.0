Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6CC343B2D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 09:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCVIEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 04:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCVIEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 04:04:10 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E24C061574;
        Mon, 22 Mar 2021 01:04:10 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id v26so12947685iox.11;
        Mon, 22 Mar 2021 01:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQCjdvCCiui7NyjVPyRHtMOqJO2l/XC/v3WkLyGdTXs=;
        b=Uq/OBklgV6KsgFXzbeyaRuJUapPvtKTysUFRcCWJfwnQUlE1UDpce59Owq2xmCVq3n
         C1wfKuf9Ekgl73sGCJOClyGBuNC1qFu3WC1F6XaQCt1Fq/Fiy2NlGpandRD5TdG6riiu
         qmh4wOzrQ8iGKgpNq45ywuxV1UsM5mL5qm7zapfXE19/Ba4cOlJks8otYTP/uNpi4U3e
         070vXWykdlPihP1P5RWGFJd//yLrto7Pu/2e1vtiDGYM3AMBTYAE7wxtMWqgc3TvzffO
         EM1eV/M9mx8XveD0S5BS1W5Fl+Y1cI3ukzMX4QB4q/uhg9DCOxfAlA5J4ANFApt7utFB
         +98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQCjdvCCiui7NyjVPyRHtMOqJO2l/XC/v3WkLyGdTXs=;
        b=uTB5mceYOuvEpdk3EATAtf4itg5pzCvY4miNRPZNbXhhDFyDB7a+e9hkTj/Va8d3dE
         yBhBSBxmwUUgy3oaeY9dmwE23St2cUbBRtLChKXvNA9PTwSiZp2SQH96gkTIMljdPDMn
         Cvtc7/byJXeDrqlke0X3y0gOP/7FALXav/Q2Z9dS7mVeTTlqIF7fp7lDuqbcyCA3lWcN
         Ay1n18ArLBLA6wL0MBsM1mW1klolOJEolE46NbVQbddhokCR9h9+y5YWAZb9tlTLjoJ9
         DJOWGQeA/NlchsNbU3cnlEafU/OUZG+8+TL6FYc5bzoKU05ngRTE/WHQGSkfPo8xhBGR
         toIg==
X-Gm-Message-State: AOAM5323LMJUbvHYx9gCxDP4nnuv6SA7MitzdYCTNkT1HJs6SOq7uvYM
        T9/XoosDJ3hSockyOBIQ94JMi3M1xh26VY/2354gRLCd
X-Google-Smtp-Source: ABdhPJwdqhT0oEb6tE/dej3q9+JpzvaDLk1Lxf4HQ/V4S8rkNVvaT6uKCMGjCO5kDCBKzvQld8WYIz1HewAlaPK1TRI=
X-Received: by 2002:a02:a889:: with SMTP id l9mr10105193jam.1.1616400250019;
 Mon, 22 Mar 2021 01:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-15-olteanv@gmail.com>
 <20210319084025.GA2152639@haswell-ubuntu20> <20210319090642.bzmtlzc5im6xtbkh@skbuf>
 <CALW65janF_yztk7hH5n8wZFpWXxbCwQu3m4W=B-n2mcNG+W=Mw@mail.gmail.com> <20210319104924.gcdobjxmqcf6s4wq@skbuf>
In-Reply-To: <20210319104924.gcdobjxmqcf6s4wq@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 22 Mar 2021 16:04:01 +0800
Message-ID: <CALW65jYc6DFoUiF55Q3KrhamPf75tFRSAkSA6ONrF3KMf9z+7g@mail.gmail.com>
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

On Fri, Mar 19, 2021 at 6:49 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> Why would you even want to look at the source net device for forwarding?
> I'd say that if dp->bridge_dev is NULL in the xmit function, you certainly
> want to bypass address learning if you can. Maybe also for link-local traffic.

Also for trapped traffic (snooping, tc-flower trap action) if the CPU
sends them back.
