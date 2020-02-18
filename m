Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963AB162C52
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBRRQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:16:06 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:42855 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgBRRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:16:05 -0500
Received: by mail-oi1-f173.google.com with SMTP id j132so20843230oih.9
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=y0j7L8KEFVkF2RsaXchTUsplwAcEOEeWnNKXl1YFxto=;
        b=laApKm+avlMC/8SVnUcLbJJ20Ax3Fku0Yapbl1wEMB6uHYYM4mhzfKGi6eAWY9qWed
         PqCODnQJC1LW3DxJDTfozuLVwrwFia5EUryt47672RVeYN8b2b09qdCqEvw7QfI1UE1P
         3Nn2lgEBKa2QHial29ARxAY8y1JPPOg9t5N9FeSLftjny0LPgMpbPg/bmdIfY72Eknzv
         hTAt/K/XpvKR5P/MoF+TzEVqSzHFYR5T+7BbC7+VLtAXv/vq8mWmVap25ays28BNzpWY
         fURdYuqMhctt7ZT38I1fEHGm7wqp+6E+3NcqumFOeLEBpdZPBINK+UDmeQHaZ6A8QyO1
         52nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=y0j7L8KEFVkF2RsaXchTUsplwAcEOEeWnNKXl1YFxto=;
        b=naJIpsSC/zXRkk6TUG5kuGBAJxEeujlt+1q18+Z9pqAfXh/69qAyz4PVHiYXcuBAXo
         w424fKqaGYLOc0EH+llfu3uCpwfKA4ds2Ugp/UzFJutOrt9A/xi3cdZkzELBcri8GvdE
         v/UJd0C2L+ysCfkaLpryNcayAnlaaSO5vx4Ucku9eWt9Y+aDtQvlO6Qvl0huenTPom0X
         gV4YTCP11cPPrMP3ix5wBrAsJ7W0M4RM9hwER/g2pV0Bl0qdEeAiQ5BTmANWc+zEy8yM
         +bdibnVBH4pW3Aa8AUtODdwO3vC3dV9eHIb6JGOZ1dJUpFSXw18XyB8un5qo3GCC3134
         6D0Q==
X-Gm-Message-State: APjAAAVyDTaKC296hykgBT6/RNwtT/oKCFgR4wQO+qqVvYnsCHxg8d1j
        Fet7dOWJgUqBjvc2wxhCzh/m9uoH3GPViD7BoMBF
X-Google-Smtp-Source: APXvYqygcKkEw36CPWvoVyPkz5DBjgNJy5Av1s28tEhhgOHqS9DK+bJC7V9CckgtZSr4LXuouP9BLUHLSyWjYUPUCfk=
X-Received: by 2002:aca:554d:: with SMTP id j74mr1958370oib.92.1582046163976;
 Tue, 18 Feb 2020 09:16:03 -0800 (PST)
MIME-Version: 1.0
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 18 Feb 2020 11:15:52 -0600
Message-ID: <CAFSKS=Mr+V0zFVBZyZu2zoY-yF3VZuOu+if6=P_0pJiaCDwmRA@mail.gmail.com>
Subject: net: dsa: HSR/PRP support
To:     netdev@vger.kernel.org
Cc:     m-karicheri2@ti.com, vinicius.gomes@intel.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd like to add a switch to DSA that has hardware support for HSR (IEC
62439-3 Clause 5) and PRP (IEC 62439-3 Clause 4).

As well as many common switch features, it supports:
Self-address filtering
Forwarding of frames with cut-through
Automatic insertion of HSR tag and PRP trailer
Automatic removal of HSR tag and PRP trailer
Automatic duplicate generation for HSR and PRP

I've also seen other switches that support a subset of these features
and require software support for the rest (like insertion and removal
of tag/trailer).

Currently there is software HSR support in net/hsr. I've seen some
past discussions on the list about adding PRP support and adding
support for offloading HSR and PRP to a switch.

Is anyone still working on any of this? If not, has anyone made
progress on any of this they'd like to share as a starting point for
getting some of this upstreamed? Has anyone run across any problems
along the way they'd like to share. I've read that the TI vendor
kernel may have support for some of these features on the CPSW.

Thanks,
George McCollister
