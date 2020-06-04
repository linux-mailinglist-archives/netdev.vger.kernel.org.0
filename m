Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0251EE99F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 19:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgFDRn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgFDRn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 13:43:57 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A376C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 10:43:56 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so1511129pjd.1
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 10:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kMXzMIUAiF2KBwUn80Ub9Qepg0sLmzMPpxPNW/vT4dw=;
        b=jdNLXOAfgdwer44TQXjXvQAXBrBG23AriFtRN+QXipdbulomSfckr+Uy/SZYnv0I1F
         V1w1zSqOpqobHfG+v2397MiMX+jsbOiMmybhkWbfYS1qehxwvVfN3FALg4N3L0KYlu2H
         u8Nj4gOSmiAM/08S8Ha4H8POzMJ+v7GlbMXXu9rh7uVz18X1a2Bjv8ZbVBNAiIlsKj2M
         tUJsDjEVBucHZk2XJMUSyqP/5vADuPaArJKYBY1o2QvpvDVzJ7AIpXc8ChozQkfylT1y
         fQJioy0tk00KTgri+Qw3KcGPOMzybDBggLg3c8+5GuXEtGK2TufbGdx3zuCKhMfAX3Ac
         hIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kMXzMIUAiF2KBwUn80Ub9Qepg0sLmzMPpxPNW/vT4dw=;
        b=CDwGlWeZ5rDVKl349vEESUYfupSZ8RsksCU4QguMggdqpCjE/O29FemrDSFy4FkPAX
         FjgDvZ6NuomZzSnum6+ovW2iwXr8RK4h9XkM7bGqZc2nspUeLnXlex5miJcu06AUvJbe
         vP/0J9WOi/2ouuPaq3Hl+ugOIEXOv14QH6EdFEzEIfKsqcy+eLr0cexfObj93DRDIduH
         7zq3eAEJRB0jsxqhz5S4ZFPVJM86UKFg6jFNTUgXtBbIX4/UO9eVmoUQoYfyVl2X9+kQ
         R8sc8KWPEcyse95j6eB5L341o0AmLWjgLFuBBTjq8unfaBD3tWLD5UZ+REIketq0qp9w
         FVVQ==
X-Gm-Message-State: AOAM530B8mQAr56g+517K9+gxxOROPWvjdByi3kwL4vzHqAUMnvr/+9D
        39XUt+667ljWyZ6d8zV8uIo=
X-Google-Smtp-Source: ABdhPJw6ulU7O8TnWN9rsSaoXNxLM72dQx5YHnKuJ692zrnmmIyOUFoW7cxdL60pMKyx4G4GdZSvFA==
X-Received: by 2002:a17:902:b706:: with SMTP id d6mr6040874pls.304.1591292635543;
        Thu, 04 Jun 2020 10:43:55 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u17sm4714397pgo.90.2020.06.04.10.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 10:43:54 -0700 (PDT)
Subject: Re: [PATCH net] inet_connection_sock: clear inet_num out of destroy
 helper
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>
References: <cc2adbd7dcc17c44e2858e550302906760b38a0b.1591289527.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5b3af1f4-c1f4-5f60-21e0-9b52f186f328@gmail.com>
Date:   Thu, 4 Jun 2020 10:43:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <cc2adbd7dcc17c44e2858e550302906760b38a0b.1591289527.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/20 9:55 AM, Paolo Abeni wrote:
> Clearing the 'inet_num' field is necessary and safe if and
> only if the socket is not bound. The MPTCP protocol calls
> the destroy helper on bound sockets, as tcp_v{4,6}_syn_recv_sock
> completed successfully.
> 
> Move the clearing of such field out of the common code, otherwise
> the MPTCP MP_JOIN error path will find the wrong 'inet_num' value
> on socket disposal, __inet_put_port() will acquire the wrong lock
> and bind_node removal could race with other modifiers possibly
> corrupting the bind hash table.
> 
> Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
> Fixes: 729cd6436f35 ("mptcp: cope better with MP_JOIN failure")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

