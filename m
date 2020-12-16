Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C112DC75E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgLPTso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbgLPTso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:48:44 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D31C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:48:03 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id o17so48464141lfg.4
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=wEuXjgtIIgK53/U+BUGaly7XtsQgkxJOICCOFSVbYfs=;
        b=MeXaM6qNIVJafa4UeA4WQIm9JSCHbyauyjf+hkVZR5C8BMSKiIlbVc4SYfqL3mMSOn
         b5dvH99WWs8tiejzfamVQhLKBi4i/igKa2SUgwoMXt2tKXopx/STvmatqfJhha27cBoD
         Wk3PkDjwy21jXD7WnXLbXQotx4zPKRX4rrun7B73q8pBZRT1JPUOWU0WaTpklZ7VUkUH
         ZBuGNiSuG63xGhukyfUufALFX8hEGN4nmMBdVe7OECeVgEWVrkA7JCF3Sg7y4iPlggDr
         Cy7VBE9YiPtQyHBBXR7/G55TTff1W2YES0LIEPp6N7ANs09IgNqRb0xZxnDGuu748nYr
         50kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wEuXjgtIIgK53/U+BUGaly7XtsQgkxJOICCOFSVbYfs=;
        b=JoZkBoOE+AdJdvsS3dVfupQDZXNy1FgBURQf4ZI9ZP0H0cEuvAOnT2g6c19IPFBiN+
         o7945vzl0oXzqG2VmzKzTJ3gs0q+Nf7pTyjtyaVpY2jvdyDLYSPEjl96sB0zE17mtnEa
         aqmkiNclBN5RDrfgnm4pt101/JWA2bstYtowJKZmHKdu39c1lJiPcEyzCfHNIXwKA1Xs
         m4/6HIQ9Ac0yj8NwAV5gavGS9fb3Y/vAqlufJS02vnymKiA5w9PzIOhYvKHB+Vpaiywy
         UpMXWTqWIRKFTZ0rfILWskcraWRwBLguMQB2Zyb9o+6RnG2DVDbeZVMfTGVKMK0dbAgw
         dBrg==
X-Gm-Message-State: AOAM531+fUo9X3kQnew3vurDMMzg2M5RT4fCnjOQGUSK7rMa+QOpGXx9
        W7afZM/9B0H0pFOIcigx9kJXSXUbD4N1frKK
X-Google-Smtp-Source: ABdhPJwL9w76muoLEHryhDW4xf9yQVGZxf6Sj8yzNIAvFckQrg9+hH08UiP7j+VuewIf1Ut2XsDSKA==
X-Received: by 2002:a2e:3503:: with SMTP id z3mr15103936ljz.74.1608148081580;
        Wed, 16 Dec 2020 11:48:01 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id z9sm394868ljh.3.2020.12.16.11.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:48:00 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
In-Reply-To: <20201216162223.f7yndqvdlqt2akfs@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com> <20201216160056.27526-4-tobias@waldekranz.com> <20201216162223.f7yndqvdlqt2akfs@skbuf>
Date:   Wed, 16 Dec 2020 20:47:59 +0100
Message-ID: <87pn39bki8.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 18:22, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
>> Monitor the following events and notify the driver when:
>> 
>> - A DSA port joins/leaves a LAG.
>> - A LAG, made up of DSA ports, joins/leaves a bridge.
>> - A DSA port in a LAG is enabled/disabled (enabled meaning
>>   "distributing" in 802.3ad LACP terms).
>> 
>> When a LAG joins a bridge, the DSA subsystem will treat that as each
>> individual port joining the bridge. The driver may look at the port's
>> LAG device pointer to see if it is associated with any LAG, if that is
>> required. This is analogue to how switchdev events are replicated out
>> to all lower devices when reaching e.g. a LAG.
>> 
>> Drivers can optionally request that DSA maintain a linear mapping from
>> a LAG ID to the corresponding netdev by setting ds->num_lag_ids to the
>> desired size.
>> 
>> In the event that the hardware is not capable of offloading a
>> particular LAG for any reason (the typical case being use of exotic
>> modes like broadcast), DSA will take a hands-off approach, allowing
>> the LAG to be formed as a pure software construct. This is reported
>> back through the extended ACK, but is otherwise transparent to the
>> user.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>> 
>> I tried in vain to win checkpatch's approval of the foreach macros, no
>> matter how many parentheses I added. Looking at existing macros, this
>> style seems to be widely accepted. Is this a known issue?
>>
>>  include/net/dsa.h  | 60 +++++++++++++++++++++++++++++++++++
>>  net/dsa/dsa2.c     | 74 +++++++++++++++++++++++++++++++++++++++++++
>>  net/dsa/dsa_priv.h | 36 +++++++++++++++++++++
>>  net/dsa/port.c     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>>  net/dsa/slave.c    | 70 ++++++++++++++++++++++++++++++++++++----
>>  net/dsa/switch.c   | 50 +++++++++++++++++++++++++++++
>>  6 files changed, 362 insertions(+), 7 deletions(-)
>> 
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 4e60d2610f20..9092c711a37c 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -149,8 +149,41 @@ struct dsa_switch_tree {
>>  
>>  	/* List of DSA links composing the routing table */
>>  	struct list_head rtable;
>> +
>> +	/* Maps offloaded LAG netdevs to a zero-based linear ID for
>> +	 * drivers that need it.
>> +	 */
>> +	struct net_device **lags;
>> +	unsigned int lags_len;
>>  };
>>  
>> +#define dsa_lags_foreach_id(_id, _dst)				\
>> +	for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)	\
>> +		if ((_dst)->lags[_id])
>> +
>> +#define dsa_lag_foreach_port(_dp, _dst, _lag)	       \
>> +	list_for_each_entry(_dp, &(_dst)->ports, list) \
>> +		if ((_dp)->lag_dev == (_lag))
>
> ERROR: Macros with complex values should be enclosed in parentheses
> #86: FILE: include/net/dsa.h:160:
> +#define dsa_lags_foreach_id(_id, _dst)                         \
> +       for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)      \
> +               if ((_dst)->lags[_id])
>                                  ~~~
>                                  missing parentheses
>
> ERROR: Macros with complex values should be enclosed in parentheses
> #90: FILE: include/net/dsa.h:164:
> +#define dsa_lag_foreach_port(_dp, _dst, _lag)         \
> +       list_for_each_entry(_dp, &(_dst)->ports, list) \
>                             ~~~
>                             missing parentheses
> +               if ((_dp)->lag_dev == (_lag))

Please see my comment just before the diffstat. I tried adding these
parentheses, and about a gagillion other ones. But no matter what I did
I could not make checkpatch happy.

This is where I gave up:

ERROR: Macros with complex values should be enclosed in parentheses
#160: FILE: include/net/dsa.h:160:
+#define dsa_lags_foreach_id(_id, _dst)                         \
+       for (((_id) = 0); ((_id) < ((_dst)->lags_len)); ((_id)++))      \
+               if ((_dst)->lags[(_id)])

ERROR: Macros with complex values should be enclosed in parentheses
#164: FILE: include/net/dsa.h:164:
+#define dsa_lag_foreach_port(_dp, _dst, _lag)         \
+       list_for_each_entry((_dp), &((_dst)->ports), list)      \
+               if (((_dp)->lag_dev) == (_lag))

