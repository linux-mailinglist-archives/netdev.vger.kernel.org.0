Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C92513CE2E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgAOUqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:46:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53154 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOUqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:46:33 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so1451577wmc.2
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nyNNJXd3nFEDoBvkUdp0lxjhucgV2jRaXG099b7ev7I=;
        b=vwj9XttmGtyWpzC2b5BERCQT1CSMcYeXpOw54bjpiVOM6lilWcpUH0wul4KEJn7NxK
         58OX77keg5Ietl8q5QFFuXOso4bzD7/BIC0jZeyLQs4DrT0f6/lsr5GHO8JFJlGrDEO2
         3YJb7gj1Zr6yZkCNrRh+krSo/ioeA64J2DzLu5XRL/Gf7fCP9CeP4JN5H0IAX5PjnOVD
         pCiyFNQEuaEO8RgRpRrhclJXd4TqB0Gi9NwACeGIieuSyz9hj6as9C0ZtQJzf2zECUCB
         2pdvKHwvyVFRXdaoSVvyVgy/SPDLjIgKRPa7VhSY3Ay5GPQx+uard8bS/F3wTSD8OO9X
         VXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nyNNJXd3nFEDoBvkUdp0lxjhucgV2jRaXG099b7ev7I=;
        b=nGL/YRZ8+PBuWvz41F2VZR6j+5c9T3OxvWI9vRMsjlB1feDHmZ2PeUpxy/Gm49ylJS
         ivmfmG9RjXtBpl2S56hjCvi5Xi6jlFzQ2Hx4weKOeVytbD84+iNXBk4tLNI4cbug+v6V
         7r0dgaKNvkHFqY9ulX3h5owM//kO3N2b0NuOCFSTLZOo0cnEknK1pCf1iS34QQlO4rM8
         bE7++HikqIM72WxfsPRsKK1UnPXvmu4EJ7kCg934vimgAsTCRYCQAPyTIoQXbn0HBg0U
         06/t5NP1RftSxxn3cd6qrniP2IXShVMB/LmR7K7xCJO2Q0FCLMumi55173qX6RsN48rD
         47LQ==
X-Gm-Message-State: APjAAAX2dtCwOg4QEVj8+i2++Ie3b1QM7UGvG2UJOsmeyybXoWmuWXQe
        83F5U2axX/lY1w37HZ3TINtr7Q==
X-Google-Smtp-Source: APXvYqwRSe6nxnGU8sDcZcERxa9VhXzEM6nwZHN/sr2wZ9LcuZ1f0+mMYIAj92GYnjNg7ozxjS/rvg==
X-Received: by 2002:a1c:3189:: with SMTP id x131mr1840683wmx.59.1579121190004;
        Wed, 15 Jan 2020 12:46:30 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id m3sm25260916wrs.53.2020.01.15.12.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 12:46:29 -0800 (PST)
Date:   Wed, 15 Jan 2020 21:46:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Message-ID: <20200115204628.GZ2131@nanopsycho>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho>
 <20200115143320.GA76932@unreal>
 <20200115164819.GX2131@nanopsycho>
 <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com>
 <26054.1579111461@famine>
 <4c78b341-b518-2409-1a7a-1fc41c792480@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c78b341-b518-2409-1a7a-1fc41c792480@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 15, 2020 at 07:12:54PM CET, dsahern@gmail.com wrote:
>On 1/15/20 11:04 AM, Jay Vosburgh wrote:
>> 
>>> Something similar is needed for xdp and not necessarily tied to a
>>> specific bond mode. Some time back I was using this as a prototype:
>>>
>>> https://github.com/dsahern/linux/commit/2714abc1e629613e3485b7aa860fa3096e273cb2
>>>
>>> It is incomplete, but shows the intent - exporting bond_egress_slave for
>>> use by other code to take a bond device and return an egress leg.
>> 
>> 	This seems much less awful, but would it make bonding a
>> dependency on pretty much everything?
>> 
>
>The intent is to hide the bond details beyond the general "a bond has
>multiple egress paths and we need to pick one". ie., all of the logic
>and data structures are still private.
>
>Exporting the function for use by modules is the easy part.
>
>Making it accessible to core code (XDP) means ??? Obviously not a
>concern when bond is built in but the usual case is a module. One
>solution is to repeat the IPv6 stub format; not great from an indirect
>call perspective. I have not followed the work on INDIRECT_CALL to know
>if that mitigates the concern about the stub when bond is a module.

Why it can't be an ndo as I previously suggested in this thread? It is
not specific to bond, others might like to fillup this ndo too (team,
ovs, bridge).
