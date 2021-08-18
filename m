Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C993F09E2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhHRRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHRRGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:06:15 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967D4C061764;
        Wed, 18 Aug 2021 10:05:40 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id x4so2897256pgh.1;
        Wed, 18 Aug 2021 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y0WyiEQfJ5BEumrqHD4PuYkdcoLZT1ER4+J/Mwi+4DY=;
        b=fXVowPPp9qtDvG/dZC9YKEX4X+0eMwjBKiQer7Do/HoDgzA5ll9qkbMbkgm/I7MvIf
         vLDqGEOlh3jLKvnS4klF6wuxO1hnPGZXlZUstzRc8pe64FY6vyxlfEPctKA1n85xTngZ
         o0G8H0yicS7G4MA2BfeZ7EYdZceeas9ywNSjrPKgeGo1kinXTOzIYvt6YypNBnRbjW6/
         /uxeHtbuLz4189ALvXMr/V7pdbsQb17FEuw5nFmU77J1sf4oztS8DtcLgpZIO2mA+k4s
         YnRz6A784vnPGyUcZzsVWsRz+6oGONIraU8SwotWltXjW7tCY3SrW1OUsknpSQyrGH1s
         TJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y0WyiEQfJ5BEumrqHD4PuYkdcoLZT1ER4+J/Mwi+4DY=;
        b=PjYhlTG1SWKImRqV/NYs7zIdektclhUIcz7P9817kVoPbAcmXjk2YWtDckQCGPAtP7
         18fo2bSSPNsjPKYfOoQngV/y+ApXiQHlLi0V/CxwGTZTv5MVqiBs/NYj+vsn+YNldh1c
         TwQiyJXozQKOyzTGJLjM8KfpTOK/buCmG5GHzGxD+bCrHp0B/52z6UBAAXZ9d6DLGkzn
         KEx+CKg7hRndRb6QRpMeQ3S/iqc6KwE11F4S587pdoC2dTdp5R2A8xmjsIHEZUyQFKqS
         0QCzRPkjuo0nFn5dVNHs/FmRek6TveIffCjSGqbJEe8Dn4NmBeoKV7kN6utNkJaZtEyB
         Lz6w==
X-Gm-Message-State: AOAM533uNc3EdX73TL34itzw+YWdyLI3OHB8LCgRMdYJeJADDhCDGQ+x
        2goi74Zkw7/sXTI+/TS1DJ4=
X-Google-Smtp-Source: ABdhPJzvfWsJKrXR0zuvu0wYxzR3EqJEhjAXU+vPLZEGuEVv5+tB29am4ZZrvbYzqxErmhspXDbRjA==
X-Received: by 2002:a65:4307:: with SMTP id j7mr9617547pgq.387.1629306340131;
        Wed, 18 Aug 2021 10:05:40 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x7sm306615pfj.200.2021.08.18.10.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:05:39 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:05:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        arnd@arndb.de, nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: Re: [RFC net-next 0/7] Add basic SyncE interfaces
Message-ID: <20210818170536.GE9992@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:07:10PM +0200, Arkadiusz Kubalewski wrote:

> The second part can be used to select the port from which the clock
> gets recovered. Each PHY chip can have multiple pins on which the
> recovered clock can be propagated. For example, a SyncE-capable PHY
> can recover the carrier frequency of the first port, divide it
> internally, and output it as a reference clock on PIN 0.

This really sounds like its own thing, and not a PHC at all.

> Next steps:
>  - Add CONFIG_SYNCE definition into Kconfig
>  - Add more configuration interfaces. Aiming at devlink, since this
>    would be device-wide configuration

As a first step, finding an appropriate kernel/user space API would be
needed.

Thanks,
Richard
