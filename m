Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76C53F5F8
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiFGGQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiFGGQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB27D7710
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 23:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654582565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mfFt9YB7FAG4KKOd5cKTjk9ERTgqrvpSR7iiUCrN8L4=;
        b=Zh0w9JH2nNaN/xQca72ys+0mWPSzR+3MxUin+DuNBVvSYNKc0Q4T4eSAiVaE4Y26x4DwGu
        2RFdiQEA9duIzUrFnFZleGMzoRhQMepSozJFhLVimi31fuCjtdg4jTGa7bFbqxQfk1k3Yl
        2s7VRMPJ6Q6/qiDHcyG6y9Zg6ZVjrkw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-xQEUXpzkPcmx0_N8VZ3R8A-1; Tue, 07 Jun 2022 02:16:03 -0400
X-MC-Unique: xQEUXpzkPcmx0_N8VZ3R8A-1
Received: by mail-lf1-f71.google.com with SMTP id w16-20020a197b10000000b004795bcb0bbbso1339637lfc.14
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 23:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfFt9YB7FAG4KKOd5cKTjk9ERTgqrvpSR7iiUCrN8L4=;
        b=Vgkow0ok83BOFOb46m+KbCUROMTHuYgmb7yea/r60ixctOq+tYyhWkPmiAf88VunXm
         6rSpElbl0KWn2WNunvdu/JOonPMzp0KRc9DKPEd+M6OzY/TaMpC+diLL8w3sU2vrz9wW
         d4wWCvtvZxi5TnO46DVsZyjcItHUvfulDSPMlwJCWasnTdqUbNlloR/O7vlr4IlP8dkO
         9PfVfbHmap+hqzcftIT45Mvsp6dSbheGqxmfYEnJlb1Pcb4riC7Fpv2lxxNSi9s/XQav
         dWGYqxyr7PA/VYxiDnOxvvX8QNR5F3zWipcPKf8ZXyHL1PViSM7ypOCjplPak1UGhnmt
         9q6Q==
X-Gm-Message-State: AOAM5305EBX9dbLc4NZp43oyhdFhdsVSpYDFneoL+2w7ZzX3jIsY61Vk
        adNpZ+7FeLEVx9n0vWJZHaZXb7Jb3Qi0wUzglsqDaFHJ/bCkjTWil/rkfRk6kLtlgX+orTGd8b3
        x22ei/2v1CDkwlE+1KUxqLBW8ALJtpsOd
X-Received: by 2002:a05:6512:3e1d:b0:479:3cfa:f2c4 with SMTP id i29-20020a0565123e1d00b004793cfaf2c4mr6986711lfv.98.1654582561645;
        Mon, 06 Jun 2022 23:16:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZzTuBn3IIguYCiZKP5oHvXhD16W7D6wTFb71MJ8M2FxxZx+S93j4cdDUj1/zy38Fq4cdFG9Ckb6I3T6j/8GY=
X-Received: by 2002:a05:6512:3e1d:b0:479:3cfa:f2c4 with SMTP id
 i29-20020a0565123e1d00b004793cfaf2c4mr6986701lfv.98.1654582561471; Mon, 06
 Jun 2022 23:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-7-lingshan.zhu@intel.com> <CACGkMEtS6W8wXdrXbQuniZ-ox1WsCAc1UQHJGD=J4PViviQYpA@mail.gmail.com>
 <054679a9-16ed-6cf6-ba8d-037aedc29357@intel.com>
In-Reply-To: <054679a9-16ed-6cf6-ba8d-037aedc29357@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 7 Jun 2022 14:15:50 +0800
Message-ID: <CACGkMEvGidNuYJ6Lww7CgAAx8Es7UvoDNfwDB_pJY7b0W3U6cQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa_dev_net_config_fill()
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 4:22 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 6/2/2022 3:40 PM, Jason Wang wrote:
> > On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >> This commit fixes spars warnings: cast to restricted __le16
> >> in function vdpa_dev_net_config_fill()
> >>
> >> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >> ---
> >>   drivers/vdpa/vdpa.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >> index 50a11ece603e..2719ce9962fc 100644
> >> --- a/drivers/vdpa/vdpa.c
> >> +++ b/drivers/vdpa/vdpa.c
> >> @@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>                      config.mac))
> >>                  return -EMSGSIZE;
> >>
> >> -       val_u16 = le16_to_cpu(config.status);
> >> +       val_u16 = le16_to_cpu((__force __le16)config.status);
> > Can we use virtio accessors like virtio16_to_cpu()?
> I will work out a vdpa16_to_cpu()

I meant __virtio16_to_cpu(true, xxx) actually here.

Thanks

>
> Thanks,
> Zhu Lingshan
> >
> > Thanks
> >
> >>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> >>                  return -EMSGSIZE;
> >>
> >> -       val_u16 = le16_to_cpu(config.mtu);
> >> +       val_u16 = le16_to_cpu((__force __le16)config.mtu);
> >>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>                  return -EMSGSIZE;
> >>
> >> --
> >> 2.31.1
> >>
>

