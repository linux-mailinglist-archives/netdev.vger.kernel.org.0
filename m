Return-Path: <netdev+bounces-7331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB88071FB8D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F1331C20B19
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6554846B;
	Fri,  2 Jun 2023 08:09:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2332538B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:09:05 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ABBEB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:09:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b04706c85fso17164865ad.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 01:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685693340; x=1688285340;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x9dsuzJyb9zqdAq6lctOEVe1TQhYA1MV8cOpJLxujP4=;
        b=TGyfEaEExhDivxd7Q0KAJqoBmuQLJciDk6hZuj69iHQIGbGGOZBSKvOxmoUwGiucxA
         QHUNI423yAlmRNhZhEg5QJ/DG4m+EJi0ChFW2wGhWISObyJPZDmabFDNb72WzCPxutv9
         EszDmDjnQPKqfwjNufU1aeCQMWS1sHr7H6e54/7lYFwneFiyGxNVElxwKsqTEUm0MW4T
         OLolKBxPmrKnKoEqn8aWcgCAqV6WpkpUj5u3Q/wYg5fFCIq7/omkKbxftfDYnORH9YZJ
         0z6OmXLW4cGv6ZHIrMDLPImigUVwma63Cv4cXadYadBentcQtlfcYAWVyn+UQ2w4ARee
         rGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685693340; x=1688285340;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x9dsuzJyb9zqdAq6lctOEVe1TQhYA1MV8cOpJLxujP4=;
        b=PMxqLauv4RRO9Y+lB8cAr5gLZvzIwrqyBpWBbu5nxki1Sv3B7djDg1J8nOcupiK/gF
         vyvgMOExLZXZ528E7u0rIuKHuzjousphlF1O1uAYpFWYOfhv/jTTJAiuvk9pkL5QCTHW
         VWEE0Ap5W04FBaE8Y7VqOpzbzttbAaBlI0Y5HJ74wq9Kcnqyit7hvyXgq3c2jDlMpYqr
         AzzjWdoj6qTFfSYmFM0HAP68Y7qwDyGWBKt2PKgoOnWvUusw3f3QUrsrgz1IICvDleHd
         P5aqF/9AR6d2r9pTwCQC4IBU4WhRvG/N9IizGFJy44sKqpsh0/X+/hmTHjKTziP8bTNp
         El/Q==
X-Gm-Message-State: AC+VfDzNpo9n6OKVi1C44OePCqwMubXwD2xmR+rJHlS4wKe2wWL30Aqu
	Y9qzLxNsT6CCkoEkrvA9ii5gjhEhoGg=
X-Google-Smtp-Source: ACHHUZ5VROU2KcOFNqru/bh6Z5WEguVg22pntkuhdjguMn9W/qwyNffgQfiJPSrcPC0KKYgFtemPjQ==
X-Received: by 2002:a17:902:b716:b0:1af:beae:c0b with SMTP id d22-20020a170902b71600b001afbeae0c0bmr1587675pls.22.1685693339931;
        Fri, 02 Jun 2023 01:08:59 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902f20200b001affb590696sm695547plc.216.2023.06.02.01.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 01:08:59 -0700 (PDT)
Date: Fri, 2 Jun 2023 16:08:55 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Subject: [Discuss] IPv4 packets lost with macvlan over bond alb
Message-ID: <ZHmjlzbRi0nHUuTU@Laptop-X1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jay,

It looks there is an regression for commit 14af9963ba1e ("bonding: Support
macvlans on top of tlb/rlb mode bonds"). The author export modified ARP to
remote when there is macvlan over bond, which make remote add neighbor
with macvlan's IP and bond's mac. The author expect RLB will replace all
inner packets to correct mac address if target is macvlan, but RLB only
handle ARP packets. This make all none arp packets macvlan received have
incorrect mac address, and dropped directly.

In short, remote client learned macvlan's ip with bond's mac. So the macvlan
will receive packets with incorrect macs and dropped.

To fix this, one way is to revert the patch and only send learning packets for
both tlb and alb mode for macvlan. This would make all macvlan rx packets go
through bond's active slave.

Another way is to replace the bond's mac address to correct macvlan's address
based on the rx_hashtbl . But this may has impact to the receive performance
since we need to check all the upper devices and deal the mac address for
each packets in bond_handle_frame().

So which way do you prefer?

Reproducer:
```
#!/bin/bash

# Source the topo in bond selftest
source bond_topo_3d1c.sh

trap cleanup EXIT

setup_prepare
bond_reset "mode balance-alb"
ip -n ${s_ns} addr flush dev bond0

ip -n ${s_ns} link add link bond0 name macv0 type macvlan mode bridge
ip -n ${s_ns} link set macv0 up

# I just add macvlan on the server netns, you can also move it to another netns for testing
ip -n ${s_ns} addr add ${s_ip4}/24 dev macv0
ip -n ${s_ns} addr add ${s_ip6}/24 dev macv0
ip netns exec ${c_ns} ping ${s_ip4} -c 4
sleep 5
ip netns exec ${c_ns} ping ${s_ip4} -c 4
```

Thanks
Hangbin

