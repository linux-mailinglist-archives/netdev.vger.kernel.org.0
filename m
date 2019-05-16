Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E12A20CB1
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEPQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:14:35 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:42447 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfEPQOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:14:34 -0400
Received: by mail-pf1-f177.google.com with SMTP id 13so2086422pfw.9
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7XoLVRfjhS6S8Tt3recnd89lCBfS8aQbdPBxOjAwbsk=;
        b=ZrvE9x9+Db23eixcDEP36c66jpEy9/u3uwwuyrWdAs2qSCBsVvXLV7qGQvPMS01nDZ
         J+ebdedOXsbKFoUEFUGAPFrLhEpmdE/2JLbJWTLFLbEf2+2XCSGm7r8ILYJ0n+XgKd/I
         QIBXzHsr+dqVQ+XJ+nS6bakJsQkZKd4/WCwjZILmNqEd3eKA6twTlKDjPAsmyv558DtG
         IXYLrQEQh/vO1tGkvlOXg27GSmkXKbuNbnjwy/BonAykqtvGzV7K6i4k9oMWo5Nycnbl
         cnuUx5CiSnUNR2PGQgPnKN8pFSb2r2OtLRE7OgESRLlGkXzu7JvJv+OxToGHvMQ1UZCU
         vLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7XoLVRfjhS6S8Tt3recnd89lCBfS8aQbdPBxOjAwbsk=;
        b=T+wX8VzXR3DPKpQvCR6bECiuKYgVEc2VGbWFFy9eGn3p2Fxs+inoC+Aw2BtmeJzGPq
         hwyCzucph/X1IwfKb+1dpZTz0lo5t7C0YScOLtqWfx92rkAFXUEHmaNpvngKBbZJk5Tf
         KS7d1UY6fClOvcyBCkfkdtkprd6+dlNJr5RhVoj6/1JgmrWzXMljmwqHrP+BYrAvNszc
         U+UHi6xUZdLp9y3OYEJiBC0k92uPHGDNiYVxXN1HeCHRIudwVwCMeA4pxyH9QAwm+J9e
         auDuSgEar7HWZCXmJ5l1DF5a+ykZ50m3K1jfpsEwS4IHPYE6CzMIKBvw+EW2Fh9zMblA
         mVHQ==
X-Gm-Message-State: APjAAAWbaLldsjaLwC1wwQ3CtT7nT9WR7AZ4ui4aT3duCqe/G/Flq5qo
        6aEwXQdd043MaE5obkEuDalgrdth
X-Google-Smtp-Source: APXvYqxmxmLMIchDHIrlj+bj9dc1ZxEaCWZ/A3iUOgaV/+PszOso9tQE+qXjRV20mSUrF2KEfXPEZw==
X-Received: by 2002:a63:dc09:: with SMTP id s9mr9711281pgg.425.1558023273668;
        Thu, 16 May 2019 09:14:33 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q4sm7366580pgb.39.2019.05.16.09.14.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 09:14:33 -0700 (PDT)
Subject: Re: Kernel UDP behavior with missing destinations
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Adam Urban <adam.urban@appleguru.org>
Cc:     Network Development <netdev@vger.kernel.org>
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
Message-ID: <18aefee7-4c47-d330-c6c1-7d1442551fa6@gmail.com>
Date:   Thu, 16 May 2019 09:14:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/19 9:05 AM, Eric Dumazet wrote:

> We probably should add a ttl on arp queues.
> 
> neigh_probe() could do that quite easily.
> 

Adam, all you need to do is to increase UDP socket sndbuf.

Either by increasing /proc/sys/net/core/wmem_default

or using setsockopt( ... SO_SNDBUF ... )

