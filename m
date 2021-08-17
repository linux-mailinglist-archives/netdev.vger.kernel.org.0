Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1CF3EE223
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 03:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhHQB05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 21:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhHQB04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 21:26:56 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1B2C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 18:26:24 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c4so6631381plh.7
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 18:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=76lPgHc7eZGNNRAuhJfd9UswjdNIPOmEHv90qlhAJ2c=;
        b=EOjCJyG+j2gODAmWo6UdntWGvQiVmDXsi77JhHqUfJVtpqpkRLKTjNZLMnrhhQQMWQ
         9IwyvegyuHJNG2Q3b7DDkz3GSAtOnbMmlbETDS09z5gZrL4CnKdQa71fg5DSOf19AjdW
         xAzm2FRCxznsXluL5TCS6F1JtfYu+Arch36bwb2Z4kzJCqYEXlWd+1HvYQZB0mbv7HaV
         3UbQ/LOJMA6BHFRzXn256IAbTaRABAuzPLWBOxvjaKFWYrfx9A3gIyeVOSuv4L443ne9
         Y6Nc/ADW4DzzyEkSu4CdkXZCzLzCCwS4gm2dNadUWjVHkiJDzmXboXWEoBy52mG6zo5S
         1jWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76lPgHc7eZGNNRAuhJfd9UswjdNIPOmEHv90qlhAJ2c=;
        b=t+GtnAOCw/l4DNGlXtKoDln9CgIrlssth8fYrBihn1hHjnbLt1X9DEeDg+QgjTi3o0
         05n6c+C4ehzXz2BwYx4me4dCcOv/cc5KPzyphwCvN2+79fJm4dSw1sKYfV5s0IycXvTn
         K+H9cuBVfhLPSXPOBiMF49WIBOMTADPTzSKBrTzJLYk707tKFYfRmCFK+0PCJWZyMqcL
         odJcD4zFCssnPtNRum+CZyj2AVzkPPzRU3Qe6V8P5zCUdIbaaMmp5wmlHNUG+xL3pPHX
         bcU/Y6aISLZyh5431dk2obDt2tjVsx5+lTIeVdbV8b+ZU0zYs0QmWZVT7wkKkUczDdfv
         x/Iw==
X-Gm-Message-State: AOAM531MuGxsbHtFUerDXegnlTUWsEd8AnryzToo3xIPC1U0PMHoZVra
        0vpRlaJNx2j3YTlOxBZocfiYJw==
X-Google-Smtp-Source: ABdhPJwac5H2las9VZegsTvgy0pZRN+eTLj3Wro5TfpOWWLmEcWsRohnqGznaDqrHsBXspBHUwAmLg==
X-Received: by 2002:a17:90b:3708:: with SMTP id mg8mr872256pjb.19.1629163584135;
        Mon, 16 Aug 2021 18:26:24 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id j23sm319421pjn.12.2021.08.16.18.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 18:26:23 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:26:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] ip/bond: add arp_validate filter support
Message-ID: <20210816182620.273bb1e4@hermes.local>
In-Reply-To: <20210816074905.297294-1-liuhangbin@gmail.com>
References: <20210816074905.297294-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 15:49:05 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Add arp_validate filter support based on kernel commit 896149ff1b2c
> ("bonding: extend arp_validate to be able to receive unvalidated arp-only traffic")
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com

Since this has been in since 2014, it can skip going to iproute2-next
