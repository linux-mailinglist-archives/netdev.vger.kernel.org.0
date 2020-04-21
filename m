Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA3F1B30A7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDUTvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUTvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:51:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40362C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:51:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id e26so4709801wmk.5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VqtPMiqMSeJsD6uZLty47wI/9txHVjh/RkgD4cMPJCU=;
        b=bHKHQTzerNpJFwBvX429qRMSs8aFg7CBvlc+eR67oupbRGBnqFetRv7iYH9TySGr1n
         KUl1kkWkFT0lB8LD2OT1tw43CkgQ17u2XmgUSsEbbiUtq+Ork7JUvuir5Dzhw/IlvMbC
         c5ROIWOUj3A87uMaE05sJ3PqtA5gP+8poja2j2H8eVJKBoL9NUl49oKJi9Tqy2EIr6f0
         xLWi2kNEmFTFNftjiWmcWG2A0RWR31y3xUPlhugXI2H/6dmpfeoGzToj14ZHDVL/FqK2
         J09SBzQVMBlp+Al+wuMs/iRHY0R8V0mkvK+Qbx6FFHxpL2i2YK0EUgAumirtJSI20Ilm
         GyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VqtPMiqMSeJsD6uZLty47wI/9txHVjh/RkgD4cMPJCU=;
        b=rwUD0elYgYFq3pVU204L7x3m3l1IDxtr7JS0JSZHY5vKASG1ry4cKpsCYMbIklmxHQ
         1RnlErMuDyDpK9+6T8CEL2TeMtzidzkRYmGuxNQLE/tTkxdJLaR9TwneB6eR8OV14ZMZ
         /H0slVGTtt7WUOWHg6SoTmgvOjhQQu97wGwsgoInHAYEuHcZakDLQ7rS5LvZAAaUMo1W
         RL42hozw7mRuKDK9hXRPC7VQL3NRl7OxMLernKDoBFakilJCY2VbteivMbX6TBXGKzgH
         Mffjhr4J43+rnyQf/2R+hHd4nTjYgsyJ3rMyMHNAHHmhkPW3Uht9Q6Qq+Vgsg4Ek0rUG
         FXdg==
X-Gm-Message-State: AGi0PubV8G0azWm8bibomXpX27+0cP05fIxtEKxCkjlzD3GSIsyr5UDa
        fz7E0uKwwfdruQDJng9r+m8c9FMuooE=
X-Google-Smtp-Source: APiQypJwIxmkTMapABGkmbBBt5kyR8TnDySAYoTWh/QrMX8gG/04z7412eKz5zg+nZU9PTnWGBCbUA==
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr6521962wmg.177.1587498708740;
        Tue, 21 Apr 2020 12:51:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a20sm5320281wra.26.2020.04.21.12.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 12:51:48 -0700 (PDT)
Date:   Tue, 21 Apr 2020 21:51:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Correct tc-vlan usage
Message-ID: <20200421195147.GI6581@nanopsycho.orion>
References: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
 <20200420143754.GP6581@nanopsycho.orion>
 <CA+h21hokTEtLAv9r-KJLTH2YgjjC53nEUML3m_XkU=yondY-gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hokTEtLAv9r-KJLTH2YgjjC53nEUML3m_XkU=yondY-gQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 21, 2020 at 08:26:42PM CEST, olteanv@gmail.com wrote:
>Hi Jiri,
>
>On Mon, 20 Apr 2020 at 17:37, Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Wed, Apr 15, 2020 at 07:59:06PM CEST, olteanv@gmail.com wrote:
>> >Hi,
>> >
>> >I am trying to use tc-vlan to create a set of asymmetric tagging
>> >rules: push VID X on egress, and pop VID Y on ingress. I am using
>> >tc-vlan specifically because regular VLAN interfaces are unfit for
>> >this purpose - the VID that gets pushed by the 8021q driver is the
>> >same as the one that gets popped.
>> >The rules look like this:
>> >
>> ># tc filter show dev eno2 ingress
>> >filter protocol 802.1Q pref 49150 flower chain 0
>> >filter protocol 802.1Q pref 49150 flower chain 0 handle 0x1
>> >  vlan_id 103
>> >  dst_mac 00:04:9f:63:35:eb
>> >  not_in_hw
>> >        action order 1: vlan  pop pipe
>> >         index 6 ref 1 bind 1
>> >
>> >filter protocol 802.1Q pref 49151 flower chain 0
>> >filter protocol 802.1Q pref 49151 flower chain 0 handle 0x1
>> >  vlan_id 102
>> >  dst_mac 00:04:9f:63:35:eb
>> >  not_in_hw
>> >        action order 1: vlan  pop pipe
>> >         index 5 ref 1 bind 1
>> >
>> >filter protocol 802.1Q pref 49152 flower chain 0
>> >filter protocol 802.1Q pref 49152 flower chain 0 handle 0x1
>> >  vlan_id 101
>> >  dst_mac 00:04:9f:63:35:eb
>> >  not_in_hw
>> >        action order 1: vlan  pop pipe
>> >         index 4 ref 1 bind 1
>> >
>> ># tc filter show dev eno2 egress
>> >filter protocol all pref 49150 flower chain 0
>> >filter protocol all pref 49150 flower chain 0 handle 0x1
>> >  dst_mac 00:04:9f:63:35:ec
>> >  not_in_hw
>> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>> >         index 3 ref 1 bind 1
>> >
>> >filter protocol all pref 49151 flower chain 0
>> >filter protocol all pref 49151 flower chain 0 handle 0x1
>> >  dst_mac 00:04:9f:63:35:eb
>> >  not_in_hw
>> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>> >         index 2 ref 1 bind 1
>> >
>> >filter protocol all pref 49152 flower chain 0
>> >filter protocol all pref 49152 flower chain 0 handle 0x1
>> >  dst_mac 00:04:9f:63:35:ea
>> >  not_in_hw
>> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>> >         index 1 ref 1 bind 1
>> >
>> >My problem is that the VLAN tags are discarded by the network
>> >interface's RX filter:
>> >
>> ># ethtool -S eno2
>> >     SI VLAN nomatch u-cast discards: 1280
>> >
>> >and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
>> >(only the 8021q driver does). This makes me think that I am using the
>> >tc-vlan driver incorrectly. What step am I missing?
>>
>> Hmm, that is a good point. Someone should add the vid to the filter. I
>> believe that "someone" should be the driver in case of flow_offload.
>>
>>
>>
>> >
>> >Thanks,
>> >-Vladimir
>
>This is not with flow_offload, this is a simple software filter.
>Somebody needs to add the VLAN of the _key_ to the RX filter of the
>interface.

Hmm, right. So the TC wants to manipulate with VLAN, it would make sense
for it to add the vlan to the filter.


>
>Thanks,
>-Vladimir
