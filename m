Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AFB5A097F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiHYHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiHYHJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:09:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E2A7B297
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661411348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QSUsmhrntyYlE4q4EIuSMo8SwjVSMcRRvXJOMV3jSHQ=;
        b=SMb/DdK+Z1WBajyrzwHokey2/KotfaP+Ompkb+HYfPwFWo1hEO71za98995RP5Bx8PKgDQ
        4uKf868m4hqlh6WYqcDW9K2Qh+W5N0fnCcHVVM65usi1UWZuF4kl9doapCPevX+dKYIVhS
        HWt8gcJDkQdBDobookrf4sfask2ZD2w=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-36-wgtUuWP0PbW1sKw4gQhWwg-1; Thu, 25 Aug 2022 03:09:06 -0400
X-MC-Unique: wgtUuWP0PbW1sKw4gQhWwg-1
Received: by mail-pf1-f197.google.com with SMTP id i3-20020aa78b43000000b005320ac5b724so8560535pfd.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QSUsmhrntyYlE4q4EIuSMo8SwjVSMcRRvXJOMV3jSHQ=;
        b=aWuGI7j69uj74eHYxk7uef/4Vlv0pnsBD/7J+lwP+8eDzg23ZoMq7TL7cucyD3Cw9D
         9Gv5UbkqYDb8KFT5yAkEskv95UsYm8sI35VrNGtURV4yaU+SJzl/tJtef8GVrwNOjDwp
         sJCs1tleepEXr/rPTR42Vgq7IdGKwQ1HKDshvlqr9U54gDSVhXITlMGHK8BmtOs6DS0I
         ZueBD6+7dsPQHRebeULdClmD0hInT3u/XHgg3dOti6O2LIEfYv8kCy30ug/QonsS5RpZ
         szhDGoHtazCkPycCKsN/qmgPihTWN9yfZbDF+5nGQNNyUwUEhmCxQLi/n5qK3hK7Zdco
         uoMA==
X-Gm-Message-State: ACgBeo1bhECZPq2HsKJos+s67D79wjdFsp6V7FQb4g1kaa1eXSsyz/KJ
        +DxQ03URfh15GaDnFLUhPcZ4tyWVDWFeljRNEhqiHgFao+QwUKIQyH5rShUmC6hD1ApsrxUNMmz
        Wm3AAiKutaySgqxwQ
X-Received: by 2002:a17:902:eac3:b0:172:ff31:bb3c with SMTP id p3-20020a170902eac300b00172ff31bb3cmr2446549pld.48.1661411345718;
        Thu, 25 Aug 2022 00:09:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7OChChMg/kNoqJvKmBhroiYu863PvIINaRSgGceUgxIbVI8dEwE1UrA/8XZGCf2a1ChdudKQ==
X-Received: by 2002:a17:902:eac3:b0:172:ff31:bb3c with SMTP id p3-20020a170902eac300b00172ff31bb3cmr2446532pld.48.1661411345488;
        Thu, 25 Aug 2022 00:09:05 -0700 (PDT)
Received: from [10.72.12.107] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a9-20020a62d409000000b0053645475a6dsm10698425pfh.66.2022.08.25.00.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 00:09:04 -0700 (PDT)
Message-ID: <13f97c76-bc8b-1509-d854-89d0d62138fa@redhat.com>
Date:   Thu, 25 Aug 2022 15:08:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/17 21:57, Guo Zhi 写道:
> Vsock uses buffers in order, and for tx driver doesn't have to
> know the length of the buffer. So we can do a batch for vsock if
> in order negotiated, only write one used ring for a batch of buffers
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vsock.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 368330417bde..b0108009c39a 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -500,6 +500,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>   	int head, pkts = 0, total_len = 0;
>   	unsigned int out, in;
>   	bool added = false;
> +	int last_head = -1;
>   
>   	mutex_lock(&vq->mutex);
>   
> @@ -551,10 +552,16 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>   		else
>   			virtio_transport_free_pkt(pkt);
>   
> -		vhost_add_used(vq, head, 0);
> +		if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER))
> +			vhost_add_used(vq, head, 0);
> +		else
> +			last_head = head;
>   		added = true;
>   	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>   
> +	/* If in order feature negotiaged, we can do a batch to increase performance */
> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && last_head != -1)
> +		vhost_add_used(vq, last_head, 0);


I may miss something but spec said "The device then skips forward in the 
ring according to the size of the batch. ".

I don't see how it is done here.

Thanks


>   no_more_replies:
>   	if (added)
>   		vhost_signal(&vsock->dev, vq);

