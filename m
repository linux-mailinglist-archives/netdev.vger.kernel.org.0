Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19B1C00F4
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD3P6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgD3P6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:58:00 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E899FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 08:57:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so7035307ljn.7
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=86k3QMcaxzgeZ7W7KT/L8p/HNMu4qgvr2mrXHZQt+48=;
        b=XZF6052yV10SROVJ2G+TRb4EyzpFdU64n81Pg9f+pT0Wp4Z8alnBfG/0D4NN3CLjA/
         LBOPtyQEiZ21nnyedyROjR5GfSO0BvetrmBhu0P0e/7RWQ5kAzW7QScxxfUuqB5LLQqX
         uEiUmnx8nBcHCG0xVhv3GXy/fjZU82F5aT+l8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=86k3QMcaxzgeZ7W7KT/L8p/HNMu4qgvr2mrXHZQt+48=;
        b=tsFgjemRnhWBx5d+px0e67G1IpUCCjNU/y5bgHtjH/OCD9f5njSXP9ohd7+iYd5itc
         nhRKOw9fC/+icyVRVAWH/gtPuvR0hs5Tw1os0oqc80QQWgZPB7Wq/Y+LkvTP8soLeN4a
         j8wF2qwCrUjBqWbCigCuhDI502FWdOnTAwCAF3cpc5uUkJjCAnbKyGkzd98aTFbHTbKz
         Wp2aZPBTM5oxoI9uBxPestoMQR6C0scwczWnrjtqn/sRqpJ8Amy0tuRCCZkKgM+IOmVP
         QNZZdEHGRjenPZhXtAJidXHTw10I9iQ3paJGTqbRuJwaKoHDyU9/a437ZOFs2np/vnTx
         Zx1A==
X-Gm-Message-State: AGi0PuaCVH36avc/UFPx7IYHRGhVj8oOb+kzZLC7O5hpvpWwqblAiq7r
        BhtJwQjf88w1v7A1ZvtyzGio9tjm2F+IjDrP
X-Google-Smtp-Source: APiQypL2LxWT5udKnpA2K2Ln/pz57VtS4yhjGktm05+hMX6cncd0lmyqsPS8GftxUbNGoqFIYJDmEw==
X-Received: by 2002:a2e:85c4:: with SMTP id h4mr1562ljj.112.1588262278038;
        Thu, 30 Apr 2020 08:57:58 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b23sm64906lff.5.2020.04.30.08.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 08:57:57 -0700 (PDT)
Subject: Re: BUG: soft lockup while deleting tap interface from vlan aware
 bridge
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>, netdev@vger.kernel.org
References: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
 <20200430105551.GA4068275@splinter>
 <4b3a6079-d8d4-24c5-8fc9-15bcb96bca80@cumulusnetworks.com>
 <20200430155645.GA4076599@splinter>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <ed87d845-035c-37da-5439-1bcfb22fa4c5@cumulusnetworks.com>
Date:   Thu, 30 Apr 2020 18:57:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430155645.GA4076599@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 18:56, Ido Schimmel wrote:
> On Thu, Apr 30, 2020 at 02:20:23PM +0300, Nikolay Aleksandrov wrote:
>> Maybe we can batch the deletes at say 32 at a time?
> 
> Hi Nik,
> 
> Thanks for looking into this!
> 
> I don't really feel comfortable hard coding an arbitrary number of
> entries before calling cond_resched(). I didn't see a noticeable
> difference in execution time with the previous patch versus an unpatched
> kernel. Also, in the examples I saw in the networking code
> cond_resched() is always called after each loop iteration.
> 
> Let me know how you prefer it and I will send a patch.
> 

that's ok, send it as it is

