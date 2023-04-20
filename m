Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9B6E9A17
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDTQ4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDTQ40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:56:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B2D65B5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:55:42 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-2fbb99cb297so699466f8f.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1682009737; x=1684601737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8COwJogh85Ubwzwgh/WUbXgMHnHM+aYpGZRMSZHXeAE=;
        b=7735fAM0RfQN/72GfpWio7Ue3N+D6rEkT9esXjhDRUXYjmeGqg74PICYX3rX5edhG6
         WmBo3MGCtjXZgkPGCaXq70Fsef6i3PT6zXvrfxo3mLIwZiOoiTIvkIjKezb0OBwMDqY+
         P0bNB3DG1DqdotBnpLPl+NgcqKm+C3rFCNQg4lEdzGp4xE3K1JgKZO1hnet7cPi2COxp
         qqmTxX09a86em2tS6txiygizTsuyc5xUAF7L1BNKOJio1npYaZmDxFwYkJt0HQuDDfzh
         +18tegTXmZKNEW+I1swyGmdBwdQ89UkMxUJW/Z0frhcI9rK1EPoGWHvUgGJbeMjOSNHu
         840w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009737; x=1684601737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8COwJogh85Ubwzwgh/WUbXgMHnHM+aYpGZRMSZHXeAE=;
        b=eZXvycFmypRailnBx9I8l6LO9GRJ6gs0O+a1+e3yJHVFeyzKJoepNM3SPE8T6Dvylv
         zDWn6mUdvYH6/B83L7T3DuD8tggaa6sKuUdq1aSR+VkFXqXdppKnkvqFB2PQhM90m7Jw
         vQy9e7MWffstSjU6ajqyzvc51vuveEQsQ75lgqMYA0nZUtiK0vK0mtWrWKsTtNCfR5gI
         mevyT7mlnoG164oRIlLRDmS3neEwY5n9z7jzRvUJvBV4SgtChrPzNv0ngFn+q9bo5vZ/
         87XnfVJ7A/ycItGD7OIz6rKllMb6/n8qn/eMXDNTp3zt6RPLIZP1y11DKmQo7LtvFbyZ
         FzKA==
X-Gm-Message-State: AAQBX9ejPqQxol9xOevki0cRgwwvi7xn8JtB9mEv2k8bF2MOZcT46CKb
        cpAeR5pDzUuaooGz58hq+1SXig==
X-Google-Smtp-Source: AKy350bJXlirEoh+ll5SJQuNZFSA3O6ZxUYGjwRW+yp/nsQKRvbua1otjr+kqF67Yjclfcoa7H8/Mg==
X-Received: by 2002:adf:ebc4:0:b0:2fe:c0ea:18ad with SMTP id v4-20020adfebc4000000b002fec0ea18admr1795221wrn.47.1682009737423;
        Thu, 20 Apr 2023 09:55:37 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:2c80:31d2:9220:ee01? ([2a02:578:8593:1200:2c80:31d2:9220:ee01])
        by smtp.gmail.com with ESMTPSA id w13-20020adff9cd000000b002cea9d931e6sm2386104wrr.78.2023.04.20.09.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 09:55:37 -0700 (PDT)
Message-ID: <f251507a-517e-b703-aa1d-50f6b3de8c8d@tessares.net>
Date:   Thu, 20 Apr 2023 18:55:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH LSM 0/2] security: SELinux/LSM label with MPTCP and accept
Content-Language: en-GB
To:     Paul Moore <paul@paul-moore.com>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
 <CAHC9VhR68fw+0oaenL08tRecLEC_oCdYcfGaN_m6PW3KZYtdTQ@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <CAHC9VhR68fw+0oaenL08tRecLEC_oCdYcfGaN_m6PW3KZYtdTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On 19/04/2023 23:30, Paul Moore wrote:
> On Wed, Apr 19, 2023 at 1:44 PM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
>>
>> In [1], Ondrej Mosnacek explained they discovered the (userspace-facing)
>> sockets returned by accept(2) when using MPTCP always end up with the
>> label representing the kernel (typically system_u:system_r:kernel_t:s0),
>> while it would make more sense to inherit the context from the parent
>> socket (the one that is passed to accept(2)). Thanks to the
>> participation of Paul Moore in the discussions, modifications on MPTCP
>> side have started and the result is available here.
>>
>> Paolo Abeni worked hard to refactor the initialisation of the first
>> subflow of a listen socket. The first subflow allocation is no longer
>> done at the initialisation of the socket but later, when the connection
>> request is received or when requested by the userspace. This was a
>> prerequisite to proper support of SELinux/LSM labels with MPTCP and
>> accept. The last batch containing the commit ddb1a072f858 ("mptcp: move
>> first subflow allocation at mpc access time") [2] has been recently
>> accepted and applied in netdev/net-next repo [3].
>>
>> This series of 2 patches is based on top of the lsm/next branch. Despite
>> the fact they depend on commits that are in netdev/net-next repo to
>> support the new feature, they can be applied in lsm/next without
>> creating conflicts with net-next or causing build issues. These two
>> patches on top of lsm/next still passes all the MPTCP-specific tests.
>> The only thing is that the new feature only works properly with the
>> patches that are on netdev/net-next. The tests with the new labels have
>> been done on top of them.
>>
>> It then looks OK to us to send these patches for review on your side. We
>> hope that's OK for you as well. If the patches look good to you and if
>> you prefer, it is fine to apply these patches before or after having
>> synced the lsm/next branch with Linus' tree when it will include the
>> modifications from the netdev/net-next repo.
>>
>> Regarding the two patches, the first one introduces a new LSM hook
>> called from MPTCP side when creating a new subflow socket. This hook
>> allows the security module to relabel the subflow according to the owing
>> process. The second one implements this new hook on the SELinux side.
> 
> Thank you so much for working on this, I really appreciate the help!

Thank you for the review!

We are working on a v2 addressing your comments.

Just one small detail regarding these comments: I hope you don't mind if
we use "MPTCP socket" instead of "main MPTCP socket". Per connection,
there is one MPTCP socket and possibly multiple subflow (TCP) sockets.
There is then no concept of "main MPTCP socket".

> As far as potential merge issues with netdev/net-next and lsm/next, I
> think we'll be okay.  I have a general policy[1] of not accepting new
> patchsets, unless critical bugfixes, past rc5/rc6 so this would be
> merged into lsm/next *after* the current merge window closes and
> presumably after the netdev/net-next branch finds its way into Linus'
> tree.
It makes sense, we understand. These two patches were ready for a bit of
time but we wanted to send them only after the prerequisite commits
applied in net-next first. But that got delayed because we had a couple
of nasty issues with them :)

We hope it will not be an issue for you to maintain them in your tree
for a couple of months but we tried to minimised the modifications in
MPTCP code. Do not hesitate to reach us if there are some issues with them!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
