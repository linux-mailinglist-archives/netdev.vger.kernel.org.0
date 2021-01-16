Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26402F89CE
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbhAPAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbhAPAM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:12:57 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A884C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 16:12:17 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x20so15689638lfe.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 16:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=CCUJ5QE4T4f0+Osi2p8KjRJRbZIPwZLEhNlD7eGOcfE=;
        b=bRFk/mgcPj1oSFS5130q/hQclQDajy0NW0/6fUCpyyuD1R8M5ibR6FiZZOHjajkoI8
         UTItksnSg8E9qpaQvz6iQRaPcKuS3B7UyCwXN35yUiTmQqzDR2QAJuEl/hfFL26hKwME
         SZpkFi7GDLYi3k21oGDMlC+MCsbIDgaMnKnYY4l7R6EaZIY75jkIrrv2dMOe6UTlzIUe
         Xja5DCSNEJqHIAabfhI/883X5XCAwYheFjNwwEEyFmHV3oSHpbkHjERxI/uDU8w3qCf3
         xjjqDxvolyrAa6z7bSLXrMNCsDu6I9PP+l05XlHF1EqokX+w0/VgGH6kUM1draXoSfDz
         5Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CCUJ5QE4T4f0+Osi2p8KjRJRbZIPwZLEhNlD7eGOcfE=;
        b=aHxpYzhNGi1SOucHFIW5rAKXC3fMLWEC0eCxXHFueqjBvL4HLJG+oy0A9lcRcttdS/
         MwQfMHnKiqwoPvCgBNpqHMp6GYyp4xvQwo0sR04hxslW1ZJNR19yZE6NJNP3Ngdoc+0u
         dJ3VDcmbHf7EvHuxUIQcr8K7QBB9Ah76bBGG0ITO7Q1aXJWitsaiP12KUZmUhObdgM6R
         w0stG0i8G/AlUg5BgPCUH29D6q+31fMs0fOPxC9XF603rq08QNhmelgRsnFSxr/0QrzA
         UaFw58qhxJf+Bw69w311meckbWNA77EraXjY15t2GPWXtmUkFgj+f75xfPPrfIkM7oQt
         Ia8A==
X-Gm-Message-State: AOAM533faIp4oxTS51HP25w66EOiNEzGODK5okwzYUqKxMimO7pR0C++
        mMTCJdhhDczejOBY5epjG7n5SZMiqoaVLw==
X-Google-Smtp-Source: ABdhPJz/+QLWDiKbepN9LUMs5aUfiKIx1MYsJz4c2HOw1BsfEQ08dufN8iqaEtCocM6QGlvgmDDL9w==
X-Received: by 2002:ac2:43d6:: with SMTP id u22mr6161926lfl.596.1610755934828;
        Fri, 15 Jan 2021 16:12:14 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id z9sm1072797lfb.287.2021.01.15.16.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 16:12:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
In-Reply-To: <20210115154622.1db7557d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210115125259.22542-1-tobias@waldekranz.com> <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20210115232435.gqeify2w35ddvsyi@skbuf> <20210115154622.1db7557d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 16 Jan 2021 01:12:13 +0100
Message-ID: <87im7xloyq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 15:46, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 16 Jan 2021 01:24:35 +0200 Vladimir Oltean wrote:
>> On Fri, Jan 15, 2021 at 03:02:46PM -0800, Jakub Kicinski wrote:
>> > On Fri, 15 Jan 2021 13:52:57 +0100 Tobias Waldekranz wrote:  
>> > > The kernel test robot kindly pointed out that Global 2 support in
>> > > mv88e6xxx is optional.
>> > > 
>> > > This also made me realize that we should verify that the hardware
>> > > actually supports LAG offloading before trying to configure it.
>> > > 
>> > > v1 -> v2:
>> > > - Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
>> > > - Simplify _has_lag predicate (Vladimir).  
>> > 
>> > If I'm reading the discussion on v1 right there will be a v3,
>> > LMK if I got it wrong.  
>> 
>> I don't think a v3 was supposed to be coming, what made you think that?
>
> I thought you concluded that the entire CONFIG_NET_DSA_MV88E6XXX_GLOBAL2
> should go, you said:
>
>> So, roughly, you save 10%/13k. That hardly justifies the complexity IMO.

Well, based on what Andrew said, my guess is that that is where we will
end up.

But since at the moment net-next does not build for configs without
Global2-support, I would really appreciate it if this series could be
applied to solve that immediate problem.
