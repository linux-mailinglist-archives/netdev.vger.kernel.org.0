Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE562DC741
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgLPTdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbgLPTdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:33:35 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16756C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:32:55 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 23so51281420lfg.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=azTHyrTMgnrbgAhJwiqFI4iO8IOuTPUHs8cj1DucNCI=;
        b=iNJEmU4StFFbGmoRNf9a5mN85QvFXKUMYvkJ0vjYFktyheV1QcPycH7m8g/qg5u16J
         Uaot+xNruD+Mu8Uc647DvBq3NR9mCkiShCgwjEYDf5KyhCKzXH5X+knpJbv3sFWEzJOd
         vt+xTVG5VZdt74ZEZ5+b60DDunNQ9xinAxqu3tOA7POABxqCe9StneqJqAIZQtKb2WGb
         AkfzFG86XFB+4UU+8dMNeyKV70TxmZK9rzo7zFBWSiBle/wGfpzxRFJ283/YeAcTXRgQ
         qy421oPxiFfo6VGrrJ3RzeeW11up2Vqr+QI9bSV0hl8Xx27oM7sWG+suWP8sEHTGWwKH
         KTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=azTHyrTMgnrbgAhJwiqFI4iO8IOuTPUHs8cj1DucNCI=;
        b=bwrikVKeLOKgjXvF/qA5iJsj546QPW/++xqhc7a1tbTrSgm9af2vg7OP9ytEp/VPHq
         CCWB6cMhuKpA8pgAmIIvYAENgSZ/NKDFoZKzbK+OL2LtYITEZfFT4VGMbo20XXeqGMtJ
         NoIjCszVMXIdX9mvYU4QoBF41kOgjF76fMQUc+pDaw/esorfGHEbIa/gAEMIfqgIbZ8t
         8lM7l0xb32m/IQ3rez7KnO2S3ILMeIPYh/xiwf0Ux1H81oovUw6D1S738mBM/6bN3KjM
         R9KxAnC0JPwHOm8x+7Bqp3FCVgck2QwPQYktu8cgAG6TakHH1Vm4m/tKVNBm1Xl03VP+
         kX8A==
X-Gm-Message-State: AOAM530DfGXsIFAcPMPzrLKCuXR11oQ1eGLfZy3c9qLb9yZa99aQJYhU
        BnZCjRlqZzaBEsK+7LR4TGtfvbM1YCfXXGzD
X-Google-Smtp-Source: ABdhPJyk1zbklKiFt+Ug/+T5vksO02P0sAqvokpNomjyxiw2LzM//WZmGlx6BrE0zvF+7qOPwMEl7w==
X-Received: by 2002:a2e:924a:: with SMTP id v10mr11314505ljg.154.1608147172647;
        Wed, 16 Dec 2020 11:32:52 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id c10sm380827lji.103.2020.12.16.11.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:32:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/5] net: dsa: Don't offload port attributes on standalone ports
In-Reply-To: <20201216162711.3nhq3lktadyzksoh@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com> <20201216160056.27526-3-tobias@waldekranz.com> <20201216162711.3nhq3lktadyzksoh@skbuf>
Date:   Wed, 16 Dec 2020 20:32:51 +0100
Message-ID: <87v9d1bl7g.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 18:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 16, 2020 at 05:00:53PM +0100, Tobias Waldekranz wrote:
>> In a situation where a standalone port is indirectly attached to a
>> bridge (e.g. via a LAG) which is not offloaded, do not offload any
>> port attributes either. The port should behave as a standard NIC.
>> 
>> Previously, on mv88e6xxx, this meant that in the following setup:
>> 
>>      br0
>>      /
>>   team0
>>    / \
>> swp0 swp1
>> 
>> If vlan filtering was enabled on br0, swp0's and swp1's QMode was set
>> to "secure". This caused all untagged packets to be dropped, as their
>> default VID (0) was not loaded into the VTU.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  net/dsa/slave.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 4a0498bf6c65..faae8dcc0849 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -274,6 +274,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
>>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>>  	int ret;
>>  
>> +	if (attr->orig_dev != dev)
>> +		return -EOPNOTSUPP;
>> +
>
> Should this not be:
>
> 	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
> 		return -EOPNOTSUPP;
>
> ?

That function is born in the following patch. So here I just align the
filtering with how switchdev objects were handled before this
series. Then in the next patch, all instances are converted to the exact
statement you suggest.

>>  	switch (attr->id) {
>>  	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
>>  		ret = dsa_port_set_state(dp, attr->u.stp_state, trans);
>> -- 
>> 2.17.1
>> 
