Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9BF5ED36F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiI1DWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI1DWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:22:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58242125B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:22:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so643123pjq.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=MWmhtztMEox7VVKGK6uybYYECsNBNiJUJsG+PcRMBEg=;
        b=ehO8VuvybkrY1SLq7NWzlJMl9wtatxA5zjZepIrHAAgxLNJ26OsGzpJXtfdGbpEnID
         GymGAFCsDdILb3l/E9ldCMtRwzDoiyjLKW1LuaPffGDwW5VFFPhsHl1y+/ebvHFSzuj4
         m1rcycrl49MTKyBQ94HZyj6zx3/gtSogBWP07ICtqI0S87zdfVgtuIzVAxXJ7wL9d/EF
         iQWXQlcJlIG9Jp+I7B8V141s68Aq2Z1IylZxcGobCBkJVOWC0JdqAZThZFvHRqxiZchj
         IwqEV1uGBQS2nKP9vWg4rnaOPU+xXZBGPa6++RQUwMOmZ4NfzPGPJPwPbHZAOvbvCNkW
         qpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=MWmhtztMEox7VVKGK6uybYYECsNBNiJUJsG+PcRMBEg=;
        b=X00HUIs0qkWg/Eck0RXpXUTYdo1Jz/L6XOfqlHm16rsVPurRyMPPfG7+gdWw1Goqte
         ynT+bJU3NAPjPG8LWImckxgOg05Zh6WP2mAbPfFjYgfRWQptiCyJC9limuXJe7Eo9ZfA
         5UurWJTQ+Bl4ZvV6UFGxHexfO2xTiQdgGqM2cULNrRws8ynjyKxALTvlTrVl8limV6Aq
         IB9dDkSOmv9j/ATRmz3KoRMRFvFF6H62FcwU1DCkUHE8oxEjlfWn6+AjAmcWxJk1v3lG
         F0Y5tAhHE6lCSMZmi3mXF7eEToEVLkgjTue1AZBp+Q0P47nZ55dmQedfhZ1qPqupt2AG
         Vldg==
X-Gm-Message-State: ACrzQf2ysSjPVb0sg4fnzfF9ZLdCz80a1BPi8ztL3kmhMOyrw4ue2wqN
        mB2r9mXZlKO/4dOQbTLiml0=
X-Google-Smtp-Source: AMsMyM7T/a7xK+tCMWInr1RURuEpd/5RFu0cuWbT2ONObPFbgukvjvx9vzM2e4Ca0zOYstQoRZdw1Q==
X-Received: by 2002:a17:903:186:b0:179:e238:bbe8 with SMTP id z6-20020a170903018600b00179e238bbe8mr8159138plg.81.1664335338340;
        Tue, 27 Sep 2022 20:22:18 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f54d00b001752216ca51sm2366741plf.39.2022.09.27.20.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 20:22:17 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:22:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <YzO943B4Id2jLZkI@Laptop-X1>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927041303.152877-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
On Tue, Sep 27, 2022 at 12:13:03PM +0800, Hangbin Liu wrote:
> @@ -3009,6 +3012,11 @@ static int do_setlink(const struct sk_buff *skb,
>  		}
>  	}
>  
> +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> +				      0, pid, nlh->nlmsg_seq);
> +	if (nskb)
> +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);

BTW, in do_setlink() I planed to use RTM_SETLINK. But I found iproute2 use
RTM_NEWLINK to set links. And I saw an old doc[1] said

"""
- RTM_SETLINK does not follow the usual rtnetlink conventions and ignores
  all netlink flags

The RTM_NEWLINK message type is a superset of RTM_SETLINK, it allows
to change both driver specific and generic attributes of the device.
"""

So I just use RTM_NEWLINK for the notification. Do you think if we should
use RTM_SETLINK?

[1] https://lwn.net/Articles/236919/

Thanks
Hangbin
