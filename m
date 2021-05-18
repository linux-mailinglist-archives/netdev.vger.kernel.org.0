Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E4386F9C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346127AbhERBvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhERBvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:51:20 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89D9C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:50:03 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id s24-20020a4aead80000b02901fec6deb28aso1884105ooh.11
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wZgWUST45i/J0qo5nwfEVRM8Fv4SiGvWo5KkoNo9x/8=;
        b=FkNMC4a1FQ2wbuONu2Vd+RJaH2/A3iS9LnkdxieFl8LmSYFiHpZ+R/afLAnpCAZ9oq
         aHna7N/V9ljJ2+dx7W8EOiYgGMMXZ/4nFjUSe20xZ7jqHhMre+woo8DemabX7/TsUSqk
         0pu1RHBcqEKW2y1FHAp4gIhNXYMnJWvBVfnxI9SwEro9zoXbhk6RWYs38I4NDF0gjY43
         MTjxsPOg8d2HSFicjDzIh5N+cIWYIdYSS4/gkt5RDY3qn5Gjril0ZAi1tFaNqsUk9837
         hbVnwKFYL8qkg1/bSiyQ9CoXx9M1gDyAClfnpRpgxby87w615ylCPm0NdCa8+GlyYtR0
         Z5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wZgWUST45i/J0qo5nwfEVRM8Fv4SiGvWo5KkoNo9x/8=;
        b=Hdqy3aj9f7HWvnrLO5xduhnyW6Bff79yGeUV/TC0t7lfFM7E+AjdELVGOF8CXU2za9
         ccCvpXTG3pGidzperbB5XzDvj0tM7XJGlFv/kAKH66o0UfVjIXj5vmVnVEzMzzEK22nN
         Sy0YrQRjMhpKX77fWljIe8iF1rVq/eWNhpb84VDAmQVnQGlMGBnH+rVB2RS+PywJRheC
         3ozg/FzgQH40LWVACPsQ8jzQhis5zIcXSTMBdI4kS8zp5zPYS/IiMkZUSyWUTIUQJ+bd
         A6kT1QF8F2mo/CDY0XRiLY3oYmQc+1SDxRPvD7nZzV9ifE+j3KhRxPjBLf7xj/YzMam2
         u4Xg==
X-Gm-Message-State: AOAM530am3CvEeREGxOH4HQ271EdE4vHhZk/rzoUY88pebpEN/iTz16c
        sNbEcqyHeY3KaAZDCBTvHCA=
X-Google-Smtp-Source: ABdhPJxio/e1ii0ydoIe+ML+CiulLFARa/oSUpIC9VhdQkvDJCMycnn5VztRaR1jlOpfK1WS4sM/Bg==
X-Received: by 2002:a4a:e385:: with SMTP id l5mr2289342oov.48.1621302603073;
        Mon, 17 May 2021 18:50:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id l9sm526216oou.43.2021.05.17.18.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:50:02 -0700 (PDT)
Subject: Re: [PATCH net-next 09/10] selftests: forwarding: Add test for custom
 multipath hash with IPv4 GRE
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-10-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f6d809e-c9a7-3ef5-588f-21b71814c831@gmail.com>
Date:   Mon, 17 May 2021 19:50:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-10-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> Test that when the hash policy is set to custom, traffic is distributed
> only according to the inner fields set in the fib_multipath_hash_fields
> sysctl.
> 
> Each time set a different field and make sure traffic is only
> distributed when the field is changed in the packet stream.
> 
> The test only verifies the behavior of IPv4/IPv6 overlays on top of an
> IPv4 underlay network. A subsequent patch will do the same with an IPv6
> underlay network.
> 

...

> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../forwarding/gre_custom_multipath_hash.sh   | 456 ++++++++++++++++++
>  1 file changed, 456 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
> 

Acked-by: David Ahern <dsahern@kernel.org>


