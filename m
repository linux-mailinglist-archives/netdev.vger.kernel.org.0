Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAE56EF5EA
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbjDZN7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240888AbjDZN7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:59:44 -0400
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D96585
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:59:42 -0700 (PDT)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 40f736d8;
        Wed, 26 Apr 2023 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=default;
         bh=jBz0OoLQowlqqEgtNiiINilej/8=; b=A9dJw5d85m05bcXPFuw+oHk3jVVr
        nDPpsplACKDTvBHbw5qSbBJz+bPLWliQ6xqu464MrU+4AAKKsme0ATONjiUb4Q/L
        jPQBfWOCK00obL6KpRIVEkSFrpNhpHgtfcIcLeNSwnnKDguNeKbb+p/emtYvXr+L
        jVt+7/oQ/BcEt8g=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; q=dns; s=
        default; b=fhyivziYoEJwGrpUASJfcCLPlzI7bDGYd8y60uLZ1T2A9rKlwuEVy
        AnLrqmlM1qI2mxItaJrykd5PYdwyg0JEyUpXPi3eIfWKBFd1QEacxSgyQGquoY9d
        BkHMW5Ytt/T5n4WpfBIJdKaqaP/HjjQgVmbzPS3I54CCreJ6Jroe2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1682517580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQM1Ucw+M927ShF7P9137B6V/7l9XGlyfGCK7/fNSOs=;
        b=V92wbgXh+tqx3SUBKJsUvrv6g4p2M0nBrr/0OXYrMjSLLiv9aJZza/Oq8vKt7XRn3vW6Q0
        OgNjQUBOYRt8ajm86OBjMhFBLuRc6icj1l+P2mMcY7XPi2TaS/1XF3MOkqKrXeJ8l7yp7b
        bW81iYjmIEBjfo20qcpjsm0zKeXlNKA=
Received: from [192.168.0.2] (host-79-40-239-218.business.telecomitalia.it [79.40.239.218])
        by ziongate (OpenSMTPD) with ESMTPSA id afbbd012 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Apr 2023 13:59:40 +0000 (UTC)
Message-ID: <141aebfc-46a3-7ac3-c984-dcd549124c05@kernel-space.org>
Date:   Wed, 26 Apr 2023 15:59:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: dsa: mv88e6xxx: mv88e6321 rsvd2cpu
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
References: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
 <5056756b-5371-4e7c-9016-8234352f9033@lunn.ch>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <5056756b-5371-4e7c-9016-8234352f9033@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 26/04/23 3:35 PM, Andrew Lunn wrote:
> On Wed, Apr 26, 2023 at 10:12:28AM +0200, Angelo Dureghello wrote:
>> Hi all,
>>
>> working on some rstp stuff at userspace level, (kernel stp
>> disabled), i have seen bpdu packets was forwarded over bridge
>> ports generating chaos and loops. As far as i know, 802.1d asks
>> bpdus are not forwarded.
>>
>> Finally found a solution, adding mv88e6185_g2_mgmt_rsvd2cpu()
>> for mv88e6321.
>> Is it a proper solution ? Is there any specific reason why
>> rsvd2cpu was not implemented for my 6321 ?
>> I can send the patch i am using actually. in case.
> 
> Should it be mv88e6185_g2_mgmt_rsvd2cpu() or
> mv88e6352_g2_mgmt_rsvd2cpu()? Does the 6321 only support
> 01:80:c2:00:00:0x or does it have 01:80:c2:00:00:2x as well?
> 
> Please do send a patch, and include a Fixes: tag.
> 

you are right, it supports also the 01:80:c2:00:00:2x,
will test that too, and will send patch v2.

>         Andrew


Thanks,
angelo
