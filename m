Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C347604FD0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJSSmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJSSmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:42:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99582196EF4
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:42:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a13so26628905edj.0
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FnEHp+n5E9ORlOqVfiOTZjwtbEGC3D3t4hEl0lUPtBA=;
        b=LoEEigcpwhA0b4dOQFXlnXsbSzVXh16XqxJxU0B1jYE6CcykOzrccSZDrFc8vpRofk
         RhYCunqJ/JOa7PxdmHhaDLTEIrx75ELC/x6fzvmP8z0N+lRODd5SfvjsWR08bbIbuACY
         T6fGOqw4psNQWVeuttxeNj1IQuPHFeyJPK7tl3SRgnWsPs/9TfjuMe2ObJf9fnJiDLX7
         E9JAhRVpd+Isr5kncFAcWsky0RnzqZ0ovJ0URJLCbuvLGHaFpWx11OgCbt4syTjupShe
         HzuAdFpAHj1vAozDxSiDq8a6pTbh4YOaAGJiWU5scV8XSXfF+pHFPWxOSg+78jqgwth9
         xqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnEHp+n5E9ORlOqVfiOTZjwtbEGC3D3t4hEl0lUPtBA=;
        b=0DHqEpRM3TiN7WolsnTD1ZL+QrlLVE/AGulQtkW15uH19HkF8t2VF7UimOa8vl2uRZ
         yz6dK9zfRLMTtivD8yp0NlOSS4cKHE0BM0IGla5iQObSS+ZuD84+rvVgSyKNKSTws+r+
         nJlb2mnDQHeAKapBXrNUFh2UfVbHTwPY3rm3898pyYOw1o/w74Z/WMssYC2M+fTSQY75
         YBQN9/V8FVkIM+E1IaDlUBBbKVcDYbMh8M3U5RgFzLRa2mqxiZZnsc9CvRkh0sDOrnbz
         aDtVvdrycPeGfHzdN3bpMgubHXaWz+xMXB00ydAZC4Rv6kBEapiwbG+0ujqj3OY5Lyuc
         TL/A==
X-Gm-Message-State: ACrzQf3+OmHCKxjshExWilgWVxpu6cS+wwE3TGXXdpBmVzjd0x49p+NT
        L/HwiWp2X2mkEWaEeBVzMVs=
X-Google-Smtp-Source: AMsMyM593ieWJV9Uiv4LTeWVb9lQfgS7tQeMsXHu9DW96Daa8+sHCrXDN7Q5sPOm7dclNAMa5XCS+A==
X-Received: by 2002:aa7:dd57:0:b0:453:2d35:70bb with SMTP id o23-20020aa7dd57000000b004532d3570bbmr8876722edw.26.1666204926093;
        Wed, 19 Oct 2022 11:42:06 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id k13-20020a17090627cd00b0077826b92d99sm9331464ejc.12.2022.10.19.11.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 11:42:05 -0700 (PDT)
Date:   Wed, 19 Oct 2022 21:42:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221019184203.4ywx3ighj72hjbqz@skbuf>
References: <20221019162058.289712-1-saproj@gmail.com>
 <20221019165516.sgoddwmdx6srmh5e@skbuf>
 <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 09:36:21PM +0300, Sergei Antonov wrote:
> On Wed, 19 Oct 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> > > The ftmac100 controller considers some packets FTL (frame
> > > too long) and drops them. An example of a dropped packet:
> > > 6 bytes - dst MAC
> > > 6 bytes - src MAC
> > > 2 bytes - EtherType IPv4 (0800)
> > > 1504 bytes - IPv4 packet
> >
> > Why do you insist writing these confusing messages?
> 
> Yes, I see now it is not good. And I have a question.
> By comparing the packet sent from the sending computer and the packet
> received by ftmac100 I found that 4 bytes get appended to the packet:
> 80 02 00 00
> I guess it is what 88E6060 switch adds. But it is not 0x8100. Then
> what it is? I looked into include/linux/if_vlan.h but still don't get
> it.

See trailer_rcv() in net/dsa/tag_trailer.c. The switch is telling you
that this is a packet received from source port 2 via a tail tag
(trailer, i.e. added to the end of the packet, meaning right before the FCS).
I know that mv88e6060 uses this tagging protocol because this is what
mv88e6060_get_tag_protocol() returns. Still nothing to do with if_vlan.h.

Also see if Documentation/networking/dsa/dsa.rst answers some of the
other questions.
