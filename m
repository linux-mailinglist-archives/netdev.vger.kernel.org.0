Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43719379AA8
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 01:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEJXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 19:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhEJXTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 19:19:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FD3C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 16:18:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id z16so14455802pga.1
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 16:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/esWc1eGaKaUAfNZ5uRucjCGrRy/1LXqjTVFAXRJt2g=;
        b=tWCttaba1Jvm5zZLAIhJkMd9jrxV7484p05LC3E60vxDBBv/KkP2jZp9vaox4YODqC
         vS7niiEEVpRsQl5KFsH7wvQGfSsTOwyz24b0VT6SPfNMlGL9kOKMX7p6UlGOP2cp2PeF
         fEWBG5hZ6hHhrFDhqDaq2j2lyoCFgVEbJHA2Zsxu6xKsnsWUXGMvUQwDmRj9Iffn/XTQ
         hu3T5XHBchBsAG5kLJ6uo0MKcGTnmOha2Aoh+GbKTHyzjd+geH2W1+8P7eHC1GjcIdWm
         Uz4EeOGZwToCwOH5qgRSssyqKuI1drXDlQt3hNK++hCoQXFe+KpTsgxQ6SLkalEESa1g
         lJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/esWc1eGaKaUAfNZ5uRucjCGrRy/1LXqjTVFAXRJt2g=;
        b=nPS9DzQ1wIe9L/byLZ35iPZ5YVEkyAsTPKD0KwcGUqqHk04kMfGfXduoxwIhQFMgmH
         e7lVYQuZzdi2/PKhGgbVbytazGHeY70onfEXEaCj6jndNHPX6B3qvs7vn4tndt4KLO9K
         btZuJLfnRYpLRFsmOX7NBhdMk/KGMSrssNJjuPtmAP9oBSs3EPR2eEaBB54esj7iK7Gb
         xVbDqe866onl7UGbuA5vA8qNimcySry4yqshdT9NuMlgZvX52PBdM/2Ej2rhRdQA6uM2
         dsvZ9bwiQQHQ7qTaXRX7jF57mk6JOg/da3tXsDsTbmucN96CpNOKq983a8Em28RamIJo
         Zc1A==
X-Gm-Message-State: AOAM533hVd+8IWI+nl1mwhjND0qNO8drMeKxkCH5A6e+VXdJp6oYKMOu
        Fz9jwMtpwDFjYuTx/4DAlo4=
X-Google-Smtp-Source: ABdhPJyAkeVGPewerymzeeXjbooeTeb/ZafoPzhglVZarmbvhFMXMpktvooOx3CX/8UXXya4tIAzsA==
X-Received: by 2002:aa7:8087:0:b029:28e:8174:565c with SMTP id v7-20020aa780870000b029028e8174565cmr27408478pff.12.1620688715956;
        Mon, 10 May 2021 16:18:35 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ls6sm411525pjb.57.2021.05.10.16.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 16:18:35 -0700 (PDT)
Date:   Mon, 10 May 2021 16:18:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next 0/6] ptp: support virtual clocks for multiple domains
Message-ID: <20210510231832.GA28585@hoboy.vegasvil.org>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 03:04:39AM +0000, Y.b. Lu wrote:

> There may be some misunderstanding. In the example, domain 1, 2, 3 are based on PTP virtual clocks ptp1, ptp2 and ptp3 which are utilizing their own timecounter.
> The clock adjustment on them won't affect each other. The example worked fine in my verification.

Okay, now I think I understand what you are suggesting.  Still, there
are issues you haven't considered.

> I mean if the physical clock keeps free running, all virtual clocks utilizing their own timercounter can work fine independently without affecting on each other.

Right.  This is critical!

> If the physical clock has change on frequency, there is also way to make the change not affect virtual clocks.
> For example, when there is +12 ppm change on physical clock, just give -12 ppm change on virtual clocks.

That will cause issues in very many cases.

For example, what happens when the "real" clock sees a large offset,
and it doesn't step, but rather applies the maximum frequency offset
to slew the clock?  That maximum might be larger that the max possible
in the virtual clocks.  Even with smaller frequency offsets, the
un-synchronized, quasi random changes in the "real" clock will spoil
the virtual clocks.  I won't support such an approach.

However, if the "real" clock is guaranteed to stay free running, and
the virtual clocks give up any hope of producing periodic outputs,
then your idea might work.

Thinking out loud: You could make a sysfs knob that converts a "real"
clock into two or more virtual clocks.  For example:

    cat /sys/class/ptp/ptp0/number_vclocks
    0 # ptp0 is a "real" clock

    echo 3 > /sys/class/ptp/ptp0/number_vclocks
    # This resets the frequency offset to zero and creates three
    # new clocks using timecounter numeric adjustment, ptp0, 1, and 2.
    # ptp0 loses its periodic output abilities.
    # ptp0 is now a virtual clock, just like ptp1 and 2.

    echo 0 > /sys/class/ptp/ptp0/number_vclocks
    # back to normal again.

In addition to that, you will need a way to make the relationships
between the clocks and the network interfaces discoverable.

It needs more thought and careful design, but I think having
clock_gettime() available for the different clocks would be nice to
have for the applications.

Thanks,
Richard
