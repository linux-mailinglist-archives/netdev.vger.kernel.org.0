Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36E42E681
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhJOC3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhJOC3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:29:45 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46541C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:27:40 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id s17so6046061ioa.13
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d9skbLq9GqGtNGoHg5nVMRQgX0pkLhNLcpZmUJIW2bg=;
        b=eIpPt9oSHc2iIMyMp5xQxslB5Ke+tbjH4Ca/QDU0B0x3BNgrzQHM7trNPTnKkVdQv3
         vbElOQ+h898KLPO607VOYE+ydYNHpN0yAWFbNSJGtLC2JzeP/T979J+JIyjpMsT3ZK3X
         VF1VB3SdR81wAjdDU3OtiMgXw5rPiTLdnSwYXWchy+OVl1GHtHF/qmvO22oHN8e2Yhuy
         pH2akbfW5c7/zviYAooKMvJ7d+IqQZK31vBsvXTpT9Qh7pueaZquCb/DRYcB+ssfc6LP
         7pO9vN5Z0I28fnmCdH1QkNjalPo0HlqzSfjehIML+98KYV9uuzN7OEhXhvBT7bH+tpZK
         ogmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d9skbLq9GqGtNGoHg5nVMRQgX0pkLhNLcpZmUJIW2bg=;
        b=TaYAnHPY/T9WcJcMz5a/3yF9x8FQ+RQzBdeYKJCCDWdukG1qjqDRmOy95v5PfFFud4
         wR0KJFPTi4IIp1IaKZ3ygUNusNhCyA/EYfVT3w59oIADFAyqlmh98zk7AkduYxYlm0Pe
         OmjB8RDdYh8sMbo9sgnxq9QCuPwhCSCJvQrGlGHBEHCABmM3poR/6DPsEe4jUWEOvKrm
         J8glytTt19xKVUr9nmGCP9KfXgnn0dDqrlb5xIyrXhf1+TU9h3EP63M5/404l4gjHeyj
         ICNDnlDanYNG6+9ZCXFfdnTKB9qwqUX8i/MZJ5MULvzCULFMMkq0WmnNKraae4eT70GW
         GhTg==
X-Gm-Message-State: AOAM530/fyUV7OFVFKSDwgRWTq8+R9jwg2RPj7WcTliUTFkk5omhrJC6
        w/lbZCQHmpd1+hL9oGQdyF0VbODBt1pd5w==
X-Google-Smtp-Source: ABdhPJx6EkDmylCXFYJaPAZXNJtd0tkRTIg+XzpZ1msi+RGZZEW7PePi/zOar11axK3A74Ri1dDtYw==
X-Received: by 2002:a02:964c:: with SMTP id c70mr6645280jai.85.1634264859595;
        Thu, 14 Oct 2021 19:27:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id u12sm1962237ioc.33.2021.10.14.19.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 19:27:39 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
 <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
 <20211015022241.GA3405@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
Date:   Thu, 14 Oct 2021 20:27:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015022241.GA3405@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 8:22 PM, Stephen Suryaputra wrote:
> On Thu, Oct 14, 2021 at 08:15:34PM -0600, David Ahern wrote:
>> [ added Ido for the forwarding tests ]
>>
> [snip]
>>
>> This seems fine to me, but IPv4 and IPv6 should work the same.
> 
> But we don't have per if ipv4 stats. Remember that I tried to get
> something going but wasn't getting any traction?
> 
oh right, ipv4 is per net-namespace.
