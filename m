Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094F31AE95
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 01:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBNAx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 19:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNAxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 19:53:25 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA3C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 16:52:44 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id a22so1327035iot.1
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 16:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=341c7e0SwYOgMVjlBYjohDVJ8bwZyPwn4QucasItNr0=;
        b=C5sYrGOnnlOCD0/kIIsoZOscc2NsvYzKwPlbF3OKt9iJi0t/P925v0/ct2my+rHPUC
         cSR5Ra7Y35eN9hpB1cupWXuBveDTFXDmyjhm0Rg9wb6CbsPDlqe2xGDFR+YivAZ6DUHW
         baV/ytcNsZvf8h9bwO1KvMf4nQwi8z7xXAkd04F+jQHVNWAB39P7v5ABHjpa0h9xAw/S
         1eUcZI/BJZrgdG0bDHhpbmPVylu7fsHQgS3UMb/RZro/n0UjutmYf+stKm41GdXsae8N
         0Bxr2SjkwBP270iaIOoYAQeo4HLyki9Zd+432Y2NNnEiVumJPKchbbVUWAUfoxsizz6L
         bxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=341c7e0SwYOgMVjlBYjohDVJ8bwZyPwn4QucasItNr0=;
        b=lb2fUvm1oaPLkf5chIB5Q8SrwJEuz2Rpjo9KZa44xbOez81CgTR/7Pw1mbVyPUNgf3
         xkVbX7D7lzv2u/Agc/zgoHKHXrYCF9+sd/Gdwbqnk1WYCSwq8vSAgdPfy2362zMRS/hg
         gt79IAVfH5EjoH4Pkp6z88L2YYfRL09pj2aO441hSIBd3VGo8MoTYmfkxo8saVg1ASvS
         OnTD02dNIGMRvSCWHN6uv4VFl9sJabTAeHXxbX1QbZzviW8h3PgwY7Dthb0oUrKJS12z
         6BX1+s7OFa3YE3pmrkGxAx8MzuKlycFicKyZ3RZZhHbVMqVRnqGsgvrvYIW6aB6pj+ej
         LiHQ==
X-Gm-Message-State: AOAM531y1AyfgI56BhSX7aHMEnE8/FXUplEa3Fo+GNa6deX+XphGrhL6
        lrAEcT9gWvWCZj+wDbZndIs9ltSzGwg=
X-Google-Smtp-Source: ABdhPJy2nT1o2lvqvGHBOorQClQEcGqqfSQHF3jV+5YhKXkWw2W7cz73sy6bXMpktmobRX3tEx9u1g==
X-Received: by 2002:a6b:510c:: with SMTP id f12mr7568665iob.135.1613263964416;
        Sat, 13 Feb 2021 16:52:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o7sm5304062ilj.67.2021.02.13.16.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 16:52:43 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ss: Make leading ":" always optional for
 sport and dport
To:     Thayne McCombs <astrothayne@gmail.com>, netdev@vger.kernel.org,
        dsahern@kernel.org
References: <20210206063650.7877-1-astrothayne@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e45b850-6c2a-4089-1369-151987983552@gmail.com>
Date:   Sat, 13 Feb 2021 17:52:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210206063650.7877-1-astrothayne@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/21 11:36 PM, Thayne McCombs wrote:
> The sport and dport conditions in expressions were inconsistent on
> whether there should be a ":" at the beginning of the port when only a
> port was provided depending on the family. The link and netlink
> families required a ":" to work. The vsock family required the ":"
> to be absent. The inet and inet6 families work with or without a leading
> ":".
> 
> This makes the leading ":" optional in all cases, so if sport or dport
> are used, then it works with a leading ":" or without one, as inet and
> inet6 did.
> ---
>  misc/ss.c | 46 ++++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 22 deletions(-)
> 

change looks fine, but you are missing a sign off.

