Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB9E2E8DCB
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbhACSfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 13:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbhACSfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 13:35:31 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5ACC061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 10:34:51 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id z11so21746076qkj.7
        for <netdev@vger.kernel.org>; Sun, 03 Jan 2021 10:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version
         :content-transfer-encoding:date:message-id;
        bh=MmTjkRuj793Lrb7TSe0lB3EZ2poUQhlcldBZ+7guGy8=;
        b=ObsHT6yRPjvpQyoB176eIqNs/b944Z1hmrvwlu4sCeKFl/Yx4rfbNRL0YwLpZ/t2GS
         wIdGtIgEJVuklbOT9VygG35QHBoNmaAUFYayOdSlzA9+WFGS5UxFh2aVk/YUHLQp0HiT
         sm0F25bhtYm2MdpXfacjiQ3kDgQAP3YTd636zrK5o0V0P94MNB9WdIHoagZ84NsxUUjV
         G0wVFeYo60QK+bJHZjjSXMOEGyzh6QQBAbV85UQM5ExcE0MkveIIAfM3C2p6DUwgM0Jw
         wIlD/WJfrVNQEIE72mTSKWVzntRygGOIBtUiGeOSB6QPwoAFBja7q/45N+XarIxhYlOh
         lftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=MmTjkRuj793Lrb7TSe0lB3EZ2poUQhlcldBZ+7guGy8=;
        b=i3YPMePV/no/OS+2xV/JFflYeDgI75bWR9TVGUPGM9a+8UInZbEKqiZ+kD3SMnFfTC
         Bd3S+zY5rNizfxwTOeCTG9n1bm99MrEzO2nnIJXS6uqwt8JGGhIYTs44yOmQTmKm4K0R
         NBh9LKEtRYASjWb1LKtz/T9x+IQ1v0ufHFyFxPvMFowBFi1d6BLZ8Fk3+zWQO03Mt/B5
         MltfLJX5o7opb1YHUZplDLsCznPvtR7gWKF2sThPU58KJUxziSrcUGqhVUxWmhqLewUM
         7m1k4AoJcO2HGPgn1+ZR/GdQ5XyzlCfRSXYp+FwvTeSsiS/6cmpTE2xhhPsbakdNTUHH
         WRuQ==
X-Gm-Message-State: AOAM531fKojH6zKPj+PETgRMXPGspxJQJMtvqXHxHpBkM6EcmxAUWGiD
        PiqgSufd50WFw1t7sPz21lps+w==
X-Google-Smtp-Source: ABdhPJzmksCghBQCKNUBUmWlNysGW6rkbkGmA4QvcvxUcU/tQjHH6fMS1vLzcMc45tAo4kLSaFbWzg==
X-Received: by 2002:a37:4394:: with SMTP id q142mr67683739qka.113.1609698890469;
        Sun, 03 Jan 2021 10:34:50 -0800 (PST)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id c7sm35839738qtm.60.2021.01.03.10.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 10:34:49 -0800 (PST)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig, DEFAULT_NETSCH, and shooting yourself in the foot..
In-Reply-To: <20210103102011.444ecaa4@hermes.local>
References: <16871.1609618487@turing-police> <CAK7LNAQU61eccDfh_jX_cnZHnyxfbfgBGu1845QM8XbBTJPnsw@mail.gmail.com>
 <20210103102011.444ecaa4@hermes.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1609698888_2273P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Sun, 03 Jan 2021 13:34:48 -0500
Message-ID: <76815.1609698888@turing-police>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--==_Exmh_1609698888_2273P
Content-Type: text/plain; charset=us-ascii

On Sun, 03 Jan 2021 10:20:11 -0800, Stephen Hemminger said:
> You can use a qdisc that is a module, it just has to be available when device
> is loaded. Typically that means putting it in initramfs.

Apparently, that's not *quite* true regarding the default qdisc, because I
hit this situation (copying from another email):

---
[/proc/sys/net] cat core/default_qdisc
fq_codel

[/proc/sys/net] tc -s qdisc show
qdisc noqueue 0: dev lo root refcnt 2
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
qdisc pfifo_fast 0: dev eth0 root refcnt 2 bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
qdisc noqueue 0: dev wlan0 root refcnt 2
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0

But if I give it a kick in the head...

[/proc/sys/net] tc qdisc add dev wlan0 root fq_codel
[/proc/sys/net] tc -s qdisc show dev wlan0
qdisc fq_codel 8001: root refcnt 2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn
drop_batch 64
 Sent 812 bytes 12 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
  maxpacket 0 drop_overlimit 0 new_flow_count 0 ecn_mark 0
  new_flows_len 0 old_flows_len 0
---

Note that wlan0 doesn't actually get plumbed up until after the initramfs
has done its thing and we're quite late in the boot process and the /lib/modules
on the production system is accessible, so it doesn't look like an implicit modprobe
gets done in that case - fq_codel.ko was very much available when the device
was brought up.

--==_Exmh_1609698888_2273P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBX/IORwdmEQWDXROgAQLm3A/+MSlQovP8k9Gxrq0QufB4K1mYoHnEhr/x
/gD3Nc7RAijmmBnO1fD3eOSyH2vjy6ONhGldU+wiuzRirWG9aP1soCqY6X3l7ZNK
aPS+Gy8yKa2B9nNNHhiDp41CiF9pFkZiGefS+btFiZsE+hSRi/e+UA4GGPL158ce
85xrgtsBzV6/HHubwFyaGeQyxFovcrZhxnjAbVvN6yszlNVAmTrVMgYB2RqlZO9p
PKv+n5p9NjDrLY6newLJFSgocVl2U6sKB0VGg+tLvaUvE2E0LdFu5lO61RRjs9a7
Rd8bgvLFZSjoC5XA4Sp7IATSxLjWeMe2ErAOe89MlZmT8NNtNKITCRNP9YcH3zhA
dJL3l32euWMxI4/Cim7bAq6s8an5jOwfsy2hUJhMNGePo6MqKUr109BodUHSf9ie
1T1/I0S7CzN8ZRGOySjDhpvp9tt/LdWYn9tMK3wtZMsenk8FZ1REOqAybu50IWdo
jVyS5hzg1MdIZJQRMDnFwUmDb36yya9flfkYe7b8px3rYsUFkQQQ1+6YXkFWyyGJ
K4bVx/Lc8OX6gq6+YWKLbv1HBwQ/4Ed/2d6xCdnddAtc925byMcODd+77zAQXLPw
Q1aiUsCOBzvjyPq15Pa1Jrb5OTX6ysdb/oxvzDYASBSOR0OcbvtzViIMYbmmhXco
YU0wERhKQTk=
=vJbt
-----END PGP SIGNATURE-----

--==_Exmh_1609698888_2273P--
