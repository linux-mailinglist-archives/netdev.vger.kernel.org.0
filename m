Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2761403BAF
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349419AbhIHOnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 10:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhIHOnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 10:43:17 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C857C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 07:42:09 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id u1so2222724vsq.10
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 07:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiFSlR9syjKHuvoqExFm8WJ8uXOU90QQcy0FwyC7vVI=;
        b=EdXGbtZ1B0sll2SOuAggry/PztZXouonh3HUxuq9bnJwNFyst35cMBpFDz9Vut1sos
         SoApX1dxEuAsQKTYIAL4BSb4Q352HdfVjcNUuLBRX9vldVq9LDkNBqvqQLY8hpm00Oxo
         ugUl4r1AwufkJzDQQ4d25hB1rAG5joEiBezqYiqFEymy1xDxXvIoD5c+Gt+SU26Dq1pb
         OoqM4z3ailCqjveJLIbgdoMnHdrWhp19KLr08vBQ8KrhriiT35Fqrb1uHFbVIll71uBJ
         43oEloqROCzJpSVS7TNeYuChXBtF1WQ67/A+KNC39s4kB/H8HpjDBSWMOGRD60tzIsIR
         byNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiFSlR9syjKHuvoqExFm8WJ8uXOU90QQcy0FwyC7vVI=;
        b=Es9tntAXBUuOGdepO9qFfPXhisJAtOdo7G+4XkkyAQVuKFEJaWxL5mvqY0YRxc5cqH
         vSUu2oqknS3t7ep7VoD/5Pj+ex1uJI8Ju+0bLz00V/L8xIrg9bVa+hXSVTTvPKJRO4TY
         ssrNBX/siNvQsA91qoXJbLE5vWi0ui6u02Z6yWvEmr8Z9FIIPrRSKBiHHVno4aOxhrD1
         fhqSI1E8B/6TM44Sx2YYCMtfP9xc7T4jLdfiFoxoaLlr1HvNrszAbGzjIP0sScSDz7zy
         6F+DXFIMcZh+B95NR0fUedSML8bvGR+Z0V+wUkozLwSMQsnd7HCHg9F+VU9SI75MpACO
         ro+w==
X-Gm-Message-State: AOAM533VBlFcn6JSjW+Y+DdbCZAutBwrVnyTit+tGcVlUYV96/H987k2
        T8/a/+2PzuivNKueecsM9ZPpOVObSLk=
X-Google-Smtp-Source: ABdhPJxRZ097dVF37pdD5xjPtFYsJEsavqs0k0YgqRd+dqPuqovMy2YHLlTN2Yd6wlNPKqTHVOVQow==
X-Received: by 2002:a67:ef51:: with SMTP id k17mr2334614vsr.2.1631112128284;
        Wed, 08 Sep 2021 07:42:08 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id m206sm301840vkm.3.2021.09.08.07.42.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:42:07 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id l9so2219845vsb.8
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 07:42:06 -0700 (PDT)
X-Received: by 2002:a05:6102:483:: with SMTP id n3mr2536007vsa.42.1631112126493;
 Wed, 08 Sep 2021 07:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210907121052.75cb416d@hermes.local>
In-Reply-To: <20210907121052.75cb416d@hermes.local>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 8 Sep 2021 10:41:29 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdH5v3HBUmh-Hvt-4SRgXPVNvdSokq=wids_t2Ze_YBQw@mail.gmail.com>
Message-ID: <CA+FuTSdH5v3HBUmh-Hvt-4SRgXPVNvdSokq=wids_t2Ze_YBQw@mail.gmail.com>
Subject: Re: Fw: [Bug 214339] New: sendmsg return value may be positive while
 send errors
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 3:11 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
>
>
> Begin forwarded message:
>
> Date: Tue, 07 Sep 2021 09:23:54 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 214339] New: sendmsg return value may be positive while send errors
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=214339
>
>             Bug ID: 214339
>            Summary: sendmsg return value may be positive while send errors
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 4.9.99
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: 1031265646@qq.com
>         Regression: No
>
> in file udp.c, a function named udp_sendmsg has a code like this:
>
>         /* Lockless fast path for the non-corking case. */
>         if (!corkreq) {
>                 skb = ip_make_skb(sk, fl4, getfrag, msg, ulen,
>                                   sizeof(struct udphdr), &ipc, &rt,
>                                   msg->msg_flags);
>                 err = PTR_ERR(skb);
>                 if (!IS_ERR_OR_NULL(skb))
>                         err = udp_send_skb(skb, fl4);
>                 goto out;
>         }
>
> but function ip_make_skb may return a null, then err will be set to 0;and out
> like this:

ip_make_skb returns NULL on MSG_PROBE, as intended.

or if __ip_make_skb did not find an skb on __skb_dequeue(queue). But
this is not possible, as __ip_append_data either succeeds and enqueues
an skb or fails and makes ip_send_skb fail before reaching that code.

I don't see anything wrong here.

> out:
>         ip_rt_put(rt);
>         if (free)
>                 kfree(ipc.opt);
>         if (!err)
>                 return len;  // return a positive value
>
> actually, because lock of kernel memory or socket_buffer,

I don't follow this part. This operation runs without locks.

> the ip_make_skb failed
> means the send operation failed. but a positive value is returnd here.
> finnally, users regard the operation was success, but actually it failed in
> kernel.
