Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5323CCB49
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 00:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhGRWWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 18:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhGRWWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 18:22:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEB8C061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 15:19:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k4so19385400wrc.8
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 15:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PkoE9eNzb5bPoKWkFB+X6mdPpHM2rny4CytW+uJETgs=;
        b=jrCXS5vo2DHbxCrvbqpMjr5NgwuV0ru78pGl5AQVhk3ynRIiBGHv1ntf8KZnCT5qXV
         Bm+HQzJAw6TmhTsMCZiaYlRbrmY4eXYaUkAvA3rCmZs+UUhB8s8ZPktmZblc9fSP8ZKj
         mnsm+Q48DTr8apnQXY4TXebh/FdvYmuDDVJe17QAnZDTORDeICUNKs8DRMTY3WGxUOWg
         3V4VQw+T2bKBZYdw2sGeKQjBjQzQrPN5QFz5fUhHzRYP1v0oi62LNTMwjvacxdCm04wy
         ILFSuBFVRmcEoeeVhMHpjVnEWSW+qGrKV0wpyJKPW5X8TsHN8WbmTTQimX4eL1j3WL3k
         CWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PkoE9eNzb5bPoKWkFB+X6mdPpHM2rny4CytW+uJETgs=;
        b=t1HKy6hdAGh0YSggjv4N36/uAQZsNWkZ0+AwC29VRqnueZ9CpBVStU6XlSwBzONulo
         jnsTO0xaQ5bjtPtfaDtH+xy33qyEM8IBG64oCQewB4SgH+KFhxkkR3LWp5i6HQT/PjAe
         XdkNSohwlkBZc3U3bYxuyE9aw2cAuhxqatA7CHwj3qlleJn9cx8F3dKXqVLChT4ZnVlR
         l09NdzhYM2indFso64sAbuNP+RyCWbw5Ti0VIjblRKWPweWaPFTdQL5lUEpx054mRqiT
         YOdZK3CgmhhnZiGrEmUf9uoLA4FtVG7PtGyNXf4YBSUaRs+2em4jrwk/+5n6+0hKXihW
         SJNQ==
X-Gm-Message-State: AOAM533Iwqq4BCbhPI39EoEZSOBSYtkzkjbJ8ENr2muJsCFJcgiX9mEx
        sKajxeIs5HhugzkS6+pyGUQ=
X-Google-Smtp-Source: ABdhPJx+GF4VQbrbmlOc3qOg5sdRbhzXcZnWz6EZR4gsGnyATKQKf4/Xpkn3oilF/dElkriLoK5dRw==
X-Received: by 2002:adf:a54b:: with SMTP id j11mr26487068wrb.305.1626646768459;
        Sun, 18 Jul 2021 15:19:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:8dda:3d64:bacc:f1f5? (p200300ea8f3f3d008dda3d64baccf1f5.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:8dda:3d64:bacc:f1f5])
        by smtp.googlemail.com with ESMTPSA id l23sm5172502wme.22.2021.07.18.15.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 15:19:27 -0700 (PDT)
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
Date:   Mon, 19 Jul 2021 00:19:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716212427.821834-6-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.07.2021 23:24, Tony Nguyen wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
> 
> Each i225 has three LEDs. Export them via the LED class framework.
> 
> Each LED is controllable via sysfs. Example:
> 
> $ cd /sys/class/leds/igc_led0

What if you have multiple igc adapters in a system?
AFAIK the LED subsystem assigns a unique name, but it's
out of your control and most likely not what you want.
Better would be to use the interface name. However then
a challenge is how to deal with interface renaming.

> $ cat brightness      # Current Mode
> $ cat max_brightness  # 15
> $ echo 0 > brightness # Mode 0
> $ echo 1 > brightness # Mode 1
> 

In general I'm not sure using the LED API provides a benefit here.
The brightness attribute is simply misused. Maybe better add
a sysfs attribute like led_mode under the netdev sysfs entry?
Then you also don't have the issue with interface renaming.
