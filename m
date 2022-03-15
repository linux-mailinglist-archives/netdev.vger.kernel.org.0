Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5687F4D95F4
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345774AbiCOIQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345766AbiCOIQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:16:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3452349F13
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647332129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tCvl2VW1cmsTMiDGSIxoASCMFsGS7CwQX41mH9mi7og=;
        b=GLQ2QN3w2LMu/wbVMYfwVOcs6Z+0pket2OIHSSAUn4BPIRBRl5eCtPlwo94n4YgKQX9zri
        ccA9F4tSHJ/Yw7UrZ13ukStMY2NmGS2f4m3g1WRuBztqDuN+KHRGMHyzvRpxLeENpJKT5i
        /kpklsncn5YpFuOJBg9NvVDJ/Px+/D4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-LBXMkoE9PlGq5s6psB3BLw-1; Tue, 15 Mar 2022 04:15:27 -0400
X-MC-Unique: LBXMkoE9PlGq5s6psB3BLw-1
Received: by mail-qk1-f197.google.com with SMTP id q24-20020a05620a0c9800b0060d5d0b7a90so13724642qki.11
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tCvl2VW1cmsTMiDGSIxoASCMFsGS7CwQX41mH9mi7og=;
        b=T8D8F25tgvJYHA6AqLfSQmIx4QR5QCru73zhzRmRDOVnqld3jYzSwDVM9wRCSsD9n1
         cn9NJ18lub7ho4kAB9SAi/ttrcwzjbI/WN5Y07b+CcEqlUme88xV7bvTQlixigxiboKL
         n6hEiUnYkEklyO7wFhbUBBpzczGXX8ozKMt7/42G4WEKNlIJCPq8XVo236YAjbTmdxzZ
         k2WIg+HUamI/txI0k8X0uU3l5lstcgW1MKE3Y6aOobLWBqpt1499tW7adSgvY+sYIL95
         aWgKi4QMV4+YcSRBS3jaUrbVbtFxhBZovC9JE0hY3IBTWipId8gGSFHXP19Hv1OfPTX8
         0unQ==
X-Gm-Message-State: AOAM532st0XIdlbf4eYYVSLPXQ1lQSHXmS+403nHf7ReZtxSX9pHeoeI
        1WHBm6yYz1ajKQf8fg6/9rMiZPWoD9hHNNVCAkXzUCuDAYnJZMpwhBcsTlMzU3yEBUa3p3pxJyi
        G3WOMaSyYE4BehDuF
X-Received: by 2002:a05:620a:424e:b0:67d:3607:6b50 with SMTP id w14-20020a05620a424e00b0067d36076b50mr17091972qko.194.1647332127179;
        Tue, 15 Mar 2022 01:15:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjgYb2HPocNtGnS6faY8OIC23ZTZlsPZ5W/DCuKMZo/aQnXkwFKl2eu1filb04x820ASXlIQ==
X-Received: by 2002:a05:620a:424e:b0:67d:3607:6b50 with SMTP id w14-20020a05620a424e00b0067d36076b50mr17091955qko.194.1647332126634;
        Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id b126-20020a376784000000b0067d21404704sm8982966qkc.131.2022.03.15.01.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Date:   Tue, 15 Mar 2022 09:15:17 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/3] af_vsock: SOCK_SEQPACKET receive timeout test
Message-ID: <20220315081517.m7rvlpintqipdu6i@sgarzare-redhat>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
 <6981b132-4121-62d8-7172-dca28ad1e498@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6981b132-4121-62d8-7172-dca28ad1e498@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 10:55:42AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Test for receive timeout check: connection is established,
>receiver sets timeout, but sender does nothing. Receiver's
>'read()' call must return EAGAIN.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 49 ++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 2a3638c0a008..aa2de27d0f77 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -391,6 +391,50 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_seqpacket_timeout_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	struct timeval tv;
>+	char dummy;
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	tv.tv_sec = 1;
>+	tv.tv_usec = 0;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(tv)) == -1) {
>+		perror("setsockopt 'SO_RCVTIMEO'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if ((read(fd, &dummy, sizeof(dummy)) != -1) ||
>+	    (errno != EAGAIN)) {
>+		perror("EAGAIN expected");
>+		exit(EXIT_FAILURE);
>+	}

The patch LGTM, maybe the only thing I would add here is a check on the 
time spent in the read(), to see that it is approximately the timeout we 
have set.

Thanks,
Stefano

