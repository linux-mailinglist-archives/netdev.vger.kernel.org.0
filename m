Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2C84C4AE9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiBYQgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240475AbiBYQgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:36:18 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D501E747A;
        Fri, 25 Feb 2022 08:35:46 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gb39so11975254ejc.1;
        Fri, 25 Feb 2022 08:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZRNZT/kowwKFbrtkcGjf3tdrcz+Mmx/9iZgGvPBsCm4=;
        b=BKTqYeU9PLTm12alisyOJRsh0ywv0HwGWvsGpmSCfdxAKPE5MI/mbdISUWad/EiBdy
         /oUPfdUu7Duc+HqzB5KEX5viPpiBEeKO+Z+ox5PxT11FMQB4F0r1e752jivmKNkiM1fm
         CKax+MQcWywclExu3rW0xzB38Mm/oJsKY84XSP4eFyKSWxVxnprknG8jdd/I+Sgsj1wU
         zSrlUEyjkzhvTofqRcVctR9LVWwPWSmlZAo6/zEbQM1PIt6saJc/U8nBw+xqOIpGGGwt
         ukDHFs2PKQqdz2NPDA2I83v0pKPZ/goM2f9DDuznUafKrxAj2cRQJ2qZbTxAa+zk3jP4
         rMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZRNZT/kowwKFbrtkcGjf3tdrcz+Mmx/9iZgGvPBsCm4=;
        b=IwVvKi/i6pmH5P97KglHC1p0XnYFEl4ddNKMuCX1DlAw1K5AxzCeWBnWiiNNSTzUOy
         rWKg3AHP9ERNOQkUlkJm/eks466oo8CoVgqOF80mSvfokX1/trdd1bsUK9DdrUGZnyW2
         JTJC12lESfaMkP22en0Is2Pkh7A16I6RnPeSYUaYneh4h63GKGZwFPM2GR8b+S80Tag/
         iNFwZSRw+eynT43hiCyp3oBv+6SuW5UgvO17GFkZqLBt5qHUnMfRcEmMDxazuTKc7zy5
         yK4JCK8rA7j2qIy1vNHcuIqjpmge2tGaxOAShvsuwEM7m7GT9avgAy6Z4NKUISx/yTTr
         DJDw==
X-Gm-Message-State: AOAM531WwyGLNJHtqHOr2d32r5N3aIWwdVh6/7Yvn5iTFjVxSL/npmzy
        uWOnPUoUbSHEI6J0MYMHwxnLs5tVhCQ=
X-Google-Smtp-Source: ABdhPJyM3B+XrHSke+4GeQQxWGIFbeMRZJFDjiG9MhYzMWOCyK7uaneWuM0uqFE3d9Yh27m3UnvfFQ==
X-Received: by 2002:a17:907:1183:b0:6cf:ce2f:51c1 with SMTP id uz3-20020a170907118300b006cfce2f51c1mr6711909ejb.209.1645806945180;
        Fri, 25 Feb 2022 08:35:45 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id vw19-20020a170907059300b006ba4e0f2046sm1169885ejb.137.2022.02.25.08.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:35:44 -0800 (PST)
Date:   Fri, 25 Feb 2022 18:35:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220225163543.vnqlkltgmwf4vlmm@skbuf>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
 <20220224094657.jzhvi67ryhuipor4@skbuf>
 <20220225114740.GA27407@pengutronix.de>
 <20220225115802.bvjd54cwwk6hjyfa@skbuf>
 <20220225125430.GB27407@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225125430.GB27407@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 01:54:30PM +0100, Oleksij Rempel wrote:
> > No bridge, why create a bridge? And even if you do, why add lan5 to it?
> > The expectation is that standalone ports still remain functional when
> > other ports join a bridge.
> 
> No, lan5 is not added to the bridge, but stops functioning after creating
> br with lan1 or any other lanX

Please take time to investigate the problem and fix it.

> > I was saying:
> > 
> > ip link set lan1 up
> > ip link add link lan1 name lan1.5 type vlan id 5
> > ip addr add 172.17.0.2/24 dev lan1.5 && ip link set lan1.5 up
> > iperf3 -c 172.17.0.10
> 
> It works.

This is akin to saying that without any calls to ksz9477_change_mtu(),
just writing VLAN_ETH_FRAME_LEN + ETH_FCS_LEN into REG_SW_MTU__2 is
sufficient to get VLAN-tagged MTU-sized packets to pass through the CPU
port and the lan1 user port.

So my question is: is this necessary?

	if (dsa_is_cpu_port(ds, port))
		new_mtu += KSZ9477_INGRESS_TAG_LEN;
