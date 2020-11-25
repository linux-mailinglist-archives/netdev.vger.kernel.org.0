Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C872C3841
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgKYEqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKYEqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:46:35 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F254CC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:46:34 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id o8so893570ioh.0
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Knd1cDyIgtm5Dpf4DrlkwhRja2537TYHQQ96VvPziuw=;
        b=hb3NYwCMHgTaF1BfEWYY/sj744Bb1WjgW16Nd/1i3lhZ3lT/kbOh9J3dBl6xltF5wx
         siC3jX7OwXaEPerveu+6/N1U7ASNIST/C/qhcVkfioewc6BNHtrpc9o4/87YVktzjI31
         PlcVKuSUG3Y3/9VXb8HyuhmQ9sRKBUcRWhzpadOIsH/zU2ubUvU5pt2RjagE0xRVd2bn
         cxnoKZeDfxgQ829XXYMz0Coivt+O5Lw+CqLPonTWd9qUE5weGwK/6xMCyBECWkYgvMS+
         TGQSxyVoghvsHDSGjMSNaTkT4gUBRU595afMq8CsbdiBCTpwyuDwROfFr27mz2IUbXWk
         m+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Knd1cDyIgtm5Dpf4DrlkwhRja2537TYHQQ96VvPziuw=;
        b=KqhjJvbZuQbYIF/o1zsW8XboYJCUa7fhl/zIjBypEcPRps+jf9hmVSorrVl0zdH3LX
         kgXh5q6rHOF46O8WiZI/weHrG7k0jRWURjXeFMBDAl7KiJYBHXnccsfJQba500hb/Hjh
         qWmsxFe3QfpwFss9fH/cYzmqq3Ty2iAUQcXrEVNgaTvWbD5w7ldRUyEjLO0BWs+dtnjU
         h1LZNmOqUfNcVQPRnsonFsAg7Hv1Nfl4XCKw+Gf1VFFcBPSQO7ZJauADThpWcmQTeVlk
         C/uduNo7Dx2I5iLgTiVUzJ59soliukFxw+yw1LVu/hF6v8gtsQh691HbrDePidHCkSFC
         DohQ==
X-Gm-Message-State: AOAM5307cOVVYRK6Br9zRCdXaBBiHN0Dhv6k0YOz/FPKpU1HX+aaaQZM
        Zmtp8/j0GN0Bpv3niS65TJg=
X-Google-Smtp-Source: ABdhPJxYl0eij+ac/7QiBBLo7eY0FCWjISLtVAj3tiPXgkkT5fnjbanA7qvG6q42IWSnCxew52Moxg==
X-Received: by 2002:a02:920c:: with SMTP id x12mr1820908jag.112.1606279594423;
        Tue, 24 Nov 2020 20:46:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id x23sm409641ioh.28.2020.11.24.20.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 20:46:33 -0800 (PST)
Subject: Re: [PATCH iproute2-next 1/1] tc flower: fix parsing vlan_id and
 vlan_prio
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        zahari.doychev@linux.com, jianbol@mellanox.com, jhs@mojatatu.com
References: <20201124122810.46790-1-roid@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a14b103a-b0c3-fe25-7346-a841990bb71f@gmail.com>
Date:   Tue, 24 Nov 2020 21:46:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124122810.46790-1-roid@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 5:28 AM, Roi Dayan wrote:
> When protocol is vlan then eth_type is set to the vlan eth type.
> So when parsing vlan_id and vlan_prio need to check tc_proto
> is vlan and not eth_type.
> 
> Fixes: 4c551369e083 ("tc flower: use right ethertype in icmp/arp parsing")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  tc/f_flower.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

applied. Thanks for the fix.

