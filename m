Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD14D968B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345720AbiCOIo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346072AbiCOIoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:44:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7737F16
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647333787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ws46Mm4AeMY5ZL6XjAXUl4ERDO6VAVFfSe3QGONNiyc=;
        b=PcIqAYJIYZi7TRxVA3vdf3dfFNqwwozFMsvd+oIB+CuAJQAPcLa+hdvA4jpoavLbelQOmC
        jzVPZalrIf/4y7Ql6Vzx6newUxkpYtZvAOeUwjjEkoAgcVtR4JjLwH3JqTzYs9wyTGbERX
        KlXPbYP9QcNcYrdiseDA6gLA5bgBmDc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-8KUrtCwbPlWQz0s93nEjxw-1; Tue, 15 Mar 2022 04:43:06 -0400
X-MC-Unique: 8KUrtCwbPlWQz0s93nEjxw-1
Received: by mail-qk1-f199.google.com with SMTP id 207-20020a3703d8000000b0067b14f0844dso13736787qkd.22
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ws46Mm4AeMY5ZL6XjAXUl4ERDO6VAVFfSe3QGONNiyc=;
        b=gWrb/iN0cifvDxv6zLIsgdvGry7qpomtuaB2aBdzjoT0olZVEm1Dk4GeKnN3MW4s/Z
         3G68q83u7TdHepAS3lx0AlPJkXz+ivrPa3f8qxxzYa3xYr3Xd+7Bzt+PUItd+ootYKeg
         vOFGRamQevqmzkVXASaBgd/hrVuwxZF8SESMVBBA5yCYBFr/A8RMv6a6PsuWEN622o1J
         4O2eBVKwaefHrF5A4ZHXVh4P/ypImFaRsRXSPqryqfRyGspJqwfyYbxk5oVo3sU3rfHv
         lbAJJnLrtJEB9Ucu3ztuzr3hAjTv8ZuKH2FGedxUMaBzUxpW5eHtkzO5u3fA+u3aO09a
         g2Zg==
X-Gm-Message-State: AOAM533HHjU2zSSwW8S1MNN4pOnwhckMXYxQy00CvOFGldlXL/gDI3fl
        Gg+EbRan+C8VByYHcMzjqeF+hCWCevzFxYnNhr7muEy2/9eedL/9CNESbw6c22jg7wpamITR3s8
        9od7oSLpC5KShinnF
X-Received: by 2002:a05:6214:411e:b0:435:7ef8:bfef with SMTP id kc30-20020a056214411e00b004357ef8bfefmr20319586qvb.1.1647333786244;
        Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3oHkYwl/EHW6+VU5/edFtgukOuNs5P/czgeVeppYp8cc7Uf17rwKyNVm6Cb0TeigCA4dttw==
X-Received: by 2002:a05:6214:411e:b0:435:7ef8:bfef with SMTP id kc30-20020a056214411e00b004357ef8bfefmr20319574qvb.1.1647333786022;
        Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id a15-20020ac85b8f000000b002e1c6a303f9sm7149201qta.95.2022.03.15.01.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:43:05 -0700 (PDT)
Date:   Tue, 15 Mar 2022 09:42:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/3] af_vsock: add two new tests for SOCK_SEQPACKET
Message-ID: <20220315084257.lbrbsilpndswv3zy@sgarzare-redhat>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,

On Fri, Mar 11, 2022 at 10:52:36AM +0000, Krasnov Arseniy Vladimirovich wrote:
>This adds two tests: for receive timeout and reading to invalid
>buffer provided by user. I forgot to put both patches to main
>patchset.
>
>Arseniy Krasnov(2):
>
>af_vsock: SOCK_SEQPACKET receive timeout test
>af_vsock: SOCK_SEQPACKET broken buffer test
>
>tools/testing/vsock/vsock_test.c | 170 +++++++++++++++++++++++++++++++++++++++
>1 file changed, 170 insertions(+)

Thank you for these tests!

I left a few comments and I'm not sure about the 'broken buffer test' 
behavior.

About the series, it sounds like something is wrong with your setup, 
usually the cover letter is "patch" 0. In this case I would have 
expected:

     [0/2] af_vsock: add two new tests for SOCK_SEQPACKET
     [1/2] af_vsock: SOCK_SEQPACKET receive timeout test
     [2/2] af_vsock: SOCK_SEQPACKET broken buffer test

Are you using `git send-email` or `git publish`?


When you will remove the RFC, please add `net-next` label:
[PATCH net-next 0/2], etc..

Thanks,
Stefano

