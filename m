Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7E75FD9B8
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJMM7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJMM7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:59:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C90147074
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:59:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r17so3710898eja.7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PhGQeGIe5xcuqU98Lgp2cyqw/BtN+KEpjBzd6CGb8JM=;
        b=8GKHKlqe2bGS4hrD63o5pzxnwqVdsNSLzqsVkoVTZw8uPy4lSoMKXgMLTTh9HSME5L
         wXPv7SueKCIgqTS+gWICu9PniW91Ljd41IvGBZvlQympqipqQcd41hUzrhMMKZNHnRoq
         xk/m4kXF23ZfrleJ0Z+VE2ic0NBoQ22s+k5l0BZg6yxYVG8HuZwyvLEWz0dKOVr+U8Nf
         9zBTkIEJHQpR7S9ssDQJM6XkuK8Mzhrp8wozQFpxbe7u7FjM5FGU6WHsapY3efW4zawj
         /x4ooceLsF9y0ikvbK7r0AuAR1qjjstJE/OIsgucnl4ejUAF2ugEHwbBkCGNcbJ387dv
         VByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PhGQeGIe5xcuqU98Lgp2cyqw/BtN+KEpjBzd6CGb8JM=;
        b=SArsvy8N6IsFnMPSr7iMc1O58mM+04G++xjCDB/uaRE5C07m9gKotI97/3SpzLI3+h
         HRo+/K4+/cS+rBA6hWG+r3thEulpWvtd1+czOkYvppp6lYunF3pL8DSqm+ruAd/Otu4R
         ogXmk7wy2Z5/+Q1wIzYbWTd2ZygKblmpOG2ga+s+nagTBmnzsHAl8BeT3nJmw6VC/72C
         F1ZHWKcONicuRx5S+qst63mflukYuVyR8wjGZKsr3baF9yK92XQJ35yaUutY+TuKMboo
         +9/FlMZF7+OVWRlLLJVaOwxH4oMesbnL3NxIlHjpf6HbLNmY7e2aNBgas7Z3gZNOya3v
         /pvg==
X-Gm-Message-State: ACrzQf1FXWD3O0BvZFvben3Cd4Ughtp+NC7c/Wjcp3Pdy38QcNg6VSbU
        L9mPD49lDVq+8jFlT0OSP/0vHw==
X-Google-Smtp-Source: AMsMyM5Alm/TAor4zQOtqV65HlIE4F0enrByqXkQFk44BT0sB1bWZ8PhoIBj19rtaGYtiMtdBGXNCA==
X-Received: by 2002:a17:906:dc8f:b0:78d:f675:226 with SMTP id cs15-20020a170906dc8f00b0078df6750226mr5766580ejc.745.1665665941376;
        Thu, 13 Oct 2022 05:59:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 8-20020a170906328800b00734bfab4d59sm3010017ejw.170.2022.10.13.05.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 05:59:00 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:59:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <Y0gLlKo8JGJKA7nf@nanopsycho>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
 <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
 <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
 <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 07, 2022 at 03:49:42PM CEST, johannes@sipsolutions.net wrote:
>On Fri, 2022-10-07 at 14:46 +0100, Edward Cree wrote:
>> On 07/10/2022 14:35, Johannes Berg wrote:
>> > 
>> > > +#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
>> > > +	struct netlink_ext_ack *__extack = (extack);		\
>> > > +								\
>> > > +	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
>> > > +		  (fmt), ##args);				\
>> > 
>> > Maybe that should print some kind of warning if the string was longer
>> > than the buffer? OTOH, I guess the user would notice anyway, and until
>> > you run the code nobody can possibly notice ... too bad then?
>> > 
>> > Maybe we could at least _statically_ make sure that the *format* string
>> > (fmt) is shorter than say 60 chars or something to give some wiggle room
>> > for the print expansion?
>> > 
>> > 	/* allow 20 chars for format expansion */
>> > 	BUILD_BUG_ON(strlen(fmt) > NETLINK_MAX_FMTMSG_LEN - 20);
>> > 
>> > might even work? Just as a sanity check.
>> 
>> Hmm, I don't think we want to prohibit the case of (say) a 78-char format
>>  string with one %d that's always small-valued in practice.
>> In fact if you have lots of % in the format string the output could be
>>  significantly *shorter* than fmt.
>> So while I do like the idea of a sanity check, I don't see how to do it
>>  without imposing unnecessary limitations.
>> 
>
>Yeah, I agree. We could runtime warn but that's also pretty useless.

I think that the macro caller need to take the buffer size into account
passing the formatted msg. So if the generated message would not fit
into the buffer, it's a caller bug. WARN_ON() is suitable for such
things, as it most probaly will hit the developer testing newly added
exack message.


>
>I guess we just have to be careful - but I know from experience that
>won't work ;-)
>
>(and some things like %pM or even %p*H can expand a lot anyway)
>
>Unless maybe we printed a warning together with the full string, so the
>user could recover it? WARN_ON() isn't useful though, the string should
>be enough to understand where it came from.
>
>Anyway just thinking out loud :)
>
>johannes
