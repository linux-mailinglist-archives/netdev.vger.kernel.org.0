Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743766B98B0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCNPMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCNPMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:12:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA37A56B4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m2so1900599wrh.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678806747;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uu4OxGwHFnmcJsNr+Ij2sDXAGYQET4DLnosCZwz6ldk=;
        b=ePlsEotwwA0R40N3aCbwNUHJ+MeyEFJlvIgkn71jjTKLARlSkwEoXZx2bdEiAeJnkS
         YB5wbgQkANC8hxNQKdbsDunW6+jJEMhDq7PyTwS0S476G3deoe7HWlT6C+P/HMyUsa9k
         XtyLbvaoUmhkzBx6pRfRjnMh19Y50n6eemvMY6ERQxSrdY8iDQ1oZqSnsX+Mr+6a0mCV
         gz6r1Fo6vd3FKYEZodXKVA0POy4dTgKIPD+nePdUcgXeXBGLpNyGNVm47uTaAx+5Sl4Z
         ZIAgoCKEEPmeD0O1Jeb0I+0038amS/eMjqSxW3jh3Y4DMWIMyw9huylCfTK/No2v3QUf
         APRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806747;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu4OxGwHFnmcJsNr+Ij2sDXAGYQET4DLnosCZwz6ldk=;
        b=qV4sWRNdj0ADTAm2v64VxlHlWJhcbp8delhDMBsVDskmbb2E9Ed60PHtkohOn5Q2mj
         vqtHJqGpFNhSA3d9jH0JRHj/t14nzAidb29ItOt+g1eaEXETlAdzRjUoXa71nSEVRGEl
         gAi/GbVR8bTwWhzyGyqMWwu35M+m0bZX/MW2VAdzLdmsYRS2DLY52GrlBVoE7RroEj0z
         JJNztD2R0HzpOnHuJAX2NLxmR8wAZu2SEzuyv0WErsFvfpo3klowjMs4PQtCvTZccdIM
         fnRspRNk31c18EtMOsPOEkYuaEi9hrC6325Ju2mrRzNU1DIMCnlt+JH7ANSN8KqQj3oH
         LyZg==
X-Gm-Message-State: AO0yUKUE+RJrtMMT8JCuheKrkPYAzWl5pHk+pdMs0hgjjUv2WztAt/QB
        +++meW31D2WbR/vGP7ff3odAww==
X-Google-Smtp-Source: AK7set8hq02W/Qk4LmkJEA1BPEzNDuwjoBNyIOJUyMOxby1tAy50gxAo3CdvYt888Dm96ezIgaJPbA==
X-Received: by 2002:a5d:60c1:0:b0:2ce:aa72:d60b with SMTP id x1-20020a5d60c1000000b002ceaa72d60bmr5989034wrt.38.1678806746598;
        Tue, 14 Mar 2023 08:12:26 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id a5-20020a056000100500b002cea299a575sm2261838wrx.101.2023.03.14.08.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:12:26 -0700 (PDT)
Message-ID: <f78b6206-fc16-44f6-e396-b7670f1fe9b9@blackwall.org>
Date:   Tue, 14 Mar 2023 17:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-2-razor@blackwall.org>
 <ZBCLfr2qvgz5Vwos@localhost.localdomain>
 <8be545ec-abe2-1313-7c64-e509266ebd77@blackwall.org>
In-Reply-To: <8be545ec-abe2-1313-7c64-e509266ebd77@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 17:08, Nikolay Aleksandrov wrote:
> On 14/03/2023 16:58, Michal Kubiak wrote:
>> On Tue, Mar 14, 2023 at 01:14:23PM +0200, Nikolay Aleksandrov wrote:
>>> Add bond_ether_setup helper which will be used in the following patches
>>> to fix all ether_setup() calls in the bonding driver. It takes care of both
>>> IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
>>> latter only if it was set.
>>>
>>> Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device changes type")
>>> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
>>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>>> ---
>>>  drivers/net/bonding/bond_main.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
[snip]
>> Please add your function in the patch where you actually use it.
>>
> 
> I'm adding the helper in a separate patch to emphasize it and focus the review.
> I have written in the commit message that the next two fixes will be using it.
> IMO, this should be ok.
> 

Also since both fixes are for different commits this should be backportable
for both, that makes it easier to pick if only one of the two would be ported to a
specific version (i.e. the first fix is for a commit from 2009, second 2015).

Cheers,
 Nik
