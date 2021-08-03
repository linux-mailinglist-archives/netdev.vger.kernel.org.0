Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A283DED4D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhHCMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbhHCMCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:02:39 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33FFC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 05:02:28 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t68so19560489qkf.8
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 05:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3HGGZ8fpVvJVzwgxxDiFdXRBy1OT8P6a+dGBaN5QO9U=;
        b=rcxswbIiAe06PjyrDH+YYx+uBLqIVJp4NQo8s8ROkv74K8ywpgYdcOh5+dj/gHSNng
         WGr73WmNsSne2RqC6VPNxmCfbHaphZLT1IcOQolG8VY8Jj/HgoA5HADZvMRxPAmA+zrQ
         hTLvnv0A2EcgJWb/r4KSGYFMhutgMlF0QQIGfDamo9Iy8ipvYZvwdLkv+ybSRzncz4HY
         iJ8rBqUJUYPFwY82jlpdiXBJjKYdRJuael4wd+l9ZnBIolCm01Bm/eUGQBiWiyKWnM0i
         Go41Hz8PgNXQ0kXb2ydhpjpyD5sl16gsVs1GGpVpAdKgc5T2766kikYm3k+ebiV0xv9g
         IOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3HGGZ8fpVvJVzwgxxDiFdXRBy1OT8P6a+dGBaN5QO9U=;
        b=IjGikVfWcqSGA+WEqwUU7Fpqe+kdlg1d4wfHaDUScWbs3lAXW7AQrjtAr8+2OA51YI
         0mYWqKA20hEKnUHhu1aYuYmUnP/EScYK85ppKEKzfg0M0dpRAFk+nte0emJ8bdXNM2n4
         pivH5x717lPT0epImR5NAS4U3PdiGIqCjJV68z+ky2c1F7GMEi6O4Z0aPcY+lUaVWtsB
         dTOWvlfTTRBGlCSwt+BD3JoGzW8nrvY2fTzoqXnkDLfp42d/1vLVRPxxMJ1IC1lslqKy
         lvZOlUepNuZKbydcGcP877PlL7qjQKd1QagQmcA0CG2YiMbrjGTmdjukj+finFzDmCEQ
         dOmw==
X-Gm-Message-State: AOAM5306qYC8PMfz5h4G8CtKkuuHpXk+Z9BVjaVnwF89Pk3FqFoCkYTC
        bGW+sUn269nai7k1cZS+nwMZaw==
X-Google-Smtp-Source: ABdhPJwHPGZGsEkXPslMHyZiCueARyGTUEzIdVAqJ3yKuBzPs13SpmVRJcpjPOOmGGEJHCBjD4ZN9A==
X-Received: by 2002:ae9:d619:: with SMTP id r25mr3602784qkk.177.1627992148227;
        Tue, 03 Aug 2021 05:02:28 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id o63sm7690715qkf.4.2021.08.03.05.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 05:02:27 -0700 (PDT)
Subject: tc offload debug-ability
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <ygnhv94sowqj.fsf@nvidia.com>
 <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
Message-ID: <996ecc2d-d982-c7f3-7769-3b489d5ff66c@mojatatu.com>
Date:   Tue, 3 Aug 2021 08:02:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just changed the subject line..

On 2021-08-03 5:57 a.m., Jamal Hadi Salim wrote:
> On 2021-07-30 7:40 a.m., Vlad Buslov wrote:
>> On Fri 30 Jul 2021 at 13:17, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2021-07-28 10:46 a.m., Simon Horman wrote:
> 
>>
>> Filters with tunnel_key encap actions can be offloaded/unoffloaded
>> dynamically based on neigh state (see mlx5e_rep_neigh_update()) and fib
>> events (see mlx5e_tc_fib_event_work()).
>>
> 
> Thanks. Will look and compare against the FIB case.
> 

So unless i am mistaken Vlad:
a) there is no way to reflect the  details when someone dumps the rules.
b) No notifications sent to the control plane (user space) when the
neighbor updates are offloaded.

My comments earlier are inspired by debugging tc offload and by this:

https://patches.linaro.org/cover/378345/

cheers,
jamal
