Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF077E46D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHAUnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:43:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHAUnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:43:51 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D0C915408812;
        Thu,  1 Aug 2019 13:43:48 -0700 (PDT)
Date:   Thu, 01 Aug 2019 16:43:45 -0400 (EDT)
Message-Id: <20190801.164345.1007767435484564146.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     linux-kernel@vger.kernel.org, rasmus.villemoes@prevas.dk,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: dsa: mv88e6xxx: avoid some redundant
 VTU operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801183637.24841-1-vivien.didelot@gmail.com>
References: <20190801183637.24841-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 13:43:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Thu,  1 Aug 2019 14:36:32 -0400

> The mv88e6xxx driver currently uses a mv88e6xxx_vtu_get wrapper to get a
> single entry and uses a boolean to eventually initialize a fresh one.
> 
> However the fresh entry is only needed in one place and mv88e6xxx_vtu_getnext
> is simple enough to call it directly. Doing so makes the code easier to read,
> especially for the return code expected by switchdev to honor software VLANs.
> 
> In addition to not loading the VTU again when an entry is already correctly
> programmed, this also allows to avoid programming the broadcast entries
> again when updating a port's membership, from e.g. tagged to untagged.
> 
> This patch series removes the mv88e6xxx_vtu_get wrapper in favor of direct
> calls to mv88e6xxx_vtu_getnext, and also renames the _mv88e6xxx_port_vlan_add
> and _mv88e6xxx_port_vlan_del helpers using an old underscore prefix convention.
> 
> In case the port's membership is already correctly programmed in hardware,
> the following debug message may be printed:
> 
>     [  745.989884] mv88e6085 2188000.ethernet-1:00: p4: already a member of VLAN 42

Series applied, thanks Vivien.
