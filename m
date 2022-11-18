Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6057C62EC00
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiKRChk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKRChj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:37:39 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59C98D4A3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:37:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q71so3812096pgq.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y3buhQ43czxzDcyasaiKPiKRm9LEuYX1OiS918u2Js=;
        b=HGrIUHIWMQwEoiRLP93PtNJsSSxNGqHLzm3xwseLuj+F+NeTilya5vXcbexzSd6a2Q
         Ju6Zdip1//Zoo2DIa5XvQTxjFYrw7S67Kvf9MeiKs5m0/780onqzAmrOWGrD2Ybsrd5G
         wok705udZm21rxjCUCHzB/Rp6T0KOHhisXkBUq7yjqMsocv/gR0lTp2crEn3C9LLTtbr
         vV39t9F2i67L7xoosy+99uPtlE66uUIeDffWtq0/QOn4h8O1hr7V1kGykbUD1dlEPdmV
         Gz+6Iy1fcMpbV6zGcG8eHGURWVGqEMSoXuHQCA3OV/+NulbhQSq4njqKtp4YvLAZ+bTp
         4IeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Y3buhQ43czxzDcyasaiKPiKRm9LEuYX1OiS918u2Js=;
        b=TLJB/xYhVfrNKQaswQnKI2y/Au/rN8scknKrFn7UGhk1v1rMiSkiPQjK4ynfdsJO5q
         PnlpC9aWYmn2OM+ecsLGHjs8hlmKldIaz3Wm9kA12k6bepTIhxllexKHZqk0UVRJH26F
         RirI40DQEnaccFTLbDddnJKsoe6EzgMjCuasl7l5AGejhHlArls/itx2IU1ZT6LUtrHL
         LB54DFrknes6S9798ODSyPr0hK8IHW6brqKGaIPhm53tpOBb7+icfp+IsPVhDcU8EzRp
         NykGwBGjP/k5qgbj/iuqHcaraJvm/MKdF4NX1Ho2ziU56+IGxmiO9mW5tqpPWRh8jKJD
         zUFA==
X-Gm-Message-State: ANoB5pmOWq7pwZVDj8YCvJrRC8Zd0juCUiS4zY438pbxZi8HK5avf06Q
        IyZA2OQno6B4JcIYu3Rd9nvlRA==
X-Google-Smtp-Source: AA0mqf4fVlCM1W9CNGvedEAdELiJUSqaxsnNkIFbID7My555jXLkUBcMe6TjsIbxMwNpp1DFQQIHfQ==
X-Received: by 2002:aa7:9551:0:b0:56b:1fca:18b0 with SMTP id w17-20020aa79551000000b0056b1fca18b0mr5803334pfq.42.1668739057328;
        Thu, 17 Nov 2022 18:37:37 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id jg18-20020a17090326d200b00174c0dd29f0sm2168800plb.144.2022.11.17.18.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 18:37:36 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:37:33 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221117183733.5ff1dcb5@hermes.local>
In-Reply-To: <20221117123615.41d9c71a@kernel.org>
References: <20221027212553.2640042-1-kuba@kernel.org>
        <20221114023927.GA685@u2004-local>
        <20221114090614.2bfeb81c@kernel.org>
        <202211161444.04F3EDEB@keescook>
        <202211161454.D5FA4ED44@keescook>
        <202211161502.142D146@keescook>
        <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
        <20221116170526.752c304b@kernel.org>
        <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
        <20221116221306.5a4bd5f8@kernel.org>
        <20221117082556.37b8028f@hermes.local>
        <20221117123615.41d9c71a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 12:36:15 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 17 Nov 2022 08:25:56 -0800 Stephen Hemminger wrote:
> > > I was asking based on your own commit 1e6e9d0f4859 ("uapi: revert
> > > flexible-array conversions"). This is uAPI as well.    
> >  
> > Some of the flex-array conversions fixed build warnings that occur in
> > iproute2 when using Gcc 12 or later.  
> 
> Alright, this is getting complicated. I'll post a patch to fix 
> the issue I've added and gently place my head back into the sand.

Building iproute2 with current 6.1-rc5 headers.
Gcc-12 is clean but Clang gets:
    CC       xfrm_state.o
xfrm_state.c:490:8: warning: field 'u' with variable sized type 'union (unnamed union at xfrm_state.c:486:6)' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                                        } u;
                                          ^
This problem started with 6.0.
