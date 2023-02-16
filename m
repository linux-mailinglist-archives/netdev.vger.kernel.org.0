Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E4B699BFC
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBPSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPSQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:16:51 -0500
X-Greylist: delayed 1310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 10:16:50 PST
Received: from mail.as397444.net (mail.as397444.net [69.59.18.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E8FA55A9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mattcorallo.com; s=1676569262; h=In-Reply-To:Cc:From:References:To:Subject:
        From:Subject:To:Cc:Reply-To; bh=DH/LCweObXbsrnud60h+QWqCj3WLFoW1LOMHYe/i3EA=;
        b=UDmoyIwhql7/ATDm/agzGyNjhIAs/Hi1MkxCt1+HS03cfMxfzXOclaV58SgeeDVtvbwRAd1755h
        red96sK4k/JvQ8epGtkvVkozVngrd69GlnxYo9vAAI5UGGbs/xn52qYPsltVN2IGcTm1UV4CtcmRI
        1r/4sSSNvadPkb83P/jyFo5QH0lmMqztpx/Yv9HsD7dBpDWEBNlacv0CAhfq5crnYi9UH98kGBGR9
        O7WqOiWI92DfKCeuETb2OPvot2rRY3jmivm4CpFXWUD8/MIBdtp34P08sOQZfX/L828QkpQh3S9WJ
        meP5i3qS7U0sSinMMmSXJet30t3NBHcFITkg==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=clients.mail.as397444.net; s=1676569263; h=In-Reply-To:Cc:From:References:
        To:Subject:From:Subject:To:Cc:Reply-To;
        bh=DH/LCweObXbsrnud60h+QWqCj3WLFoW1LOMHYe/i3EA=; b=UwCFv2UyUgJEAVH6Y5KUc8nvQc
        2VLXljobfFxTwTBHLJgBDh3ApiwevhMWi1dI6EFq5hp0AQmON82KpifSSpE8USEDBU1oJuEjcZuhV
        iTNXUm8jt68HKmg9Qt6KEyNZaVQ//jgtgZr8i8bOHdbZqa3RRyXrYh0QvcHWKieCQTHIMylIwYCvZ
        Bcf1i0DnWEE7fuGsGrBlCeQRqJG4OHkL88thBSHFR7NEZyjEod5YOYhG+NslkpBZsqUGGZE0jpsZP
        8d1oRfl4kQPSkUpvnN4MWbXjMMRCTMluw93FPBQa154NSguTn+zbDDDBY3K85gmhsmi03C3SkbjU8
        SxdgE2tg==;
Received: by mail.as397444.net with esmtpsa (TLS1.3) (Exim)
        (envelope-from <ntp-lists@mattcorallo.com>)
        id 1pSiTA-00AIbJ-1v;
        Thu, 16 Feb 2023 17:54:56 +0000
Message-ID: <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
Date:   Thu, 16 Feb 2023 09:54:56 -0800
MIME-Version: 1.0
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Content-Language: en-US
To:     chrony-dev@chrony.tuxfamily.org,
        Miroslav Lichvar <mlichvar@redhat.com>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
From:   Matt Corallo <ntp-lists@mattcorallo.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <Y+3m/PpzkBN9kxJY@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/mattcorallo.com
X-DKIM-Note: For more info, see https://as397444.net/dkim/
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/23 12:19 AM, Miroslav Lichvar wrote:
> On Wed, Feb 15, 2023 at 10:27:15PM -0800, Matt Corallo wrote:
>> My naive solution from skimming the code would be to shove
>> formerly-discarded samples into a global limited queue and check for
>> available timestamps in `phc_poll`. However, I have no idea if the time
>> difference between when the sample was taken by the hardware and when the
>> `HCL_CookTime` call is done would impact accuracy (or maybe the opposite,
>> since we'd then be cooking time with the hardware clock right after taking
>> the HCL sample rather than when the PHC timestamp happens), or if such a
>> patch would simply be rejected as a dirty, dirty hack rather than unifying
>> the PHC read sockets across the devices into one socket (via some global
>> tracking the device -> socket mapping?) and passing the samples out
>> appropriately. Let me know what makes the most sense here.
> 
> My first thought is that this should be addressed in the kernel, so
> even different processes having open the PHC device can receive all
> extts samples. If it turns out it's too difficult to do for the
> character device (I'm not very familiar with that subsystem), maybe it
> could be done at least in sysfs (/sys/class/ptp/ptp*/fifo or a new
> file showing the last event like the PPS assert and clear).

I mean my first thought seeing an ioctl on a socket that gives an explicit channel and then receives 
crap from other channels on the same socket was "wtf" so I went and read the kernel to figure out 
why first to see if its a driver bug. I can't seem to find *any* documentation for how these ioctls 
are supposed to work, but it seems the "request" here is kinda misnomer, its really a "configure 
hardware" request, and is unrelated to future reads on the socket, or really the specific socket at all.

As for duplicating the output across sockets, ptp_chardev.c's `ptp_read` is pretty trivial - just 
pop the next sample off the queue and return it. Tweaking that to copy the sample into every reader 
is probably above my paygrade (and has a whole host of leak risk I'd probably screw up). 
`extts_fifo_show` appears to be functionally identical.

I've CC'd the MAINTAINERs for ptp to see what they think about this, though it won't let chrony 
support this without a kernel upgrade - not sure if that's an issue for chrony or not.

Matt
