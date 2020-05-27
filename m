Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E506A1E4A53
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391263AbgE0Qe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390679AbgE0Qe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:34:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7DC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:34:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u188so33797wmu.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2AI8G9t4ys49r6Lnqk3YDFigCBz7eu9qaHA7ztfxGLM=;
        b=mn55s8z9JLqe+F/Go5UuNeEcO2NEilEWBdgTfy+r42x0OUwgFGmTXonaHzTEVrUJ78
         1am+B2fS3pYeOw8vjuOVMHclIIMmzDymVUmZvvQTaudFEtN7m+fRJMP/whFYnfOa8MDt
         wYtke7uJG0scKMuu0A3gtJAz48C48r++nE4vIPWgYKcc0y1tk4N9GPpoSo6VKPRKYJ4M
         trfHDrCCa2MBn1MS46MJySg723OUAWuKh6Q2Fd+RDXcPOv8LPQ6wq2faWqMEBAy75NVA
         QUReQC9Qn52oEbc6+4Q3HeO/4ulI+txSvKbA3H6BJ9apJoQlWiva+4IKiCix/LtEYwV3
         EQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2AI8G9t4ys49r6Lnqk3YDFigCBz7eu9qaHA7ztfxGLM=;
        b=k0tAt0b1RTOTyak5e981zzkDk2Ew6BU0ZLum4ky1Lu/fm9Tq5O6pV1P8jNycFjzfWi
         YL6fyWLla2sFPPy6oX5jug2+bDrww2JFx1kgS6XYKTjQUNkDf7+/eMDm03PTQ32LWaPE
         f1Z8zKxocuj0HpKVw+ljv9/IfnRD7rgmoJ/+HBsmyUxvxzOC6mRRtJTrZYw1nwOBmGgd
         XHb0xe6qeeOd2I2KR3RGuAhunHW7YX5TA92cmRKU6KZP80GM8OZ5s0K7AV8bpt6Nk4y7
         O9xyyxsoSfumltPenHJn3LG2KtdiEntyLT7oZMoT9I5RDXVvXlvMFGHpNMttdZ+KesJX
         igEg==
X-Gm-Message-State: AOAM5322KmQZ5IcIMW06bXdQQEJKhDfW1MATx9eJ9JEs18urUzbbBLzX
        akwsThpO/EbrpRoTH9BYiEf/T26w
X-Google-Smtp-Source: ABdhPJwRuVZV4HZQrZkrykaRYwwjAlvpCjrDZIfbzK38bJqQR0reeF2jIORV+lmGQW73Ms0tsWFK2g==
X-Received: by 2002:a1c:65c2:: with SMTP id z185mr4817857wmb.125.1590597263173;
        Wed, 27 May 2020 09:34:23 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l19sm3246314wmj.14.2020.05.27.09.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:34:22 -0700 (PDT)
Subject: Re: [PATCH RFC v2 6/9] net: phy: add support for probing MMDs >= 8
 for devices-in-package
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <30a40ebc-7214-b5e7-4468-e289b79f9b6e@gmail.com>
Date:   Wed, 27 May 2020 09:34:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> Add support for probing MMDs above 7 for a valid devices-in-package
> specifier, but only probe the vendor MMDs for this if they also report
> that there the device is present in status register 2.  This avoids
> issues where the MMD is implemented, but does not provide IEEE 802.3
> compliant registers (such as the MV88X3310 PHY.)
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
