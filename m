Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA62CE034
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgLCUxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgLCUxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:53:52 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66803C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:53:11 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id f24so4046894ljk.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1t9ThwFEeVMqsB1jbcJXlNgFIIDafOfDkm0rxAIWQRo=;
        b=2MdHMYfTzsLdPbLgwDyWeaCq6b0heBa7DROzs+5pTgAtk4sszWD9kiv6CqDyDl2JTJ
         e55UiAX5RmhBez4hixpgWh0MyNkAa9bNDSMRCFiSuBjfyQUB22g1fFJzkn4pyGMNMXwU
         MBx2AGlJYg62rgepwiA31I0ByHc8YJFGLd+r1PXlfeaqmuu7E94mR0eYbjjuMMtBCYFe
         ISB1KyxRMi5kvi1Z2hDC8iDSgiTNnQJCMbRsGleXWZHdTAsZWrvIWcfN8bhfI5f3e4ej
         Bi7OPSWlW4V01Z8WqjR5KXPyqcqwEY3LUPohGyp/Eh97q4o1Q5pcirs6vj6pZHcWnFTz
         hHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1t9ThwFEeVMqsB1jbcJXlNgFIIDafOfDkm0rxAIWQRo=;
        b=bU2KsYuAhvokulBbZ3SvcQWt8KthKlyiDA2TtqmwVLH1xGTKgFYDl7w9ko4gFT+/qu
         VPUFPJKVCLjGGUUvueMfmgl49vSNSzMuTlh/afN0NdhKeFxX1mgTSp7ZQMlvUkPhQzBb
         nZDIs8/U5Sk/Dnci8IZ6E1IN3cKwG/brQPMs8kzKqO59AC/yoJdvlTfaWdSjEFCa6svj
         yR4mxE8mjvwwpVobELiJZ+LanQwHdAwtzh/YpwJ1NR0QXxH07Q27meKu777LNcq3WCjF
         Bapwk4QY7LZ3+33b2bvyZcXl1KngK1UZx7mKCO6y4/TlTg9b+6WJOYH9ln12mCeDtjUE
         hSbw==
X-Gm-Message-State: AOAM5300tFQLbUFCEs95NBVpcwbrfnHXHM7B5u+oYGV0maXacqOpFPyK
        Mj1ktV1IRXMZbyF2ZFoYWQZ42rpjB4m8v3c9
X-Google-Smtp-Source: ABdhPJytYhRPldW/M+O97RVS+e1SqvpA761VAHDxfEfLgowrAhgfVGHiOq9iHvWT7zIQWepEHSacgQ==
X-Received: by 2002:a2e:808e:: with SMTP id i14mr1863780ljg.276.1607028789607;
        Thu, 03 Dec 2020 12:53:09 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id n22sm906637lfe.130.2020.12.03.12.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:53:09 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201203162428.ffdj7gdyudndphmn@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201203162428.ffdj7gdyudndphmn@skbuf>
Date:   Thu, 03 Dec 2020 21:53:08 +0100
Message-ID: <87a6uu7gsr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 18:24, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
>> +static inline bool dsa_lag_offloading(struct dsa_switch_tree *dst)
>> +{
>> +	return dst->lags.num > 0;
>> +}
>
> You assume that the DSA switch, when it sets a non-zero number of LAGs,
> can offload any type of LAG TX type, when in fact the switch might be
> able to offload just NETDEV_LAG_TX_TYPE_HASH.

Right you are, I had this on my TODO but I most have lost track of
it. Good catch!

> I like the fact that we revert to a software-based implementation for
> features the hardware can't offload. So rejecting other TX types is out
> of the question.

Well if we really want to be precise, we must also ensure that the exact
hash type is supported by the hardware. mv88e6xxx only supports
NETDEV_LAG_HASH_L2 for example. There is a needle to thread here I
think. Story time ('tis the season after all):

    A user, Linus, has just installed OpenWRT on his gateway. Finally,
    he can unlock the full potential of his 802.11 AP by setting up a
    LAG to it.

    He carefully studies teamd.conf(5) and rightfully comes to the
    conclusion that he should set up the tx_hash to include the full
    monty of available keys. Teamd gets nothing but praise from the
    kernel when applying the configuration.

    And yet, Linus is not happy - the throughput between his NAS and his
    smart TV is now lower than before. It is enough for Linus to start
    working on his OS. It won't be big and professional like Linux of
    course, but it will at least get this bit right.

One could argue that if Linus had received an error instead, adapted his
teamd config and tried again, he would be a happier user and we might
not have to compete with his OS.

I am not sure which way is the correct one, but I do not think that it
necessarily _always_ correct to silently fallback to a non-offloaded
mode.

> However we still have to prevent hardware bridging.

The idea behind checking for dsa_lag_offloading in
dsa_slave_lag_changeupper was exactly this. If the LAG itself is not
offloaded, we should never call dsa_port_bridge_join on the lowers.

> Should we add an array of supported TX types that the switch port can
> offload, and that should be checked by DSA in dsa_lag_offloading?

That would work. We could also create a new DSA op that we would call
for each chip from PRECHANGEUPPER to verify that it is supported. One
advantage with this approach is that we can just pass along the `struct
netdev_lag_upper_info` so drivers always have access to all information,
in the event that new fields are added to it for example.
