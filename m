Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5FB45373A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhKPQXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhKPQXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:23:37 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5A8C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:20:40 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id q14so19432918qtx.10
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXmP0iEL7NoEd9T/QMFkDnPKk7SG43uZ/gjP8ig4g0I=;
        b=fYYCn5WqajmgSpCS+i0bFFrEDuaLC/vYuvzDB9cWr2onNeQ4H40cDI2419e14yCNaG
         UUX43NJ3l/51FEp5vYOZxQ1GUdY4fsx2pXkpxFm/vJOAI7w7pOijTJlDhyh788djfUhx
         99MIpBSyyUiQUSoyd5o9o5GWC8G9WDt2GH/SI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXmP0iEL7NoEd9T/QMFkDnPKk7SG43uZ/gjP8ig4g0I=;
        b=3+P0KhTIJ2j8WDiBLv035FzMKPzCpthOiSHCgHcC55zKdSeusMG3W6GK2rFHEQeCBB
         36Uz6yFv194ePUctur0/wkvJljjH7BzrW08SHSrrNty4IFj2hkWRXKcoQSv+bFH2XBJF
         Q581eLYZADrTMiP2zUHVIirn9e5zVubg2V3HUWL8amiO6km8kcKCO4lTLZpyOqo3ZVaZ
         0kDc0lWNm4qkwCOlvrWZ28yWmuch4VD3k/ixublMTZl+SCLglv3hZ3HoG5sZekdT3XGN
         dSTgxwHZtc+wEOplf65E83+m5HZabYHcKUYL+JKVnP8euH4rC8E3mNOFqyB/4IQIpDnU
         tqQQ==
X-Gm-Message-State: AOAM532y5boTmpxGVs60CwjIPPMFQQJtdLF+JJITwppFtgdq7aYfA7zm
        HQ9zkuwDjwxh6GhAjHabvNUQ9l0tQ2mjaI+37DRJWg==
X-Google-Smtp-Source: ABdhPJwueNRwd+7G2C49ZaZME9umYA5Wo/JEEnMIP9kE0dbhmQK6GrZ8S0pNOF0D+GLdi4RHsXBu7Bj2RjYtM2z77lg=
X-Received: by 2002:ac8:615c:: with SMTP id d28mr8467623qtm.103.1637079639076;
 Tue, 16 Nov 2021 08:20:39 -0800 (PST)
MIME-Version: 1.0
References: <1636961881-17824-2-git-send-email-michael.chan@broadcom.com>
 <202111160027.hFgVPM0z-lkp@intel.com> <20211116063943.7aa27c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116063943.7aa27c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 16 Nov 2021 08:20:27 -0800
Message-ID: <CACKFLin4PGrs5yrUc+gqfZc5E9nTskcApg2GA5xYWA7OOzYDyA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] bnxt_en: extend RTNL to VF check in devlink driver_reinit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 6:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Nov 2021 00:30:34 +0800 kernel test robot wrote:
> > >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c:445:48: error: no member named 'sriov_cfg' in 'struct bnxt'
> >                    if (BNXT_PF(bp) && (bp->pf.active_vfs || bp->sriov_cfg)) {
> >                                                             ~~  ^
>
> Hi Michael, is this a false positive? Is the fix coming?

It's a real error when CONFIG_BNXT_SRIOV is not enabled.  I'll send
the fix later today.  Thanks.
