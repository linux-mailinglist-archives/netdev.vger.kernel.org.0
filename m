Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82E5699FE5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBPWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPWyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:54:33 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A92838EBD
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:54:33 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id y186so2191785pgb.10
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j4CkTw8Ms8FLVE8jeoJ2dO/iBPEPtxKEwtXNadVMAKE=;
        b=QuOrePsWKbedxlQ8gods7DMiUBhwkT/aQcVXLtxmMniURQWl9Nz2mOM7opiifoIX7c
         +47vfscNCqVxzw2cVOByhMoZZwUB5XAs7QCpW6uWJVhkGAbikVkc0dtHxvJmeiqGTfTk
         pbO9iv2r/6i1U35Cki+Gw3VCYQzFrgok3ZyVQfbodskeYnX6PJYYlo28brQ+9Gx2jLeC
         iA3IM4w4Wuygar/FTgPdY6HktH/Y/cvqES7d4C+bnH5i6BxkIHTvZnli2Y3R2ehm/mv0
         hg9GGQpPcell0oY7uzq4N/xCgY9OJF2oq8FzdAFDSYLA+hJEK21a/wAy0/Iq+Lt0lv2I
         X5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4CkTw8Ms8FLVE8jeoJ2dO/iBPEPtxKEwtXNadVMAKE=;
        b=lP35g3qkXUCzFqxbyU6g9jnn1AZ0sSwWlJTLYK8cvH+ev5tPzxobXMmVidHIkbdcD0
         kG42vq0B0wQqUgbnJRmtalpKXAoAuM0GFM3NqZqFBB3RMvUapOJLEB5/f8OfXVsOfibV
         gyiJQaXbD0t1zc+RAYrY+MSR0s/g3njfIOramcezf1FTh6hryjMoDNqPHYwdXz9DbbHj
         U3HjTwK5tR7PNsqGeWOaggmBO/RVvKlj7CDT2YfgcqkKplBr8cnKTe0/eGDcx41skh4L
         n5pHedhM44yLAAUd1kComrsqofcLni0x9js3LOw1Srtw55/ljwcC1/3vXcphK4ah68tP
         G2vg==
X-Gm-Message-State: AO0yUKXv0LF8647ej13lukvXCB4rcvlmhTJxS+RnWMlXhSoUf7xzNegg
        nMTfQwt4IFxX8dKVPlry8KY=
X-Google-Smtp-Source: AK7set9l/gh+Ye4Iicz21oByubFkcpfTXGjP1mh9Ve+dRbYYwi/piOTqasudy3G5nGEBOpLC1p4eZg==
X-Received: by 2002:a62:a21d:0:b0:5a8:ae97:25f2 with SMTP id m29-20020a62a21d000000b005a8ae9725f2mr6197746pff.0.1676588072561;
        Thu, 16 Feb 2023 14:54:32 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0058e264958b7sm1830038pff.91.2023.02.16.14.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 14:54:31 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:54:29 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Matt Corallo <ntp-lists@mattcorallo.com>
Cc:     chrony-dev@chrony.tuxfamily.org,
        Miroslav Lichvar <mlichvar@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Message-ID: <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 09:54:56AM -0800, Matt Corallo wrote:
> 
> 
> On 2/16/23 12:19 AM, Miroslav Lichvar wrote:
> > My first thought is that this should be addressed in the kernel, so
> > even different processes having open the PHC device can receive all
> > extts samples. If it turns out it's too difficult to do for the
> > character device (I'm not very familiar with that subsystem), maybe it
> > could be done at least in sysfs (/sys/class/ptp/ptp*/fifo or a new
> > file showing the last event like the PPS assert and clear).

The PPS thing has a race, and so I'd rather not copy that!
 
> As for duplicating the output across sockets, ptp_chardev.c's `ptp_read` is
> pretty trivial - just pop the next sample off the queue and return it.
> Tweaking that to copy the sample into every reader is probably above my
> paygrade (and has a whole host of leak risk I'd probably screw up).
> `extts_fifo_show` appears to be functionally identical.

Each extts in the fifo is delivered only once.  If there are multiple
readers, each reader will receive only some of the data.  This is
similar to how a pipe behaves.

HTH,
Richard
