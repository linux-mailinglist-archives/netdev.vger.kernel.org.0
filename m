Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CDD4924F6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbiARLcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:32:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241127AbiARLci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:32:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642505558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxIUZxKIctHJwL8z/L5myK/ubboYV+HhwGkSMX1RWeM=;
        b=DNSmUkZd/7CSh+S/AW+V1uEGxrJhJSuZvXrab9/QuZqzkqSJ5mkuJ41SOuF3dqdlEbfA5D
        d71PKVPPwazo5+UPs96Db/zzMtTQPRB68jTXEzcqMs1/+KDEYVlEcC4zd5Y3pC1s9q+VE9
        ZV+O54g87pTS6GV3DelXB04Kec08HOU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-ieb7yq9ZM8yfuiv_MCVfbQ-1; Tue, 18 Jan 2022 06:32:37 -0500
X-MC-Unique: ieb7yq9ZM8yfuiv_MCVfbQ-1
Received: by mail-wm1-f69.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso1864831wmb.9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 03:32:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gxIUZxKIctHJwL8z/L5myK/ubboYV+HhwGkSMX1RWeM=;
        b=xB2JvrkHo/KOqc3yYHPlWfy+o9+fi7LzPf7mmwQ4uQeFT5MbPk1fH6fo0SfV2EPRMF
         3nR6OMOoVjeN+LjP/tp8YdCA2DuAIOEGrHqulwE/ZzWYFPfKAWUNTtcr8bc4qwIlYxey
         t5B4R9gN1YHgzqkF14Ah8fH2o2Tsftn70TmTOj0CiPamevVDTk0tIefwpTTU/l4WPAVl
         B812tX/x+Icks0NWsJIcRMXX7BTgSNEG70IDjJCPHUUrUW5FDta+jgiShsp9RdqlD/d6
         PHURbcjCMSoalxIiyvluExBahrc1H/DxFUhAugm6Edc+mUK0O3r1pZhSEWr7NgIDEvJB
         Mitg==
X-Gm-Message-State: AOAM533V7GNmFdPCMJWoizBibr8+bi0T60bbqQ1DLS5m5KKS1go3APYf
        o6LvNIEavqZgNgR20KiyIilgMR7BgUDM3FKSSbo7HAQahRfBvpfwCzxjO3Xac8iDabvkUZemeFy
        lS5tD1jOwUOO/wQRP
X-Received: by 2002:adf:eec5:: with SMTP id a5mr22941960wrp.125.1642505555957;
        Tue, 18 Jan 2022 03:32:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2Z2Ir8v9YbJpsV5b8zAGMUVsvQSlizXWz0r6NetP68sBK/YKLA/n6veKoloXDcOw314VKwA==
X-Received: by 2002:adf:eec5:: with SMTP id a5mr22941913wrp.125.1642505555610;
        Tue, 18 Jan 2022 03:32:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p4sm252431wrf.25.2022.01.18.03.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 03:32:35 -0800 (PST)
Message-ID: <3d46c2e7-40a7-61e1-8bb5-063bb608b26f@redhat.com>
Date:   Tue, 18 Jan 2022 12:32:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 09/10] selftests: vm: Add the uapi headers include
 variable
Content-Language: en-US
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Cc:     kernel@collabora.com
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
 <20220118112909.1885705-10-usama.anjum@collabora.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220118112909.1885705-10-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 12:29, Muhammad Usama Anjum wrote:
> Out of tree build of this test fails if relative path of the output
> directory is specified. Remove the un-needed include paths and use
> KHDR_INCLUDES to correctly reach the headers.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>   tools/testing/selftests/vm/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 7d100a7dc462..8dc428c8a3b0 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -23,7 +23,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/p
>   # LDLIBS.
>   MAKEFLAGS += --no-builtin-rules
>   
> -CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
> +CFLAGS = -Wall $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
>   LDLIBS = -lrt -lpthread
>   TEST_GEN_FILES = compaction_test
>   TEST_GEN_FILES += gup_test

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

