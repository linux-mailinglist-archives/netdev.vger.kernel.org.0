Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43809609E32
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJXJoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJXJog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:44:36 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBFEE4B
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:44:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so9544339wme.5
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cKbucU/IUZcAQQsLiS3DB2W32TroQ7AAyD9l71dyaUk=;
        b=huZqcV008xcZTVY0FnuelzG2dzHHno9WF9RMNMdC0D8AJE/++TQ3MX5IUzjp2z8JbL
         hpxDaIBgnXXVDQsx7PuAbW0rhQqBv5yghJyxnf73YMtStjU2kQi0G/2/bBsnhoPJIG/M
         h0h9ttBY+nsVf7/3O72KSqU2rrnTcY2Qmu9A97ponOswP+uR5uksz3m714zy+raEWC7l
         SWAzJT7E47h8L7bF2zbgnu/J00TO6xVnEWiXGy5P27Db9fHFnr4EtHIjQKiySu35K/kG
         D/kQzuub4PwCQQMETnaG89xrmdZ3dPqEXTNzUsHKALJ45JYFC4nkhj8I3VErwmIuI0do
         r+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKbucU/IUZcAQQsLiS3DB2W32TroQ7AAyD9l71dyaUk=;
        b=YVgl851I01Dym3629N4o1y4c8EfllFAI2+Ko8ZOpFib+1WMhdigJs0BLPUD+jiVZEq
         vwk6FFvrdbpYlMIPMWaM+FEUNQL9/Jduh7D/UUmdQpIbgyh0brfWwytwb38sZsnBlMyf
         8koMKVs7E5Ej6r3sV/7lZgKhn+Ip52N5kjUkoNsv6kQK6hV5W7cQqnoA3EgemcVUm+bb
         wqie7w97spU2TpTUuLPAumUD6lORwcwrZ9h2BJsswjAsgU4+kYPPx/OYT4T5zOVxKhxk
         bRLkdmzfvYpFLXMJsohF4R35/8CKcMzzrerUcv4DKYMG4Bq4jOlPHwRpM9GPu16I8ZsE
         CPbQ==
X-Gm-Message-State: ACrzQf1V368EgewrYMT+sstoCSwIdai2aQW6dhue8CiG9lWdmY7DNnJt
        D8tzloZPbA/czQfukbngRqW7vw==
X-Google-Smtp-Source: AMsMyM4umPILC1oEtMSJ51plHHUqHIatWc/lkDMmjO66/KRtV6dWncNmZ+KPEAcVH8ZNk8eOViOkfQ==
X-Received: by 2002:a05:600c:548a:b0:3c6:dd03:2d31 with SMTP id iv10-20020a05600c548a00b003c6dd032d31mr21549695wmb.95.1666604663357;
        Mon, 24 Oct 2022 02:44:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:416:9ea1:405b:86ea? ([2a01:e0a:b41:c160:416:9ea1:405b:86ea])
        by smtp.gmail.com with ESMTPSA id d4-20020a05600c3ac400b003c64c186206sm10390857wms.16.2022.10.24.02.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 02:44:22 -0700 (PDT)
Message-ID: <eb6903b7-c0d9-cc70-246e-8dbde0412433@6wind.com>
Date:   Mon, 24 Oct 2022 11:44:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFE net-next] net: tun: 1000x speed up
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <20221021090756.0ffa65ee@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221021090756.0ffa65ee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/10/2022 à 18:07, Jakub Kicinski a écrit :
> On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
>> Bump the advertised speed to at least match the veth.  10Gbps also
>> seems like a more or less fair assumption these days, even though
>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>> and let the application/user decide on a right value for them.
> 
> UNKOWN would seem more appropriate but at this point someone may depend
> on the speed being populated so it could cause regressions, I fear :S
If it is put in a bonding, it may cause some trouble. Maybe worth than
advertising 10M.

Note that this value could be configured with ethtool:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e24f2dd516ed

> 
>> Sorry for the clickbait subject line.
> 
> Nicely done, worked on me :)
Works for me also :D
