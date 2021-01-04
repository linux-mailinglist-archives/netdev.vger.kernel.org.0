Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8686A2E9810
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 16:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbhADPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 10:06:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbhADPG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 10:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609772703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HJCXspdx3i7XpaVupbHfC3QV0pRcOT5mdGPwTiDlwdE=;
        b=U/StqKtLrEY6Sy1pRG+/Q5AbUGx98iGOE4uEX4B/ydubxLeaL4VXPQgxV8fXe5sfCAeIkG
        SDRLe1vXmN42N/sz9aQYXao4hr2IMroHJkQiFr0JGZpBp67fZr1OShzSCdyK8zWaEcwEtF
        k9Fy/FPUG6qdQf2bvOznuQJOi5mKyB8=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-tBKSh3JhNLuzDEg3Tud3Jg-1; Mon, 04 Jan 2021 10:05:00 -0500
X-MC-Unique: tBKSh3JhNLuzDEg3Tud3Jg-1
Received: by mail-oo1-f70.google.com with SMTP id t7so17926726oog.7
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 07:05:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HJCXspdx3i7XpaVupbHfC3QV0pRcOT5mdGPwTiDlwdE=;
        b=N776aUPeUeZNyR6VQzV9IE2UIVUnf8ORRvDwq10CkjcC3APMiYow+oo8p7TgLyF6eL
         id1+RO8KBNU21uM9W80zA3rOtXRm4RySRb8Hrkso74hMTiT27WWdIShJho3E02iRWrfz
         v+DLVd+budrKoMI4H/OsdFA/5HZYyq1piXlueXDfT+ciki7z6qm9RIfXaRs3bVh2d8sa
         W2D4LDEmGihuzLTYHe5HAF5d1xggm8MaGNv5ko1w/j9G+DJA7qOYjv13Koe1pbd7OxLj
         /kZsQhdRxS+AEB+lB7He/0BMQAU1UjEwGdoCIYKw/b9IJ051B14k+2xQ1MZD2M9BZhj2
         GINw==
X-Gm-Message-State: AOAM532qbRsC6vXyOGH9GdOJDuTQQldY7u3L/sgXm+VoKdLHHynp+quD
        5z9GXKtQ/l3+k9dBpLHD1o0OUvHSCcKFdSj5sghDnT6j4y3yl0aqefrCyB8uqDLyMESkRUP2V5W
        8DkN1Nxgw+OljXCxv
X-Received: by 2002:a9d:64c1:: with SMTP id n1mr51855311otl.60.1609772699868;
        Mon, 04 Jan 2021 07:04:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRUyG0GxwJQKg/9AhApCUjQKPMjtQeX3Pa9tD8Ye6bDk9lTcVUwDMwWhwRkyqjr4LTotHyGQ==
X-Received: by 2002:a9d:64c1:: with SMTP id n1mr51855294otl.60.1609772699720;
        Mon, 04 Jan 2021 07:04:59 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t186sm13461368oif.1.2021.01.04.07.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 07:04:59 -0800 (PST)
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in
 rxrpc_read()
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20201229173916.1459499-1-trix@redhat.com>
 <259549.1609764646@warthog.procyon.org.uk>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c2cc898d-171a-25da-c565-48f57d407777@redhat.com>
Date:   Mon, 4 Jan 2021 07:04:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <259549.1609764646@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/4/21 4:50 AM, David Howells wrote:
> trix@redhat.com wrote:
>
>> -		switch (token->security_index) {
>> -		case RXRPC_SECURITY_RXKAD:
>> ...
>> -		switch (token->security_index) {
>> -		case RXRPC_SECURITY_RXKAD:
> These switches need to be kept.  There's another security type on the way.
> See:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-rxgk
>
> for example.  I'll have a look later.

Yes, looks like more stuff is coming.

Thanks!

Tom

> David
>

