Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBC3095E9
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhA3OYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 09:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhA3OUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:20:36 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C89C06174A
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:19:55 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i9so9393743wmq.1
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SOsA8zOt1uq9Gtv7hdKwhFdfsg9+LJNXZoRvKxBQ9Cg=;
        b=KZdjuaSHIgNx3RSxNDxlFSXk/m3QojlHSjukj1QMsGAV//yFmircTUyjT7b0hGJonC
         GhdNUv/QTCZWfczBMejagTAc1RtaBktFSrzznOxnnu81k1d+UiBikjzDdUyG4vkXKJmO
         kx72w1U8d5ZKNSqAfokfgjTp8FB3QAr5ZjxG5tJ0n0wmNxwExYgR+Skl+f9kyKBR9aCK
         dkdEppNQu1hgulFT5dQheMvSDzSIAdC5wdU0xFvr72Pis/7oJdNYxVE+n7/Y2brTrVNG
         ziqakMvsxKs3Ik/7Xc+NX9umWsF7ZQEgZmKieZogoJBrCNioZFprNj+1IIgY/Q1MTDJs
         QDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SOsA8zOt1uq9Gtv7hdKwhFdfsg9+LJNXZoRvKxBQ9Cg=;
        b=d2G0VCuTTOixU5An1QcXz2Y6SiKe9ERqHUnB5bO6/WPHwbefY2UdgA6+Tr3cgalWVD
         K9DvPSPjqBhsrIXkabj+ozxtqLoA9CG3iuRu2lcfi5+mlYUrcOlOejfh5ufo6ACzyfAq
         4/SVduNyEAgupu0I7Pu+TWrLo0i6VmImmzO+LayzS4oXDXzcLcgVwEKYyCOhNK1E3iv3
         Z5i39OmDwg2Q8G3NgZLr18mb/II1N45SzGwmv/aJCQ9vbHSsIDprhTkG3FsAy5r0xEpz
         4b3qgfYDgx617ynF1KbihzIqTyQQEVhOcr7GMLfgWJYnxeKkfKsHyJx0zQh5T8svzCZs
         lD0A==
X-Gm-Message-State: AOAM530rBEJvfUctSa7/G46TNUvUqxEIp0lqnBxJKPIeHXhDQqr36i7p
        85/O58opF0gRwXDnWNEpt6bRjMP+NjrFwlYi
X-Google-Smtp-Source: ABdhPJyb6nEyge38BBIv4lvHI//P8hC5ePlxWQ1+Q0jv0vJDQ+arOAzlYhIytvqrWd0QyYAAsA7rPA==
X-Received: by 2002:a1c:b78b:: with SMTP id h133mr8060929wmf.151.1612016394425;
        Sat, 30 Jan 2021 06:19:54 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i131sm14551507wmi.25.2021.01.30.06.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 06:19:53 -0800 (PST)
Date:   Sat, 30 Jan 2021 15:19:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vadim Pasternak <vadimp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210130141952.GB4652@nanopsycho.orion>
References: <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
 <YBRGj5Shy+qpUUgS@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBRGj5Shy+qpUUgS@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 29, 2021 at 06:31:59PM CET, andrew@lunn.ch wrote:
>> Platform line card driver is aware of line card I2C topology, its
>> responsibility is to detect line card basic hardware type, create I2C
>> topology (mux), connect all the necessary I2C devices, like hotswap
>> devices, voltage and power regulators devices, iio/a2d devices and line
>> card EEPROMs, creates LED instances for LED located on a line card, exposes
>> line card related attributes, like CPLD and FPGA versions, reset causes,
>> required powered through line card hwmon interface.
>
>So this driver, and the switch driver need to talk to each other, so
>the switch driver actually knows what, if anything, is in the slot.

Not possible in case the BMC is a different host, which is common
scenario.
