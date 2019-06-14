Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE71460EE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfFNOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:35:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39869 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfFNOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:35:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so1578705pfe.6
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b4yH1UHrx2u99WhiYULpMP8e+QkXx9OFjVDDVegtjZY=;
        b=MUE/uXN7UADEag9Rd8hIj9w9U++Y0ZAaLVXdoz5FPOkD5ZDiPLQ6GV9L7racEF3g0k
         HYvQSriTT4AZlLMYYgHDGjR1mwk6Hm/YYpwBYmUQLVOHHwkKlW8Elng7Uohmw9v1Tmb7
         ykQYXRMf3pR2wsjar4hhD/FXAxmq+ccbF/rJtKS0JQnHL4LZE1ulXoo93Wncx27UgIbZ
         a1XT+2ZE+kSV4UUtvBCQLa/kqoB57/4h4y/sbtA7E1AxPpdXnWYEA193hfY2A4cGQGge
         5WENw2BJ1GyPvTsiZfgTFHfwU7SiB7qHu55sScW8xzEbe5kQywovr+Q89sdfU30HfrTP
         18QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b4yH1UHrx2u99WhiYULpMP8e+QkXx9OFjVDDVegtjZY=;
        b=jSdIm197kWQFZZ4DSmR+loD3+mG4litin/9OJIP9TjchysvGM9ZtEX6QVZfQJHSr37
         By++HFmZfm26mAfjj9Hj8S3IfsOR+C4ekhqJahqJ8Me92Ory0OXl1ygE792y7tJEtQ9w
         eem2tyATRYU0wHLgKpb65R9GW8lS98ufGRUOyWylpkOvoS4IB6rrY+VZyXSCdYTnrZ7o
         dZlJHSIYlKCqkHT1/STn2GEPDkXgMH4Iia46f8L+DO74JRpkLA4TqRJ1VO8LmMa539Lq
         oCgTM1J12c1xx7owVV9gL1rAVHJeFpvbgEB64xYLDD9a+KeiPw0rt+UFU6rQE5LfDB29
         NRVQ==
X-Gm-Message-State: APjAAAXKKoSpabQb4o7fNf1bE9+Mvi9yokoeh9SaYHswEBab3AimtTQ1
        vV1KgwztgmBTzW248XZk9TP6B1bxS+E=
X-Google-Smtp-Source: APXvYqxmqqERCpN1/Xl1H0hlVoP7PoAJXsSCAcPepn8vswPxCKrG+RiBQsN5JBzW97Q7EoxoQEEJrg==
X-Received: by 2002:a63:c44f:: with SMTP id m15mr13027015pgg.34.1560522932754;
        Fri, 14 Jun 2019 07:35:32 -0700 (PDT)
Received: from [172.27.227.167] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 34sm2566303pgv.49.2019.06.14.07.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:35:31 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
References: <20190611161031.12898-1-mcroce@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11cdc79f-a8c9-e41f-ac4d-4906b358e845@gmail.com>
Date:   Fri, 14 Jun 2019 08:35:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190611161031.12898-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 10:10 AM, Matteo Croce wrote:
> Refactor the netns and ipvrf code so less steps are needed to exec commands
> in a netns or a VRF context.
> Also remove some code which became dead. bloat-o-meter output:
> 

This breaks the vrf reset after namespace switch


# ip vrf ls
Name              Table
-----------------------
red               1001

Set shell into vrf red context:
# ip vrf exec red bash

Add new namespace and do netns exec:
# ip netns  add foo
# ./ip netns exec foo bash

Check the vrf id:
# ip vrf id
red

With the current command:
# ip netns exec foo bash
# ip vrf id
<nothing - no vrf bind>
