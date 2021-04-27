Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE236C7BA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 16:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbhD0O2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 10:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhD0O23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 10:28:29 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FCAC061574;
        Tue, 27 Apr 2021 07:27:46 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso50667915otv.6;
        Tue, 27 Apr 2021 07:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pDlD8dE3PQv85+6B9UWHdjEhvDTr44ZFo6L5hW8IgxI=;
        b=nymKx8rWCaTxCUoWLBiey1Ja3eYYZNxjwyYZU4JnJVekgtIy2jTJrP3XCAIhYpvXAl
         nouclLvkbfpPiFrLpAvtSMDOR8ZQOKAkyFmh+q3aqLLF2mBCHgig10QSc6M+sgIHdES+
         oqFIfWVrMEJDsVwb8GeKl6ZAqq0K1r7F/DF8FyoV5xP3qmiuEluJbPFmvAE+mQ/chvaD
         lOCQjcdravRGGZOnuGLcaXEi4ysPnmEW5kBApHkPfeNk93Ernt2K+XIXOSb1ME//NKW7
         4uekRv6f6qBUuPEPjMbjNP6V/rErKJaoWUSirrxDAj/aF0Mdmf2d6wq4SfjfSzRIfrwq
         SV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pDlD8dE3PQv85+6B9UWHdjEhvDTr44ZFo6L5hW8IgxI=;
        b=pKxi8NDsZkPvLOM/aYmCigPVQG/55k0CbuCq+tk6jzlWGqiBicJ2IzdX0qU8Hxaqxs
         LNvmXgjm8a2zSUnKIavpPeVYZljCq2XCXeC5Av+JWlPk01ZsfaVYA1rA5jaSNmGSuHT/
         A+HMxrSPYiMRT2KSXlN8ny+MhjLNzCUqkm9ABPEpvDfLmG25Dp6L+Mwn8C7SZIy0lnkF
         UnC+vc75PfDekYYzr6BCMk9vnJwXIarXEBHguKB0A/jr9Mci+64absmxuZD/NeDEdnhL
         ELYQ8EWmQ0C2KgJQpjOyGc+XB3vJ7Dh1NqTZSwzu3SAGQVgktj/mdlCdHReMRSapvIUL
         lLhA==
X-Gm-Message-State: AOAM533lb6jLUQy2SvbIgQz/mn6+0VfjKi38v6TngVWscvGbj8BYj7Aa
        9uCftKZsqbuIuQBCwIcXGl3P0hqiQdE=
X-Google-Smtp-Source: ABdhPJzX7952fFjCSOBmVsoK8xx88i5GIPaHXhKrnfQP26kXrVYS8acHATF5aTVU6vuBagOYLi5L9w==
X-Received: by 2002:a9d:3a44:: with SMTP id j62mr552630otc.176.1619533665967;
        Tue, 27 Apr 2021 07:27:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id n105sm198ota.45.2021.04.27.07.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 07:27:45 -0700 (PDT)
Subject: Re: [PATCH v4 net-next] net: multipath routing: configurable seed
To:     Pavel Balaev <mail@void.so>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
References: <YILPPCyMjlnhPmEN@rnd>
 <93ca6644-fc5a-0977-db7d-16779ebd320c@gmail.com> <YIfcfEiym5PKAe0w@rnd>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e5e46b25-065f-7c56-3c31-6b9cc130510d@gmail.com>
Date:   Tue, 27 Apr 2021 08:27:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIfcfEiym5PKAe0w@rnd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/21 3:42 AM, Pavel Balaev wrote:
> After running "scripts/checkpatch.pl" I got warnings about alignment.
> So I run checkpatch.pl --fix and fixed alignment as a script did.
> So warnings goes away. I don't get the rules of alignment, can you 
> tell me the right way?

I don't see any statements under Documentation/process; not sure where
it is explicitly stated. You can get the general idea by following the
surrounding code and then let checkpatch correct from there.
