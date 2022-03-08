Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C504D1DA6
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiCHQq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiCHQqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:46:20 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6219551E6C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:45:24 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d17so8961672pfv.6
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=67LEAhU89B0w6L/agLlaPyK1bjDDxvl4HxaEq81/ehk=;
        b=NAGNzuj7Xpnpj81qh+3KZCsWMTT/veS/nnpiI4KuBr7tnoxw2pVp26zWA6/bllmfJj
         xh22NZGI41x04rTn0Ee2Q3xL1/t6v4l+tvG/qiD+Hw4KafR8haI3i5EmkUTJg6jF0cWm
         O8uOeFUx3wkFQl2ysWlazw1M6AGN1OjzhnMY+fkcZrtib2N1uC9/wNAOBmwfrsMJGhf4
         /ppAHloJYlFOLM055Qs3MMAhwgOQqgRwAEUsDkbwaGOJ6aEV3RlIO+cag7fiAxau4Mpf
         Fe+yrVnbx4407OWZPzUaa2Y43XSxsmRM//N4LVzCbBIVUBWMWDqtusBX2C3yySdrFpJN
         8DKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=67LEAhU89B0w6L/agLlaPyK1bjDDxvl4HxaEq81/ehk=;
        b=qQqmQ5UmXVUWSgZ8o4Uda0JAXSxvvmk9NsK86fn7CsXtF80GPm+hkFHXxo8iO+TJ6C
         YOLggQkq9SCEW3bsoMBc7i648+/a3G0z6cQ4sAd95sxpJaVv0VZbJGaCDpUW+kmIbgHW
         DSxrdgrh7K7zz+fv8D1TfZVGsdXsVLGqI1nphRHSueMO5cdfl+qG+58ler7wg6V0D8+e
         2GmzHGjOQqs1ZPfRd0xm7AvlnOJ0WRxuJwr2JsM4/buMsf4N50l3mUYRC8mSttOHW+E9
         thm0LP29r7za7+xyiS7STQ0VQegZdSe60hMVHAKvUpziqFCCbJAeBfSq94xRWeFiQtC/
         aucg==
X-Gm-Message-State: AOAM533GlKFh3U2oQLQTvrmFMoC/JEH9vuVC64ntz849ToDd+Ij1J3vb
        iNBPz6CjZw3A+6MGnUnVZSX3wA==
X-Google-Smtp-Source: ABdhPJzDdAk5qyE/ywViquGt8IcAIw4eF8NCkM1VgoXV52XMcX9885A6Z3oYTbC2Wg9TxHlcDHbd4g==
X-Received: by 2002:a05:6a00:1ad0:b0:4a8:2462:ba0a with SMTP id f16-20020a056a001ad000b004a82462ba0amr19443158pfv.75.1646757923844;
        Tue, 08 Mar 2022 08:45:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f9-20020a056a00228900b004f3ba7d177csm19695479pfe.54.2022.03.08.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:45:23 -0800 (PST)
Date:   Tue, 8 Mar 2022 08:45:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Eyal Birger <eyal.birger@gmail.com>
Subject: Re: Regression in add xfrm interface
Message-ID: <20220308084520.18ddd3e2@hermes.local>
In-Reply-To: <YidTpIty2fVKTBzM@moon.secunet.de>
References: <20220307121123.1486c035@hermes.local>
        <20220308075013.GD1791239@gauss3.secunet.de>
        <YidTpIty2fVKTBzM@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Mar 2022 14:51:30 +0100
Antony Antony <antony.antony@secunet.com> wrote:

> Hi Stephen,
> 
> As Steffen explained bellow if_id = 0 is likely to cause problems in the long
> term. Should we revert the commit because it broke userspace tools?
> 
> I notice the Debian bug is in a iproute2 testsuite, also it is in Debian testing! How about fixing test case than reverting the kernel commit?
> 

This is testsuite in iproute2. Please submit a patch to fix it.
This is not a Debian test.
