Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE29C3808FB
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhENLzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhENLzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:55:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF923C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:54:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id e11so24000068ljn.13
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=8ftyhHaLQlrKLVpQEp2/pJGZAd+54SlDwp2QqTwq9UA=;
        b=IO403FuNIkDo/g1XXo9ktecceheTLZS0lSz60dT7gW9eDqLZVEVH+y4UpwEy2vkaS4
         vJfT0N4/eX+SgE8ODPkaB+wFI1qNhaj47tbqTFyH6kJtoT/tDtTHZc8WTB9zCjQahKuF
         fYnly/tbWHBr+lXnKXT0BIoV/QJW9oCdJX3RqJCKHnkcAdMVXfKEV8UZiJHoldSBQNZE
         C8boYtk+/wTeoo7h3aCUM2ps6kZaR2E7X3I9ROeVQCLSnIiBoK3x3Sa/Bjhix+UQyRmq
         u9vrUgdnIrZs3mr8B75ssOBlUiGbBOJZFATlacYKoRPlzcPk9aT3l+1UXbPKEdym2QJV
         JeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=8ftyhHaLQlrKLVpQEp2/pJGZAd+54SlDwp2QqTwq9UA=;
        b=N3YE9cASL6ty4uVE/YdRX6ZW+U6C+Nv0iQjJgMC7PepbD4w3PcezY3yqQt51BxNILi
         0OTE3NBDNSROT498izh/JmuNShPloJjSqDZ9gyTo1svb3Cdwgi2nsHT6jKtqtCTbDIct
         mMuJUGe7vj9Fu5sTBq759JqaJVG9BpBtiTHbjBww1V3tOw2ceTxSe5IGF0mE/lo333DH
         /tboeTvlq2/M3OnFrLS4MjrgoYrFO1yYek3nXqRgc+4MfJKJnv2C9lOLp3pmTDyZVbYo
         I4aCUErsskbInWqjfZmQWUAbaCanZiD/ru3oniO2FzYnVABalYx7NBP85Ik2Qc0rbbI+
         Pg/g==
X-Gm-Message-State: AOAM530+VvgK28cqLKJMftvleQTlwLT4K6rN+TAI4cEbg1UFoS8x2nzS
        S8U8CWNi9l0d6oJqll83VXg=
X-Google-Smtp-Source: ABdhPJyBVt2AC4BuvtZ68ZVQ+5f9HxrsGWJixEsZFZQ+R4elRDSrspsSKsmSBbBI/FEOW8H50DPt7g==
X-Received: by 2002:a2e:9e53:: with SMTP id g19mr39017457ljk.58.1620993281310;
        Fri, 14 May 2021 04:54:41 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id w16sm663127lfn.183.2021.05.14.04.54.40
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 14 May 2021 04:54:40 -0700 (PDT)
Message-ID: <609E674B.4090702@gmail.com>
Date:   Fri, 14 May 2021 15:04:27 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] alx: use fine-grained locking instead of RTNL
References: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>     <609E5817.8090000@gmail.com> (sfid-20210514_124949_830593_01576FC8) <8e2a8567d79141f8f5cb180be656efb378dcfee8.camel@sipsolutions.net>
In-Reply-To: <8e2a8567d79141f8f5cb180be656efb378dcfee8.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

14.05.2021 14:22, Johannes Berg:
[...]
> I clearly missed it, somebody already picked up on it:
>
> https://lore.kernel.org/r/20210514082405.91011-1-pulehui@huawei.com

Ah, ok, that is exactly what I was going to do, thanks.


Regards,
Nikolai


> johannes
>
>
