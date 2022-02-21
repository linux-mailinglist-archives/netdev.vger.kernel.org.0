Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB204BE8C1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiBUQli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:41:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380767AbiBUQkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:40:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A4B927FC4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645461559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoyoRMJ/nAu1Wuy1hoTYHjBEoixwT5p2+nHN8seM7W0=;
        b=CQ3JbgAEP1RQ01i6zYVJxLZQ+xFYN0JvZgKNiXhiHKXUCud8viqkjL6OPvo3gWiNZ68oeJ
        YR26Qgo6MAtXM3QT9Y8svqdyvYksY1HD6afcyzo/tO8F92wL/qZVQlfnx2VCtQ/QRYzmPA
        s6SgIsxhQG/stPmKD6Bmwi9uZSwHjdA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-AwwWNKkiNd6y8WWR0y_2fg-1; Mon, 21 Feb 2022 11:39:18 -0500
X-MC-Unique: AwwWNKkiNd6y8WWR0y_2fg-1
Received: by mail-qk1-f198.google.com with SMTP id m22-20020a05620a221600b005f180383baeso14847999qkh.15
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SoyoRMJ/nAu1Wuy1hoTYHjBEoixwT5p2+nHN8seM7W0=;
        b=lkix7Wc4+V5rGrMpsgULKzboQoJKq0B8t6Ltx6u5+s/bd9uW1WvAZk+WlPGEpbsDPt
         OKkXDwGmUbSOfiOpwpt6Plj6zILirr6nf1hVEq1ABT7XyBR0W181lCq7TBrERZhM+uV2
         mNxtKppIyNMZiv8yDYt9vZ32Ej8NvsGD17p0WWo+4BooG9u1g6BjIF+u1UrHhQy6hESg
         FIuV0Fg6+QuaKNWFRNNPRhfveV0fNEtBgzsYBQtfYYtRIC4Jeb5TZM9q+HCTs9Rv24H3
         qHZpEctAOKggIkREekYFs2AW8vepSaLbjJrLcw4x9fOR9Jo9s65842Jlbd40x8jA9ITQ
         0fEw==
X-Gm-Message-State: AOAM533Go0KU7kZUsouiS14Sgh73JHossa65OJJiiD0PiDDp13IbU6j1
        EKpsTd5nZZOk6tWrnDmlDV9QwRe6mqCbR3PRa85y6tnDOHBrP3WT41lca9YX0oH3Hcl21gkZ49t
        hu/EqZB+vWRlRuiIC
X-Received: by 2002:a05:6214:19ed:b0:42c:289b:860e with SMTP id q13-20020a05621419ed00b0042c289b860emr15949416qvc.73.1645461557331;
        Mon, 21 Feb 2022 08:39:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9nKNisYnQkAL2AwPf/8jKoIFZMeIDLW9aeCMNDkG4GM65TKhRDd3JisZSgS51F0AT0t1yNg==
X-Received: by 2002:a05:6214:19ed:b0:42c:289b:860e with SMTP id q13-20020a05621419ed00b0042c289b860emr15949399qvc.73.1645461557115;
        Mon, 21 Feb 2022 08:39:17 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id s5sm7471966qtn.35.2022.02.21.08.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 08:39:16 -0800 (PST)
Date:   Mon, 21 Feb 2022 17:39:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
Message-ID: <20220221163909.xfrgt6slp3ksqr2w@sgarzare-redhat>
References: <00000000000057702a05d8532b18@google.com>
 <CAGxU2F4nGWxG0wymrDZzd8Hwhm2=8syuEB3fLMd+t7bbN7qWrQ@mail.gmail.com>
 <YhO1YL0A6OjtXmIy@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YhO1YL0A6OjtXmIy@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 09:23:04PM +0530, Anirudh Rayabharam wrote:
>On Mon, Feb 21, 2022 at 03:12:33PM +0100, Stefano Garzarella wrote:
>> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
>> f71077a4d84b
>>
>> Patch sent upstream:
>> https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarzare@redhat.com/T/#u
>
>I don't see how your patch fixes this issue. It looks unrelated. It is
>surprising that syzbot is happy with it.
>
>I have sent a patch for this issue here:
>https://lore.kernel.org/lkml/20220221072852.31820-1-mail@anirudhrb.com/

It is related because the worker thread is accessing the iotlb that is 
going to be freed, so it could be corrupted/invalid.

Your patch seems right, but simply prevents iotlb from being set for the 
the specific test case, so it remains NULL and iotlb_access_ok() exits 
immediately.

Anyway, currently if nregions is 0 vhost_set_memory() sets an iotlb with 
no regions (the for loop is not executed), so I'm not sure 
iotlb_access_ok() cycles infinitely.

Stefano

