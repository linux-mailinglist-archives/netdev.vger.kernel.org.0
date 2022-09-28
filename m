Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343885ED848
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiI1Izk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiI1Izi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:55:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DCB6D15
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:55:37 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h7so6289407wru.10
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=Uym5fMaQVWn0/pKz7baCkD/kyjxDpn/g2B/qr8dEbZo=;
        b=U7Hyabd9pUnhlCRG4YfP3lUR6mHvUGI+qTmItO1UIxPy4zH3yVQTReDBUwmNLTC+q8
         PwB8qoWz7WO+7fQSkc9LPwU4Q4sW/pULXuxUkrzWTR2wrv5nq6VIbnTkAwJ+sF98RtOk
         r2J2m4O7tTD3avuPMISViXguqT7JPggk2wm/RZpKrGhps9WzBc622T4ntyKM1AuVYf6i
         hvo753Cu0NC10pzxhewYwAB0CJ3flUzeLVAgjojlAuG6q9VNWXC0b5gx+E+C/Z7343q6
         k+dP6zQD9pYPmpQHJe2h8n5UehvatGa9t2ygGVHqPdsK8gbMxA68v8MogKhnwM+Bp+Xj
         leHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Uym5fMaQVWn0/pKz7baCkD/kyjxDpn/g2B/qr8dEbZo=;
        b=ty3pqwPyrYMJnwWNEaUpeD8VVRMhbyDvGiTfI6DlDbNAXNM+7PvXBT0gpVXld9SsDY
         k2FwLlqf9dlpARyYVVPczXipjyzkZykMD0+tzc0YEI85V7yGHgugepWqOT1P5kbtrUoz
         Cw3YUM7Czu5r18bPz49dXl3AxX+aovTyur7YHnoWXZKzj7cuakRYfva4zOj/pIF8HH77
         TqMOfFFtAC/1prpJCk9tSTRQdaqFSETiHDCnlQ3bDLpTyl9ATF5kvzBoFh1j3Yw6knqy
         obFbtpYQUcslkoIPk3CBOpNe0ZeYFrYPH4s0HmYy9+24mpFHcM+O+natOg/SVgBecnii
         97Sw==
X-Gm-Message-State: ACrzQf3GgA6ZCWLVv9AOFmTtILvf2OKmZKwxF3IJJD+sg6/ie0sKPqPV
        jlyTyxTsy7U34oNgNa3eqX9obg==
X-Google-Smtp-Source: AMsMyM5Ae7UWZ9a0X04lbtb+j5gu7VbCaohEtpQt/UeqIi+L/eNLnO0wZdLSTEGjThtMUrp9xqj13Q==
X-Received: by 2002:a05:6000:1acf:b0:22b:36ad:28e with SMTP id i15-20020a0560001acf00b0022b36ad028emr18874835wry.314.1664355336006;
        Wed, 28 Sep 2022 01:55:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:3555:34ed:fe84:7989? ([2a01:e0a:b41:c160:3555:34ed:fe84:7989])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c0a0200b003a4efb794d7sm1221678wmp.36.2022.09.28.01.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 01:55:34 -0700 (PDT)
Message-ID: <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
Date:   Wed, 28 Sep 2022 10:55:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,

Le 28/09/2022 à 10:04, Florent Fourcot a écrit :
> Hello,
> 
> About NLM_F_EXCL, I'm not sure that my comment is relevant for your intro.rst
> document, but it has another usage in ipset submodule. For IPSET_CMD_DEL,
> setting NLM_F_EXCL means "raise an error if entry does not exist before the
> delete".
So NLM_F_EXCL could be used with DEL command for netfilter netlink but cannot be
used (it overlaps with NLM_F_BULK, see [1]) with DEL command for rtnetlink.
Sigh :(

[1] https://lore.kernel.org/netdev/0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com/


Regards,
Nicolas
