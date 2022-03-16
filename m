Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA74DACDE
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354653AbiCPIwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354643AbiCPIwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 732DC64BF4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647420682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMlu3K6eKY9U4Sitc08oOJDaydm2FxICxmkEb7WkAjg=;
        b=MX2+1iTrJ17PSfSkT7aTUfMz8DdO5ObOHm0UFGlgG7KxRmhLXqyQyw7ShcyBHw1M1h0+BJ
        dRZjVXmfQDFQkGuiuUaN1BcMPrqcW32JUA/xMAlXfG60waRkz7tW5cSTcPnVKCTY+inyor
        qMs6t/+XuyK8pDEcdw7zIsXYNrDqa3U=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-_lByJ7oXPlOhbbVwjwqK0w-1; Wed, 16 Mar 2022 04:51:21 -0400
X-MC-Unique: _lByJ7oXPlOhbbVwjwqK0w-1
Received: by mail-qv1-f70.google.com with SMTP id x16-20020a056214015000b00435cbacdb72so1202276qvs.23
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WMlu3K6eKY9U4Sitc08oOJDaydm2FxICxmkEb7WkAjg=;
        b=Iv7ZCuYbrZLsJp2UVSBEfZ+n9CYL3xxoyx9QT+erKPdTgWe4zlkip8CKUQ0+7SMVQo
         R3CnH8+XzWzPS42+obuhkgwg1GB2PD/vgdcAO+3+VRbvacK3pbAeSEDZhjqZl4AZXMXf
         pg2J8ccEujLBkBx9PXb4pG8lHbu2XjkMZBu/ywIyYr3H3lK71O75Nl3pzFQQGNjGZJGQ
         Cy05Sj6e+A6IwIB4GVJQnTAfdOMaUqOWNYtbziIA4X/Ay1GgPs8Y5S2et/OewUZMlocT
         v7eU3yxfqO/QPnv+iFfh7+syNfVfp012eiAaLriPADwyyqiVX26FY0sJggBAVlvRBj1I
         Bn/w==
X-Gm-Message-State: AOAM533gjKgL+HDuE02Unclz69lFflKpwXN0z8NQ9LVzXmJtAA+4rDJ0
        /gWrIviv88A22O5yck7AEXDRZcKqa5aMopQRVC3PED9j8TP84g02C/FMmYDk3mJlC1c4qSrQzAR
        ssuBcuto75FVPsZaW
X-Received: by 2002:a05:622a:13c7:b0:2de:6f6e:2fe7 with SMTP id p7-20020a05622a13c700b002de6f6e2fe7mr25263102qtk.198.1647420680814;
        Wed, 16 Mar 2022 01:51:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuAi0JfY/QXj6XW5ZULZlBNrdNUKgIdO1Q5oMPbc2+3FSG4vHPDg4XW/kGbXoPQVPYst4s7Q==
X-Received: by 2002:a05:622a:13c7:b0:2de:6f6e:2fe7 with SMTP id p7-20020a05622a13c700b002de6f6e2fe7mr25263088qtk.198.1647420680549;
        Wed, 16 Mar 2022 01:51:20 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.retail.telecomitalia.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id bm1-20020a05620a198100b0047bf910892bsm641043qkb.65.2022.03.16.01.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:51:19 -0700 (PDT)
Date:   Wed, 16 Mar 2022 09:51:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Message-ID: <20220316085113.jlkj7cflzg77akmm@sgarzare-redhat>
References: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
 <2bc15104-37e6-088a-1699-dc27d0e2dadf@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2bc15104-37e6-088a-1699-dc27d0e2dadf@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 07:27:45AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Test for receive timeout check: connection is established,
>receiver sets timeout, but sender does nothing. Receiver's
>'read()' call must return EAGAIN.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> v1 -> v2:
> 1) Check amount of time spent in 'read()'.

The patch looks correct to me, but since it's an RFC and you have to 
send another version anyway, here are some minor suggestions :-)

>
> tools/testing/vsock/vsock_test.c | 79 ++++++++++++++++++++++++++++++++
> 1 file changed, 79 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 2a3638c0a008..6d7648cce5aa 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -16,6 +16,7 @@
> #include <linux/kernel.h>
> #include <sys/types.h>
> #include <sys/socket.h>
>+#include <time.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -391,6 +392,79 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static time_t current_nsec(void)
>+{
>+	struct timespec ts;
>+
>+	if (clock_gettime(CLOCK_REALTIME, &ts)) {
>+		perror("clock_gettime(3) failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	return (ts.tv_sec * 1000000000ULL) + ts.tv_nsec;
>+}
>+
>+#define RCVTIMEO_TIMEOUT_SEC 1
>+#define READ_OVERHEAD_NSEC 250000000 /* 0.25 sec */
>+
>+static void test_seqpacket_timeout_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	struct timeval tv;
>+	char dummy;
>+	time_t read_enter_ns;
>+	time_t read_overhead_ns;
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	tv.tv_sec = RCVTIMEO_TIMEOUT_SEC;
>+	tv.tv_usec = 0;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(tv)) == -1) {
>+		perror("setsockopt 'SO_RCVTIMEO'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	read_enter_ns = current_nsec();
>+
>+	if ((read(fd, &dummy, sizeof(dummy)) != -1) ||
>+	    (errno != EAGAIN)) {

Here we can split in 2 checks like in patch 2, since if read() return 
value is >= 0, errno is not set.

>+		perror("EAGAIN expected");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	read_overhead_ns = current_nsec() - read_enter_ns -
>+			1000000000ULL * RCVTIMEO_TIMEOUT_SEC;
>+
>+	if (read_overhead_ns > READ_OVERHEAD_NSEC) {
>+		fprintf(stderr,
>+			"too much time in read(2) with SO_RCVTIMEO: %lu ns\n",
>+			read_overhead_ns);

What about printing also the expected overhead?

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("WAITDONE");
>+	close(fd);
>+}
>+
>+static void test_seqpacket_timeout_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("WAITDONE");
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -431,6 +505,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_msg_trunc_client,
> 		.run_server = test_seqpacket_msg_trunc_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET timeout",
>+		.run_client = test_seqpacket_timeout_client,
>+		.run_server = test_seqpacket_timeout_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1

