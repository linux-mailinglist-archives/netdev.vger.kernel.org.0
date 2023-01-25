Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5125667B124
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjAYL0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjAYL0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:26:20 -0500
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D8A24C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:26:18 -0800 (PST)
Message-ID: <c582757f-a633-3958-d72e-e606e43879db@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1674645975;
        bh=L0iLjRUkh1uci0MNWNG16MSHcoo/lfeFhBP5LOA4qH0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=ZxWWnlzwwRsiPSE39Cc+o5u/JaGCXn/WufoppX2y2Cf+8NW17D2y4QYtuwacCwK5w
         2Qb+CKm7RrklnjBWDTiZb8aXpIsLVFnCyEHcEGmoFySFygWtbChzxtAU3wnTSvXBYR
         Bri1S8iEg17NjDMkvIDWcOX1bxkMjebZOy59G/Bl4vZ07kaF+IjHNoJX5rXNXK8Wfj
         GY5HlBJqIREcb6V6rakkMxSj5eGoEC/yjqEnP9ci2JoQd7PTzLcda4giv9mSy3fzB+
         8OvCTp0ZmMuKooVMc8J+d/G21EWgq35KHML5iS9MYiujzElOdi4mt/FFy8MFC9+CDC
         RX0qRND446+VA==
Date:   Wed, 25 Jan 2023 12:26:14 +0100
MIME-Version: 1.0
Subject: Re: ethtool: introducing "-D_POSIX_C_SOURCE=200809L" breaks
 compilation with OpenWrt
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
 <77b6a4f9-be34-c1c6-9140-a39633fe4692@gmail.com>
Content-Language: en-US
From:   Nick <vincent@systemli.org>
In-Reply-To: <77b6a4f9-be34-c1c6-9140-a39633fe4692@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed, it is fixed by those patches. Thanks! Why are they still not merged?

On 1/25/23 00:28, Florian Fainelli wrote:
> On 12/27/22 07:23, Nick wrote:
>> Commit 1fa60003a8b8 ("misc: header includes cleanup") [0] introduces 
>> "-D_POSIX_C_SOURCE=200809L".
>> However, this breaks compilation with OpenWrt resulting in following 
>> error:
>>
>>> marvell.c: In function 'dump_queue':
>>> marvell.c:34:17: error: unknown type name 'u_int32_t'
>>>    34 |                 u_int32_t               ctl;
>>>       |                 ^~~~~~~~~
>> Not sure, why the code uses u_int32_t.
>
> Should be fixed with:
>
> https://lore.kernel.org/netdev/20230114163411.3290201-1-f.fainelli@gmail.com/T/ 
>
