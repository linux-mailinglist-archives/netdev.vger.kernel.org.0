Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCAB4DA5D0
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352425AbiCOW6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiCOW6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:58:17 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBD95D5E8
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:57:04 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s29so895987lfb.13
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=AckR/coIxOb10tv+spqnXBr+Bpips1bwCHH84e6FTSM=;
        b=FCVeUrS472oDWiDqhyo4Ws4t2jUTRUzskbKDGjh1i4yV9sGjgTDZPif753HOrdYB1v
         +IoBKY5p+5LMXn4pzvHYzgUjCG9MlulNyimV9n4tTkdI41HZLW2Lm/nJZOEBpiyk1ZnQ
         lNPJNIavokMhsayNWMImIfqVk/j9xYgjjg2sUwwdLZC57cPqPPeD8LE9MO3aBqnIDS+X
         pihRjdSJFuj4TE/JRq4fZvSUQiM10UijL305ffL1EfHnSbTlbe7FI8MmSfxhveFUBzCJ
         OXx1sZbUrYln41S3aDx+/5r793aunkI+XLWkywP+v8/X+e7U0haSNfobmO7oekIDfqtu
         yNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AckR/coIxOb10tv+spqnXBr+Bpips1bwCHH84e6FTSM=;
        b=HmMe0li+SXfkzAd7sk3a9sQ4B2IbCWd7hh7ra0jgSwqXErLiA/TgvQa9VEE+orKw+r
         Y5GFpQsDZncmFi0HNROZzkqBg2Xus714Wym/nc/Nw1Xojabr3YFPnvAZ57jHA3FlBrJW
         XUT0NFWeL8FUEkZDCPb4X89llZcj9bgjkNs0rQJvnGrGd4kVNcpcC8IPPobkKZjv5XnW
         yrd1uC1r0XhaMYLbknEBszoAAK2PIgBGvw4A2qZ5oqt6CiUW/Z51vwj4lcnLqA8Jo5Ff
         QQDfgxW+UBMhnOorb7W6RKs3RGKg+Kw76eWzqgykfsWXtliWefBhwbvpJKB0P2/kzDLW
         X6Lg==
X-Gm-Message-State: AOAM532jxcOsw2kKd+UgNlFsD4kwdMI9DbJGxBNDSe4K7o4eSQ5AF6cN
        NqNbl36sAAkCYMF5FZ9rDklKCA==
X-Google-Smtp-Source: ABdhPJw2KWlYZiyQRjRnqb4/L4mhvft8SvJA9g41H5Uxa1E1S0kNfhbTWB2cHcRvCCOCdthsakGn4Q==
X-Received: by 2002:ac2:55a7:0:b0:448:3023:e645 with SMTP id y7-20020ac255a7000000b004483023e645mr18084066lfg.266.1647385022741;
        Tue, 15 Mar 2022 15:57:02 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id p11-20020a19f10b000000b004488b82a87esm25531lfh.39.2022.03.15.15.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:57:02 -0700 (PDT)
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
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 09/15] net: dsa: Never offload FDB entries
 on standalone ports
In-Reply-To: <20220315224205.jzz3m2mroytanesh@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-10-tobias@waldekranz.com>
 <20220315163349.k2rmfdzrd3jvzbor@skbuf> <87ee32lumk.fsf@waldekranz.com>
 <20220315224205.jzz3m2mroytanesh@skbuf>
Date:   Tue, 15 Mar 2022 23:57:01 +0100
Message-ID: <875yoelt8i.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 00:42, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 15, 2022 at 11:26:59PM +0100, Tobias Waldekranz wrote:
>> On Tue, Mar 15, 2022 at 18:33, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Tue, Mar 15, 2022 at 01:25:37AM +0100, Tobias Waldekranz wrote:
>> >> If a port joins a bridge that it can't offload, it will fallback to
>> >> standalone mode and software bridging. In this case, we never want to
>> >> offload any FDB entries to hardware either.
>> >> 
>> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >> ---
>> >
>> > When you resend, please send this patch separately, unless something
>> > breaks really ugly with your MST series in place.
>> 
>> Sure. I found this while testing the software fallback. It prevents a
>> segfault in dsa_port_bridge_host_fdb_add, which (rightly, I think)
>> assumes that dp->bridge is valid. I feel like this should have a Fixes:
>> tag, but I'm not sure which commit to blame. Any suggestions?
>
> Ok, makes sense. So far, unoffloaded bridge ports meant that the DSA
> switch driver didn't have a ->port_bridge_join() implementation.
> Presumably that also came along with a missing ->port_fdb_add()
> implementation. So probably no NPD for the existing code paths, it is
> just your unoffloaded MST support that opens up new possibilities.
>
> Anyway, the dereference of dp->bridge first appeared in commit
> c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
> which is still just in net-next.

Thanks, I just sent it separately:

https://lore.kernel.org/netdev/20220315225018.1399269-1-tobias@waldekranz.com

>> >>  net/dsa/slave.c | 3 +++
>> >>  1 file changed, 3 insertions(+)
>> >> 
>> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> >> index a61a7c54af20..647adee97f7f 100644
>> >> --- a/net/dsa/slave.c
>> >> +++ b/net/dsa/slave.c
>> >> @@ -2624,6 +2624,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>> >>  	if (ctx && ctx != dp)
>> >>  		return 0;
>> >>  
>> >> +	if (!dp->bridge)
>> >> +		return 0;
>> >> +
>> >>  	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
>> >>  		if (dsa_port_offloads_bridge_port(dp, orig_dev))
>> >>  			return 0;
>> >> -- 
>> >> 2.25.1
>> >> 
