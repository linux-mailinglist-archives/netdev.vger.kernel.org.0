Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798F423D1A0
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgHEUDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgHEQhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:37:09 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E4AC00868E;
        Wed,  5 Aug 2020 09:37:03 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g26so42294135qka.3;
        Wed, 05 Aug 2020 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g8oBzmcJiwGUXDvGcXm/0jru3TFpb5KAGIgwrDHVYC8=;
        b=KBWDn9ItSVNc/Jo8C2TLo2d2SEBDpW+HtxikoK/wOOY/mZh9tUYIYjj/uswXH6qy5w
         8nYeqNNVOoQZQyqnWEKsi6y1jLlwl6N8V4Kk5dMr8lGik9Yev4DbnpaYOqRuJg+Logxv
         eaVWwobIifXbVWAI0sxtrwc0CLJRsswu3/ZdeeZ04bD1FMXgqtG4ALd4f7WEJY+0bsa8
         1GqfxQyatbsNL0hjud1ZZlRCIe59Jtnkn2Eccfbgyg4G4pWNS0OWG8BKfy+PGbWSbHz4
         J+Wd0i+hyS9MDfNNFUc+u1u8EtIllN2jVoU8Ap1Qgl43YSFTBJzs3DVrJzbbyfFpgs8N
         H9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g8oBzmcJiwGUXDvGcXm/0jru3TFpb5KAGIgwrDHVYC8=;
        b=iuXjceHfxYS/t0fm/z5yJ1KUYTQRm1vvc934g9d9mDhuL1Sz0QulZo+6MS26OLX/3k
         Bxk542KCSbsqTEpZVD9NdJ/D5h5zd0uRTb1FN9cuHsisynkO8hxUtNq4olwNGJccjK/0
         flEGCv9ICHwU187sCe8V1/VPjXDDXUCNC/roZnRqM9+LGuBsHfXO609PlEbLBrLxMenH
         gS1qY+OE6uBEzGKRmDHIyr+z5ciGzR8QBWA639x8PkNrmaLMBvuDJo5cGzILf0D0n13n
         x3UpHoYrEJCjcuni30FYwaeoM+4WNAcK/t3ZG+y0hCl1MfbEFsM1HlKpueqkHSBB4BLK
         dI9A==
X-Gm-Message-State: AOAM530bsY7JwZ+1tSUWvRngDALGyx0CD5VPgGnVmj2SXS11L1CpI2i/
        ho3wYXNOZZKNAl80snbt6dlxFjpl
X-Google-Smtp-Source: ABdhPJyWF6j527vZYqsLimWvbwOHtw6EfuxOOrLaZwDoO0Xy2t721e+FtIEEjwxmg8MVztY6/8nodQ==
X-Received: by 2002:a37:90e:: with SMTP id 14mr4299966qkj.102.1596645422525;
        Wed, 05 Aug 2020 09:37:02 -0700 (PDT)
Received: from [10.254.6.29] ([162.243.188.133])
        by smtp.googlemail.com with ESMTPSA id h24sm1971156qkk.72.2020.08.05.09.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:37:01 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 0/3] Add a new bpf helper for FDB lookup
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, bpf@vger.kernel.org
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <5f2492aedba05_54fa2b1d9fe285b42d@john-XPS-13-9370.notmuch>
 <E2A7CC68-9235-4E97-9532-66D61A6B8965@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8eda2f23-f526-bd56-b6ac-0d7ae82444b5@gmail.com>
Date:   Wed, 5 Aug 2020 10:36:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <E2A7CC68-9235-4E97-9532-66D61A6B8965@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/20 4:26 AM, Yoshiki Komachi wrote:
>>
>> Just to clarify for myself. I expect that with just the helpers here
>> we should only expect static configurations to work, e.g. any learning
>> and/or aging is not likely to work if we do redirects in the XDP path.
> 
> As you described above, learning and aging don’t work at this point. 
> 
> IMO, another helper for learning will be required to fill the requirements.
> I guess that the helper will enable us to use the aging feature as well
> because the aging is the functionality of bridge fdb.

One option is to have a flag that bumps the ageing on successful lookup
and do that in 1 call. You will already have access to the fdb entry.


