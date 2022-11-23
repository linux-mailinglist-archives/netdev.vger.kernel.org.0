Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96871636266
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbiKWOw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbiKWOwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:52:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DB38D4B5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:52:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z63so6151733ede.1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0cYYhuWeBZxggRjcWRK91TmoegYznBOAl9pXEZNzsI=;
        b=nnwgpLhtjt+2gXNHSgiKT60egaIwEmVpQ8xKo9AcAfGpzIzu1bpFI9m2DgTHLd8d+r
         SuJ9fQyzhNyQRngVCz3R/RlYHs4CAIPQAfxYCSzlZ5uj1zoQGBSiEDiXTd0m99L7cdfn
         YuN3bxj4Qi+0L91OzuFSUmmc3FyOUtZ9hCebAiprpS08tz48FeZWe9PScasJDcXI2A0y
         Vo5zVvqzVbt+4vLUyVP0l85ONI9gI8oRYAlVPHRGWhNs4D17jcRZEZJXS7zVIcaZgFsR
         AoJxGZrb/jLSfdOTZME0ktCswc9rOqBHY3oKaDda55N7sUZwRmgJITjkz6RCGM38g6/E
         oAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0cYYhuWeBZxggRjcWRK91TmoegYznBOAl9pXEZNzsI=;
        b=hOI7bV8ojbaiig6PIb8Tq7wjAPXX7TVe5zQBvCyDx6g+mWkl1uwRT4xa22k0C8IXQR
         ljrsn7Hy/xGr7Mpl0/7AsQypBEaOwwaR+Rr2afenFsydJFXmy5Jj9jsRbF7h8eLjiYpq
         zNle3ZM+gvIzX0d1cJezfg4kXV6SqSMEXLfAMmolGZIHrk8XaXI/uwo7RWkjVd8BKeMI
         vt4h++02g/s7An+LkCwJ+nVDxa6TtPHVBBDpCG170Qg3qPGbLlrvd3lAXkY45SwKrWg6
         A4pW2vZn8pDyD6ISFQ+kdsXZvu4dysPoE0slqR8JulzKW9WJ1q0f6urTzCvJGwUPDCBL
         aPNQ==
X-Gm-Message-State: ANoB5pmG/8NSJ0rFlCdbGjq5Rdt9AkN6LS+HJbVzYZNEXXZ0z3rdZxxd
        p78L4rKiqQ7aZNW91MlvzKnm6w==
X-Google-Smtp-Source: AA0mqf5jd4dYN9C/+Elce1qts52eZrfgguAaFs5X117TB4jlH7uLstuiK0xjyFl0NqMXGcJ43gfbpA==
X-Received: by 2002:a05:6402:5299:b0:461:7291:79c1 with SMTP id en25-20020a056402529900b00461729179c1mr16390906edb.68.1669215139860;
        Wed, 23 Nov 2022 06:52:19 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 14-20020a170906308e00b007b29a6bec24sm7224876ejv.32.2022.11.23.06.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:52:19 -0800 (PST)
Date:   Wed, 23 Nov 2022 15:52:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <Y34zoflZsC2pn9RO@nanopsycho>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
 <20221123142558.akqff2gtvzrqtite@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123142558.akqff2gtvzrqtite@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 03:26:14PM CET, vladimir.oltean@nxp.com wrote:
>On Tue, Nov 22, 2022 at 12:51:53PM -0800, Steve Williams wrote:
>> This driver provides a way for outbound traffic to be tagged and duplicated out
>> multiple ports, and inbound R-TAG'ed packets to be deduplicated.
>
>> Hanic tries to make the R-TAG handling transparent,
>
>> Generic filtering and/or dynamic stream identification methods just seemed
>> out of scope for this driver. Certainly out of scope for our needs.
>
>> Yes, hanic implements a practical subset of the standard, and I try to be
>> clear about that in the documentation.
>
>I'm back with a more intelligent question, after looking a bit at the
>code and at the problem it tries to solve.
>
>The question is: why don't you create a tap interface, and a user space
>program which is given the physical ports and tap interface as command
>line arguments, and does the following:
>
>- on reception from physical interfaces, handles 802.1CB traffic from
>  physical ports, eliminates the duplicates and pops the R-TAG, then
>  sends the packets to the tap interface
>- handles packets transmitted to the tap, splits them and pushes
>  whatever R-TAG is needed, then forwards them to the physical network
>  interfaces
>
>Then your Cruise 802.1CB endpoint solution becomes a user space handler
>for a tap interface. To users of your solution, it's the same thing,
>except they open their socket on a tap interface and not on a hanic
>interface.
>
>Reworded, why must the hanic functionality to be in the kernel?

I guess for the same reason other soft netdevice driver are in the
kernel. You can do bridge, bond, etc in a silimilar way you described
here...


>
>Thank you.
