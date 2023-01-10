Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46047664E1F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjAJViv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjAJVil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:38:41 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D335301
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:38:39 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jo4so32157688ejb.7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=r7ikDppQ7RdDEQSrD7fYVfkXrO2NW7K7ExuXj9r2CeE=;
        b=MP4MTVPp4Q3YymAw6U69kBDJz0BAqKxH7ZKCFjnk9zC0asOZKYPElo5qGCzclSRK7f
         LFWDSFTg/2Y/EChU08fZ9VXKss+gG5mqfHkc9MfVx7g6cX3v+nE2XpLlcFWLM63AKeGF
         rs5moYdt6/h/cpB+rVFrz1XJF5aMS5BVcMU24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7ikDppQ7RdDEQSrD7fYVfkXrO2NW7K7ExuXj9r2CeE=;
        b=SNLEI8j5fQnjGpN680xsBAt8asJv9akNMxkx7XpYt+Qelr7orYhS3RmjR1DIodbFzU
         QgPuz3KXNj6ov/nnxtH3dycKRgwdkxyL9CnRGsfRDPBT2Q4/LT1SENjCk8NRGgau6HVn
         ciXZFDP9+5dFxBmBKvpeA23y9mDCgeqURNmgoUGnPdtIPfJJH4V8E5dEZyazYjdBSavr
         ynsE9yP7vvYnaCfFh1pqGLpE1IvSYFVDK7m39uZrR6PPLtuBOoYE0Dl4kQQMI9BO+Saf
         n+O6T6jMt9cgKr5iUoBrVKbL0HpjcrtCRqO3H4BgBup1EtFY/kq+9fSNPM7rtrjHakUX
         ERtg==
X-Gm-Message-State: AFqh2kr8Fjk21FxEvZ9f3jHTz1XkGtvT0C0MlU16fqJam2i38KCGKYVF
        09TysTBggZ2XnPz0XhqmfDGixQ==
X-Google-Smtp-Source: AMrXdXt6Rx6nLUJu0WU7xEFEfCAJlmAe0gos+69BOzj2nmRf3MR8OoQq/QKsEesz6Ri7q/K+/T47yg==
X-Received: by 2002:a17:907:8b11:b0:81b:fbff:a7cc with SMTP id sz17-20020a1709078b1100b0081bfbffa7ccmr60157169ejc.18.1673386717902;
        Tue, 10 Jan 2023 13:38:37 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id w13-20020a170906184d00b00838e7e0354asm5295118eje.85.2023.01.10.13.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 13:38:37 -0800 (PST)
References: <20221221-sockopt-port-range-v2-0-1d5f114bf627@cloudflare.com>
 <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
 <CANn89iJmmENm6DTP4qjkN23j_KT7ZS_hweR5qks4VETsUzA_eQ@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v2 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Tue, 10 Jan 2023 22:36:33 +0100
In-reply-to: <CANn89iJmmENm6DTP4qjkN23j_KT7ZS_hweR5qks4VETsUzA_eQ@mail.gmail.com>
Message-ID: <871qo2dq8z.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 03:28 PM +01, Eric Dumazet wrote:
> On Tue, Jan 10, 2023 at 2:37 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Users who want to share a single public IP address for outgoing connections
>> between several hosts traditionally reach for SNAT. However, SNAT requires
>> state keeping on the node(s) performing the NAT.
>>
>
>> v1 -> v2:
>>  * Fix the corner case when the per-socket range doesn't overlap with the
>>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
>>
>> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  include/net/inet_sock.h         |  4 ++++
>>  include/net/ip.h                |  3 ++-
>>  include/uapi/linux/in.h         |  1 +
>>  net/ipv4/inet_connection_sock.c | 25 +++++++++++++++++++++++--
>>  net/ipv4/inet_hashtables.c      |  2 +-
>>  net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
>>  net/ipv4/udp.c                  |  2 +-
>>  7 files changed, 50 insertions(+), 5 deletions(-)
>
>
> Being an INET option, I think net/sctp/socket.c should also be changed.

Will do. Should be a one-liner + test coverage.

> Not clear if selinux_socket_bind() needs any change, I would CC
> SELINUX maintainers for advice.

I will start a thread.

Thank you for taking a look.
