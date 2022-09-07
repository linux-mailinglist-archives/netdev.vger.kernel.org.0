Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D35AFEAB
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiIGINu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiIGINs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:13:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF5AA350
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 01:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662538425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jGCBXs/LiZV7m+4iWwK0A0ed0uGkgznMIVJgxIo+Gcw=;
        b=C6OpBLJGh6qKlE4hFiayxc3IryfQijyMtbcB0BO7QI5IyXvvpsBFXe8oD2+CWn3BoKyqHW
        Ao4JTTRbnYXHtxUJHxF1I8Rq3ejnGb0LbgWViq3WqAGaxN9DCirmEGGryJvd3CN4samBAD
        7vCQ9RIxWHisCDfY+bna8BGlSJZ7EGQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-F7eglEinNqSy7dJKIhalRA-1; Wed, 07 Sep 2022 04:13:44 -0400
X-MC-Unique: F7eglEinNqSy7dJKIhalRA-1
Received: by mail-qt1-f197.google.com with SMTP id cj19-20020a05622a259300b003446920ea91so11196473qtb.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 01:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jGCBXs/LiZV7m+4iWwK0A0ed0uGkgznMIVJgxIo+Gcw=;
        b=0R6Z9JcUiI/56q3m6hG4sACptN5uhoecOpCjQoZZt2fAtYTR4wJQOR2gGyo/ARmi4l
         oZ7YTlUYx9ZP28Fq7l6S3XM9Nqu+XzGZjxcnyyf4wxKPBMvHkJDmDabVZqAharX2CSlM
         IjcRd8HpM6MPyXlFI11fUCLKk0m39DVMjlfkaZ7DKg3oJUq4WsnYgjE5U228UoU8w3Dq
         9ZVnokQIjEx7YkvwLsG6/CjzWF6PuszGGEfQL+do6fRcuXVD0FZLleYoesyYRn9VqKwf
         pJPmGol8fiiBNNjc1khz3qGxbDh1UbszvtAle3UOcRSQHszyfzLc8L90U+PB0CVvy4tV
         QTaQ==
X-Gm-Message-State: ACgBeo3D+bD7Kdm38QiyiaGMZSYZaGRgQsj6ZsqJsWpABG6wcOQGgtZI
        Dm22UIPPU/PoEmHFrYqidJ+a6YNkD9WQx5eZOi0WPqOWzZ+OP04GgFTxIiQ6BXGmO80KTHfTmSG
        CpqYQ+FeJW8vyGjB1
X-Received: by 2002:a05:622a:103:b0:343:3ce4:c383 with SMTP id u3-20020a05622a010300b003433ce4c383mr2147910qtw.388.1662538424190;
        Wed, 07 Sep 2022 01:13:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4M+BpK0S3drKVwl3E/AGnsS1H35ouLbhYkpwM8Wr1TNLAJDN5peZCbYmUDdaNP/jFdyZTRnQ==
X-Received: by 2002:a05:622a:103:b0:343:3ce4:c383 with SMTP id u3-20020a05622a010300b003433ce4c383mr2147902qtw.388.1662538423966;
        Wed, 07 Sep 2022 01:13:43 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id f20-20020ac84994000000b0031eebfcb369sm11206617qtq.97.2022.09.07.01.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 01:13:23 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:12:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock/vmci: fix repeated words in comments
Message-ID: <20220907081256.wlua35p72s6azgqr@sgarzare-redhat>
References: <20220907040131.52975-1-yuanjilin@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220907040131.52975-1-yuanjilin@cdjrlc.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 12:01:31PM +0800, Jilin Yuan wrote:
>Delete the redundant word 'that'.
>
>Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
>---
> net/vmw_vsock/vmci_transport.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index b14f0ed7427b..842c94286d31 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -951,7 +951,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
> 	 * for ourself or any previous connection requests that we received.
> 	 * If it's the latter, we try to find a socket in our list of pending
> 	 * connections and, if we do, call the appropriate handler for the
>-	 * state that that socket is in.  Otherwise we try to service the
>+	 * state that socket is in.  Otherwise we try to service the
> 	 * connection request.
> 	 */
> 	pending = vmci_transport_get_pending(sk, pkt);
>-- 
>2.36.1
>
>

