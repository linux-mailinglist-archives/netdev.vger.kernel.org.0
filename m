Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA017E0FEC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388558AbfJWCJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:09:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35481 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731549AbfJWCJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:09:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id c8so6333969pgb.2
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 19:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SP8UUm3dF6yvDYfWvbOHW69XODY0NYkr2uyxdjbxRD8=;
        b=kGRwuDXkoZTJp0LD3o3S2mwXAxyMVQ4u4/YVRLZvXxFothO4uBpGHKu7IAQDkKSs+F
         zjl59a95kLHccNtF6Hh1HzD4bcdjOD6pA9WdHE+/ujuRqxCrd6r5fBBttUDQ9R5DnG0Z
         HBqENZoKV1klmqVECFNMleX41hFy4wgp/QW3Bd6j4wzcsBg7iN6oJcCux0f+Fx2g3EXy
         6DPP6l7K+3HHeckOkEKxbDmOstYDtlzozk+q0LwzwCfBX2Nq7tKPaHwhtm7EmOEyHySx
         pfEEUOo1ClDd3ZOXMJDdP5utSHqPZAAiKFpZVr1bXrsxjaTC5izI66g5uIsfB5VFEPX/
         7FwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SP8UUm3dF6yvDYfWvbOHW69XODY0NYkr2uyxdjbxRD8=;
        b=LumnBzQQtFpXYYrXfIm/hwtqZ9atnxgfKBzOFIwjUo6x7QQNv5/92h+91vwLWqPXrV
         vfb7M0Viw6MZc6SxVeXUQzUlNXCSdSe0IuFC9wL0k+NnTJljUjpYSvLug7jWdHtwYzmi
         11ngqjtHyv5Qr1Ki/kneZbDAUdC0shZ2vfOg8WKC3Pz7o0rOf8OhfYehpiwTDIWmTpJ+
         lRDRXQ57O90BI9RtAYpEOcvjGLeHWqHR12hHlp7iovuY4U26JB2CGO57JB1LeUMn1pu+
         g/A+pLLWV0CPupTlb0xoKT3iOO7P17FxVcB+37fpEbvHSNpBa2OIGM1I/9yhDTh2MxBY
         yB6Q==
X-Gm-Message-State: APjAAAU/g5Zf+v5LfQwEWnaFu1WsnPsRRFP6mimEp87qNzOIOdSe2mp6
        djDmMxAtpm1kFhAoQhqFxQ+VgG0snJMC3g==
X-Google-Smtp-Source: APXvYqyQ4yHvXkIJqQ+Vr/Gob9yi4o8okBCD8ZrKjZmHQrYiWAlbbYkfy+whjIsnp/nZixGZL0k5Xg==
X-Received: by 2002:a17:90a:9701:: with SMTP id x1mr8232505pjo.35.1571796582893;
        Tue, 22 Oct 2019 19:09:42 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x12sm19682581pfm.130.2019.10.22.19.09.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 19:09:42 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] ionic: reverse an interrupt coalesce
 calculation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20191022203113.30015-1-snelson@pensando.io>
 <20191022203113.30015-3-snelson@pensando.io> <20191023012225.GJ5707@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a81e4f85-68db-555d-047d-b6d6f5997b68@pensando.io>
Date:   Tue, 22 Oct 2019 19:09:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023012225.GJ5707@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/19 6:22 PM, Andrew Lunn wrote:
> On Tue, Oct 22, 2019 at 01:31:09PM -0700, Shannon Nelson wrote:
>> Fix the initial interrupt coalesce usec-to-hw setting
>> to actually be usec-to-hw.
>>
>> Fixes: 780eded34ccc ("ionic: report users coalesce request")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Hi Shannon
>
> How bad is this? Should it be backported? If so, you should send it as
> a separate patch for net.
>
>    Andrew

Well, it doesn't "break" anything, but it does end up initializing the 
coalesce value to 0, aka turns it off.  The easy work-around is for the 
user to set a new value, then all is well.  However, since v5.4 is 
intended as an LTS, this probably should get promoted into net.  If 
there aren't many other comments, I'll likely turn this around tomorrow 
afternoon.

sln

