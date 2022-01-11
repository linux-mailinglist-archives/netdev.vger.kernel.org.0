Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB1848B23E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349798AbiAKQcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343735AbiAKQcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:32:15 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD268C06173F;
        Tue, 11 Jan 2022 08:32:14 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q8so33921137wra.12;
        Tue, 11 Jan 2022 08:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cm0/vlrbVoHC8EKntPoP9arLSNzILpHsWLdE6JegkyY=;
        b=jUbFR8ADouExloAaglVvAmTKIPFozbCj6sCWHnkNmAlyTr6RGgjABvacC2dI1LyJG4
         9VWoI2mQZ12atYTWkoocdpRJko/+3ntMBQ287jUbDDY6Cr+lynAvNn7lSTydlclKg0UI
         6Y0cHUM6+UGM5aXwGMFu08/wyscIcHkcc+op8aM8xAz1BiuvEFXy5vGjjz9AXQAdFk2s
         JaQCbA2Jxg7Qo4ggZgyF7WWXCsSf40RCLSjUXdqnFDZ74XvJ8x68q5eqpx1VV8ksWVlI
         x4AEiL48+s7vFr75bGudz/4uRjn1pHdo6diVtlBs7oaVQomzTa98RksHhTPRVnG7tbBZ
         mojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cm0/vlrbVoHC8EKntPoP9arLSNzILpHsWLdE6JegkyY=;
        b=ARWF3SRTQ19vDQxrOhzsxAHlMa7g31f4aoYOUrWJiueSqa+i7tOMvRSneYiKbvH/Sc
         Pq+I3ORSH9r2CsFus6d6bTUrSKi/0mMXtghQBA81Xk3HvFi+/YE4j4W+roI9Ke5VnydL
         2WnHoSD9kf6QXk+l9VwMrs08fs1fywZu4K2dM4QJc9R7iVmDedXJ4jMyZJ2tI1WlVmF6
         4uXQw9dbs0aN3BiI2A33IfkBWdTq0eMXZtLorzSaQhC3K5uKoshtRAc+o/FAEJvtzblX
         ftfjkDrNjc6yVktxo52ZnUMGheON8QaaXTMzZTy0Z1+ka5mBhjevv+VGzeVV9oMJh17/
         WL5w==
X-Gm-Message-State: AOAM530LcMdf8xhLeVjkcAzRuWYeAhLUTQdITQ73oyGv61slAfXcF7YD
        b8NJgJOylF8521U8hidNXlCCRePhLWg=
X-Google-Smtp-Source: ABdhPJwQVDP7EBAc5a0jP9RNVlfv4J3f+CkCGmmtRWzBRPAtxpItgSsAP0A0637uTt6tXPhrN7OB9A==
X-Received: by 2002:a05:6000:1e15:: with SMTP id bj21mr4679919wrb.118.1641918733315;
        Tue, 11 Jan 2022 08:32:13 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m35sm4432736wms.1.2022.01.11.08.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 08:32:12 -0800 (PST)
Date:   Tue, 11 Jan 2022 17:32:11 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: sun4i-emac: replace magic number with
 macro
Message-ID: <Yd2xC7ZaHrTAXcZd@Red>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 11, 2022 at 11:05:53AM +0800, Conley Lee a écrit :
> This patch remove magic numbers in sun4i-emac.c and replace with macros
> defined in sun4i-emac.h
> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>

Hello

I sent a CI job witch next-20220107+yourpatch and saw no regression.

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun4i-a10-olinuxino-lime

Thanks!
Regards
