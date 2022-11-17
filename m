Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA34C62E596
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiKQUET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbiKQUES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:04:18 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6B07EC9A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:04:16 -0800 (PST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 07AAC3F2FF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668715455;
        bh=ZmiqJnyvd6vTeVGZikratkIvf9N150GcNkMCZrfSuEo=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=MBEMRL/HfEgyyA0BMi/0sSnTR0iDeLH5Vr05YtZHtci/n+Lp+YhZNtY2N34VT8kVE
         1rUtLNa+tr2rLLiUoE7qo9EGSBBrCTRX4YYkovLoT/myZfw6pYlg+fZzPZoCSqfY6d
         IocU7DxZa3+hkRlPZ4YGCetAcwOnFzFaA2Hv6W8oDEaIE5xlyRlMCKRAMBe8Kh96no
         jgj9vS0+oJC+/xDSlzmU0Qt0SGLMZIJMk62MAnZrkujTuf/A8h9c1eHHGHSE++8/vf
         EWzdxTGBaC8RYIV6WII9Bg9jm+WdPNKyq0XJsCqrK2FbAkQqMylXS8ogDuMDrIS6XY
         Id9HRan8+/kfg==
Received: by mail-pf1-f197.google.com with SMTP id f19-20020a056a001ad300b0056dd07cebfcso1718115pfv.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:04:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmiqJnyvd6vTeVGZikratkIvf9N150GcNkMCZrfSuEo=;
        b=iG756xkTCWilZtHBkP3bCNcyWsaKiwdAwiO5uzAHbdpe7WhCyyybe3DOJF9ZVzZ4Bz
         tkfcGUGWJUbsucainr9u8AdAhybvz2pblRj5hNvN6Q7ctrnFHzijevwc0OfNxX28MJw+
         DaQc/+PFIY7GbOUJRGUmwnHBbX3IOO1o3c9yOOWYeaUThmlhKEQKBDXr9LcKNV6c0bPX
         jJoA+gFHheBGkTeHyQLzBo79+BxIgwTYSWWpAw/9HiLfy0nRHSajKxeYe25UfG3oY8dF
         /urjaRkoqC4oOh+Et6yicCZjvqb574ENG0UqpycRuXlpmY+V9cat8HBYl9+Qp0qnM7WX
         Gecw==
X-Gm-Message-State: ANoB5pm2ZDMG8ta8zcsGvRyHfcArww2Msy+9L9lff3hfU5zhl0516rxg
        9gvcVsLjzqaM2kFclVA5bsa5Z+pG4S9je8QhFRi/hq0VDDbD+/DUDUnxM51KYsWKWO09dkyxSp7
        Bu7LjcRatk/VT6+X0UHypFVrmaiS0j4Rifg==
X-Received: by 2002:a17:90b:3c42:b0:218:8186:ef9b with SMTP id pm2-20020a17090b3c4200b002188186ef9bmr979800pjb.10.1668715452662;
        Thu, 17 Nov 2022 12:04:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NXlZQbR9cTEr1lh1sFqAUlKbdXxWm8fX/B30XTMnL87Xll2P3S7LqaKjWQpVw5VFfYiCjfQ==
X-Received: by 2002:a17:90b:3c42:b0:218:8186:ef9b with SMTP id pm2-20020a17090b3c4200b002188186ef9bmr979776pjb.10.1668715452275;
        Thu, 17 Nov 2022 12:04:12 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id t19-20020a17090aae1300b002036006d65bsm1262411pjq.39.2022.11.17.12.04.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Nov 2022 12:04:11 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 26FFD5FF12; Thu, 17 Nov 2022 12:04:11 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 1FE109F890;
        Thu, 17 Nov 2022 12:04:11 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <Y3XyGIVnX2xvZ/bU@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com> <17540.1668026368@famine> <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com> <19557.1668029004@famine> <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com> <Y3SEXh0x4G7jNSi9@Laptop-X1> <17663.1668611774@famine> <Y3WgFgLlRQSaguqv@Laptop-X1> <22985.1668659398@famine> <Y3XyGIVnX2xvZ/bU@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 17 Nov 2022 16:34:32 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24153.1668715451.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 17 Nov 2022 12:04:11 -0800
Message-ID: <24154.1668715451@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Nov 16, 2022 at 08:29:58PM -0800, Jay Vosburgh wrote:
>> > #if IS_ENABLED(CONFIG_IPV6)
>> >-	} else if (is_ipv6) {
>> >+	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &i=
p6_hdr)) {
>> > 		return bond_na_rcv(skb, bond, slave);
>> > #endif
>> > 	} else {
>> >
>> >What do you think?
>> =

>> 	I don't see how this solves the icmp6_hdr() / ipv6_hdr() problem
>> in bond_na_rcv(); skb_header_pointer() doesn't do a pull, it just copie=
s
>> into the supplied struct (if necessary).
>
>Hmm... Maybe I didn't get what you and Eric means. If we can copy the
>supplied buffer success, doesn't this make sure IPv6 header is in skb?

	The header is in the skb, but it may not be in the linear part
of the skb, i.e., the header is wholly or partially in a skb frag, not
in the area covered by skb->data ... skb->tail.  The various *_hdr()
macros only look in the linear area, not the frags, and don't check to
see if the linear area contains the entire header.

	skb_header_pointer() is smart enough to check, and if the
requested data is entirely within the linear area, it returns a pointer
to there; if not, it copies from the frags into the supplied struct and
returns a pointer to that.  What it doesn't do is a pull (move data from
a frag into the linear area), so merely calling skb_header_pointer()
doesn't affect the layout of what's in the skb (which is the point,
bonding uses it here to avoid changing the skb).

	There may be better explanations out there, but

http://vger.kernel.org/~davem/skb_data.html

	covers the basics.  Look for the references to "paged data."

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
