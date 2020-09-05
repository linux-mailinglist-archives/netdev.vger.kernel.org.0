Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF5E25E8EE
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgIEPyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIEPy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 11:54:27 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA58FC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 08:54:26 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a2so8629214otr.11
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 08:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jANvBpZW4WzDxeFXVCrjQ62HpePYgiQipiGMQNEmhoo=;
        b=FON2kA3UsDxETUyXsJm88gahNWYyrEWcY9qzdFAlH7fyjINDnvldd6xe9C+bxCXhYA
         iAIXyXMeox/GHr7NbnHcfV0lNuRfJDNW4aRtCFy4XbAOzN6R4A66ORUrCaV3qZRIWTnV
         nMJ+vXOnVnnmSE2HGBH+PuIMCboJUCLVI8MqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jANvBpZW4WzDxeFXVCrjQ62HpePYgiQipiGMQNEmhoo=;
        b=idoxpHK/0aekB2SlsRlfrh2MIiRplyWSQKu4A+9EM1g0bJnMLI2SwPAEYpdrJ90oVt
         UysHmqG9R21VV1ev6MvXKDkcnxKpp/vX13pxsAzSxkva4TVzaqD728GD2P7hd1Rs6E+T
         KAiIJsSpQUFwXfH7hLgJUmoo4whnpx7K+hmbJK3K6Gv3erPjC8iGx2z0PWL8OPxeWkaN
         IOYD5vzj8ZNQ1vjSru3tZ30tu2ZA9ZsE7Pt2Sy/YgZyq0JyLcpu67AeF5qMqVSbGpA9/
         zhZLAOnnZLTXFm3hwVvVar6vAQE3cG1ksMzICbOplZO1ivQoeB8EEAaM1SMl5gs/g83N
         h/3g==
X-Gm-Message-State: AOAM532l+JRIjK5FAG14GufW/28B384jfNkxt5HAWaaloMACRIm8mULp
        pRm0Fx857VEIe+w1ro/aMdMJIoEWQQVWvahXOYxXjQ==
X-Google-Smtp-Source: ABdhPJye2xTFXVwmrNkZvMwnnP0Lz+qZzCcghgMCuP6I55wfQDl3gSkEj0BUU/UaSZ7Gia5s5mfK3K1Mfz96mOZjW7A=
X-Received: by 2002:a05:6830:1d8a:: with SMTP id y10mr9512388oti.92.1599321266289;
 Sat, 05 Sep 2020 08:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200905140325.108846-1-pbarker@konsulko.com> <20200905153424.GF3164319@lunn.ch>
In-Reply-To: <20200905153424.GF3164319@lunn.ch>
From:   Paul Barker <pbarker@konsulko.com>
Date:   Sat, 5 Sep 2020 16:54:15 +0100
Message-ID: <CAM9ZRVto=5HKtuuyoz1CDctCw85Qh1+=yU26brDxHcgEbxzWrA@mail.gmail.com>
Subject: Re: [PATCH 0/4] ksz9477 dsa switch driver improvements
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 at 16:34, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Sep 05, 2020 at 03:03:21PM +0100, Paul Barker wrote:
> > These changes were made while debugging the ksz9477 driver for use on a
> > custom board which uses the ksz9893 switch supported by this driver. The
> > patches have been runtime tested on top of Linux 5.8.4, I couldn't
> > runtime test them on top of 5.9-rc3 due to unrelated issues. They have
> > been build tested on top of 5.9-rc3.
>
> Hi Paul
>
> Please rebase onto net-next. Take a look at:
>
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Will do. I'll send a rebased v2 which also addresses your other comments.

Thanks,

-- 
Paul Barker
Konsulko Group
