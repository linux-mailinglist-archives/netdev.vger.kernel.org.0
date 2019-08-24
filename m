Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239069BE9F
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfHXPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:41:01 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46156 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfHXPlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 11:41:01 -0400
Received: by mail-ed1-f65.google.com with SMTP id z51so18722212edz.13
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YNazRPH3AOj3Ngf9n0bxDv+A9uY1pRa+sQnOeqrJiWQ=;
        b=KjGwSyULtCZ/7PARK3l/GHAed8fUe7jxO0pUVTKOddj+3TlYI39cxzJ4GwrkTn40Mo
         MRSx72m6w4UfDon1RIPn1kL/bxrxv3YPmfCxT6slgo6Oe4KtL7BWGC/ktTVpjFeIfKRT
         RV8wflWQcIWFurx+AotnJm8Fr4eOsZEnX8JRahBGg1gsVKyiyW1uMlUwqBxsvenM0BJ+
         sgEPQgS9IE/p6Bo9VXZhIx8rFsl2az8pdk9Fe30OUGFhka1ZpvVm5E4bmpI0YO/wY9sw
         7dc4WW5C9QTS9otRfq0Ch6RJTiexwqc/HVTrlhkgspuwm9qVS/ws8xRVR44t/AmpM6dm
         1pGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YNazRPH3AOj3Ngf9n0bxDv+A9uY1pRa+sQnOeqrJiWQ=;
        b=ikVsBd91Cyj4HPFaSg6hVHZv9zjN8RI8vCQC6I32NK1oD5DbPciNiBPiVru9WX8RFU
         UrI+jrLLx1t+rZ4hTw1MTkqt9vVhyYn8u5TEBIjnSoRDihl9NlpfYfQtC2l2hr5sP+5u
         LwSQyBgScw88bHHwUwjgdMP7HTVoFeNYKJ8JriMIV8ylzzpBTm4+2WrbXjdRzqG62vTI
         klycIRmHkwVcikRcPWyhgIp2PyVohkRMTpnSpL292kE1JIOYYaYUzMGyoZs0jDuWw9Uv
         zc81iWmdBa8D+RGsptQ4T9wiTHQuoU7ngns9iAjh6uzWFDid0tVszgWHVgMiOxqcF4Pg
         hP+g==
X-Gm-Message-State: APjAAAXQsZoXLcDQTgI0C/Uw3WkeAxwwbvc05UiVgew27WdVCsyhqtFJ
        OUd0aQ+HPSDlyo6WeOmXnodRHuNMF3Cyfe8jg7Otb3yNf78=
X-Google-Smtp-Source: APXvYqzZ3v/2J1+/Y/qhlUgxo6hvwMqbIo6PnJCeeIYsn8L7gMyrP/OeA1xfIPxvSYWFEJDvk6Kn6yDSJa0ZS4TLvKY=
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr10322196edv.36.1566661259366;
 Sat, 24 Aug 2019 08:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190824024251.4542-1-marek.behun@nic.cz>
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 18:40:48 +0300
Message-ID: <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sat, 24 Aug 2019 at 05:43, Marek Beh=C3=BAn <marek.behun@nic.cz> wrote:
>
> Hi,
> this is my attempt to solve the multi-CPU port issue for DSA.
>
> Patch 1 adds code for handling multiple CPU ports in a DSA switch tree.
> If more than one CPU port is found in a tree, the code assigns CPU ports
> to user/DSA ports in a round robin way. So for the simplest case where
> we have one switch with N ports, 2 of them of type CPU connected to eth0
> and eth1, and the other ports labels being lan1, lan2, ..., the code
> assigns them to CPU ports this way:
>   lan1 <-> eth0
>   lan2 <-> eth1
>   lan3 <-> eth0
>   lan4 <-> eth1
>   lan5 <-> eth0
>   ...
>
> Patch 2 adds a new operation to the net device operations structure.
> Currently we use the iflink property of a net device to report to which
> CPU port a given switch port si connected to. The ip link utility from
> iproute2 reports this as "lan1@eth0". We add a new net device operation,
> ndo_set_iflink, which can be used to set this property. We call this
> function from the netlink handlers.
>
> Patch 3 implements this new ndo_set_iflink operation for DSA slave
> device. Thus the userspace can request a change of CPU port of a given
> port.
>
> I am also sending patch for iproute2-next, to add support for setting
> this iflink value.
>
> Marek
>

The topic is interesting.
This changeset leaves the reader wanting to see a driver
implementation of .port_change_cpu_port. (mostly to understand what
your hardware is capable of)
Will DSA assume that all CPU ports are equal in terms of tagging
protocol abilities? There are switches where one of the CPU ports can
do tagging and the other can't.
Is the static assignment between slave and CPU ports going to be the
only use case? What about link aggregation? Flow steering perhaps?
And like Andrew pointed out, how do you handle the receive case? What
happens to flooded frames, will the switch send them to both CPU
interfaces, and get received twice in Linux? How do you prevent that?

> Marek Beh=C3=BAn (3):
>   net: dsa: allow for multiple CPU ports
>   net: add ndo for setting the iflink property
>   net: dsa: implement ndo_set_netlink for chaning port's CPU port
>
>  include/linux/netdevice.h |  5 +++
>  include/net/dsa.h         | 11 ++++-
>  net/core/dev.c            | 15 +++++++
>  net/core/rtnetlink.c      |  7 ++++
>  net/dsa/dsa2.c            | 84 +++++++++++++++++++++++++--------------
>  net/dsa/slave.c           | 35 ++++++++++++++++
>  6 files changed, 126 insertions(+), 31 deletions(-)
>
> --
> 2.21.0
>

Regards,
-Vladimir
