Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6613D1E32C7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbgEZWje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbgEZWje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:39:34 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9579C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:39:33 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x12so17629076qts.9
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gIHLsPQK1Aq04LsKOIUyY4fHLnn3ZZ/80D1sGjkw4qY=;
        b=P6+Us+BGRt3He4pb0JLA7JepUkPCKJEZlrJGoacfOk2J7XSo2x8KxYewJRN/ZpDGNG
         7uPXct57IXMFvFsRdzMVULYE5+UT3B+bn5Z8QKKke4C9MwkAHoXYZGTd8ptvyOM+uCdd
         TljT0OoAtZ998Bafsh3RCn2+zPjd6qKon7Lu0HFlrs0NxU6ne8ldsfEciLtcR+l7sX40
         zJqzlSwTj+Ms0QxYeXqO/SV7xf/G2T+kjESbjbTzL1t0x3jYu3gn7AIWr47HzvGVUSd9
         j2QmLk567iWQEgdgSlUXrK3Gv4C/E6mSG3AqVkDQ59qXZll5HnjhwnE1xTGQcHKwPjLI
         M4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gIHLsPQK1Aq04LsKOIUyY4fHLnn3ZZ/80D1sGjkw4qY=;
        b=dA6WiSPuVC/NMcGgPR9CjhwuK/fn0e+w5HcSHqaGk41YgUGFxF07LGkm6Eq7thMvMs
         ybW3INt3g0KDvoN+eYmHi80M/ziS+m1mPm6a8f8Dc8Cg6MyztB7MC9ruIW+qnGI894tM
         J2sbU7KS+GDqJVfhLC+tp+A4FqryT57TG32M1gaqXdMRTQMs7V6QQ69QTFwohVITQ6C3
         hVMYv3I+35c6Cwhmzocy8/CGH7YOKC45EmPAFyrvX5wl43pE5+XKgMZt81ZPYCbZYSfr
         h5aBLosb88u98G1EQeKYZeF6mJSRG9n0nd7xb6VSXvejtrRKNG1nQd3UNStsHZo1+dDc
         MMkA==
X-Gm-Message-State: AOAM532iS/jjZaxL1Mcmv63w4hamksEYBwdlKv3PoxqRN49At6VNkeQ8
        m8Js+V/MQ33lly/wM53Wi7A=
X-Google-Smtp-Source: ABdhPJzd6Zj6xLV7wQu/UgbTc/Ekl/kSM2tOoE9NB5cXhoJimfffylsQ+qJW/k4cmoAqeUIfZ7vw0Q==
X-Received: by 2002:ac8:664a:: with SMTP id j10mr1151549qtp.85.1590532773082;
        Tue, 26 May 2020 15:39:33 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id k43sm1020040qtk.67.2020.05.26.15.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:39:32 -0700 (PDT)
Subject: Re: [PATCH net 0/5] nexthops: Fix 2 fundamental flaws with nexthop
 groups
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dahern@digitalocean.com
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526.152800.1859140520396255826.davem@davemloft.net>
 <cb09aeab-9d34-6f83-5c59-d798cb6b2de7@cumulusnetworks.com>
 <1b4441b5-70ba-3462-64af-293ec3955d6e@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ffd8c2d9-1feb-34e0-0f44-35352525b362@gmail.com>
Date:   Tue, 26 May 2020 16:39:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1b4441b5-70ba-3462-64af-293ec3955d6e@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 4:37 PM, Nikolay Aleksandrov wrote:
> We can send a simple incremental against this set to fix 'em up. If David
> doesn't me beat to it, I'll send a fix tomorrow.

Leave -net as is; I think there were 4 lines with spaces instead of tabs.

I have another feature coming for the nexthop code; I can look at fixing
the whitespace issues in -next with it.
