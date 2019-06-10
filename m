Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3738C3BECA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390082AbfFJViK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:38:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38648 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389945AbfFJViK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:38:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so6035183pfa.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yfBT+DW4k3NkSoZSjkt1YuAQG4YmaC/9RG5SdveLJm0=;
        b=S+LMKNNMq4IPtWInaUFozPpSsOEG8NnNlEJjNc/LTefZ/VBMBKy8NYeFB+oQKNaMg5
         jtOQ8AGGo61vAoC1JaDHGSuXhSKeOLb/hk4mu4BgLlDel2IOq2L9ndJ3YRFr2AII1hER
         ghwYxPgf4p1q07kh/REHscmy2XfHQ/WO1oqrAhDggkJYdll7qD1k3x+cNeXJCHg9CDuD
         b6mNlqlD2oVOoKV0beeqN+yefpRoh+uLeOkRYKYKmD8L/o7NgdPQtgZWjT72pGEqI/8t
         xe51rf3V7BgAzuCXxIcWECxFTy9QGChxVmA7bJ1fdsQR+M07m4XGm1xIJErkY/G2NK9s
         MgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yfBT+DW4k3NkSoZSjkt1YuAQG4YmaC/9RG5SdveLJm0=;
        b=I4x0rhEUieeP8t3Ty6oqAce6O3F4cdcQ7D/fFfvW5DgtWmvVhpJn0QAPl6ZwVq85zG
         6yumeghFK5pEZC8y+S67C60+qqFGiq0M7ssCAiRZfIc8k4k1wSnYvj3jd0gRMmVmIPYT
         hFuFvQaz0i85h4rXRou0zpZ3bTjDlPFVE4zNhJ0gS7Br9Nt1ApOyE5VSD9g9ITrkQMkY
         Uxn3R+09CUwwjEVBknQbcuSsZBNZ+0xBcecHKDBwjaa78T6i6GEi/VCY+fkG4ISEBt6f
         c4jIE18b2/8ulCLOhi8Bpl2+nRrRtxMQuHsvVHeGSvz50WtGdpqwIpseA6hr/LWWqctJ
         YGzQ==
X-Gm-Message-State: APjAAAXJOy6Gr6YGP4qcIgjHqBJUci4evZQZD08UQnjqY2wgYwS6gNNu
        ILHmPGQaY6KduieN2M8ZtNM+yNXtodg=
X-Google-Smtp-Source: APXvYqzRt0jJ+WBeUnbf4mKfUcFGWKLJdHKrCnm2QDk4dOKBUj+rhGmFODQ9l/ZGJhPqTl5Ivfqtqg==
X-Received: by 2002:a65:60c2:: with SMTP id r2mr17100368pgv.156.1560202689127;
        Mon, 10 Jun 2019 14:38:09 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 2sm12770899pff.174.2019.06.10.14.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 14:38:08 -0700 (PDT)
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached route
 exceptions
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560016091.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
Date:   Mon, 10 Jun 2019 15:38:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <cover.1560016091.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/19 12:12 PM, Stefano Brivio wrote:
> The commands 'ip -6 route list cache' and 'ip -6 route flush cache'
> don't work at all after route exceptions have been moved to a separate
> hash table in commit 2b760fcf5cfb ("ipv6: hook up exception table to store
> dst cache"). Fix that.

The breakage is the limited ability to remove exceptions. Yes, you can
delete a v6 exception route if you know it exists. Without the ability
to list them, you have to guess.

The ability to list exceptions was deleted 2 years ago with 4.15. So far
no one has complained that exceptions do not show up in route dumps.
Rather than perturb the system again and worse with different behaviors,
in dot releases of stable trees, I think it would be better to converge
on consistent behavior between v4 and v6. By that I mean without the
CLONED flag, no exceptions are returned (default FIB dump). With the
CLONED flag only exceptions are returned.
