Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC57F951F1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfHSXxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:53:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41565 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbfHSXxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:53:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id i4so3961943qtj.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 16:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AIDRHw1/KiLr7UmXvp2zhI8Bb1peNbuqWd3BSli0jwc=;
        b=Kbazf/u3dEUS6lE3K152lxnBk93g038woC5OXn4RRZKUi/vf88p+9Y9tt6NwfP+T0m
         1rNFVgLM3b6YOdsE/UZjpy6KYBPPBTVoZgS5dytw6BwQHB7P0YggksJsKzNgA4IqJd1t
         aavS1q2nDiJIsiUZZ+M2+HESurCvanWHefweTB6WWUval7EDTWQsnsvUlwsPeEYtJRzP
         zrSGiYrUgJMSo+wXP2p3B2a+J5j4ZnhYxBK1SNCI+w5K5m1qFXsh0Bpl8Ml1YzQLHpfr
         YGHaLWKPavdwVvAKCHiYGuZofSU6lYOzAPpJFLiAdhUk7mtWsJIiJADEeR7B+F8Q0ARc
         Bugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AIDRHw1/KiLr7UmXvp2zhI8Bb1peNbuqWd3BSli0jwc=;
        b=B3k7sWkgzCb/zYwhbwCNdHoDBfNIbP8k2ktqJdacc3slmxVlz2ZDW2bU1kqrS0FpT/
         Lm9GA0Id2wOr8s6JKEU7CRIf4DQspq6ySOf6nImEXdGO0tLYD0hhsTOrM07dkOPpVhEQ
         /JEXRsR8tj9MXT7J6bFj0ph+4y+mN5H04fiqqgN7aec1v2Yd3qdqrwxRI/mA6z2G5r6R
         clPGJ/NBe6oHUYqIP5RFe+PjI2BJe8XK/A1Ynuu3Vcg76gK2cqK7YyVoL9c8Vq7avlS7
         7l03oZfIZjMPnz6Fsesro5AiJcFX/JOp66nfCbq2E1jBC1n4c2oalhDijZgM8c/GhVpw
         ZJyg==
X-Gm-Message-State: APjAAAVHk/XGar9klVFxk2ElXmL+7zPSd55BH1e4mi/AaAK6EhKTnhiz
        VaVsm8tzZWVn3T/4+RfLxHmttw==
X-Google-Smtp-Source: APXvYqwTgEEQlq2YXaR7J/GtQXUoLzZ9unaM7PLFTbLMXdenWb/uDryZMnhzbUXgXQYrq3LZ47NVhA==
X-Received: by 2002:a0c:c93c:: with SMTP id r57mr12120231qvj.226.1566258790089;
        Mon, 19 Aug 2019 16:53:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q13sm7761210qkm.120.2019.08.19.16.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 16:53:10 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:53:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 09/17] net: sgi: ioc3-eth: use defines for constants
 dealing with desc rings
Message-ID: <20190819165301.4922e86b@cakuba.netronome.com>
In-Reply-To: <20190819163144.3478-10-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
        <20190819163144.3478-10-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 18:31:32 +0200, Thomas Bogendoerfer wrote:
> Descriptor ring sizes of the IOC3 are more or less fixed size. To
> make clearer where there is a relation to ring sizes use defines.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
