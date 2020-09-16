Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8354E26CA25
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgIPTsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgIPRhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:37:55 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD4DC0F26C6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 08:08:59 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id o8so7030243otl.4
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 08:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9P+/zfUrv1hKMRajubOQ6tXjJBwp/PwNgCXvVyCvEWg=;
        b=Py05bBfbK7yaNOrdFGs5M6Wq/4GDoNY+D50IU+D0TmzSiadeMW56/A6GPULblWarqA
         TxPJpG6voUPTmgkWDBUcuCmjLbQ8/DfrxahtI0qjmYEdGJjlIeGx4VaRaXXQ6ObVLTy/
         qkRITHc0YqX6R++xHcSw0Z5BS+1Zxj2xI+NrBeoxWaHKvkg/rphnkU+BW8Ecv9sQJjlw
         IUH7ka8QCXF/JHmUOHTaMtlBan5eozgMyV14FerILlbVRyicbxginF0NVCsXn6b/ifkG
         oqGO+/d8hGmB9jBfQfVo/q4gdHE5UGMNlsw7Ry5kjWjyoUxo5WRmk7CdeTHdOyExAgOd
         MGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9P+/zfUrv1hKMRajubOQ6tXjJBwp/PwNgCXvVyCvEWg=;
        b=JO6oPhm7xn+GOY29K1bSQUKJXDSaZfYAaei6vWS1aVRF2ObqOx2i6bqSmM4PKiYvG2
         wkMLQVFRVC10Vdo5nfJMu+qBlN+8eNrV/2IFyJZR1dKp7+ns02rJ2PjLi8jaBscd+d/2
         aVV+0sFyZ66l4LiK6ZtpRmVKZGlEe1uQoif55uRtRHxJ1XaGT1O4lNQAyK9+jKPdozQ3
         8JhYcoqjRi7MuaWtBWN18eGftrSAx8VluVh5JkGzOc/Aljm6b9V/S7aI1M7S6rWGqlY+
         w7UISMReCFlMvtiVrRH0OibIfwRGIGpfY+zGTB8vL3PLpNCJt31IzNyIYCE6rYE3bK7u
         9giw==
X-Gm-Message-State: AOAM530xKOvCucN4ZGjulXD8au93GG8HkKQNDo8sPBDx+gP59PDdUpI/
        mwvT59HrV79n2zl7x91P8WHvS9FJFslOfPttc00T0w==
X-Google-Smtp-Source: ABdhPJx9bvbl5VYhXeKtcVCHu04M6AM9dW5c1JQKO5qANEeUST7yFUJ6watGMCW7X2ROJCgsB1Y3CWhDw50xz1RBOGw=
X-Received: by 2002:a9d:6445:: with SMTP id m5mr5951453otl.36.1600268938976;
 Wed, 16 Sep 2020 08:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com> <20200910131227.GC3316362@lunn.ch>
In-Reply-To: <20200910131227.GC3316362@lunn.ch>
From:   Vikas Singh <vikas.singh@puresoftware.com>
Date:   Wed, 16 Sep 2020 20:38:32 +0530
Message-ID: <CADvVLtWVOZOCGuWxLhHHfjB7LYtWp4yZ6=5x0Mt7o7ascYxdAQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: Phy: Add PHY lookup support on MDIO bus in case
 of ACPI probe
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>,
        Arokia Samy <arokia.samy@puresoftware.com>,
        Varun Sethi <V.Sethi@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 6:42 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Sep 10, 2020 at 05:13:03PM +0530, Vikas Singh wrote:
> > The function referred to (of_mdiobus_link_mdiodev()) is only built when
> > CONFIG_OF_MDIO is enabled, which is again, a DT specific thing, and would
> > not work in case of ACPI.
>
> Vikas
>
> How are you describing the MDIO bus in ACPI? Do you have a proposed
> standard document for submission to UEFI?
>
>          Andrew

Hi Andrew,

We are evaluating this internally with NXP stakeholders.
Once finalised, I will share the plan & documentation accordingly.

Thnx !!
Vikas Singh
