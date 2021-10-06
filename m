Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE38424040
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhJFOkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbhJFOkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:40:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842B1C061753;
        Wed,  6 Oct 2021 07:38:13 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l13so3115625ilo.3;
        Wed, 06 Oct 2021 07:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CSSBjioT811JzS1znIx4dYSP233jP9Xi4BIXpz1np+k=;
        b=Stl+xEwr/IUWbcuWcgW8epJPTDKsm4qcqX9O5xfmmSt9Nad9eM8dRdqRqREvpQ+Ltz
         WsoEb7msTF5mLMDAq1/ZhGQz5z27knVzAzGEyL6162x9fPqqLsnvIZEN095NAr9Sf0TC
         ADdh5f9Wk0hEIMYNf37ISSuytz1jkDpoH/cioZmpaZvDaTQGjkifZHfZ5UO7Grg5QUOG
         GVSGkomzcYxWGn0mp62L9vNijTUtUA36CqukKAOrv+YBWqNuuGU5SbDmSSzVbKm/9syV
         fz1CoNzpL22LCPj7kaeYg6ch//30gyeOhLkFlSs/JQMSjfN4lxjXuCtoR+YV65IW/Sim
         MFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CSSBjioT811JzS1znIx4dYSP233jP9Xi4BIXpz1np+k=;
        b=7W04i7dG0pMgI7gjC2LnW8LhjXiwDPrqZlUbi8oEf35VDpl0Zwn0uPta8Vz2ccytVm
         NduhowxFENI8RDzhl+s4FKEeKl2oc8ZahI4OPQi6i++bWPUWMKPfOzOOQCc2XRnqqpxH
         h7ix4Vyev9VeW27obom8lTk088v+KtKlXVjAwKnDOHHZ4LW19ZWfrimpDSO/JYdVEHvm
         roUkcYB2a+Qt1m0kLzbzJ8HNki+R5ws+PNWhv16Qxw2NiY7rGl71eNapHR6CN92s8ThW
         PbCnarhFh2QiAMW52TwQiFEHXfGdhnLJ7m0zXVktDQpp3hfCy08fBr0nkmLP7cRIEuoX
         IC7Q==
X-Gm-Message-State: AOAM532jVk9zouCKamL3KtS8oiPdb/3VCie8O9Zct9OzYEHqq3bWO8bI
        cLwHfRtLkVYc4Vsh091sMfmVAGL59nA03Q==
X-Google-Smtp-Source: ABdhPJy0FxhJ1bmrOEPLVWSjdMyhQQEGrgR7XTnsSdV3aFaDmPBQfRjLLfiwG4CkchJHSAGlwxy/Jw==
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr7357103ilh.170.1633531092889;
        Wed, 06 Oct 2021 07:38:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id t5sm1054005ilp.84.2021.10.06.07.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:38:12 -0700 (PDT)
Subject: Re: [PATCH 04/11] selftests: net/fcnal: Use accept_dad=0 to avoid
 setup sleep
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <9cfeec9f336bf6f5fe06309526820e9bbbc87ea3.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b7b60c7f-2d79-26a2-3eb1-ef1e68ff3e8b@gmail.com>
Date:   Wed, 6 Oct 2021 08:38:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9cfeec9f336bf6f5fe06309526820e9bbbc87ea3.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Duplicate Address Detection makes ipv6 addresses unavailable for a short
> period after adding (average about 1 second). Adding sleep statements
> avoid this but since all addresses in the test environment are
> controlled from the same source we can just disable DAD for the entire
> namespace.
> 
> Unlike sprinkling nodad to all ipv6 address additions this also skips
> DAD for link-local-addresses.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


