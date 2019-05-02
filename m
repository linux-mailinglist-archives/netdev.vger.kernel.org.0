Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD811A63
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfEBNh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:37:29 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41566 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfEBNh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:37:29 -0400
Received: by mail-io1-f67.google.com with SMTP id r10so2128851ioc.8;
        Thu, 02 May 2019 06:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B+xPVEmnEjMU0Ad3Renee6pFrgDbiQQsdeLUcI8AfYs=;
        b=JdqOpQtYfXbIRepTKwf+lZ8T0Wuwp+vOqh4A0y22ptz76WoNHikdXWKCSf8bBXzSZt
         ZEDQW7VJKDDKMeqNj7YNE78rGYuRKHIGq87YRLsL2xGKSZDXEG6hkTOFFUPFse2+jJNF
         GdreRmIw6hpnczFm58PFhDvyzWsuxw22EPdzXMHhccl8uPtsR8yviGYPQCnwQYr7CzEp
         GNe6wFphuK2lv3WZcw9AwKvWElzZAerQLm0J5F/dcWvVprYM/b2S7zqOfZcgTpa5yT5U
         u5ixzZbpVMROC58XjyeUXNtlZ9f10uunpqlMGwEJYeMD/e+y+8QEaLWwZa6qYUhoP1gR
         T/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B+xPVEmnEjMU0Ad3Renee6pFrgDbiQQsdeLUcI8AfYs=;
        b=SAr6dyKFeL950m+lCyYna9svVEI4rhf/S55nWOiY3cfR6ED6g4aK9oT8D+aiO0JUeC
         Jns/rHpvKfxArXpTDuNUrww2OGshmGighk+nShLLWBfWHPWn7i5GrzS/JFl/xexXAxP7
         uXjHTgVBoEXaPdqd2aUefI6uqniKss9SKRrBze6UDXQVxmA3J0f4OtvpZ4aIms9/WG7y
         TN5tY+/XLJ7EhwpJM49Ip3bciQ7x0i5tZnt0phStx8rbFfzaWtncyY89C2Y3H9HmeJjp
         cu5VviJsSueTqmfjmwQHogENtCw/TLdSQZTnV+f88wKX8ULBD1gdULXvxDAQmerJrHhb
         ojxA==
X-Gm-Message-State: APjAAAVxqb/mdUBX8quHhB8CeImc8jWA/GEtJbOGXL/0dIBMYsvEVXDq
        7jW3+EBSYkQT6Qk/zJDTds812E8Z
X-Google-Smtp-Source: APXvYqw4nBsqKlrSr+TmBsILe2jgARkTcPfHsrQ3JR65GQxH9vVus52UpdUjLtjCH0t/Fqc2hnesGw==
X-Received: by 2002:a6b:2cc6:: with SMTP id s189mr947957ios.303.1556804248595;
        Thu, 02 May 2019 06:37:28 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:7d41:7f77:8419:85e7? ([2601:282:800:fd80:7d41:7f77:8419:85e7])
        by smtp.googlemail.com with ESMTPSA id i24sm7463608ioh.60.2019.05.02.06.37.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:37:27 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] netlink: set bad attribute also on maxtype
 check
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        linux-kernel@vger.kernel.org
References: <cover.1556798793.git.mkubecek@suse.cz>
 <e7a5efb0d4acbd473286a9e5923d1a97c68fcb09.1556798793.git.mkubecek@suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d44a5423-0904-d4ac-e4b5-64a778a8339d@gmail.com>
Date:   Thu, 2 May 2019 07:37:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <e7a5efb0d4acbd473286a9e5923d1a97c68fcb09.1556798793.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 6:48 AM, Michal Kubecek wrote:
> The check that attribute type is within 0...maxtype range in
> __nla_validate_parse() sets only error message but not bad_attr in extack.
> Set also bad_attr to tell userspace which attribute failed validation.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  lib/nlattr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


