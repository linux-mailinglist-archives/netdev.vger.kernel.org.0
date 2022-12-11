Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F2649583
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 19:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLKSGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 13:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLKSGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 13:06:07 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D05B860;
        Sun, 11 Dec 2022 10:06:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h11so9817311wrw.13;
        Sun, 11 Dec 2022 10:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQB5wiJruuXEoFTRN35atj92efL08Shno7AmgnEzXsc=;
        b=P56qAfeP+w12O11oIRnih8J4XusgmJe9MNlDEi1QNzv9j2kp79e0seqJBuPPD2DZ1+
         k7sK4KafuyWHyBnNNfrbfFv8OUVbtqajUqx3fd8TmAMi6R8SHfatQ81zHKoUIz7qJaGL
         t2RNvggN6SOy8QiiaEQG+RFM8j2AuW3Rv9NUnJgVtNA+be4SJiEebeYWE7yJ6qF1xZeG
         8YrN0jbewqUyvnJsWg68KBG9kzBJLMsbamJR9fhzhTOXDv53x7YkZlBBgUzug67taNjE
         A7ZEMyekJ33L+uivFSV9qxYSSsYmKsWaqof4xXT/hpzF5vROnUdrwip86PcsWcE1e7gg
         CH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQB5wiJruuXEoFTRN35atj92efL08Shno7AmgnEzXsc=;
        b=XNi7fodRIG1FnTSwpzSfYAH29JVZOUMC+Wm3YxfKf9cqQQojQrC7TVE6BOSYR+sjvq
         ehLL0/cDTTY8OOaBLacRVkvxx9WBTwnIN5/+TFHKDe5Bc7mqdRH8tkD41a+ocjokMsCb
         GTJTo2v9AjLr+9aCTo3iivfetJd+2zsJaqv57cXrH7uTezSJOZc2sj+lcz33yJBjZg1A
         sYgF8mbjg8MiGeAHkRnJzOtZiVMOn5l0iXxbUNmtGNryRSIeE+NQOwLBrRBiKxPbgBIB
         UR7sDCxJgErtwvNYuOjxw5v2ka9jZZ18Z3g7t1EhhNlsTMgV4V3uq0Dt4tXgnkfjzIWm
         z29Q==
X-Gm-Message-State: ANoB5pk64My8MZATBDX/jD8NgOnWJc/7nA3TkLQFYqBc9Ghg0ZhChL22
        Xny/RK2AelY35BXdWFOGNQs=
X-Google-Smtp-Source: AA0mqf4vol3XbU3xkW4XTS4BaX6Kz7y7qvyvsSTKIPtjxqDhlIBb5txCcSXwFwtlBsGTYb5u9HYl3A==
X-Received: by 2002:adf:f145:0:b0:242:486:5037 with SMTP id y5-20020adff145000000b0024204865037mr8318366wro.32.1670781961502;
        Sun, 11 Dec 2022 10:06:01 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id cl6-20020a5d5f06000000b0024274a5db0asm6953182wrb.2.2022.12.11.10.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 10:06:00 -0800 (PST)
Date:   Sun, 11 Dec 2022 18:05:58 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        jasowang@redhat.com, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] sfc: add vDPA support for EF100 devices
Message-ID: <Y5YcBoDyAlT4DtLQ@gmail.com>
Mail-Followup-To: Gautam Dawar <gautam.dawar@amd.com>,
        linux-net-drivers@amd.com, netdev@vger.kernel.org,
        jasowang@redhat.com, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 08:24:16PM +0530, Gautam Dawar wrote:
> Hi All,
> 
> This series adds the vdpa support for EF100 devices.
> For now, only a network class of vdpa device is supported and
> they can be created only on a VF. Each EF100 VF can have one
> of the three function personalities (EF100, vDPA & None) at
> any time with EF100 being the default. A VF's function personality
> is changed to vDPA while creating the vdpa device using vdpa tool.
> 
> A vDPA management device is created per VF to allow selection of
> the desired VF for vDPA device creation. The MAC address for the
> target net device must be specified at the device creation time
> via the `mac` parameter of the `vdpa dev add` command as the control
> virtqueue is not supported yet.
> 
> To use with vhost-vdpa, QEMU version 6.1.0 or later must be used
> as it fixes the incorrect feature negotiation (vhost-vdpa backend)
> without which VIRTIO_F_IN_ORDER feature bit is negotiated but not
> honored when using the guest kernel virtio driver.
> 
> Gautam Dawar (11):
>   sfc: add function personality support for EF100 devices
>   sfc: implement MCDI interface for vDPA operations
>   sfc: implement init and fini functions for vDPA personality
>   sfc: implement vDPA management device operations
>   sfc: implement vdpa device config operations
>   sfc: implement vdpa vring config operations
>   sfc: implement filters for receiving traffic
>   sfc: implement device status related vdpa config operations
>   sfc: implement iova rbtree to store dma mappings
>   sfc: implement vdpa config_ops for dma operations
>   sfc: register the vDPA device

For the series:
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> 
>  drivers/net/ethernet/sfc/Kconfig          |   8 +
>  drivers/net/ethernet/sfc/Makefile         |   2 +
>  drivers/net/ethernet/sfc/ef10.c           |   2 +-
>  drivers/net/ethernet/sfc/ef100.c          |   6 +-
>  drivers/net/ethernet/sfc/ef100_iova.c     | 205 +++++
>  drivers/net/ethernet/sfc/ef100_iova.h     |  40 +
>  drivers/net/ethernet/sfc/ef100_nic.c      | 126 ++-
>  drivers/net/ethernet/sfc/ef100_nic.h      |  22 +
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 693 +++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     | 241 ++++++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 897 ++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi.h           |   7 +
>  drivers/net/ethernet/sfc/mcdi_filters.c   |  51 +-
>  drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
>  drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
>  drivers/net/ethernet/sfc/mcdi_vdpa.c      | 268 +++++++
>  drivers/net/ethernet/sfc/mcdi_vdpa.h      |  84 ++
>  drivers/net/ethernet/sfc/net_driver.h     |  19 +
>  18 files changed, 2650 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/ef100_iova.c
>  create mode 100644 drivers/net/ethernet/sfc/ef100_iova.h
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h
> 
> -- 
> 2.30.1
