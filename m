Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35D2A4D24
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgKCRgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgKCRgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:36:00 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D012C0613D1;
        Tue,  3 Nov 2020 09:36:00 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id a20so16839142ilk.13;
        Tue, 03 Nov 2020 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y0hqlzASuEgoXbRy4gWLWWG8iRng1vxoIPmcNQyvmQI=;
        b=nbsX3eVzPwqnb7Sgr0dM5o//OVnDmSqHJiKOPvj8Gxxu0CJDOpHmVvKPYg4rXgH2qP
         BoSPEnlkh2X9xy7MHpUlROkrATjrKpPSkq6JZ9ZI+KblrCo7200dJ5sPbDjPwBC0UxEx
         dyI0AKCydghhtE2L/73XQTgLkjIX1FipT/R0n46hvxFcoS5YV++khoLrZGaKa9GVj5P6
         xnG3o7ucUHoIAmWy/POl0Uh7uxEwDEB9FxgfQvsuz+QmdD115h5odzSLdE0nc/+CrBuH
         53NuDLt7dU7b3ayfPYhzRYt2aWPCUNxImRyukIILQKhtWPROqIcgly+KYXcF3FwrdHsO
         soog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y0hqlzASuEgoXbRy4gWLWWG8iRng1vxoIPmcNQyvmQI=;
        b=KDszlw8DRTzQpIA3O6gV3IvJ4n27sQlBnf0RoQLNq8+a0c02PYpoQ3Nrpwy3NI9MaY
         Ha0V2t5SOVq/daZHV/dc1WUKtgPi3qyMMh2pxLGrEtDFml3uDMIseZlDeez22PXGYLWF
         4TuO1KCt3CCiSiOUMAmEdfFsojRCBoo5y8oHXU3CfUx7iwlWD9OjgIhrh7rBlsWgKrpC
         hTcskHsxS/+j5iMNLvdjWjKI76AtBF8PLJ4CkW5SG9Vsle7ecgG02FhkBisxB2QgrAtc
         zDNnwicRatwj96xbtyu6YUZyh9YOfTNDE2PtWHiZMI65dDBBI4CtRQRqOOlcRjYzuPEU
         xLeQ==
X-Gm-Message-State: AOAM530cOhEaiOx9WdX7VuZQ7N8NmMXQTu6Rhswn0w0BuCq8L7uCYNbF
        eHlzHTJDytPSLRkE8GvCvno=
X-Google-Smtp-Source: ABdhPJyxfXgLUI1h0aMq+Cpk9/R1ftYGoPvwlG1FRWU2wnA5Adp+zpzo8mZy/kzDEeYUPzpW8ioieg==
X-Received: by 2002:a92:cd0e:: with SMTP id z14mr15244968iln.135.1604424959802;
        Tue, 03 Nov 2020 09:35:59 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id n15sm13438574ilt.58.2020.11.03.09.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:35:59 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
Date:   Tue, 3 Nov 2020 10:35:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 1:46 AM, Daniel Borkmann wrote:
> I thought last time this discussion came up there was consensus that the
> submodule could be an explicit opt in for the configure script at least?

I do not recall Stephen agreeing to that, and I certainly did not.
