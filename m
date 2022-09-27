Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B571A5EB94C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 06:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiI0EjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 00:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiI0EjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 00:39:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34206FB302
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUYySdokudzYAu/PwShHz0v/wpwcIfbDjXPzc5w9Z/8=;
        b=ObVpW/8v5vr27ITirxsec6tCRIstFkB130WWFhdvJvmo8B4dtp6V2A9N/kAFOcSrsI3Jy9
        OQotv0jlG/4XnOS4oDGpeTogORq7in1NH1IcgFzViZxhfzhV5QASZ3iixQU0tp1Ox8JJr6
        JFMtqLLECz3XkGuCoA8o8zzOuZwS99M=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-sc_XLYqUMHqG0nWgWh7jKg-1; Tue, 27 Sep 2022 00:38:59 -0400
X-MC-Unique: sc_XLYqUMHqG0nWgWh7jKg-1
Received: by mail-oi1-f198.google.com with SMTP id a26-20020aca1a1a000000b0034fdf34de68so2815011oia.12
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=UUYySdokudzYAu/PwShHz0v/wpwcIfbDjXPzc5w9Z/8=;
        b=rMTO1BvBbE20RZ9ARf1dSWIHf2zg9bGYgfax9ptCBkI3paBGDPyW+GqbZdZdBPgMQ4
         4/Ap5RTf9e56XIbdyZ+r5uL9yeh5UIfLinXIqsQz2Xz5pH+wqFCi3k7OlwvEhrqdJVAf
         /o6Ywjhs9vbngktzQoCpjUbkl6utl3VbAV4ZsCGG+QqGQf2JZI+X7u0j+Idz+InIZogw
         aviN7p6Bdylk/ofJ9xlnzLXuQhbDdCBmKt88LTKae+yTIQR08Dj8oS8D7KdIXbNW2EfL
         d3rWNVYWlvIva+C1lCbA2HQGqE3VhZnWQz+qPt34pJGseYdwDBjKeemS9+TnhZAoHWqn
         CjpQ==
X-Gm-Message-State: ACrzQf2dM6svmgU2APzeRVQlbqCEE3bCxyDoilFzoVK8vmSG4pCq5QJP
        e+Oq5XgGKjv3Whg86RSWKDR86l8PToDWUFCcx81UG/St6rtRvuSYQcjGemTMknBErpfAVD8XSpD
        lSth7MPL+aOy38ZiC3NWeh0FaGc1ITSWC
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr948389oib.35.1664253538580;
        Mon, 26 Sep 2022 21:38:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6dtWDIDMFMsm1TLAUpFC0nEqOJfRQrv1Inh+yp5FeOdRtNy1OaIjtWjmVbiQUn0wRzZTkbR7IWTxa32X2nA7Y=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr948382oib.35.1664253538380; Mon, 26
 Sep 2022 21:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-6-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-6-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:47 +0800
Message-ID: <CACGkMEtBQr9ZSdN0WUxEZ7wHb5ikpyheVAjfbiPSDRM8SqHhcQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 5/6] vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:10 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit fixes spars warnings: cast to restricted __le16
> in function vdpa_dev_net_mq_config_fill()
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 84a0c3877d7c..fa7f65279f79 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -809,7 +809,8 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>             (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>                 return 0;
>
> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> +       val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
> +
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> --
> 2.31.1
>

