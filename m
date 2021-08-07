Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440B23E370C
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 22:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhHGUqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 16:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhHGUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 16:46:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011EEC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 13:45:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so23401034pjh.3
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 13:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zi8Ckmn+MFCZzYYd00KoG4NgYZUjFUOPpnnNJj+1WBw=;
        b=gfL7NqQBPfm9T7Sz8t+Lx2mx4ruZCPs8Gt1vz5exy/wqmCBHss3zeHTVpDma+2ysCs
         j1OZ0aMr7cY1D2nXYMp8bsSOWFp12RFKBGrQLFNXWw36JK23zbtIDM+jHM+FUnYEuHwe
         u/u3ATE2IvlOliqdGcKuio9Ufx9IWqyv3m33WX7xXDVZwtPCsPowBG7Wger1/WMgZcvu
         /Fi0kkNrTwDUsJ34Mlx97dndzhYFMG1mMMdkSSEWDW3oJximxl5kMnitlydEg7Smbkif
         7SZksxpPJ+sM+ydMqMfVI50lCXZOhXF/cKhi4VcQnoqpLSl3uLE9H5nD9MkNZ2z/u8yX
         D6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zi8Ckmn+MFCZzYYd00KoG4NgYZUjFUOPpnnNJj+1WBw=;
        b=ShebDVlTyakUDJQ2KQ08thePSnFE2lyvuV0XdPtlKLu4wC11gSWD/NpHqwVfZd5RtJ
         UbBxpZy5GthxfmFS6filHEfEl7wUgMmGElMO6L/Fy+buhDNsObc0XUOULMr8NhhypfKU
         QPVK/m4P6F1X5xTuSfWDvvr0WagaoO3sxlDdIl68RMxeyyr1OBiYoHYuvB5ViQlheg2P
         jkfYxY/3lvEv2+bxQ7cnt0Cf6diYCFC/WZQ1uh/cjrcc0rV3U9SF+7tt2Hj9V9vjpRjy
         t9nL6c6XuUAWy9lycMO2YoaMiwfC5gxcg3pBxJ28YmDSVXHeIkuvYu5z18chhvBOkZUT
         oVqg==
X-Gm-Message-State: AOAM532MY7Bs481VP7SYjwdoJ/88hkNx3CazM1OrRFl1a7wflTkvk7m5
        yld7sIMLKilNdoa3PrDyz3k=
X-Google-Smtp-Source: ABdhPJxvLtVBVicv4tgpshBl8j1k+ApO4fOXnBNQeRCw5kZQ/EG9VvuY5NNuQwt5XsCwnxLnI402EA==
X-Received: by 2002:a17:90a:3f87:: with SMTP id m7mr16737488pjc.96.1628369146508;
        Sat, 07 Aug 2021 13:45:46 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c26sm8721827pfo.3.2021.08.07.13.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 13:45:45 -0700 (PDT)
Date:   Sat, 7 Aug 2021 13:45:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, pavan.chebbi@broadcom.com
Subject: Re: [PATCH net 0/3] bnxt_en: PTP fixes
Message-ID: <20210807204543.GC22362@hoboy.vegasvil.org>
References: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 03:03:12PM -0400, Michael Chan wrote:
> This series includes 2 fixes for the PTP feature.  Update to the new
> firmware interface so that the driver can pass the PTP sequence number
> header offset of TX packets to the firmware.  This is needed for all
> PTP packet types (v1, v2, with or without VLAN) to work.  The 2nd
> fix is to use a different register window to read the PHC to avoid
> conflict with an older Broadcom tool.
>  
> Michael Chan (3):
>   bnxt_en: Update firmware interface to 1.10.2.52
>   bnxt_en: Update firmware call to retrieve TX PTP timestamp
>   bnxt_en: Use register window 6 instead of 5 to read the PHC

for the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
