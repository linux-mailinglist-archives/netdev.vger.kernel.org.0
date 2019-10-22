Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9DBE0CB5
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfJVTlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:41:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46955 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVTlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:41:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so18432018ljl.13
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 12:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IsSJ5eVHCLYF53VNonxhHNCQH5QFu6jimMBy8vLyOog=;
        b=v2Z48XpBFwFxbMTkDf5egKRLy0tlp5zDEydT5/ivTps8yEnycEIoL8jhDGVwWfGvuI
         ppvyGHZ+DubsGU6a4x8vJX5X5CMUORUc+1cW5DRzs+Ke+Y9l+dXtC010OxB0Xg++o1pp
         gqb2Vad2XVp7sY546Rfu+2Jo6osuGA9tiwrBDaMHXX9G4V+v9cslCip/jMjYnA/9QZp9
         5Sq+yRvUN3ooc4mwRKWhsMXBSDeK7rIbpKt7xZtBfPdxFCCVh29BXIwQIX1sI3Q0+HAh
         e7yIyte7XiodG0qau49JmLor0pn10VNoV/udV5S8PuvxYA6HzhO+kGoogMs2EurO/DOk
         XOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IsSJ5eVHCLYF53VNonxhHNCQH5QFu6jimMBy8vLyOog=;
        b=CI9k2BbHAbQF8HEs37NPu+5Q9bkwqH9MlEJW7k14OFm7OGEvdOoDDmENiKoIGxP9W6
         ZWQyiuADVKkyYb+WeBlU2eK8eFKbpNT2Mor4R9ydYR372v3GPbgxPpcGwMu0C0LDBzzB
         VgLvJXPHT+yVvQ3El9li7mrvtjVbFGHgkGPR45NjhtNxc8XjvBefiDMvSEMd3ufjhjbt
         00+VHbttaJ0xnqMXyaTV7+Zoz4bDx6JbjeeQiR430Rv5SSYWaYA78U1aFML+0UThqcdN
         aplXA83ZOCJyFdt2asfsE2mu2Q0TduRfp9dLxof63TXCB+u6AIsRE8U/s1ZEjxzonIe0
         ULSQ==
X-Gm-Message-State: APjAAAXYsRhbJRfiDSfk9lfNDj6e8Z2PDr7u3kzjuibyOViIO+eM7Su9
        72nlkvYldczXKP4ZD0zrqnGBHw==
X-Google-Smtp-Source: APXvYqxMFv7GkiMNTgA/JKRIE2HHriZcON5ChaFS8ph0JapaLSggHpKAx0YiA0yGbLKB+T6OFe3KJQ==
X-Received: by 2002:a2e:8118:: with SMTP id d24mr2950056ljg.111.1571773313303;
        Tue, 22 Oct 2019 12:41:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l24sm1168910lfc.53.2019.10.22.12.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:41:53 -0700 (PDT)
Date:   Tue, 22 Oct 2019 12:41:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/16] net: dsa: turn arrays of ports into a
 list
Message-ID: <20191022124146.25c1fdbc@cakuba.netronome.com>
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 16:51:14 -0400, Vivien Didelot wrote:
> The dsa_switch structure represents the physical switch device itself,
> and is allocated by the driver. The dsa_switch_tree and dsa_port structures
> represent the logical switch fabric (eventually composed of multiple switch
> devices) and its ports, and are allocated by the DSA core.
> 
> This branch lists the logical ports directly in the fabric which simplifies
> the iteration over all ports when assigning the default CPU port or configuring
> the D in DSA in drivers like mv88e6xxx.
> 
> This also removes the unique dst->cpu_dp pointer and is a first step towards
> supporting multiple CPU ports and dropping the DSA_MAX_PORTS limitation.
> 
> Because the dsa_port structures are not tight to the dsa_switch structure
> anymore, we do not need to provide an helper for the drivers to allocate a
> switch structure. Like in many other subsystems, drivers can now embed their
> dsa_switch structure as they wish into their private structure. This will
> be particularly interesting for the Broadcom drivers which were currently
> limited by the dynamically allocated array of DSA ports.
> 
> The series implements the list of dsa_port structures, makes use of it,
> then drops dst->cpu_dp and the dsa_switch_alloc helper.

Applied, thanks!
