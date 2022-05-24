Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561B453246F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiEXHwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiEXHwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C10B49C80
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653378729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eLiRBJigFuDJflEBL1yIFfpnc5pdYqpynwY7vvoEGYo=;
        b=IE/9BcFiIGagO6t34yXM5AIaMaYECPX95rsyj6l7DHDK1Hg/lEk/EeRzciuTyyfdyIX1ku
        O7qT54jXtuJi4N1rp0TnTJMXYvlXhFci3ZifeQ+Eyb7K63rg+FtQaHzsnuVXNzaCYVkdmM
        iJJD3/9Wx8BJxlQY1G4hpzQ/TF43Tn4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Dnh0Yb7KO1CPSfFBu_7swg-1; Tue, 24 May 2022 03:52:08 -0400
X-MC-Unique: Dnh0Yb7KO1CPSfFBu_7swg-1
Received: by mail-qv1-f71.google.com with SMTP id 13-20020a0562140d4d00b004624a316484so2490469qvr.11
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eLiRBJigFuDJflEBL1yIFfpnc5pdYqpynwY7vvoEGYo=;
        b=WC8eR0oDJfakeefMLT7rbypSErldIkGWJWfnxlfYNVKTePfYJFxgpeaulrJAzAygXQ
         K1rWgoRN+qZtpYBpaPKoRovPErPUPFKs5EHlNtRRL/4+YC5q4tOMBMBNruyXWG+Td0we
         LDPbMd1yKdE+wtomeTI3prCufq+V2lt+0c3hCSl/7AUlPgOujgbxwJWxo62cyjQPfifT
         7a4drkDuRIbzF0abLI1+B7gUNhKG9Vrt8c8vxloZQLsAMJFDiQnAdogTObif72/TU+Jn
         3CEAvfe2sMCoJ5wyLS1A/rs0/brQJYJ2jsqOwF03kdO41j16waOjAyEFtSFMMVz/z6Nh
         xrbg==
X-Gm-Message-State: AOAM532IKk6nKohKteRTjQWZzLKeu0e51Z0fKKZXSayWbKEYGIU+9fwY
        Pl5QJsznOX1srMncxBW47459cRDEvXqyOOTS0wJRAKj9WQXpo1BpkFmdx8VPh/ORSJ1iiCnKRB+
        NsGN1NKfS9xIbiziQ
X-Received: by 2002:a05:622a:216:b0:2f9:30b3:45ee with SMTP id b22-20020a05622a021600b002f930b345eemr9051387qtx.397.1653378728046;
        Tue, 24 May 2022 00:52:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgFlPc9qJ1j1IzDb/M0V3FRtH4WCnJY0MqJ/BAD5tylD1UiTiBef3dxP0vV+Ovsmsho5ZXvA==
X-Received: by 2002:a05:622a:216:b0:2f9:30b3:45ee with SMTP id b22-20020a05622a021600b002f930b345eemr9051362qtx.397.1653378727818;
        Tue, 24 May 2022 00:52:07 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id o62-20020a37a541000000b006a34df5a9a9sm5288177qke.126.2022.05.24.00.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:52:07 -0700 (PDT)
Date:   Tue, 24 May 2022 09:51:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Message-ID: <20220524075158.2vyuw7ga72xub7pp@sgarzare-redhat>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
 <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
 <20220524070900.ak7a5frwtezjhhrq@sgarzare-redhat>
 <CAJaqyWeiNWnWUzEUEo8HeuuF8XMPtKw9SapxLxLJECWJ0zNTUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWeiNWnWUzEUEo8HeuuF8XMPtKw9SapxLxLJECWJ0zNTUA@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 09:42:06AM +0200, Eugenio Perez Martin wrote:
>On Tue, May 24, 2022 at 9:09 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Mon, May 23, 2022 at 09:20:14PM +0200, Eugenio Perez Martin wrote:
>> >On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>> >>
>> >>
>> >>
>> >> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>> >> > This operation is optional: It it's not implemented, backend feature bit
>> >> > will not be exposed.
>> >> >
>> >> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>> >> > ---
>> >> >   include/linux/vdpa.h | 6 ++++++
>> >> >   1 file changed, 6 insertions(+)
>> >> >
>> >> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> >> > index 15af802d41c4..ddfebc4e1e01 100644
>> >> > --- a/include/linux/vdpa.h
>> >> > +++ b/include/linux/vdpa.h
>> >> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
>> >> >    * @reset:                  Reset device
>> >> >    *                          @vdev: vdpa device
>> >> >    *                          Returns integer: success (0) or error (< 0)
>> >> > + * @stop:                    Stop or resume the device (optional, but it must
>> >> > + *                           be implemented if require device stop)
>> >> > + *                           @vdev: vdpa device
>> >> > + *                           @stop: stop (true), not stop (false)
>> >> > + *                           Returns integer: success (0) or error (< 0)
>> >> Is this uAPI meant to address all use cases described in the full blown
>> >> _F_STOP virtio spec proposal, such as:
>> >>
>> >> --------------%<--------------
>> >>
>> >> ...... the device MUST finish any in flight
>> >> operations after the driver writes STOP.  Depending on the device, it
>> >> can do it
>> >> in many ways as long as the driver can recover its normal operation
>> >> if it
>> >> resumes the device without the need of resetting it:
>> >>
>> >> - Drain and wait for the completion of all pending requests until a
>> >>    convenient avail descriptor. Ignore any other posterior descriptor.
>> >> - Return a device-specific failure for these descriptors, so the driver
>> >>    can choose to retry or to cancel them.
>> >> - Mark them as done even if they are not, if the kind of device can
>> >>    assume to lose them.
>> >> --------------%<--------------
>> >>
>> >
>> >Right, this is totally underspecified in this series.
>> >
>> >I'll expand on it in the next version, but that text proposed to
>> >virtio-comment was complicated and misleading. I find better to get
>> >the previous version description. Would the next description work?
>> >
>> >```
>> >After the return of ioctl, the device MUST finish any pending operations like
>> >in flight requests. It must also preserve all the necessary state (the
>> >virtqueue vring base plus the possible device specific states) that is required
>> >for restoring in the future.
>>
>> For block devices wait for all in-flight requests could take several
>> time.
>>
>> Could this be a problem if the caller gets stuck on this ioctl?
>>
>> If it could be a problem, maybe we should use an eventfd to signal that
>> the device is successfully stopped.
>>
>
>For that particular problem I'd very much prefer to add directly an
>ioctl to get the inflight descriptors. We know for sure we will need
>them, and it will be cleaner in the long run.

Makes sense!

>
>As I understand the vdpa block simulator, there is no need to return
>the inflight descriptors since all of the requests are processed in a
>synchronous way. So, for this iteration, we could offer the stop
>feature to qemu.

Right, the simulator handles everything synchronously.

>
>Other non-simulated devices would need it. Could it be delayed to
>future development?

Yep, sure, it sounds like you already have a plan, so no problem :-)

Thanks,
Stefano

