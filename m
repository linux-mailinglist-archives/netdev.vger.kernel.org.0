Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53295EB94A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 06:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiI0Ein (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 00:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI0Eim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 00:38:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174DAADCC0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZzmX/LZpNg3sCgzTfVweFFRT/JxjvUTK3cLB50DJXY=;
        b=KnkDNNYqKwLTF61b1lrwoPHaAypMreK6KuIbfEPRCcCqaJX1zwvlnN+F0eND4URNak+92Q
        vazNWa05OnB60IXYlhO9hD4R68wQj7fH9OB2B/wnePDaDIGtVQefm3BfWJjlJaf2P6rQGb
        A7MRukClZnT62OYo3V+80yo/x/0uDFw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-5LRKFaB3NOKAaza5cT_0ig-1; Tue, 27 Sep 2022 00:38:38 -0400
X-MC-Unique: 5LRKFaB3NOKAaza5cT_0ig-1
Received: by mail-ot1-f72.google.com with SMTP id u7-20020a0568301f4700b006540f740af1so4218243oth.15
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LZzmX/LZpNg3sCgzTfVweFFRT/JxjvUTK3cLB50DJXY=;
        b=Z5E1NmqK7H67F3QyMuur5REI7quporrQI1mcesGTu5Zahf1299neDcSX4O5yzRQcru
         GIro72Ni8+yhVsrG4DJw70djIUECQeRlTj3AA51UisUQgFlyJ5fCQSCXzzgpYHgPaH4K
         eJSXx+ASLPbnHHwtyjWuTcXkNxSoRx3xV6z3QJSGAPAic13hBKnFSuXvpxMbBW7LyskI
         thVQoEJ7xVelyzNNgwiH6ocqXIQjiDtRJHY8OGd3s9lTbT/6u32ADw9Q+MiwRG7Nwbi/
         YQwjJQVkEQjzv5eupEAcnL5rynIxLujv3c4Z/kxPiAmbro/64AykxSTp+w8A7txBWq5G
         bvaw==
X-Gm-Message-State: ACrzQf1GDD/gGSkAFxdmrgO9H5GcSyGY20MtxBIeu4WzZvUYRz35H645
        hZxtazKUVzyy4DRCxL7K/og66IDJkUqU+o6xS4Qsacz3GcQYAPS14DvEdZ8bONWK9/r2O7KFBdB
        se4TUKHjouAtcpgDsoeZdHOzqEs973uih
X-Received: by 2002:a05:6870:e409:b0:127:d330:c941 with SMTP id n9-20020a056870e40900b00127d330c941mr1098026oag.280.1664253517660;
        Mon, 26 Sep 2022 21:38:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6KWLqfJGIYu2DMf98dx7P5bJF0eOmO5aC9XWtZcg5CfjpovBHj6fifEe189yrHy4f3HtwIm3fQ26DaUdD8y+0=
X-Received: by 2002:a05:6870:e409:b0:127:d330:c941 with SMTP id
 n9-20020a056870e40900b00127d330c941mr1098021oag.280.1664253517451; Mon, 26
 Sep 2022 21:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-5-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:26 +0800
Message-ID: <CACGkMEuzee5cuEhkPVduvesFEo7FfXWOmxHf70bN4JWp7Zi0GQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 4/6] vDPA: check virtio device features to
 detect MQ
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> vdpa_dev_net_mq_config_fill() should checks device features
> for MQ than driver features.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 829fd4cfc038..84a0c3877d7c 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -839,7 +839,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> +       return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>
>  static int
> --
> 2.31.1
>

