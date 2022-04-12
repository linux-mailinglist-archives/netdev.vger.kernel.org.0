Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC5C4FD893
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbiDLIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 04:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376378AbiDLHn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 03:43:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1A914616C
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649748499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iF6/C1RHwf7CTYQOQSnv8azPGC+3cM41Uv4y73pmXAM=;
        b=Tmevb8X/88SfFPaIY/6VxLTKIYkMpb+1K6HqBw1b3oceNH9BkJ2XxQETbdnNQTCAAhrJyO
        WERd3xEmlSGi/Wwgw6ctnx2MlpEocP/DTvmEmWrjOPdNYzhoJWRxikF90owCGH6mUAPc0v
        24YplLFyMfdMZJRebVgtiu1fhzi4y8I=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-ztpDeWvRMV6Kdc8pVYKaug-1; Tue, 12 Apr 2022 03:28:17 -0400
X-MC-Unique: ztpDeWvRMV6Kdc8pVYKaug-1
Received: by mail-qt1-f200.google.com with SMTP id m20-20020a05622a119400b002ef68184e7fso2366495qtk.15
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iF6/C1RHwf7CTYQOQSnv8azPGC+3cM41Uv4y73pmXAM=;
        b=alwgyHQftuRCt2NkeX9NtoyqjuK6hKLTnTgLzLrH6O3aelWgbP4AQXWYOKPBrZvWeI
         4U+KNDNjk4smeyWRXhKEykRQVk1WHtU3zjcTiPiMNX54tvbOxV2brMX+V+DDxhE/ulnB
         1EcrPku3vvk74PVZ3wZp/5cHIaGc8oKlGBOFSCVLv4oAgccPAfOlW+BF8ESUlOxG17hq
         CPfqnvokm99H9JqyQ19anGQchEHImeRZ9y5M8P5AXIw6iT2dl4uSYHkhwJR2vXDrl3Mt
         nyub5b1/QJhb+hT/ukTkwhx0RQxUE9QQKcJ8eaAH4WI+OXUW1YRakVlABofYv48E9xaC
         yKSg==
X-Gm-Message-State: AOAM530g27wkh+7uiSbuNY+9lXhqXhQD7R7XzpZyqkMX0NEp2e8FPa0B
        Mb/Gphqggbrl0VJDhgjcD/NmnjrtoopWXiSQzht9mQQtEVMtxcRJQkVPjbIxWwlejswVUKriGm5
        nEuVR0LXcUywVlfeb
X-Received: by 2002:ad4:5d49:0:b0:444:4dda:9ac1 with SMTP id jk9-20020ad45d49000000b004444dda9ac1mr2488107qvb.108.1649748497394;
        Tue, 12 Apr 2022 00:28:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNqcG2gg+lPrhMhfRjya9yf0TWWGeI+RKPCr5T2GmjCviAtvjwECgL4zSXIfBCgARvZwYSzg==
X-Received: by 2002:ad4:5d49:0:b0:444:4dda:9ac1 with SMTP id jk9-20020ad45d49000000b004444dda9ac1mr2488091qvb.108.1649748497150;
        Tue, 12 Apr 2022 00:28:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id y18-20020ac85f52000000b002ed08a7dc8dsm10612638qta.13.2022.04.12.00.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 00:28:16 -0700 (PDT)
Message-ID: <3daec73abc2f21809a8057b6a9729a70d2877231.camel@redhat.com>
Subject: Re: [PATCH V2] drivers: nfc: nfcmrvl: fix double free bug in
 nfcmrvl_nci_unregister_dev()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, krzk@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
Date:   Tue, 12 Apr 2022 09:28:13 +0200
In-Reply-To: <20220410135214.74216-1-duoming@zju.edu.cn>
References: <20220410135214.74216-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-04-10 at 21:52 +0800, Duoming Zhou wrote:
> There is a potential double bug in nfcmrvl usb driver between
> unregister and resume operation.
> 
> The race that cause that double free bug can be shown as below:
> 
>    (FREE)                   |      (USE)
>                             | nfcmrvl_resume
>                             |  nfcmrvl_submit_bulk_urb
>                             |   nfcmrvl_bulk_complete
>                             |    nfcmrvl_nci_recv_frame
>                             |     nfcmrvl_fw_dnld_recv_frame
>                             |      queue_work
>                             |       fw_dnld_rx_work
>                             |        fw_dnld_over
>                             |         release_firmware
>                             |          kfree(fw); //(1)
> nfcmrvl_disconnect          |
>  nfcmrvl_nci_unregister_dev |
>   nfcmrvl_fw_dnld_abort     |
>    fw_dnld_over             |         ...
>     if (priv->fw_dnld.fw)   |
>     release_firmware        |
>      kfree(fw); //(2)       |
>      ...                    |         priv->fw_dnld.fw = NULL;
> 
> When nfcmrvl usb driver is resuming, we detach the device.
> The release_firmware() will deallocate firmware in position (1),
> but firmware will be deallocated again in position (2), which
> leads to double free.
> 
> This patch reorders nfcmrvl_fw_dnld_deinit() before nfcmrvl_fw_dnld_abort()
> in order to prevent double free bug. Because destroy_workqueue() will
> not return until all work items are finished. The priv->fw_dnld.fw will
> be set to NULL after work items are finished and fw_dnld_over() called by
> nfcmrvl_nci_unregister_dev() will check whether priv->fw_dnld.fw is NULL.
> So the double free bug could be prevented.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

This looks like a -net candidates, could you please add a suitable
fixes tag?

Thanks!

Paolo

