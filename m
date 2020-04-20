Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F871B0E8C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgDTOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729341AbgDTOh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:37:59 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B79C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:37:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t14so12433236wrw.12
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1T1z3NA+A36tUztklmP8/ZYI8QmN4V/oKSOXgeTqccE=;
        b=UnmXppBG93wnQks27U/PPDQk2gj2WSKsYuRBODH3pUbc/S0zBENFoNO24yoeNt3aKU
         yfUbL8U68Y6hAFZFLTCZAGeJlhHoSw13PTGR5irI9bNFkUnQWeaO11if2GSSNZNNgiAJ
         cwHEBvzi6yvHh+Mn0UNbwFFNSOnV87QXtWrJinTvvhx4gVv5yhMc0jyM3+1/D98+Ipuw
         Y7yU33pil3omd1/Vcm/IYuhuTrq4xsSqhcbOyYz8pWl6IMtxsy8aaRYCekwYN8zKSSZ9
         DBjrxro595sx+2Ef0cO4sAKXNCEN7h9Zh4KwG+JECOqHiECzcKY5ZUMUxifMRtO//zLo
         QN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1T1z3NA+A36tUztklmP8/ZYI8QmN4V/oKSOXgeTqccE=;
        b=UseBfiCENeD1mz1erIZ6pKlPxOC2gF+9qR0ZB7XjkxhJ1a4kLJw9lZgTSkWLu4X6ii
         WgaCOExiRNjbU0IXrmkwoCKn6uET8xQRbTxBGqC5p7/gjyJ2rKwEau+O6G9dreCw9IYt
         +JCIoKVgU1jaAwXlQJbJT0PaHLSAkXco8kAllQx6dKxqAIvvoP+Pc8GSgWt4nQWUPtkK
         d/M8yvd6sev924lx8PPZqfaZmGOD+TmuZ00zBvCdz5gaDyER8Dy7yps78zVotgGRurFl
         cPBMK/LfjFqp/UHe7wHsv6jmx7IAwJJpSDqwbwF/25Co8hrF5ApADSgcRNKGbr1AGHr0
         Cg0w==
X-Gm-Message-State: AGi0PubqQLvaPs5d+JhGyWb9CuMMFVR9eIKQ3GEZEIINKJE+tHmOeg4Y
        dj2kbqJ1kJuCOsU9Wdb1JMtC4Q==
X-Google-Smtp-Source: APiQypKQVBPffmF4R9ucTVHkDxdQzV7rbV+nMFdGv/rj3+LBeVf0XPJ/CtguxOwRE3W/4PCWJG/RIw==
X-Received: by 2002:adf:e986:: with SMTP id h6mr18835149wrm.256.1587393476521;
        Mon, 20 Apr 2020 07:37:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q8sm1592323wmg.22.2020.04.20.07.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:37:55 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:37:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Correct tc-vlan usage
Message-ID: <20200420143754.GP6581@nanopsycho.orion>
References: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 15, 2020 at 07:59:06PM CEST, olteanv@gmail.com wrote:
>Hi,
>
>I am trying to use tc-vlan to create a set of asymmetric tagging
>rules: push VID X on egress, and pop VID Y on ingress. I am using
>tc-vlan specifically because regular VLAN interfaces are unfit for
>this purpose - the VID that gets pushed by the 8021q driver is the
>same as the one that gets popped.
>The rules look like this:
>
># tc filter show dev eno2 ingress
>filter protocol 802.1Q pref 49150 flower chain 0
>filter protocol 802.1Q pref 49150 flower chain 0 handle 0x1
>  vlan_id 103
>  dst_mac 00:04:9f:63:35:eb
>  not_in_hw
>        action order 1: vlan  pop pipe
>         index 6 ref 1 bind 1
>
>filter protocol 802.1Q pref 49151 flower chain 0
>filter protocol 802.1Q pref 49151 flower chain 0 handle 0x1
>  vlan_id 102
>  dst_mac 00:04:9f:63:35:eb
>  not_in_hw
>        action order 1: vlan  pop pipe
>         index 5 ref 1 bind 1
>
>filter protocol 802.1Q pref 49152 flower chain 0
>filter protocol 802.1Q pref 49152 flower chain 0 handle 0x1
>  vlan_id 101
>  dst_mac 00:04:9f:63:35:eb
>  not_in_hw
>        action order 1: vlan  pop pipe
>         index 4 ref 1 bind 1
>
># tc filter show dev eno2 egress
>filter protocol all pref 49150 flower chain 0
>filter protocol all pref 49150 flower chain 0 handle 0x1
>  dst_mac 00:04:9f:63:35:ec
>  not_in_hw
>        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>         index 3 ref 1 bind 1
>
>filter protocol all pref 49151 flower chain 0
>filter protocol all pref 49151 flower chain 0 handle 0x1
>  dst_mac 00:04:9f:63:35:eb
>  not_in_hw
>        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>         index 2 ref 1 bind 1
>
>filter protocol all pref 49152 flower chain 0
>filter protocol all pref 49152 flower chain 0 handle 0x1
>  dst_mac 00:04:9f:63:35:ea
>  not_in_hw
>        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
>         index 1 ref 1 bind 1
>
>My problem is that the VLAN tags are discarded by the network
>interface's RX filter:
>
># ethtool -S eno2
>     SI VLAN nomatch u-cast discards: 1280
>
>and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
>(only the 8021q driver does). This makes me think that I am using the
>tc-vlan driver incorrectly. What step am I missing?

Hmm, that is a good point. Someone should add the vid to the filter. I
believe that "someone" should be the driver in case of flow_offload.



>
>Thanks,
>-Vladimir
