Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD12F151522
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 05:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBDExF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 23:53:05 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44702 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgBDExE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 23:53:04 -0500
Received: by mail-qk1-f195.google.com with SMTP id v195so16652775qkb.11;
        Mon, 03 Feb 2020 20:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yYA6XkX5vMvntAUU1uL1pVnna9DiXCkGFkPe8CRS+jw=;
        b=Ye/D00oUuDeNkuWCAC0e+kD1nqzo/TdJ0EguJDEFqIRQTkpamvD8cvcQ7mPGy0tWRQ
         hZ12N9z/VsdYJh/CdsZFCBJMZySRyahAYLXR87qsPaOwZShmMjqTkcAB8D+ONk1Qr/3+
         tthxoiVINrUA9+2e/9NLAFQPJ7JGbs1QzryvY/mzCMEuEpHBXticJFytpaQHgcIpOqAh
         qPZ7iCA8Caoj1B1ei2QEfzyt1foyOHCdsudtusxtsLXzSMg4QpKI+PO7qUJC/M/MFQtc
         /Gp1fWFjTcS8d1uoUBNHieHcbTIDGnbHqF08uKeLmK2fprP9gX1Zi2nY61JrUOHtJoJQ
         mAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYA6XkX5vMvntAUU1uL1pVnna9DiXCkGFkPe8CRS+jw=;
        b=YhGklkq/xF+40NqRDUitYGkXxHJX25BvVDfgIw+m8H8iospqt2Zg8H0VfC/RA9ru5f
         PqU4v4f4GFK178mMJhAUokOX8NPHPTaAQz9f3gw1CmfmHxQNXJHP1bVhu5ahEoNpt+lM
         lZigl8ehNHv05yclNwJtmC8g9iUxkXvY37X+rEicRnG0PisudMWCg+8nLQqKvaG3ceX6
         xxWt4ZufSuACdPRib4vdHsklWRK6UBHamS3JxxU8pwcZ8THvxoKqwe6m+CvRyIz8vtdh
         cUYecLEA2SzCnBq/VG2bffOVv36i/2x1Pm9/r5Ib6ecSxsKDaxqYk/zZurR1A60narve
         6fyQ==
X-Gm-Message-State: APjAAAX3NibKBPt9krlJpZRr9t2AWHjUoA9qOulja9D7ora++2l7v3Xt
        jfZ1IHdWcGc9C/8ylzKw+IdwQn1zbaM=
X-Google-Smtp-Source: APXvYqzla12vZJVAfSANOPdCWpMVrjDkVyv7L6bjQzq06Yxq5rx8KuPxNLpBcT2k9KvzbpGcQpDw3A==
X-Received: by 2002:a37:a0cc:: with SMTP id j195mr27293712qke.8.1580791982183;
        Mon, 03 Feb 2020 20:53:02 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:3d10:e33:29a2:f093? ([2601:282:803:7700:3d10:e33:29a2:f093])
        by smtp.googlemail.com with ESMTPSA id w41sm11390279qtj.49.2020.02.03.20.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 20:53:01 -0800 (PST)
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20190820114706.18546-1-toke@redhat.com>
 <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk>
 <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
 <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
Date:   Mon, 3 Feb 2020 21:52:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
> On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
>>> Great! Just to disambiguate and make sure we are in agreement, my hope
>>> here is that iproute2 can completely delegate to libbpf all the ELF
>>>
>>
>> iproute2 needs to compile and continue working as is when libbpf is not
>> available. e.g., add check in configure to define HAVE_LIBBPF and move
>> the existing code and move under else branch.
> 
> Wouldn't it be better to statically compile against libbpf in this
> case and get rid a lot of BPF-related code and simplify the rest of
> it? This can be easily done by using libbpf through submodule, the
> same way as BCC and pahole do it.
> 

iproute2 compiles today and runs on older distributions and older
distributions with newer kernels. That needs to hold true after the move
to libbpf.
