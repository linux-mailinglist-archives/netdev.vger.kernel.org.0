Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A1B1B5EB2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgDWPKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWPKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:10:01 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C143DC08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:10:01 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p10so6705568ioh.7
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A6tOAhfLe0aYLhdH8IGlue9Jsw8XW1sg9mSXtEwXO4o=;
        b=K0jx8/FJ0Au05H5wVDqWrA8NsBKyTs2FXhR7N3NndA1JaMEqK89w8kzTc5C2ARqrKy
         czMvE4ry8vd8NFyYfgMbcA6ijg453b2YWky/FBV95xPdK2IvufPspb8w0crLxPycdmhw
         VHj1FpOCJZ+y/Q2yE6gyZB+OkpFZxnoI+H+SPD9WrH+P6Kpsp1ZST7A6dfH+AA/Bpfrj
         hQ2P6F6KlS8IH2+mf8Mj7u/2OGJPHpE4Fs11kcBeSZE3DqY0P7aY8d6/40blwP8EIyOo
         bXln/0ZYOBna0magDK1uxoUkaJXrbVEetx6Hv5ZT1MLT5rAlCh6kvwqZvLcGqkOFGKV8
         XHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6tOAhfLe0aYLhdH8IGlue9Jsw8XW1sg9mSXtEwXO4o=;
        b=MLVR4uhe4eOPsf1moTvE2Z6HineEIaSIH0mLs5VN0DM0pt0HgNhTcUDKR8ADQ8CDeJ
         vc/HfBw7m8nWnULIxXg73xuyXtpZDf/IT9kf6kYnxR60bg/Fp3lEyhCz6hIRv6Rc4iNX
         Jdb1VG68nlBdTkzKaIb+vhBUACj98bSMPdpAVDSsERlJuxtzGflpaZWxnZmzdoXKwNP5
         zEhARGbKclgxX7vFAq/yRmUJucJYNVr6gzlinMUNvkg2Eqp1Nqa0exaS2tHp8jiV14W+
         uYpy1AzXEmAqZSOSQQbdGWrwBXG0YmuO7xrM6Vzux5EdNgann1ZDmm2gyGXMh7njS6HA
         lnIg==
X-Gm-Message-State: AGi0PubmaKJNkpEHmOSdRbfv0HOKYamTp3rLwWBsmJWDRTUzz9OscTgm
        1xAbj1zAkGqVePBLpzg+b5U=
X-Google-Smtp-Source: APiQypKUGMpe+oDpDMPZwOdJtyPsSLIm2HCNw4ULitQ+IEgtZmUk/g3U2t7vFaH2kyvhhNLte6cehA==
X-Received: by 2002:a02:90cd:: with SMTP id c13mr3558030jag.83.1587654601176;
        Thu, 23 Apr 2020 08:10:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id i10sm988196ilp.28.2020.04.23.08.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:10:00 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] nexthop: sysctl to skip route notifications
 on nexthop changes
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bpoirier@cumulusnetworks.com
References: <1587619280-46386-1-git-send-email-roopa@cumulusnetworks.com>
 <CAJieiUgHMjVozdSE_DM1yDnGuUEXkamDgmKwUfdBbvhTdx3Eqg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9bc6f1cd-7d18-8222-6e09-918488c3f6b5@gmail.com>
Date:   Thu, 23 Apr 2020 09:09:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAJieiUgHMjVozdSE_DM1yDnGuUEXkamDgmKwUfdBbvhTdx3Eqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 8:48 AM, Roopa Prabhu wrote:
> 
> 
> On Wed, Apr 22, 2020, 10:21 PM Roopa Prabhu <roopa@cumulusnetworks.com
> <mailto:roopa@cumulusnetworks.com>> wrote:
> 
>     From: Roopa Prabhu <roopa@cumulusnetworks.com
>     <mailto:roopa@cumulusnetworks.com>>
> 
>     Route notifications on nexthop changes exists for backward
>     compatibility. In systems which have moved to the new
>     nexthop API, these route update notifications cancel
>     the performance benefits provided by the new nexthop API.
>     This patch adds a sysctl to disable these route notifications
> 
>     We have discussed this before. Maybe its time ?
> 
>     Roopa Prabhu (2):
>       ipv4: add sysctl to skip route notify on nexthop changes
>       ipv6: add sysctl to skip route notify on nexthop changes
> 
> 
> 
> Will update the series with some self test results with sysctl on later
> today. Expect v2
> 

and I have some changes for you. :-)

There's a bit more to a "all of the processes know about nexthops; give
me best performance" switch. I will send you a starter patch - the one I
used for the LPC 2019 talk.
