Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9A2CA2B5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 13:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgLAMai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 07:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgLAMai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 07:30:38 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1213C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 04:29:57 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id s30so3772558lfc.4
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 04:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Sc7Uc9XQ83b/IqWEkZ8PxPdhAjRmXdS2G/nogbUUZC0=;
        b=EktwFGtxsLqFEuVg7txwjHhRzO/ZQDihlkZHE+/+HDjoBXFzT/cEngY5PBN0KCBsjH
         f7l3YGNGknfhnQF4kHbfeyZEZF1hs4qAXxocIPrYbtRsiuYJeS+acmnPZJ1ejuIBD1Fa
         xKiEwBX7fZUxH0Rxt0gELZ1KNW8fohAfZ/mGizmAn7RBCoe+wkeAk7LGlo4SXjhXxPk0
         mxglis+lVeFOYlHjVDAonDM3hVSsQwkq1nuqCt6pxbvJ6hZxCNwn3Flc0Kaj1h3hvuwg
         tCGfiLs0BbLTNB3B9kYkj25X6NNn2yw87Nn4HarRfoB9/5zSYwGpLZATk7a3ltvYOW23
         srZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Sc7Uc9XQ83b/IqWEkZ8PxPdhAjRmXdS2G/nogbUUZC0=;
        b=UJMqWVYnPevfFeWAMV7geKSBKUhCCmkcvFOGFFK2oLYEo131XC5j6IL1m5TAkO8e34
         6qAX7hZvtxsuIf5FN5YKiyYP2tPPVoafwW/NF3wwuTn1V3pqVSO57BNSenDdkhCgMLlf
         7iWqkpl6Zf6N9NnLS6NWacpXyEpd1WX2Cy3TNObf+BgIhWWRyW4I/LntkvPKfDtjfrC4
         VkgBv76KUV56DtfkRwbRpBPd5WsQF90/IlgC0GGI/xxYPD5XNMT+kRwqm8+1hEzWXzdE
         6DH8SgGoZahtgWXjvLTmf6Imtxsd6CdOpbFUulN5P42kvkzAxu68rtUNeUaAcEi7s4or
         w/Jg==
X-Gm-Message-State: AOAM533wwTis/8hNVEGtgqIpbNBoE1Vi9mkifzhDWT7q5mXKKFc52P5r
        WqClQAFPa6LESMx5J66VT6mwjQPPn1oYM+y2
X-Google-Smtp-Source: ABdhPJztWW/doZU7DV/CIyig6zUcw4qKTJHvMrXu/9W2AKp2UzVwSRc53vKzQH3Hk02kgg3qm/BLTQ==
X-Received: by 2002:a19:2242:: with SMTP id i63mr1033186lfi.451.1606825795999;
        Tue, 01 Dec 2020 04:29:55 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g6sm185335lfb.291.2020.12.01.04.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 04:29:54 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Peter Vollmer <peter.vollmer@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
In-Reply-To: <20201201084916.GA6059@unassigned-hostname.unassigned-domain>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com> <20200930191956.GV3996795@lunn.ch> <20201001062107.GA2592@fido.de.innominate.com> <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com> <87y2in94o7.fsf@waldekranz.com> <20201201084916.GA6059@unassigned-hostname.unassigned-domain>
Date:   Tue, 01 Dec 2020 13:29:54 +0100
Message-ID: <87a6ux90al.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:49, Peter Vollmer <peter.vollmer@gmail.com> wrote:
> On Thu, Nov 26, 2020 at 10:41:44PM +0100, Tobias Waldekranz wrote:
>> On Wed, Nov 25, 2020 at 15:09, Peter Vollmer <peter.vollmer@gmail.com> wrote:
>> > - pinging from client0 (connected to lan0 ) to the bridge IP, the ping
>> > requests (only the requests) are also seen on client1 connected to
>> > lan1
>> 
>> This is the expected behavior of the current implementation I am
>> afraid. It stems from the fact that the CPU responds to the echo request
>> (or to any other request for that matter) with a FROM_CPU. This means
>> that no learning takes place, and the SA of br0 will thus never reach
>> the switch's FDB. So while client0 knows the MAC of br0, the switch
>> (very counter-intuitively) does not.
>> 
>> The result is that the unicast echo request sent by client0 is flooded
>> as unknown unicast by the switch. This way it reaches the CPU but also,
>> as you have discovered, all other ports that allow unknown unicast to
>> egress.
>> 
>
> Thanks for this explanation. Would there be a way to inject the br0 MAC
> into the switch FDB using 'bridge fdb' or some other tool as a
> workaround ?

Unfortunately not. DSA will only attempt to offload FDB entries on user
ports to the ATU at the moment. Vladimir has started work on a series
that would also offload addresses from "foreign" ports:

https://lore.kernel.org/netdev/20201108131953.2462644-1-olteanv@gmail.com/

His work could possibly be extended to include addresses added to the
bridge itself.

> And is this behaviour the same with all other DSA capable
> switches (or at least the mv88e6xxx ones)?  Will this change eventually 

For mv88e6xxx, yes. These devices will never perform learning on
FROM_CPU frames.

> after the implementation is complete ?

I sure hope so. There are multiple ways forward here. Vladimirs approach
with adding dynamically learned addresses as static entries is one way.

I would like to do some work to optimize multicast forwarding
performance that would also, as a side-effect, solve this
problem. Because it would mean that we would start sending FORWARD
frames from the CPU for bridged traffic, and thus the switch would be
able to learn the location of the source address.
