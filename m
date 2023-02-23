Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6FC6A1188
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBWU4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBWU4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:56:43 -0500
Received: from mail.as397444.net (mail.as397444.net [69.59.18.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BA20311E5
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mattcorallo.com; s=1677183662; h=In-Reply-To:From:References:Cc:To:Subject:
        From:Subject:To:Cc:Reply-To; bh=zjuVt2RBPexF6eq2e8w+lgjrwxaIaax7mnFcfwgZwBY=;
        b=PaRJ1phb6c6KMQRLdfDStiaqbSBseE9CsiB9Wn/852gnhhMH6TFWvYdtVtT8E6Ik6iZGToQ/3JR
        z0i53/VHGMyXUFeYeCCEhAlkiGxmZL+DlMeZ+G4u80pIrt29nfZmFO8OY2UyNZ/d5TMISj5oNRcu7
        GuFXWBkF8RXumx2RZe0lT7M0128ZmZuqGxd3hVBsYtQ7yR9m7dREZX3DSgCGHf45XCTFt41F99d0D
        0L97dxWVJWfv4Y4mr4iVqJYWDrbbbvDytLDUHyU07UCSGBuFlWzUZySqUB5SAmPYR8jTfi3HBoFFn
        BAKGbt9UZjp6i/qkbQF+P4+7cIs3CaPy0hdw==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=clients.mail.as397444.net; s=1677183663; h=In-Reply-To:From:References:Cc:
        To:Subject:From:Subject:To:Cc:Reply-To;
        bh=zjuVt2RBPexF6eq2e8w+lgjrwxaIaax7mnFcfwgZwBY=; b=aVlOgv5rjRs8zO/6kULrHdipBJ
        QKutLPZP6Dkf20oNAIOsaMl1p5ZDBB5kUTnvuh8OZPhpeZJSkmPSvBd73tTF6TpGe3jMAYfD8RXSY
        Bp4wonOy0vgefiwazMo/EGdMwqGSMbrYTRA39b0fyDS/Q78MLqbUrgi3qZbxHQoj/es0v1kZcnpXk
        75xIqwBBnrJo1ov6sDGbpnrsPtx0SZpjaW26HBo2FPAGRLaGz83GBGQvFWT+ILusCOo0VTmZIwdoa
        j1QzBsGOExiIwgCOF0bxH1yqTrlRIMvHfI6E5wNfzm+C649v0AcKwKUZhc6K43Spg2hJkw2nYZsTk
        ouHoZwJA==;
Received: by mail.as397444.net with esmtpsa (TLS1.3) (Exim)
        (envelope-from <ntp-lists@mattcorallo.com>)
        id 1pVIdn-00Bqlw-0H;
        Thu, 23 Feb 2023 20:56:35 +0000
Message-ID: <5bfd4360-2bee-80c1-2b46-84b97f5a039c@bluematt.me>
Date:   Thu, 23 Feb 2023 12:56:34 -0800
MIME-Version: 1.0
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Cc:     chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org> <Y/NGl06m04eR2PII@localhost>
 <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
From:   Matt Corallo <ntp-lists@mattcorallo.com>
In-Reply-To: <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
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



On 2/20/23 7:24 AM, Richard Cochran wrote:
> On Mon, Feb 20, 2023 at 11:08:23AM +0100, Miroslav Lichvar wrote:
>> Does it need to be that way? It seems strange for the kernel to
>> support enabling PPS on multiple channels at the same time, but not
>> allow multiple applications to receive all samples from their channel.
> 
> It does not need to be that way, but nobody ever wanted multiple
> readers before.
> 
> Implementing this would make the kernel side much more complex, as the
> code would need per-reader tracking of the buffered time stamps, or
> per-reader fifo buffers, etc.

There's two separate questions here - multiple readers receiving the same data, and multiple readers 
receiving data exclusively about one channel.

I'd imagine the second is (much?) easier to implement, whereas the first is a bunch of complexity.

At least personally I'm okay with the second, rather than the first, and that fixes the issue for 
chrony, though it doesn't allow one to, say, get raw samples in one program while having another 
handle them.

Matt
