Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB74BE9DD
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381234AbiBUQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:48:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiBUQst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:48:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 634E6237CC
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645462104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ugkg/6bHK4I9I6rQyjp9bnBEEpgwBXrQHXcejLYuUBI=;
        b=TFcrL5PjpcpYhTGWBpFtiw5ExZuMT4fePd7GaXEd3NkeOuuDgM17Q33P+AoIeshnBDVqBI
        /VGt1ZB6msQHQszN8aMwE1gJjK3w5yGc8npZ0KSnpFaEUiY6gHCAox2+6YK7EZRoFbSDfO
        RnwZYEcSKZpZJw3rGb6IvrkM+vT42lA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-rjglFpyUObOzkJ-UkyRpvw-1; Mon, 21 Feb 2022 11:48:23 -0500
X-MC-Unique: rjglFpyUObOzkJ-UkyRpvw-1
Received: by mail-qv1-f69.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so17803619qvd.2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:48:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ugkg/6bHK4I9I6rQyjp9bnBEEpgwBXrQHXcejLYuUBI=;
        b=tuNRXQ6E8FWg7WDiSgZbNIYz2E+CUXCoyUWJ+eNzYbztqLZyMN05SZDCk8GoKmLN2z
         aROJ7+pqYEiDxP3gdj/gbcP+wwxqP9DrTmznzCDYEItSV4vdNAA/dpwIjBv2kMefj2RD
         720wLdkNYVUV3xnnrai/gYnhx3/xsMyfchvqOkguIpubA1CXHtcqhPZ5AeoqkQYZN2oF
         iOyNjXRxBCqyX36B75mDwbnvgvcNPxnl9u1cre4RIrIiAR8wdx1RL6Dtr1hB+Rk3Z92B
         By3Z0YP7+GzHqwxepEks5ZcilP8TCXN2tSh6lBsBNyM+dV4PxawJuch/ryVPySxNeeCG
         mc9A==
X-Gm-Message-State: AOAM532i3DZk9vXF+G3mQkk44gAmZvR0of8eZeHPGySr9ChMoyDhp3sU
        7QagKrJZ2qtEHzNCZLErUPrHLrg0Dy4Wr4bxvsypCIGhbsy+hDWloLUvvIZYy3oOe/nRAxbV/U6
        CDPS8GpMK9Dsy0bEd
X-Received: by 2002:ac8:5e48:0:b0:2dd:aae2:9163 with SMTP id i8-20020ac85e48000000b002ddaae29163mr13786993qtx.95.1645462102876;
        Mon, 21 Feb 2022 08:48:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFv1gdovuCvIHcpiRkTUusMpouueO/kTbQ3gip4zmAzUzlcfKIHRaFuNGZVTP437Hqjr+tcA==
X-Received: by 2002:ac8:5e48:0:b0:2dd:aae2:9163 with SMTP id i8-20020ac85e48000000b002ddaae29163mr13786978qtx.95.1645462102586;
        Mon, 21 Feb 2022 08:48:22 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id e3sm7388100qto.25.2022.02.21.08.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 08:48:21 -0800 (PST)
Date:   Mon, 21 Feb 2022 17:48:17 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: handle zero regions in vhost_set_memory
Message-ID: <20220221164817.obpw477w74auxlkn@sgarzare-redhat>
References: <20220221072852.31820-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220221072852.31820-1-mail@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 12:58:51PM +0530, Anirudh Rayabharam wrote:
>Return early when userspace sends zero regions in the VHOST_SET_MEM_TABLE
>ioctl.
>
>Otherwise, this causes an erroneous entry to be added to the iotlb. This
>entry has a range size of 0 (due to u64 overflow). This then causes
>iotlb_access_ok() to loop indefinitely resulting in a hung thread.
>Syzbot has reported this here:
>
>https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

IIUC vhost_iotlb_add_range() in the for loop is never called if 
mem.nregions is 0, so I'm not sure the problem reported by syzbot is 
related.

In any case maybe this patch is fine, but currently I think we're just 
registering an iotlb without any regions, which in theory shouldn't 
cause any problems.

Thanks,
Stefano

>
>Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
>Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
>---
> drivers/vhost/vhost.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index 59edb5a1ffe2..821aba60eac2 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -1428,6 +1428,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> 		return -EFAULT;
> 	if (mem.padding)
> 		return -EOPNOTSUPP;
>+	if (mem.nregions == 0)
>+		return 0;
> 	if (mem.nregions > max_mem_regions)
> 		return -E2BIG;
> 	newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
>-- 
>2.35.1
>

