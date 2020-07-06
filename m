Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C65215E5E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgGFSdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGFSdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:33:36 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF26C061755;
        Mon,  6 Jul 2020 11:33:33 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id t25so42071359lji.12;
        Mon, 06 Jul 2020 11:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=AkKmGs8r7EyqO3vztTv68b/fbqhGHTJyNbKAWnpq+go=;
        b=Mn7mxd5+M3161CMH7lt91p9KogPaJxMsp3LvHJPE24oOTFwuWD2Mx2vFrJTVfRRbkP
         /SDq0Lj40PTA4qM02H+xsU4Ph7gSisQUVk4stKBATXdm0lL4qztrcXNI2ndkU1+sqZv5
         b4SnphFMEoC4XEz3t9/zA3SBLHtCCwLswx3Cc9RcS5LUO++vgAEbZs8RAdJonRKuH2gW
         DCdKvucdzIQCZ9Gu/zSKYPFUapBcD/I5yAZ3MGD33GS+kIzh5xa6xHSQOxhU+HITgyj2
         SB6lAHRFNAVLsFCzgXHHIgJqE0w/oYSrvIv9+xYVIdPY51maTT66uS23mrfJjC6drv+B
         pM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=AkKmGs8r7EyqO3vztTv68b/fbqhGHTJyNbKAWnpq+go=;
        b=YXNPZnRBpP5zlNFCxXsv5ELNlfeXewipA7nW3TWumd4IJGVGkRK3vIIqYPqfpw3SL6
         Ob/K+IDxmxT6iufYE7U+V1ilXhcndA2DbpUMhdGZfXXuXT0A43VzilPV3qccrwEGV+7Y
         /PtpzuNbataSOpvBsg145VHvNeSb9NKVqm3uXoLgI7K1XQaKCvsDT0+KNqNFCc0/TWCa
         F13kmtJUCqHHcdUtt40LfQJ7lG0F/3dRJoTRadiZIBKM/iZ0fMpjqzJyEw4t7nnOvB8n
         CVo46RR9Uje5bZKA/KVWbffx5/cuzkAv13gc4sP9Fi3yudpNtUsu2c4xrzakgwRLNLlJ
         0Fkw==
X-Gm-Message-State: AOAM531jqNURdtn0Bu3s1PUakCFIbvp5HmkaRzjgcFD9Vf2JY8D49PZK
        iyycaDuD9ELVrYQ7LfHOHIj7c9+N
X-Google-Smtp-Source: ABdhPJxcSWlAXSFgSej3Larbvntasy2BMLSc6MORDmJpstXsDqlAa9xRLOahOnA++NCqpPApfkX34A==
X-Received: by 2002:a2e:3c03:: with SMTP id j3mr22344444lja.12.1594060412127;
        Mon, 06 Jul 2020 11:33:32 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id u9sm4850401ljk.44.2020.07.06.11.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:33:31 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-2-sorganov@gmail.com>
        <20200706150814.kba7dh2dsz4mpiuc@skbuf> <87zh8cu0rs.fsf@osv.gnss.ru>
        <20200706154728.lfywhchrtaeeda4g@skbuf>
Date:   Mon, 06 Jul 2020 21:33:30 +0300
In-Reply-To: <20200706154728.lfywhchrtaeeda4g@skbuf> (Vladimir Oltean's
        message of "Mon, 6 Jul 2020 18:47:28 +0300")
Message-ID: <87zh8cqyrp.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Mon, Jul 06, 2020 at 06:21:59PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
 
>> > Hi Sergey,
>> >
>> > On Mon, Jul 06, 2020 at 05:26:12PM +0300, Sergey Organov wrote:
>> >> When external PTP-aware PHY is in use, it's that PHY that is to time
>> >> stamp network packets, and it's that PHY where configuration requests
>> >> of time stamping features are to be routed.
>> >> 
>> >> To achieve these goals:
>> >> 
>> >> 1. Make sure we don't time stamp packets when external PTP PHY is in use
>> >> 
>> >> 2. Make sure we redirect ioctl() related to time stamping of Ethernet
>> >>    packets to connected PTP PHY rather than handle them ourselves
>> 
>> [...]
>> 
>> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> >> index 2d0d313..995ea2e 100644
>> >> --- a/drivers/net/ethernet/freescale/fec_main.c
>> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> >> @@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>> >>  			ndev->stats.tx_bytes += skb->len;
>> >>  		}
>> >>  
>> >> +		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
>> >> +		 * we still need to check it's we who are to time stamp
>> >> +		 */
>> >>  		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>> >> +		    unlikely(fep->hwts_tx_en) &&
>> >
>> > I think this could qualify as a pretty significant fix in its own right,
>> > that should go to stable trees. Right now, this patch appears pretty
>> > easy to overlook.
>> >
>> > Is this the same situation as what is being described here for the
>> > gianfar driver?
>> >
>> > https://patchwork.ozlabs.org/project/netdev/patch/20191227004435.21692-2-olteanv@gmail.com/
>> 
>> Yes, it sounds exactly like that!
>> 
>
> Cool. Join the club! You were lucky though, in your case it was pretty
> evident where the problem might be, so you were already on your way even
> though you didn't know exactly what was going on.
>
> Towards the point that you brought up in that thread:
>
>> Could somebody please help me implement (or point me to) proper fix to
>> reliably use external PHY to timestamp network packets?
>
> We do it like this:
> - DSA: If there is a timestamping switch stacked on top of a
>   timestamping Ethernet MAC, the switch hijacks the .ndo_do_ioctl of the
>   host port, and you are supposed to use the PTP clock of the switch,
>   through the .ndo_do_ioctl of its own (virtual) net devices. This
>   approach works without changing any code in each individual Ethernet
>   MAC driver.
> - PHY: The Ethernet MAC driver needs to be kind enough to check whether
>   the PHY supports hw timestamping, and pass this ioctl to that PHY
>   while making sure it doesn't do anything stupid in the meanwhile, like
>   also acting upon that timestamping request itself.
>
> Both are finicky in their own ways. There is no real way for the user to
> select which PHC they want to use. The assumption is that you'd always
> want to use the outermost one, and that things in the kernel side always
> collaborate towards that end.

Makes sense, -- thanks for clarification! Indeed, if somebody connected
that external thingy, chances are high it was made for a purpose.

>
>> However, I'd insist that the second part of the patch is as important.
>> Please refer to my original post for the description of nasty confusion
>> the second part of the patch fixes:
>> 
>> https://lore.kernel.org/netdev/87r1uqtybr.fsf@osv.gnss.ru/
>> 
>> Basically, you get PHY response when you ask for capabilities, but then
>> MAC executes ioctl() request for corresponding configuration!
>> 
>> [...]
>> 
>
> Yup, sure, _but_ my point is: PHY timestamping is not supposed to work
> unless you do that phy_has_hwtstamp dance in .ndo_do_ioctl and pass it
> to the PHY driver. Whereas, timestamping on a DSA switch is supposed to
> just work. So, the double-TX-timestamp fix is common for both DSA and
> PHY timestamping, and it should be a separate patch that goes to David's
> "net" tree and has an according Fixes: tag for the stable people to pick
> it up. Then, the PHY timestamping patch is technically a new feature,
> because the driver wasn't looking at the PHY's ability to perform PTP
> timestamping, and now it does. So that part is a patch for "net-next".

Ah, thanks, now it makes sense! I simply was not aware of the DSA
(whatever it is) you've mentioned above.

I'll then make these 2 changes separate in v2 indeed, though I'm not
aware about Fixes: tag and if I should do something about it. Any clues?

Thanks,
-- Sergey

