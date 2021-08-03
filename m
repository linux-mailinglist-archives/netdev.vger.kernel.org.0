Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51FB3DED25
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhHCLru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbhHCLqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:46:51 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D643EC0617A4
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 04:45:15 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id f91so10407673qva.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 04:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OGmfEP8XQPtvE8kc8wV51KilvAujE5/WuJ+uCg/XoOk=;
        b=zjEXUKlC3ozBCwUb04QOR9GKjmo4BetumGc4IPMc52lTWKoYHTgV5AgMcDnEXwwkR8
         2kP72QWJ5+9UAesZye6AU7Tayk3Mfk7g8HBX4BeD/V0r1VWldvH3wW0edxwdeaBD+d0S
         bZxZTw1SRm5xH8M1yeXRsXlMxFRZKZi4QZFkOW/CWB7BDpil83URWnNEP+ljI3Zfndn7
         uXYWLExzOdyzACiwfapAH3h918vxp7hAZ8ppb3hA/SA2pqUk6v7OfZ9CTJjetJpyZE8v
         xqlKmXb4UHmAFc0eVRkFtt5PMN/YWTTY6icCDVQ+Ar9Bcl0r8Ukj1dlvV6XtsRs79lp9
         y6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGmfEP8XQPtvE8kc8wV51KilvAujE5/WuJ+uCg/XoOk=;
        b=GZtQYLqWDgCBwD2JfRKoKTQMZpmpTzz0d2V5c6bVbIicwy9Lb28zP20nPkaanmP0f2
         GLWtoIuUpboSgRgiiG7v1JWi3R0oSKiVWE7u+E9OF+IIsmA4ezyxrNlNtYezrQeR7MzA
         mmctUlezoHytoFI94QUxHqGemzU/gKnykwHFVqKtA7wD4J4bdIQR288Fr+jgztx6WHZ6
         AguH1AI7cBEBKSZDYX5Nylk6JyBu4/BdpCAa8GED2sZeVOMnD01aAcxEDBne69DDI+Va
         QqLK/v12acmh4XfsZCyzrQb6hz3k6u73K+c2v5BilwOkaiV7qpHe/o88N0YFWwVSMELr
         JmCQ==
X-Gm-Message-State: AOAM533A1wT6I9cIccfYimtlQHVdgn9OeCqKNTox6q4VNliPVhtOWUP2
        zGnMbgOfEYwyQq8H8SEi1k/MBA==
X-Google-Smtp-Source: ABdhPJwujuAW07B1so9MpR48tjNcwODbWk5BXtR3DF7PmkpU5YfaktLD0gkV5KHMpkuYOvQRQWmVRw==
X-Received: by 2002:a05:6214:1362:: with SMTP id c2mr21402626qvw.9.1627991115100;
        Tue, 03 Aug 2021 04:45:15 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id b15sm6186579qtt.9.2021.08.03.04.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 04:45:14 -0700 (PDT)
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
References: <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
 <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
 <20210803113655.GC23765@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2eb7375d-3609-3d94-994a-b16f6940b010@mojatatu.com>
Date:   Tue, 3 Aug 2021 07:45:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803113655.GC23765@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-03 7:36 a.m., Simon Horman wrote:
> On Tue, Aug 03, 2021 at 06:14:08AM -0400, Jamal Hadi Salim wrote:
>> On 2021-07-30 9:20 a.m., Simon Horman wrote:

[..]

>> Example of something you could show was adding a policer,
>> like so:
>>
>> tc actions add action ... skip_sw...
>>
>> then show get or dump showing things in h/w.
>> And del..
>>
>> And i certainly hope that the above works and it is
>> not meant just for the consumption of some OVS use
>> case.
> 
> I agree it would be useful to include a tc cli example in the cover letter.
> I'll see about making that so in v2.
> 

Thanks. That will remove 95% of my commentary.
Check my other comment on the user space notification.
I was just looking at the way classifiers handle things from this
perspective and they dont return to cls_api until completion so
the notification gets sent after both h/w and software succeed...

cheers,
jamal

