Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9363E6E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 01:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfGIXrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 19:47:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43399 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfGIXrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 19:47:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id cl9so187080plb.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 16:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iL18xnFSpk6ptM8YAmoMi2iKWd1SLqXYtP/FCRGWav8=;
        b=Q/RoaNRgQ0bfuVZO6pPdiS54Ias6oBekAYBmwoJjMckKbKNA6454iquKh8eut0Ttr+
         bHXuqKeFInzzcfc3baQo0VS5LiyQfBykfnHu8j05DjOLkGoLQ0PFp9S8Zu6+LMNhtNxY
         GZSl7HRj4cHGDeoiEl7QIrm+fVJC1HYHl4HuuRaXuCTMzlQxTX+8zf1lwuxFrCM/l19m
         nL7uk75lGOj8zZoAXABKhqXGjBiHeKf6bpLuTyI5suP29zxb+3H3F24S6lXx8oKwU78I
         XRLQ3CMG/X4/9nh9MVVHBpUtU9iODOb/3ofC9t616yOCYyV8YJIlYnhi5ITzag2XtxMW
         JJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iL18xnFSpk6ptM8YAmoMi2iKWd1SLqXYtP/FCRGWav8=;
        b=Zz8Uw+9KCcK9NdE3cadpaFKFz/IMKY3Ac9H3p8fxbMlJbnKxEYke4rB4kMZo9iNMWR
         FPwdf6R8JkfvJEzk1J1C+RcAnKlHYBaZ7euR+KUS8niJvf3LM8+FT4fwe9IWPXeQFaWi
         gB3rmyyWf1Ek3LprF9wfy5sMRH3Bs2R/9mULCrg+584yZeAcKi9DFKr5MGKLgv8+iSTL
         cTyuOFwJ88+3Z3RsLrGaKVLiqJA1RTw9sR+OKUidCMpB8z757emxc+fUURwEIkq9s4nf
         Yf4zw86+Ty+9l/Qb18WyWUP3peZ4IfK2kd6DOvhn9UFCxTjnczAGwt/ymSJgQVls5X7s
         hb9Q==
X-Gm-Message-State: APjAAAVgXh3GNIMkzhgwWQppyYzpm/in/XXByuLYK9zHX+GXrspReUcu
        nHZi83i9Sos4Hrf5pYofUdD/HA==
X-Google-Smtp-Source: APXvYqyORHvLs9KYDreBAMDfudmnHv3DL836iujhdLjZRsI5WKxIcNSD4anrJCkjYa22pZMESWRMbQ==
X-Received: by 2002:a17:902:7088:: with SMTP id z8mr29145504plk.125.1562716037090;
        Tue, 09 Jul 2019 16:47:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r196sm151543pgr.84.2019.07.09.16.47.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 16:47:16 -0700 (PDT)
Date:   Tue, 9 Jul 2019 16:47:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] Name NICs based on vmbus offer and enable
 async probe by default
Message-ID: <20190709164714.70774c92@hermes.lan>
In-Reply-To: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
References: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 22:56:30 +0000
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> -				VRSS_CHANNEL_MAX);
> +	if (probe_type == PROBE_PREFER_ASYNCHRONOUS) {
> +		snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);

What about PCI passthrough or VF devices that are also being probed and
consuming the ethN names.  Won't there be a collision?
