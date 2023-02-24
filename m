Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BC6A1492
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 02:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBXBSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 20:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBXBSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 20:18:14 -0500
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:1::99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50B4713DFD
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 17:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mattcorallo.com; s=1677199261; h=In-Reply-To:From:References:Cc:To:Subject:
        From:Subject:To:Cc:Reply-To; bh=/3fq9beoOqhAmgdTVmvn5oAFax4Bxo3xdSQmxOPR1MU=;
        b=ARbIaPgSaTxfpjjb1MimClfjVgIqr3AGKig37WnBwqkJokGD2TFGp9CfUKNjfQmPJUWjetOy7Qe
        KLJAQAu0yRJKxsGH7h3aZB7o+nbg3ktfdOWedA45w9Kji6Eo8HHVggwW22Mav9fRJZkkLT4cpnc5V
        68mlCJbHvPeBRwGfCKtbXhd2BRTx7auovh7akZ0NekCJyj9nxwjWOe1hwVztH4q9FVs5o1Rmv4hg6
        siUjpSR0+2DFOkLHjMKq5USS7iTkgskyucjbinaPvheeIHYOnqobNsvylkKUkQ+pyKwe0tliaMW/V
        hNSXHgF63Iais7WJTn3e1w+ghU6cZpehqBBA==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=clients.mail.as397444.net; s=1677199263; h=In-Reply-To:From:References:Cc:
        To:Subject:From:Subject:To:Cc:Reply-To;
        bh=/3fq9beoOqhAmgdTVmvn5oAFax4Bxo3xdSQmxOPR1MU=; b=Ws0M4WX7dVJ3l/N4rrvgw8PlPF
        sVW8731RJf2a8mf7LDMNRwmM8ul/IUlDUdEKZU3ttFB2ilMedlr9fAdp5IUBap7X1rW8YaZPkzIiL
        xgYTdN/aobgBjfmBXHF3TjA3PZwc/T2WWSCRzrqE+EM2N6lwHPJtibwIxB8Uf2IdDBRckyA1DN0Zg
        vpTeoEpPJAJm1SJX7pVyUkiiTr47MWD7m0MmbIuIjun7NyaZvEF8TJMSLRHyDZppir65nzUnNkMLG
        tLuX/SQ/8by892N7FlhogDlVdYksdI05I1zomKHPyX9TBJ5seVZgdsdBnwXKlDLrRt9PGw1HudxjY
        HSwehXIg==;
Received: by mail.as397444.net with esmtpsa (TLS1.3) (Exim)
        (envelope-from <ntp-lists@mattcorallo.com>)
        id 1pVMis-00BtGq-1A;
        Fri, 24 Feb 2023 01:18:06 +0000
Message-ID: <5d694706-1383-85ae-5a7e-2a32e4694df0@bluematt.me>
Date:   Thu, 23 Feb 2023 17:18:06 -0800
MIME-Version: 1.0
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org> <Y/NGl06m04eR2PII@localhost>
 <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
 <5bfd4360-2bee-80c1-2b46-84b97f5a039c@bluematt.me>
 <Y/gCottQVlJTKUlg@hoboy.vegasvil.org>
From:   Matt Corallo <ntp-lists@mattcorallo.com>
In-Reply-To: <Y/gCottQVlJTKUlg@hoboy.vegasvil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/mattcorallo.com
X-DKIM-Note: For more info, see https://as397444.net/dkim/
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/23 4:19 PM, Richard Cochran wrote:
> On Thu, Feb 23, 2023 at 12:56:34PM -0800, Matt Corallo wrote:
> 
>> There's two separate questions here - multiple readers receiving the same
>> data, and multiple readers receiving data exclusively about one channel.
>>
>> I'd imagine the second is (much?) easier to implement, whereas the first is a bunch of complexity.
> 
> This second idea would require a new API, so that user could select a
> particular channel.
> 
> First idea would only change kernel behavior without changing the API.

Fair point. I figured a new IOCTL to filter was a lighter lift, even if a bunch of boilerplate to 
define it.

I'm happy to take a crack at something to get the ball rolling, though not this week. I'm sure I 
could copy+paste to make a new IOCTL work, but adding relevant queue limiting means I have to go 
read much more kernel code to figure out which datastructures already exist there :).

It sounds like I should go replace the extts queue with a circular buffer, have every reader socket 
store an index in the buffer, and new sockets read only futures pulses? I assume a new pulse already 
wakes all select()ers on the sockets so nothing would need to change there. Is there some existing 
code somewhere I should crib off of or just run and see where I get?

Thanks,
Matt
