Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251766E98C3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjDTPwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjDTPwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:52:13 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB33E4A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:52:10 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D04253F19A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682005928;
        bh=fq1dtdVjYY7A699O+5drOoVzL9/AfSC0BPxHROwjvrE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=sbQ/Hk1EbmigzPBs+YBdqPryPbc975jgDeJCIlvmAnOwSqjQ0T2k9yUVTDSa5+lTJ
         shsZjlqW9PN6F9JFB/IhB1IvvWm/mCp5QXkQx0qjNONQY/qlgoBt6V3oNtIETJepBn
         fOLGj1Mogb0E1uejgf8X4gYG1Q0uKz7+bDRujNKTKvoj2HTUQcQoYdDMc+zvPHZI1+
         hB6G8lEIaAi4VBl4Ub+XFNt4kEH5O9bkwhnuBkSQiLKdC5M8clgCc8XwukAUEYjr1X
         VYV9tCrvSxdzovwj/q7NQE+UG+wo+4BbSseCru+tLyfgcO2B1t3AkNdDzOINwwt8PT
         zRGH769NTR3PQ==
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1a6a0a54c9dso8376485ad.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682005927; x=1684597927;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fq1dtdVjYY7A699O+5drOoVzL9/AfSC0BPxHROwjvrE=;
        b=c9Jal/WZnIP1QKWLyCVE0JJPJQSiodOTj/oFbFPliKndUoong7MbmtbhOwF1GFAa3b
         JfWkOURpeyeRaFgKsqIHI/7IN5sVgi0H3WwwjNSOlF6dfo+Won0bbCFh+I2wpMqgKS3c
         kTnAUmC3vwEQROeNWDcNsPhycsKXsMYkAecKvLfJObGkfMKgdjoL2VuMJbb8RO4G7cQw
         8sed5oCnOCfrVmPgjk14bf3ZjuAQTRg80JcUvOfWp8HAAuNE28148Y24dlvdBlvPRj4q
         nMZbts1/DxzKZct+5MpuC52xKBMSYbPjRtC3FpxiXe8UBq6/BAi/8AYeCjbbX02Puy3X
         r8GQ==
X-Gm-Message-State: AAQBX9dCW0sI/hteW7jHIYZrtU2AlzqoylRPtGIRkcDf11L3XHn7+or4
        dkSszoExC5B4PddJAegKUE3n/MRn9wm9751950YNANKqQfX0g7YJlTAyiZ0l6U82MT0Q85VnAoX
        /e3lwXie8ZB0qgd7cVg5giLjb9z18O7DCOA==
X-Received: by 2002:a17:902:c3c3:b0:1a9:31e5:a3ff with SMTP id j3-20020a170902c3c300b001a931e5a3ffmr2147265plj.8.1682005927449;
        Thu, 20 Apr 2023 08:52:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350bmq0Hm2W+q9oumO1Hz42Mf96oWqyE+FXa11O5yP66pC432lLEL4Ty0vGJpCo3TdANr68CcJA==
X-Received: by 2002:a17:902:c3c3:b0:1a9:31e5:a3ff with SMTP id j3-20020a170902c3c300b001a931e5a3ffmr2147248plj.8.1682005927119;
        Thu, 20 Apr 2023 08:52:07 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902748b00b001a641e4738asm1343003pll.1.2023.04.20.08.52.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:52:06 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 329A1607E6; Thu, 20 Apr 2023 08:52:06 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2B83A9FB79;
        Thu, 20 Apr 2023 08:52:06 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH net 2/4] Documentation: bonding: fix the doc of peer_notif_delay
In-reply-to: <20230420082230.2968883-3-liuhangbin@gmail.com>
References: <20230420082230.2968883-1-liuhangbin@gmail.com> <20230420082230.2968883-3-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 20 Apr 2023 16:22:28 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27405.1682005926.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 20 Apr 2023 08:52:06 -0700
Message-ID: <27406.1682005926@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Bonding only supports setting peer_notif_delay with miimon set.
>
>Fixes: 0307d589c4d6 ("bonding: add documentation for peer_notif_delay")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> Documentation/networking/bonding.rst | 7 +++----
> 1 file changed, 3 insertions(+), 4 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index adc4bf4f3c50..6daeb18911fb 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -776,10 +776,9 @@ peer_notif_delay
> 	Specify the delay, in milliseconds, between each peer
> 	notification (gratuitous ARP and unsolicited IPv6 Neighbor
> 	Advertisement) when they are issued after a failover event.
>-	This delay should be a multiple of the link monitor interval
>-	(arp_interval or miimon, whichever is active). The default
>-	value is 0 which means to match the value of the link monitor
>-	interval.
>+	This delay should be a multiple of the MII link monitor interval
>+	(miimon). The default value is 0 which means to match the value
>+        of the MII link monitor interval.

	Perhaps something like the following better reflects what we're
trying to convey here?

	This delay is rounded down to the MII link monitor interval
	(miimon), and cannot be set if miimon is not set.  The default
	value is 0 which provides no delay beyond the miimon interval.

	-J

> prio
> 	Slave priority. A higher number means higher priority.
>-- =

>2.38.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
