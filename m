Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FB09F8A6
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfH1DRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:17:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfH1DRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:17:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71AAA153B8312;
        Tue, 27 Aug 2019 20:17:54 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:17:53 -0700 (PDT)
Message-Id: <20190827.201753.619474113830630076.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/6] net: dsa: explicit programmation of
 VLAN on CPU ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hqPTqzCPPYqF1zvbGhu=yeqPFQ_X77xtfmt1mzENDQ9Dw@mail.gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
        <CA+h21hqPTqzCPPYqF1zvbGhu=yeqPFQ_X77xtfmt1mzENDQ9Dw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:17:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 25 Aug 2019 21:27:23 +0300

> On Sun, 25 Aug 2019 at 20:25, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>>
>> When a VLAN is programmed on a user port, every switch of the fabric also
>> program the CPU ports and the DSA links as part of the VLAN. To do that,
>> DSA makes use of bitmaps to prepare all members of a VLAN.
>>
>> While this is expected for DSA links which are used as conduit between
>> interconnected switches, only the dedicated CPU port of the slave must be
>> programmed, not all CPU ports of the fabric. This may also cause problems in
>> other corners of DSA such as the tag_8021q.c driver, which needs to program
>> its ports manually, CPU port included.
>>
>> We need the dsa_port_vlan_{add,del} functions and its dsa_port_vid_{add,del}
>> variants to simply trigger the VLAN programmation without any logic in them,
>> but they may currently skip the operation based on the bridge device state.
>>
>> This patchset gets rid of the bitmap operations, and moves the bridge device
>> check as well as the explicit programmation of CPU ports where they belong,
>> in the slave code.
>>
>> While at it, clear the VLAN flags before programming a CPU port, as it
>> doesn't make sense to forward the PVID flag for example for such ports.
>>
>> Changes in v2: only clear the PVID flag.
 ...
> For the whole series:
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> Thanks!

Series applied.
