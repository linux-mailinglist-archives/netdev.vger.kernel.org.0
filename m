Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542D341D1EF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347994AbhI3Dnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347799AbhI3Dnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:43:52 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC19C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:42:10 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso5585105otu.9
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eZ490IcbO+4fwbmnoCC5oaoIvWOeiJK0cJIZsyP/Ykg=;
        b=OL949GF3GKa5TsXAvW6/ytlZ7QkLNRoO4Y6eLOXQ7+smyMTioRF9pRLzYUfMWoMo8D
         0VSPYraF+ER2fgmVBa0IEd1CQWq+EmPOvsteVe6aqEXmSqKyt8A7oNdMwZAnTQpTEAhS
         KYeIjY7ox37v4fUnfrkc3wBftxks5ZmVef5vmkcjbhtyDTuyiXq+5nR1F9YCkaXHY0VB
         4QWoTrfMKvIMY3sYoGucuf1Ftknr6ZNCR75HbCJhRHssktT6Ua6IkVcz6pmdaEElTYpZ
         5keru/JMKPqVJ5UcY78jb1thz4cS79vF0wZ5mdj7i2UHZ4907FxM/NF37jti8x/kFcKs
         6XCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eZ490IcbO+4fwbmnoCC5oaoIvWOeiJK0cJIZsyP/Ykg=;
        b=NJPKcbeZMEQ9EENx7y1j3bZ+0YUVdbtnxvCnasYS1/beZXBg/zD2D5EV+R2Rh8Nx8m
         +51YfrR8H9LZsSjiaDWLvlb2Nl+w1JMSz3bEe5XzSVFlbI1o+CDoL3PVIfM739OmWPnS
         +bbothEKTrqIwdhzQCYi+8fO51h8aTeoyoZaFpXz7qTMfhFpejCnW41F3aQCLrIUnoSr
         +mnXBxfx6CAsT8YhRafCT6KpxUXe5YjW0KCq1jxKNm1ry79DcDYY0K1MCKwqSKh7WTbw
         p7L50l9kXoniji2Uj7Edw2F0NtB/snqUSGUDNhe2cUz1R6iaY45f526z96KFq8GbOJjs
         3W4A==
X-Gm-Message-State: AOAM531jh45UMgUMjgM/QV1cZl8rO6zO1ZX5RGdr9AxXZu00IDhcNCII
        jfyorlqvOlAiOpzJ7dDHRAc=
X-Google-Smtp-Source: ABdhPJzn7ynqHehFYEhtVQQCH7k0GmPSjndc/+QuQbT7UqrEZHqDIYHXC41QdgP1jXRw7HhTy3YUYw==
X-Received: by 2002:a9d:5f8f:: with SMTP id g15mr3102299oti.384.1632973330272;
        Wed, 29 Sep 2021 20:42:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 14sm357705oiy.53.2021.09.29.20.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:42:09 -0700 (PDT)
Subject: Re: [RFC iproute2-next 00/11] ip: nexthop: cache nexthops and print
 routes' nh info
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ffec3e8-63ba-ce85-7a5a-d092420749df@gmail.com>
Date:   Wed, 29 Sep 2021 21:42:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set tries to help with an old ask that we've had for some time
> which is to print nexthop information while monitoring or dumping routes.
> The core problem is that people cannot follow nexthop changes while
> monitoring route changes, by the time they check the nexthop it could be
> deleted or updated to something else. In order to help them out I've
> added a nexthop cache which is populated (only used if -d / show_details
> is specified) while decoding routes and kept up to date while monitoring.
> The nexthop information is printed on its own line starting with the
> "nh_info" attribute and its embedded inside it if printing JSON. To
> cache the nexthop entries I parse them into structures, in order to
> reuse most of the code the print helpers have been altered so they rely
> on prepared structures. Nexthops are now always parsed into a structure,
> even if they won't be cached, that structure is later used to print the
> nexthop and destroyed if not going to be cached. New nexthops (not found
> in the cache) are retrieved from the kernel using a private netlink
> socket so they don't disrupt an ongoing dump, similar to how interfaces
> are retrieved and cached.
> 
> I have tested the set with the kernel forwarding selftests and also by
> stressing it with nexthop create/update/delete in loops while monitoring.
> 
> Comments are very welcome as usual. :)

overall it looks fine and not surprised a cache is needed.

Big comment is to re-order the patches - do all of the refactoring first
to get the code where you need it and then add what is needed for the cache.

