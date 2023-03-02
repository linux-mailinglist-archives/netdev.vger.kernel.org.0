Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C346A7FA1
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCBKHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCBKHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A861E18149
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677751587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXAIi3FZLIk/yQi9mz4FXN1H3EGTGEpaBHWX86aG/j0=;
        b=SqVUvC52rTx2kwbOE0r/ic898iU3WU3hW3DvtGn3Ix5wSnxtlNQRoqdbeIy7TrVhlpzy2w
        9fJLoQYeRQxehRodfkvjexGZQ4sLcPd36NdbZk9gFXIwXfY4ACyUuLa/0w9v21BDDkmKt/
        if+Vb8HSoBENd80HSxBspdnSMisJa20=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-XJf5GGXkPZmIexppaMSf9w-1; Thu, 02 Mar 2023 05:06:26 -0500
X-MC-Unique: XJf5GGXkPZmIexppaMSf9w-1
Received: by mail-wm1-f70.google.com with SMTP id j32-20020a05600c1c2000b003e9bdf02c9fso1036092wms.6
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 02:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677751585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXAIi3FZLIk/yQi9mz4FXN1H3EGTGEpaBHWX86aG/j0=;
        b=mRsRiDbGL00rnZ3W98BZfkWDvY6djgjl1qAZ4d4svStx402l1YfUe5Pg9BpoUs8NYH
         6NK2l9Ehj/OS1hzzVmwwc8HT9oDIpvI0j9A5oSbwCrQWbyjLfNPxKkECzhDc/eSRuxk1
         uI0mMV24iGDF9cZ5mek5XM2Alg4D3kb2CAk+CVQT3mGS0vNbimHLMuQJPnrkxzbEjqHn
         FZSQTj+3mrsl8a/x0fuKnLWEV9zpJPrUrO1b/4VXF/3yTAfbnm2lf3Qn3sFnZ+eQkaTY
         6oFFYvoTf4RM0KMKtei29NTMt007QfALxi9unBHlZwkxOs62F3CCs/wNBDVpAGAJAbfn
         cxFg==
X-Gm-Message-State: AO0yUKUBzW/F4zZgdLPXAytOrLq/ngzCYACMIIB7VcBbQg26gC5rf4NK
        QINhnZtXR9wxduFflvpZVfyFH3ge8z9UAFeQ+M3J0+eFOF8oFD2QoaGMvWhyy6BO3Oq/GKFAi0l
        N5SogJd773xeq5wqz
X-Received: by 2002:a05:600c:170a:b0:3eb:37ce:4c3d with SMTP id c10-20020a05600c170a00b003eb37ce4c3dmr3352985wmn.38.1677751585591;
        Thu, 02 Mar 2023 02:06:25 -0800 (PST)
X-Google-Smtp-Source: AK7set+/xE0Y8UibIuJEFr88ZiU69bExip1GW+fSy6pdjECNlMGo6eFU0GAAnaHnmHflDCn7D3uYEg==
X-Received: by 2002:a05:600c:170a:b0:3eb:37ce:4c3d with SMTP id c10-20020a05600c170a00b003eb37ce4c3dmr3352969wmn.38.1677751585285;
        Thu, 02 Mar 2023 02:06:25 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id w9-20020a05600c474900b003eb5a0873e0sm2571290wmo.39.2023.03.02.02.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 02:06:24 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:06:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, oxffffaa@gmail.com,
        kernel@sberdevices.ru, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: Re: [RFC PATCH v1] vsock: check error queue to set EPOLLERR
Message-ID: <20230302100621.gk45unegjbqjgpxh@sgarzare-redhat>
References: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 08:19:45AM +0300, Arseniy Krasnov wrote:
>EPOLLERR must be set not only when there is error on the socket, but also
>when error queue of it is not empty (may be it contains some control
>messages). Without this patch 'poll()' won't detect data in error queue.

Do you have a reproducer?

>This patch is based on 'tcp_poll()'.

LGTM but we should add a Fixes tag.
It's not clear to me whether the problem depends on when we switched to 
using sk_buff or was pre-existing.

Do you have any idea when we introduced this issue?

Thanks,
Stefano

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 19aea7cba26e..b5e51ef4a74c 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 	poll_wait(file, sk_sleep(sk), wait);
> 	mask = 0;
>
>-	if (sk->sk_err)
>+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
> 		/* Signify that there has been an error on this socket. */
> 		mask |= EPOLLERR;
>
>-- 
>2.25.1
>

