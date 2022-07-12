Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD25714FA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiGLIqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiGLIqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:46:03 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE92A5E7D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:45:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id f2so10151842wrr.6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=9UErsJ+9xhst+m1vHMqrZ788bYitqXMrmN69ZeXmTU8=;
        b=G5elakXms12740Y0cTdld48XUdkQTbhDSrFKc0g96DQrIlMB12DCEUfoGbLTgH08sU
         VMBWMcc9hJ19o3wLt8TaAY9p524NhxkYRGLgR8UqiU2yEAeUkM2LCVacH5STA0RNUpXK
         TggVh57AOZnZVrKXyQ08aTPMZBwssiq1KRtrLZegVsza83yHasSV2+wJHVS35GrJIRtV
         Ak12GjCPQFTkbfSGYn/GAc92MEDcQf+3WUDi3WEiHvXFFilEw/kjLL0lEEF1C8nd6SGV
         r9kA7V/xTKE2qSca/VugTsKL42rk6C/6G2epHo/35NP4cgio0klLXoJ8jAO+rIX5/06L
         l8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=9UErsJ+9xhst+m1vHMqrZ788bYitqXMrmN69ZeXmTU8=;
        b=PgwogdRJfdggkKbfWV3bClebfSw/Q3nGpNpaLcVYwkRwgmDvlcFufHWmEuYFmvch+u
         MKTmpeOO6wWs827GG1jMsaPFoxP46YBN1XM5f0YCOK49gTmspd3yRDd9RHksAlJV5nlU
         dHWUCFRkBMbAgf8kMQok2Zh57aSW02UrGmX2CbZWwWugJ1upENOdeMoKaupwJkkmVqGn
         ofENSxY1La8fgGOdvJikRka0Sz+B7U8dBB3rloe/FP6/Wz56KojGtU9gsHyBmI2LcshX
         RrZ9Gk85wardRdHAny2u1C6K9eqOhS2mGh8ko5oFi0Hm9o64V+ZBNUeO2h1iDfD3AWhc
         eWww==
X-Gm-Message-State: AJIora/Ki1730jj4fbYITb1jZS3SRrOt7exAC86vzk7/Ut6yQk+eMKzD
        5dMOzSepDLa37D+7cwyvt5gIplffbLATGQ==
X-Google-Smtp-Source: AGRyM1vnq35olLirLaFsRc6wuH6b/i+mYCD3wg+ZAuNoAe2Rq04V0qaoseDLPFHABUBhyHJwidiepg==
X-Received: by 2002:adf:fbd2:0:b0:21d:9b35:ab02 with SMTP id d18-20020adffbd2000000b0021d9b35ab02mr13573087wrs.440.1657615556418;
        Tue, 12 Jul 2022 01:45:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6422:a9c9:641f:c60b? ([2a01:e0a:b41:c160:6422:a9c9:641f:c60b])
        by smtp.gmail.com with ESMTPSA id y12-20020a5d620c000000b0021d63fe0f03sm7633670wru.12.2022.07.12.01.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 01:45:55 -0700 (PDT)
Message-ID: <806e5672-f890-fa06-040b-2d59ed80d9e3@6wind.com>
Date:   Tue, 12 Jul 2022 10:45:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 1/2] ip: fix dflt addr selection for connected nexthop
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Edwin Brossette <edwin.brossette@6wind.com>
References: <20220706160526.31711-1-nicolas.dichtel@6wind.com>
 <231358c3284c5ab18981ad9cbc143154d346ec9f.camel@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <231358c3284c5ab18981ad9cbc143154d346ec9f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 12/07/2022 à 10:11, Paolo Abeni a écrit :
[snip]
>>
>> ip -n foo link add name veth0 type veth peer name veth1 netns bar
>> ip -n foo link set veth0 address 00:09:c0:26:05:82
>> ip -n foo link set veth0 arp off
> 
> It looks like the 'arp off'/fixed mac address is not relevant for the
> test case, could you please drop it, so that the example and the self-
> test are more clean?Good point, I will remove these lines.

[snip]
>> Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
> 
> Why that commit? It looks like fib_check_nh() used SCOPE_HOST for nongw
> next hop since well before ?!?
Yes, but with "standard" route, ie when the nexthop objects are not used, the
scope used, at the end, is the one specified in the netlink message.
With nexthop object, the user cannot specify the scope and we end up in this
problem.
Thus, the problem exists only with nexthop object only.

I tried to explain this difference in the commit log, but maybe it's not clear
enough.

> 
> Otherwise LGTM.


Thank you,
Nicolas
