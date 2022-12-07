Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C651645A7E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLGNNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:13:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF5B50D5C;
        Wed,  7 Dec 2022 05:13:34 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e13so24797510edj.7;
        Wed, 07 Dec 2022 05:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KIJTn6uf5ipjBKv9CY5vtV1Hkp+oVF6IKDi1Z1ze17U=;
        b=VMJLjAN+QCvNePbdKUldGx4XeyoaC26IemMCfR80C0u4Il56h62+63la6BndXvHG+u
         7EFhxaqVTPyvlxk3lLlUG+/FX7te2J6nWv7N/IRi3n0hyk1TVEh3PbjvFSbTJVRH5FIm
         204Ws5Xo2Cm/3UvrVgpnoXIMAWUTMpv3AtBphjio4u6wQfioOOTisL0AiwHy3GOX+vy2
         6i4sCSCtAtkfYi8/YwjLxg8G/HjwLZSPch5/0hxlPEc0axnRMGgxipmWLznIIEdze2AA
         6YX6ZXqjDvsYNHc9UQHlg5MTbCsnj26iYo8WT9M7KuUZu1F6Tuj77clfbPx+a5IxQMk5
         m8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIJTn6uf5ipjBKv9CY5vtV1Hkp+oVF6IKDi1Z1ze17U=;
        b=tLnGOdzAxDiF+AxeH6EWMPkPgV0oGzQS9emooVImmFIWIKGqx7fUkETg30LV2LYi7a
         udDbC3kJuyOm700Wlr22hbEJZiHzf2WETZpmlzGcu6a2Fdatz/3MgcSfMf43N3Lr+FUh
         vuIpicBjp5mkQw55d/mLYHhdPZW1JD2JQ8NCko8X2X3D/2dVNLtyRv9mhhr8FLsG1nFH
         7hi8SyXGyCgskwz3TFo4wHHhGhh/Cw0hjzpphyK/BDGPEJNuFxAgcXQh5deqyM7njTvB
         roDEmRTiaKUIqOysZOO609Jy2jZH3bYbLzGqZV6nJnUrpBxL3sBtVX/0jfE3Gr9/YaPb
         XZmQ==
X-Gm-Message-State: ANoB5pnwbVUUFwDTflapq7wNNFomMuY4hQ4GdFaMGWFzRwn7eyBWBo4N
        JswfTJ1ywiuM5KCFTb1er/U=
X-Google-Smtp-Source: AA0mqf5dEGRQGRPIJU+djVze2ytX4k7QuRVTwoOo+q8OUe7Dpgl3TXGIbeQddai1A9gh6sueqqq3ng==
X-Received: by 2002:a05:6402:2993:b0:462:845:ba98 with SMTP id eq19-20020a056402299300b004620845ba98mr1778270edb.12.1670418813147;
        Wed, 07 Dec 2022 05:13:33 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id dk21-20020a0564021d9500b0045723aa48ccsm2176388edb.93.2022.12.07.05.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:13:32 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:13:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: [PATCH 5/5] powerpc: dts: remove label = "cpu" from DSA
 dt-binding
Message-ID: <20221207131330.pehewfwmr6pv2sln@skbuf>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-6-arinc.unal@arinc9.com>
 <87a647s8zg.fsf@mpe.ellerman.id.au>
 <20221201173902.zrtpeq4mkk3i3vpk@pali>
 <20221201234400.GA1692656-robh@kernel.org>
 <20221202193552.vehqk6u53n36zxwl@pali>
 <20221204185924.a4q6cifhpyxaur6f@skbuf>
 <84ce6297-5aff-4d6e-8d31-da3f25dc8690@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84ce6297-5aff-4d6e-8d31-da3f25dc8690@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:15:16PM +0300, Arınç ÜNAL wrote:
> As Jonas (on CC) pointed out, I only see this being used in the swconfig b53
> driver which uses the label to identify the cpu port.
> 
> https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/files/drivers/net/phy/b53/b53_common.c;h=87d731ec3e2a868dc8389f554b1dc9ab42c30be2;hb=HEAD#l1508
> 
> Maybe this got into DSA dt-bindings unchecked before it was decided to move
> forward with DSA instead of swconfig on Linux.

Yes, but swconfig is not DSA and their bindings are not compatible
anyway (swconfig lacks an ethernet = <&phandle> property that would
allow DSA to work). Still waiting for Pali to clarify what he had in mind.
