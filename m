Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D665B455337
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhKRDOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 22:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbhKRDOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 22:14:38 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AFFC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 19:11:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id x7so4006748pjn.0
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 19:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=rIUDXKD0e8KbaqffimpOQLEeyGh18ZndTs4TR3BjZr4=;
        b=N5Zr7nfarJptZy6evNUIvzhPFnVXBCSAqeSZe4fqpnz3oCjebsaXB+xv9WnV4PPZdY
         WHVRy9LWkPPN3xiyIfHl5GANorPbqI+G36H4vjbuVsNGbliJOVWnXcB1sjyMEo0b4A8+
         rkaFMeVz8S5R3YEdNfptCmAIqaioEZu2IpfQPaUF/buzx6kTksZ4Ms+FfF6f3fxv+RAY
         eRGS/r7Fa6/jl38IfK6r1BSeLZMvRZD6d5IXcAk7L+HQ1zgrc8CgCaIeKsPSoVt4zYjA
         BPl9auefElzBKa8+zFYwEjSR9AOHf6uMDxdZERrxkCrhNYdgnUa4B/sPA6P82jHMPBau
         nd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rIUDXKD0e8KbaqffimpOQLEeyGh18ZndTs4TR3BjZr4=;
        b=orgovUI68RbBZZaSPw7V3sKBoX+h+xCaYapwYbcViJoyw/wSQDeRMHSktoQfNLlLkU
         Zk0L8IPj1HqG7m/OcGZ0gR1AXz68QABmqv1TK6luJVRiIloeuqDMrqAOl7zdHfOMLpy9
         hvLX0hcfnwOULMB6GrYK/Lo6HmVWhmcPDYqbWt7fE5nWmzLumsSO7uBh+0bhIRqAaHc6
         k2AoO8tQUS1AqEhevFTh53Ph5TcivfQtfpLONq4uqxSnFRAkDTyllpisi/z8Hr2UNvID
         YartlIfM7KagTvMkgQIEqTauptW6g+NPvm/F9mFe0oWgFW2aDivtlhW2eW2GhjrOS3LB
         0uhg==
X-Gm-Message-State: AOAM530crEw6TRqkvMw9fq3GohpGfD9PT3/M6FAEZiAcmwclUYuNRrgO
        SYPegRYvYBuCPmkagL110+rRo4Gg4a4=
X-Google-Smtp-Source: ABdhPJwO52chSqylpom6J69z4PWM2PLIOBOVaMAJvoembd9z2Opn7tWqXU2M/VULMfHZZOWnBp+E7w==
X-Received: by 2002:a17:90a:db01:: with SMTP id g1mr6210034pjv.33.1637205098834;
        Wed, 17 Nov 2021 19:11:38 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m6sm861464pgl.2.2021.11.17.19.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 19:11:38 -0800 (PST)
Date:   Thu, 18 Nov 2021 11:11:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [DISCUSS] Bond arp monitor not works with veth due to flag
 NETIF_F_LLTX.
Message-ID: <YZXEY90dRsBjJckd@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When I test bond arp monitor with veth interface, the bond link flaps rapidly.
After checking, in bond_ab_arp_inspect():

                trans_start = dev_trans_start(slave->dev);
                if (bond_is_active_slave(slave) &&
                    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
                     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
                        bond_propose_link_state(slave, BOND_LINK_DOWN);
                        commit++;
                }

it checks both slave's trans_start and last_rx. While veth interface's
trans_start never get updated due to flag "NETIF_F_LLTX". As when NETIF_F_LLTX
set, in netdev_start_xmit() -> txq_trans_update() the txq->trans_start
never get updated because txq->xmit_lock_owner is always -1.

If we remove the flag NETIF_F_LLTX, the HARD_TX_LOCK() will acquire the
spin_lock and update txq->xmit_lock_owner. I expected there may have some
performance drop. But I tested with xdp_redirect_map and pktgen by forwarding
a 10G NIC's traffic to veth interface and didn't see much performance drop. e.g.
With xdpgeneric mode, with the flag, it's 2.18M pps, after removing the flag,
it's 2.11M pps. Not sure if I missed anything.

So what do you think? Should we remove this flag on veth to fix the issue?
Some user may want to use bonding active-backup arp monitor mode on netns.

Thanks
Hangbin
