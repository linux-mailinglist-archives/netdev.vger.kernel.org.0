Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475C61593
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfGGQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 12:41:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41318 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfGGQlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 12:41:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so3303931pls.8
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 09:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZNBASK19z0cfw9gM/0itJsmsHS3Yg/oB9LUc0/iNLA=;
        b=eHh7s9uitgRcfd1yo95mPlBV5lrXsqyZpnEyJLL5sMv93Vd8OHrP2TLemBDTZ/r4/c
         N9fjqjOy+Z6Z3Wq1FQMMqICFCuVEPqS22gDlxdPPLLTmoA+GBSWQ/RZ5oBhPXBkePz/E
         B30tam/Glyt7brb8SurWwGbSctfVmKFza/ANYXvwdMlXQilg4wGIVJEFRZx5U+j7Ihud
         YW6WV5HLTYc9f6eiCzZ2E3kW4W8NJgjyCVFlfGWdVU1axh0ieHybgfFsxz5Yi6jiI8Pm
         FfsbP6mZRB/p116x5Kai/OKhlr5HntAUQqC63rbbvtKONYYrA26Ko+qDmnFMymUix4bU
         bkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZNBASK19z0cfw9gM/0itJsmsHS3Yg/oB9LUc0/iNLA=;
        b=WbhxJYNUvgrfISTmj/BfKfe8Q5BOFbRiNRScaCN5ZfcrTBpYIklbZmV5T36rZKd+29
         w3SuQCzrFdeATRi3TS1EFAABfZHb8fF+RlppM97l+LMaAlCX1Kzx0Qoo0dXsT/KwfqR4
         XJeYf02NntM0rhJwDUNqO2pmbyR8plc5ScYYlg+7E4QtOEHxVXPPbCDzfkXThgEjUP+7
         ehNV/rYHVsgxGsMVF2kbdkDoK2IuDHkC1YqGwMKv/2vmnGgljg5eiA050UmCD2mDrBQI
         vSMHZiQPp9KH2+XP0TnnQEFxkWgcxpnilIbM7VewIjbl99hOb4Jh1BnU3s3bMQk/K/3K
         H2kw==
X-Gm-Message-State: APjAAAWk2b0wVyy9WESsjyqvb0lkqdlTtDYhBcDd4MxN5mZbZprmi3rl
        artvb9lkb0ZcXfYt2LHilYLV9Y2IW3E=
X-Google-Smtp-Source: APXvYqxaYOWyJnapkFgVWZrDdv25zURElM9dFpWTVJ3HyahIwukS/iG4Ac3ScoLceRNKje1151QIHA==
X-Received: by 2002:a17:902:e202:: with SMTP id ce2mr15776133plb.272.1562517708762;
        Sun, 07 Jul 2019 09:41:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y12sm18819164pfn.187.2019.07.07.09.41.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 09:41:48 -0700 (PDT)
Date:   Sun, 7 Jul 2019 09:41:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: bond: add peer notification delay
 support
Message-ID: <20190707094141.1b98f3f4@hermes.lan>
In-Reply-To: <20190706211145.16438-1-vincent@bernat.ch>
References: <20190706211145.16438-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  6 Jul 2019 23:11:45 +0200
Vincent Bernat <vincent@bernat.ch> wrote:

> Ability to tweak the delay between gratuitous ND/ARP packets has been
> added in kernel commit 07a4ddec3ce9 ("bonding: add an option to
> specify a delay between peer notifications"), through
> IFLA_BOND_PEER_NOTIF_DELAY attribute. Add support to set and show this
> value.
> 
> Example:
> 
>     $ ip -d link set bond0 type bond peer_notif_delay 1000
>     $ ip -d link l dev bond0
>     2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     state UP mode DEFAULT group default qlen 1000
>         link/ether 50:54:33:00:00:01 brd ff:ff:ff:ff:ff:ff
>         bond mode active-backup active_slave eth0 miimon 100 updelay 0
>     downdelay 0 peer_notif_delay 1000 use_carrier 1 arp_interval 0
>     arp_validate none arp_all_targets any primary eth0
>     primary_reselect always fail_over_mac active xmit_hash_policy
>     layer2 resend_igmp 1 num_grat_arp 5 all_slaves_active 0 min_links
>     0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select
>     stable tlb_dynamic_lb 1 addrgenmode eu
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> --

My only nit, is that peer_notif_delay is not a good choice for name.
None of the other options are abbreviated. Please use peer_notify_delay
