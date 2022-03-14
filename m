Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE62A4D8F5E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbiCNWPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiCNWPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:15:02 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8A83D49A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:13:51 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bt26so29746708lfb.3
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=P+sSZ/MIHLkLQskC5zq8hmVD4ykc2QmIuRZHeedkEaI=;
        b=ojFUY1Ydha4EjvryEkE3HsxyjtloLRMCc5AmrdkMj8nj0s1r31KnEkySamhyOGNtxJ
         cJ4/+NGmk3It+nqJTCZRnc56LmxUKMBDiqc3uQZpAlGXydEiMUR7jJtwdNTo7+XXMIYH
         QNHQHUqVtdiJqKTkpy7d2LLoYXI9o363C5m5z3JucWS9HzlQMtFiJJdXcQRg0G9WxnEY
         wXE0rtDHshiBb39cqzlGsSxdkfRzf40J9yLOAikMOoZyBKTD8TtWjpUwsEgllQmeljW2
         +DMEUU9d2SVX02w7yjNbVPm+mexqvGQEPcMME9EN0yRU2V4CNpsYEcIrO7KV7jTYwpEG
         yk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P+sSZ/MIHLkLQskC5zq8hmVD4ykc2QmIuRZHeedkEaI=;
        b=wukFUsVfkSh37ZSBhbiM1bg62NJ428/oUV/wfi3xXZ4c40XR1Plk1uCTWGARYvqZmd
         4KxDNUfAraUoRdMkV29G/AggEatR/nHgzRrb7UbsvnljcSpHPfbMoI2RX9ACTiV/sfun
         pmPnTazQzFhU87OBfP5ZFzi9L3+YmBtVdHqnkg3DAn8eNcSvut6klrkOrr+5gejnAhzb
         OizfgkGaizW4ef4L4bjwmdKRG0XDXmgLQVINLg4wnNF9/dAwKNGo2yN/zvqmdIq+mIfr
         FIO6UjiGzrMc08Ph3PaApqwhgsiTJp/LCEE5+B+6E/OJ2CBIG9HDuC6r/wx2CsAj27+C
         xDVQ==
X-Gm-Message-State: AOAM532a1V+xmOkDEVkmUiJZRtyYE51MKYhQxJ41Z0K6tHOu8b+W+JLk
        Ie+iQuBXNB6XElaq24j5IGwsYQ==
X-Google-Smtp-Source: ABdhPJzBOCPzfCoOjZRJEfzWh6SxoSpbyeNrkPdkrWcpL7NEjcByTPWlBt/VH7PbCKEeRFDPXcGgnQ==
X-Received: by 2002:ac2:5441:0:b0:448:5b32:c493 with SMTP id d1-20020ac25441000000b004485b32c493mr14552456lfn.438.1647296029382;
        Mon, 14 Mar 2022 15:13:49 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id h1-20020a056512054100b0044847b32426sm3481059lfl.156.2022.03.14.15.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:13:48 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 09/14] net: dsa: Validate hardware support
 for MST
In-Reply-To: <20220314202040.f2r4pidcy6ws34qv@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-10-tobias@waldekranz.com>
 <20220314165649.vtsd3xqv7htut55d@skbuf>
 <20220314175556.7mjr4tui4vb4i5qn@skbuf> <87mthsl2wn.fsf@waldekranz.com>
 <20220314202040.f2r4pidcy6ws34qv@skbuf>
Date:   Mon, 14 Mar 2022 23:13:47 +0100
Message-ID: <87h780kwro.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 22:20, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 14, 2022 at 09:01:12PM +0100, Tobias Waldekranz wrote:
>> On Mon, Mar 14, 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Mon, Mar 14, 2022 at 06:56:49PM +0200, Vladimir Oltean wrote:
>> >> > diff --git a/net/dsa/port.c b/net/dsa/port.c
>> >> > index 58291df14cdb..1a17a0efa2fa 100644
>> >> > --- a/net/dsa/port.c
>> >> > +++ b/net/dsa/port.c
>> >> > @@ -240,6 +240,10 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
>> >> >  	if (err && err != -EOPNOTSUPP)
>> >> >  		return err;
>> >> >  
>> >> > +	err = dsa_port_mst_enable(dp, br_mst_enabled(br), extack);
>> >> > +	if (err && err != -EOPNOTSUPP)
>> >> > +		return err;
>> >> 
>> >> Sadly this will break down because we don't have unwinding on error in
>> >> place (sorry). We'd end up with an unoffloaded bridge port with
>> >> partially synced bridge port attributes. Could you please add a patch
>> >> previous to this one that handles this, and unoffloads those on error?
>> >
>> > Actually I would rather rename the entire dsa_port_mst_enable() function
>> > to dsa_port_mst_validate() and move it to the beginning of dsa_port_bridge_join().
>> > This simplifies the unwinding that needs to take place quite a bit.
>> 
>> Well you still need to unwind vlan filtering if setting the ageing time
>> fails, which is the most complicated one, right?
>
> Yes, but we can leave that for another day :)
>
> ...ergo
>
>> Should the unwinding patch still be part of this series then?
>
> no.

Agreed

>> Still, I agree that _validate is a better name, and then _bridge_join
>> seems like a more reasonable placement.
>> 
>> While we're here, I actually made this a hard error in both scenarios
>> (but forgot to update the log - will do that in v4, depending on what we
>> decide here). There's a dilemma:
>> 
>> - When reacting to the attribute event, i.e. changing the mode on a
>>   member we're apart of, we _can't_ return -EOPNOTSUPP as it will be
>>   ignored, which is why dsa_port_mst_validate (nee _enable) returns
>>   -EINVAL.
>> 
>> - When joining a bridge, we _must_ return -EOPNOTSUPP to trigger the
>>   software fallback.
>> 
>> Having something like this in dsa_port_bridge_join...
>> 
>> err = dsa_port_mst_validate(dp);
>> if (err == -EINVAL)
>> 	return -EOPNOTSUPP;
>> else if (err)
>> 	return err;
>> 
>> ...works I suppose, but feels somewhat awkwark. Any better ideas?
>
> What you can do is follow the model of dsa_switch_supports_uc_filtering(),
> and create a dsa_switch_supports_mst() which is called inside an
> "if br_mst_enabled(br)" check, and returns bool. When false, you could
> return -EINVAL or -EOPNOTSUPP, as appropriate.
>
> This is mostly fine, except for the pesky dsa_port_can_configure_learning(dp)
> check :) So while you could name it dsa_port_supports_mst() and pass it
> a dsa_port, the problem is that you can't put the implementation of this
> new dsa_port_supports_mst() next to dsa_switch_supports_uc_filtering()
> where it would be nice to sit for symmetry, because the latter is static
> inline and we're missing the definition of dsa_port_can_configure_learning().
> So.. the second best thing is to keep dsa_port_supports_mst() in the
> same place where dsa_port_mst_enable() currently is.
>
> What do you think?

I think that would mostly work. It would have to be positioned higher up
in the file though, so that it can be called from _bridge_join. Unless
we add a forward for it of course, but that seems to break with existing
conventions.
