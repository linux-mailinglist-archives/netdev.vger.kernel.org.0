Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B684D9AA0
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348022AbiCOLus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiCOLur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4682828E2D
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647344974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PterqoyvBh+msSA0i+V9VnnV0+IT1msM0OrO0D3B12Q=;
        b=MvH+of0RrqKqufDLcv/t9OLZEBi1wmrr1uMoDyBap4k0k191QGzParmsQmbxLZyO9Y8qeY
        8P6GmjL9b6wxkK+b128XMunsS9rgecO6/BoofOff3lgoSNrGWmn2BTKNN/TR2pmU5hQnQu
        rZc4tW7Q/enQk9xyeJQ3N0O+JWPrbyU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-_bnuXO0GPYyED-LdAGB9Gg-1; Tue, 15 Mar 2022 07:49:33 -0400
X-MC-Unique: _bnuXO0GPYyED-LdAGB9Gg-1
Received: by mail-qv1-f70.google.com with SMTP id j6-20020a056214032600b004358f15c51bso16343763qvu.1
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PterqoyvBh+msSA0i+V9VnnV0+IT1msM0OrO0D3B12Q=;
        b=zoRBqQtXpndOMTSD4X6J5AmCKe+QLs2huX6p7+M3E2qKr8U+0Q5LSEvIU9gpZXRHZr
         id77uqFzL8J1P6xysvqKC7/v6vaKlzA/PzJzurXo5IfH2Z0QMndmHn6vxRmhnMwFrnOP
         OuEGUCIV20NWLSTuvQUxYe0aK9kzgCOT3NuFNeJzoL6cmQ2O8uorkogKzVpohu908TLB
         UDku0VBWz87SngV7G6n9oVV4JpZMYIYarb+uGr4n9l0IyBEEeNZyJXVEzttbJhm0yecs
         F66nXF6a6JiYMgdMP5f/JW8kNAGpdvQPyOZwVwpWLX2fJphMOKT3eBGIrtFl60+oi1kR
         +Ssw==
X-Gm-Message-State: AOAM5324iSTKRhNUPUhoXR8+H9Z9udL0XR9iVZ7bm6JaW70S3obEjGvy
        VkepJ8qsJZn0CnwIRMmLoskVvV5Lr13hmHnCt8hGrDxTQUr1NCRNYP83Tsmh9J7LI7vHraGDqy2
        MMsITDO4yJmtDb1w8
X-Received: by 2002:a05:620a:284d:b0:5ff:320d:c0a5 with SMTP id h13-20020a05620a284d00b005ff320dc0a5mr17984062qkp.681.1647344972639;
        Tue, 15 Mar 2022 04:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlVn8tnyxlBYGoPjGDSTQP/ITXgasxjqs34flNZkJRFrJ4Au6tkURG5Do6GTqcbi4TFZ7ZTQ==
X-Received: by 2002:a05:620a:284d:b0:5ff:320d:c0a5 with SMTP id h13-20020a05620a284d00b005ff320dc0a5mr17984052qkp.681.1647344972385;
        Tue, 15 Mar 2022 04:49:32 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id s12-20020a05622a018c00b002e1cd88645dsm5305032qtw.74.2022.03.15.04.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 04:49:31 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:49:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 3/3] af_vsock: SOCK_SEQPACKET broken buffer test
Message-ID: <20220315114924.er65xwzw6mg3zp6t@sgarzare-redhat>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
 <bc309cf9-5bcf-b645-577f-8e5b0cf6f220@sberdevices.ru>
 <20220315083617.n33naazzf3se4ozo@sgarzare-redhat>
 <b452aeac-9628-5e37-e0e6-d33f8bb47b22@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b452aeac-9628-5e37-e0e6-d33f8bb47b22@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 09:34:35AM +0000, Krasnov Arseniy Vladimirovich 
wrote:
>On 15.03.2022 11:36, Stefano Garzarella wrote:
>>
>> Is this the right behavior? If read() fails because the buffer is invalid, do we throw out the whole packet?
>>
>> I was expecting the packet not to be consumed, have you tried AF_UNIX, does it have the same behavior?
>
>I've just checked AF_UNIX implementation of SEQPACKET receive in net/unix/af_unix.c. So, if 'skb_copy_datagram_msg()'
>fails, it calls 'skb_free_datagram()'. I think this means that whole sk buff will be dropped, but anyway, i'll check
>this behaviour in practice. See '__unix_dgram_recvmsg()' in net/unix/af_unix.c.
>

Yep. you are right it seems to be discarded but I don't know that
code very well, so better to test as you said ;-)

Thanks,
Stefano

