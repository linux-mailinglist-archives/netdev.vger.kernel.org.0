Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D041C8012
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEGCg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEGCg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 22:36:57 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD63C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 19:36:55 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ep1so1954304qvb.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 19:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hBTX1Kw4e7pCX61DzGblsqafMSRu5V4GhP7YGTeEj+c=;
        b=E4gKuTVS6sm0fEczdnyPr7kQ7FMS2SanCD3VqrjCxcN7Wckp7Mo+NH5GsHzaepCpfD
         wyKm/7FC8wHLG58ac+gLCSOPNMVhN88+uMTmz7nwK5Px9+VGbpJ5YKGA861Dl4TtEgx9
         Jihm19T+lCmAOhLUQLHOgiJuonf/2+rM6NGyNNZ45muW+jKy6ZlxX0ELiqm+kVcfAw+5
         JjLBavAhKJXftRBqzKxGwBh57AhDJsZ2PrbXbu4WgYy1EaB4CkNT5+AONtwtiXL2l9Zp
         coKeMa31fQOjSooBd5pHGc6Sc8gNsD5pYmhOROReif0WSMqKO1d760Nx0Cu8vpp6ddX+
         +Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBTX1Kw4e7pCX61DzGblsqafMSRu5V4GhP7YGTeEj+c=;
        b=f29fffwzr/U/8WE+BHaWgcm1aX5Ti0oC60VEDjuosTFlBK4dP7wNphdGnyr85FsIPN
         BEpIuxRRvmCOyPT9WL83/ya1Zk9qk+tFHng0GaBK4lto7Mio77tyREJ+1u3bw0Dj5uta
         HEMsYzJk+uTLUor4dSc+S6ewMqEzowZ1RmO4umT6f5jCRpSMewc33RIY9yFuezkd4MVU
         +xwA3DJXF4cSzoKmPOglcbUZ4ii6AJlWkI9pt1JHrErO1xoY5g+npCsR2X247Uq5crPt
         ZBSzeQ9xOcm+DymGZJOhc5emIrzoGbmC5xtj5F6OJ/8c5ZhcRz10p60pQDstRT0pKVyH
         aQPw==
X-Gm-Message-State: AGi0PuY3ivfkGoVEWq41wxEgb5wrdWZkb7cjvRQaZYaYMZfP9uk4qahF
        nAeN5PS/xawzvnNjNus27odzx7yw
X-Google-Smtp-Source: APiQypJ6F92PQT0EzgLlmCVCFjIb62zc1D65UEgFhf3+9eNS7IQCyYg2mN1UKUBXC6KMuGMmoCSZ+Q==
X-Received: by 2002:a0c:f2d3:: with SMTP id c19mr11202232qvm.109.1588819014890;
        Wed, 06 May 2020 19:36:54 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f49b:d833:83ee:104e? ([2601:282:803:7700:f49b:d833:83ee:104e])
        by smtp.googlemail.com with ESMTPSA id 23sm3235683qkk.11.2020.05.06.19.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 19:36:53 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip link: Do not call ll_name_to_index when
 creating a new link
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20180517222237.72388-1-dsahern@kernel.org>
 <20180517153604.0d905a36@xeon-e3>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <983f2ee8-2a42-28ff-7d42-1b5a58803780@gmail.com>
Date:   Thu, 17 May 2018 16:47:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20180517153604.0d905a36@xeon-e3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/18 4:36 PM, Stephen Hemminger wrote:
> On Thu, 17 May 2018 16:22:37 -0600
> dsahern@kernel.org wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> Using iproute2 to create a bridge and add 4094 vlans to it can take from
>> 2 to 3 *minutes*. The reason is the extraneous call to ll_name_to_index.
>> ll_name_to_index results in an ioctl(SIOCGIFINDEX) call which in turn
>> invokes dev_load. If the index does not exist, which it won't when
>> creating a new link, dev_load calls modprobe twice -- once for
>> netdev-NAME and again for NAME. This is unnecessary overhead for each
>> link create.
>>
>> When ip link is invoked for a new device, there is no reason to
>> call ll_name_to_index for the new device. With this patch, creating
>> a bridge and adding 4094 vlans takes less than 3 *seconds*.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
> 
> Yes this looks like a real problem.
> Isn't the cache supposed to reduce this?
> 
> Don't like to make lots of special case flags.
> 

The device does not exist, so it won't be in any cache. ll_name_to_index
already checks it though before calling if_nametoindex.
