Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2992864DA20
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiLOLQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLOLQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:16:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C09FD1
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 03:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671102956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Kl3tMRlZWCku5ZeCmK3Fd0ox6k3kRb6mmVQtWcX99U=;
        b=GOWKODBbvbM2pi461rSVqG4uHa3FIiiDD1IBNnn8yN3pQdae5ltIulVRBRR5YpMqlKgH1N
        tRcNFAAWKAMGe+5AZcmi9HRQnmaQg1URA8C8NvC33q3gLm+CIjloLim5JsMRRhqKjc4dJL
        Yeu1OGwT0z8Ch2mT2vgXYZh0khnfW9M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-ioaOhPauPwui9l9iO50DXA-1; Thu, 15 Dec 2022 06:15:53 -0500
X-MC-Unique: ioaOhPauPwui9l9iO50DXA-1
Received: by mail-wm1-f71.google.com with SMTP id v188-20020a1cacc5000000b003cf76c4ae66so999523wme.7
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 03:15:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Kl3tMRlZWCku5ZeCmK3Fd0ox6k3kRb6mmVQtWcX99U=;
        b=kpVGW/ve0PB4YONHQFFxvM89cJIbIBIiwVtLekwVvV7M52V/C1mfCxd7bKo3f9T5sk
         zeMcQCc21nrAeb4CHGrst21aalExo1GqzbDVvneFeDcV8wUKN+ri73qWt0nezUV4PU8Z
         Gqm/5DsrJhsVfzv1kBAD9s71qvZznxBScUhua5Rh8GEYf4y22cwuNQpTQWnDj+o4x1TX
         EiAzwgiHS7xqymXJ4iHGIsZh17+kr9t/v0oSz+rnJBRQAX4a5n+U2mEdyIEbhvRi0Lgi
         zuIwIh9WMAIISPOlM5ibErBLbM1WkXiP6r0DWGjb0JE0yNkunxj+KNoFSx673gmr4p7X
         VYgQ==
X-Gm-Message-State: ANoB5pmwovyt4cYCuJW1dafaRDzMvktxmGsVYk2g4e0eQ6h0phRBuQVg
        3E2Jt3CR7dDmkZiJA90AC+uUxCquYyTqFJKUgLchMYauJikqhZEkmBVHsO2mFMy+BdMoBi6EqUk
        4CUcEFuzwSnqcPDhT
X-Received: by 2002:a05:600c:3549:b0:3cf:68d3:3047 with SMTP id i9-20020a05600c354900b003cf68d33047mr22081733wmq.41.1671102952809;
        Thu, 15 Dec 2022 03:15:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ZHsLPkg5GR7KSUtYrOa6b3jyqOif0xG3iwmEVvK38ZieL2rFAbQomNYviVnRTRNk5qPoUJA==
X-Received: by 2002:a05:600c:3549:b0:3cf:68d3:3047 with SMTP id i9-20020a05600c354900b003cf68d33047mr22081716wmq.41.1671102952553;
        Thu, 15 Dec 2022 03:15:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-97-87.dyn.eolo.it. [146.241.97.87])
        by smtp.gmail.com with ESMTPSA id 189-20020a1c02c6000000b003cfd58409desm5993633wmc.13.2022.12.15.03.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:15:51 -0800 (PST)
Message-ID: <9365cc1a48c326122898e22067ccd8f9667e5b37.camel@redhat.com>
Subject: Re: [PATCH net] selftests/net: mv bpf/nat6to4.c to net folder
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>
Date:   Thu, 15 Dec 2022 12:15:50 +0100
In-Reply-To: <20221213071211.1208297-1-liuhangbin@gmail.com>
References: <20221213071211.1208297-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-12-13 at 15:12 +0800, Hangbin Liu wrote:
> There are some issues with the bpf/nat6to4.c building.
> 
> 1. It use TEST_CUSTOM_PROGS, which will add the nat6to4.o to
>    kselftest-list file and run by common run_tests.
> 2. When building the test via `make -C tools/testing/selftests/
>    TARGETS="net"`, the nat6to4.o will be build in selftests/net/bpf/
>    folder. But in test udpgro_frglist.sh it refers to ../bpf/nat6to4.o.
>    The correct path should be ./bpf/nat6to4.o.
> 3. If building the test via `make -C tools/testing/selftests/ TARGETS="net"
>    install`. The nat6to4.o will be installed to kselftest_install/net/
>    folder. Then the udpgro_frglist.sh should refer to ./nat6to4.o.
> 
> To fix the confusing test path, let's just move the nat6to4.c to net folder
> and build it as TEST_GEN_FILES.
> 
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile            | 11 +++++++++--
>  tools/testing/selftests/net/bpf/Makefile        | 14 --------------
>  tools/testing/selftests/net/{bpf => }/nat6to4.c |  0
>  tools/testing/selftests/net/udpgro_frglist.sh   |  6 +++---
>  4 files changed, 12 insertions(+), 19 deletions(-)
>  delete mode 100644 tools/testing/selftests/net/bpf/Makefile
>  rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 69c58362c0ed..d1495107a320 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -71,14 +71,21 @@ TEST_GEN_FILES += bind_bhash
>  TEST_GEN_PROGS += sk_bind_sendto_listen
>  TEST_GEN_PROGS += sk_connect_zero_addr
>  TEST_PROGS += test_ingress_egress_chaining.sh
> +TEST_GEN_FILES += nat6to4.o
>  
>  TEST_FILES := settings
>  
>  include ../lib.mk
>  
> -include bpf/Makefile
> -
>  $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
>  $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
>  $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
>  $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
> +
> +CLANG ?= clang
> +CCINCLUDE += -I../bpf
> +CCINCLUDE += -I../../../lib
> +CCINCLUDE += -I../../../../usr/include/
> +
> +$(OUTPUT)/nat6to4.o: nat6to4.c
> +	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> deleted file mode 100644
> index 8ccaf8732eb2..000000000000
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0
> -
> -CLANG ?= clang
> -CCINCLUDE += -I../../bpf
> -CCINCLUDE += -I../../../../lib
> -CCINCLUDE += -I../../../../../usr/include/
> -
> -TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
> -all: $(TEST_CUSTOM_PROGS)
> -
> -$(OUTPUT)/%.o: %.c
> -	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
> -
> -EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)

With the above, nat6to4.o is going to lose the cross compilation
support introduced with commit 837a3d66d698 ("selftests: net: Add
cross-compilation support for BPF programs"), you need to include such
make builerplate, too.

Side note: it would be nice to factor out the cross-compiler ebpf and
libbpf support into lib.mk or the like.

Thanks!

Paolo

