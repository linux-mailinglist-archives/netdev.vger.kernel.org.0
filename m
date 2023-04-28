Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154046F1C40
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345589AbjD1QGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjD1QGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:06:47 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABBA44B6
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:06:44 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E409B3F233
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682698002;
        bh=Evd5E1vAGuqAFGaUU5YGL3Y6YSFIrBP4+8VwWarY6U4=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=EopbUDEbL7G3uu1ewTL5K/6y26s7DFCATCPWj3BWozXdCeKiagHR4lQMW5Btud+Ks
         gywSZ1Idqf8yhMVivFzmfRMSJJsZSBgnsdqTphB9lM8FwPQdPzla32CFxYHkh+LLAA
         uZ3mLNwE5LeRMrgbVA7UvoRhlb9Q/HmMxyU1BIcvBuJsgSa2QMvcSna04SFhyeKZ5S
         0fkxPID2vFkJ7c9O3hCYTtXtS+zj6LjsbF+3vtklTG51fc0XXCDms3mAqedycKAx5y
         QHK1j1NbyM1xCpmqJiiz5MemVrJ7lwrCCaSr+ruO5ZFbeXGR4ILYgaheXwJwpbhGQP
         Xvw1SF6CBsWjA==
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-51b51394f32so5927952a12.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698001; x=1685290001;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Evd5E1vAGuqAFGaUU5YGL3Y6YSFIrBP4+8VwWarY6U4=;
        b=hvyejd1OKqZygxmSioXNSui5XiPhSq6pc3AetMX/ScIKCtgIKbBdmlXefGkRdZrXR8
         79Xxprtaa7o422NinR8MAb9XcvV1ApmElhSBZ9IRLKjt9isNDhIX1fK2ws+Qd8g5FzMg
         hLbQiF7iYOeWO4wfXRRHmmp0o2kIYSMlE8A+f8txMHd+2z634qAZCFib94N8riQF3srf
         ++7LRbifxoJATAhgP9DWc4lX7ROPNps1xribG+4MMZ3dRgpIHnU3yq23NBp0H7Eu4jNY
         hOSw3H9za1Kkqd3ZVxNaY4+Yzp8hWdw2WQnEPCLM1YI4DNO/LW/4O9saxnALUXk3uAsS
         ZDjg==
X-Gm-Message-State: AC+VfDwvrb6McQI6ogFI6X/Bewxd8C8N1NJDO41BHM5S8peDQu7wFqKn
        /isS8J6fqD5Kq5y1VkRblSSIVfLFtKWIxcpsgL8Q+tPfG0LURTKavhFck+3NGEnw6QpLiOIzB/6
        CGwWPpD+YCt/HZch23r7ikmNF2LCfZgjzDA==
X-Received: by 2002:a05:6a20:7f86:b0:ea:fb53:4cb1 with SMTP id d6-20020a056a207f8600b000eafb534cb1mr6306043pzj.41.1682698001426;
        Fri, 28 Apr 2023 09:06:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6vCMbBy9UmDjaXkCqXDyGLTFA1fbEoPWkV82nzvAxcxGfRNIgpIkUIxDaOqUDmUeGvlgGLmw==
X-Received: by 2002:a05:6a20:7f86:b0:ea:fb53:4cb1 with SMTP id d6-20020a056a207f8600b000eafb534cb1mr6306012pzj.41.1682698001098;
        Fri, 28 Apr 2023 09:06:41 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id i134-20020a62878c000000b006328ee1e56csm15319495pfe.2.2023.04.28.09.06.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:06:40 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2FF5661E6D; Fri, 28 Apr 2023 09:06:40 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2AA929FB79;
        Fri, 28 Apr 2023 09:06:40 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is bond 802.3ad
In-reply-to: <ZEt3hvyREPVdbesO@Laptop-X1>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 28 Apr 2023 15:36:38 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15523.1682698000.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 28 Apr 2023 09:06:40 -0700
Message-ID: <15524.1682698000@famine>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>A user reported a bonding issue that if we put an active-back bond on top=
 of a
>802.3ad bond interface. When the 802.3ad bond's speed/duplex changed
>dynamically. The upper bonding interface's speed/duplex can't be changed =
at
>the same time.
>
>This seems not easy to fix since we update the speed/duplex only
>when there is a failover(except 802.3ad mode) or slave netdev change.
>But the lower bonding interface doesn't trigger netdev change when the sp=
eed
>changed as ethtool get bonding speed via bond_ethtool_get_link_ksettings(=
),
>which not affect bonding interface itself.

	Well, this gets back into the intermittent discussion on whether
or not being able to nest bonds is useful or not, and thus whether it
should be allowed or not.  It's at best a niche use case (I don't recall
the example configurations ever being anything other than 802.3ad under
active-backup), and was broken for a number of years without much
uproar.

	In this particular case, nesting two LACP (802.3ad) bonds inside
an active-backup bond provides no functional benefit as far as I'm aware
(maybe gratuitous ARP?), as 802.3ad mode will correctly handle switching
between multiple aggregators.  The "ad_select" option provides a few
choices on the criteria for choosing the active aggregator.

	Is there a reason the user in your case doesn't use 802.3ad mode
directly?

>Here is a reproducer:
>
>```
>#!/bin/bash
>s_ns=3D"s"
>c_ns=3D"c"
>
>ip netns del ${c_ns} &> /dev/null
>ip netns del ${s_ns} &> /dev/null
>sleep 1
>ip netns add ${c_ns}
>ip netns add ${s_ns}
>
>ip -n ${c_ns} link add bond0 type bond mode 802.3ad miimon 100
>ip -n ${s_ns} link add bond0 type bond mode 802.3ad miimon 100
>ip -n ${s_ns} link add bond1 type bond mode active-backup miimon 100
>
>for i in $(seq 0 2); do
>        ip -n ${c_ns} link add eth${i} type veth peer name eth${i} netns =
${s_ns}
>        [ $i -eq 2 ] && break
>        ip -n ${c_ns} link set eth${i} master bond0
>        ip -n ${s_ns} link set eth${i} master bond0
>done
>
>ip -n ${c_ns} link set eth2 up
>ip -n ${c_ns} link set bond0 up
>
>ip -n ${s_ns} link set bond0 master bond1
>ip -n ${s_ns} link set bond1 up
>
>sleep 5
>
>ip netns exec ${s_ns} ethtool bond0 | grep Speed
>ip netns exec ${s_ns} ethtool bond1 | grep Speed
>```
>
>When run the reproducer directly, you will see:
># ./bond_topo_lacp.sh
>        Speed: 20000Mb/s
>        Speed: 10000Mb/s
>
>So do you have any thoughts about how to fix it?

	Maybe it's time to disable nesting of bonds, update the
documentation to note that it's disabled and that 802.3ad mode is smart
enough to do multiple aggregators, and then see if anyone has some other
use case and complains.

	In the past, I've been against doing this, but only because it
might break existing configurations.  If nested configurations are going
to misbehave and require complicated shenanigans to fix, then perhaps
it's time to push users into a configuration that works without the
nesting.

	The only thing I can think of that active-backup over 802.3ad
gets is the gratuitous ARP / NS on failover.  If that's the key feature
for nesting, then I'd rather add the grat ARP to 802.3ad aggregator
selection and disable nesting.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
