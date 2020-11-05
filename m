Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A712A758A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgKECdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbgKECdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 21:33:44 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7734DC0613CF;
        Wed,  4 Nov 2020 18:33:44 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u62so251278iod.8;
        Wed, 04 Nov 2020 18:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ahld+ZsiZ/gnbY9ZDKFCHfmK2Mj7xEWXjhQ2rhDSQgU=;
        b=OkkAZdZhUym8yVXwagYbBCU0qHKaXv1JbqK+B1cUo9nbCJ1+0Q8ypVJImPWBlfpKxx
         1oGmG1Ml/lAnvFS7bc8/EB4oEEHTcvggaAQZ/Qq49xp0GeWvDGHvsyKGvM0UkWyVFZJN
         5x9C32rHoEsG6/KvXsRn+zcKgor2OAyc7E+LoflWu0dTluhcM0LHcCzf1NXsj8P1lAJs
         0bPCgvL2mpthsmiukoB/il/YvOOlmcxmwVi52RRRPUOMPk01Q2rjBg2eJms9MZRJoq1L
         3D+SePjwGt7UYy5qXieT/lK5DLNdmmoae/pcQM8wEZddlu7l0C3cHu/uwkkcBG57bg8+
         I+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ahld+ZsiZ/gnbY9ZDKFCHfmK2Mj7xEWXjhQ2rhDSQgU=;
        b=DGu3Vc3JGA1P+3Oiv5dU64KGPtNcrFjirMBQZ9sCpGC8lL+xKe9TXtPeballD0vJpb
         uLg+wijPyRsGgj8Wfw0xrTsmg4RrJltbFGykNXVdCI/YnafK6bP7NedNoRPi6bITXefn
         TkCYxN3qJpjK9C02CafrsBBKXl66OZ46X7dWKl6jPO3LUgqGoQrW6yoWwVhqA8NVe7DH
         UBREPib1YpOICOE8Py7KkjQsoQCCg6mQORuX/AuKi3BGeQm/8Z604SbdBS2XzUbAPDSZ
         HOUSysBgpJxaFCAhRCK0zNuBYq5SOmyVYHu+NOS6plMbNwvvI8n88kDGDY54QyFB3hxJ
         XOJA==
X-Gm-Message-State: AOAM530F2tMVDBd9MS3P5ah6cTch8oa5EoauTces3NT0w51mkwgGMiQz
        fjGELGMiAtM0OZgleeSPEYY=
X-Google-Smtp-Source: ABdhPJwy1rxWKWWhX24+u45cvVNdDki3nvSpqyD5byJdS15UdAszI7q4y8yXRX8rAIjXk8zW1hilfQ==
X-Received: by 2002:a6b:dc0f:: with SMTP id s15mr296507ioc.180.1604543623897;
        Wed, 04 Nov 2020 18:33:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6dfd:4f87:68ce:497b])
        by smtp.googlemail.com with ESMTPSA id v85sm88625ilk.50.2020.11.04.18.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 18:33:42 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
Date:   Wed, 4 Nov 2020 19:33:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 1:22 AM, Hangbin Liu wrote:
> If we move this #ifdef HAVE_LIBBPF to bpf_legacy.c, we need to rename
> them all. With current patch, we limit all the legacy functions in bpf_legacy
> and doesn't mix them with libbpf.h. What do you think?

Let's rename conflicts with a prefix -- like legacy. In fact, those
iproute2_ functions names could use the legacy_ prefix as well.
