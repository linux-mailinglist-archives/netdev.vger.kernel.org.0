Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1F20FA39
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbgF3RMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbgF3RMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:12:21 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F143C061755;
        Tue, 30 Jun 2020 10:12:21 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so21439137ejc.3;
        Tue, 30 Jun 2020 10:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hLjY+FiejsKCHtdjZ2X5AG1Wh8QL9+hOBzArfxVt15s=;
        b=qBp9Bkd+bZcKlIGx6Z9Kc30AXs6nEXO8oRuh2kHPe1me1YuqwxMpQQotWwJAoWvdS8
         a6Mrxv1/phr4YSLPV7NPqwEAA3wKuJl455FYOqK3Y9pKm+4+z1ts+0MCd579LepC7xO+
         0pd40N8nWIiy/44TDVRRzJ2NA0CY2DvN8dYUCczzJxlpv8y7l5RCWWO07FrsN+leH/F1
         QxE4Tf7DCfGHyvEi32QPMwoG5cbIsx1s3q+R5ejMn0kFe4A+gZbC1bFYO0aSj25kA0sO
         1Ie5WDR/Cco30yQ/hSHaklpDnkrCo1/XoWkEHeZJNRdGvzVHjR3/VwNx2aIfxA6ghRFN
         GlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hLjY+FiejsKCHtdjZ2X5AG1Wh8QL9+hOBzArfxVt15s=;
        b=r4DxTuqW/0XtQQ4OaGXYkAJtSb4hdeEX46mAMJIstl5VIo6qC4p/BKAlbRWFWDMgaB
         rAGmkITpep3MAIzusoyYd8q4DRW62oouyeVsmAMHlF4l736FVoBd6O4L7ka1BybxcHg7
         xJmdjG13MTcHPbPxSFOLEc7Hy2UfXYzVG3EuPJNh3g0xWp99/pGXUe6XLBBjattuCEgB
         Dp0Q6VKY3Nh0vlWjYzGs5patbp27uJyOaJRNWW55lJasZs/KCsEvN2JDVOcr6+pSfTOJ
         Hu2KTzmftRhoiYkiiGM6jLaFAAEtvKdCCBtDT5OCQhT9H0tFFC7PxWIRuSuzPnDczSPy
         eiqA==
X-Gm-Message-State: AOAM533+XmDZqMGEI1L5Nbe0E7GVSEd6S6+4VHGNZxffyrmK/432/W6P
        pXGNg9I5RemuQjoZZH1llHw=
X-Google-Smtp-Source: ABdhPJy/WiZXMjLukD00/Pj3vPe0LoKDdDGPP1BLeXkJAELpuKNhsZYuZ/vw/t2EYG6lMRHMuhnqMQ==
X-Received: by 2002:a17:906:178b:: with SMTP id t11mr8136eje.489.1593537140016;
        Tue, 30 Jun 2020 10:12:20 -0700 (PDT)
Received: from andrea (ip-213-220-210-175.net.upcbroadband.cz. [213.220.210.175])
        by smtp.gmail.com with ESMTPSA id g8sm3704441edk.13.2020.06.30.10.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 10:12:19 -0700 (PDT)
Date:   Tue, 30 Jun 2020 19:12:13 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     t-mabelt@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        skarade@microsoft.com, Andres Beltran <lkmlabelt@gmail.com>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 0/3] Drivers: hv: vmbus: vmbus_requestor data
 structure for VMBus hardening
Message-ID: <20200630171213.GA12948@andrea>
References: <20200630153200.1537105-1-lkmlabelt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630153200.1537105-1-lkmlabelt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:31:57AM -0400, Andres Beltran wrote:
> Currently, VMbus drivers use pointers into guest memory as request IDs
> for interactions with Hyper-V. To be more robust in the face of errors
> or malicious behavior from a compromised Hyper-V, avoid exposing
> guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> bad request ID that is then treated as the address of a guest data
> structure with no validation. Instead, encapsulate these memory
> addresses and provide small integers as request IDs.
> 
> The first patch creates the definitions for the data structure, provides
> helper methods to generate new IDs and retrieve data, and
> allocates/frees the memory needed for vmbus_requestor.
> 
> The second and third patches make use of vmbus_requestor to send request
> IDs to Hyper-V in storvsc and netvsc respectively.
> 
> Thanks.
> Andres Beltran
> 
> Tested-by: Andrea Parri <parri.andrea@gmail.com>

Em, I don't expect the changes introduced since v1 to have any observable
effects, but I really don't know: I should be able to complete my testing
of this by tomorrow or so; for now, please just ignore this tag.

Thanks,
  Andrea


> 
> Cc: linux-scsi@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> Andres Beltran (3):
>   Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
>     hardening
>   scsi: storvsc: Use vmbus_requestor to generate transaction IDs for
>     VMBus hardening
>   hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus
>     hardening
> 
>  drivers/hv/channel.c              | 154 ++++++++++++++++++++++++++++++
>  drivers/net/hyperv/hyperv_net.h   |  13 +++
>  drivers/net/hyperv/netvsc.c       |  79 ++++++++++++---
>  drivers/net/hyperv/rndis_filter.c |   1 +
>  drivers/scsi/storvsc_drv.c        |  85 ++++++++++++++---
>  include/linux/hyperv.h            |  22 +++++
>  6 files changed, 329 insertions(+), 25 deletions(-)
> 
> -- 
> 2.25.1
> 
