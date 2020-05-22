Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F781DEEF9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgEVSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgEVSLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:11:06 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B65BC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 11:11:04 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id d191so10026849oib.12
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 11:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/BJMDQoBtSyXX1mU6xpReLTVyZ2RaNki2/S5xZS9qzc=;
        b=NHdJ7UTb5kunXWBxP+sTy5sjv+V7UIKCO2spmqxruCFyRB/LX4k3jiLYUL9If+jv1S
         Bv4pG/kxyGx5HiEgfVU8TIgFiqwuPVoIxWGVZDDZrnmz5PTlxwBcLIXhYWgY42cR1B9i
         dbBU4bAT0yY/rWye0DxHkN+bsxD3niY6VUjwa/kg8KvbakJG0+tr06BG5btWTVJWCth2
         MuGRfThnpc+DnFcbMoN4oVwG/Y5uUWj+eGHrsNO1+VbnpXdf3IvJzgrU89T4tbbLUH7c
         iqA/5NgLUVw+gA/cBuNPhZBMTLlNrrQ4oP/xJEcJyxfTrrnQFr3ez+zWKgd8YWsNN6Ku
         miLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/BJMDQoBtSyXX1mU6xpReLTVyZ2RaNki2/S5xZS9qzc=;
        b=k4ZzQLUmeyGGBOm76u56zndgmTTWBOkVnF9M8V+Xbxf13n240GGH+/5Eq1DloimZ5l
         im8BOgJ8BaEGEjQpdCitHnln4NRW8gcLGu0Ia5BaqL6QTPXJmptkzFypAImj+PYg7vPS
         LXcooQwX4uzxoJus6GLVb2XazcFcqj8LfeME7rzRVvrTcHE5SednGkdwFC835aj6IxCr
         unV6IiDrWpAGmbE/lw5rYGRLz/KqvKI7DJA7qH5G/Pf0Uh6Kt5aWKFOVtPZ2TcpdA5Ne
         5VlbGrwCrPQKS5rn4Chke3KL81hxcWFky+d4V6IU/KpCcUF9zSmsfXDrgMME7SyFHh+W
         TkXg==
X-Gm-Message-State: AOAM533/QL1ypaGmUtWcnNHfwwdg62R+K1K99OHaqwdQ8Gt8PKBC5lRs
        Owws2hQXQajxrOn417uoihg=
X-Google-Smtp-Source: ABdhPJzh2HpAT8P3Sup8bMKwjQy/jtKCwbivxQtV7zwHuL/YXotgJN1dBNBLdAP/HrRgMvtoWp0zjQ==
X-Received: by 2002:a54:4383:: with SMTP id u3mr3275133oiv.8.1590171064002;
        Fri, 22 May 2020 11:11:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id 6sm2161913otg.36.2020.05.22.11.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 11:11:03 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 1/4] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, Lorenzo Bianconi <lorenzo@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
 <20200522010526.14649-2-dsahern@kernel.org> <20200522140805.045b8823@carbon>
 <20200522180431.6fa89cc7@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ee23ed8-741f-267f-00d2-1b75f6f8f426@gmail.com>
Date:   Fri, 22 May 2020 12:11:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522180431.6fa89cc7@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 10:04 AM, Jesper Dangaard Brouer wrote:
> On Fri, 22 May 2020 14:08:05 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> 
>> On Thu, 21 May 2020 19:05:23 -0600
>> David Ahern <dsahern@kernel.org> wrote:
>>
>>> Add support to DEVMAP and DEVMAP_HASH to support 8-byte values as a
>>> <device index, program id> pair. To do this, a new struct is needed in
>>> bpf_dtab_netdev to hold the values to return on lookup.  
>>
>> I would like to see us leverage BTF instead of checking on the size
>> attr->value_size. E.g do the sanity check based on BTF.
>> Given I don't know the exact details on how this should be done, I will
>> look into it... I already promised Lorenzo, as we have already
>> discussed this on IRC.
>>
>> So, you can Lorenzo can go ahead with this approach, and test the
>> use-case. And I'll try to figure out if-and-how we can leverage BTF
>> here.  Input from BTF experts will be much appreciated.
> 
> Published my current notes here:
>  https://github.com/xdp-project/xdp-project/blob/BTF01-notes.public/areas/core/BTF_01_notes.org
> 
> And created PR that people can GitHub "subscribe" to, if you are interested:
>  https://github.com/xdp-project/xdp-project/pull/36
> 

thanks for compiling some notes.

Fundamentally, I do not see how this can work for something like the
program id where the kernel needs to know not just the type (u32) but
that it should take the id and do a lookup - convert the id into a
bpf_prog reference.
