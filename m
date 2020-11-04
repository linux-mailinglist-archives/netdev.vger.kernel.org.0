Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10D72A5C14
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgKDBks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgKDBks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 20:40:48 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77306C061A4D;
        Tue,  3 Nov 2020 17:40:48 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id o11so9289811ioo.11;
        Tue, 03 Nov 2020 17:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5PXhtPDP8zBwGol0twdKLwlVKUnyORjj759fS8L0cL8=;
        b=SVgZCOZuQDiSMXV46BXv6oVu2NF3+Jc3waS7CUGkoqj5lBH8qSXozoGh6e3fp14Pp/
         7zNveyuU+Br2YEOMjxRef+rp8JgWuu82HotT7LprnZK9yf4y2fN2FL8z6U4IqDPMMogc
         WI7xQjsLEgGwAVB3kehMNVdQLmElVslT3J8E4sX9LowvVac3sNCibHQ67w/Fr2tP3Vp/
         du37fNlS/ov8N3FHXyT68iCydlR0XOiXoU8IRUAvfl0IH7RqKv9/Tt7v5AQNrfAvMsSt
         h8AWkcGrikdi+1BLEITu/eVOrXK11vsWpc0pIaChuoGQKu4+s7d62J5k/w2ieFLIiHeV
         21zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5PXhtPDP8zBwGol0twdKLwlVKUnyORjj759fS8L0cL8=;
        b=jwa6KXxWoOlh7Sv4cZwHShZMf7j342/u8BPVcb8O6ly5khwvgU3zRrThHkcZG4Xh0w
         qD4Bh4wuohyZBNiaUaoSiCvmjA5l41oLXtgqdkjYpfv8LjzzaJ2XVDZtyrfNO7eIY/Ni
         StT7lIJbEnKKjoTi/ysjkkog8/wNJZ87TTYJbTjBH9d9OsNtGgqShZO0UdquNhIrWHIv
         DYSDCwnNn1kHSYcsJ/J29WgSouuEM7+ci8vfLn8Fa2Q2HWuIXaf8lX/eyLFh+bf76WIo
         ldNh+teQSUCEEitIAxJ//knzr+xYoIAJ5IkQqhYslLZCDB2iTf+ofMzjycImrUGBJq/y
         uWVg==
X-Gm-Message-State: AOAM533HjdZvP6bbln3nQBcUp6u0xglZeqrKgybI7NYNCGp+hHpuo/Wm
        xHxD+WHiR4nTGc11z+cSVAQ=
X-Google-Smtp-Source: ABdhPJwI1cRc0z1QBpsrhAJ7Sy5pAxdJumP54YcdCaukup1VU2REueaQk692d7NS6ZkWx/vidfe4wQ==
X-Received: by 2002:a02:cbde:: with SMTP id u30mr8557917jaq.69.1604454047867;
        Tue, 03 Nov 2020 17:40:47 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id n28sm366580ila.52.2020.11.03.17.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 17:40:47 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ce441cb4-0e36-eae6-ca19-efebb6fb55f1@gmail.com>
Date:   Tue, 3 Nov 2020 18:40:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 3:55 PM, Alexei Starovoitov wrote:
> The bpf support in "tc" command instead of being obviously old and obsolete
> will be sort-of working with unpredictable delay between released kernel
> and released iproute2 version. The iproute2 release that suppose to match kernel
> release will be meaningless.

iproute2, like all userspace commands, is written to an API and for well
written APIs the commands should be backward and forward compatible
across kernel versions. Kernel upgrades do not force an update of the
entire ecosystem. New userspace on old kernels should again just work.
New functionality in the new userpsace will not, but detection of that
is a different problem and relies on kernel APIs doing proper data
validation.


> More so, the upgrade of shared libbpf.so can make older iproute2/tc to do 
> something new and unpredictable.

How so? If libbpf is written against kernel APIs and properly versioned,
it should just work. A new version of libbpf changes the .so version, so
old commands will not load it.
