Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEB429071A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406607AbgJPO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390724AbgJPO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:26:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F311C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:26:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t21so2611419eds.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Ac7MIkClsdpIuzFP232MqlDI0LBFUX0g87TnIYO0xk=;
        b=m1OCjNiZpCng4uiA5UUgxErw9PaTcmV2DnbKDbLzL5cDegV273JVSucDppO9WZAPIK
         AUu7XQ7BuZ1rRCwg0s391/hD6HATsqBW42EPIX0ZcDcOTTMp13WWJKtFvhrhlqrOSqAR
         gtXNTnWFQN2H70DZNpF18DBuZWrZZkp4ei/NiYtXlpNTMUb4nfYZYa+oyYPiPrHu7TJe
         a5Wuc0qncS/1x/MVY68f6N2MB1lRmzFxlu0b8tPo0v5E2z3jQbSnBUkcVaOHHsEt5aMR
         2YyvmMqnlEOtI2TTC4A+qBQSW+Y0PSQ/uUQTA2ftIls5t7B6CinTfkGLCz3o9f/Ig8hq
         T+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Ac7MIkClsdpIuzFP232MqlDI0LBFUX0g87TnIYO0xk=;
        b=mvM5UA1YO6x5g9chHvWWOjOeTHJcuKltc5TtB06Nrwc05DD8MNzV+WEeqD3Bz7mCfL
         CpUiazNMz7jVS3sruPpSgkv7TQujj12oxtaV0eEHiTfcjn5Iz09Z7vOjMXDnVkxeqqIl
         bKc3VEFMSfhS4WhXXbGZXTdK1sX/bfZJFfSrxg98tGMyS2G7pPnH2cSJwr/hsFtRX1Yo
         b/6P+n23I+jdWmgHxKWD7wQNszSr61s1pUd4WUc9LsqF/s6DYkb2HByiTXBOkienOOfw
         eK51uPwIuWT0GBmYxT1xU7aSgQ2lZJnU/cW9AMkVwOCWHjnpii9ySGJ3SnUFTqiEjjq7
         zPpA==
X-Gm-Message-State: AOAM531AemIrti/6iQnOybQHxumbs+3a/QiZDIMGia/NQvZIQMu4F0qL
        d9zZ3NjBkUON9rPwmrj9nC0=
X-Google-Smtp-Source: ABdhPJxUq+S3H8Nw9VXe4WaTIzQEbIB9/cF/Ahq0hibYLXCT9svLJbY4ss2oIMtMZTrrQ9Q6ipfoEA==
X-Received: by 2002:a50:e08a:: with SMTP id f10mr4358052edl.220.1602858372830;
        Fri, 16 Oct 2020 07:26:12 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id y12sm1592767ede.82.2020.10.16.07.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 07:26:12 -0700 (PDT)
Date:   Fri, 16 Oct 2020 17:26:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Mike Galbraith <efault@gmx.de>, netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
Message-ID: <20201016142611.zpp63qppmazxl4k7@skbuf>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
 <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 01:34:55PM +0200, Heiner Kallweit wrote:
> I'm aware of the topic, but missing the benefits of the irqoff version
> unconditionally doesn't seem to be the best option.

What are the benefits of the irqoff version? As far as I see it, the
only use case for that function is when the caller has _explicitly_
disabled interrupts.

The plain napi_schedule call will check if irqs are disabled. If they
are, it won't do anything further in that area. There is no performance
impact except for a check.

> Needed is a function that dynamically picks the right version.

So you want to replace a check with another check, am I right? How will
that improve anything performance-wise?
