Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0762A1B154C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDTTDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:03:03 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A1C061A0C;
        Mon, 20 Apr 2020 12:03:02 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x2so9551663qtr.0;
        Mon, 20 Apr 2020 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hgAjps0nJl7u5gmwuhjVuLdKn4woFTWzZ2fAe7ZVBPQ=;
        b=tXCl5Rc1ElajW5dddhQ5EJPStDlqaP9YpbqwcQ0830qN4U+9MIXWUTsCInKB5RRFuS
         LKYZmLyzUh/xL2UJ6upwyeL5pI+VqdzFx35kcePmsCT8foMEcsxYPFQGc/I18YtOkY8o
         0itt5DROZHxrpNWkdy3OdQKiDcWHcq71nEQh6xd0GA274P9HDwsTGJJSEwixRhyHG7w9
         1DvAbDJP35sp1u/Uy7GE+yR+0uSo6enTeiMN8HBkaUKj9e73xnB9WOT+kYKBpSR477/c
         OzinsGFrJSyekWz5lecA1+8v7FMNIHhLdLSAUw8/ApVBK5i2JlpGhhHoPxQ3YdgpfveF
         nHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgAjps0nJl7u5gmwuhjVuLdKn4woFTWzZ2fAe7ZVBPQ=;
        b=k7Z49/NbThXLHFGeV7jcbExu+vz8lFsFX9YSIdwOMlg7pL5BQ7gtUDtfeUOjrgMyp5
         zLSppbDOpg4z7i0rnmZJq2IT4spKV4o/WgCaOT0bGktGzZg+ZjtzH7fwTVnkPeVzQkX3
         hyHeAoReswMWO3x94MhEGJGhMXScWohK5HdITsjAqpTE4m9IklyqaaE9RI+6FTavCZb9
         T0zxvz2kDkwWU/USI6PcJ6oHGk0i4sqAxCnY5YvhIOQUdk9la4pasSsPNaAgGqYStb71
         Cg7lknZy1HLVV6TjMH7KZmwNzuI6flVnKef0O7Fy3U1t8M9+2i+hN0ynAezEmErOXqmF
         HxVA==
X-Gm-Message-State: AGi0PuYaxF+tRdU4HJDBt3BC5sheWDkaCy9pAyPpz+ZMa5db5bLAgBmD
        EExKJncMOoSbIxb4FbPlA8k=
X-Google-Smtp-Source: APiQypJob3pjjWU2U5V1SkyS5htZeHTvgrJM0+OeqX7tlblQoBUafLhoZefiyMLdMxksz8Dj8ePuBA==
X-Received: by 2002:ac8:5256:: with SMTP id y22mr16708510qtn.321.1587409381587;
        Mon, 20 Apr 2020 12:03:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id p25sm295741qkk.18.2020.04.20.12.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 12:03:00 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Maor Gottlieb <maorg@mellanox.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
 <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
 <20200420184811.GW6581@nanopsycho.orion>
 <60467948-041c-5de1-d365-4f21030683e7@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <46f77bb5-c26e-70b9-0f5a-cd3327171960@gmail.com>
Date:   Mon, 20 Apr 2020 13:02:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <60467948-041c-5de1-d365-4f21030683e7@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 12:56 PM, Maor Gottlieb wrote:
> 
> On 4/20/2020 9:48 PM, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 08:04:01PM CEST, dsahern@gmail.com wrote:
>>> On 4/20/20 12:01 PM, Jiri Pirko wrote:
>>>> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
>>>> this is ever going to be used for other master. And if so, could be
>>>> very
>>>> easily renamed then...
>>> core code should be generic, not specific and renamed at a later date
>>> when a second use case arises.
>> Yeah, I guess we just have to agree to disagree :)
> 
> So I am remaining with the flags. Any suggestion for better name for the
> enum? Should I move master_xmit_get_slave from lag.h to netdevice.h?
>>

IMHO, yes, that is a better place.

generic ndo name and implementation.
type specific flag as needed.

This is consistent with net_device and ndo - both generic concepts -
with specifics relegated to flags (e.g., IFF_*)
