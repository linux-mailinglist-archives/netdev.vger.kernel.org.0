Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3912B14EE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKMDz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMDz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:55:58 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2AC0613D1;
        Thu, 12 Nov 2020 19:55:58 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o11so8397066ioo.11;
        Thu, 12 Nov 2020 19:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hjZnc6Xy7qkh9UYwXnqI9mxOyaDtZNt4WxuwMsbcHLE=;
        b=OA6g9d2eJbYg/mjwgzqroAXMbamouOLsUt3i6JOivjRRBhZpV14GP2+satJWX344El
         7LDhmAkn2vyJ2/BqAIM8dL8ANXrcFORdsA0uhb+GD7T94NoI/0pUDeTSm8vfoeOHX52i
         L4UGwu/Z2jKLNjev/eh4SeErZHgbrSERZ3alQpjWwmbbjFVWS8GPJ+8YGm9+zvQgo+6L
         s8t8QPe7Mo/asfbSNvenVrEj/LHtB8GTzXGuKrs1qDyAlRHVHBeCsaXgDbHohrb4iIWg
         S+bxT6gAyWgwFM6EQErMQiLfRFJzcKZFgIryYMXqI2Tni6RlN1JrLiokxWl4GxWsRMPm
         2Abw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hjZnc6Xy7qkh9UYwXnqI9mxOyaDtZNt4WxuwMsbcHLE=;
        b=VR5Ib9RfGN8y/rQdWAjITGXXhKXmhPJZM0VNdtw8e5FmsPWKwz9XH7Uxb+BK6oxGQ+
         m6scsvBrBU9FXCzzoapvIXqAqtO9Rc2Jp/fiqsZ9cll6rHh/IL1g54zBmiLf7+hbkRor
         o9MP1iX5KYe0Ks0ODaMTDohRvLrYACzOAbmYQrhvebhud9bUxiBxjw0UcGgoHF6uWSTA
         Rwpf2AqsxFVRAnOlpB5KgtNWh/wR1IfkPSAQbgM6gIDNm5PjyWZLAcsp4Mb9nr/D2WPj
         yaHD/ncJbOawvwTsN7AZ6VybA5LbuepoNIlWsGFUKgtlHHFcffp/K4n8mZlX7xD4AI99
         CSug==
X-Gm-Message-State: AOAM531mGvNMcRdxBTLcuG1xLADRtsxNcFyQMuw9n4h2Nvr2gyFFYIAn
        DN0IjI6Q/t3ZiFY/mE8gQOU=
X-Google-Smtp-Source: ABdhPJxX4xHJY6c4hNL9+/iqqx1qMVwqjgM3LwzHSbUNdc1mtqLX8t7uu3wKpWS/9XTfLc9BfGin6A==
X-Received: by 2002:a5d:8344:: with SMTP id q4mr373850ior.182.1605239757586;
        Thu, 12 Nov 2020 19:55:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:781e:c7e6:68f1:ffce])
        by smtp.googlemail.com with ESMTPSA id x25sm1678077ioa.23.2020.11.12.19.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 19:55:56 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp> <874klwcg1p.fsf@toke.dk>
 <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net> <871rgy8aom.fsf@toke.dk>
 <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f7a86d22-cac8-a8fa-15d2-55264205a46c@gmail.com>
Date:   Thu, 12 Nov 2020 20:55:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 4:20 PM, Daniel Borkmann wrote:
> built-in given it otherwise comes with the base distro already. But then
> my question is what is planned here as deprecation process for the built-in
> lib/bpf.c code? I presume we'll remove it eventually to move on?

It will need to follow the established deprecation pattern for N, N-1
releases (N here refers to distro LTS releases, not kernel or iproute2
releases). Meaning, for the next few years it needs to exist as an
option when libbpf is not installed. After that we can add a deprecation
warning that libbpf is preferred, and then at some point in the distant
future it can be removed.
