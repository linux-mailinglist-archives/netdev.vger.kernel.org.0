Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1B1A4728
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgDJOEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 10:04:24 -0400
Received: from forward104o.mail.yandex.net ([37.140.190.179]:47434 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbgDJOEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 10:04:23 -0400
Received: from mxback9j.mail.yandex.net (mxback9j.mail.yandex.net [IPv6:2a02:6b8:0:1619::112])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id D57029415AD
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 17:04:21 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by mxback9j.mail.yandex.net (mxback/Yandex) with ESMTP id Bc2Fl3VF7s-4LQWkPQi;
        Fri, 10 Apr 2020 17:04:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586527461;
        bh=FpLFaitKudZtRyxEvaOWme6ozKu1G8+oKBnv1E0Lh1w=;
        h=Subject:From:To:Date:Message-ID;
        b=MoZSGNi1zj8zksvsbVFZ5anWIb7vSKAlWS2aw3dgGTOrAjcGorWjmSSwAkXj9DBE6
         HbVM8Z2hqex7Byhl/aBa33GNRS+lWzjGrlVz8BSRYh/mvxCcMEqdY/psJoiC7U9Dp4
         //5OBAX8Y9oH3LEKiL7VDASHzMC1t+Rk/KvV0Abo=
Authentication-Results: mxback9j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id CrjIlOrWRg-4LWW5KBp;
        Fri, 10 Apr 2020 17:04:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     netdev@vger.kernel.org
From:   Konstantin Kharlamov <hi-angel@yandex.ru>
Subject: What's the offload name for iscsi_tcp_recv_skb()?
Message-ID: <78ca0450-2693-2494-9d13-f34635f4ca6e@yandex.ru>
Date:   Fri, 10 Apr 2020 17:04:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I seek to improve IOPS for some usecase. I found a bunch of time being spent in
iscsi_tcp_recv_skb()¹. The function accepts `offloaded` argument, which basically
allows to skip much of the function.

The only place in the kernel where this parameter is used is Chelsio driver². But
we use Mellanox adapters, not Chelsio ones.

So my question is: what is the name of the `offload` capability in `ethtool -k`
output that allows to offload the function? It would be great if it turns out
that we have a hw with such capability, and all we need is to simply wire up
another driver to use that.

I searched all over Chelsio driver, but haven't managed to find what that
property should be called in `ethtool -k`.

P.S.: the references below are supposed to be URL links to the code, but the ML
refuses to accept links "under a suspicion of a spam", so, well, sorry for bad
usability here.

1: commit c0cc271173b2e1c2d8d0ceaef14e4dfa79eefc0d, dir: drivers/scsi/libiscsi_tcp.c:885
2: commit c0cc271173b2e1c2d8d0ceaef14e4dfa79eefc0d, dir: drivers/scsi/cxgbi/libcxgbi.c:1550
