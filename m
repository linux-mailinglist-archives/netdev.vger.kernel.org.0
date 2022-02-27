Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623DC4C5A25
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 10:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiB0JNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 04:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiB0JNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 04:13:35 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD3F13EA5
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 01:12:57 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b9so16573502lfv.7
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 01:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q8o1j/gHOW81wiA3XlZNO9z6XKP1N7JTMsHKciFldaY=;
        b=C6XF6dHh4zO80DuyIuMAtfCBX9gnCMARtwMpA5MHwHbj7SP5b1U+q9FYoeZXJRamA7
         T8peCPW3AoyBhmSXLWMoKQmViCiEOe+Jm8AxuLfdowyoRfk/MX0UkHJI6sqkCJlliYWu
         y2piB3XgiXiiUXwKhD9vw4jaoZVCsIjc4PLXWryA3+kppa3q8StSReQ3UJqRBpXa5cMm
         +zBx07Y8QGTf/KkBKW4T34lcUUfGFDGElvmMAvFFqCIBXbxZEer0+inpr6EzQ7zxPnEb
         LGTJoHclODKFE3vupP9LKmFo9sPmKw9drUaYBomWvmmvfnyzZBNF0LtHtKcayZJxe6A5
         Pw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q8o1j/gHOW81wiA3XlZNO9z6XKP1N7JTMsHKciFldaY=;
        b=tZzjMZ4QfcMMYe/e99s+BNe82cQ5NJ8rPBnuZx6mWJYIMgi2+daKBbjyTw4H62dAtH
         68T9h6kBQQ75ipdUTcr3A4JLB3zhETHngdLrooaRgHig86jl5PM+P0snR6Xph3B7GpW8
         DoteN5TgSwKiBhsgM9IrGNgs0/R/00yesp75n+y0SIDWn68Q8RJi7WZV0oLxOQ9nIY4k
         eMruoBJOU73NqI9kYNpWEESTBFCp1fYeyyQ2VcZP188Sf8s9S7RC7rMvJ7elgh+7GJqr
         0iYNu7zX+r2jyxPrz/qF0H8LiamQbvczpUC+sUMIIr5q90IQFkLFX5yBWWpt782LiJIa
         Hcbw==
X-Gm-Message-State: AOAM530aDnngKxS+DIfuiBhFVhtuqHFEMHTb03otu8ApvuR7dgW5EY92
        bVsV5Kjb539xpG+EvoKaxLW/t6fRG9nwrA==
X-Google-Smtp-Source: ABdhPJznaI5KhdZHTl1tptTucNEjTG0Rw74A/YN5DA+6R2eJTqv/q1cB7icxm1QU0bO8jRNLpteWfw==
X-Received: by 2002:a05:6512:511:b0:443:3f9f:5d5c with SMTP id o17-20020a056512051100b004433f9f5d5cmr9413426lfb.94.1645953175593;
        Sun, 27 Feb 2022 01:12:55 -0800 (PST)
Received: from [10.8.100.128] (h-98-128-230-58.NA.cust.bahnhof.se. [98.128.230.58])
        by smtp.gmail.com with ESMTPSA id p1-20020a05651238c100b004437b4e5034sm626945lft.159.2022.02.27.01.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 01:12:55 -0800 (PST)
Message-ID: <fe69847d-b0d4-3ab0-ab4b-e673210d4b9d@norrbonn.se>
Date:   Sun, 27 Feb 2022 10:12:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next v3 1/2] ip: GTP support in ip link
Content-Language: en-US
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
References: <20220211182902.11542-1-wojciech.drewek@intel.com>
 <20220211182902.11542-2-wojciech.drewek@intel.com>
 <a651c26e-24e7-560e-544d-24b4e0a9ae6a@norrbonn.se>
 <YhsuhzsncG9s1KtX@nataraja>
From:   Jonas Bonn <jonas@norrbonn.se>
In-Reply-To: <YhsuhzsncG9s1KtX@nataraja>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/02/2022 08:55, Harald Welte wrote:
> Dear Jonas,
> 
> On Sun, Feb 27, 2022 at 07:57:02AM +0100, Jonas Bonn wrote:
>> On 11/02/2022 19:29, Wojciech Drewek wrote:
>>> Support for creating GTP devices through ip link. Two arguments
>>> can be specified by the user when adding device of the GTP type.
>>>    - role (sgsn or ggsn) - indicates whether we are on the GGSN or SGSN
>>
>> It would be really nice to modernize these names before exposing this API.
> 
> I am very skeptical about this.  The features were implemented with this use
> case in mind, and as you know, they only match rather partially to the requirements
> of later generation technology (4G/LTE/EPC) due to their lack of support for
> dedicated bearers / TFTs.
> 
>> When I added the role property to the driver, it was largely to complement
>> the behaviour of the OpenGGSN library, who was essentially the only user of
>> this module at the time.  However, even at that time the choice of name was
>> awkward because we were well into the 4G era so SGSN/GGSN was already
>> somewhat legacy terminology; today, these terms are starting to raise some
>> eyebrows amongst younger developers who may be well versed in 4G/5G, but for
>> whom 3G is somewhat ancient history.
> 
> The fact that some later generation of technology _also_ is using parts of older
> generations of technology does not mean that the older terminology is in any way
> superseded.  A SGSN remains a SGSN even today, likewise a GGSN.  And those network
> elements are used in production, very much so even in 2022.
> 
>> 3GPP has a well-accepted definition of "uplink" and "downlink" which is
>> probably what we should be using instead.  So sgsn becomes "uplink" and ggsn
>> becomes "downlink", with the distinction here being whether packets are
>> routed by source or destination IP address.
> 
> Could you please provide a 3GPP spec reference for this?  I am working
> every day in the 3GPP world for something like 15+ years now, and I
> would be _seriously_ surprised if such terminology was adopted for the
> use case you describe. I have not come across it so far in that way.
> 
> "uplink" and "downlink" to me
> a) define a direction, and not a network element / function.
> b) are very general terms which depend on the point of view.
> 
> This is why directions, in 3GPP, traditionally, are called
> "mobile-originated" and "mobile-terminated".  This has an unambiguous
> meaning as to which direction is used.
> 
> But in any case, here we want to name logical network elements or
> functions within such elements, and not directions.
> 
> Those elements / functions have new names in each generation of mobile
> technology, so you have SGSN or S-GW on the one hand side, and GGSN or
> P-GW on the other side.  The P-GW has then optionally been decomposed
> into the UPF and SMF.  And then you have a variety of other use cases
> (interfaces) where the GTPv1U protocol was later introduced, such as the
> use between eNB and S-GW.
> 
> So you cannot use S-GW and P-GW as names for the roles of the GTP tunnel
> driver, as S-GW actually performs both "roles": You can think of it as
> decapsulationg the traffic on the eNB-SGW interface and as encapsulating
> the traffic on the SGW-PGW side.

So this may all come down sloppy usage of the terminology, but everyone 
I interact with tend to refer to the interfaces on the S-GW, I-UPF, UPF, 
etc as the uplink or downlink interface depending on whether it is 
connected to the uplink network segment or the downlink network segment. 
  That's all a bit ambiguous, as you alluded to above, until you 
consider that these directions are always relative to the UE:  the 
uplink carries traffic FROM the UE, the downlink carries traffic TO the UE.

That all maps quite nicely to the GTP module where the peer tunnel 
endpoint is determined from either the source or destination address 
depending on which direction the traffic is flowing:  either TO or FROM 
the UE.  Traffic sent on an uplink interface is destined for the UE, 
hence the destination IP determines the TEID; traffic sent out on a 
downlink interface moves away FROM the UE, so the source address 
determines the TEID.

With that, the S-GW/I-UPF has a both an uplink and a downlink GTP 
interface between which packets are forwarded.  The decision as to which 
peer TEID to send to is made based on which interface the packet is 
going out on, which of course is synonymous with the direction the 
packets are flowing in.  That's exactly what the SSGN/GGSN "mode" 
parameter decides, as well.

Anyway, I don't disagree with anything that you wrote here and I'm not 
going to push hard for a name change; I just wanted to raise the issue. 
  I realize that uplink/downlink aren't crystal clear either.  That 
said, if I'm putting together an I-UPF, then it certainly isn't more 
clear why I need an interface in "SSGN" mode rather than "downlink" mode.

And I'm sure that I've seen a one-liner or something in some 3GPP spec 
that handwavingly justifies the above usage, but of course I can't find 
it now... so I'll happily concede that this isn't a 3GPP standard, but 
rather just "common usage", at least within in my bubble.


> 
> I'm not fundamentally opposed to any renaming, but any such renaming
> must have a unambiguous definition.
> 
> In the context of TS 29.060, there are a number of references to uplink
> and downlink.  However, they - as far as I can tell -
> 
> * specify a direction (like the QoS Parameters like AMBR for uplink / downlink)
> 
> * are used within the context of TEIDs.  So there is an "uplink tunnel
>    endpoint identifier" which is chosen by the GGSN, and which is used by
>    the SGSN to send data.  So again it is used to signify a direction.


The "uplink tunnel" terminates at the "uplink interface" of the GGSN, so 
you'd want the GTP module to provide an interface in "uplink" mode.

Equally, the SGSN allocates a "downlink tunnel endpoint identifier" for 
packets terminating at the "downlink interface" (originating from the 
GGSN), so here you'd want the GTP module giving you an interface in 
"downlink" mode.

/Jonas


> 
> If we look at 3GPP TS 29.281, there are one mention of 'uplink' and
> 'downlink', and both are also again referring to a direction of traffic.
> 
> Regards,
> 	Harald
> 
