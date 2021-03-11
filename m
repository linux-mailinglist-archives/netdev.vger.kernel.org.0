Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC2E337884
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhCKPyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbhCKPxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:53:34 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B4DC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:53:32 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id t16so1907343ott.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dUswYpHyqccxS0KQQhlM8yOq2HVLhD4ynDHGAVLoWQc=;
        b=nr4VsGHDfPu3M4Dh+Ye3Nn5ZfDgpY352z1yrE77AnKlpQzZ3HnG7bv92PsiF0W7rt5
         tYD40BCFaKf8tWiInvptv7/j+Yqcu92z7aEUivsY1+t4lEL6pVEdCgGkfK+lXYjGgwRR
         jBxPhm27VJ/5AYoFExsregCfEmT22uODqcZTVMMxPR/oegcFUDX38Cj6mgk/X5P3lB1a
         6cuH49kQhumGdjfieRQVNslz1z54xMPkLGs7QZhaveKE/DG9cYlWw5dB30Q/7B1Dwt2m
         Qhw+FSB4C1jG2YLT1SXbcxsNdOfXEfaa+2YJpG86RuMXY5YS3jH4yLIQp7fzcEjeGW02
         orcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUswYpHyqccxS0KQQhlM8yOq2HVLhD4ynDHGAVLoWQc=;
        b=rdn/0xyMUDkMEKxKodK4NIYzc4QWj94a0TpEHYcUjiotr0gFTnhFr+sWGYWvMOtMGd
         Ck64b4JUpLl26FNJK4lbyVeTUYXeK7c+UaB8Xp8X7I3MMNiDbGR/rGUA9v4ZPCvTOEQw
         7WA3YO1LQEIc/+cJkxmPeH/SMb7DGVc+HgP394bzAVAfv8VuMhjinEe1hQSLBRot5yJW
         81BDmqoGxs4j9opgDX0g50l7QRXCKnQBzS7nZ9+cSF0xd7lU8ywS6f9ZHDrjY2MDN0qf
         ZPLW9dNrRGz9KZ6MF/nnvEPLtHywaqYdkxVo86cr1hyRzH6WxOUZYhV5vXFUPy45ka8o
         1uqQ==
X-Gm-Message-State: AOAM53355mlgeBrmiUgsvXMF8e3elCQaz7gZ/6660hn1D+J0IL2x1j1U
        uYTRNIl4/YKANfbPzpVZFeSXNDfH94A=
X-Google-Smtp-Source: ABdhPJxmhzSa170i+9pnz57iBmcgQSNFcEQiUFy50H9+WTfxP81kQ7jr/Bx9FpZgNgRiK8GeqDuQ/w==
X-Received: by 2002:a9d:2cf:: with SMTP id 73mr7405401otl.28.1615478010897;
        Thu, 11 Mar 2021 07:53:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id g6sm736528otp.68.2021.03.11.07.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:53:29 -0800 (PST)
Subject: Re: [PATCH net-next 03/14] nexthop: Add a dedicated flag for
 multipath next-hop groups
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
 <5cc5ef4d-2d33-eb62-08cb-4b36357a5fd3@gmail.com> <87k0qditsu.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6c703efe-0357-e83a-f5b0-3fbba1b3228e@gmail.com>
Date:   Thu, 11 Mar 2021 08:53:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87k0qditsu.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 8:39 AM, Petr Machata wrote:
> 
> David Ahern <dsahern@gmail.com> writes:
> 
>>> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
>>> index 7bc057aee40b..5062c2c08e2b 100644
>>> --- a/include/net/nexthop.h
>>> +++ b/include/net/nexthop.h
>>> @@ -80,6 +80,7 @@ struct nh_grp_entry {
>>>  struct nh_group {
>>>  	struct nh_group		*spare; /* spare group for removals */
>>>  	u16			num_nh;
>>> +	bool			is_multipath;
>>>  	bool			mpath;
>>
>>
>> It would be good to rename the existing type 'mpath' to something else.
>> You have 'resilient' as a group type later, so maybe rename this one to
>> hash or hash_threshold.
> 
> All right, I'll send a follow-up with that.
> 

I'm fine with the rename being a followup after this patch set or as the
last patch in this set.
