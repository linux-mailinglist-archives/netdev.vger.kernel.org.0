Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95B3DD742
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhHBNhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbhHBNhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:37:22 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B57DC06175F;
        Mon,  2 Aug 2021 06:37:12 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id u10so24087443oiw.4;
        Mon, 02 Aug 2021 06:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PbcBzYCDzjM/TKXUy4gd/mf09bcYCldaAFLfvfQnHzQ=;
        b=DwaAWEc4Q6Uca77i1pa2FzsHjwr9/FjCJvqewvhgiKAby+uKugn8R/1vtl381tQ9TD
         zD6mjWM7EDPmBy87dl6240otKOcRKK1tPlXJY1ZXkmxjjFZBhIk06BhMdPmByoKvaPqg
         Y3mtrBAYzvH3br9rxFH3OmFeiQ//k8GQ/IFamrv3tamOfxhY+RJQzGqYHx+AToApOs17
         mwY54HJmk5kv5ObixIBouxDiRRWFFhhXyumRy56FpmsZ18OAF6ob0pvtdJsHllSVets1
         NRS7JS7nUCA04dXRUjgz0WM4Mcm0r3xQY8IQnLSI9OoH+2FoLlk6ZZDuNurkvBpCGMUJ
         l9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbcBzYCDzjM/TKXUy4gd/mf09bcYCldaAFLfvfQnHzQ=;
        b=cluepT3ZAVK36QsmYZSw8tfPvOqohrQjlhJ4DSM0MQCB50zFMoXp7ButbY8Oup0cVo
         o5jhOLvgxQty2leYBHYg+oCfhHtEsZ8cNxPHCDUMftyeGy+z91vYM11MxCE5pOHJa/UI
         V4j1eeKjT+LeKlzzoYI7UPikAzNvUkXRAtkXoDEpa4iw+lTwnkzTenYOZNGdlfMK2b5o
         tv3heu7Ed0sG/Ab4AbJPzgHLQeubMMwGZX04TVKdDgsjGn4lnGsJRJtBZkBQkTq8JTXl
         PTsOrUttY+TDUU9T0IIqAKfdEGhGEaSUUI2HzmXDP+tM6SlqfFHDnbkapRsfz9lAUqve
         BMIw==
X-Gm-Message-State: AOAM530eCHU8USaE3x9YUUjPXzQx5IHClHGNsdtkmU8CdjXTJJin0EcU
        2aeTB7vI0HBbmR38YKJCqns=
X-Google-Smtp-Source: ABdhPJyf6PwIBiYKEvn/j5AUOIaUsrJFqOISQa5mzqZHiymrzID1xoPdYD1lL+ot9DwqGtiWx7VCEQ==
X-Received: by 2002:a05:6808:13c5:: with SMTP id d5mr10367796oiw.56.1627911431838;
        Mon, 02 Aug 2021 06:37:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id r5sm1856639oti.5.2021.08.02.06.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:37:11 -0700 (PDT)
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <5be90cf4-f603-c2f2-fd7e-3886854457ba@gmail.com>
 <20210802031924.3256-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f66750af-cbda-6d49-2b39-860c10357e95@gmail.com>
Date:   Mon, 2 Aug 2021 07:37:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802031924.3256-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 9:19 PM, Rocco Yue wrote:
> On Sat, 2021-07-31 at 11:17 -0600, David Ahern wrote:
> On 7/30/21 7:52 PM, Rocco Yue wrote:
>>> In this way, if the MTU values that the device receives from
>>> the network in the PCO IPv4 and the RA IPv6 procedures are
>>> different, the user space process can read ra_mtu to get
>>> the mtu value carried in the RA message without worrying
>>> about the issue of ipv4 being stuck due to the late arrival
>>> of RA message. After comparing the value of ra_mtu and ipv4
>>> mtu, then the device can use the lower MTU value for both
>>> IPv4 and IPv6.
>>
>> you are storing the value and sending to userspace but never using it
>> when sending a message. What's the pointing of processing the MTU in the
>> RA if you are not going to use it to control message size?
> 
> Hi David,
> 
> In the requirement of mobile operator at&t in 2021:
> AT&T <CDR-CDS-116> Prioritize Lower MTU value:
> If the MTU values that the device receives from the network in the PCO
> IPv4 <CDR-CDS-110> and the RA IPv6 <CDR-CDS-112> procedures are different,
> then the device shall use the lower MTU value for both IPv4 and IPv6.
> 
> And in the 3GPP 23.060:
> The PDP PDUs shall be routed and transferred between the MS and the GGSN
> or P-GW as N-PDUs. In order to avoid IP layer fragmentation between the
> MS and the GGSN or P-GW, the link MTU size in the MS should be set to the
> value provided by the network as a part of the IP configuration. This
> applies to both IPv6 and IPv4.
> 
> That means user needs to be able to correctly read the mtu value carried
> in the RA message so that user can correctly compare PCO ipv4 mtu and
> RA ipv6 mtu.
> 

Then userspace should get a link notification when ra_mtu is set so it
does not have to poll.
