Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575C13DEA9A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhHCKOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbhHCKOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:14:21 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB82AC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 03:14:10 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 3so10330349qvd.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 03:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q9ariqt6N6DfzPNTmWSDZDwBMZeZwxqD8bAaubzkaRE=;
        b=yyPm0lQX+mMeSjp5Re4HM0YCVeH/sZ2PajG0961uxmOiEWSGZhHZVY3bG/gbNrLekz
         c0PabE2Lvm12LhrFBxK3gTJE8F9bVJ2RiEXMWQ+ibNuEyaOFRIwQ5KlyBoeKZRmwriSA
         9yXjHu67RHDV+zigSMQIRyfi/0tAXUMyEpsHpYHY2a2qiR2plo7ak9bYYnO+CPWyElJm
         C2MavaDHfGGEmzznbe7gtH5ut7bHvN7MtZUFfpQiNKTeqwaMpEiLa++JkLpAWNOCLdtk
         O8OW3pqMfNpjJUNkmHUu0pUseXFAocBOkhn7mnd6ooDwydXa6AcD/+n3ihVE5uJ5xp+r
         ixfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q9ariqt6N6DfzPNTmWSDZDwBMZeZwxqD8bAaubzkaRE=;
        b=uBsyFrTbNTAtKPhtGCN6dfHaU4lT7XUhQJpagiyuE1LfPshkpm3snu7Id/eJn2N6dP
         8zDxYYj2heRyaTTjtNp6XbnkDt16l1lCL0wRupY+Ipyr2iI1FI2lKzZRGj23WPGPr5Yt
         D9nf5jBSME3gPPdZXP2ezWe0Bog/tNMDh6F6ovb8U82Spuh9hXCdjsjNkAkanVBY+64u
         AoRcRFZAh0vuERqPOHDHRptyxYQHMbvxTKB+X95MtN8FYdChYpJg7HvX1FOr2lN5UV+H
         p0cyWW+S8dEUUjahopTxHVuZglcIZn+jfnBwIrMcc/3RRLgXXsFwBuXO8vwetPWHRqWZ
         E8bg==
X-Gm-Message-State: AOAM530VczIzK2Ehw/HG6pasQ36K94zEbLjgWUuKqxQR95SzNzYAePph
        oT7qi5yPYhuFcXKXAg8RNEWDFQ==
X-Google-Smtp-Source: ABdhPJzUM8uUYsKaS+DwO0ufXqy7zzKgBJ8J/X5CqrTHXDzqbxB15ETwuAkw+YDEgDlslinnWH3TBg==
X-Received: by 2002:a05:6214:13af:: with SMTP id h15mr6353135qvz.7.1627985650199;
        Tue, 03 Aug 2021 03:14:10 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id y10sm5659983qta.16.2021.08.03.03.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:14:09 -0700 (PDT)
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
References: <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
Date:   Tue, 3 Aug 2021 06:14:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730132002.GA31790@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-30 9:20 a.m., Simon Horman wrote:
> On Fri, Jul 30, 2021 at 06:17:18AM -0400, Jamal Hadi Salim wrote:
>> On 2021-07-28 10:46 a.m., Simon Horman wrote:

[..]

>> It still not clear to me what it means from a command line pov.
>> How do i add a rule and when i dump it what does it show?
> 
> How about we confirm that once we've implemented the feature.
> 
> But I would assume that:
> 
> * Existing methods for adding rules work as before
> * When one dumps an action (in a sufficiently verbose
>    way) the in_hw and in_hw_counter fields are displayed as they are for
>    filters.
> 
> Does that help?
> 

I think it would help a lot more to say explicitly what it actually
means in the cover letter from a tc cli pov since the subject
is about offloading actions _independently_ of filters.
I am assuming you have some more patches on top of these that
actually will actually work for that.

Example of something you could show was adding a policer,
like so:

tc actions add action ... skip_sw...

then show get or dump showing things in h/w.
And del..

And i certainly hope that the above works and it is
not meant just for the consumption of some OVS use
case.

>>> If we wish to enhance things - f.e. for debugging, which I
>>> agree is important - then I think that is a separate topic.
>>>
>>
>> My only concern is not to repeat mistakes that are in filters
>> just for the sake of symmetry. Example the fact that something
>> went wrong with insertion or insertion is still in progress
>> and you get an indication that all went well.
>> Looking at mlnx (NIC) ndrivers it does seem that in the normal case
>> the insertion into hw is synchronous (for anything that is not sw
>> only). I didnt quiet see what Vlad was referring to.
>> We have spent literally hours debugging issues where rules are being
>> offloaded thinking it was the driver so any extra info helps.
> 
> I do think there is a value to symmetry between the APIs.
> And I don't think doing so moves things in a bad direction.
> But rather a separate discussion is needed to discuss how to
> improve debuggability.
> 

Fair enough - lets have a separate discussion on debug-ability.
Maybe a new thread after reviewing Vlad's pointer.

>>> You should be able to build on the work proposed here to add what you
>>> suggest into the framework to meet these requirements for your driver work.
>>>
>>
>> Then we are good. These are the same patches you have here?
> 
> Yes.

Thanks - will review with that in mind.

cheers,
jamal

