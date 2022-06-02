Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8E53B47E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiFBHkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiFBHkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5B66D11E
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654155649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H3rUL7ZZeT2JwdmclqqOS1FGxkIH/lrh6coXqnJEDkk=;
        b=blJtazdxWELj8mVnT9nasWLDmJxx4mh2NY3sf0B7oILVGuvEtZyHHa0QAvfeM78bned+PG
        GXrYbGLq8Et6jw8nhgkzruXquKP1K/7r4ydqS9TE5irWgNmogD8wQbxkfJGxBlEeGuihTv
        bZmGjGZtjSahAXIy3l/J20IEmVHn7fI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-XLSn9mgIO2i9t4BmvmYJOA-1; Thu, 02 Jun 2022 03:40:48 -0400
X-MC-Unique: XLSn9mgIO2i9t4BmvmYJOA-1
Received: by mail-lf1-f72.google.com with SMTP id br24-20020a056512401800b00477cb7c9a9dso2157414lfb.1
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H3rUL7ZZeT2JwdmclqqOS1FGxkIH/lrh6coXqnJEDkk=;
        b=6DLCMj1k0Y8LoqstIfDu2W3GhSoU7Sma9By+4TzulmWuWX0BCVKlI+QD9PxufW+3bK
         zfuJAua3FyGuMVNJh+b+pM4O/F6GWwhtWepmzat/B96FlzGK5w8b6ldYdzDjDGMdSIQA
         bqYV6wZ/vEG9Chzi7PBIe5laxO48eNpCPC5MCn/hD6KYx04EvMrPWAqgjQil+rOGLhMX
         Fd1d+L1jeeHgTM6Tk9MUZ4qPTrkr2HTiTHTSoyNLD8wI+iFh8QTTpXL+85atM4KCCPv1
         qj0ql0MbaeEH7CQkhy78NNtSi7m6Y30OCOIoDA0U/wSDEo6DfoDT8H2dHzxtMTSi/0VF
         6qAw==
X-Gm-Message-State: AOAM531tpel4ZmeSdjipssvTcSjC7E8Y2gSndoFm5tTidq0gXQuLVEeR
        GbC9UL9JctKh/5kwVaZTZsxozFPFD7HNZFd9h9BthIcBGG2XI8ms8uq9mEtE/ZzIvoW8wyEPmVb
        OsWtR65uKN2f47PNI4JbG4ryTGBuv5S1P
X-Received: by 2002:a2e:8752:0:b0:255:6df7:7ad5 with SMTP id q18-20020a2e8752000000b002556df77ad5mr3614643ljj.73.1654155646302;
        Thu, 02 Jun 2022 00:40:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmmX7LWMurM60IlJrSEEDX4JnlvIsnNorPLL0O33CXCEcRX5d60Fd6hXV3QcY0b++HGPrddNlzyUhtSmsEZag=
X-Received: by 2002:a2e:8752:0:b0:255:6df7:7ad5 with SMTP id
 q18-20020a2e8752000000b002556df77ad5mr3614632ljj.73.1654155646126; Thu, 02
 Jun 2022 00:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-7-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-7-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:40:35 +0800
Message-ID: <CACGkMEtS6W8wXdrXbQuniZ-ox1WsCAc1UQHJGD=J4PViviQYpA@mail.gmail.com>
Subject: Re: [PATCH 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa_dev_net_config_fill()
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit fixes spars warnings: cast to restricted __le16
> in function vdpa_dev_net_config_fill()
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 50a11ece603e..2719ce9962fc 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                     config.mac))
>                 return -EMSGSIZE;
>
> -       val_u16 = le16_to_cpu(config.status);
> +       val_u16 = le16_to_cpu((__force __le16)config.status);

Can we use virtio accessors like virtio16_to_cpu()?

Thanks

>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>                 return -EMSGSIZE;
>
> -       val_u16 = le16_to_cpu(config.mtu);
> +       val_u16 = le16_to_cpu((__force __le16)config.mtu);
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> --
> 2.31.1
>

