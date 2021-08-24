Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5543F6209
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbhHXPwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbhHXPwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:52:46 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A687BC061764
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 08:52:02 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a13so26898495iol.5
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G9UnSSnlYRLUttWk790OTUp3vVDNhuFNpjJPwPR33gg=;
        b=eiDog05hn6geYVERCCz83M7DncCeFgjW4iVb4MF6TQEZkST+XbuWGBUN1J6xMd4+Jf
         oM6/wKi3lPr7xBEq/SDCgNOErb+C8y5w78/D3J30mqecQNi6O/28hBNP1LgaZjVpIfoq
         tgO3TkEdbvxp+lDdPSMN9Ujo3Q7e2wtUN10sM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G9UnSSnlYRLUttWk790OTUp3vVDNhuFNpjJPwPR33gg=;
        b=nqC74SwVF+v7EBCgndgvnJ9QOOgFtbOGX33Q9wLyrWtXNhPKVuf5Zw4fHoRZcXI8xt
         gD1BNoGJ5axuC+41rUHXu37ev8yn5VuZfECjXxKzEdgaGQy1mHhCPZZ5WHFLaMqNd2ur
         BDnq5VDaqKSL3+kyXb0rT70EXsXWRZefge5fx/20M4ELP8xadSERuuyTUtE3hcy1TByr
         loB1kF18icul8bCwWXFfp63FFHWqUK5GZqMSGQzEfdLK+uUBeuYjdWz1hK3kDKtCGs9C
         ero8jPh3wcem40wf0XjDhsVTQ7vjF7830EkrgDV6wGPbyBne1J6X7XkexroVlyX0JqrR
         Itdw==
X-Gm-Message-State: AOAM531cdoI9KNepzFxF672nJ8sK51b6ixA51pTOPbAiYTELMR8TTQ26
        QfB31pOG87m+IBTEgNmt4ZsjQg==
X-Google-Smtp-Source: ABdhPJw12PHQe4ldQaJd+CQv6s5KafuQsOqHWMdAGHu+kcNMgcpKWej3e22m86/A7SuIEuuLmE4LnQ==
X-Received: by 2002:a05:6638:1504:: with SMTP id b4mr32944162jat.144.1629820321934;
        Tue, 24 Aug 2021 08:52:01 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c25sm10609598iom.9.2021.08.24.08.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 08:52:01 -0700 (PDT)
Subject: Re: [PATCH linux-next] tools:test_xdp_noinline: fix boolreturn.cocci
 warnings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     CGEL <cgel.zte@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824065526.60416-1-deng.changcheng@zte.com.cn>
 <2d701f13-8996-ed7d-3d41-794aa8a6e96c@linuxfoundation.org>
 <20210824074657.363455a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2b6bf2fa-cf40-9610-ede5-ceab35004864@linuxfoundation.org>
Date:   Tue, 24 Aug 2021 09:52:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824074657.363455a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 8:46 AM, Jakub Kicinski wrote:
> On Tue, 24 Aug 2021 08:42:15 -0600 Shuah Khan wrote:
>> On 8/24/21 12:55 AM, CGEL wrote:
>>> From: Jing Yangyang <jing.yangyang@zte.com.cn>
>>>
>>> Return statements in functions returning bool should use true/false
>>> instead of 1/0.
>>>
>>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>>> Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
>>
>> We can't accept this patch. The from and Signed-off-by don't match.
> 
> That's what I thought but there is a From in the email body which git
> will pick up. The submission is correct.
> 

Missed that. Thanks.

> Please trim your responses.
> 

Will do.

thanks,
-- Shuah
