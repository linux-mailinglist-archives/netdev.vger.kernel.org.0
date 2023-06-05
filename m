Return-Path: <netdev+bounces-8026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F5D72276D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAEAA1C20BDF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231D21B91B;
	Mon,  5 Jun 2023 13:30:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F436FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:30:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9050AF3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685971844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09h7AR4TuCkDh4zJT0E+2xZhXl8jzj6eU3ZdjKoNbek=;
	b=gmS4diiYn7Pm676p7UuGn+xWBH7IrpP9pEBE/qaXOsQf+V5KZA89Y379YFE0t1vUZt9YMS
	naiPfy5exKaWj+EESF6tEaLXQqpvc7vDj1r/wVjfmgKG5qg3WPcRoncJ59VD0lBNckY2eS
	cJpSC7g31RzM/Gi0fr2gnxrBtFfdt1w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-60SDBZL_Ne6Fcnoiq9Fcmg-1; Mon, 05 Jun 2023 09:30:44 -0400
X-MC-Unique: 60SDBZL_Ne6Fcnoiq9Fcmg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-616731c798dso41641376d6.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685971843; x=1688563843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09h7AR4TuCkDh4zJT0E+2xZhXl8jzj6eU3ZdjKoNbek=;
        b=StqE1I+txk0oENPVt9KTwHfA1xGAESM2m4S39llGmiR8WGhd4FWkYZsFNRI1K61/sT
         wk8GgC0NPoXxFa6D93hLFMqus3KM9MHdstPtfk+I61Tpw24zzIm4UWm+wJcwD7rc2h9J
         S/hUUt9lA4KAPWWwmrFyU3PlmZoRKtHbh1tsuSwC/Mx+llYbM/fVg5jvxq9eBKdFD/dd
         eCLdGuXLXw09sut78osiVGWavi7oCX5oGOqTeBomZmHISZxBtkfNBc/LrnbGRbPbKFe+
         8ByCzSdvDqfcBlT/nn6LEBc5s776nwVBCJ+zLhLw2Jn4rwuxxNpIYXg5S7mpbnzoxu/y
         cR+g==
X-Gm-Message-State: AC+VfDy+bg/KYRdvLroLQ/V6fT4TEN89x49OSywi+5eyDoAwUdnSVk6F
	aC4JLSPBmqLgH9AWEkL4b0XYmOwAb+GXwJVY2qz58oT59RvsKjqhUEyBUDWyiYXkzOZpSxrBOWh
	Ff++oBRUbOGdV2zOdW6B78wsv
X-Received: by 2002:a05:6214:240b:b0:623:9a08:4edd with SMTP id fv11-20020a056214240b00b006239a084eddmr8345314qvb.25.1685971843176;
        Mon, 05 Jun 2023 06:30:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ59eKAQLHTpxMz4/t5AgUGvFz9F83N7jM9XvbTEJ6IWLoINLpCKUzwbDeHXyzeu5z0HI4vP9w==
X-Received: by 2002:a05:6214:240b:b0:623:9a08:4edd with SMTP id fv11-20020a056214240b00b006239a084eddmr8345276qvb.25.1685971842889;
        Mon, 05 Jun 2023 06:30:42 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id ph12-20020a0562144a4c00b0061c83f00767sm4623347qvb.3.2023.06.05.06.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:30:42 -0700 (PDT)
Date: Mon, 5 Jun 2023 15:30:35 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
	Shannon Nelson <shannon.nelson@amd.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230605085840-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
>On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
>> On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
>> > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
>> > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
>> > > don't support packed virtqueue well yet, so let's filter the
>> > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
>> > >
>> > > This way, even if the device supports it, we don't risk it being
>> > > negotiated, then the VMM is unable to set the vring state properly.
>> > >
>> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > ---
>> > >
>> > > Notes:
>> > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>> > >     better PACKED support" series [1] and backported in stable branches.
>> > >
>> > >     We can revert it when we are sure that everything is working with
>> > >     packed virtqueues.
>> > >
>> > >     Thanks,
>> > >     Stefano
>> > >
>> > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> >
>> > I'm a bit lost here. So why am I merging "better PACKED support" then?
>>
>> To really support packed virtqueue with vhost-vdpa, at that point we would
>> also have to revert this patch.
>>
>> I wasn't sure if you wanted to queue the series for this merge window.
>> In that case do you think it is better to send this patch only for stable
>> branches?
>> > Does this patch make them a NOP?
>>
>> Yep, after applying the "better PACKED support" series and being sure 
>> that
>> the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
>> patch.
>>
>> Let me know if you prefer a different approach.
>>
>> I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
>> interprets them the right way, when it does not.
>>
>> Thanks,
>> Stefano
>>
>
>If this fixes a bug can you add Fixes tags to each of them? Then it's ok
>to merge in this window. Probably easier than the elaborate
>mask/unmask dance.

CCing Shannon (the original author of the "better PACKED support"
series).

IIUC Shannon is going to send a v3 of that series to fix the
documentation, so Shannon can you also add the Fixes tags?

Thanks,
Stefano


