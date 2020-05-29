Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3600D1E83F7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgE2Qsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2Qsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:48:46 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C5C03E969;
        Fri, 29 May 2020 09:48:45 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so2810167qkg.3;
        Fri, 29 May 2020 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NHEfOR+MU8lQyz8ylk78HOtCrqvScTyrekgLYUDpaYM=;
        b=miLXrgwWvoavkqmIH8G+EZ+4yZNKX+MNyou25/6P8+wcrtRY6hgrtXo67mJHjaW2Xz
         IU4y5kYaaRTBeEePTl09TBn9Y5Gwuj50uI6MeFDHoAxgMhOBdAKD0jexM3ntP2p+JoID
         Bx9Y9F4578895fAZ65OCWOHpzo2hbYpEywfZsnrkEp/81FfMnpUyWSDz7zAbfI5ca3N9
         Hdi6nqim0I0dfw8HcR/arzzCd0Qghi5Jgr8eHDHxkrO1ZdKif14uNycT9HWoJrDw+SOY
         AWulynPaZF56WtQLrRRsoHUgqMKb812QXqdfDmz8Q1jqM10qYnhlFVj+DW/KFH/li43N
         8jiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NHEfOR+MU8lQyz8ylk78HOtCrqvScTyrekgLYUDpaYM=;
        b=nn8H0WYcCoewYowcZyx5Ak667XfvYEBQ7wLZy7AMxePu7LryB39T2MfxmHpBKGVEaI
         lAc52pacakvhZTNKZe9EJS64WoQL2X5MP1z2yPdOxFCWvzvDqFTYGulY/pISSBB0fGnx
         uT3H6L7b+MsPpZcblsJTwaQFIW0t/WkjQaVFJOzmYgbXZNAcLOOt2BxGYG1dZgv/RiJa
         gf/LChNnaORxTQqYgVxJFvw3VCtcK1M0ekODYmmlgpI0sAZrmwL5bp3T7jbhaQp2b3HF
         GeRRbzItbz4Z2V718og5jH00neM4W7C1PY4upVekRPy16beLANLC2f5n6ODIQ+L9C5yi
         KRfA==
X-Gm-Message-State: AOAM532SblaEu570O9409/JQ2iHVnzsotXjYXDsMGeah6PAVHKw2+Sp+
        z4Rgt6ujcFNc7e587B5OUHY=
X-Google-Smtp-Source: ABdhPJxn3qSDgkcbgogZEAq8X0r79dZLu3QVSO94Nu2uvuuNJ54qss0HFufBD75SYhbazKjMuWv/dQ==
X-Received: by 2002:a37:a949:: with SMTP id s70mr8435869qke.111.1590770924246;
        Fri, 29 May 2020 09:48:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:9452:75de:4860:c1e3? ([2601:282:803:7700:9452:75de:4860:c1e3])
        by smtp.googlemail.com with ESMTPSA id g28sm3118876qts.88.2020.05.29.09.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 09:48:43 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 5/5] selftest: Add tests for XDP programs in
 devmap entries
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, lorenzo@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200529052057.69378-1-dsahern@kernel.org>
 <20200529052057.69378-6-dsahern@kernel.org> <87r1v2zo3y.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a8fd8937-25d7-0822-67a7-e01b856261be@gmail.com>
Date:   Fri, 29 May 2020 10:48:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <87r1v2zo3y.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 10:45 AM, Toke Høiland-Jørgensen wrote:
>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
>> new file mode 100644
>> index 000000000000..b360ba2bd441
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
>> @@ -0,0 +1,22 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* fails to load without expected_attach_type = BPF_XDP_DEVMAP
>> + * because of access to egress_ifindex
>> + */
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +SEC("xdp_dm_log")
> Guess this should be xdp_devmap_log now?
> 
no. this program is for negative testing - it should load as an XDP
program without the expected_attach_type set. See the comment at the top
of the file.
