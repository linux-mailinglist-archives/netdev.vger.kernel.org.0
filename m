Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E5852ADAA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiEQVt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiEQVtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:49:22 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7331252B2E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:49:21 -0700 (PDT)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4563F3F5EF
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652824160;
        bh=EeAYup7Z3kKQDD2Qh4K59WMf8Pu+/T4wgl2l9cAZtmE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=OVNI4q65qmtOEXZ660B2H/Ox99KeYZK59Hhh4GeMyYxNcMvEMSSBVyJX0eJMvy2zF
         hv2nszcGSD+blbfokx4UNwsEBzIIlZaaPUW57MaVxBmAK1dnXgejvsk3o+sTyLTwgf
         kmYObVHgrDDSH5rp8L+RVBpMFrt9ueQXA7eTVsN36waPbczRMYqzZvBXsmfH0j6MN1
         qqjPzxX4bwGH9WQrEYM/z9pxILV+X4VZpImIK81woioCOW/aBtHpwU8+bkTCFk2n4B
         3YFp3KRe6Z/vFngd8VGKMyMs4/s45qF2GRkA3wqaJUEOYAZ9CmhvOM9AWAru4vM+Ep
         cZlNhZiFIGQoQ==
Received: by mail-pf1-f199.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so139417pfn.15
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=EeAYup7Z3kKQDD2Qh4K59WMf8Pu+/T4wgl2l9cAZtmE=;
        b=x0TalixOPteILYsZRXR13rDbG9/p3WrGIYXP4kX9ujeflOMqTGdO5fH7W2rxFBcfpB
         0xgk9CltEN8+UBYvw//D3Y+Vcyfw1wVyyZdROs7gwp4mg6aSOQsoBBKsiqsvzz5Rnppx
         s3PYJUNHb+ldkGd2Pz7HHe1iJhfJCE4yuaFR1Entf+hapu1Ic6mouJTjIgODbKppFSJl
         0x0oSE3EUG8oHfUOrr6u8a1tmrdjyrFdvKtTz+p60K9tTUaRysPEhEZrllDiT7VYixXb
         oy9lB1a6GFdgzxhmGu9eo3O221AQLBfiq51urO72pSdDQVqK7y50CpgSQVm9G9WpmiVV
         hXXA==
X-Gm-Message-State: AOAM531h1Hij4jKasDAm+BuWN9ALg/NjS4e2dLKCLfyzuNYo6V3QxvC+
        InJVsJRqu6EwTdKwBxhwXofou6ihFuokJZmj/2XlNk/9wSZyZHwZgoe2qXoMeCwRxWjLdYqGM90
        I4kpK1euBrX/ry3vkypTzyjO1cpvZ1oI+Ew==
X-Received: by 2002:a63:28c:0:b0:3c1:6f72:7288 with SMTP id 134-20020a63028c000000b003c16f727288mr20944597pgc.564.1652824158752;
        Tue, 17 May 2022 14:49:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFRaJHRhJXW+NlcWgRYb1ZX8nbWLYzxvz7dw+TpR3frqC/TXLT78HphRw94kHWN9sl0aOfQA==
X-Received: by 2002:a63:28c:0:b0:3c1:6f72:7288 with SMTP id 134-20020a63028c000000b003c16f727288mr20944580pgc.564.1652824158489;
        Tue, 17 May 2022 14:49:18 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id p186-20020a62d0c3000000b005180c127200sm232127pfg.24.2022.05.17.14.49.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 May 2022 14:49:18 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A0D765FDEE; Tue, 17 May 2022 14:49:17 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 97521A0B21;
        Tue, 17 May 2022 14:49:17 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [question] bonding: should assert dormant for active protocols like LACP?
In-reply-to: <de8d8ca4-4ead-0cef-1315-8764d93503c1@redhat.com>
References: <de8d8ca4-4ead-0cef-1315-8764d93503c1@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 17 May 2022 17:17:19 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4195.1652824157.1@famine>
Date:   Tue, 17 May 2022 14:49:17 -0700
Message-ID: <4196.1652824157@famine>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>So running the following script:
>
>--%<-----
> ip link add name link-bond0 type veth peer name link-end0
> ip link add bond0 type bond mode 4 miimon 100
> ip link set link-bond0 master bond0 down
> ip netns add n1
> ip link set link-end0 netns n1 up
> ip link set bond0 up
> cat /sys/class/net/bond0/bonding/ad_partner_mac
> cat /sys/class/net/bond0/operstate
>--%<-----
>
>The bond reports its operstate to be "up" even though the bond will never
>be able to establish an LACP partner. Should bonding for active protocols,
>LACP, assert dormant[0] until the protocol has established and frames
>actually are passed?
>
>Having a predictable operstate where up actually means frames will attempt
>to be delivered would make management applications, f.e. Network Manager,
>easier to write. I have developers asking me what detailed states for LACP
>should they be looking for to determine when an LACP bond is "up". This
>seems like an incorrect implementation of operstate and RFC2863 3.1.12.
>
>Does anyone see why this would be a bad idea?

	The catch with LACP is that it has a fallback, in that ports
that don't complete LACP negotiation go to "Solitary" state (I believe
this was called "Individual" in older versions of the 802.1AX / 802.3ad
standard; bonding calls this "is_individual" internally).

	If there is no suitable partnered port, then a Solitary port is
made active.  This permits connectivity if one end is set for LACP but
the other end is not (e.g., PXE boot to a switch port set for LACP).
For reference, I'm looking at 6.3.5 and 6.3.6 of IEEE 802.1AX-2020.

	So, how should operstate be set if "has LACP partner" isn't
really the test for whether or not the interface is (to use RCC 2863
language) "in a condition to pass packets"?  In your example above, I
believe the bond should be able to pass packets just fine, the packets
just won't go anywhere after they leave the bond.

	-J

>-Jon
>
>[0] Documentation/networking/operstates.rst
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
