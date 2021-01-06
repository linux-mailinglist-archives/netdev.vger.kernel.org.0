Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57522EC60F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbhAFWKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:10:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbhAFWKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609970949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xTfqp/cnQanwSVgtCnzk15O1tB24PFg3CJKydXU40A=;
        b=Mgok3LkaKysddMHK1bYfmDUNHeQH6MYMsNOu0cblHJiMlY03RgOmwEiaLSGvVsXblzgLvc
        Rxjzb/hulTVNndf/N9VpTt1GPdR2Xv8zAsJQQ2xrkcgBoiJtXpDpGd7tNrLKpEyMy3g7Rh
        tfNk5UzjfasLhPRXAiq50uxZr8r2h+E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-trxajAdwM_-xeiavnH-SBw-1; Wed, 06 Jan 2021 17:09:08 -0500
X-MC-Unique: trxajAdwM_-xeiavnH-SBw-1
Received: by mail-pj1-f72.google.com with SMTP id gt6so2643090pjb.7
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5xTfqp/cnQanwSVgtCnzk15O1tB24PFg3CJKydXU40A=;
        b=Dg4YW4VVy6k9Rr1uiOWv3X8E8r6fwx/uiVR+7U5yfeVnFQHeS9Z5rpkJeno1cpDugT
         uc75pRpb6plgzHYrZAOfpHHt6rZDcqo/9DJV51XpH1vzJstHKxC/xtx3+eX8uv8P8YUN
         3x41/zvpx0HOlZgC7vPBDH7iWkvbD4vtubQe7EdQhofdawxxlYs5ArKqjhd0O94HDQh1
         /Hj2xo+Rikgbg0mISnFAL0gQ7VNSEFSeYqlt/1ctKIp7bM8d6naRLlsMshhnLAF1G3OA
         rroGNwFhtVxeiMJLySNkWAlRLs7KtEbEDtKt7GINYZ3AEJxDdmEJ5HMWmfskNwxL0miw
         mYcA==
X-Gm-Message-State: AOAM532UBUu6Ai57kEpyW7P6sEE25ktcNhP1/gwJIg9II3BLWsHp+W6F
        /J41dNLzrq9i6FVWVZ0qm3Txc1SBz0xFoHrKJ7uwP8NP/lcQASWfRQE6wO+DTe8fJcFXKdXZKFh
        38iNPI1OoVSC5zkRr
X-Received: by 2002:a17:902:6b84:b029:dc:3423:a24a with SMTP id p4-20020a1709026b84b02900dc3423a24amr6329248plk.31.1609970947117;
        Wed, 06 Jan 2021 14:09:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXv6R1GMOq6pMfQ3fEim+tdu83D/aaUaUjNmnRljgB/CqQ96fR/ozt43mntG38d1hbdQgXaA==
X-Received: by 2002:a17:902:6b84:b029:dc:3423:a24a with SMTP id p4-20020a1709026b84b02900dc3423a24amr6329236plk.31.1609970946862;
        Wed, 06 Jan 2021 14:09:06 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id l7sm2978695pjy.29.2021.01.06.14.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 14:09:06 -0800 (PST)
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in
 rxrpc_read()
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <07564e3e-35d4-c5d4-fc1a-8a0e8659604e@redhat.com>
 <f02bdada-355c-97cd-bc32-f84516ddd93f@redhat.com>
 <548097.1609952225@warthog.procyon.org.uk>
 <c2cc898d-171a-25da-c565-48f57d407777@redhat.com>
 <20201229173916.1459499-1-trix@redhat.com>
 <259549.1609764646@warthog.procyon.org.uk>
 <675150.1609954812@warthog.procyon.org.uk>
 <697467.1609962267@warthog.procyon.org.uk>
 <706521.1609967368@warthog.procyon.org.uk>
From:   Tom Rix <trix@redhat.com>
Message-ID: <8db4e32e-a587-e0ab-d4a6-678cfbc7173e@redhat.com>
Date:   Wed, 6 Jan 2021 14:09:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <706521.1609967368@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/6/21 1:09 PM, David Howells wrote:
> Tom Rix <trix@redhat.com> wrote:
>
>> On 1/6/21 11:44 AM, David Howells wrote:
>>> Tom Rix <trix@redhat.com> wrote:
>>>
>>>> These two loops iterate over the same data, i believe returning here is all
>>>> that is needed.
>>> But if the first loop is made to support a new type, but the second loop is
>>> missed, it will then likely oops.  Besides, the compiler should optimise both
>>> paths together.
>> You are right, I was only considering the existing cases.
> Thanks.  Can I put that down as a Reviewed-by?

Yes, please.

Reviewed-by: Tom Rix <trix@redhat.com>

>
> David
>

