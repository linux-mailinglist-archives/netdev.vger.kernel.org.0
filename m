Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1B58C751
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbiHHLKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242745AbiHHLKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 791CE10E0
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 04:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659957040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hBe2fpdBGNWzcr6vXOzuBs2kJsMnU68Mt4pMY9LLh1w=;
        b=AUQ8vh58bF6brXuQHf/VM/9ltM8yOUOyPqHvMak4v9ejm8LiCMWVByEedyq1yaQSYGx2VH
        kCRIdm8mCbJLz99riM6fkhA3JDNbW915GxO9wNr76LLneTwR7Rae2m+Fn2nfEbYA2s9F6y
        ppM8kI1v+KcyF2i0sbp+1+58RFY6/OQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-akMJOjZAM6-DrWN2KyB4Fw-1; Mon, 08 Aug 2022 07:10:39 -0400
X-MC-Unique: akMJOjZAM6-DrWN2KyB4Fw-1
Received: by mail-qk1-f199.google.com with SMTP id m17-20020a05620a291100b006b6590830feso7656262qkp.13
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 04:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hBe2fpdBGNWzcr6vXOzuBs2kJsMnU68Mt4pMY9LLh1w=;
        b=yNMk4AVf4vp+DdPe2CLOeF6+a1ZHTo0I1wzPb9+vzG4pSh+VlCaqbWA4FEG8JG8Q+c
         XrJJAwzgGwDsI+TwN8V4rLgrDf4vGF/pxBeoG4EX9lqnIdY0xpnlONurgCPCWJpfCLwD
         FQ2khokgkrXOt0jzYjl8AtYgfXqB9rESbs6OLSiTSiK6aErA3skEQCMlXFoAwcWRUEE8
         5jiD+tIdZtlErNrUNe6F5xncZHsgt8YELo3BGKd1802m1O7Q9UXG7zKVLS7sLkC37R3c
         PplICayVQl8WFq9WaEI514VABKEPBVVBaBqUlEldirL7X0Z/CPG45lEVnBQV1/Pl0PaO
         7KUQ==
X-Gm-Message-State: ACgBeo3BHJ9jBSzejq5xBDeuF77qSN2itBmx5q0aWbj4vC4GKfKtCHSu
        XxTMp5b+EbrrCSWdLdJZGj0zga3YnKkwmiilCZM9Waa9ZwFw56jc4iCAiO01iY+php9FZDr2hTS
        fjfL9sKE6cRsxuXQZ
X-Received: by 2002:a05:6214:5285:b0:474:69d7:c22b with SMTP id kj5-20020a056214528500b0047469d7c22bmr14912800qvb.97.1659957038986;
        Mon, 08 Aug 2022 04:10:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ujYB7ib/RGWCUpFI4MR2ymD2ume/U+w9j2VF/0+QfSm3zys9i5QUsO2JwnpbewhemYJWtSA==
X-Received: by 2002:a05:6214:5285:b0:474:69d7:c22b with SMTP id kj5-20020a056214528500b0047469d7c22bmr14912769qvb.97.1659957038768;
        Mon, 08 Aug 2022 04:10:38 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u3-20020a37ab03000000b006b46a78bc0fsm1093912qke.118.2022.08.08.04.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:10:38 -0700 (PDT)
Date:   Mon, 8 Aug 2022 13:10:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Message-ID: <20220808111027.nmreeuxa4jgn2e4t@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <1f50d595-cd37-ad61-f165-5632162dc682@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1f50d595-cd37-ad61-f165-5632162dc682@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 02:07:58PM +0000, Arseniy Krasnov wrote:
>This adds test to check,that when poll() returns POLLIN,POLLRDNORM bits,
>next read call won't block.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 107 +++++++++++++++++++++++++++++++
> 1 file changed, 107 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index dc577461afc2..920dc5d5d979 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -18,6 +18,7 @@
> #include <sys/socket.h>
> #include <time.h>
> #include <sys/mman.h>
>+#include <poll.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -596,6 +597,107 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
> 	close(fd);
> }
>
>+static void test_stream_poll_rcvlowat_server(const struct test_opts *opts)
>+{
>+#define RCVLOWAT_BUF_SIZE 128

Since we use this macro on both server and client functions, I suggest 
to move this define outside the function.

Other than that the test LGTM. I also ran it and everything is fine :-) 
thanks for adding it!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

