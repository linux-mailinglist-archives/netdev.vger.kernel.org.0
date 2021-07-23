Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF83D3C19
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhGWORg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbhGWORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:17:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C72C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:58:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j17-20020a17090aeb11b029017613554465so4054202pjz.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HRJtn/8J6Ef+hfSqR0UswiIqTIEv2+GcedNfnC3WIGM=;
        b=Zd9x2juOIz2x93ag2r0RrdP2HAMSXnz07AYvYO6+xp3mclCPsBca9BxVVexq0pXMIo
         eqiWJZSaWAXyBXAk/kGl0aTZO3KIYQLMUM24hYoa0MRoA3bYOljMnOui6CXah5lV2F15
         HKrF7KJhL3XzMues7Fri+UybF4T9UGzlhw9AoKYkfEy1k1vNW4jkEesVxY6bdg29JA3N
         vH75eXQfmOSjJtQmtdzDZskeTFCmd4Kr1raRrXNPP5WmkSmN3Peer7x7Tr3m9x6tacCw
         b6gPuTldbYiHkUmtOmJfMuJ30FH1FjDgOVlySkExDsAycBP4UlPm5v6mylD7kh0nuJzN
         mDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HRJtn/8J6Ef+hfSqR0UswiIqTIEv2+GcedNfnC3WIGM=;
        b=nEjpUL02naKmG7YS77cNvoCPlp5s9TDGBgABhYENXXJeNPXwPvc4lj7pBIXu5dUY6k
         w9Grp5Q2jnySm7i9x4aQ3sOdtU6VnkAI2Kx2kyEWehIH9iFE6wwJqo95fbe5UcrcznAp
         lklPbA85GEfC7VwlzKwYi3lmFdr5oi5868phuuLBHN/8qLwbKfJi4bKt4fvzffy+u2rd
         qou5pTc2uUgKrUDeU5Cz41anIwM1iSlz32vosrT7lQ4oOwM93TgmAtTgI7G/X1Boar9h
         cejyqTXfvNAZBcO0N9pWJICG3KcjSpM6NeXl1WZcCdxf8ycEbMEBM71VcJujc9iCI1Sz
         GDxQ==
X-Gm-Message-State: AOAM530LPCiKrYdGLJJqJAYry+btj6C/x7T25aYRnddbw0v25gCuE92g
        ZMGB0M/p6gGrvIH6ItDOvzbUC8NLYRR1UA==
X-Google-Smtp-Source: ABdhPJyCwIZrkjVFX3xrU5BijigXPYjyCYx+Yr0S1fn6HUKzRrCpyZXNgvLq+drAG4KEV5AHeLIGaQ==
X-Received: by 2002:a17:902:d50f:b029:12b:8ae4:22f with SMTP id b15-20020a170902d50fb029012b8ae4022fmr4102420plg.25.1627052287603;
        Fri, 23 Jul 2021 07:58:07 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id b17sm30782296pfm.54.2021.07.23.07.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:58:07 -0700 (PDT)
Date:   Fri, 23 Jul 2021 07:58:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/3] Add, show, link, remove IOAM
 namespaces and schemas
Message-ID: <20210723075804.1387e789@hermes.local>
In-Reply-To: <20210723144802.14380-2-justin.iurman@uliege.be>
References: <20210723144802.14380-1-justin.iurman@uliege.be>
        <20210723144802.14380-2-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 16:48:00 +0200
Justin Iurman <justin.iurman@uliege.be> wrote:

> +		sprintf(data, "0x%" PRIx32,
> +			(uint32_t)rta_getattr_u32(attrs[IOAM6_ATTR_NS_DATA]));
> +
> +		print_string(PRINT_ANY, "data", ", data %s", data)

The json_print has ability to handle hex already
Why not
	print_hex(PRINT_ANY, "data", ", data %#x",
		rta_getattr_u32(...

