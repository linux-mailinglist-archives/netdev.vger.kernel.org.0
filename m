Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E0B67899
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 07:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfGMFbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 01:31:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45192 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfGMFbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 01:31:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so5436249pgp.12
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 22:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2ggg9+QN5rkCW05g/CmWaetXySs+9ZikemsFZTgmZ2I=;
        b=GC+epzucSFJFz7KF83aM1xtfZAHCzYcq8gg8KmP356VLPMBWcLtJOnI6WO3alnbdj5
         M7ceqkkI/h7ufHgj7HHHSa0DivfElTKsOt6rExciwQG4BHHcgyRZr8dYQo4rHXs9OWX3
         2wWBmj735c099eUc/F8RisuPSpCFWpuyYTTEObWmm6mVpkDwDFARqew0T6m1E+n7ncoP
         hic53BcbBmEV8WYcgPrPqpfEEFCT1JS8/vdaxjA2C1qWmLchMvADfv5vmQLLYe017D88
         aSsuhSDybCRSgaiX4JFjHWh62m+G6utipz9xcLfPv7neFXYjI2vz7qEvqzMCyhzVbZKk
         SscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2ggg9+QN5rkCW05g/CmWaetXySs+9ZikemsFZTgmZ2I=;
        b=ClSRlc2g1e/xTgMfI/uBZ3M0ntjyuQz6vzPxToX5GLDdts1JarrMg2gP1id2L/jCxT
         NhQasXveW3VbtIjWBT+zYNvatBxqiGRIrMvxExpAL6gD+tAAs/MZCdBnqGCGuM2jFB4u
         jeSFjA63g/XHUS8h2o6TCQO6c74BYQmZW9Uhai6MjrGWclwI4OB90u0Y61V1pc+lcMZo
         8rCa0nmKZUUDzjHfesUmgPhxCiAx5XtNysRAA6flNI2CnR6WtTK6I+6M1At9G+RgiErp
         OCCttpj95m6hpk/Nilg6CN/mxW6yOzySH2SXYz1Mg7iGHXp466iZiUXNU4TjpnF8ZxsF
         wLYg==
X-Gm-Message-State: APjAAAWPTgDoouIp2o/dr1Cy9raB5enunIZ0XfOAbcivF+FiYVoAGrh2
        gojvg5jxomai6UQsjdlkLknuxTcE/M0=
X-Google-Smtp-Source: APXvYqzAXz+7LIm/gWy4KNRC+3eemOM653BAR4OOU2oLYvI2/JRFaOz4oOwQ13a9kCu7PwkenSx6Tg==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr15598143pjs.112.1562995895889;
        Fri, 12 Jul 2019 22:31:35 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id i124sm21222183pfe.61.2019.07.12.22.31.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 22:31:35 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709023050.GC5835@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <79f2da6f-4568-4bc8-2fa4-3aa5a41bbff1@pensando.io>
Date:   Fri, 12 Jul 2019 22:32:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709023050.GC5835@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 7:30 PM, Andrew Lunn wrote:
>> +static int ionic_nway_reset(struct net_device *netdev)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	int err = 0;
>> +
>> +	if (netif_running(netdev))
>> +		err = ionic_reset_queues(lif);
> What does ionic_reset_queues() do? It sounds nothing like restarting
> auto negotiation?
>
>       Andrew
Basically, it's a rip-it-all-down-and-start-over way of restarting the 
connection, and is also useful for fixing queues that are misbehaving.  
It's a little old-fashioned, taken from the ixgbe example, but is 
effective when there isn't an actual "restart auto-negotiation" command 
in the firmware.

I'll try to make it a little more evident.

sln


