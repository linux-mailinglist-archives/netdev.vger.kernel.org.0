Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1DC2AA179
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgKFXiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgKFXiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:38:18 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CB0C0613CF;
        Fri,  6 Nov 2020 15:38:17 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id y17so2528400ilg.4;
        Fri, 06 Nov 2020 15:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cMDUSUSOJpaSH9CWWq2vM22j2LvwSDCD82Y7MWOuiM0=;
        b=joz2Pg4QmVOHmoaOx6PXRXtt3vZis4TQCgK4Qwq+Jgn6bTyUYxl1tfHGypnTywZa18
         S+1O7KjSyVjcxG1+zo6EW3ntoZ/qnQ6Zd4S2c6nBOCqtP2U39T6BjGVqj3kfZ32sgbVy
         LL/6iF2A+ostM0RojMAQ5saWyNybUtPqKzZMqSLL0P6BqiNY7/DDhjIo41LOREdpsO+h
         zXNclpygvTulNHxljUVbKfXIKs2feBb172NaN/Q2gkP1DH8TD1ecGmSU1ijNiv98bOmV
         CkJUSSwxcqqI7EUeMxztC3OT/RzFLHmLiOcSzUI5LINUYgwt2ept8s5vHaIe+/T9GNPj
         /PgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cMDUSUSOJpaSH9CWWq2vM22j2LvwSDCD82Y7MWOuiM0=;
        b=N+jSw3R/64JqN/XH2WAWH6ffQn8AO8R8h5SP8+YtTAuKxI9Evz/9VtCQTnKwl4s2D0
         2qbycbkEtP8ewrzXKt6THxAL8+2A1rJry1YAPp0RxqFAPX+fcqYUuy2H47fChoqJxiVr
         wsmMB0+cRIlxkw+RUinXDlcUuFBjbyizt37UUWbTRNyItDvivX+JlRdWW0zujvJuqZhy
         n3Nv61Q5duHjYpWslcfED9z5cSn1UfVG3SVxYrdUWTFrYGK8K3U7N6WbF7FvXVuZtW0m
         pqrHIm0kfIy0rfWkahZ7H1khxrw5+jCoLV6ha8WCtQEWFVw9ruhSlwhrBeyIDWnLiIlg
         qxVg==
X-Gm-Message-State: AOAM532FuE5lyr7LNgvCYAB6vAHLr9sUKq5bqzElrz7cI15h2Y7E9tR3
        L/I7Nwd0BdPnxzcs9k2PUMA=
X-Google-Smtp-Source: ABdhPJy7XnjwPCPz2NHxqJM6u5YGzHmtg2Z8zcAwJ4OM84ZOUHTEM1jp70rQf0hkz4FM9jlrBVhDoQ==
X-Received: by 2002:a92:40d2:: with SMTP id d79mr3217980ill.7.1604705896410;
        Fri, 06 Nov 2020 15:38:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:59f:e9df:76ab:8876])
        by smtp.googlemail.com with ESMTPSA id r16sm1495830ioc.45.2020.11.06.15.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 15:38:15 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
 <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
Date:   Fri, 6 Nov 2020 16:38:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106152537.53737086@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/20 4:25 PM, Stephen Hemminger wrote:
>>
>> I think bumping the minimal version of libbpf with every iproute2 release
>> is necessary as well.
>> Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
>> and so on.
>> This way at least some correlation between iproute2 and libbpf will be
>> established.
>> Otherwise it's a mess of versions and functionality from user point of view.

If existing bpf features in iproute2 work fine with version 0.1.0, what
is the justification for an arbitrary requirement for iproute2 to force
users to bump libbpf versions just to use iproute2 from v5.11?
