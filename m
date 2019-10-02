Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B00C90B6
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfJBSVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:21:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35372 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbfJBSVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:21:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id y21so7961598wmi.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZcdhzacrDgvQn7XlMkm7i106xpcGRQuSmJrk/gGOHHM=;
        b=2MfTiqdwShY24hzqb0nqK7lx+6fl46Dyc400N7K9H+I8w04k9YIveiB5Kipcxldfv7
         nKtbKReGcpLnhXP+tC6lkhDmFnOK/LTyp4tCj0BAumEvi6DxvTLQL/pSIyqQ6xcecRKQ
         ExzJrTeZJ4tCuiI1EnfPM8OpHvmOrJonTKhWCD/Yp/s/ZK5Tpq8jft+HXg8h+7Xvjh0F
         gRnvAw4FgsDappCXS80d13CbR89raDfmGm7BwfSPajYAmohznga+RMWpLaUqjgtf9TTm
         9Zzy0lcdTOaRhWpD7Yi0i2yfy7kSDCqC070H/WtypeVIhJ03aPtpF4/Uj/i7SbGrmlGd
         THjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZcdhzacrDgvQn7XlMkm7i106xpcGRQuSmJrk/gGOHHM=;
        b=a3ZkbpP7E/6rwTQKPOAUE0gQFJPy9WZbrTrXEZA/xnunFevb27PyfCtAsjmK/iDdf+
         jCYdYidpIuJjA134Jl1D50GlIzTctHkvXQa8x9uRlOxdR2D50aI1hzNexadxbW8+4F+2
         eAzHuLi5Q038ORlgoE8igcN3FQqqwmfLV72o4d4Skyo2sN/rEQUqXHJhIGA2x5jC/Mgv
         gL7h2/Rvu9TvPhxuzetsaS4uAEPy9qCyrH44nqF+Vbn1V5qLLB+xQMio9qfXWsJX3tWy
         koTT96nWoktxkxuFiDMOWx7cbwlWwScu7NrQh4smqVejIFZj278/Ikb1LFzGA5sdSO+p
         dUgg==
X-Gm-Message-State: APjAAAXjh1ToBo8IevQQUq8UmvJRyaOznvdYYdQp2ZQ654MbmmqitJ/W
        aXWheMd6oa4KwG20eJ62aMUh2Q==
X-Google-Smtp-Source: APXvYqxyLaG0lhTUCA/mP/3jkOGuNlgE6NejSs+rm4GGXwvW5nesT/aaiqJ7iajKxEOWm4YKuocCKw==
X-Received: by 2002:a1c:ba08:: with SMTP id k8mr4038647wmf.63.1570040479999;
        Wed, 02 Oct 2019 11:21:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b16sm288889wrh.5.2019.10.02.11.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:21:19 -0700 (PDT)
Date:   Wed, 2 Oct 2019 20:21:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
Message-ID: <20191002182119.GF2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 05:58:52PM CEST, roopa@cumulusnetworks.com wrote:
>On Wed, Oct 2, 2019 at 1:41 AM Ido Schimmel <idosch@idosch.org> wrote:
>>
>> From: Ido Schimmel <idosch@mellanox.com>
>>
>> When performing L3 offload, routes and nexthops are usually programmed
>> into two different tables in the underlying device. Therefore, the fact
>> that a nexthop resides in hardware does not necessarily mean that all
>> the associated routes also reside in hardware and vice-versa.
>>

*****

>> While the kernel can signal to user space the presence of a nexthop in
>> hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
>> for routes. In addition, the fact that a route resides in hardware does
>> not necessarily mean that the traffic is offloaded. For example,
>> unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
>> packets to the CPU so that the kernel will be able to generate the
>> appropriate ICMP error packet.

*****


>>
>> This patch adds an "in hardware" indication to IPv4 routes, so that
>> users will have better visibility into the offload process. In the
>> future IPv6 will be extended with this indication as well.
>>
>> 'struct fib_alias' is extended with a new field that indicates if
>> the route resides in hardware or not. Note that the new field is added
>> in the 6 bytes hole and therefore the struct still fits in a single
>> cache line [1].
>>
>> Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
>> with the route's key in order to set / clear the "in hardware
>> indication".
>>
>> The new indication is dumped to user space via a new flag (i.e.,
>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
>>
>
>nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
>with the nexthop offload indication ?.

See the second paragraph of this description.


>But this again does not seem to be similar to the other request flags
>like: RTM_F_FIB_MATCH
>
>(so far i think all the RTNH_F_* flags are used on routes too IIRC
>(see iproute2: print_rt_flags)
>RTNH_F_DEAD seems to fall in this category)
