Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB11403BB
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgAQGA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:00:59 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:45126 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:00:58 -0500
Received: by mail-pf1-f170.google.com with SMTP id 2so11416349pfg.12
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AJAUu1lz8691sSOVEYKtPP8lX1laxuCOGOc0GBesIbA=;
        b=d8WlvBjP8FyIvBDkDsVLQWAYsBv3HxFc7OyPeh84mweFO57ak1kUuJ8u9jrHAQpM19
         9U7NhpG6dnSv1eHABKQaTrhBoCh89dshSlpoy5s+bzrwL8mCgUfXScJVayrmRJHDl5wx
         tM2qsNDVgxkQKbnWxxrDWKybfmT/UZJLcDg+c2XSuy0P/7akZde2v+PzcNZtWmiwjHOu
         9+fmsiTA6sjsHt/dHKA+z53q03M7haMZl9qb75m8yeqE5fS8NSjPgRt7IW+JveYXb6Ru
         J9NkstfMjsLpgMqNnyIK6d9Hgc1xhq08pYNPJXgByKG9i4ovsexsF1mhwXmo+GwpF0EL
         /qhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJAUu1lz8691sSOVEYKtPP8lX1laxuCOGOc0GBesIbA=;
        b=n/8VdEqQT0Dg14q9aw1V0YCfgLqI5vyOCrv6Yuv9WWxCIdmLgkwJqUthlejgDfa7Rz
         /zwMN/YwqtmwsE5nkSUSPGs72Zpz1+LSoqxpa+QJiLTYU4wVSdTS20GbbA419kxBXrG6
         sZT56bdVi/nWr/ehQ2RkMD8BiHE3OsZcP74f7RI69PqnduFVtb8VBHfXQgiifhUWyLt0
         KzRg71wVDzbJkWijDFZVz5HX7hkrBLqY2VhB6QUfNjQy0ta5IZWhtRi1zVpMbJa8udO9
         COhrVs7LPYZpRWGzgBrbYJbAOsD0N2PSOMDw1aH3Sd+wYhZaZEt6uCcGiapbgTJGnIcX
         XUwg==
X-Gm-Message-State: APjAAAVmkK6xdFAWI16pDhBxoyC0jrvQRZjWD2/eAAbguY3A0dRPq/a2
        8s/LPpjgqrxzkUfsBryxWK4=
X-Google-Smtp-Source: APXvYqzbI9NWLqQ5E5sF1R8Ncay2MUvj02U+GOyLY+5CX9PGIzN35yu14g3TpcaUJRLDZM/EXXySQw==
X-Received: by 2002:a63:541e:: with SMTP id i30mr42227486pgb.183.1579240858065;
        Thu, 16 Jan 2020 22:00:58 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a23sm29283182pfg.82.2020.01.16.22.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 22:00:57 -0800 (PST)
Subject: Re: Veth pair swallow packets for XDP_TX operation
To:     Hanlin Shi <hanlins@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cheng-Chun William Tu <tuc@vmware.com>
References: <1D6D69BF-5643-45C2-A0F5-2D30C9C608E5@vmware.com>
 <fb2d324b-35fb-802d-2e1d-1ee1aa234c16@gmail.com>
 <68645457-3A77-4AC2-A033-F09DB5AEE6F8@vmware.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <d2dffea2-13d9-72a2-a89c-354b6403da54@gmail.com>
Date:   Fri, 17 Jan 2020 15:00:53 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <68645457-3A77-4AC2-A033-F09DB5AEE6F8@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please avoid top-posting in netdev mailing list.

On 2020/01/17 7:54, Hanlin Shi wrote:
> Hi Toshiaki,
> 
> Thanks for your advice, and now it's working as expected in my environment. However I still have concerns on this issue. Is this dummy interface approach is a short-term work around?

This is a long-standing problem and should be fixed in some way. But not easy.

Your packets were dropped because the peer device did not prepare necessary
resources to receive XDP frames. The resource allocation is triggered by
attaching (possibly dummy) XDP program, which is unfortunately unintuitive.
Typically this kind of problem happens when other devices redirect frames by
XDP_REDIRECT to some device. If the redirect target device has not prepared
necessary resources, redirected frames will be dropped. This is a common issue
with other XDP drivers and netdev community is seeking for a right solution.

For veth there may be one more option that attaching an XDP program triggers
allocation of "peer" resource. But this means we need to allocate resources
on both ends when only either of them attaches XDP. This is not necessary when the
program only does XDP_DROP or XDP_PASS, so I'm not sure this is a good idea.

Anyway with current behavior the peer (i.e. container host) needs to explicitly
allow XDP_TX by attaching some program on host side.

> The behavior for native XDP is different from generic XDP, which could cause confusions for developers. 

Native XDP is generally hard to setup, which is one of reasons why generic XDP was introduced.

> Also, I'm planning to load the XDP program in container (specifically, Kubernetes pod), and I'm not sure is it's feasible for me to access the veth peer that is connected to the bridge (Linux bridge or ovs).

So veth devices will be created by CNI plugins? Then basically your CNI plugin needs to attach
XDP program on host side if you want to allow XDP_TX in containers.

> 
> I wonder is that ok to have a fix, that if the XDP program on the peer of veth is not found, then fallback to a dummy XDP_PASS behavior, just like what you demonstrated? If needed I can help on the fix.

I proposed a similar workaround when I introduced veth native XDP, but rejected.
If we do not allocate additional resources on the peer, we need to use legacy data path
that does not have bulk interface, which makes the XDP_TX performance lower.
That would be a hard-to-fix problem than dropping...

Toshiaki Makita
