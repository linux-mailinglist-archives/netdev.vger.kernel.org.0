Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376063027B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfE3S6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:58:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40103 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfE3S6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:58:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so2529168pgm.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ekb9nu/Qqu3zrEUw3auidmUKBxEC7jgaxq63QGtfUdo=;
        b=brVEfmGEkIQeOYN8kbuRPEFaPuHKTLCdTQvW/m7dW3rHBXd1ZdtZAiB1VSwF2bcoxT
         lb62TGUKpNY/YZKI5Fvzdc7xS7tpGu2/lzI0b8sx8xvx/V6XYfEzOfMUf1R5jpOZCUJq
         EnDXqD3XCY59wbyjie339VDohHSGgHONzYPHXZSVS2NRX/qamJ7MP4FnUVWpooBgmTJH
         n5xeIAjMrSlYkxFfKv7VpkRjjfPEhieQmOOYAE00jb1FxIpsvHYOfP9GhEhv4jOvtcAw
         pZNMCbYnKUT3w4lhjNU59Uu82j9Uqnmo+mfYdTLh7Sevh3IBc8VUY61V7cBVD3z/eeEY
         t4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ekb9nu/Qqu3zrEUw3auidmUKBxEC7jgaxq63QGtfUdo=;
        b=O7RqT9odDEzPVx8lVBkQNS116T6ms0N78c14smhBlfiDUJeWRyGSpKSkngLNrmsNrV
         tqSWlh8YNgPrJUSws3mbUEaEZLWNSVw9vPhxMdjr0UnGtOu5NrsaJouv5Za8qGYxv1HP
         1LvQNHETATfdqZUSqPTcLxF/6nqE9pRkxLvgL1XiX2pgsSusbGDZV84yjXgZ72tLydx0
         OCf2oy2S5Ol9LEgwWeKf5KcZb8fT1mLcD08zuhe12rE1x+20JKkFjHKtyHlIdj8iIhm7
         zpCdljYwQNh8Iy8l+jNVZz+pig4X1EbyHKIUVVYATDgWTxm9xysqzTIKtRZ+DNGy12al
         dlEQ==
X-Gm-Message-State: APjAAAUwCN0rTP0Ng1PMktXr2O3LABiOLGUN61rpQeAMdsYRNef1ThXr
        tnFfJ53pg7R+8+qTQTEuFdw=
X-Google-Smtp-Source: APXvYqwGmmbRnpYzNfrsjnOIuPdNBS0FNu/o+6u3WfJsIsBGyEnR/Aa+WoVI89ZRhJv+D7hdaxk3uA==
X-Received: by 2002:a17:90a:2e89:: with SMTP id r9mr4770770pjd.117.1559242725714;
        Thu, 30 May 2019 11:58:45 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u4sm3646677pfu.26.2019.05.30.11.58.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:58:44 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Miller <davem@davemloft.net>
Cc:     alexei.starovoitov@gmail.com, dsahern@kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com, saeedm@mellanox.com,
        kafai@fb.com, weiwan@google.com
References: <20190530.110149.956896317988019526.davem@davemloft.net>
 <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <20190530.115726.2295852303789730642.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec6545b8-9043-5131-777e-1086cf0e6fc3@gmail.com>
Date:   Thu, 30 May 2019 12:58:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530.115726.2295852303789730642.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 12:57 PM, David Miller wrote:
> From: David Ahern <dsahern@gmail.com>
> Date: Thu, 30 May 2019 12:52:43 -0600
> 
>> The nexthop code paths are not live yet. More changes are needed before
>> that can happen. I have been sending the patches in small, reviewable
>> increments to be kind to reviewers than a single 27 patch set with
>> everything (the remaining set which is over the limit BTW).
> 
> We definitely need tests using the new netlink attributes even if the
> code paths aren't live yet.
> 

https://github.com/dsahern/linux/commit/8c0b06b9813e74c561c8626de862fb649f615cb1
