Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEB8600778
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJQHN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiJQHNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057B95808B
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665990827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9elsTyKwP2RgI1TXQIsN6pFsi2ab4o+Pn6NCbA8rb7A=;
        b=gMMyAPp3fl1dxHE7Riau+wLOB46f5HYVDVlklX4IeZQq+h6xeu5Po0+wGakpXyZeLRfm4t
        QMMKiztdnvkqON707uJuX5wnttbnbME02MVsZnEDnuInAgmYi8+HaOVbBVt6o9OA7SPRY0
        qP4S2zSpoFQ/LGAL3H4bLmYXvEY1GO8=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-TJHB-S0ROHeS_jZ2OdhnNA-1; Mon, 17 Oct 2022 03:13:45 -0400
X-MC-Unique: TJHB-S0ROHeS_jZ2OdhnNA-1
Received: by mail-oo1-f69.google.com with SMTP id x10-20020a4a394a000000b0048082279db7so4363244oog.7
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9elsTyKwP2RgI1TXQIsN6pFsi2ab4o+Pn6NCbA8rb7A=;
        b=5Y3429tJZdY7yVzNAnIwVhrgSSsFFtdaZQLRfC75c5Hrz63feRVzk2c5GtDapcD6fK
         DmLwRT3FTfQubrgCJ5bBy9wYzPCllAnqLuHprSp3fEk+cMznLkdqwVVgqJtJ4LIIw98b
         ZSxVer6H2wukrOINAcJTtU53aelO2Y26RCan4AMHPm5t92hGjPEe+J1njq4ZZpaAwtMS
         ICfeGnPXPLFkvlt5qb4B8Ks9ylbLO5i5U7m25TuPQgVnJuq5TsajHndStyr5G1ODFvQq
         W9vbPSKZCN+iXckbfAGNZ2PBuekwPhKIrzZPIC36PSgz6HuhG5y2j5IqKXpn7mws+aRL
         GCYw==
X-Gm-Message-State: ACrzQf0Rt4ng//yStxP10on1gtVb2x2hVJX/iQLOpITOEhrVyVyFbe1p
        FrTywlQVxG9iJyoBBZZrGCdyGShSNwLPRc1/vmCC+JvYKxg8AgBx+uN7Vu0/vChqWmoi7tMm0Qx
        OmIQ4dqG7pCCQf452yEA93Is76dxy0dDz
X-Received: by 2002:a05:6808:1483:b0:354:a36e:5b with SMTP id e3-20020a056808148300b00354a36e005bmr12274494oiw.35.1665990824610;
        Mon, 17 Oct 2022 00:13:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM60hrzvtei5NX1fBq/Q7EKckUGENj2+K9sAAsE2eiHNSIL6NO8XivmV3Yu0VxbFkzqlO4sJmTjNfyTsppEQKaM=
X-Received: by 2002:a05:6808:1483:b0:354:a36e:5b with SMTP id
 e3-20020a056808148300b00354a36e005bmr12274482oiw.35.1665990824429; Mon, 17
 Oct 2022 00:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221014094152.5570-1-lingshan.zhu@intel.com> <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
In-Reply-To: <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 17 Oct 2022 15:13:33 +0800
Message-ID: <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com>
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >
> > This commit implements support for reading vdpa device
> > features in iproute2.
> >
> > Example:
> > $ vdpa dev config show vdpa0
> > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
> >   negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
> >   dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
> >
> > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
> Note that Si Wei proposed to unify the two new attributes:

https://patchew.org/linux/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/

Thanks

>
>
> > ---
> >  vdpa/vdpa.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index b73e40b4..89844e92 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >         [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >         [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> >         [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> > +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
> > +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >  };
> >
> >  static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
> >
> >  #define NUM_FEATURE_BITS 64
> >
> > -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> > +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
> >                            uint16_t dev_id)
> >  {
> >         const char * const *feature_strs = NULL;
> > @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >         if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> >                 feature_strs = dev_to_feature_str[dev_id];
> >
> > -       if (mgmtdevf)
> > +       if (devf)
> >                 pr_out_array_start(vdpa, "dev_features");
> >         else
> >                 pr_out_array_start(vdpa, "negotiated_features");
> > @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >                 val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> >                 print_features(vdpa, val_u64, false, dev_id);
> >         }
> > +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
> > +               uint16_t dev_id = 0;
> > +
> > +               if (tb[VDPA_ATTR_DEV_ID])
> > +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> > +
> > +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
> > +               print_features(vdpa, val_u64, true, dev_id);
> > +       }
> >  }
> >
> >  static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> > --
> > 2.31.1
> >

