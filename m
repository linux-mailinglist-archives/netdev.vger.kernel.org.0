Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EB36E2CC5
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 01:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDNXXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 19:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDNXXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 19:23:37 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6634C0D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:23:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681514603; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DBjbTmiZ+TPtWNnP7QLQxKxhjlF04ch8y5F+JA2SzaeXj7IOgmrn+FgJyIiKUslaP9nDlC69KK90paZcojFr12EKdDZN80HaNqsHCE1VQ4ApTAOTXSkKPL7j6E5pa1t/ZvYIAW7OWUW7oGn0yqQX+O1Qo1JA2P/nVvbZOkLP/Os=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681514603; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OQ4vG4XHyFvgYVpbG9jk2NumYaMOEY3MQz3YLxk1vdQ=; 
        b=fE6LEqjMVxNe9s+/gX5N7EPl695LOkj5Wswvc7BOnIkvQFn4ZDn+C9RMoP+zWbKgFgFebOKAAECv54VLtuEwiZKAS9Y2qXIUIK3qU0+2Itrk3P0OG6pNGME62iC4IqRqc8O1904GoSBXgpusKbtpjZORKp9Dy+ls7RaAaMSFeaA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681514603;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=OQ4vG4XHyFvgYVpbG9jk2NumYaMOEY3MQz3YLxk1vdQ=;
        b=IfE17H+m6p/nUhzT/wtN2kw0sFfrhmU5GffBUFg2PAYyiqYkqCPyY8gYD7N81Z6e
        BxCpYRbuTTZySrD8Sab9unACN/tVQMQ6DARom5VdEr6MkxmDk+jGoCIQAwiaWoUnjvA
        teUFK2PJcgcOmnPL+evSubkTGEdXeQyxS7M/4MOU=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681514600877358.9033906001564; Fri, 14 Apr 2023 16:23:20 -0700 (PDT)
Message-ID: <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
Date:   Sat, 15 Apr 2023 02:23:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
 <ZDnYSVWTUe5NCd1w@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDnYSVWTUe5NCd1w@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 01:48, Daniel Golle wrote:
> On Sat, Apr 15, 2023 at 01:41:07AM +0300, Arınç ÜNAL wrote:
>> Hey there,
>>
>> I've been working on the MT7530 DSA subdriver. While doing some tests, I
>> realised mt7530_probe() runs twice. I moved enabling the regulators from
>> mt7530_setup() to mt7530_probe(). Enabling the regulators there ends up
>> with exception warnings on the first time. It works fine when
>> mt7530_probe() is run again.
>>
>> This should not be an expected behaviour, right? Any ideas how we can make
>> it work the first time?
> 
> Can you share the patch or work-in-progress tree which will allow me
> to reproduce this problem?

I tested this on vanilla 6.3-rc6. There's just the diff below that is 
applied. I encountered it on the standalone MT7530 on my Bananapi 
BPI-R2. I haven't tried it on MCM MT7530 on MT7621 SoC yet.

> 
> It can of course be that regulator driver has not yet been loaded on
> the first run and -EPROBE_DEFER is returned in that case. Knowing the
> value of 'err' variable below would hence be valuable information.

Regardless of enabling the regulator on either mt7530_probe() or 
mt7530_setup(), dsa_switch_parse_of() always fails.

Arınç
