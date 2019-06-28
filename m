Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19F5A2D9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1R4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:56:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36406 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfF1R4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:56:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so3366414pfl.3
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YcKbK3r2Q+497R+LaIiCey5bOby8qZ7z+01VJdR9ML0=;
        b=aE4DmMUjEz14Rl3dY+YSN0gZiBakAl1s+bDWQgyvyNKJoGVLdb18cTjG/xzjZYadtu
         Ho9OONfRoFIi6Sa9twDude4gZ7uNn3ZR4JVlq454FdJlFsdRFtsysiNlAqVsUTH2bsak
         s1LBoz7Foj5VsHoOdpOnTFM33JWRZnxZiGuVOJvGsMD2fAC9pjcV9UJnh0wsq+n87lj0
         8Ejm02K7dj5OyL9YvqvBCgQJpxS6MAIL4MtZvuTAhYH9Tb6PQZWvZ2J66mEs2buFUf9b
         5lupSsCZ2kuZHRozsyU19LWAUpdDXaZzSJxnJfDcS44UB3IaSpknhx3EbmIEO/avpJq0
         hqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YcKbK3r2Q+497R+LaIiCey5bOby8qZ7z+01VJdR9ML0=;
        b=t9wU0sD0jWtHOpybf+55Nid8aalX4bGIscJNRIThk/cfJWw3c1f6Z1ubnP8nM2klyl
         VacA+YKQmC/04BTyKzCK5CGd8JOOyeIJrkSUDImV/JwOV7GC8bgUMhbluiCaVoq/r/ha
         RxlgwQkZUsR+Aa0yzCpkRYhjrObW3g5mAFHeGRbZd+9BYZ2QWLhpbFplvddnIx2aZWiv
         ngw0jJKVd7iccmvqf4FdalJ7RBAdo7gO56lNSk6RNVeaUqPud9sZj+AsPv0ruxqq27N/
         BR042qG91VfxgaWbcI+ZrADXKD4BFNB0UxnfaQZjPtZaD4AJeRQxx+Uyo0fQK/PScXgj
         ZV0Q==
X-Gm-Message-State: APjAAAUyzO9GioWkwvm+xO5eiVXZYLBiQXg+1kCyU6bl1tZH6woYuLK5
        5OkawIrtnee6X0Wa2XH0PHixkA==
X-Google-Smtp-Source: APXvYqwyulMWXXvHCH2uwx4MmaikslB2L25jM59v2iW0J+N1+xqrL66F4On2xRMig4z3EYRkecpCSw==
X-Received: by 2002:a63:3ec7:: with SMTP id l190mr10851197pga.334.1561744559353;
        Fri, 28 Jun 2019 10:55:59 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u2sm2524001pjv.30.2019.06.28.10.55.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:55:58 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:55:58 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
Message-ID: <20190628175558.GK4866@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-3-andriin@fb.com>
 <20190628160230.GG4866@mini-arch>
 <CAEf4BzbB6G5jTvS+K0+0zPXWLFmAePHU2RtALogWrh7h7OV03A@mail.gmail.com>
 <20190628174533.GI4866@mini-arch>
 <2cff901c-3b0b-d99d-3e58-7065d9d82ace@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cff901c-3b0b-d99d-3e58-7065d9d82ace@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28, Alexei Starovoitov wrote:
> On 6/28/19 10:45 AM, Stanislav Fomichev wrote:
> >>>>
> >>>> +struct bpf_link {
> >>> Maybe call it bpf_attachment? You call the bpf_program__attach_to_blah
> >>> and you get an attachment?
> >>
> >> I wanted to keep it as short as possible, bpf_attachment is way too
> >> long (it's also why as an alternative I've proposed bpf_assoc, not
> >> bpf_association, but bpf_attach isn't great shortening).
> > Why do you want to keep it short? We have far longer names than
> > bpf_attachment in libbpf. That shouldn't be a big concern.
> 
> Naming is hard. I also prefer short.
There are only two hard things in Computer Science :-)

> imo the word 'link' describes the concept better than 'attachment'.
