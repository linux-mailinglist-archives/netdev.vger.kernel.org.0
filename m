Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1486D3DC8B6
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 00:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhGaWpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 18:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhGaWpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 18:45:44 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C65C06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 15:45:37 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id v8-20020a0568301bc8b02904d5b4e5ca3aso1477966ota.13
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 15:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=p0Vt11XZOYOMlHxtjfmYxPfHjoqALLBEYIb8c+YJn3I=;
        b=HvtVixXZuR40g1cfODTH0B/8Bca3/uXKApAzCWKGuf4AA8s8Vy7JggN4u+OzPPjXNT
         2R1o9GpCA/dlD1bO7rjwIgzDX3EAK4J+8C33K0k/ubdz86dc4gwNpeOwak1eWSHk4bk9
         zt/9iyevYZkJcJBC8Rz3tzf1VdVqwmpzmHFvH3TjcIFT0UzBwYqDfKc3pAvkt7NK2432
         2Y2X+XpNhzzUXvxc/FbNxafPhwDPaeE0PZkzD7nTjqqqITWPuZCaVoogOBWG0pHOghJ0
         M9wST/8nY3ryKDOTTmLmENnI+QuqmgtmfGgiRJzvNdXn/2S60t7aR6unCBwCoHxaC+Rb
         Vxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=p0Vt11XZOYOMlHxtjfmYxPfHjoqALLBEYIb8c+YJn3I=;
        b=QEyNaeKLoa91/RQGjtv2NFNPUBYtd2QI28VJEj6p/pcgKToM1G+DUeSxl/mXeHMx9b
         Wof7lzjKHyGiFB4nx1jpeOA2OmUT8R+dR64fhss8esrtDJ21UQMa5ajew1rm9gblioHI
         VJHOV+xKFGsVJIb3vcwcou23ep8J/XgPQt4UCM+I55YXFwppsCUyAWwHl/4hTByEeRxK
         t6zDVfSyUzGL6zcThjwsbzanJjQxrgfRajcp9mOyDUVGnk4uBva21S2r1gohAALFO7y7
         AINqoj/pek3huP/QMt0eGH4uwNB825J3TH+QyL38Ca4R+lW82sd0FCjS0Pj+DHh2qrKE
         KP+Q==
X-Gm-Message-State: AOAM533Dq/A0si+GA3O5m6K9TVQP2lJTRQS1zktnHWDuEKqWsfUU4O3y
        pb/jskT4DdHiyNtrqAro2eYlPPUmSOBeY3+AgXMtrQ==
X-Google-Smtp-Source: ABdhPJy+xIUb3bX2SdmknDPC0TU0LbD/tGZS2bTOzskXfli72e9tE0RvUVU2343Uj8tVhcIChSKNIObSn6Ec5Sx87zA=
X-Received: by 2002:a05:6830:3143:: with SMTP id c3mr6859118ots.229.1627771536858;
 Sat, 31 Jul 2021 15:45:36 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Sun, 1 Aug 2021 00:45:26 +0200
Message-ID: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
Subject: RMNET QMAP data aggregation with size greater than 16384
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Subash,

I'm playing with the whole QMAP data aggregation setup with a USB
connected Fibocom FM150-AE module (SDX55).
See https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/71
for some details on how I tested all this.

This module reports a "Downlink Data Aggregation Max Size" of 32768
via the "QMI WDA Get Data Format" request/response, and therefore I
configured the MTU of the master wwan0 interface with that same value
(while in 802.3 mode, before switching to raw-ip and enabling
qmap-pass-through in qmi_wwan).

When attempting to create a new link using netlink, the operation
fails with -EINVAL, and following the code path in the kernel driver,
it looks like there is a check in rmnet_vnd_change_mtu() where the
master interface MTU is checked against the RMNET_MAX_PACKET_SIZE
value, defined as 16384.

If I setup the master interface with MTU 16384 before creating the
links with netlink, there's no error reported anywhere. The FM150
module crashes as soon as I connect it with data aggregation enabled,
but that's a different story...

Is this limitation imposed by the RMNET_MAX_PACKET_SIZE value still a
valid one in this case? Should changing the max packet size to 32768
be a reasonable approach? Am I doing something wrong? :)

This previous discussion for the qmi_wwan add_mux/del_mux case is
relevant: https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/..
The suggested patch was not included yet in the qmi_wwan driver and
therefore the user still needs to manually configure the MTU of the
master interface before setting up all the links, but at least there
seems to be no maximum hardcoded limit.

Cheers!

-- 
Aleksander
https://aleksander.es
