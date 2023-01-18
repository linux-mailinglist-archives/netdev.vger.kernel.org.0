Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E642E6723D3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjARQoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjARQnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:43:24 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CCC11EAD
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:43:18 -0800 (PST)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 57F753F124
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674060184;
        bh=9tAuWl9w/4f9rTIgcfT0TkvDUp/Bl5WP5VSvPWmaD/E=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=DmOd7WLXiFNxAmnL+ApvFYmx/xP8jMSW81ggGATNBL/SykhHsvjMKCzAxC0rbL8jb
         MVd/TmiyiUy/gJCDrzhzTFzA2gYxHpvPpxl/UN6GnVA3pJC3Y/vzsV5K6WOgKswaFc
         TvSXGG18sXPqHl8bbqj05BemS3ofqqBfRQYsJICMRcR16S3O1RGsK1f8IH3vr7kCU9
         5FcO575SYJldmPmak6sq+W84fSxH4cMYJUpRZ13UHmErh/3baAvbqRitjFizOOW8xW
         sTLplX34vzuy8NT7plwYVaf3Aw/ynnIYUOZXRFdanWIjUmZiMEFcuNEyFrZZpr+aKb
         xrSqCr2+TPwbA==
Received: by mail-pg1-f199.google.com with SMTP id e184-20020a6369c1000000b0049de6cfcc40so15720813pgc.19
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:43:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tAuWl9w/4f9rTIgcfT0TkvDUp/Bl5WP5VSvPWmaD/E=;
        b=2l48eep5GjjfaQOqWRelA1lF5wYARb4RW4zlnGf1hPO50nzfNWglqXCClXY0e1t4aM
         JwZg3mJp+B7HRBtl8OSTJJlyQPwt3xFYjiUeXE1YlM1iPlHvwOPJzpQOdFlKqedyT3k/
         SbRS3d1VsjE64zb/Bi1L5gD5ZINjV2um8COl7kk2IALdsGiiPiEpbz2us3STtATTWPgp
         CsXf7fsV9BBZ/8GN8VGouNzE5z7+KCmQKXXlsqNSzbQCnJdsDwXwsV5dh97/NCf/rV3v
         0RDMrH3hYBNF4cdBo5qNiXAn8jSS/0ueKC4JdYTKcziapGRh7KQxmPy+R8KsTbyPZ3fZ
         YYpg==
X-Gm-Message-State: AFqh2kpJRZLlGys3w/N/dHDU22epS8TTvFIbZshVepwte0i6kpdta6eG
        A1W4P0yrrLrcg9uR0GSW2aIS3Hi/9H4OD+z7ep0J00b0gq2b6N5zhWxSKbp4BvhzBf8vOKcDlTt
        jR1GXwiW2ZY9BhAE7WnP3frC7sfxFD4DuUg==
X-Received: by 2002:a17:902:b111:b0:194:65fa:c354 with SMTP id q17-20020a170902b11100b0019465fac354mr7245979plr.20.1674060182682;
        Wed, 18 Jan 2023 08:43:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsT4bOO9BmAYHavgzCREJGW0H2jUSFxMISUNKKf/H7Mtsrhtb+5/CenOK1GRw/DMqRb6WJrhw==
X-Received: by 2002:a17:902:b111:b0:194:65fa:c354 with SMTP id q17-20020a170902b11100b0019465fac354mr7245963plr.20.1674060182395;
        Wed, 18 Jan 2023 08:43:02 -0800 (PST)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id z20-20020a170903409400b001933b4b1a49sm17958798plc.183.2023.01.18.08.43.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:43:01 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 703E25FF12; Wed, 18 Jan 2023 08:43:01 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 688799FB5C;
        Wed, 18 Jan 2023 08:43:01 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Ian Kumlien <ian.kumlien@gmail.com>
cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        andy@greyhouse.net, vfalico@gmail.com
Subject: Re: Expected performance w/ bonding
In-reply-to: <CAA85sZtrSWcZkFf=0P2iQptre0j2c=OCXRHU8Tiqm_Lpb-ttNQ@mail.gmail.com>
References: <CAA85sZtrSWcZkFf=0P2iQptre0j2c=OCXRHU8Tiqm_Lpb-ttNQ@mail.gmail.com>
Comments: In-reply-to Ian Kumlien <ian.kumlien@gmail.com>
   message dated "Wed, 18 Jan 2023 15:21:26 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10436.1674060181.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 18 Jan 2023 08:43:01 -0800
Message-ID: <10437.1674060181@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ian Kumlien <ian.kumlien@gmail.com> wrote:

>Hi,
>
>I was doing some tests with some of the bigger AMD machines, both
>using PCIE-4 Mellanox connectx-5 nics
>
>They have 2x100gbit links to the same switches (running in VLT - ie as
>"one"), but iperf3 seems to hit a limit at 27gbit max...
>(with 10 threads in parallel) but generally somewhere at 25gbit - so
>my question is if there is a limit at ~25gbit for bonding
>using 802.3ad and layer2+3 hashing.
>
>It's a little bit difficult to do proper measurements since most
>systems are in production - but i'm kinda running out of clues =3D)
>
>If anyone has any ideas, it would be very interesting to see if they woul=
d help.

	If by "bigger AMD machines" you mean ROME or similar, then what
you may be seeing is the effects of (a) NUMA, and (b) the AMD CCX cache
architecture (in which a small-ish number of CPUs share an L3 cache).
We've seen similar effects on these systems with similar configurations,
particularly on versions with smaller numbers of CPUs per CCX (as I
recall, one is 4 per CCX).

	For testing purposes, you can pin the iperf tasks to CPUs in the
same CCX as one another, and on the same NUMA node as the network
device.  If your bond utilizes interfaces on separate NUMA nodes, there
may be additional randomness in the results, as data may or may not
cross a NUMA boundary depending on the flow hash.  For testing, this can
be worked around by disabling one interface in the bond (i.e., a bond
with just one active interface), and insuring the iperf tasks are pinned
to the correct NUMA node.

	There is a mechanism in bonding to do flow -> queue -> interface
assignments (described in Documentation/networking/bonding.rst), but
it's nontrivial, and still needs the processes to be resident on the
same NUMA node (and on the AMD systems, also within the same CCX
domain).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
