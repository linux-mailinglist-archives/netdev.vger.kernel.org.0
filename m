Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA8F502E6A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbiDORvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343622AbiDORvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:51:36 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A24BCB6A
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:49:07 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id n17so5290153ljc.11
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=5XM54esi5Eok3jDOxJYtKt57YMeODoXOKraxTOsy46A=;
        b=Zlj+UxV1OEdo2amDF/6snrU6BTkSnlTKLx9JQA1EOXt7CUtUBOtr/fJRotCHhyoOPM
         FRmw6NSd31W1jS/ORt1zMO+tKGJoZFWCDBU+hB0HX1JW344Vr5vT7Gjs09UUc582DI+c
         6nlt2C8QBJzbZgQUocNy++5sjxs4HZ8tigL+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=5XM54esi5Eok3jDOxJYtKt57YMeODoXOKraxTOsy46A=;
        b=fpF49f6jOepN2NIhD6YYqRI6D0om76/aMfNlzxGpARXrdF4UASANtQGbb+9uIdDogR
         FheKXPJo4lKROQUahFvH3MhNn2d2dElkX8tQmHEE6DBReD+wPiZth+FUn1GFC1gHLcL7
         Irpqq+RreExsm4YbzKcW2Le7bkSF+hP4GJiTB0AIS6nGkCE6vT0+cPJfsb5YM/fErb1w
         XIzqwPpyuos5KTwdtwyvNdGrrUzcNPXA/9ofJaKXwinjXmahz866lGk66KWGtKOlg1j/
         hGJ4+Kn2yqoMpeSRARkdov9PffhNKFcbHZWxIxryxY1AX0cLVj14CM0Ay/1ifnASVjHI
         oOew==
X-Gm-Message-State: AOAM532APWEAGhwcyogtOuO63Rmt3M6niHCAnj7/IyI0FuDNDWKS62Gk
        h+z2rz2FAI8Ogm7+FfdnW6KbCA==
X-Google-Smtp-Source: ABdhPJx4AQcQqkFmb2Jedw4hUQ60/atpnS9qOHwSSvBbUIe6jE8kEq7L7dHPtTXnFIg+Zp36ZK+3Lg==
X-Received: by 2002:a2e:9b59:0:b0:24b:439c:8928 with SMTP id o25-20020a2e9b59000000b0024b439c8928mr147324ljj.154.1650044945340;
        Fri, 15 Apr 2022 10:49:05 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id m14-20020a2ea58e000000b0024c87adf6e3sm329773ljp.35.2022.04.15.10.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 10:49:04 -0700 (PDT)
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <87fsmmp1pi.fsf@cloudflare.com>
 <CAKH8qBuqPQjZ==CjD=rO8dui9LNcUNRFOg7ROETRxbuMYnzBEg@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Date:   Fri, 15 Apr 2022 19:39:35 +0200
In-reply-to: <CAKH8qBuqPQjZ==CjD=rO8dui9LNcUNRFOg7ROETRxbuMYnzBEg@mail.gmail.com>
Message-ID: <878rs66xv3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 11:44 AM -07, Stanislav Fomichev wrote:
> On Sat, Apr 9, 2022 at 11:10 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:

[...]

>> [^1] It looks like we can easily switch from cgroup->bpf.progs[] from
>>      list_head to hlist_head and save some bytes!
>>
>>      We only access the list tail in __cgroup_bpf_attach(). We can
>>      either iterate over the list and eat the cost there or push the new
>>      prog onto the front.
>>
>>      I think we treat cgroup->bpf.progs[] everywhere like an unordered
>>      set. Except for __cgroup_bpf_query, where the user might notice the
>>      order change in the BPF_PROG_QUERY dump.
>
>
> [...]
>
>> [^2] Unrelated, but we would like to propose a
>>      CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
>>      easier to bind UDP sockets to 4-tuple without creating conflicts:
>>
>>      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4
>
> Do you think those new lsm hooks can be used instead? If not, what's missing?

Same as for CGROUP_INET hooks, there is no post-connect() LSM hook.

Why are we looking for a post-connect hook?

Having a pre- and a post- connect hook, would allow us to turn the whole
connect() syscall into a critical section with synchronization done in
BPF - lock on pre-connect, unlock on post-connect.

Why do we want to serialize connect() calls?

To check for 4-tuple conflict with an existing unicast UDP socket, in
which case we want fail connect() if there is a conflict.

That said, ideally we would rather have a mechanism like
IP_BIND_ADDRESS_NO_PORT, but for UDP, and one that allows selecting both
an local IP and port.

We're hoping to put together an RFC sometime this quarter.
