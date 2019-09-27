Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838F2C0C51
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfI0T5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 15:57:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43927 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfI0T5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 15:57:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id f21so1475628plj.10
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 12:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a+9blC7q9PG6FceLK7/DZhm9XLzj5n4GCBccP+7ey64=;
        b=TQWJfxPKtVwS1LY1yTXkcIqxp4Gswho2AwgTkMedt/F0gAx2IhliKofwUNOa0biWz2
         ku5aBKJ0vj+IR3rhbmcHDxjcLFvhLPLSI2k6LbWklLx+AI3xT7DkH68zhgehiSS2rhCT
         yDUEWvqpuhtv8mEMI95ezu0S6MGlw8GlO8JyB76ZOjoFbADJ9r8qslMGfUyYyCpILXry
         dHDdB7jv2l4I0uVhS003UWzJkyX9DOUMnS/i6IMkM5JWlmz9VcB7G9Ix5q2dCHMLMfSH
         FWa0KQVW/46eR2R/ZzqjogF6/YBUCVQJJ9WulghFoVk6J2n0XICpGpVeUVgsGUVLeADN
         IDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a+9blC7q9PG6FceLK7/DZhm9XLzj5n4GCBccP+7ey64=;
        b=VuKyn9v9z5cT8Z2/r3flopBmswuFafiCUOZpUCBsCmNAM4o7oDadWPs2v3XyIY/Rfc
         eqp+pZ0eRZ5NjKXo41BBVg/4LAWjt7kw3ETx3WkMLy0LjGDV6xOpwMFvUurVl7SanViE
         8DbzDlUGxMGZ3IG3jhaPNuEeSeaHUSplOvQ7eP/sUftLCOW4l/rBWjh6TqhEHZIUzR0Q
         3ATOGlihURYLqtqkYJzD+6OgpFBWCsl6ot6Hoirye5DXAYPa31eVKn0FTLvstSbYshNd
         vWd3kzfhpD+KiuNNcgDpnDgrCHzIKF6U3DOzU0QHIG7XK1rJOvZBia+cx60BJhbXvdf6
         puqg==
X-Gm-Message-State: APjAAAWw4FexNZZ4ZzSS4wSjXGcmenOoIb9yM+TH9WZ2yUpMa2TkUSjz
        CZaTbUxJSar2V9KMefyc3w8=
X-Google-Smtp-Source: APXvYqyYYHVJKtcmeFAPDqN+jFWbsI0v40X3pPKqFc6jSCF9qxFVsoZgpjgpr9/WAcFoUERbCa8+Sw==
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr6490034plo.180.1569614268525;
        Fri, 27 Sep 2019 12:57:48 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e65sm3723174pfe.32.2019.09.27.12.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 12:57:46 -0700 (PDT)
Subject: Re: [PATCH net] sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
References: <20190927012443.129446-1-edumazet@google.com>
 <20190927.205524.1304517574378068070.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0b0ed452-c576-df5a-2420-2185e75e32e0@gmail.com>
Date:   Fri, 27 Sep 2019 12:57:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927.205524.1304517574378068070.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/19 11:55 AM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Thu, 26 Sep 2019 18:24:43 -0700
> 
>> syzbot reported a crash in cbq_normalize_quanta() caused
>> by an out of range cl->priority.
>  ...
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Fixes: tag?  -stable?
> 

I guess I feel always a bit sad to add :

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Thanks !
