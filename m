Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED1825A259
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIBAmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIBAmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:42:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9019AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 17:42:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d190so4012340iof.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 17:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VKHLvH1J2VJaorrEDWRQw/ehzOWUl6yg1KAg6n1TROo=;
        b=I19hRBxpEcAkNRm32DFSRNfrJpGFUftTrMJGlcgwQedtviTgFN40wxw1AJ9sCAZ2aE
         cjWx4iXTs7I8QcazQlFJAVxLDH3tmDtLvqgC9liJfuS/t+WkAyGllaIG7xtqNPJJ3Q7a
         U8LIih1zwlmvslboF0eBhmJuyGdSzCM0DoFNX1EstvlFkgT2S8A2gtlf1Q1yQMUDs46j
         9TO8CveRJbFGQwQv5it49m00c3InA1rhP7pKzZ83XHE9KxvWOXR18l3Dk/y62Tizu5j5
         eOhzS6w2h6sNnho+12zWgWq8jvJmYjp4RtTcBIzBh4JzvPMw4537DXR13bN4F/MWFrRY
         UTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VKHLvH1J2VJaorrEDWRQw/ehzOWUl6yg1KAg6n1TROo=;
        b=aJfS0kw8KknHnkMXsyb9IgkJcEx/f1ZNmd37d5iK5G6HTsu2tSzNPq68OL8EO6+jQo
         8UpM12KCAyk5XMR/RKeRKxgtZ3FM65HkJkyTzd4iBOG7pE0HIDTPZYuSLNcZtxysQnzv
         HZm5m79V4QsE8yMN5cigroyuNJKdjrsy44523pNwYyVmEvdIIRX4HW3YcJXCFxq+WiFe
         +20fqR4bkZFtTSlSgTSkqCcb2boHk7UFU4lB8AlRzIhv8hKizb/M8TVAZKj3YHxzFkju
         wFHt7oOnyp/dk4zvGeI2Yx80DC0RmJRKoj7UtZ5TaWDLRVMkqt1Mclx104LASl9R0cHy
         D7+w==
X-Gm-Message-State: AOAM531WY+T2F7d3niZqFx6zvPIpnEjkQkEro3z4wycYYxdorPq1qg8b
        FQwEqTEidHevCeocUrK2ySeqla5oBCxPiA==
X-Google-Smtp-Source: ABdhPJwkkSYMfRRK3ctK0iam8JjLv3Q5ok+h/i1y5ZpmtqAeTl5uda/iwOnrOzSFwRyWfmrE75Kyfg==
X-Received: by 2002:a6b:6e0b:: with SMTP id d11mr1443011ioh.155.1599007331818;
        Tue, 01 Sep 2020 17:42:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id d19sm1292141iod.38.2020.09.01.17.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 17:42:10 -0700 (PDT)
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     mastertheknife <mastertheknife@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
 <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
 <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com>
 <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
 <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com>
 <CANXY5yKW=+e1CsoXCb0p_+6n8ZLz4eoOQz_5OkrrjYF6mpU9ZQ@mail.gmail.com>
 <CANXY5yLXpS+YYVeUPGok7R=4cm2AEAoM1zR_sd6YSKqCJPGLOg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f0e9d12-1780-cd1f-891d-940274f9105d@gmail.com>
Date:   Tue, 1 Sep 2020 18:42:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANXY5yLXpS+YYVeUPGok7R=4cm2AEAoM1zR_sd6YSKqCJPGLOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 4:40 AM, mastertheknife wrote:
> 
> P.S: while reading the relevant code in the kernel, i think i spotted
> some mistake in net/ipv4/route.c, in function "update_or_create_fnhe".
> It looks like it loops over all the exceptions for the nexthop entry,
> but always overwriting the first (and only) entry, so effectively only
> 1 exception can exist per nexthop entry.
> Line 678:
> "if (fnhe) {"
> Should probably be:
> "if (fnhe && fnhe->fnhe_daddr == daddr) {"
> 

Right above that line is:

        for (fnhe = rcu_dereference(hash->chain); fnhe;
             fnhe = rcu_dereference(fnhe->fnhe_next)) {
                if (fnhe->fnhe_daddr == daddr)
                        break;
                depth++;
        }

so fnhe is set based on daddr match.
