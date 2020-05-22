Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613A31DEE85
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgEVRpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730695AbgEVRpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:45:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97CC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:45:54 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id o24so10030201oic.0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XJAmrshjLSaIujxExK2+2zZTDqCFADfyUcSr6Vgd2Qk=;
        b=GeknEPEXYqlGTDXcIAjNGiuvDIvzu+usCvGLPcQSg1++McONZxCRJ1bi4TfmYUFN3k
         jbLgz959bDVqyp6DDpC1nljg72/f3CedkZUyd1tyOjzLC9G+9mzVuP5wlBY8r7VhwxzL
         yTR3AVMLx/dOKPnN1lcrCHvvvddvmx8EUy5KrF16DyzZ9o1ykXvZ7cUPeCTNoMsXfeLJ
         Fmj/BvcH9qstMwh1V+CTzi/PYPqNVQT1uviPNKYzx/YSAc4njkA6g0Rbe8ls26MWCiga
         O0BbrhXX4Kjtm+uwb4lI4sG3NFS9X/zUEolhALow9XHZZM7T4E30Vf7gglOPhvldsZRp
         Wp4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XJAmrshjLSaIujxExK2+2zZTDqCFADfyUcSr6Vgd2Qk=;
        b=PbgBe0OAtbnWhIjWq9iqb5qZ5qXEIsV4fRfnHgXz1hAEX04f+S5pssEQvqHkNF+ulC
         j24vTs+e9LqMnHDPvLf/yzmv5GDeWRJJi4/v4gLPaaf6U58Fc8vN3ldxDALnGWPSYBfB
         VB/BpU3gf12UCv9HcLtaFKfbFGkb5heZzv6PAKVdFJEm9qdBqo6xr4TjzyjaiISzGL4a
         jUq02lN6cGu0KLZunUe1tQkC9Lc6CpJWWHN/iKHaxJKj06Ag83mIMosXUYd6O+r0UN5W
         N7P94ltY75P0sFE90G7Ht7sQwZJrBT7On8l55x/Z1pgaJxQJlHNXi9M6aTWk37v4zvSr
         ECHw==
X-Gm-Message-State: AOAM532KzQPIdn2cwf67dPrc4Yu6p+g/b0LrG6FKwaMpY/CqqL8dh3uI
        2Qya+6zwQRfH0pcDt9lXNAg=
X-Google-Smtp-Source: ABdhPJyhsB1t5VXux40ggK2KsbEQouTwWmwurvNDE+D7qygeNlLEZPKH0iXhC/j4KR0S97/G0Q3TZQ==
X-Received: by 2002:aca:1a0c:: with SMTP id a12mr3397064oia.96.1590169553669;
        Fri, 22 May 2020 10:45:53 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id j6sm1076285ots.61.2020.05.22.10.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 10:45:53 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 3/4] xdp: Add xdp_txq_info to xdp_buff
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200522010526.14649-1-dsahern@kernel.org>
 <20200522010526.14649-4-dsahern@kernel.org> <87ftbsj6rz.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <187c8124-8886-5112-a5a9-02985eec3a39@gmail.com>
Date:   Fri, 22 May 2020 11:45:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87ftbsj6rz.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 10:04 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
>> moment only the device is added. Other fields (queue_index)
>> can be added as use cases arise.
>>
>> From a UAPI perspective, add egress_ifindex to xdp context.
>>
>> Update the verifier to only allow accesses to egress_ifindex by
>> XDP programs with BPF_XDP_DEVMAP expected attach type.
>>
>> Signed-off-by: David Ahern <dsahern@kernel.org>
> 
> Nit: seems a bit odd to order the patches like this, I'd have expected
> this patch to go before #2.
> 

This patch depends on patch 2, so it needs to follow it.

