Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7B88595
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfHIWH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:07:27 -0400
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:34365 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726800AbfHIWH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:07:27 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2019 18:07:26 EDT
X-Sender-Id: dreamhost|x-authsender|craig@zhatt.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id A8849502BDD
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 22:02:14 +0000 (UTC)
Received: from pdx1-sub0-mail-a64.g.dreamhost.com (100-96-145-246.trex.outbound.svc.cluster.local [100.96.145.246])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 3E3C1502C47
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 22:02:14 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|craig@zhatt.com
Received: from pdx1-sub0-mail-a64.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.5);
        Fri, 09 Aug 2019 22:02:14 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|craig@zhatt.com
X-MailChannels-Auth-Id: dreamhost
X-Reaction-Cellar: 216456c716c3effa_1565388134460_4186428799
X-MC-Loop-Signature: 1565388134460:1976152283
X-MC-Ingress-Time: 1565388134460
Received: from pdx1-sub0-mail-a64.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a64.g.dreamhost.com (Postfix) with ESMTP id EC2D58383D
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zhatt.com; h=mime-version
        :from:date:message-id:subject:to:content-type; s=zhatt.com; bh=K
        n3fWNvpfiu3OjS74S01yCv0Mes=; b=gxl5eOmhvRn6vgu1vzwMAOb7QEtN+GMCB
        e2E76a3wtGhwM3AuzTdv+/ZHVruxNLvp0k3YWZGiMJFkB99X3MJ1N4fMRxp7lVbz
        NwTsMhbmfDV00JL5LO+68kYjnNQsbA+6anBMJGcsivYt35Ux9Xf+S1RHjPmBSHVm
        uNPmBwtyQw=
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: craig@zhatt.com)
        by pdx1-sub0-mail-a64.g.dreamhost.com (Postfix) with ESMTPSA id 72AF383847
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 15:02:10 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id b16so2796476wrq.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:02:10 -0700 (PDT)
X-Gm-Message-State: APjAAAUKknAGlY710gxjAmUoxClVZ5JR/C/xdfzP3yRjF4dwSHh6cy22
        gCxYnRPG9jGdSu2oRNVelwWx+XvSpI8mhVH4qaA=
X-Google-Smtp-Source: APXvYqzXuF384I1yj1tbWLU1BgygUGZ3QCDDgpSmKR/pGuC7QEuDhz3WIdi3lOmEy4AoAgQHVKHtcVBaa2E49Duf0fw=
X-Received: by 2002:adf:dd88:: with SMTP id x8mr17018589wrl.331.1565388129404;
 Fri, 09 Aug 2019 15:02:09 -0700 (PDT)
MIME-Version: 1.0
X-DH-BACKEND: pdx1-sub0-mail-a64
From:   Craig Robson <craig@zhatt.com>
Date:   Fri, 9 Aug 2019 15:01:52 -0700
X-Gmail-Original-Message-ID: <CAK0T-BLWTeDqX7-4KuYcUNNwg1vjiG9x70cUxiELzMkOEPufsw@mail.gmail.com>
Message-ID: <CAK0T-BLWTeDqX7-4KuYcUNNwg1vjiG9x70cUxiELzMkOEPufsw@mail.gmail.com>
Subject: Regression in routing table cleanup when VRF support was fixed.
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddruddukedgtdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpegghfffkffuvfgtsehttdertddttdejnecuhfhrohhmpeevrhgrihhgucftohgsshhonhcuoegtrhgrihhgseiihhgrthhtrdgtohhmqeenucfkphepvddtledrkeehrddvvddurdehtdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepmhgrihhlqdifrhduqdhfhedtrdhgohhoghhlvgdrtghomhdpihhnvghtpedvtdelrdekhedrvddvuddrhedtpdhrvghtuhhrnhdqphgrthhhpeevrhgrihhgucftohgsshhonhcuoegtrhgrihhgseiihhgrthhtrdgtohhmqedpmhgrihhlfhhrohhmpegtrhgrihhgseiihhgrthhtrdgtohhmpdhnrhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit caused a regression for me when using policy routing.

5a56a0b3a45d net: Don't delete routes in different VRFs

The regression is that routes are no longer getting deleted when I delete IP
addresses when using non-default routing tables.

For example the following sequence used to delete the routing entry in table
100 when the ip was deleted, but after the above commit is does not delete the
routing table entry.

Setup
# ip link set dummy0 up
# ip addr add 10.10.10.10/24 dev dummy0
# ip addr add 192.168.10.10/24 dev dummy0
# ip route add dev dummy0 192.168.10.0/24 table 100 scope link src 192.168.10.10
# ip route show table 100
192.168.10.0/24 dev dummy0 scope link  src 192.168.10.10

Cleanup
# ip addr del 192.168.10.10/24 dev dummy0

Routing entry still exists and should not.
# ip route show table 100
192.168.10.0/24 dev dummy0 scope link  src 192.168.10.10

This was previously working (deleting the route) since at least 2.6.32.  I am
not using VRFs.  What needs fixed to get the old behavior?

Regards,
Craig Robson
