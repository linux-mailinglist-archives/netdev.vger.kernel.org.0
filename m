Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFA93DEEA6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbhHCNCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbhHCNB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 09:01:59 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D9BC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 06:01:47 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id a19so13859664qtx.1
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 06:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nuTYoTLaZv7P/kDxOnYUARMwyoMMdFxgC7RrowVfaOU=;
        b=OL4zwGE5VWLyACsArWT9xVb/DGRETaPQZfvk7MftlqE2RvlZjAEY63mcOoDOVqTV7H
         hg7vR0RubARdREDMNJ36wu0bKpVQny0pL8+xCGt8tDBcRSG0udPJ0Rw1yoFDKxBQ/CPX
         XmM9Xx44BFNs6fhElgDKVk2Wsj+IfU22+RFAJbV7N0yXVjdmwL3Wn0XfVCk3o+Cf/00G
         eGHtyVVtIFYYxf9yBg7CsHTbpOdmr0wG5fDtPcM2vfezsbqxF0Fhb+RgIApsN9yP1fzE
         41Xq6u/kG9BxZtJLmviTUwFkF+iwBvHJN+4aVEnAiL1nz0EltWjzlQ5YlEs29GzRFcV/
         e+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nuTYoTLaZv7P/kDxOnYUARMwyoMMdFxgC7RrowVfaOU=;
        b=gQM6Kca6u/QjQlSoRMOzsM2qYjn4ZAk9rT6xIXikpWBHywTVHT0hbSHQxsM5RtjNB1
         y51Vt5C8Yuy93W+2gcTEWWoCTmveE7qBReTetCZswToIS1DyUCVwe/+8lCjraB9C+Ra1
         fRQ5DI+JLYXoYDtr8/okcwmeMYzD2e1UewU57wtEylb8HgF/x5FmJyijNOIM5FLboHUZ
         EsaBLJtlrBHbVLmaTpH3EUdnsBqAR4s5YluTWrXubj9+WKsF4u6lnniKLokeqjAHJO2X
         d3muCN3NNNdXQycJYLxkvevVDPDOND6THodcK7VFd0gEGcigBmDhqHixhH+5TLPHSQmX
         /Zog==
X-Gm-Message-State: AOAM532RYczHNYj/9mCo+/dmxqenUh0yOlSAYSv3kWSDPfZPAYsHDR+q
        dEhqvdiTAbtKHGaokXJfdZf+l2xGUEUamg==
X-Google-Smtp-Source: ABdhPJz7dzgK2c9No+TRuws4NKme/K2Hx9pVFt0+BzFtrXzi5pPXM4CXAu5pVs0qW0Y9lngJjQmUiQ==
X-Received: by 2002:ac8:70d2:: with SMTP id g18mr18085888qtp.58.1627995707035;
        Tue, 03 Aug 2021 06:01:47 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id h7sm6073453qtq.79.2021.08.03.06.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 06:01:46 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
References: <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
 <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
 <20210803113655.GC23765@corigine.com>
 <2eb7375d-3609-3d94-994a-b16f6940b010@mojatatu.com>
 <20210803123153.GD23765@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <3907f67e-a362-e69c-2891-280cf6c7fb23@mojatatu.com>
Date:   Tue, 3 Aug 2021 09:01:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803123153.GD23765@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-03 8:31 a.m., Simon Horman wrote:
> On Tue, Aug 03, 2021 at 07:45:13AM -0400, Jamal Hadi Salim wrote:


> Thanks, I will look into this. But it would make my life slightly easier if
> 
> a) You could be more specific about what portion of cls_api you are
>     referring to.
> b) Constrained comments to a topic to a single sub-thread.
> 

Context, this was on the comment i made on 2/3 here:

-----
-        ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
+        tcf_action_offload_cmd_pre(actions, FLOW_ACT_DESTROY, extack, 
&fl_act);
+        ret = tcf_del_notify(net, n, actions, portid, attr_size, 
extack, &fallback_num);
+        tcf_action_offload_del_post(fl_act, actions, extack, fallback_num);
           if (ret)
               goto err;
----

where a notification goes to user space to say "success" but hardware
update fails.

If you look at fl_change() which does the offload you'll see that it
returns err on any of sw or hw failure (depending on request).
Notification of success is done in cls_api.c - example for 
creating/replacing with this snippet:

---
         err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
                               flags, extack);
         if (err == 0) {
                 tfilter_notify(net, skb, n, tp, block, q, parent, fh,
                                RTM_NEWTFILTER, false, rtnl_held);
                 tfilter_put(tp, fh);
                 /* q pointer is NULL for shared blocks */
                 if (q)
                         q->flags &= ~TCQ_F_CAN_BYPASS;
         }
---

cheers,
jamal
