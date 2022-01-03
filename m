Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94690483632
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbiACRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiACRcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:32:15 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6335C0613B3
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:31:27 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id s6so32211366ioj.0
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JFAlzD2IAe6q2QUbQWv+iZi9bzF5vXAdiTbapVvQ3Ys=;
        b=U1JIu3yvgWEa8YAwp0QaC+DxrXC9FVrF9auMh6PyavBDoC1huOtQoTILhA6j1b3W7V
         F4INHxpXf8dlGlxsS8fNy7HlmgYcTexgIM4xQSuOBzCvQIbyfWKfCxzUK1am77V4VVrn
         V8NzoooeqDrV/LefJF3EfKhwcIZY1qpQ7rtg8cKShfhcJ6myrFaAeK/4vpJoLNhG5wem
         Eyj5NLJSaAI5fl/eKapMp2NS8LhMg0ZY7BpJyjW62gmnjKmn90iehXYqIEJtCWzkNKxv
         GLWJAmIx5XmpEj9nrOSJ7VXC8L0CZoxUR2gZGciIAQTSS1UUM3bNhsRGGlqZxXo403jr
         wPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JFAlzD2IAe6q2QUbQWv+iZi9bzF5vXAdiTbapVvQ3Ys=;
        b=Wu2oY1gAJEDeUPIMLgzyEGvWiUwo5cr4RE/+ka/ZLntdeS9EgxnUzsstJuqMJ6utTn
         A5wXHPlA2SYQgfgapcCurmEo7XjHMh4jlY6NqtqEaSOZeHqLGR7kzXavV4NNR/lp07U3
         AQfBgyF640nfroGvOc6QcyG+kMFTMNwra8jmQe9cTzyTLgBAF/LHHi2+PnuEFhZ36QaZ
         xarrOuhlzvMHaWDCOW1IcnEqnhcSgaPNaytlpypXoRga7IKSnxYtdiVQT3fkH/RJCk5r
         NpuwXX8aNco0qn8X/IXSRCR1S0uy0SFOj1qWhb2GSPC0RiXdBL1ee81ToPFY9nLX0xpX
         TUEg==
X-Gm-Message-State: AOAM5326jUiHG5qnOGh6QJsFYG0+rvDrSbXmL9n9ETbpHKr0mp64f7yn
        5w0o+JuN5bnCYlvArJnHc4Q=
X-Google-Smtp-Source: ABdhPJzcb932rCF5nOeXnIrXkQ+0ILxeZwlRIT9fWEk7iEdsK/dpNx/lbJunxUfBPQ9GeXvbPerdZQ==
X-Received: by 2002:a05:6638:629:: with SMTP id h9mr20180578jar.57.1641231087116;
        Mon, 03 Jan 2022 09:31:27 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r13sm23571937iov.11.2022.01.03.09.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:31:26 -0800 (PST)
Message-ID: <b675e0e5-3469-0854-3767-b2a9ec68bd8f@gmail.com>
Date:   Mon, 3 Jan 2022 10:31:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v5 net-next 1/3] seg6: export get_srh() for ICMP handling
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20220103171132.93456-1-andrew@lunn.ch>
 <20220103171132.93456-2-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220103171132.93456-2-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/22 10:11 AM, Andrew Lunn wrote:
> An ICMP error message can contain in its message body part of an IPv6
> packet which invoked the error. Such a packet might contain a segment
> router header. Export get_srh() so the ICMP code can make use of it.
> 
> Since his changes the scope of the function from local to global, add
> the seg6_ prefix to keep the namespace clean. And move it into seg6.c
> so it is always available, not just when IPV6_SEG6_LWTUNNEL is
> enabled.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/seg6.h    |  1 +
>  net/ipv6/seg6.c       | 29 +++++++++++++++++++++++++++++
>  net/ipv6/seg6_local.c | 33 ++-------------------------------
>  3 files changed, 32 insertions(+), 31 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


