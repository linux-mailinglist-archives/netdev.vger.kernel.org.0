Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2376107ED
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiJ1CZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiJ1CZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:25:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303225B538
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:25:03 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i3so3626588pfc.11
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=APTR9G8BWySdkiOp7lUNWvcl3daBTmtKOYrPyf2ypdU=;
        b=aDpGIDN3N493zMcHxu/vuW7OGI9FTfiXynxwrf0XkgsY9yMLC/xrVQny9sFJTCGDgg
         mApRoRkcbMIT3m9nmgaXQnRzC+BO4vilgdyi1smqEzIBFDMB8VzR0OMphc64vR8QeBdG
         RrB1a+owtl4AzpYUtisCiM+fxDhVpazi9zajvi01enxsUPju4vZwWgzZJ1okeSdZc7gC
         6rWmWO+tQDos0DCVIDiLU4L+aD5oK9gbEzMcsRQC5TQNU30hIFbBtvonKGAXAINUaQod
         YheX+zRo3tthE+ePDMk98cTkj1EJR0uhNU/U6tKYRSEE7oQ/R5Hd1VMDxhxcmU7yzAwP
         R0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APTR9G8BWySdkiOp7lUNWvcl3daBTmtKOYrPyf2ypdU=;
        b=wKmDgJqppolP4c/HdEAJs3zyFITxb/jHpy0NwKJFRnBZ3x9We6g/8Mu56nrfm/o6Bd
         kHOi9TSZ3iJRQMzT+YjAokvNsOEGzPDMsrMSr9WpYhDxMLtNzmze/6rjtoSaJ7PKAEA3
         5RqeNZZAofW8Ukn9BhQWvmiLO8/QJiCmewaKlo2xEaqzGO09gQD25RXQgDabggAOI//r
         fa/AqVmh2JvV+ceKMyWxARian6dblfvQqNYEYjjfDmymiaFjA6eKu6JPUNM0sFunqOZb
         T1dWnjsVoWFXIBzg21HVlT1QwqTtJ4HMIGdV2vp8pzQov0aTjwcDISMDway2T7RKv0HQ
         MsyQ==
X-Gm-Message-State: ACrzQf17fedmyLCF2JvjqgV6aW1UVaq+skihJp8Kz2R+aGjNZusuHNWI
        D7uQui9Mmrwzbgjv9IRDYVYxS8MIcpDwmCEsziTALVGonfU=
X-Google-Smtp-Source: AMsMyM5nveRv0XMB3Tqec05T/ltpcHJIGx4Rbftqu5IteN5x1+4GJMwz/Yfd8N4x869EOnn1xqYmU1d51q+vLQe3hHA=
X-Received: by 2002:a17:902:d2cf:b0:17f:7b65:862f with SMTP id
 n15-20020a170902d2cf00b0017f7b65862fmr52270295plc.168.1666923892250; Thu, 27
 Oct 2022 19:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
 <20221027204135.grfsorkt7fdk6ccp@skbuf>
In-Reply-To: <20221027204135.grfsorkt7fdk6ccp@skbuf>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 27 Oct 2022 23:24:40 -0300
Message-ID: <CAOMZO5ANFe1AH2PqafbHd97G0L=-LnSyHt5VjBKh0EAskm5JBw@mail.gmail.com>
Subject: Re: Marvell 88E6320 connected to i.MX8MN
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "tharvey@gateworks.com" <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Hi Vladimir,

On Thu, Oct 27, 2022 at 5:41 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Looks like you are missing the Marvell PHY driver; the generic PHY
> driver gets used. Can you enable CONFIG_MARVELL_PHY?

CONFIG_MARVELL_PHY is already selected.

However, there is no support for 88E6320 in the Marvell PHY driver.

Thanks



> > device eth0 entered promiscuous mode
> > DSA: tree 0 setup
> > ...
> >
> > ~# udhcpc -i lan4
> > udhcpc: started, v1.31.1
> > [   25.174846] mv88e6085 30be0000.ethernet-1:00 lan4: configuring for
> > phy/gmii link mode
> > udhcpc: sending discover
> > [   27.242123] mv88e6085 30be0000.ethernet-1:00 lan4: Link is Up -
> > 100Mbps/Full - flow control rx/tx
> > [   27.251064] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready
> > udhcpc: sending discover
> > udhcpc: sending discover
> > udhcpc: sending discover
> > ...
> >
> > This is my devicetree:
> > https://pastebin.com/raw/TagQJK2a
> >
> > The only way that I can get IP via DHCP to work in the kernel is if
> > I access the network inside U-Boot first and launch the kernel afterward.
> >
> > It looks like U-Boot is doing some configuration that the kernel is missing.
>
> Yeah, sounds like the Marvell PHY driver could be what's the difference.
>
> > Does anyone have any suggestions, please?
>
> If that doesn't work, the next step is to isolate things. Connect a
> cable to the other switch port, create a bridge, and forward packets
> between one station and the other. This doesn't involve the CPU port, so
> you'll learn if the internal PHYs are the problem or the CPU port is.
> Next step would be to collect ethtool -S lan0, ethtool -S eth0, and post
> those.
