Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9CB5AE0CA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 09:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbiIFHRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 03:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238836AbiIFHRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 03:17:42 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BBE73935;
        Tue,  6 Sep 2022 00:17:41 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 8794E21BD;
        Tue,  6 Sep 2022 09:17:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662448659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qxi49WzANBodoTQOX0E/K8f/DX4qR1X+vWMmaXpTEi0=;
        b=meVG/NVLfkJRQq1uQnr1QrnzD86804WP6rLDZ4fMa74eMzJRJ06DuH2PpAeYygx6Q0yVmI
        CKxYu2kWDrIH7e5gBxduRNf0iG3RAQ/QV8226tNmvaCHkSj9YzB4ZCRlLWBfZfKjlQTR+F
        /hEGP/tq0pYx88MrddxkP9B1G6W82MBFEuSFNxflm2i4E0qRiG6PAmm6ZAx3vPM82q3LFN
        MZ0rHiuraa/yULLl/UrQtGZvoVj1DSpb+2BGFwu3Ftmu823xOZu51ZKHMNUGXbSlbOORKW
        6fXPcV+4bmlYLw/pf4d+0295AYasFcyNwKeymFV1krtZDiB2m74YBPiDpCgLKg==
MIME-Version: 1.0
Date:   Tue, 06 Sep 2022 09:17:39 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 1/3] net: dsa: felix: tc-taprio intervals smaller
 than MTU should send at least one packet
In-Reply-To: <20220906001134.ikooyzebb4pmgzib@skbuf>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
 <20220905170125.1269498-2-vladimir.oltean@nxp.com>
 <d50be0e224c70453e1a4a7d690cfdf1b@walle.cc>
 <20220906001134.ikooyzebb4pmgzib@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0c7c5fecc853ce161236f66c517b7474@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-09-06 02:11, schrieb Vladimir Oltean:
> On Tue, Sep 06, 2022 at 12:53:20AM +0200, Michael Walle wrote:
>> I haven't looked at the overall code, but the solution described
>> above sounds good.
>> 
>> FWIW, I don't think such a schedule, where exactly one frame
>> can be sent, is very likely in the wild though. Imagine a piece
>> of software is generating one frame per cycle. It might happen
>> that during one (hardware) cycle there is no frame ready (because
>> it is software and it jitters), but then in the next cycle, there
>> are now two frames ready. In that case you'll always lag one frame
>> behind and you'll never recover from it.
>> 
>> Either I'd make sure I can send at two frames in one cycle, or
>> my software would only send a frame every other cycle.
> 
> A 10 us interval is a 10 us interval, it shouldn't matter if you slice
> it up as one 1250B frame, or two 500B frames, or four 200B frames, etc.
> Except with the Microchip hardware implementation, it does. In v1, we
> were slicing the 10 us interval in half for useful traffic and half for
> the guard band. So we could fit more small packets in 5 us. In v2, at
> your proposal, we are slicing it in 33 ns for the useful traffic, and
> 10 us - 33 ns for the guard band. This indeed allows for a single
> packet, be it big or small. It's how the hardware works; without any
> other input data point, a slicing point needs to be put somewhere.
> Somehow it's just as arbitrary in v2 as where it was in v1, just
> optimized for a different metric which you're now saying is less 
> practical.

I actually checked the code before writing and saw that one could
change the guard band by setting the MTU of the interface. I though,
"ah ok, then there is no issue". After sleeping, I noticed that you'd
restrict the size of all the frames on the interface. Doh ;)

-michael

> By the way, I was a fool in last year's discussion on guard bands for
> saying that there isn't any way for the user to control per-tc MTU.
> IEEE 802.1Qbv, later standardized as IEEE 802.1Q clause 8.6.8.4
> Enhancements for scheduled traffic, does contain a queueMaxSDUTable
> structure with queueMaxSDU elements. I guess I have no choice except to
> add this to the tc-taprio UAPI in a net-next patch, because as I've
> explained above, even though I've solved the port hanging issue, this
> hardware needs more fine tuning to obtain a differentiation between 
> many
> small packets vs few large packets per interval.

