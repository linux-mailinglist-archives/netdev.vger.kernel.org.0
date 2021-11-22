Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6402458A9F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhKVIsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhKVIr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:47:58 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A225DC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 00:44:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b68so15416850pfg.11
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 00:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuLHuGPOZQR3z4rA1JJ/NnOpp1dXs4usqE/oXhXgOR4=;
        b=cIo4JpUBEmJESVuuvhqA5MimvmliwrMc/bdAPME9lefEaNMVp5nLS4qAal8/8TstQl
         Sid1xhhfZIQZk32OF9Fi6V48rzXC5zwEJ900xXlWnJCrPXpcNgZEaf3G1IfAypM9LsHy
         sN7WK9HHYxruw9zZlcr9Q3xij1Ev0quMENZAlH3nxSZw+zUfx7FS9tB1mpI/69hobdoZ
         uVSr5ddXSA8x3RrtZ+JX2TX3Wzek3JhEw0QMjJq9iWiUp/MGsd1ZzNXsTVnp5mrdFxoH
         Rk9HyZIEF3oYN12pHC4Bg1L+saDdBIYjNedlZINtZt95szaSAohd0/jy6iPK9eNPMKn1
         L5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuLHuGPOZQR3z4rA1JJ/NnOpp1dXs4usqE/oXhXgOR4=;
        b=LsE++2q2U6uCeW/ZlDDq4FnzUBzT4HPPldB5mrdHh9R3hjyRWWTS7UBXiHiO1kDRxu
         3VX8hg4NVF/1+IYnUYnTHRARgsDPU/aZEAeTHZAhY/vCLVxnOA69ouHpLx1gISl5zjf0
         9OlZBLo2K0q0XqJwjICe0oxSMSbGiJpRddlwa7I2WY2pq0t3cWVlpSLb0dyMzOOmcZc0
         gPOEW1rcH+u6HHJNOssHyvbxSpe87c8jrhGCMcuU9xwEwrn3LsuaCMXQKs76p6IW6ScO
         IA/FE0xMLCVJQliAh9bBp10MRmavpsBLSQxsSkoTt9WU2I+jcItAZgJQ20sGNdE3+Nlj
         YsyA==
X-Gm-Message-State: AOAM530USMaHWQNpoGlAtdawhHHwHFWuJJVv3b7BIL0UKZoS8/Quqi0y
        m75WXVUBlQiQs0IZcRJCpOMUZW3Ax0yh/1hHXO7zKA==
X-Google-Smtp-Source: ABdhPJzN0NNJEEgg69Z4TS7SKWlPZk6hzOPtJzW+nM5ANM76iaxlSQ3/bcH0iC8jzyLrD3PsR0/xVkON7Jm4X/boPTI=
X-Received: by 2002:aa7:8204:0:b0:494:68ea:ea89 with SMTP id
 k4-20020aa78204000000b0049468eaea89mr84102110pfi.74.1637570691982; Mon, 22
 Nov 2021 00:44:51 -0800 (PST)
MIME-Version: 1.0
References: <20211120162155.1216081-1-m.chetan.kumar@linux.intel.com> <20211120162155.1216081-2-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211120162155.1216081-2-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 22 Nov 2021 09:55:27 +0100
Message-ID: <CAMZdPi8cfTFypqHYgi-UMCVavCMQqG1e4tBGUihJzR2Kd09S5w@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/2] net: wwan: common debugfs base dir for
 wwan device
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 at 17:14, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> This patch set brings in a common debugfs base directory
> i.e. /sys/kernel/debugfs/wwan/ in WWAN Subsystem for a
> WWAN device instance. So that it avoids driver polluting
> debugfs root with unrelated directories & possible name
> collusion.
>
> Having a common debugfs base directory for WWAN drivers
> eases user to match control devices with debugfs entries.
>
> WWAN Subsystem creates dentry (/sys/kernel/debugfs/wwan)
> on module load & removes dentry on module unload.
>
> When driver registers a new wwan device, dentry (wwanX)
> is created for WWAN device instance & on driver unregister
> dentry is removed.
>
> New API is introduced to return the wwan device instance
> dentry so that driver can create debugfs entries under it.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
