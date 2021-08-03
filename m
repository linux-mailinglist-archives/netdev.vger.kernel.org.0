Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC8D3DF417
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhHCRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbhHCRuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:50:04 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8A4C061757;
        Tue,  3 Aug 2021 10:49:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y7so680710ljp.3;
        Tue, 03 Aug 2021 10:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=appGSUBpUB7Z4hxXq9WMmGcqxVJ6QSkBfy4QZnBqvu4=;
        b=ltB7icxkbjWA6hiTSxZX9NyK/fLidSmbgMv/3wIkhgNxLQBfkelhQFZeWet4CfDZgc
         wYLhi7xOSxfOTl0n7NcTOJcUZM+ESkP9HBbeqWeGQrefIs62L3Z6iSbqGOFLoTexAm18
         nPKpwUD4KxRJIZSIWg0/XHOOUVwJe2cPGaPHfdsP4Nj/Q153ZDRNnrFUFheDOYXYB3fK
         KNq9/k4N9725qjtBn8BrYp5eEqE34Y7cHeykO/EiJgEAU+S0jLpTuYYliXQYWda0Imte
         w3U4w/GngXULgKUGBw5owqS9gTUnMrDCPvTciP5gh0IBtRYFG1i5tsHXZqD6y3wePLBZ
         6Bog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=appGSUBpUB7Z4hxXq9WMmGcqxVJ6QSkBfy4QZnBqvu4=;
        b=km5KqVBhz2g+xyWy6JYpdhRXU5dBzA8wm0LpanTM459DVXajqA/HNTembIVRqPjVcY
         QTXopApqXWdcJXR231N3aJegNt5pbCIXFL2+0UtRGd9XiB46cEV03TxoE6Z+NM57s8iR
         cXA+T/QIBFepP00v/e8TlOuHOTzAgvv3ZtHGUjNW8IBM+n6azQKtX3Ak9t2bQALrUWw5
         h1kGS1N1itSALGSU92nK3crRxIEHZXEFeeTXvM0eMG8Zu2lCHT9XZS16XGkokhGNyGv8
         bxd3jZBCQvnPc8UwV5NLkxzJhIo7mcJgIf70N8dXNZjZKx+YgGzH8wBuxlZOi6FJPQUw
         jDZQ==
X-Gm-Message-State: AOAM531+3mEJad9qRHy502DN5+sKkjS7ridypQEoZPRsBw13VXjvP0iV
        HkycIt4kASmECLuRJF48fKY=
X-Google-Smtp-Source: ABdhPJwONsWN0deq41ItULAiY4kLBQgqlUipGLJwKN/ehwJvw74A3i73Oye1AgVseUpWQ1K0d1kucw==
X-Received: by 2002:a05:651c:1144:: with SMTP id h4mr15079623ljo.396.1628012990846;
        Tue, 03 Aug 2021 10:49:50 -0700 (PDT)
Received: from localhost.localdomain (broadband-90-154-71-87.ip.moscow.rt.ru. [90.154.71.87])
        by smtp.gmail.com with ESMTPSA id w7sm1306481lft.285.2021.08.03.10.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:49:50 -0700 (PDT)
Date:   Tue, 3 Aug 2021 20:49:46 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net v3 1/2] net: usb: pegasus: Check the return value of
 get_geristers() and friends;
Message-ID: <20210803204946.38978b72@gmail.com>
In-Reply-To: <20210803172524.6088-2-petko.manolov@konsulko.com>
References: <20210803172524.6088-1-petko.manolov@konsulko.com>
        <20210803172524.6088-2-petko.manolov@konsulko.com>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Aug 2021 20:25:23 +0300
Petko Manolov <petko.manolov@konsulko.com> wrote:

> From: Petko Manolov <petkan@nucleusys.com>
> 
> Certain call sites of get_geristers() did not do proper error
> handling.  This could be a problem as get_geristers() typically
> return the data via pointer to a buffer.  If an error occurred the
> code is carelessly manipulating the wrong data.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> ---
>  drivers/net/usb/pegasus.c | 108
> ++++++++++++++++++++++++++------------ 1 file changed, 75
> insertions(+), 33 deletions(-)
> 

All's good! Thank you :)

Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>


With regards,
Pavel Skripkin
