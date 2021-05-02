Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E93A370B44
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhEBLVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhEBLVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 07:21:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC0BC06174A;
        Sun,  2 May 2021 04:20:50 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id zg3so3688375ejb.8;
        Sun, 02 May 2021 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=mMkrnxACa0wJYD9aiaCHWNP7/k9P5/uVkcRWd0c/2dA=;
        b=GfdQ+OGCzP6QpCfhFREOdT5ZPc/OLUVxjpg2mInyhAsxiqeg3vari7E2HIRN9HUF7j
         nY3cBDtIXbFh9U46yPjBqJlQ9KuN1EjZpnTAq/peQR3tEjS5XQixOZCJDrE2foG6UdcY
         s7GSORfZy+2br8Qcergy2FgHIGBHmPIIk2RGicreXZgvq3wxqOVpVb8ExndhYDfIXmAY
         QWk1UgRjggkKYBM9cFFegKWjY6CmBfLM/F92PHbcUdokkQ46NRx4Sa0AW+wUQnEaTR7d
         UpPC2oeOFSj9EMvoPyIeTWHA+tDyyJ8GBuG3UJF1Rzcm28B9b5e2oI1BQAJX7XgUWzyi
         O+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=mMkrnxACa0wJYD9aiaCHWNP7/k9P5/uVkcRWd0c/2dA=;
        b=Q5LX25QVvidQNXNnpLGT0k/rXxTaD1r3d3INwTt1pw1LYeqICJRhYLhJS/NaDG/xFL
         DBhMTSvGKtyiSHjgT8IsHqJPM/mUL6OfW3o7/KsyXiYD6+pBvI3kvtNQISD4lpRGyA89
         2uxUPswzabT4EACBJ9maDE1l0nd4nmKW6/ATqMKnNVHEsCdUNxB1Yo9ONHjhl+hKF9De
         70XQ34hrH3KjPNGosb/+LBKDz7Frdj/HNHPhH15Us/3UD/3rL5q71VItPCivZV4QlkjI
         NtKZUQvF7KYNZda9IfZPfk5oJ47OVlk785TdS4v2DlP/+FbkMXzg6eFbr2x6wHInI7n2
         9jnw==
X-Gm-Message-State: AOAM53333aUEV5UVys4urpyNdC9H+zg+seF38vJdkwiN9wlQfIevrQ32
        H3PpBykxEp+co5hMiebMIEGX68erIQyUWA==
X-Google-Smtp-Source: ABdhPJyDn/18q0c7hDTfkBrKDLlGjDzODR2QxNsEw1q+S2kno3+i6tRRD66QKEHjj3dLEDcFfang5A==
X-Received: by 2002:a17:906:2a1b:: with SMTP id j27mr12243267eje.370.1619954449123;
        Sun, 02 May 2021 04:20:49 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id dk13sm9969276edb.34.2021.05.02.04.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 04:20:48 -0700 (PDT)
Date:   Sun, 2 May 2021 13:20:46 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YI6LDhpn/Esl+Rf8@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
 <0daa2b24-e326-05d2-c219-8a7ade7376e0@gmail.com>
 <CAEyMn7ZtziLf__KOGWJfY5OUDoaHSN8jopbKJeK9ZSD1NsZDjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7ZtziLf__KOGWJfY5OUDoaHSN8jopbKJeK9ZSD1NsZDjw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi David,

> Am Sa., 1. Mai 2021 um 17:03 Uhr schrieb David Ahern <dsahern@gmail.com>:

> > On 4/30/21 12:26 AM, Heiko Thiery wrote:
> > > With commit d5e6ee0dac64b64e the usage of functions name_to_handle_at() and

> > that is a change to ss:

> > d5e6ee0dac64 ss: introduce cgroup2 cache and helper functions


> > > open_by_handle_at() are introduced. But these function are not available
> > > e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> > > availability in the configure script and in case of absence do a direct
> > > syscall.


> > When you find the proper commit add a Fixes line before the Signed-off-by:

> What do you mean with finding the right commit? This (d5e6ee0dac64) is
> the commit that introduced the usage of the missing functions. Or have
> I overlooked something?

Just put into commit message before your Signed-off-by tag this:

Fixes: d5e6ee0d ("ss: introduce cgroup2 cache and helper functions")

> > Fixes: <id> ("subject line")
> > > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > > ---


Kind regards,
Petr
