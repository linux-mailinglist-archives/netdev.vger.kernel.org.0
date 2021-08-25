Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A97E3F6EBD
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 07:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhHYFS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 01:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhHYFSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 01:18:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B8DC061757;
        Tue, 24 Aug 2021 22:18:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so3911881pjs.3;
        Tue, 24 Aug 2021 22:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UjTsAH0VtlcDsx7b7YgMEkRGGeEJtOmDdioWkhyZzGc=;
        b=AuJ672m5YbzXR75aA7tNdSjrd/NAGRGV4lGyaKdtZfDoepaZ1j7rrugpq/zpKFF2TA
         ol/YLlIxuK5mECcTDcvKyMkwVcX+CJadO+ZVjOXH516Dl36DJzWV1QUT0UDuFAgoSNWj
         wVCf4pV2TRtynWPqPNOi2BQo+sXHm/Ha2UEDf39itjMpdDKc5YOZz/gakZJiYPELtJp1
         hu7LhwclcLPzku/yhwlRFEH77jKRs25Q387GG3helh4lAkU9ExGoMri9fpQOXw7bmhGK
         zJz6Y2c05KCM/RzEa7wVMEEwE7VzFndnMaaTZJjPCcOSJD8WMkzS3Xe+EdM/hKVvJxfk
         jxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjTsAH0VtlcDsx7b7YgMEkRGGeEJtOmDdioWkhyZzGc=;
        b=k2XQLn2g4b/SN9WEnVHEbYhKTduGLThgiaEcPv2eqXuU1aQWhndO+UzsN3dnCUxUnF
         M3lNWXkvlB05o07yDJmZaWqc9KTY6ZAcHyirazxcXSZxdqTG1AjsWoxu3/GqmgqaC+Yi
         A2peehVwfmOlo+Q6SC/iH/I5PeEsKRor2RAE5CH3SZAxZkPilbWN1wJFz9B8rqEWI5lL
         8wV9aZ78c206Dz6fJyOwbaEAP7vDJQTtqldALZMYikooMtlCF49Eim7m4kDyt/dCCcmM
         FWwjz+UNXqF6t1HiOMvxap/9upQx4iK7ITkGEiW7fiSAkLRApaO6DAtxmXYpXMh/Kkq5
         z1hg==
X-Gm-Message-State: AOAM533un2l7JEpY6zvzphfoIa7srVj3H4l1Kjru9ZqihVj+pjrMseU0
        wNnlFgB8ZVbqhS8KYjDT2wGNRVXxGjw=
X-Google-Smtp-Source: ABdhPJzUwotDxP9wHAcTZAHOP3zkBjnJjyXZ0RYz8YbWkAK2B5YeEOmGKql0Dj7wM7ENtT+2sMEYBQ==
X-Received: by 2002:a17:90b:ec9:: with SMTP id gz9mr8216534pjb.24.1629868689775;
        Tue, 24 Aug 2021 22:18:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id p10sm4248727pjv.39.2021.08.24.22.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 22:18:08 -0700 (PDT)
Subject: Re: [RFCv3 09/15] selftests: tcp_authopt: Test key address binding
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1629840814.git.cdleonard@gmail.com>
 <09c7cff43f832d0aba8dfad67f56066aeeca8475.1629840814.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <922fe343-c867-62ff-14b8-3d84ed2e1b76@gmail.com>
Date:   Tue, 24 Aug 2021 22:18:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <09c7cff43f832d0aba8dfad67f56066aeeca8475.1629840814.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 2:34 PM, Leonard Crestez wrote:
> By default TCP-AO keys apply to all possible peers but it's possible to
> have different keys for different remote hosts.
> 
> This patch adds initial tests for the behavior behind the
> TCP_AUTHOPT_KEY_BIND_ADDR flag. Server rejection is tested via client
> timeout so this can be slightly slow.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  .../tcp_authopt_test/netns_fixture.py         |  63 +++++++
>  .../tcp_authopt/tcp_authopt_test/server.py    |  82 ++++++++++
>  .../tcp_authopt/tcp_authopt_test/test_bind.py | 143 ++++++++++++++++
>  .../tcp_authopt/tcp_authopt_test/utils.py     | 154 ++++++++++++++++++
>  4 files changed, 442 insertions(+)
>  create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
>  create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
>  create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
>  create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
> 

This should be under selftests/net as a single "tcp_authopt" directory
from what I can tell.
