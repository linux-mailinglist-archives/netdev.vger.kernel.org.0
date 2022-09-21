Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2E5BF800
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIUHoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIUHoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FB985F87
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663746243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=86vShVgoh12B6XaEHHutbnawfEbjDkAMZ1MtTQw6pEo=;
        b=Y1w9VV80QRdbg9+5omFjMxcuylpzmt0L8D1NnKPkCndaRHj9t++CJ7lty02QMH9KeJnA/Z
        XKIWvMg0ybmTUBhBjIT6+Na7zHuoXkQ/ylANS+8RGL+3qT3BlgmT0EyDEoXv/TOn78R1cn
        Dz32W6HFrzqCtHqn+W62VdpCA7ZYs1A=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-I5EAzPy7Os6Q5a7Z1Omarw-1; Wed, 21 Sep 2022 03:44:01 -0400
X-MC-Unique: I5EAzPy7Os6Q5a7Z1Omarw-1
Received: by mail-oi1-f198.google.com with SMTP id u10-20020a54438a000000b003451c5e52b2so2740431oiv.10
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=86vShVgoh12B6XaEHHutbnawfEbjDkAMZ1MtTQw6pEo=;
        b=29tj3mOI+5wQ3KDJH1gd/5KOEgLLndcqEg20LoYRamhyOWiVxUj3MHwNna/SQzssPR
         QS7vT4cWQKQGEsqvZ/51QcTzVBO6Ii/KJWFvJC413x5B7wNiOI9tOiTSvN93YHSQTyGI
         GPizZ5Nshv8Pfo+p4z1Rg7m2BqZwhGj0gAgASmD79bGP+0KMgkdCfNhXgaEIeqdUF6aW
         o6L3xJ5oFVUCuSqWLB6Sc/OVK8SI8sBySZW0csUs+oCzISz/2qtCjIHusis7urPGJ8zF
         TuiANy/YQdPrx1lA37FXgVT3Y4BeIUAV6ZTHs0Ulle3h60vOSbb6asvYnch4Knyz3Xw0
         2XVw==
X-Gm-Message-State: ACrzQf1whM/lP6RTBWTE2tpccl0DDfZlk2AgTwN4oWgxgl3bJgz/Vm0O
        pHJNty3MtjP0ziGO8oUrhEX6ImLzcogSiRlTs5OepBTbp2RVuIA42Mqbxy8udwPBLpry8O/k8Rk
        kI9AQFYZAPY+rDC+YWbnVLeu0nJb5t2no
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id y4-20020a056808130400b00350649bf8a1mr3234467oiv.280.1663746241015;
        Wed, 21 Sep 2022 00:44:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7qONZ88pXEclF6rWHrCx6zwa1UB2BpZ/Kart+KFBy/YxtaT63ZnO00Ywv2ymwreiaf+VxnSFQCuGq04KCBrEo=
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id
 y4-20020a056808130400b00350649bf8a1mr3234455oiv.280.1663746240793; Wed, 21
 Sep 2022 00:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-3-lingshan.zhu@intel.com> <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
 <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com> <CACGkMEuusM3EMmWW6+q8V1fZscfjM2R9n7jGefUnSY59UnZDYQ@mail.gmail.com>
 <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
In-Reply-To: <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Sep 2022 15:43:49 +0800
Message-ID: <CACGkMEuXA6Uj7OHqUDux=Yz+XFtouKWGOVV4fk5B5XCZW5F22w@mail.gmail.com>
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is set
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 1:39 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 9/21/2022 10:14 AM, Jason Wang wrote:
> > On Tue, Sep 20, 2022 at 1:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >>
> >> On 9/20/2022 10:16 AM, Jason Wang wrote:
> >>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>>> vdpa_dev_net_config_fill() should only report driver features
> >>>> to userspace after features negotiation is done.
> >>>>
> >>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>>> ---
> >>>>    drivers/vdpa/vdpa.c | 13 +++++++++----
> >>>>    1 file changed, 9 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >>>> index 798a02c7aa94..29d7e8858e6f 100644
> >>>> --- a/drivers/vdpa/vdpa.c
> >>>> +++ b/drivers/vdpa/vdpa.c
> >>>> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>>>           struct virtio_net_config config = {};
> >>>>           u64 features_device, features_driver;
> >>>>           u16 val_u16;
> >>>> +       u8 status;
> >>>>
> >>>>           vdev->config->get_config(vdev, 0, &config, sizeof(config));
> >>>>
> >>>> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>>>                   return -EMSGSIZE;
> >>>>
> >>>> -       features_driver = vdev->config->get_driver_features(vdev);
> >>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >>>> -                             VDPA_ATTR_PAD))
> >>>> -               return -EMSGSIZE;
> >>>> +       /* only read driver features after the feature negotiation is done */
> >>>> +       status = vdev->config->get_status(vdev);
> >>>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> >>> Any reason this is not checked in its caller as what it used to do before?
> >> will check the existence of vdev->config->get_status before calling it in V2
> > Just to clarify, I meant to check FEAUTRES_OK in the caller -
> > vdpa_dev_config_fill() otherwise each type needs to repeat this in
> > their specific codes.
> if we check FEATURES_OK in the caller vdpa_dev_config_fill(), then
> !FEATURES_OK will block reporting all attributions, for example
> the device features and virtio device config space fields in this series
> and device status.
> Currently only driver features needs to check FEATURES_OK.
> Or did I missed anything?

I don't see much difference, we just move the following part to the
caller, it is not the config but the VDPA_ATTR_DEV_NEGOTIATED_FEATURES
is blocked.

Thanks

>
> Thanks
> >
> > Thanks
> >
> >> Thanks,
> >> Zhu Lingshan
> >>> Thanks
> >>>
> >>>> +               features_driver = vdev->config->get_driver_features(vdev);
> >>>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >>>> +                                     VDPA_ATTR_PAD))
> >>>> +                       return -EMSGSIZE;
> >>>> +       }
> >>>>
> >>>>           features_device = vdev->config->get_device_features(vdev);
> >>>>
> >>>> --
> >>>> 2.31.1
> >>>>
>

