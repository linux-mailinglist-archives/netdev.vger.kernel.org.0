Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9A2B888C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgKRXnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgKRXnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:43:01 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA0DC0613D4;
        Wed, 18 Nov 2020 15:43:01 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id k7so1917412plk.3;
        Wed, 18 Nov 2020 15:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=my77lXxheR/soSpdh9NtnHrImMTbEyo5ey9OXT+ydGM=;
        b=tnAh4sgFOOfGkBrOhj0wq7o24G5C2JBdHz8gB2janp1zIdppJcfsfSo5ADiD9HzKDl
         ONZNEFStlL8hh76GqoHm/4CAwwl+HJt5VzZL8tDtMxOMT3LhJYcUsitgMWkCVRJ8yjEf
         1jhUWZZHz+GDT67wqy6W60n91buKwZge4mA4GDkpOh0Djdxr56f+WihxbU/k3CJ+BiTY
         JWyLmz412BGJ4/B6LC7onGP7RBqLxTu4ZOBgzcH0NxQcdRJMFXPHFOw/C0viRZksJ/LJ
         d9chJReG3R7wSGiY4WBkAxjzwyS7X29/6eI7xxLoy0wJrmI/hBlilbvYsQZJfO0rk+tI
         hYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=my77lXxheR/soSpdh9NtnHrImMTbEyo5ey9OXT+ydGM=;
        b=ATAEX97n7p90xDa/u+dng5IDSs6dJeArVWTNJHmSelpHwAw0L1qU0yyfxLlBlIj80c
         gY8rTtq9Tex7gNz74e3LD0MpIM5HWpLUl4ki4fl0dmI1uk8gRy35rFQI1u9CNBlexrMc
         T6vdJXPTa+uxByoWwT+IYaJvKU6NTPl1Fn9VL6ELGq9pI46452tnj627jx3+7pZgKY+Y
         LvofNDGHW1hbnGPvs1GARa86dhCbxFA1By6PZjDh2HcILntQFzzz4ArnS16DTfpojx8J
         DKJCkj2W3/F/WNIZutyT2tQukJJ0Eu7qI+hCk8wkIYluUgg2ACvfvApueYf7HrqyrKyQ
         yC/Q==
X-Gm-Message-State: AOAM530bQbXMmg0rsJrAvu9xUCYSEil/aHoZq6CLBORi3yueDVTIlY9e
        SO2StEHjC1F4MyFIpNYYGsE=
X-Google-Smtp-Source: ABdhPJytJ5WdKQGVNxK7E32i8LxD6oXuriCVok63jK7EZZaQ2Zuy/LgRsVqR4sm4/WK/Gf/JM4D7nA==
X-Received: by 2002:a17:902:b410:b029:d6:614b:679c with SMTP id x16-20020a170902b410b02900d6614b679cmr6512221plr.79.1605742981128;
        Wed, 18 Nov 2020 15:43:01 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91 (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id g14sm28970005pfk.90.2020.11.18.15.42.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 15:43:00 -0800 (PST)
Date:   Wed, 18 Nov 2020 15:42:53 -0800
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: [PATCH v2 0/2] hwmon: (max127) Add Maxim MAX127 hardware
 monitoring
Message-ID: <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
 <20201118232719.GI1853236@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118232719.GI1853236@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:27:19AM +0100, Andrew Lunn wrote:
> On Wed, Nov 18, 2020 at 03:09:27PM -0800, rentao.bupt@gmail.com wrote:
> > From: Tao Ren <rentao.bupt@gmail.com>
> > 
> > The patch series adds hardware monitoring driver for the Maxim MAX127
> > chip.
> 
> Hi Tao
> 
> Why are using sending a hwmon driver to the networking mailing list?
> 
>     Andrew

Hi Andrew,

I added netdev because the mailing list is included in "get_maintainer.pl
Documentation/hwmon/index.rst" output. Is it the right command to find
reviewers? Could you please suggest? Thank you.


Cheers,

Tao
