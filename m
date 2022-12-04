Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3F8641F08
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLDS7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiLDS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:59:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9936913F42;
        Sun,  4 Dec 2022 10:59:36 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id i15so4862867edf.2;
        Sun, 04 Dec 2022 10:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UWFacJGvShq0MLP6hc6MDufkupxByDzBx9Z7939niQ0=;
        b=LGvHERI6oyWwiCHULvH6sMEOSMhMXAN8vdxVZtzn4tnVQT2jXbF1aDKMhHjgOuz1k/
         pPR2sTh9q887dXIswwY3uGp1YA5p8rA9I48j+CeKgUq9Sr9lhsXVQBeCC8nQjK065y/b
         ktMEWuNc8pMWW+YeeFBlp1OPHjfW/iUIuLMBgAyc5zzvwev9qq0Per1/lVNlHVUArojs
         MbhFv/uq2GMD34aPqVzPb0tv4FNUOfPfIw7EdTpEJAt+gwa03v4YH4QY03coOwUb+YG7
         m+QPkcF5XR4M4nV2TYPv/BW9/ayofL0I3dTQj5pdCwl5fvhWzpKUdsy7DUxvzOLRv7z1
         hYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWFacJGvShq0MLP6hc6MDufkupxByDzBx9Z7939niQ0=;
        b=uGiGEQf08sfxsDWQxC1bwBRKUKeenbnX3esm14XzEn0KGZ5DZLsfNH4LaiKCncAo9Q
         BJ0XUgqfHoL0aFWoLjAFA38WAuRTiA111tsnYbCRK3btDnKSMo3Wmqj26Cj6I23r4Sx+
         RLgM6a2Hbb0xCQAsftvgEi+MnQpKejHGI8293yM7JwJb86cEj6hAxpNzgibOaA1+3Fbq
         pFMZOkV8E51W9YOv/wajI0E58hJtnJhKuMQNQm9uHyIoHaaMdHLywC1M5vcVhnrIyaPn
         nqgvkH8KfG0Qh1pb1uGlvamopBuvW8FgNEHw3y+Eb/V/4tG6X4rZVeXT3zG5bs+z0jJZ
         g+NQ==
X-Gm-Message-State: ANoB5plB2G70WfJ5Pw34XCjihfdpIbtMn2Gnq5LzR8BGTjlEHbiBDdQj
        iHc+s/mtarXOFMJZC7I9HmJio6KTL5LpQw==
X-Google-Smtp-Source: AA0mqf66vAKaq7DgWJVMxS61oXNDXn2p4ix9hDG7xu+24V4eKMbZP+QyHUC46ZpvsFrwMxwzBFs+OA==
X-Received: by 2002:aa7:c0c7:0:b0:46c:8142:3873 with SMTP id j7-20020aa7c0c7000000b0046c81423873mr4393459edp.428.1670180375069;
        Sun, 04 Dec 2022 10:59:35 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id z3-20020a170906240300b007aef930360asm5456794eja.59.2022.12.04.10.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 10:59:34 -0800 (PST)
Date:   Sun, 4 Dec 2022 20:59:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Rob Herring <robh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH 5/5] powerpc: dts: remove label = "cpu" from DSA
 dt-binding
Message-ID: <20221204185924.a4q6cifhpyxaur6f@skbuf>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-6-arinc.unal@arinc9.com>
 <87a647s8zg.fsf@mpe.ellerman.id.au>
 <20221201173902.zrtpeq4mkk3i3vpk@pali>
 <20221201234400.GA1692656-robh@kernel.org>
 <20221202193552.vehqk6u53n36zxwl@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221202193552.vehqk6u53n36zxwl@pali>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

On Fri, Dec 02, 2022 at 08:35:52PM +0100, Pali Rohár wrote:
> On Thursday 01 December 2022 17:44:00 Rob Herring wrote:
> > On Thu, Dec 01, 2022 at 06:39:02PM +0100, Pali Rohár wrote:
> > > I was told by Marek (CCed) that DSA port connected to CPU should have
> > > label "cpu" and not "cpu<number>". Modern way for specifying CPU port is
> > > by defining reference to network device, which there is already (&enet1
> > > and &enet0). So that change just "fixed" incorrect naming cpu0 and cpu1.
> > > 
> > > So probably linux kernel does not need label = "cpu" in DTS anymore. But
> > > this is not the reason to remove this property. Linux kernel does not
> > > use lot of other nodes and properties too... Device tree should describe
> > > hardware and not its usage in Linux. "label" property is valid in device
> > > tree and it exactly describes what or where is this node connected. And
> > > it may be used for other systems.
> > > 
> > > So I do not see a point in removing "label" properties from turris1x.dts
> > > file, nor from any other dts file.
> > 
> > Well, it seems like a bit of an abuse of 'label' to me. 'label' should 
> > be aligned with a sticker or other identifier identifying something to a 
> > human. Software should never care what the value of 'label' is.
> 
> But it already does. "label" property is used for setting (initial)
> network interface name for DSA drivers. And you can try to call e.g.
> git grep '"cpu"' net/dsa drivers/net/dsa to see that cpu is still
> present on some dsa places (probably relict or backward compatibility
> before eth reference).

Can you try to eliminate the word "probably" from the information you
transmit and be specific about when did the DSA binding parse or require
the 'label = "cpu"' property for CPU ports in any way?
