Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8CF2E2051
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgLWSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:15:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39732 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWSPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608747346; x=1640283346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aqMqNfUUrBSBGofkDY2MEj+70emrzEpu+BRSKs82Hro=;
  b=MV/tQOCFmwMUPW93EXB/55DOBBkB8TOQyhdAAtgd/7XavewZ4Lh3Vx3L
   5YhRhk1Bx9YfrxOtiGHRiR1GuraoFNkBu2AOEhYMBN1+ps9SVxcc/eNbO
   laNJVbIDM7BDO1GEIxxisZ1XJAFAVWUROi/mY1doc7W/XSZae+9hcNfLh
   yzvUxRJR1xl1gmtNBXLXz80ONtH9pTHwFie6iEwASQTXFm0vrwy92gQVB
   6hitbkXVrONnBjw/481j5L7uevAq/8JjgRhd+Kb8FE6Ll6wO5fVqKCUDt
   4tjALCc+PFU6znrpK5sLWmp3cmqGoQPA3dTyOUqQqdtGnsL7Sj5aHipAc
   A==;
IronPort-SDR: 7gtpuIo/8p7UWhPzt9mZ166K9XuYHg1MHrYESZN32nOfyPNHPutB6hU+DgpKrvPuO91z7VNgi9
 idcdhYCBdBtcHSrQaUc1BA+dpPvyYXXKFsjBQsw0n22IWAvHJDRH6hTL0NQaCQgtNAQeJoxeFB
 cjxWhkorWw+qp5dYZPPoB6sGGLDtufV42uZOzbFyawYJATJuSvUWHPQH4ZHzxakjFhchr1SENE
 QtuVrB+IK6ZQvtes67PN/C+PjGy0XvbPI5XJASEkS+OyOFg64bJ7tiZMTBRTiRrOtkHFh8Q0jG
 VSI=
X-IronPort-AV: E=Sophos;i="5.78,442,1599548400"; 
   d="scan'208";a="108760320"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2020 11:14:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 11:14:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Dec 2020 11:14:30 -0700
Date:   Wed, 23 Dec 2020 19:14:29 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 0/2] MRP without hardware offload?
Message-ID: <20201223181429.h4q3e37qs5g2sp46@soft-dev3.localdomain>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/23/2020 15:45, Rasmus Villemoes wrote:
> 
> Hi Horatiu and net folks

Hi Rasmus,

> 
> I'm having quite some trouble getting MRP working in a simple setup
> involving three mv88e6250 switches in a ring, with one node set as
> manager and the other two as clients.
> 
> I'm reasonably confident these two patches are necessary and correct
> (though the second one affects quite a bit more than MRP, so comments
> welcome), but they are not sufficient - for example, I'm wondering
> about why there doesn't seem to be any code guarding against sending a
> test packet back out the port it came in.
> 
> I have tried applying a few more patches, but since the end result
> still doesn't seem to result in a working MRP setup, I'm a bit out of
> ideas, and not proposing any of those yet.
> 
> Has anyone managed to set up an MRP ring with no hardware offload
> support? I'm using commit 9030e898a2f232fdb4a3b2ec5e91fa483e31eeaf
> from https://github.com/microchip-ung/mrp.git and kernel v5.10.2.

I was expecting that you still need to do something in the switchdev
callbacks. Because otherwise I expect that the HW will flood these
frames. For a client I was expecting to add a MDB entry and have the
ring ports in this entry. While for a manager you can have also an MDB
where the host joined and could return -EOPNOTSUPP so then the SW will
detect when it stops receiving these frames.

Most of my tests where done when there was not HW offload at all(no
switchdev) or when there was MRP hardware offload.

> 
> Rasmus Villemoes (2):
>   net: mrp: fix definitions of MRP test packets
>   net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP
> 
>  include/uapi/linux/mrp_bridge.h |  4 ++--
>  net/switchdev/switchdev.c       | 23 +++++++++++++----------
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> --
> 2.23.0
> 

-- 
/Horatiu
