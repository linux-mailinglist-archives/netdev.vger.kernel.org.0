Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DDE1D9CFB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgESQhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729219AbgESQhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:37:43 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AEEC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:37:42 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id dh1so2933026qvb.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ev5T6vjJH0oC12FklJIvFbNYx7YAnVtic5fHIwuhCWA=;
        b=Vq1x5ICrMOI0+IrTgm+EwOxDyQ1wAQ5K7dW8D6yWR8cBkhwZzYpco+wDWTE9l05n1g
         xGnVjQ+X6kXw7LQAQRGxqtw54pDAR4RwVPh5EhlsFZ0XHSfs+9cCqtPa3hdgt3/OAxeq
         +BkEewxFYayBTPoCTQ9g2Tz0b0JZDPwXmew0jNSyvtaIrzwInb8C9M8/XiHN2ZBeO7/a
         GPndy/zWIqFtB9i88FayzNOmTFY2ircd67HyUOf5I5zg75fxcCm13ovztftMOABEdk46
         nWMCjGMnLLOUuArHiS5ObMj+5OHIzXXUqhLDjUyPeW0do9qLZ6i//zeI+r8P8aa9J3z1
         kWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ev5T6vjJH0oC12FklJIvFbNYx7YAnVtic5fHIwuhCWA=;
        b=al4SaH9I/aVS1ga2+xC9JpKs6oXlynSMvLHPrqo4rkHcYzeSRnEOYEOehCUFQBBHlp
         h3OHe7OkE81BebmvaVubX5Qts0xd10kIlCBeFabaZ59YVqgwIbktc7I0YS0gZ+keqhW5
         y7t278mugfSvtVx5hFob5xoG0+PfLo7IQYDiBuNRZJKgvLOEZ03KUrY1mNi5XfClLxax
         cqq47rPp1/BFzYXXv5pQSeVHmle7hOGXNw9If0do7lgqd2QclajG2BMJqBZKS89xG2GR
         UeNMSiHSEocmsdNYh9jU/jCK3qmsavdHBx49RnpjUNuw8Sex7kRC8fhXLFL5iuMUH0qs
         X3Sg==
X-Gm-Message-State: AOAM531/WnnuCfARh1N+TEugqdtGeQDd/AUfyhA0hOBAX6uAwe3Yi9tK
        yC4r39qmFCNSOhrPdf2PRPg=
X-Google-Smtp-Source: ABdhPJxqSwh3rCDEkzUbWOqYrK9aeCvbUi4IxY6R/Jiw60Ljc2Olxy52yHv+dSsc7GS5SNhu2/bXFw==
X-Received: by 2002:a0c:b44c:: with SMTP id e12mr488349qvf.30.1589906262123;
        Tue, 19 May 2020 09:37:42 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id y28sm138229qtc.62.2020.05.19.09.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:37:40 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk> <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
 <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
 <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b8c2a50-b78f-7525-4f80-58bae966c1bc@gmail.com>
Date:   Tue, 19 May 2020 10:37:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 7:31 AM, Daniel Borkmann wrote:
> I meant that the dev{map,hash} would get extended in a way where the
> __dev_map_update_elem() receives an (ifindex, BPF prog fd) tuple from
> user space and holds the program's ref as long as it is in the map slot.
> Then, upon redirect to the given device in the devmap, we'd execute the
> prog as well in order to also allow for XDP_DROP policy in there. Upon
> map update when we drop the dev from the map slot, we also release the
> reference to the associated BPF prog. What I mean to say wrt 'property
> of the devmap' is that this program is _only_ used in combination with
> redirection to devmap, so given we are not solving all the other egress
> cases for reasons mentioned, it would make sense to tie it logically to
> the devmap which would also make it clear from a user perspective _when_
> the prog is expected to run.

Thanks. I will take a look at this.
