Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA9F7943
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKKQ4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:56:42 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40863 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfKKQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:56:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so9799386pgt.7
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 08:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQ+E6czJ4DNaGOkMLTz7dyfB5cXcK4wWj6bFDEgy1h0=;
        b=ebFjG3a7GurRBYEtFEzgyjSkDQrPT+h3Oeke2Fjt6QWFc1kk89q1scDl25V3vMp0Z3
         9RCiD+1QK1wu6ZSFHVD5gc4qxQ8wRwhW0jtrBlwLzEvFeOuYXX23CfnIPAwdJ6bk3lkO
         FIJS8C3imAMAgF+Q34zvN5SK9ucCPIvVramajPclRHIMIlmgq8l4oBAMcX0GlNsJI7A9
         dUgVkCehUDS/bcO9t6QuxUUIZPngPGWnIqZBbQsEkVS4WvQy6u9BS+q7hKd2chF6QPa/
         K58vsA3r9KTC9VBQHCJmtvUEMsENBGbHJIMdIT8iKdW+oa0gfgo83xuDaaypZnb5HGaX
         l3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQ+E6czJ4DNaGOkMLTz7dyfB5cXcK4wWj6bFDEgy1h0=;
        b=qJmj9Uy/Ld5ijp/yeMBGK2pygeGUtUbgV+ImSDJG+1X7M0OdoaxJAEbCsvxQks8dfE
         sNJA2mwIidbFNuRLoBpZdHOSuLHb6/Kp3pS7PfyJYv47rS3XEMOXMp65aSC0xeTw/CIj
         yzh3BTp/7rVV83kU4PLRZl/GKZIqO6zIwAhEZ5691PG23+55SFhO7juZN4ArB9V5VeOQ
         e3gybQ/yIe8b1tTbPObl+o1D8kMFx1Q8FRrjucJrErUaWiijoMVZz3HwNHD6Cuc5J5Oc
         4RSDWD5PeebDVAOCDLAlgNqfebzM4XxBk9u98MNLvvl5VphmI1GaRk6N485EFUkG1mx0
         yZ3Q==
X-Gm-Message-State: APjAAAUCF5uR6qxouHW3MhzyKYSix12VC85g1fO/Mku8cErSCtUoAT3U
        uETDmeQatZ5qnvEFCfUZ9imIwQ==
X-Google-Smtp-Source: APXvYqzUshE6db9IdPvXjjrLX/g9qtWYzSDysJ4A1JV3KsHmRlMG+2hrZcbvDkueZZaRowkldzfB0A==
X-Received: by 2002:a17:90a:22a6:: with SMTP id s35mr34591908pjc.3.1573491401372;
        Mon, 11 Nov 2019 08:56:41 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r5sm15009594pfh.179.2019.11.11.08.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 08:56:41 -0800 (PST)
Date:   Mon, 11 Nov 2019 08:56:32 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     davem@davemloft.net, shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove static inline from dev_put/dev_hold
Message-ID: <20191111085632.24d88706@hermes.lan>
In-Reply-To: <20191111140502.17541-1-tonylu@linux.alibaba.com>
References: <20191111140502.17541-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 22:05:03 +0800
Tony Lu <tonylu@linux.alibaba.com> wrote:

> This patch removes static inline from dev_put/dev_hold in order to help
> trace the pcpu_refcnt leak of net_device.
> 
> We have sufferred this kind of issue for several times during
> manipulating NIC between different net namespaces. It prints this
> log in dmesg:
> 
>   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> 
> However, it is hard to find out who called and leaked refcnt in time. It
> only left the crime scene but few evidence. Once leaked, it is not
> safe to fix it up on the running host. We can't trace dev_put/dev_hold
> directly, for the functions are inlined and used wildly amoung modules.
> And this issue is common, there are tens of patches fix net_device
> refcnt leak for various causes.
> 
> To trace the refcnt manipulating, this patch removes static inline from
> dev_put/dev_hold. We can use handy tools, such as eBPF with kprobe, to
> find out who holds but forgets to put refcnt. This will not be called
> frequently, so the overhead is limited.
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

In the past dev_hold/dev_put was in the hot path for several
operations. What is the performance implication of doing this?
