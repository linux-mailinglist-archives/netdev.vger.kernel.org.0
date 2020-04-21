Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E501B2F12
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDUS05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUS04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:26:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B81C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:26:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id rh22so11747174ejb.12
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aaWkw8sSg6NV1DPuAxm4YFnOOJuZuZVc3l4s9Y3c3nY=;
        b=S8qXBtANwPSqVekQomsRyxKvuo1boOAUKm3ydq9dehNAFza48hBzAXAmUqdfw1rNLv
         2cQcZ5fery4H+zLchRZM3OX2l9WkMauSTjZuSJMnm0ftx7k/6VXNZNSWffX3daOxrY19
         ahnDMutgtfxoA9jYnZjnP3v7CTUragzogsGWlmaBBUhkVQtjt7JW/1b9uPjVM3JcsjQC
         ZuWlZiv9NjaedVCyyTO5N47qMaohAyjIus7vSsC7cEbgYigCicN5TNHQCelOMw3sU1hs
         2HzdJ24Pfy1f/B8VJuNXOXs2hOEq4xBy6l/FG0jMksO146KAZoke+kDdYwbeMHNW3GkI
         an0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaWkw8sSg6NV1DPuAxm4YFnOOJuZuZVc3l4s9Y3c3nY=;
        b=ADFyid2mPAPGCtI5FIDOmgwhUQVJdOOihNozA1LgGPOuqZbo+fv3aeb2A07tTJq7ku
         88SqGLkrF1Yb+0sWtxeqep9jkUAeDTTOo7MtmVtldxqqgd0qD7O7owS+n+OsKDsWn6NR
         D54KlZJ6MrOyfk55u5I6iRNd1hMM9zl/O9JIEjnZ5yE+RoNQWWpum0x2To+FlOcPR2Gk
         XAxtT6BbNZ1q1WLItXVdWJjmbQ537F9VJ8Nb5stIL87CbCdddLjsAIJ+oEgu46oB/sV7
         49XLAPGmWNluY5iebAlODtD1syA2AUg/+fGCcfRJj0BJR0DICoTkLpl5hqsoGlzDclxD
         VrdQ==
X-Gm-Message-State: AGi0PubkaX5Y07eB9uT/Z9NhWzv/H0SdHmxFAD2iLiDW6VrwkpOopoSh
        3oYqJyM66oGod/HCTCttsHL6VoNSA1Ea+RCy7lE=
X-Google-Smtp-Source: APiQypJBU7mrlYLmsKFwDelLf0LOgvN+ZxF0vj5tWT+C0jmUo7bq1X6q0m/k2cDdTH5rl8AbTPg0nGXlVUntopYu5Ig=
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr23624864ejb.6.1587493613510;
 Tue, 21 Apr 2020 11:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
 <20200420143754.GP6581@nanopsycho.orion>
In-Reply-To: <20200420143754.GP6581@nanopsycho.orion>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 21 Apr 2020 21:26:42 +0300
Message-ID: <CA+h21hokTEtLAv9r-KJLTH2YgjjC53nEUML3m_XkU=yondY-gQ@mail.gmail.com>
Subject: Re: Correct tc-vlan usage
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, 20 Apr 2020 at 17:37, Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Apr 15, 2020 at 07:59:06PM CEST, olteanv@gmail.com wrote:
> >Hi,
> >
> >I am trying to use tc-vlan to create a set of asymmetric tagging
> >rules: push VID X on egress, and pop VID Y on ingress. I am using
> >tc-vlan specifically because regular VLAN interfaces are unfit for
> >this purpose - the VID that gets pushed by the 8021q driver is the
> >same as the one that gets popped.
> >The rules look like this:
> >
> ># tc filter show dev eno2 ingress
> >filter protocol 802.1Q pref 49150 flower chain 0
> >filter protocol 802.1Q pref 49150 flower chain 0 handle 0x1
> >  vlan_id 103
> >  dst_mac 00:04:9f:63:35:eb
> >  not_in_hw
> >        action order 1: vlan  pop pipe
> >         index 6 ref 1 bind 1
> >
> >filter protocol 802.1Q pref 49151 flower chain 0
> >filter protocol 802.1Q pref 49151 flower chain 0 handle 0x1
> >  vlan_id 102
> >  dst_mac 00:04:9f:63:35:eb
> >  not_in_hw
> >        action order 1: vlan  pop pipe
> >         index 5 ref 1 bind 1
> >
> >filter protocol 802.1Q pref 49152 flower chain 0
> >filter protocol 802.1Q pref 49152 flower chain 0 handle 0x1
> >  vlan_id 101
> >  dst_mac 00:04:9f:63:35:eb
> >  not_in_hw
> >        action order 1: vlan  pop pipe
> >         index 4 ref 1 bind 1
> >
> ># tc filter show dev eno2 egress
> >filter protocol all pref 49150 flower chain 0
> >filter protocol all pref 49150 flower chain 0 handle 0x1
> >  dst_mac 00:04:9f:63:35:ec
> >  not_in_hw
> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
> >         index 3 ref 1 bind 1
> >
> >filter protocol all pref 49151 flower chain 0
> >filter protocol all pref 49151 flower chain 0 handle 0x1
> >  dst_mac 00:04:9f:63:35:eb
> >  not_in_hw
> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
> >         index 2 ref 1 bind 1
> >
> >filter protocol all pref 49152 flower chain 0
> >filter protocol all pref 49152 flower chain 0 handle 0x1
> >  dst_mac 00:04:9f:63:35:ea
> >  not_in_hw
> >        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
> >         index 1 ref 1 bind 1
> >
> >My problem is that the VLAN tags are discarded by the network
> >interface's RX filter:
> >
> ># ethtool -S eno2
> >     SI VLAN nomatch u-cast discards: 1280
> >
> >and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
> >(only the 8021q driver does). This makes me think that I am using the
> >tc-vlan driver incorrectly. What step am I missing?
>
> Hmm, that is a good point. Someone should add the vid to the filter. I
> believe that "someone" should be the driver in case of flow_offload.
>
>
>
> >
> >Thanks,
> >-Vladimir

This is not with flow_offload, this is a simple software filter.
Somebody needs to add the VLAN of the _key_ to the RX filter of the
interface.

Thanks,
-Vladimir
