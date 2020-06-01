Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3C1EB1B3
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgFAW2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAW2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:28:06 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F6AC061A0E;
        Mon,  1 Jun 2020 15:28:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id y9so855522qvs.4;
        Mon, 01 Jun 2020 15:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w34qrgAtqKgWn0UNxg9g50JFvRmAbPE4l3k1NpuixCc=;
        b=FX3ZGVwbd1+L4oOVXEzicN4ElNQPWdDo46vCq5u9/Zg9fJrvymADqyIooj05mKYtSc
         ItJiinZOjBYSmg2Ru9TWKF4O36DOt93Gl8E0HcT4FlVSGUzz150TUrOy4JBGd7KtYM7Y
         yktw1fdHkT7uv4LvBkc6GrzaHmMLWhEFIY7ii9aU0WdM1z8dm3p1lGVTVmsCqcoEzrW+
         XPz7MlgrAnkiZvDeC5Bjg4s3GHOy0LZ1gMftsoCWKcL2MgMlPKYnwMUKtXh/TlTy2Oi/
         8TZS+MSY8RxjBRng7+UF1j8gtTMPENJPfJv15K8kuH3TJbk6Q9b7MQcB4RT1mCG4NPRB
         hwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w34qrgAtqKgWn0UNxg9g50JFvRmAbPE4l3k1NpuixCc=;
        b=T1ZZQyGCTyFLzs46YyLUomTOqN3fpvk94E3TFML/fB69HbtgOMod529JYeNcGwtnHr
         9gm5dxgDlqYfWz9nYtPhV+cmW9FyiyC4qIrJQ71rMnMOPoym5cOTdF6zzQRGlSKZ3M9G
         /nau74nAf9us4tgi0+mtQKn6BCr2dB0T2W4rG1QLa+DSgca8rNQMinNb0oL+Wskv9HUD
         ckZ/PpwstkBXmrtRK4JsX3fdQnvKw/oefazULYpOHOuV+eNFnaOa3G7ci48XIngPBpMq
         5x3QL29vhWOBtUzVhUvueWri1P0lRfBA3TDKQylkPYX7+vxVy/1bVVRdQAjYI4Pks0vf
         suIg==
X-Gm-Message-State: AOAM533EBr4jJBfkqOtMsNaq7DCOCYU1h0+qsTGF/rcA+VmIWthgmNCp
        q2OZwT4uC5sxOrQL1yR+FyE=
X-Google-Smtp-Source: ABdhPJzNoUyN6nQF1jd4/5OR1guuPDqOvhgxEfgWG7sYy2kB+jgYnMY86pXH39We+onlcCe98+nCQQ==
X-Received: by 2002:a0c:b60c:: with SMTP id f12mr22811410qve.244.1591050484893;
        Mon, 01 Jun 2020 15:28:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c9ef:b9c4:cdc1:2f07? ([2601:282:803:7700:c9ef:b9c4:cdc1:2f07])
        by smtp.googlemail.com with ESMTPSA id y66sm652093qka.24.2020.06.01.15.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 15:28:04 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200529220716.75383-1-dsahern@kernel.org>
 <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
Date:   Mon, 1 Jun 2020 16:28:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/20 3:12 PM, Alexei Starovoitov wrote:
> In patch 5 I had to fix:
> /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c:
> In function ‘test_neg_xdp_devmap_helpers’:
> /data/users/ast/net-next/tools/testing/selftests/bpf/test_progs.h:106:3:
> warning: ‘duration’ may be used uninitialized in this function
> [-Wmaybe-uninitialized]
>   106 |   fprintf(stdout, "%s:PASS:%s %d nsec\n",   \
>       |   ^~~~~~~
> /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c:79:8:
> note: ‘duration’ was declared here
>    79 |  __u32 duration;

What compiler version? it compiles cleanly with ubuntu 20.04 and gcc
9.3. The other prog_tests are inconsistent with initializing it.

> 
> and that selftest is imo too primitive.

I focused the selftests on API changes introduced by this set - new
attach type, valid accesses to egress_ifindex and not allowing devmap
programs with xdp generic.

> It's only loading progs and not executing them.
> Could you please add prog_test_run to it?
> 

I will look into it.
