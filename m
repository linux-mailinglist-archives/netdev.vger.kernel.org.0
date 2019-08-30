Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E85A3987
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfH3Ors (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 10:47:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35892 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbfH3Orr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 10:47:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id f19so3487620plr.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 07:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ItoxvM21vDxM/GwrtO+PzcGibXvWpwjcb0fm3qVqp10=;
        b=QIr5f+aHpbX4uYDEF4IJtK1S1UrcdMur20vcgJVbR9AhYbQP4y8/yRihYN4BXHO8tF
         EKWE0mzFzChnaSg5BxEuTg4Cuu4wmgVPnrvTj0ik1bwDABd6n8lj6mzchcXiLkqt++Im
         qud3ksJSCBjq8XHFUe5/bTNHn7Cb2vfpPcTzSVEvQOBDICvBzdH6SytYQGEE77GjBKZ9
         QIRbRdaPlO0jW5iFpTz6a+daHg69qdinp1M/WXLoMaA/20TMuIcILgmMMzR/Rk6gb87u
         qPK+ypoOnTAuuRJxBd/spJoTlLkeq/Ybn9ns7BEzXo+6h/FUmgN5zH1z9Oq6U2OPIY3v
         Dz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ItoxvM21vDxM/GwrtO+PzcGibXvWpwjcb0fm3qVqp10=;
        b=oLQyW+ryIIcdtOLyoqznB/fUtxMTl+8zI9MTUesarW1bF56vGPIPB5xnnR/iq6jOxb
         SAEO5ItPvmCV/2vmyyM4bWQ1RVKTEUg6aEHGYfKhV8pBvA/HScPkQweuCmR1bmyV9JZZ
         EMJ/jUENoXB5RvhAvW8N5gLniBbz+pjT/IkeNbSyr/p5OHWhhA50yb2ALLjtZDP9AXGT
         3kW7Njdhtgnh+/Vi5JpdSW6fuK68sqcl2n16fRUHve1Oj5xIyLLnhkyNw2e5GDK+genr
         eJZfQNQnO4jUzfPOG+aZi+t0A0lhNajD5Hc9AhECWgzdTzf2e1Z/rTScZG2jQW7ma1ZC
         pLDQ==
X-Gm-Message-State: APjAAAXYU5XcZlD8NNuf65KBgIlSuxfhwZEjpEjLTVPUia9QlbtG/dNW
        cnkBRzBAdVNSwebO0VPYyWg=
X-Google-Smtp-Source: APXvYqxVkooyaUbID7dp/mtCTEoLb2oe8BNDi7s3se1MWhb0hLgzejuzT+QBVuy3Gng2gDnQKapDZg==
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr16909483plp.194.1567176467057;
        Fri, 30 Aug 2019 07:47:47 -0700 (PDT)
Received: from [172.27.227.156] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id n185sm5037471pga.16.2019.08.30.07.47.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 07:47:46 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9ec43634-d2e9-b976-1936-5b7ddc587b76@gmail.com>
Date:   Fri, 30 Aug 2019 08:47:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 8:35 AM, Roopa Prabhu wrote:
> On Wed, Aug 28, 2019 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>>
>> On Wed, Aug 28, 2019 at 09:36:41PM -0700, Roopa Prabhu wrote:
>>>
>>> yes,  correct. I mentioned that because I was wondering if we can
>>> think along the same lines for this API.
>>> eg
>>> (a) RTM_NEWLINK always replaces the list attribute
>>> (b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
>>> (c) RTM_DELLINK with NLM_F_APPEND updates the list attribute
>>>
>>> (It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
>>> case. I have not looked at the full dellink path if it will work
>>> neatly..its been a busy day )
>>
>> AFAICS rtnl_dellink() calls nlmsg_parse_deprecated() so that even
>> current code would ignore any future attribute in RTM_DELLINK message
>> (any kernel before the strict validation was introduced definitely will)
>> and it does not seem to check NLM_F_APPEND or NLM_F_UPDATE either. So
>> unless I missed something, such message would result in deleting the
>> network device (if possible) with any kernel not implementing the
>> feature.
> 
> ok, ack. yes today it does. I was hinting if that can be changed to
> support list update with a flag like the RTM_DELLINK AF_BRIDGE does
> for vlan list del.
> 
> so to summarize, i think we have discussed the following options to
> update a netlink list attribute so far:
> (a) encode an optional attribute/flag in the list attribute in
> RTM_SETLINK to indicate if it is a add or del

The ALT_IFNAME attribute could also be a struct that has both the string
and a flag.

> (b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
> (close to bridge vlan add/del)
> (c) introduce a separate generic msg type to add/del to a list
> attribute (IIUC this does need a separate msg type per subsystem or
> netlink API)
> 

