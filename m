Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A8B4DC0AD
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiCQILK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiCQILG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:11:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB2CF38BA
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647504588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bnLdr4HwqrI6g2eVldupmYABxQ1B7HkrLHxzrYkWZNY=;
        b=R52wsbPEc66AQ5tRKrAUD/+lw7I6L/vZfKwMKvasI0DRT8Gux66nZuFKonbVyIzbLhDz7w
        zEDhEs6MG4iDIvvjniWtb4m3rpVvl53Ihl6L+/Ro3ZS9+Bq2GrgDx7XND1mD0amNt97Hx9
        zQxXIoc2sHYWBEPy3P49uKYTJl4Dodg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-_9DG582vPL2kxz1fTkSqzw-1; Thu, 17 Mar 2022 04:09:45 -0400
X-MC-Unique: _9DG582vPL2kxz1fTkSqzw-1
Received: by mail-qt1-f198.google.com with SMTP id o15-20020ac8698f000000b002e1db0c88d0so3011464qtq.17
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bnLdr4HwqrI6g2eVldupmYABxQ1B7HkrLHxzrYkWZNY=;
        b=VdqkwcU5Q6nPtE9CMD4s05S+Tu2HqYJw8tMam+D7wHpr0lRFxkUIJCRat6kAMl5z2O
         1CRSNjj26CLq+DRBWSmDND/LNmMEtsVjvW983RSJwEKYj7uhLFl7omHLy8OBKJIzQ+MA
         EFYk8+bmaqu+mGYifoCYDa8vT6e1xoRre6I3QfN7mWQ0329TtrAM8gBJnGcWtOEPMIXK
         jfwS8wzX+QR+BDWor8g5P2gCP0fcq4OWq8cYMVxqGMSvjeTVBp8uk1B+bBUn/UHrIdk6
         rStgHPtetRfoPW2wHYt/BrYPME0/o6ZIg21Ikl7VrlFb0DCG0UBA9xcfgivq+1zNR0SO
         Y9oA==
X-Gm-Message-State: AOAM531lNG8K/kMbSo+IPxdRSp/q6MoM1tj+rhtzAdJWFZVdd1FR2jX8
        TzDiMklb0k1tINM0uzK5sZ2QibXRdtyIq58W+lBKYiMJbpVMQ5bGEewc3RROoc5O52oVZcaQVUX
        Tm54FQac6qpuV1pZt
X-Received: by 2002:ac8:5ccc:0:b0:2e1:b355:5c36 with SMTP id s12-20020ac85ccc000000b002e1b3555c36mr2733606qta.402.1647504584990;
        Thu, 17 Mar 2022 01:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxnAp8LRv0pGr4caYh2PYRswaZ3blc4m+lTKdGlnP5IFQMb25svYg88Zli7hmhO5GnMJsu3Q==
X-Received: by 2002:ac8:5ccc:0:b0:2e1:b355:5c36 with SMTP id s12-20020ac85ccc000000b002e1b3555c36mr2733597qta.402.1647504584792;
        Thu, 17 Mar 2022 01:09:44 -0700 (PDT)
Received: from sgarzare-redhat (host-79-42-202-12.retail.telecomitalia.it. [79.42.202.12])
        by smtp.gmail.com with ESMTPSA id a6-20020ae9e806000000b0067ba5a8a2a7sm2003975qkg.134.2022.03.17.01.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:09:44 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:09:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/2] af_vsock: SOCK_SEQPACKET broken buffer
 test
Message-ID: <20220317080938.pyngcehb3lmags7k@sgarzare-redhat>
References: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
 <c3ce3c67-1bbd-8172-0c98-e0c3cd5a80b6@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c3ce3c67-1bbd-8172-0c98-e0c3cd5a80b6@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 05:28:21AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Add test where sender sends two message, each with own
>data pattern. Reader tries to read first to broken buffer:
>it has three pages size, but middle page is unmapped. Then,
>reader tries to read second message to valid buffer. Test
>checks, that uncopied part of first message was dropped
>and thus not copied as part of second message.
>
>Signed-off-by: Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
>---
> v2 -> v3:
> 1) "got X, expected Y" -> "expected X, got Y".
> 2) Some checkpatch.pl fixes.
>
> tools/testing/vsock/vsock_test.c | 131 +++++++++++++++++++++++++++++++
> 1 file changed, 131 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

