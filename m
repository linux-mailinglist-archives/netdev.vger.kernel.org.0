Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20C73D4793
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhGXLgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 07:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhGXLgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 07:36:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D5C061575
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 05:16:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so7442565pjh.3
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 05:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g3ppGVpJEUxeRy6OPxPvby0Y7pmH2CyarpPHwAZK56k=;
        b=sJ9VWl/R+dXyTDu2MuBY/AzA6EH1VgjefqbJ9Lm2MfOXlSEnaxmWev8lN1esr9fwJ0
         Ecz3288LPhvwIYDgSlqOdX+h7h80Qu81489Z89Jj/GotXeJM8VCBsIgXODSsUWPW5V+D
         aKw/iR/f0kFSdcQxJLHoy1Tn2sVlABekoiNZw40nJqFkY0EnE0XcHspDxY8ojpks0HVa
         BjpJLEbIVRE7u9/s7Xa0X1Z1Iany5htY/31r4LnUp17xIok1DwSjtxe+qomBZCBoDpy/
         d+NT0fs3e0z5KFYBO7GUc8ltkCoNfuB3ZO7zVm1rHhNjjtf8DndS5om2hOwJiwoGffIS
         luqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g3ppGVpJEUxeRy6OPxPvby0Y7pmH2CyarpPHwAZK56k=;
        b=ULHPGaFo5tFB9vEcsdnPpzOCyfZoGDwDXJ3G3l70chVyEUM77RzdCA8r7P11vb6Ct6
         FWLFYWsB1iDB/0wjquIDRzLClo8BXrTcacwJjYZm459IHUBc9PRuFx1UMvTyAn2b+HAL
         glKAk/+c5WJR6hc/W6I8zEK0KaL3Vc0RXYJZsfUzmW1y4UxuaWIV0Y2IJ8mHhVaXIPm4
         7B1Vmx02hU4HZLJxvb0OXmI577/tQsr/0B8xy/RYAZwNsv/Yr2TvgQMgsHMikgY9KE8T
         VMT3ydhxc7SkAxMBIp+P2glPVYkg0FjhGvj3J0p1g6bnpjbFCEl6Fdu+mDz1JHQk3Niy
         Rsyw==
X-Gm-Message-State: AOAM533YUKNBa0hn9/gxsaxOHhLuMf7+yVNrEDDTxLABrTJGMA4utmty
        qv+elGonbKZ9qdC6CTeB/n8=
X-Google-Smtp-Source: ABdhPJyKHMg/yTUBV6X16uO0rU4bf24EFIU2cKaSOyY/DmKfpzFct+e6pDQFQwG11+94gmJUtTc9fg==
X-Received: by 2002:a63:2347:: with SMTP id u7mr3887059pgm.381.1627129016004;
        Sat, 24 Jul 2021 05:16:56 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t22sm9875175pjo.3.2021.07.24.05.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 05:16:55 -0700 (PDT)
Date:   Sat, 24 Jul 2021 05:16:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, pavan.chebbi@broadcom.com
Subject: Re: [PATCH net] bnxt_en: Add missing periodic PHC overflow check
Message-ID: <20210724121652.GA10654@hoboy.vegasvil.org>
References: <1627077228-887-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627077228-887-1-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 05:53:48PM -0400, Michael Chan wrote:
> We use the timecounter APIs for the 48-bit PHC and packet timestamps.
> We must periodically update the timecounter at roughly half the
> overflow interval.  The overflow interval is about 78 hours, so
> update it every 19 hours (1/4 interval) for some extra margins.
> 
> Fixes: 390862f45c85 ("bnxt_en: Get the full 48-bit hardware timestamp periodically")
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
