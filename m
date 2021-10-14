Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561742D1B1
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhJNEpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:45:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04848C061570;
        Wed, 13 Oct 2021 21:43:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y30so2602326edi.0;
        Wed, 13 Oct 2021 21:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8LPaw5+M3luGOVH1M1qUxYbUAN1VHa4xoL3FVlaU0qc=;
        b=MFquGC9VtUKw8pTBgsPsfZDGIu9cYGc4JldmzyNsgdWqmhc/zctDSXxMlASUM133+6
         cXBXs89qeGqUI5Qzrj4kMjK7tAJMUKzW46AiAsr/A5FHnS2I2DVQW1VZhrH58ElyC/qz
         RHix/4VoZPx/C4k171vUR1Yvrim1ADZU0M2tqUik+ZVxOFoqfn8sR+eUbpClNd+PmjRZ
         p8aYhZ9s+GDvprc1//1oTQfQMNdvUbFDvkC8QnmW9PgFnaAXaW8efJq1umQQfyLJ0FT+
         3dJzbsNEbRLxXS1F3YrMZIweVLzGeKcAOf4iI12C70z6Mu8CUsGU8QqSLEAZ6Xfe7P8i
         lGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8LPaw5+M3luGOVH1M1qUxYbUAN1VHa4xoL3FVlaU0qc=;
        b=4wngAwIzwvTE3Qf7AApm9nzcTj9QKBfM2o2AHZD8PWcWzB9lBca9oASagk5Vr1DIdn
         VBxThBvhtBxkN+hAF6i7exC22fgBMIoBhVz+8Bwm116eQMvQwxz4buVJpoiF86HeC+Ep
         UlVu5zLYaj9Am7p4KLDViI1tPjmRnemuihjW0/0VUGoGAL8YkuUVd0LFzB4KhzdeY4fO
         vmh5zwYLCQNQw3Kgc/sKPkzFc7e4jRVPYk6RnQnW5khs7b31LR19hOP3DU12YJnS/Db+
         hoB8uxy0GtKORkJoucJqOAO4QKqa2P1xWeUSXT5a91A79it6SbHernF7ywsVgd7RSps/
         hunQ==
X-Gm-Message-State: AOAM533ub0ZpqrEc8HRbteMkuQc+hsmx3x2aZJxjOW5yvczAuFYo+BMC
        BHYAPDfvmIrmUVbJ7HTljzomPpzBju5RMDA8
X-Google-Smtp-Source: ABdhPJyz3OfW6aowvh4DiAwX9JLEogf5euDIwW9BIUV2E+zePjUtqGQaIGHRZ3c8bksJbAdDiQYJEg==
X-Received: by 2002:a05:6402:50d4:: with SMTP id h20mr5444213edb.112.1634186594587;
        Wed, 13 Oct 2021 21:43:14 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:2cc6:c762:3ced:180f? ([2a04:241e:501:3800:2cc6:c762:3ced:180f])
        by smtp.gmail.com with ESMTPSA id s7sm1206140edw.67.2021.10.13.21.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 21:43:14 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <9eb867a3751ee4213d8019139cf1af42570e9e91.1634107317.git.cdleonard@gmail.com>
 <7d8f3de1-d093-c013-88c4-3cff8c7bc012@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <bc702545-175d-9de8-e131-839efbcb4492@gmail.com>
Date:   Thu, 14 Oct 2021 07:43:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7d8f3de1-d093-c013-88c4-3cff8c7bc012@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 6:09 AM, David Ahern wrote:
> On 10/13/21 12:50 AM, Leonard Crestez wrote:
>> Multiple VRFs are generally meant to be "separate" but right now md5
>> keys for the default VRF also affect connections inside VRFs if the IP
>> addresses happen to overlap.
>>
>> So far the combination of TCP_MD5SIG_IFINDEX with tcpm_ifindex == 0
> 
> TCP_MD5SIG_IFINDEX does not exist in net-next and it was not added by
> patch 1 or this patch.

Commit message is wrong, it should refer to TCP_MD5SIG_FLAG_IFINDEX.

--
Regards,
Leonard
