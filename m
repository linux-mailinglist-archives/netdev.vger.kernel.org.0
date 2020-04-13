Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F891A6DB4
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388693AbgDMVBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbgDMVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 17:01:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA5FC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 14:01:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e16so4068071pjp.1
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 14:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eG1ZzCBB8gddwwOOsrdeBxproKyMmkUDNlyGFbpWgwQ=;
        b=LnYTu7SGB+Fr6dnMpGQ8o/2flvmhcMyLHb7eJxPjkt33VGNw+SESScbGcJgax4Jf5P
         odfyL5AizraQpcg7TMBFxDuU4qyeHLdY7VEYSNflJzpFhnfhzww+MBuqqElHwTD4ExVK
         0AQpMKUL6SHv9owMgVbtbD5zfn7NR/+/uJo5bLcVvp7ioKPElvq/W/uxxecRzuqM7hv/
         3cYK/fbQGYoqJpjVZWtZrM9C/2EBNxYyPKK+4PLTeZ3wxYncRAAk0BqMhrfDGKt3hbTo
         /QMFCepR0712zxSBp/VZtFeFW2Ge1Ik+lz2jv5W5NILsLhlJNUDusHaU5YbuH+fQT+o/
         VxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eG1ZzCBB8gddwwOOsrdeBxproKyMmkUDNlyGFbpWgwQ=;
        b=Wuc95xOGidNtjpSbhyrtDIphleiQEhnRcgHDYICPXtRqVr+kJvGcXkx4ThAxmjJ0mb
         rBZTfQXZL7ZCpiqg5ia9eoLPG7NKNubnXhhf7pxvgozTEuczyL505ij8E/xvLH2/OysM
         ZgZRTrtOZR/A+iAdzQ3IhskccQdVHRbw2BZ/sXK7JtQUoLXKmgXd8mktBK7jGIWFyhtY
         GBs371fEYeP1or1eY9GpuOnUxAd4GeoT4DjaijeJ/W2sZuCRRx69hRtLn5mO7pSTlcze
         GnDMxwPRS7ZN+jO5GxZscx73Nc/UCW/fIyEkvbTYTkMtQvJJvAERJVQJETewQsp6iPYR
         1ItQ==
X-Gm-Message-State: AGi0PuaTMwQuJ++6U/IbnfQ1h0bsB3QQK6sPF6FGh+VpCPaC7XzEK3xP
        EV7WyaUFuow8yK+420r+7HurPQ==
X-Google-Smtp-Source: APiQypKK7CglMD4+pX/IDMp9GwsGMW9eooSdFbxnwD9rV1AEN/xMQaaP3yNV9UnUfAMk/J4hq2Lgcg==
X-Received: by 2002:a17:90a:9f86:: with SMTP id o6mr23493573pjp.156.1586811693027;
        Mon, 13 Apr 2020 14:01:33 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o187sm9394529pfb.12.2020.04.13.14.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 14:01:32 -0700 (PDT)
Date:   Mon, 13 Apr 2020 14:01:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 v2] devlink: fix JSON output of mon command
Message-ID: <20200413140124.673ffeac@hermes.lan>
In-Reply-To: <20200409182951.2334-1-jiri@resnulli.us>
References: <20200409182951.2334-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Apr 2020 20:29:51 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The current JSON output of mon command is broken. Fix it and make sure
> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
> to end the JSON properly.

Applied thanks
