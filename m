Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6FB6183B3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiKCQHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiKCQGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:06:24 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B10318397
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:04:03 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AAE454132D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1667491441;
        bh=wA5TimkKHu/2G3U5fQfL4GAyx/idgDQqFW/QvzF4ryc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=OMiW7Jj6Xc0nv+3kop6+KYMU8pw2hEImV4RZsLB+ubdeMT/ntv7jXxfM0cHXbbXDL
         6dUTdmsr3u6nLtWjWSEEU00ACjh+Gy8bZ/svILf+Jr3itRuEhK2xEaPfKClgHWrm1m
         Sy8fmkUtVMbPC0MfQxwnfFjJu1I3oCRxiaYZkGNOHO/OG28LKt8KBdjDilnLGd3TGP
         sed7KqKoVfT7HrsQJzxjpPtAvQ6xYOdTmt7onwncGARr8RzWgCu+zee32eMGIItNRH
         KuI4wKShzG4qaW3R0ZRkofLQL040ItgKm6HKc1uz4SdWGGL/csd8Xfoet18q7wtGEO
         EuBkdg7kN7wwA==
Received: by mail-ed1-f70.google.com with SMTP id l18-20020a056402255200b004633509768bso1684158edb.12
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wA5TimkKHu/2G3U5fQfL4GAyx/idgDQqFW/QvzF4ryc=;
        b=uaUi3Rmipz+oglpRkTBm5NYg21chB6pcV9n5xfejvY6+/eZbC+NVFeauljKY56UMmg
         bu9drwyEYQdg4Am5T1hYMxX0PW+Vi+rohItE8bbNgPF2jXYKQBjKLgIyNSmHT1REkuRP
         KIsTLSxKMk8/jiCpRDHCF/IWtIlabh72wjGz1fZaFoa2j553Tby7c9usTDPsYCpnyuIw
         j4PACIErCHCMpUV9AshB1HudhVGvszR69LXI04pjQqb2kzMAioNztcmcPZ00euenXrlR
         k0XzSyD3RNScaQ5YlenQ1XvO2ftoUT0xJxWamZX1RRW/35ai9lusKv5MlwL0pobsBfpa
         FJKA==
X-Gm-Message-State: ACrzQf0fqFcPAfA3gW1TcOwMAtCiMfLJQPaGDCAwtRO7RD7h77R8JCRx
        RLlYinmrc3O8qf2GNJMXNz3rPmMJhE8ifyqMaYtrDVBCDcDt3rrCpbATvJYUWP+LXAKsAJh/o+1
        ljLPNpC3TLHgx3N61jRUQQw7xGHblI6uYhg==
X-Received: by 2002:a17:907:783:b0:76e:f290:8b5 with SMTP id xd3-20020a170907078300b0076ef29008b5mr30159850ejb.395.1667491441370;
        Thu, 03 Nov 2022 09:04:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7WfYPZSb9GfqUyIt0T2kjRC8x80cFnMHX3aFh1usFdJBm1zMYD42oLcDaxc2rkWnr71VTaVg==
X-Received: by 2002:a17:907:783:b0:76e:f290:8b5 with SMTP id xd3-20020a170907078300b0076ef29008b5mr30159836ejb.395.1667491441172;
        Thu, 03 Nov 2022 09:04:01 -0700 (PDT)
Received: from vermin.localdomain ([213.29.99.90])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906308100b0073d71792c8dsm629769ejv.180.2022.11.03.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:04:00 -0700 (PDT)
Received: by vermin.localdomain (Postfix, from userid 1000)
        id 6E5941C9AFD; Thu,  3 Nov 2022 09:03:59 -0700 (PDT)
Received: from vermin (localhost [127.0.0.1])
        by vermin.localdomain (Postfix) with ESMTP id 6C5B91C9AEC;
        Thu,  3 Nov 2022 17:03:59 +0100 (CET)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <Y2EqgyAChS1/6VqP@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com> <72467.1667297563@vermin> <Y2Ehg4AGAwaDRSy1@Laptop-X1> <Y2EqgyAChS1/6VqP@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Tue, 01 Nov 2022 22:17:39 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <171897.1667491439.1@vermin>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 03 Nov 2022 17:03:59 +0100
Message-ID: <171898.1667491439@vermin>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Tue, Nov 01, 2022 at 09:39:22PM +0800, Hangbin Liu wrote:
>> > 	I don't understand this explanation, as ipv6_gro_receive() isn't
>> > called directly by the device drivers, but from within the GRO
>> > processing, e.g., by dev_gro_receive().
>> > =

>> > 	Could you explain how the call paths actually differ?  =

>> =

>> Er..Yes, it's a little weird.
>> =

>> I checked if the transport header is set before  __netif_receive_skb_co=
re().
>> The bnx2x driver set it while be2net does not. So the transport header =
is reset
>> in __netif_receive_skb_core() with be2net.
>> =

>> I also found ipv6_gro_receive() is called before bond_handle_frame() wh=
en
>> receive NA message. Not sure which path it go through. I'm not very fam=
iliar
>> with driver part. But I can do more investigating.

	I suspect that what you're seeing is caused by bnx2x calling
skb_set_transport_header() in bnx2x_gro_ipv6_csum() to explicitly set
the transport header for IPv6, and benet having no equivalent call.  If
benet were to set the transport header, I think it would happen in
be_rx_compl_process_gro().

	__netif_receive_skb_core() calls skb_reset_transport_header() if
the transport header isn't set, but I presume that doesn't do the right
thing for ICMPv6.

	I don't believe there's any expectation that drivers must set
the transport header at this point, so I tentatively think that what
your patch is trying to do is reasonable.

	Briefly looking at the patch, the commit message needs updating,
and I'm curious to know why pskb_may_pull can't be used.

	-J

>With dump_stack(), it shows bnx2x do calls ipv6_gro_receive().
>PS: I only dump the stack when receive NA.
>
>[   65.537605]  dump_stack_lvl+0x34/0x48
>[   65.541695]  ipv6_gro_receive.cold+0x1b/0x3d
>[   65.546453]  dev_gro_receive+0x16c/0x380
>[   65.550831]  napi_gro_receive+0x64/0x210
>[   65.555206]  bnx2x_rx_int+0x44c/0x820 [bnx2x]
>[   65.560100]  bnx2x_poll+0xe5/0x1d0 [bnx2x]
>[   65.564687]  __napi_poll+0x2c/0x160
>[   65.568579]  net_rx_action+0x296/0x350
>
>Thanks
>Hangbin

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
