Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62A107C59
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 02:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWB4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 20:56:23 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41357 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfKWB4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 20:56:23 -0500
Received: by mail-pg1-f193.google.com with SMTP id 207so4216615pge.8
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 17:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2m8mazKsK1iIQMkib+fQevuXM9vS81kOHQ7iWl6rJf0=;
        b=PxiZnSisGz7WtLCyb5Zo84owxbi8yWE4zQzN+IsECHGL5IktBaZh1CBF/BmJZ9xyUQ
         5BIavVHXiESHEwvEKzjyQ8zan/Yeq8fGaudpM+W1YDyxMMQ2L2yEUG9d7S6QXQbiiHnP
         7FqmXOzvpsGRbyWkAMLdFjry7fbArAb4M1i46QRUa4uhpvlZe+dUhAiOXtSr3YyFXR0k
         Z3C5g0jI6RK9ENUqJxLWb55SYZw0SevoJBjT0n6VTisECbCL3uJ57recnVQ/jPbCp2Ql
         4EVEOa3YwAScqA5QnwUY1fxDau435eFL2Nns1npvH9j7D5vjwyBEEOs7hqI1g2Jeptn1
         X+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2m8mazKsK1iIQMkib+fQevuXM9vS81kOHQ7iWl6rJf0=;
        b=jwkee3eJWj4WNXEqXLJiFzwCy6g0+beFGGaaZWN6oSeeVRKEDXzPSnTMytuFMMxxeK
         wW+mEC/gO5Jpr9j8x2j6Z+v4+Wvc4QmoH9Nr2A25wm3oOFBhRMQ2i6dYJIl9TAuYhCnd
         aLYCIXtcVeQo+r5C0qYYnVRoYt4UGXvRvCYV/yWnarXFaSmz377mrz8EPKVu63QPlfqV
         G9eQLbXT4U93bVvd92KqzrpeMsqwvLmCIvkCWUsKjwlRlSu5TnIR3JXEQbpYR5DrraRO
         rFZd+QGOxjKQzEqbqUq3GkFUcDCcEQVjwQSIxOHImK1bhaCV1ipkQGbQdbAbsxls1tvl
         DgWQ==
X-Gm-Message-State: APjAAAWKNOHvNTSqdONmna/Uig1j6EAKf8BTRqthfmpq5T1ueMqvywAj
        2gsbRN5l87Se7uhS+ssZeB4DIw==
X-Google-Smtp-Source: APXvYqzy3a/db3fqcVrzvoaG7d1opGAEhfDA0PBgLBXFoHFnQBV+oO/Z9oxNAal9M36HM+6HgRdyVg==
X-Received: by 2002:a63:4a01:: with SMTP id x1mr19137247pga.312.1574474182325;
        Fri, 22 Nov 2019 17:56:22 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 83sm408571pgh.12.2019.11.22.17.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 17:56:22 -0800 (PST)
Date:   Fri, 22 Nov 2019 17:56:17 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH net-next 0/4] sfc: ARFS expiry improvements
Message-ID: <20191122175617.0adb37f1@cakuba.netronome.com>
In-Reply-To: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 17:54:27 +0000, Edward Cree wrote:
> A series of changes to how we check filters for expiry, manage how much
>  of that work to do & when, etc.
> Prompted by some pathological behaviour under heavy load, which was
> Reported-By: David Ahern <dahern@digitalocean.com>

I guess that counts as a reported tag? Lemme make the By lower case,
then ;)

I'm not 100% happy on board with the abuse of statistics to show the
current count, now that we have devlink APIs to dump tables and capture
their occupancy.

Applied, thank you!
