Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07164F169D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376505AbiDDN7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376436AbiDDN7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:59:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141FD3EAAF;
        Mon,  4 Apr 2022 06:57:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c42so3757093edf.3;
        Mon, 04 Apr 2022 06:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DZAZVBwAShxU5u7fT6BbCZ+cQt51H9PsjF/8xPB3ZlU=;
        b=i8qh5fhg0UqgwGRnh95t8swhhyAwQY2n/t9uOBy+TL89eBpm/rFs0b39QbPRrf8MGn
         WyOxmYfG8fd5ON21qte4eGvOQmOnE+tCvuGeriTqHv300iGTrxnqlgDH3pW7+I8toGLQ
         ZAvBD4gnhRsSUDCW3o4yQzbJpNrXaSIAgL+xQCv0kjnWXXp0JL+7bx1ZsliHqX3kwV/J
         YqezPusqC4W5SV/QchoesphLGHmNn3DA9tWBJiVcqNBEQaTrCdjZW/1V/F963/zevopW
         QneM6SOZ+mrRzdSn3WGfRxf6zPkO/5wjF2QqKdXGBsGFvqDr8cEY8Fwgpy5/sJSsO9LH
         s0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DZAZVBwAShxU5u7fT6BbCZ+cQt51H9PsjF/8xPB3ZlU=;
        b=6zL5C9WY1/aKTqi4u5ruyHOT8OuIPTO7KCDdIDK8Vo7ywsn+rvOzKJ+yUwKlbCLMrv
         fvJt1o09fp5rC3oQZew/eqyTlmMs6fIjvTbzL383FhyVs/1AX8177ovqWCPL2P1kS4gm
         d1M0DxRK9ucqzwIAaZajlriHRMf+X8vLZs3lYsB/wAUqi6mKK/6lpB7KI4r4BI4omZcF
         dZlji2TJWbb09sanUTI6XUQcnf4AK3h7LPldIQHvtDCt2aYTci5us07YJlOiv8fWqeMK
         fY7qWWebhldNxwZNqj1yM4PzuJYFPTRcCQa96TZctGle3vByQwI5NSlftupv33lAwYR7
         qBoQ==
X-Gm-Message-State: AOAM530G6amyhW4/f6O3x4kbQBZ/cjZXtyhXKaTJh85MvGf+KR45rKlX
        h9BoZwHmCvQzCMKbFwp5qBg=
X-Google-Smtp-Source: ABdhPJzlykMaag65xiPEIcEggH138cKd7VNLVaGqUsbaxrVKIVw51ya7IQZECt8xidWF+jQQhsJTqQ==
X-Received: by 2002:a05:6402:1d4e:b0:419:5a50:75f6 with SMTP id dz14-20020a0564021d4e00b004195a5075f6mr110694edb.403.1649080636593;
        Mon, 04 Apr 2022 06:57:16 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm4457482ejc.25.2022.04.04.06.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 06:57:16 -0700 (PDT)
Message-ID: <743c57bd-514e-d17f-ba43-607e3cb83a95@gmail.com>
Date:   Mon, 4 Apr 2022 15:57:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] ipv6: fix locking issues with loops over
 idev->addr_list
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220403231523.45843-1-dossche.niels@gmail.com>
 <Ykro/s5+kd+po26e@lunn.ch>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <Ykro/s5+kd+po26e@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/2022 14:47, Andrew Lunn wrote:
> On Mon, Apr 04, 2022 at 01:15:24AM +0200, Niels Dossche wrote:
>> idev->addr_list needs to be protected by idev->lock. However, it is not
>> always possible to do so while iterating and performing actions on
>> inet6_ifaddr instances. For example, multiple functions (like
>> addrconf_{join,leave}_anycast) eventually call down to other functions
>> that acquire the idev->lock. The current code temporarily unlocked the
>> idev->lock during the loops, which can cause race conditions. Moving the
>> locks up is also not an appropriate solution as the ordering of lock
>> acquisition will be inconsistent with for example mc_lock.
> 
> Hi Niels
> 
> What sort of issues could the race result in?

Hi Andrew

The issue is that the protection of the address list is lifted inside of the loop for a brief moment.
Therefore, the looping over the list loses its atomicity.
I believe the list's entries might become corrupted in case of a race occurring.

> 
> I've been chasing a netdev reference leak, when using the GNS3
> simulator. Shutting down the system can result in one interface having
> a netdev reference count of 5, and it never gets destroyed. Using the
> tracker code Eric recently added, i found one of the leaks is idev,
> its reference count does not go to 0, and hence the reference it holds
> on the netdev is never released.> 
> I will test this patch out, see if it helps, but i'm just wondering if
> you think the issue i'm seeing is theoretically possible because of
> this race? If it is, we might want this applied to stable, not just
> net-next.

I am not sure, but I believe that it may be related, although I believe it would be unlikely to happen.
In your case, it could be because of this non-atomic handling of the list entries:
this could perhaps, for example, result in skipping an instance of ifaddr in the loop if
there is another change happening to the list in the meantime. Then the instance would've never been put,
hence not changing its refcount. But again, I'm not sure about this for your case.

> 
> Thanks
> 	Andrew

Kind regards
Niels
