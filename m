Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA052C3DF1
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgKYKiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:38:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbgKYKh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606300678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ua750XKo4C3zqyftxqoSrxLWZtUtIaffcWgO6bLYLvo=;
        b=Ku3fLj6KgusVGO5kukB6m++oFmzLnBc6XhqEuS3pR9JftbMmq4VZBpw0irnX1SI3O+xWZP
        iIAtr7BpjPj8y/eraaPxyLPrOl+D820TSRySGgF0fU+tWYpe+00o/bXPuSW9fnVaqjrGkO
        8CwajZDAPhXRD50BZgLpZnX3CuS93uQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-jBzhbVIuO8O4Ee2cTIFOOA-1; Wed, 25 Nov 2020 05:37:56 -0500
X-MC-Unique: jBzhbVIuO8O4Ee2cTIFOOA-1
Received: by mail-wm1-f71.google.com with SMTP id d2so618863wmd.8
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 02:37:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ua750XKo4C3zqyftxqoSrxLWZtUtIaffcWgO6bLYLvo=;
        b=Ox1M9Fm7iKo2NQeLehyT+mB5fqv/9L5ihod8vAdjZLrDQEGcwsh5jiJOIs2ptw9NbH
         Oo48Ixblo+OekgS4f6GmTtwjULrf+nSW0mPN/8uH86JtmyVBvUCaXt2r8Smk+OzBY6Pn
         7KWJ8yKpjZzTaACidx4lzYVTppPYDfJKaMq/gMKjL1I7H3TpQVXrdk5GMTLjngbuM6Sw
         BOz8amwKBYUrufgcXu8IB2s5RI6qqmQ/lrhcouzG7oOwm8A7PGp0adtT+ZilatDoxZhU
         T/y/1BtiFft3e2sLqCzMUGwDCqRsTe4drDWUef3PJi/hFmZLkxcRtf+SV6qektmstph/
         aTCg==
X-Gm-Message-State: AOAM531mcJPIMhZivvrQVN7bqirPhIOGdu5h35wh5+xxNDYM9hOXLC0Q
        aOVm1Y1Pm2mU4OkvlMpXDQakGxzB5QgYgWfGYBLC8T0OGl5we1s37swq3ZTo9s6jlw1Nqe+f5p1
        gdblgRScmIuGoHkvk
X-Received: by 2002:a7b:c0c2:: with SMTP id s2mr3154428wmh.78.1606300675068;
        Wed, 25 Nov 2020 02:37:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhCf7x9F8vPp0X2oM8cLmrqxwsTKyId8SN7ae0Wio1a6UgklkW8aRDsqWIYN1ocro09VwmLQ==
X-Received: by 2002:a7b:c0c2:: with SMTP id s2mr3154382wmh.78.1606300674615;
        Wed, 25 Nov 2020 02:37:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b14sm3961773wrq.47.2020.11.25.02.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 02:37:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 996BD183065; Wed, 25 Nov 2020 11:37:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, f.fainelli@gmail.com,
        andrea.mayer@uniroma2.it, dsahern@gmail.com,
        stephen@networkplumber.org, ast@kernel.org
Subject: Re: [PATCH net v2] Documentation: netdev-FAQ: suggest how to post
 co-dependent series
In-Reply-To: <20201124.204723.2063364355702441857.davem@davemloft.net>
References: <20201125041524.190170-1-kuba@kernel.org>
 <20201124.204723.2063364355702441857.davem@davemloft.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Nov 2020 11:37:53 +0100
Message-ID: <87wny9lo1q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>David Miller <davem@davemloft.net> writes:

> From: Jakub Kicinski <kuba@kernel.org>
> Date: Tue, 24 Nov 2020 20:15:24 -0800
>
>> Make an explicit suggestion how to post user space side of kernel
>> patches to avoid reposts when patchwork groups the wrong patches.
>> 
>> v2: mention the cases unlike iproute2 explicitly
>> 
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Applied, thanks!!

W000t! Welcome back Davem - we missed you! :)

-Toke

