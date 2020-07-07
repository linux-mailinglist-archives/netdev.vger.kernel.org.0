Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107FA21754E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgGGRg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgGGRgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:36:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD94DC061755;
        Tue,  7 Jul 2020 10:36:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn17so5271436pjb.4;
        Tue, 07 Jul 2020 10:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hD+v1VwjgoeBfusFCbIYd6+V9RKkmN7xz9LUMK9w9XU=;
        b=Qv/uEpNWiakSuZNYA5rbzaOVChoyrZxuHlViO3KTV7XI6WH15OgKLlOFjNo1OxvCo3
         mv389p+O9FjSGJgY3gKdVuaPowMcstPA6vpiLWD1X/l2erLUadryvFN+qe0MSsnFqP6N
         3kWSEccbINtlLux5TRFxA3tGRoGRLQii+MmpmneyhG5Zfqo2EyD85jxWSjLS5NBZi235
         wNo2tZWXNAq+xTM1qqc8sFU4Uez7W2SVglEVsw2DN+9M0TtgA1vfp6YBDU2FBg6ungz8
         1E/rwAby402S4OHpGgVHY4dby0JtSxRuQAsB6BsgK6tuxR50TUhIf/XWOFXHQOUa4A87
         ecaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hD+v1VwjgoeBfusFCbIYd6+V9RKkmN7xz9LUMK9w9XU=;
        b=Xo9hHKi+m/cU2GtVuNm6gRsfQtmW2lVxkifnuCfr4ePzVMx8Onnn7s9i8Y6F01NTDs
         zVfaieOu7PUdOtGv56z2IAcj27sBVZrbg/rSmdkkcUZGCzV5BVCiTeXA9AgwG4wx/0B5
         2oNM4UYXfqqkQSH05n4myhu3gL2OvOwRXRLalFsajHnHZISEyNwIaXeNbMwUzAHIonYb
         fMWOkR5t0GQPmCyTbiXzGpYfM/pTYRTY85T7KlyU0ltavxpMlHX30eDptE6eAKcmBYXr
         AcXa0djNSgwWYoLAiviTWudKW6GMZ6aJ4UFFTLbCw+rZZ0XdOxYSNqSj4G3Dp7nV0hQG
         0/RA==
X-Gm-Message-State: AOAM531QT0/YcCnVM2DZwckJwsbFZlzKGEOqaNLUPjIJOVBWkwSB7TwR
        qdFrxTb5EOvtBWdk/X3HAvc=
X-Google-Smtp-Source: ABdhPJy3v1cAGREGtVx9lCAdWMpeWbRUW51kXJcikmNKcG38AoWdWxTkdOWfaMxLFnjl3Fmv1r1k7A==
X-Received: by 2002:a17:902:7611:: with SMTP id k17mr46664468pll.255.1594143384186;
        Tue, 07 Jul 2020 10:36:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c188sm22817275pfc.143.2020.07.07.10.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:36:23 -0700 (PDT)
Subject: Re: [PATCH net-next] dropwatch: Support monitoring of dropped frames
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     izabela.bakollari@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <8aa6bcfe-8117-0fc9-1bc5-9b6a600e0972@gmail.com>
Message-ID: <48534d9d-49c3-5e43-d1f6-51b96ba7fd90@gmail.com>
Date:   Tue, 7 Jul 2020 10:36:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8aa6bcfe-8117-0fc9-1bc5-9b6a600e0972@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 10:33 AM, Eric Dumazet wrote:
> 
> 
> What happens after this monitoring is started, then the admin does :
> 
> rmmod ifb
> 

I meant  :  rmmod dummy

