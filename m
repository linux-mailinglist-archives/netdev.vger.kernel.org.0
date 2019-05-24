Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4784129DA5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfEXR74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:59:56 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:46838 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXR74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:59:56 -0400
Received: by mail-yw1-f65.google.com with SMTP id a130so3941967ywe.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6rqP8le9ND5N9jvs8VM4YfyCudu6ASEAI306E22uBBs=;
        b=rCDu90Rh2U7g7lC70DEiosfUXqVVb7NLYQgMnPsJxs3ZqaQkyRzm4L5+y8EenAVPwY
         QLn2Wpa2AE3LiyB7dyGPhReco/lyOREtsmESEn3LHwqMdcrMpi7luJaUZ8R3URIEiYWT
         9R1xozG5kQ5qhXu2GgGecIwD1dW/2wnPlvWqc+y9OmiCmcg5E7uFjMZQz/bqUiiHNE1d
         SPUhUHeOQsR+hYWcjvEqipRg3tXIxyQFlOw0dNlX6Dzmb+6FHOfbyu9Z2u/0WKdZGS/Z
         c/37lbefANe3djVKjN3g5bkcM908faiCOdNiDI9FG1BBkhpjUgJqzhFbXHQ+/WOdysoO
         sMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6rqP8le9ND5N9jvs8VM4YfyCudu6ASEAI306E22uBBs=;
        b=W9HzymXTkH9wIVPzlGID+z7XPmrHKvU9m0iqyrQjDqIyplOZeGD5fFAD9HgVhqnCxV
         O/qraOVjMQzO92Tm1KAcB2SLydln0tv65xckiiNx9RMMk7A1j9CWk9gYXX0lVnld5jYx
         8Xnb0kwZ4x/HDvHsLBTV6are9Vnc+OU/RWuvt6VqI1VZhWgbxzCsbfy0kW+lw9pzGOts
         GNYc5KEntMVt1l7UlvIfTuE/ZUVG3ZAJfhXRxVTj0BOH4GRPvTTii1HfD/0LuOvNwGhe
         Zoq4Gc37Vy748h74p98qk74VWZ0ZecGUlaPC+yiP2KkcUW6wz9Q/dRL6nm9qGgNzDRoS
         ndog==
X-Gm-Message-State: APjAAAVGDVafh9xXRic/aR2nvcJfdNkeM/vUR07CSHowTR+JP07/0Ja8
        ZifvGsZDc3e2DkLcfnEP8nEA/g==
X-Google-Smtp-Source: APXvYqzBxNxRYyuGFUz0b9iE0rCpFQsFumoJaVxX5NXddgwzP6vqcmZTZiTYiqjYqan7cNGGorqtLA==
X-Received: by 2002:a0d:c081:: with SMTP id b123mr8682306ywd.474.1558720795971;
        Fri, 24 May 2019 10:59:55 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id r132sm796296ywg.33.2019.05.24.10.59.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:59:55 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
 <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
 <20190523091154.73ec6ccd@cakuba.netronome.com>
 <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
 <20190523102513.363c2557@cakuba.netronome.com>
 <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
 <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
 <93ee56f3-6e58-5c16-a20a-0aa6330741f7@mojatatu.com>
 <7c472cb2-f98d-d25b-1b4a-9ecef99a20a3@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a959986d-47bb-03cd-d408-854c25084529@mojatatu.com>
Date:   Fri, 24 May 2019 13:59:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7c472cb2-f98d-d25b-1b4a-9ecef99a20a3@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-24 11:09 a.m., Edward Cree wrote:

> Oh, a push rather than pull model?
Right. I thought the switchdev (or what used to be called switchdev)
did a push of some of the tables periodically.

> That could work, but I worry about the overhead in the case of very large
>   numbers of rules (the OVS people talk about 1 million plus) each pushing
>   a stats update to the kernel every few seconds.  I'd much rather only
>   fetch stats when the kernel asks for them.  (Although admittedly drivers
>   already have to periodically fetch at least the stats of encap actions
>   so that they know whether to keepalive the ARP entries.)

So that is part of the challenge. We had this discussion in Prague in
the tc workshop. Andy (on Cc) presented and a discussion ensued
(recorded on the video, about minute 24).

If you are going to poll the hardware from the kernel then, if possible,
you should put a time filter for "last changed" and only get things
that have changed in the last delta.
If you are using a model where the hardware pushes then ability to set
a time filter for "last changed" would be needed.

Note, Ive had to deal with this problem with tc actions from kernel-user
point of view.
See commit e62e484df049 - the idea is to not retrieve the 1M+ stats
but rather only things that have changed since last attempt.

> Also, getting from the cookie back to the action wouldn't be trivial; if
>   there were only TC it would (just cast cookie back to a struct
>   tc_action *) but soon some of these will be NF actions instead.  So
>   something slightly smarter will be required.

Well - this is that issue i was raising earlier as a concern.
I think netfilter should have called into the tc api instead
of directly.

cheers,
jamal
