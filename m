Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4F11F540
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfLOBVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:21:30 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46430 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfLOBVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:21:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so1534721pgb.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 17:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fMT9Uq8oA7N4cc8A+BqwQHzoKGnygJU6FYugzr2VIag=;
        b=KEL8/tHDQaGUH7uxzfNpx/uUU3s4ZR+ORlxEazfZo+lqq7HGWpSu6E5v+P8E32beS6
         xTNxrZ3TwmW7im+hVvhuMlQZ1gUQje34Ghn2x0yVS0L2F313/BMR0a3mfoHs5JP4UFuP
         2t8A1eMKgIOUWfJ7Xsdnr0VPEJl5DUhbAb0ZFShFdmi2eAxwRn3OT4JJICWeQoY/3TMZ
         K9AygQL+4lXRPW4eknD1MBFuRI20WfA6fwRymWvlxNX1mqpmwTM3XuRl7/T0bnhQxQE1
         JNUiivSvpkGfDoo+ZoL5jDGEvRZydugbcL/UB+mKkXmEFBG+gClx/nA65M793Y7tGppO
         3p5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fMT9Uq8oA7N4cc8A+BqwQHzoKGnygJU6FYugzr2VIag=;
        b=oOybia+Tc1eFmibQkwWiqdXdDBNAwNVN27wEDqFceAebprgyTQb1l3JpciqHLfAMOO
         R+zADCxcjqIL0pJ70RfvDVZQp4LkJe+kZ36i0CyimQYknVIC36b51ynr2Wic6cfVe0iG
         ezM59UszRw2/7lvHzWUA8dzb1siZEQA8nIB+qR2N7XdYT5DvDP/Dp65xPlyRN/cHzH0N
         +O5SRftNRralTXAE2LF9J7YhRNZJVFUOm/ZQ2+fMqU2Kkjx3v+8iKcEqAIyfocBsXxBP
         B0OEc50JHdfbSIhUoIqdEDH4GmcM0Uoq028xdDOWqcQBlpRE0I/aSPmmw/mG2e1Mzwqz
         LfXg==
X-Gm-Message-State: APjAAAVsnk1FvN4WZEfsXK+BP1RzDXhidqWKcq8CrJ7bElLVkBw3Ofe9
        f2OL7wWZr7CZe4YXz91VlKxOaQOFKRY=
X-Google-Smtp-Source: APXvYqyNRkNh1NsJ8oLFOFP+NHLe8b5KbJ+8zLzYGQ2/YH/lDvmaRFXrRk5+K6ycUraXoFFAjahcMQ==
X-Received: by 2002:a63:597:: with SMTP id 145mr8792268pgf.384.1576372889380;
        Sat, 14 Dec 2019 17:21:29 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d13sm13282631pjx.21.2019.12.14.17.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 17:21:29 -0800 (PST)
Date:   Sat, 14 Dec 2019 17:21:26 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] gtp: fix several bugs in gtp module
Message-ID: <20191214172126.3f5027a4@cakuba.netronome.com>
In-Reply-To: <20191211082243.28465-1-ap420073@gmail.com>
References: <20191211082243.28465-1-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 08:22:43 +0000, Taehee Yoo wrote:
> This patchset fixes several bugs in the GTP module.
> 
> 1. Do not allow adding duplicate TID and ms_addr pdp context.
> In the current code, duplicate TID and ms_addr pdp context could be added.
> So, RX and TX path could find correct pdp context.
> 
> 2. Fix wrong condition in ->dumpit() callback.
> ->dumpit() callback is re-called if dump packet size is too big.  
> So, before return, it saves last position and then restart from
> last dump position.
> TID value is used to find last dump position.
> GTP module allows adding zero TID value. But ->dumpit() callback ignores
> zero TID value.
> So, dump would not work correctly if dump packet size too big.
> 
> 3. Fix use-after-free in ipv4_pdp_find().
> RX and TX patch always uses gtp->tid_hash and gtp->addr_hash.
> but while packet processing, these hash pointer would be freed.
> So, use-after-free would occur.
> 
> 4. Fix panic because of zero size hashtable
> GTP hashtable size could be set by user-space.
> If hashsize is set to 0, hashtable will not work and panic will occur.

Looks good to me, thank you, applied and queued for stable.
