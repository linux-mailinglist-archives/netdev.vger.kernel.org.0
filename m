Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FE54AD033
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346236AbiBHEMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346782AbiBHEMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:12:17 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF7C0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:12:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id n32so16680679pfv.11
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IHH3Ou/fj7p1O60NDSvye2PQmIbDifAvVgs0Uz//Alg=;
        b=RhoXSMYlsNe6FAh7hDIZMl6a49Dtd+UxKkaw0a7o4nmwFqmHTeSzqtUUGN/5Nf/7eL
         iP2TEzJ6JtVcYyYMq1wv/ivg08gVHzoh5rAd9Fk81NUPgkjd0vliS06Yi5svA6+//rGN
         PFrdpR/uaoPTpNbO0TbXZ6t9DSfqvwz/ZVSTapq80csE/1Pyf0doJZeYR18LwVI0Ha28
         ebUW2jxSsPpvwNXI5fPDGfXd5hH7/X/x/AlypikWz+cF6bNhdOrqL+kXmUr677nniErJ
         IqDY3uPgpD68HLSQ5qq2xhT4DT1MyRx2gdsAoho6zKUMKZ19kFjeFsbxNknq59Egi61W
         /Pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IHH3Ou/fj7p1O60NDSvye2PQmIbDifAvVgs0Uz//Alg=;
        b=ot7HxEhrHx5jFudUkEYak0K/uOs2u3yVA+Z+XPQV20KQuVRfVVu1If3D6aC3vBNMHn
         v2j+08AfpP+mbQ7HBt6HaSwU1z28EYsUNv30DAVXT4/fF8fivQR0x+SNtJlyfNddRhal
         dHttwrPD0sLVV/7d71nsomHKiYCjofbDe+6+Oz8LufS8QAAp+l//+Q3IKeAhwFCpQKAk
         hh2QLWv/8pfX3AJFIkLfPgtB/3RYI7GnaHkTLEL6uVlLeOldisMGK75B5dyx1ogERWyZ
         dbqEmmC6pVHGdZJu+XORSzBsWPRUN2lKkM5DbC/dGtXNXKdmtU7HelCCW3cjalf5t3ak
         z6qw==
X-Gm-Message-State: AOAM532LEFr2vpB78ooJrif5E3Z+dkow0QYMaGK4zUuCJazuKg05ERk5
        b8dBfIUhOo7esUbctlmGA4A=
X-Google-Smtp-Source: ABdhPJwi0yj43r7lf5kwjx8YI/1NUTOv8OiGYSYqqFrBjQ7s9SjUjtK9rUf752xkbO89gUYOV8lBtA==
X-Received: by 2002:aa7:938c:: with SMTP id t12mr2522962pfe.51.1644293536840;
        Mon, 07 Feb 2022 20:12:16 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id ng16sm906316pjb.12.2022.02.07.20.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:12:16 -0800 (PST)
Message-ID: <776f76fc-6a0e-44e4-f880-9cffe65dd4b0@gmail.com>
Date:   Mon, 7 Feb 2022 20:12:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 03/11] ipv6/addrconf: switch to per netns
 inet6_addr_lst hash table
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-4-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-4-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> IPv6 does not scale very well with the number of IPv6 addresses.
> It uses a global (shared by all netns) hash table with 256 buckets.
> 
> Some functions like addrconf_verify_rtnl() and addrconf_ifdown()
> have to iterate all addresses in the hash table.
> 
> I have seen addrconf_verify_rtnl() holding the cpu for 10ms or more.
> 
> Switch to the per netns hashtable (and spinlock) added
> in prior patches.
> 
> This considerably speeds up netns dismantle times on hosts
> with thousands of netns.

this has to speed up many aspects of ipv6 addresses, not just the teardown.

> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/addrconf.c | 77 ++++++++++++++-------------------------------
>  1 file changed, 23 insertions(+), 54 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


