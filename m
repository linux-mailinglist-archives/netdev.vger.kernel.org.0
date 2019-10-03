Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B307C9804
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfJCFk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:40:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47041 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbfJCFk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:40:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so1389005wrv.13
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 22:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H4huWPZtNw5mPzVvLLaG4sYvweJySVhT/oDBAIc5ews=;
        b=BggMJ1tbRvTS6PJ+MS4F+83Cx4x9FMnaLa0+h8CaU7tszX/HX6uINjh/hrnac8bd/0
         sEPRoujysJDhzbqJwrPHVNHwcdKVaTjxQhoENaemaf2EDwpSvkCMVTB3cf2rMrGiRUWM
         4pruWtfl4hne0M7DPWC8hJxEIHa/gg74NGxJgLVYMECFq+rgfACz5Mzk7gejVFaosnSi
         3Ifico4pxMyUiAIPzzX6b8h9QFJsV/9pEtZuCW8Oj9yTGP4VS+SlR6xj0MA9Z+msw2xA
         Glwn72Bdf+Rglemv900LzJlQ1VJ5ZA8QlKeg/88SujGpAde6QY6gcfte1of98lWXNgov
         xVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H4huWPZtNw5mPzVvLLaG4sYvweJySVhT/oDBAIc5ews=;
        b=VZIg+oIhYhBkXoO8PPywuKWz4ethzPh7wfD11t19Km5R7/85OqkKBHG865vyAWRTyO
         HiDg23x3mq8GOnqDf7kyyNe2fjcLWKFUtpSUCpMMRRFfoj+qAkpkJYGcN2/4dPN2Zi5j
         ACOWBpx6vWIB9TJQXl3q6xUYGeytdhQjcv8H6BiFLVoIhW/Tz0YppwHGiWRxlm9ikqcr
         1kRcZlP/VfK0CSfywFpGL18kdb2kAuJhsZJXJS3X0HvQwu+6UF26R1/KYqppPsHLGVY4
         nFnbjLa8cB/8Hv1GPGXf9w3LUgPIRgdTtVFWwS5YhGsv78WDCz3Txk2c/XjyO+q3T4bl
         ndQw==
X-Gm-Message-State: APjAAAXwjHfp+Q1v0k9krXE+GXtDNN+FStuPT08t3IRn+Wh8X4r+6x1D
        GJX0yGBxJFc8C+WnLziLHdvwIg==
X-Google-Smtp-Source: APXvYqw1g7WYTy+Q+tQNLQfhqGlUbu5KRsQ6Gl61Qr+wUJiYPJG2HggFSgPPuGucJxEWXK+f5L7Ipg==
X-Received: by 2002:adf:f0c7:: with SMTP id x7mr5732437wro.2.1570081254850;
        Wed, 02 Oct 2019 22:40:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t1sm1473868wrn.57.2019.10.02.22.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 22:40:54 -0700 (PDT)
Date:   Thu, 3 Oct 2019 07:40:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Ido Schimmel <idosch@idosch.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
Message-ID: <20191003054053.GI2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 03, 2019 at 04:34:22AM CEST, dsahern@gmail.com wrote:
>On 10/2/19 12:21 PM, Jiri Pirko wrote:
>>>> This patch adds an "in hardware" indication to IPv4 routes, so that
>>>> users will have better visibility into the offload process. In the
>>>> future IPv6 will be extended with this indication as well.
>>>>
>>>> 'struct fib_alias' is extended with a new field that indicates if
>>>> the route resides in hardware or not. Note that the new field is added
>>>> in the 6 bytes hole and therefore the struct still fits in a single
>>>> cache line [1].
>>>>
>>>> Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
>>>> with the route's key in order to set / clear the "in hardware
>>>> indication".
>>>>
>>>> The new indication is dumped to user space via a new flag (i.e.,
>>>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
>>>>
>>>
>>> nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
>>> with the nexthop offload indication ?.
>> 
>> See the second paragraph of this description.
>
>I read it multiple times. It does not explain why RTM_F_OFFLOAD is not
>used. Unless there is good reason RTM_F_OFFLOAD should be the name for
>consistency with all of the other OFFLOAD flags. I realize rtm_flags is
>overloaded and the lower 8 bits contains RTNH_F flags, but that can be
>managed with good documentation - that RTNH_F is for the nexthop and
>RTM_F is for the prefix.

"In addition, the fact that a route resides in hardware does
not necessarily mean that the traffic is offloaded."
