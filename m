Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D67572F4F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiGMHgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiGMHgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:36:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F9AE3C08
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:36:40 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bu1so13065093wrb.9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=MdAHa4jvV4C61lS/YeKy1KwD7XmY18P8L/Gmr/vIAzo=;
        b=DvESuBr3QYALhmxjU4nnoks3WVrH9XT5YjCROBtVLRE0nY5cwMX0ZJ+CTXJA5BXiFK
         ia+NWAnKyPdP318qYQ6DBIgdoLY3S1z7hnYUmDeyw/s8jwdfeUMLJfH3s+8xGbuwmE+r
         pEV6Qq5jzCOi35k6ktXQCEjxdYvnUvJVzleEE4UkX8UVcxxj3NW1Fs5FLobPLRa3/hzb
         F8uG56ALzif8WBxhZ6pWG0qMN72Ueh1FHLNTqg4+OQKQSlRaHXOPiAR6L4Nvtfkitfa/
         tWGwm4zjZVasYlgiG7fBAVcUcjLkqD1C26riGfW8bPsUaJskvIY9B1qf/w/34dvjOa6m
         BPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=MdAHa4jvV4C61lS/YeKy1KwD7XmY18P8L/Gmr/vIAzo=;
        b=zrV5uk3C/eJXJPoxs5E2jz2rOQIRbio23x9+tfu4yoyN+M25q5tCdETR9s+YtzQXEA
         s4il9LNMWzb3GE6p4o325Q9p2Y7mPM+s4YB9V4Q9tEcprAyXcymKWJPEdig6J7xVWqak
         KzzxEps4q6Cud6DfZsG1YaGW3KX1N9lEroyR5rPCj8Y+l56kQgFjvlerc322ItwsJCWm
         U0x2JN4BWIAsb/w8i1vb40V+s6gqOIS7v3agXDWbWEeJl1WwPfQ3dyXWs+lblq7ZmBvG
         rzcfyoekF6HMk5vAjR5cxIq2+kbKBMwH4s0plCudoc5tF1v3GGeIYRgHWkpbUwjDzPTY
         IhyQ==
X-Gm-Message-State: AJIora9Fs6dVsVi/QsoU4bAEm10TekH6K8wVrxI405JXJXquvdeh1sbV
        38hSDcu3XmpApKuLhzffkKr+IQ==
X-Google-Smtp-Source: AGRyM1sOpzYUu5kzMZvGmN1S9zzvkkgrHqfKhV0PGfAhm/2tAMlJs21an00rphgazx/bEoC+b/xceQ==
X-Received: by 2002:a5d:6e88:0:b0:21a:3403:9aa0 with SMTP id k8-20020a5d6e88000000b0021a34039aa0mr1855749wrz.379.1657697799283;
        Wed, 13 Jul 2022 00:36:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:d92e:476:25ee:30ed? ([2a01:e0a:b41:c160:d92e:476:25ee:30ed])
        by smtp.gmail.com with ESMTPSA id b3-20020a5d4b83000000b0021d6dad334bsm10201905wrt.4.2022.07.13.00.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 00:36:38 -0700 (PDT)
Message-ID: <c4eccb16-3b45-1644-d4b0-ee3fee3810d9@6wind.com>
Date:   Wed, 13 Jul 2022 09:36:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2 2/2] selftests/net: test nexthop without gw
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
 <20220712095545.10947-1-nicolas.dichtel@6wind.com>
 <20220712095545.10947-2-nicolas.dichtel@6wind.com>
 <Ys1JefI+co1IFda4@kroah.com> <20220712172515.126dc119@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220712172515.126dc119@kernel.org>
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


Le 13/07/2022 à 02:25, Jakub Kicinski a écrit :
> On Tue, 12 Jul 2022 12:14:17 +0200 Greg KH wrote:
>> On Tue, Jul 12, 2022 at 11:55:45AM +0200, Nicolas Dichtel wrote:
>>> This test implement the scenario described in the previous patch.  
>>
>> "previous patch" does not work well when things are committed to the
>> kernel tree.  Please be descriptive.
> 
> And please don't resend your patches in reply to the previous version.
> Add a lore link to the previous version in the commit message if you
> want. In-reply-to breaks the review ordering for us :/
Oh ok, I didn't know that.
