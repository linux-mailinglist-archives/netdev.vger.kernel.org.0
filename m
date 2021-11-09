Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41C944ACBF
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbhKILij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbhKILii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:38:38 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7CC061764;
        Tue,  9 Nov 2021 03:35:52 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id b125so9856366vkb.9;
        Tue, 09 Nov 2021 03:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0Yph5k5PR6TeOU3I7k4EwQFxdX4oi2J5SYnWO8o0KU=;
        b=Pe9oQC3BhxPWfC2irk/Tcu++9nUD29Fju0j/DACUlqjeF9TN/uoAczpOwrdY8t9WOp
         DAB97v7IdKefWaPyLOHzbt+Y5DQ3hsr9T1OaDz9olA2Hz3v9XvUaFHHlheJhMOG3Y/4y
         DyAy8cBueNt1q19JOoSJgAIp1EZHY771/qm+p0BPEDdxxxdEpdyr5vfvVRa36FK9F/VM
         oI6BMDD8rL0DjqLTDlGPnGKLLSTCwuLn1a7OFVby+27FljKmAMq9e028vxoJ+KeaCt1a
         7uRtX3BH7JC8KrJVSXZjsDX2XLCqj9JfkOjLZm1otzghtSPPYKDnnCep8I4yCfiOeh1P
         a4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0Yph5k5PR6TeOU3I7k4EwQFxdX4oi2J5SYnWO8o0KU=;
        b=5zqYPd6iI7gJUsL4Dg4dOWYQqS68Rwpf/SKa+XqrxfApgfPkrsL0bsQYNHSvwiQd2H
         VFG57scHgtxT/mTktroBZ0VHy/r/Sh4SeNi5kQ5herW5fy4ESXW11XDvAN3c8B548Ef0
         vKsfPf5TvS0+bYFWVNBhFjdn+mDSKvAOjZZ/Lh5UYHSzAaFLwBM8TmGBsge/qTg0Twbk
         qN6RY5D7AV1I34Jw6vqnEiIgXBG/jQIBoov12puX08bzjek59BlVxu+VskDDzRdFRPbj
         MjCArJu1CP2UCuxoCho4sUUlrs2k+W5wQWIoSf+Pu3uxG5bo4M8l3yNcCUGia3pi3at/
         Na8A==
X-Gm-Message-State: AOAM530IzzrpKq/Rkc/AQdKnxTu7IXsskyuYAK1v7mZ2wcSGKZ3xb8qR
        VZtTC9+BwYTePKXqB5lWW5VWU1YjEvuMkzf5DSs=
X-Google-Smtp-Source: ABdhPJwNss78ZLB+AQwkHzhdek2GHqgMm+PdQbj3KqVC1K0SBPVvplyCCxFUXMetP2Ue+G2CApQvbDMyNCmseKgslUM=
X-Received: by 2002:a05:6122:1803:: with SMTP id ay3mr10286237vkb.24.1636457751664;
 Tue, 09 Nov 2021 03:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <CAHNKnsSW15BXq7WXmyG7SrrNA+Rqp_bKVneVNrpegJvDrh688Q@mail.gmail.com> <27811a97-6368-dab2-5163-cbd0169b8666@linux.intel.com>
In-Reply-To: <27811a97-6368-dab2-5163-cbd0169b8666@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 9 Nov 2021 14:35:40 +0300
Message-ID: <CAHNKnsQ8k-mKCfK2UEiC-EZn13-4VPU3ygoT3a3s4nUw5bHvhQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 9, 2021 at 8:26 AM Martinez, Ricardo wrote:
> On 11/6/2021 11:10 AM, Sergey Ryazanov wrote:
>> A one nitpick that is common for the entire series. Please consider
>> using a common prefix for all driver function names (e.g. t7xx_) to
>> make them more specific. This should improve the code readability.
>> Thus, any reader will know for sure that the called functions belong
>> to the driver, and not to a generic kernel API. E.g. use the
>> t7xx_cldma_hw_init() name for the  CLDMA initialization function
>> instead of the too generic cldma_hw_init() name, etc.
>
> Does this apply to static functions as well?

As I wrote, this is a nitpick. As you can see in
Documentation/process/coding-style.rst, there are no general rules for
functions naming. My personal rule of thumb is that if  a function
performs a very general operation (like averaging, interpolation,
etc.), then a prefix can be omitted. If a function operation is
specific for a module, then add a common module prefix to the function
name. But again, this is my personal rule.

As for the driver, it was quite difficult to read the code that calls
functions such as cldma_alloc(), cldma_init(). It was hard to figure
out whether these functions are new kernel API or they are specific to
the driver. A common way to solve such ambiguity issues is to prefix
the driver function names. But again, this was just an attempt to draw
your attention to the function naming. Feel free to name functions as
you would like, just make the code readable for developers who are not
familiar with the specific HW chip.

>> Another common drawback is that the driver should break as soon as two
>> modems are connected simultaneously. This should happen due to the use
>> of multiple _global_ variables that keeps pointers to a modem runtime
>> state. Out of curiosity, did you test the driver with two or more
>> modems connected simultaneously?
>
> We haven't tested such configurations, we are focusing on platforms with one single modem.

Now you are aware of the potential kernel crash due to the global
variables misuse. Please fix it.

-- 
Sergey
