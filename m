Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97836BDFB5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCQDjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQDjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD333A877
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679024299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFVsLqk+r1ZOPzZI3ydTPicHIm2HZPqwfTT7+IgUJZ8=;
        b=cmQxAqBRIlMxZEw5HOyaN1uV0Tq35/NBHGXlLmy5iGX4pmsjMNXUN/ifYwSHhIQSW/ZkWE
        xM9Aw5Z5Hk+7ER4/yjEe4XmcIDJvOhvs+WyGrHnB8ie0kEZHXD/+hz8sbLZWlGflV6MptF
        mHKClL+1p7uwRAyFwmm+CNLgXfVOTB0=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-q0sCF4OQMBCePvYMK0BSCg-1; Thu, 16 Mar 2023 23:37:32 -0400
X-MC-Unique: q0sCF4OQMBCePvYMK0BSCg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-172ace24d4dso2244584fac.18
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679024252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UFVsLqk+r1ZOPzZI3ydTPicHIm2HZPqwfTT7+IgUJZ8=;
        b=bPswXoi8rLr0pRCHxp4bffZKFFrQJKHE3mfbAJKMgN4CsfZnk5iwVVnSme55U1hwL0
         gXZnFVtyezFrstUfMFBfE6/IIZAc8JMHzw90yd0fR96jJhhbZuJxVWy2ZOHqR6lrpZeV
         kIsqA0mAyWFaxSENaebRJbEz3/rUDW+nhxtxlKRsDsRrYet/pZAaXEsDVIKaVgGgYIuK
         D/TXDI+ZJmiLKPYwLTxxnxl4TAONyFILnusDWzVOH9jnOAvcys/Hyankls1DCalXMDjK
         MuJlSeRVSsrmfERPqNF3MoiiH8/cj+/Nlae7lcx37W/kqgfoO+Ei6EHeYZ033trYq6Ej
         n40Q==
X-Gm-Message-State: AO0yUKW02NJLSTX/Vy7TkiEZf3zNFnRjRED6Kp/QNE82ef0bGXFGGyQQ
        lQWiuL8ARWqmo5gbD+sUsM5Y5YO2aSoU8JZ3e0E8uj6Jfa/BrDxByz7oyIeJCjKkKRwvaNzjIRn
        M7g+7yKdQGvqNdo1DIA/Ph5Znw3pQigjM
X-Received: by 2002:a54:4481:0:b0:384:c4a:1b49 with SMTP id v1-20020a544481000000b003840c4a1b49mr2529113oiv.9.1679024251928;
        Thu, 16 Mar 2023 20:37:31 -0700 (PDT)
X-Google-Smtp-Source: AK7set/gDvTy3qEnd0t9C0+ygLrhOCbBGSbZavev4c65WFF89C8eZYwKpwwVJnu0eV7eOlDLHKc/783vwv9c3TKTqDg=
X-Received: by 2002:a54:4481:0:b0:384:c4a:1b49 with SMTP id
 v1-20020a544481000000b003840c4a1b49mr2529105oiv.9.1679024251767; Thu, 16 Mar
 2023 20:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-4-shannon.nelson@amd.com> <CACGkMEt5Jbsp=+st8aG_0kXD+OSSp+FX9vYE+gTkywp2ZN4LTw@mail.gmail.com>
 <ee3dd0c5-5e44-634d-7ab7-7a4c9c1cd4f7@amd.com>
In-Reply-To: <ee3dd0c5-5e44-634d-7ab7-7a4c9c1cd4f7@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Mar 2023 11:37:20 +0800
Message-ID: <CACGkMEsK0YknKS8CWkToJSo3_jY837zyQsaFjOE8h7jOdWMASQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 3/7] pds_vdpa: virtio bar setup for vdpa
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:25=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> On 3/15/23 12:05 AM, Jason Wang wrote:
> > On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@a=
md.com> wrote:
> >>
> >> The PDS vDPA device has a virtio BAR for describing itself, and
> >> the pds_vdpa driver needs to access it.  Here we copy liberally
> >> from the existing drivers/virtio/virtio_pci_modern_dev.c as it
> >> has what we need, but we need to modify it so that it can work
> >> with our device id and so we can use our own DMA mask.
> >
> > By passing a pointer to a customized id probing routine to vp_modern_pr=
obe()?
>
> The only real differences are that we needed to cut out the device id
> checks to use our vDPA VF device id, and remove
> dma_set_mask_and_coherent() because we need a different DMA_BIT_MASK().
>
> Maybe a function pointer to something that can validate the device id,
> and a bitmask for setting DMA mapping; if they are 0/NULL, use the
> default device id check and DMA mask.
>
> Adding them as extra arguments to the function call seems a bit messy,
> maybe add them to the struct virtio_pci_modern_device and the caller can
> set them as overrides if needed?
>
> struct virtio_pci_modern_device {
>
>         ...
>
>         int (*device_id_check_override(struct pci_dev *pdev));
>         u64 dma_mask_override;
> }

Looks fine.

Thanks

