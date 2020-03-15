Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D46E186002
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 22:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgCOV2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 17:28:04 -0400
Received: from correo.us.es ([193.147.175.20]:38636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbgCOV2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 17:28:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B03EC39E2
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 22:27:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C07FDA736
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 22:27:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3164DDA3C2; Sun, 15 Mar 2020 22:27:36 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 730BADA736;
        Sun, 15 Mar 2020 22:27:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Mar 2020 22:27:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 54D444251481;
        Sun, 15 Mar 2020 22:27:34 +0100 (CET)
Date:   Sun, 15 Mar 2020 22:28:00 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/4] netfilter: flowtable: add indr-block
 offload
Message-ID: <20200315212800.j45jg3s4gbpiql53@salvia>
References: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
 <20200303215300.qzo4ankxq5ktaba4@salvia>
 <83bfbc34-6a3e-1f31-4546-1511c5dcddf5@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83bfbc34-6a3e-1f31-4546-1511c5dcddf5@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 08:54:25PM +0800, wenxu wrote:
> 
> 在 2020/3/4 5:53, Pablo Neira Ayuso 写道:
[...]
> The indirect block infrastructure is designed by the driver guys. The callbacks
> is used for building and finishing relationship between the tunnel device and
> the hardware devices. Such as the tunnel device come in and go away and the hardware
> device come in and go away. The relationship between the tunnel device and the
> hardware devices is so subtle.

I understand that this mechanism provides a way for the driver to
subscribe to tunnel devices that might be offloaded.

> > Probably not a requirement in your case, but the same net_device might
> > be used in several flowtables. Your patch is flawed there and I don't
> > see an easy way to fix this.
> 
> The same tunnel device can only be added to one offloaded flowtables.

This is a limitation that needs to be removed. There are requirements
to allow to make the same tunnel device be part of another flowtable.

> The tunnel device can build the relationship with the hardware
> devices one time in the dirver. This is protected by
> flow_block_cb_is_busy and xxx_indr_block_cb_priv in driver.
>
> > I know there is no way to use ->ndo_setup_tc for tunnel devices, but
> > you could have just make it work making it look consistent to the
> > ->ndo_setup_tc logic.
> 
> I think the difficulty is how to find the hardware device for tunnel
> device to set the rule to the hardware.

Right, this is the problem that the infrastructure is solving,
however, it's a bit of a twisty way to address the problem.

> > I'm inclined to apply this patch though, in the hope that this all can
> > be revisited later to get it in line with the ->ndo_setup_tc approach.
> > However, probably I'm hoping for too much.

I have applied this patchset to nf-next.

Probably, there might be a chance to revisit this indirect block
infrastructure.

Thank you.
