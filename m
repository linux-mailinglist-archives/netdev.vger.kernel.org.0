Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AABD6D184A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCaHQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCaHP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:15:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AF91B7CE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680246909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KWMFK/padud2qL2Yu5nuVXmsRK2hLBvg6h75c5M7KFw=;
        b=ce5FqbD973OR0uuL9me7U+UlE7kjD9jWV0CFfgp99sQd2jvtcqvTNNrCYmbnWJ0t8TUHJ3
        xmrBvRGEvO13hjF7wIiWYpoRdcHLcSI/hpm21HSENmuhBZ30in5dEejTCaSgW0OM1bRRl6
        77lkcXdlS07F/lmygAW7Z8TMiXzjWeU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-O9WciOzYOd6S6oa108CwOQ-1; Fri, 31 Mar 2023 03:15:07 -0400
X-MC-Unique: O9WciOzYOd6S6oa108CwOQ-1
Received: by mail-ed1-f69.google.com with SMTP id m18-20020a50d7d2000000b00501dfd867a4so30773905edj.20
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWMFK/padud2qL2Yu5nuVXmsRK2hLBvg6h75c5M7KFw=;
        b=4ZPiRQkXW57Ukpi9bAIBptOnB/I6zceZ4c5m7/CcVexbtzv88pbN5SINt/di5qBjf8
         CZyZNSuTdaBaXI7pMRRsr1qVILyyYpAWhvGYsabbXyWu8rYIUItM+eqVQf183B61s1yH
         ctOFevEIK1i8LgREJ++9fjM2Jjxzz+h12Ck65rgt8L/MQR0jI8WyN5gLOzIx6XL3S2Y2
         W0KHudZPrNZVpmsf7+JtcGcV43mV9OKyZi1H/dEc4jP6sXFbIvb/9zzIcuoLQzTdPJn9
         CWsP08bOLJpe79r9xkWJiBukx8pqB1+Y3QypP+YfpO23WtPbFctr6vmQSufn6AOxvf9L
         A73A==
X-Gm-Message-State: AAQBX9eDA0uOW7jxFmhyMvWAUgvQJ4BV2EqQDREgLq5OD0aOcJl1ouyD
        HibUAHntELM/jUbnVq2zDLdarHvAMGmV/90zT+WQEFKiU2KTyjlyeS6aHxQsWHund41iij5HF5j
        srK3iIn5XmvyGlZig
X-Received: by 2002:a17:907:6d83:b0:947:6ce9:705d with SMTP id sb3-20020a1709076d8300b009476ce9705dmr5436209ejc.55.1680246906171;
        Fri, 31 Mar 2023 00:15:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350aZwogAdOwSVJvzr6Pjwq+TBHVkVowx29697Nam/rYpQ8g3Ha6PzoB/NgF8lkggQuyLgeScSw==
X-Received: by 2002:a17:907:6d83:b0:947:6ce9:705d with SMTP id sb3-20020a1709076d8300b009476ce9705dmr5436179ejc.55.1680246905861;
        Fri, 31 Mar 2023 00:15:05 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id v13-20020a170906b00d00b009373f1b5c4esm649065ejy.161.2023.03.31.00.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 00:15:05 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:15:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v3 1/4] vsock/vmci: convert VMCI error code to
 -ENOMEM on send
Message-ID: <rrapkoibcd6p33pmai2egr6isphvbx7rlu6hfj74gsmuih5p2o@kdilyljzs5bm>
References: <dead4842-333a-015e-028b-302151336ff9@sberdevices.ru>
 <a0915a9d-ba41-5a90-0e16-40c2315f0445@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a0915a9d-ba41-5a90-0e16-40c2315f0445@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:12:44PM +0300, Arseniy Krasnov wrote:
>This adds conversion of VMCI specific error code to general -ENOMEM. It
>is needed, because af_vsock.c passes error value returned from transport
>to the user, which does not expect to get VMCI_ERROR_* values.
>
>Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/vmci_transport.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)

The patch LGTM, but I suggest to extract this patch from the series and
send it directly to the net tree, while other patches can be sent to
net-next.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

