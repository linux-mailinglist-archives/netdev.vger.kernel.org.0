Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63092929E9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgJSPAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgJSPAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:00:09 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4A3C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:00:08 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id l85so194140oih.10
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4zcu9wdriLkFWciMvoezvASbezsxwaR0DyHnp4y5Xyo=;
        b=cifRvuU87Xl7ld9dS9diHrSC3nXRI/k65Pm40JCTXyVmAho3I+aORzKYxApY0wmySN
         ZI1aNcmWQ0pITVjkKtWFhGZEOmut8+C0jUOU6hf8puMjpupQcdeWABlbchYwJORQovAp
         dzHeat9rfKFNZNCqs9uUoqNnQhqNy33RnKc/AgD+xomL1waVV+uH9t7Lsf9Sg5FVsCGt
         QdgJDlbG+Kg2kW0sWzbWu20ZMuC6uHu7hMbOr3WpQj0yLRfQ5FVMKNcFWl1Phgw+kEGm
         TsqdC2Ho9bXNeZ0NdHRRxlpmXdWRKvPrqv5GKuasMhmCb/VoWX9YkaP++ORwi96mwZPj
         DVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4zcu9wdriLkFWciMvoezvASbezsxwaR0DyHnp4y5Xyo=;
        b=eL13yGwUyZ8iK3H06JFFO9BRy5bdn6NQAwuUpnESAiH2XG6Aby2ujWtxIUTCmWsH5n
         puzEctAr9VAHDG9Y3oOFlXuOOg6TzAhfYzo6mN2P6ZuAKheHpN6eIaCCnsw42qnsL6HA
         gtF12E44UsFbTP8LkLNdPON0EF1a+9DXjsqX8kVGikey3LGeIk8NWH2qDzLu9am3t8wm
         CDZ5e6iNrLu/kZ4aCAagsbsHqcbzPr92CC4Io5CwIJ5USfZ0QvUlfI4c9qaE+8mwxyeZ
         vn1R0dele0hzNcU6dkoZUV2wPkOM5+lcI7wEs2/hZV+n2uex4a8ZkwCiFXd/bLIsEiIn
         pyBA==
X-Gm-Message-State: AOAM532Vc/SE1QPqcLEyvSdpH6OI3NX11RWpb5DgsPN/5gvAPu+E1QaC
        u2x197IPoHV/aPYWa1VfYV6Uk0SUAPD+kGWcrp7v6wvd3u8=
X-Google-Smtp-Source: ABdhPJyqjmw00T4cATlGetSUcf/QBprE8FO8zf/jKpF87vu5l8WzN0XyatV2Lmjd/nnjbyareLOIfFoWZ3cwX+bf8C8=
X-Received: by 2002:aca:5596:: with SMTP id j144mr104887oib.41.1603119607637;
 Mon, 19 Oct 2020 08:00:07 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?15zXmdeo158g15DXldeT15nXlg==?= <liranodiz@gmail.com>
Date:   Mon, 19 Oct 2020 17:59:56 +0300
Message-ID: <CAFZsvkmCyRdOePeedok0b6Hn4PR-FPcNjfY7sWBzSBOAW+HRWg@mail.gmail.com>
Subject: GRE Tunnel Over Linux VRF
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, i am trying to create GRE tunnel over vrf.
after binding  the GRE tunnel interface (also the LAN & WAN
interfaces) to VRF, the traffic didn't forwarded via the WAN
interface,  the path is LAN(VRx)----->GRE--x-->WAN(VRx) .
only while the WAN interface is binding to the default router, the
traffic forwarded correctly via the WAN interface, the path is
LAN(VRx)----->GRE----->WAN(VRx).

used configuration:
ifconfig lan1 80.80.80.1/24 up
ifconfig wan2 50.50.50.1/24 up
ip link add VR2 type vrf table 2
ip link set dev VR2 up
ip route add table 2 unreachable default metric 4278198272
ip tunnel add greT2 mode gre local 50.50.50.1 remote 50.50.50.2
ip addr add 55.55.55.1/24 dev greT2
ip link set greT2 up
ip link set dev greT2 master VR2
ip link set dev lan1 master VR2
ip link set dev wan2 master VR2
ip route add vrf VR2 90.90.90.0/24 via 55.55.55.2

what is the correct way to create GRE tunnel over VRF.
Thank for support.

BR, Liran
