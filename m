Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFEB14CC2C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgA2OQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:16:28 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:41442 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgA2OQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:16:28 -0500
Received: by mail-pg1-f180.google.com with SMTP id x8so8898681pgk.8
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 06:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=F61LnmBVZlm2lS4N34vgbLIqsf4fBX6ZHe8ZhhUMZvY=;
        b=Sii8GI6UqWip9Gf4URAgLzBfcPJkm/wCRPSBvSz9CaNEemwH5gadMcTeYQs3Q99fnO
         y6OH9acd6WEU2FZJPb6QwhvF1T889OTYr/UDiCdpN1lK7ye3TGnw0WhmxmHduLv/KRKU
         oBcSon/OVojl1sqIjzI2Pz18CdTZTv0406wgu9CiDxdmAplJTG9awZMUSI4z9ZuIXSbn
         sHxOtBkROrf6QmbWGa84YQ0jpJFkVnxQpZTjxSA36lzOrIwuu+f4QSL85DLi4Bv7C+f1
         Vb8CpKwilV3Z0PnVCael0lfg0IhY6u4zed4rjzvSPQETg5F6QCj5vdMoqXq36im0Vqgs
         CBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=F61LnmBVZlm2lS4N34vgbLIqsf4fBX6ZHe8ZhhUMZvY=;
        b=IUOZw6JuGbOrORSOVUIP27D8GOK48f3h6K3QGxsTRrfUUEbN7VkvR8rNNuMJbMiru7
         HeQQu5ivVm+sEq/wHV07zKOjG3FxjUjspLUp+XWni82PwUSKbz0yxejaam3KWfM2XVx7
         U2nIqH6joSgU3gtkmaA9ot6QTmesYkwEATz/6xMs70ry6TYMVsl498ipIfVuNxVLOqA4
         PuNhn/4gID/vevwagT9DSlrnS4Qlj+sM5wTHiKyorRb3Hgs/vVRR8szm5llx1UgNGM10
         cyd74bvBoxZgctd5FW2sS7uSR1Wx6cSfcGkp1Vj9ch0YXjprCf7Pk047Y2imCT7Q5NPb
         eU4w==
X-Gm-Message-State: APjAAAUE3ojrUYBxCFqa4bx6sHqoCZLyL2nbk9WA+EfCMDnMfuBOI/pM
        1imHGxYiKzVvo8a69yM3UD/bG1Z4A5M=
X-Google-Smtp-Source: APXvYqzzEbA0j/WaUUb79gYTctOKSgt/pPSA1JdTqlrY8dqQDGVTThMdKUt2nR64ayvRsBca82k6kQ==
X-Received: by 2002:a63:950c:: with SMTP id p12mr31427495pgd.85.1580307387548;
        Wed, 29 Jan 2020 06:16:27 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t1sm3033799pgq.23.2020.01.29.06.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 06:16:27 -0800 (PST)
Date:   Wed, 29 Jan 2020 06:16:19 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Peter Junos <petoju@gmail.com>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: iproute2 regression test now  failing after merge
Message-ID: <20200129061619.76283217@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I merged iproute2-next into iproute2 and noticed that the regression test for ss
is now failing.

$ make check 
Removing results dir ...
Running bridge/vlan/tunnelshow.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/netns/set_nsid_batch.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/netns/set_nsid.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/link/show_dev_wo_vf_rate.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/link/add_type_xfrm.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/link/new_link.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/tunnel/add_tunnel.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ip/route/add_default_route.t [iproute2-this/4.19.0-6-amd64]: PASS
Running ss/ssfilter.t [iproute2-this/4.19.0-6-amd64]: FAILED



Bisected it down to:

commit c4f58629945898722ad9078e0f407c96f1ec7d2b
Author: Peter Junos <petoju@gmail.com>
Date:   Thu Dec 26 14:07:09 2019 +0100

    ss: use compact output for undetected screen width


This commit is fine, the tests just need to be updated.m
