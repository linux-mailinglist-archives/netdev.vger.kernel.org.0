Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2919251FE3E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiEIN1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiEIN1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:27:41 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E31E251A;
        Mon,  9 May 2022 06:23:28 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so23828707lfb.0;
        Mon, 09 May 2022 06:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1K2obVx3YG8QEPrenU4QI5guJQ8Phbo/6yP70JTaawU=;
        b=ctuOdHCyg4DfJDMuVyrfXjafqsIBGrPq9u27BiBAquJftMSjYFJ55Dztcsr8bNMn0w
         oeM//L+QbMc5cqR/YL4ZYXu9SspJYNvQLipuO/dxUV/COK7qJD4YPieEuwN+Da6gnICg
         tiL5ifQOF61sLM7j5k+TfKf3keD2QE9+mfbjkcLau1uokLQ0TJXXWGRj10hWZc6mNTCY
         ZiPlrCXkxh/d8AP+hVzj144bdbLZ6gunWEeo3XTOHdZMf+1T4Dk4fDvhUDM82hKq6q3x
         a24gfPwl0eQuynyAnF+v9tUB7WbmPEsnBDi3opOHoOjQkJbqyH8fYmRySBDQ1lHi3t+I
         lY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1K2obVx3YG8QEPrenU4QI5guJQ8Phbo/6yP70JTaawU=;
        b=mIkc0TZp+d1LwPecfcRJtDyH8BAqmNXPw1gYvuKs2yAX+y/qu14tJVn5mKfiCdAUiD
         J1PqhiIjZpmt4I41YmLtpvg+xbziJgzNGHXGMiOFa6DvXp7/eZptbtwLH2IAhvwlPCxS
         NabvguI5sndh9CnuM7+Nbt5RqzIBU1d3G0QPTQgzq002Of+D7T6HGgaawOrPEptXXb3P
         eUYjlsTq3r2LFbCvBBF+mq0oXHqqNcckY+cE/SOi0e0PXu5RldMDfIevfXgKBHyWePHP
         0sgqvfjsdEogwf9f3gIvaQlDCS3kpPAdvafbIWiQQWGKMr+zn7KSbobrxskZHZW/vLap
         5kFg==
X-Gm-Message-State: AOAM530ONvoAN48p67Wf1oX/vzg/HnhHcWEtfhjcp+b/GIzlzZTrFcLh
        BlXgCeuNzxRrgAUVOGngXGI=
X-Google-Smtp-Source: ABdhPJy54uNV0a0Y5a5xZUhU6QHCMVecZmAJ2frVW6KAYppShjM44jXuH8rdrMemcTVYgMIiSG1E7g==
X-Received: by 2002:ac2:4c49:0:b0:473:ca4f:9345 with SMTP id o9-20020ac24c49000000b00473ca4f9345mr12622420lfk.203.1652102606387;
        Mon, 09 May 2022 06:23:26 -0700 (PDT)
Received: from [192.168.1.7] ([212.22.223.21])
        by smtp.gmail.com with ESMTPSA id h5-20020a056512338500b0047255d2111csm1941442lfg.75.2022.05.09.06.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 06:23:25 -0700 (PDT)
Subject: Re: [PATCH v3 00/21] xen: simplify frontend side ring setup
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-integrity@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20220505081640.17425-1-jgross@suse.com>
From:   Oleksandr <olekstysh@gmail.com>
Message-ID: <409fb110-646a-2973-aff3-c97fdfb9bfbc@gmail.com>
Date:   Mon, 9 May 2022 16:23:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220505081640.17425-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.05.22 11:16, Juergen Gross wrote:

Hello Juergen.



> Many Xen PV frontends share similar code for setting up a ring page
> (allocating and granting access for the backend) and for tearing it
> down.
>
> Create new service functions doing all needed steps in one go.
>
> This requires all frontends to use a common value for an invalid
> grant reference in order to make the functions idempotent.
>
> Changes in V3:
> - new patches 1 and 2, comments addressed
>
> Changes in V2:
> - new patch 9 and related changes in patches 10-18
>
> Juergen Gross (21):
>    xen: update grant_table.h
>    xen/grant-table: never put a reserved grant on the free list
>    xen/blkfront: switch blkfront to use INVALID_GRANT_REF
>    xen/netfront: switch netfront to use INVALID_GRANT_REF
>    xen/scsifront: remove unused GRANT_INVALID_REF definition
>    xen/usb: switch xen-hcd to use INVALID_GRANT_REF
>    xen/drm: switch xen_drm_front to use INVALID_GRANT_REF
>    xen/sound: switch xen_snd_front to use INVALID_GRANT_REF
>    xen/dmabuf: switch gntdev-dmabuf to use INVALID_GRANT_REF
>    xen/shbuf: switch xen-front-pgdir-shbuf to use INVALID_GRANT_REF
>    xen: update ring.h
>    xen/xenbus: add xenbus_setup_ring() service function
>    xen/blkfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/netfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/tpmfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/drmfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/pcifront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/scsifront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/usbfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/sndfront: use xenbus_setup_ring() and xenbus_teardown_ring()
>    xen/xenbus: eliminate xenbus_grant_ring()


For the patches that touch PV display (#07, #16), PV sound (#08, #20) 
and shared buffer framework used by both frontends (#10):

Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>


Also I didn't see any issues with these frontends while testing on Arm64 
based board.
So, you can also add:

[Arm64 only]
Tested-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>


Thanks!


>
>   drivers/block/xen-blkfront.c                |  57 +++----
>   drivers/char/tpm/xen-tpmfront.c             |  18 +--
>   drivers/gpu/drm/xen/xen_drm_front.h         |   9 --
>   drivers/gpu/drm/xen/xen_drm_front_evtchnl.c |  43 ++----
>   drivers/net/xen-netfront.c                  |  85 ++++-------
>   drivers/pci/xen-pcifront.c                  |  19 +--
>   drivers/scsi/xen-scsifront.c                |  31 +---
>   drivers/usb/host/xen-hcd.c                  |  65 ++------
>   drivers/xen/gntdev-dmabuf.c                 |  13 +-
>   drivers/xen/grant-table.c                   |  12 +-
>   drivers/xen/xen-front-pgdir-shbuf.c         |  18 +--
>   drivers/xen/xenbus/xenbus_client.c          |  82 +++++++---
>   include/xen/grant_table.h                   |   2 -
>   include/xen/interface/grant_table.h         | 161 ++++++++++++--------
>   include/xen/interface/io/ring.h             |  19 ++-
>   include/xen/xenbus.h                        |   4 +-
>   sound/xen/xen_snd_front_evtchnl.c           |  44 ++----
>   sound/xen/xen_snd_front_evtchnl.h           |   9 --
>   18 files changed, 287 insertions(+), 404 deletions(-)
>
-- 
Regards,

Oleksandr Tyshchenko

