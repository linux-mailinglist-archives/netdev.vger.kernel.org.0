Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4965A286C69
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 03:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgJHBk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 21:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgJHBk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 21:40:26 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B58C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 18:40:25 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id q136so3491840oic.8
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 18:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5EFkwolMPoTL6IFy8lCqf97JhpfTbozFKe6A6aPtqLU=;
        b=GSCSTqV4csKv6Upl9Dc1dLH6OcTVIEcUKZ3iaw3ULo9BKA9c0uW/xwk2CW927ptO9f
         seOHKOzzDpgYgIsIvRrBFSX7ZAkohNlbDcwJ+WOCd6kTgL604NGxlXVK4QHrCQUQxpQM
         reYr+oWZOQqx5EYVdxztP2mmduNzgOY98/T+lK3PuLyX7rsaGshPZfn8VelOJhqHovUL
         gcJ8AbLWcPMFuXfq8dVBNxeH39ISEF1zkIyaMamUos8kZAe7uUmziXQ7XVjrWgMx3dAM
         Fr+MBs/+VTTayc/DMjNjvnvzHHyzL+8EMncNtkFZXppJcskPgy24dWcBtUUV6QeWDA7y
         E1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5EFkwolMPoTL6IFy8lCqf97JhpfTbozFKe6A6aPtqLU=;
        b=rowGw4Quy8/rYvSV/SHMUuHTfp7iT06eoL3cWmjhphQ30BhKvRyqNgsQR1ypsQd6YR
         d3t5BuKKLX6cRUMrge8Xy9kTvl8yECE1WDN4H3+cSl0j5M5HDz1+SGR4aL3HwO4/pLCG
         pa97LisJc7Mb2zq9ep+SFW/i42gN23n/Ej+kTDan1pQtFduK3SOVp7uGGIZgSmTKmRgM
         98NqXAGm3qRr2jkYGI/AeNkXvbgw4JkOHeCiavkm3MFzIO6B1Gjo8J4dhVrInGDEmnMi
         DA41A6ZFBUhJ5Q7DVlM3Na0N5v4X3fzIwc0IGy1aEvcWvGNYEOPNSk4LKT1m+GZ5KDt3
         HRzg==
X-Gm-Message-State: AOAM533Y3yCMU6qLPu74ThcFBh09dWsGdyB6Th/U58lQ5zwSgblOVbFr
        lCF+3RsZGDc9JlhpKX4SfNY=
X-Google-Smtp-Source: ABdhPJzeJGgelWlFDYohf+iEPFtsCypcer8NN7ev+cDLtWQsxsetFwq9j9sDC9XGBKPII2ABosfceg==
X-Received: by 2002:a54:4501:: with SMTP id l1mr3455416oil.165.1602121225069;
        Wed, 07 Oct 2020 18:40:25 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:15f9:f0ca:c82c:9be5])
        by smtp.googlemail.com with ESMTPSA id i5sm3168134otj.19.2020.10.07.18.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 18:40:23 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>, stephen@networkplumber.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20200930165924.16404-1-vladbu@nvidia.com>
 <20200930165924.16404-3-vladbu@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com>
Date:   Wed, 7 Oct 2020 18:40:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20200930165924.16404-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 9:59 AM, Vlad Buslov wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> 
> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
> user requested it with following example CLI (-br for 'brief'):
> 
>> tc -s -br filter show dev ens1f0 ingress
> 
> In terse mode dump only outputs essential data needed to identify the
> filter and action (handle, cookie, etc.) and stats, if requested by the
> user. The intention is to significantly improve rule dump rate by omitting
> all static data that do not change after rule is created.
> 

I really want to get agreement from other heavy tc users about what the
right information is for a brief mode.
