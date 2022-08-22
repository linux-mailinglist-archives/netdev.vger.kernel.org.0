Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E1D59CA48
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbiHVUnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbiHVUnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:43:19 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67210B6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:43:15 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8EC493F805
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661200993;
        bh=Qts39Mg4jjDHGuttlbfQ5Yrda0JS+j1aF+odznqo+PU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=m0R+41wozdwBaFzBuk4S/tXsY0RABZRzDF6L/62SU/tiEpLF4go93aBMW5lMe8fTU
         1EPKZ3AQn5YakrmcucTVktHJhBg41i1IWeWBsPLZb4ckFfeJg91MqVzJ23Q8A5Lcqx
         E1Q3Mo8xPcInB2a1ovgnwYsn22SBiUhWo5hQuCY/SnVBpvTBnH15GjoVI4Bxrhb4ii
         ndhSbMt0dyW8ntmZhB//E3PIEnYbeyErYeByCStO/arAI5npNqKoX2WtLqR2h7xdAu
         2wlCE/4lFDd4RLedfVb6vifRmGmctnC3HCDvDRq+D96hxheg8EAAiP6Y/Aw7tzLLt5
         lVvhB+kngN/CA==
Received: by mail-pj1-f72.google.com with SMTP id na5-20020a17090b4c0500b001fb464b4761so30679pjb.1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=Qts39Mg4jjDHGuttlbfQ5Yrda0JS+j1aF+odznqo+PU=;
        b=i9cDB8wArXQmzblIWY6pyzOBMNSp6+Gk+ntLBF+JDBU7S45MXihGObMD555z6gakGl
         bhX6t8azxLB0na2UeSEap8g95UM8OkrJDOqoLtRgsSlRrnl6zoyqtIH8Wj7N1tfcMwmn
         jODR2bmhVDpQPZWKiITWwKEl9Fh1ACoaAATRpJF5XZEXZ3U/v3Fr8rkXhK8wkvQoF+qs
         bhYw2OjrqexT27dVsazy0ymbWnxr4MoJ/aRM+jnGz2ZRLKSum/wHY33EL1mak7frlStz
         rdg9ziV4cmCMImKi89Ox0I5oP/2d7+P4J6H/UVEq6O/E7wLGZNQSnAtcRBJ/oQgFWQEh
         U3SQ==
X-Gm-Message-State: ACgBeo2fIQHCb4jPK1jZXtgzMqlVOMrj1PfoDavTov8KQoLtucT4d2ru
        ixzugtqya0focxcs5MZI4t6vjmRMch5hPxE2n7A+4K7fcOvLMkjyag5QFhi6mCbhiNCpOEr88j/
        aNsuPv9CeBO5gsY1w9r6hpgETcwtYWcUbgA==
X-Received: by 2002:a17:90b:1c89:b0:1f8:42dd:5ebb with SMTP id oo9-20020a17090b1c8900b001f842dd5ebbmr126556pjb.246.1661200991945;
        Mon, 22 Aug 2022 13:43:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Xc8GhE3ET/KjinL8c28unOQOQ+RkAmMqYBYSlQXPa9/OlFIUA4aTUAsurIzrqikMtKTfQXg==
X-Received: by 2002:a17:90b:1c89:b0:1f8:42dd:5ebb with SMTP id oo9-20020a17090b1c8900b001f842dd5ebbmr126526pjb.246.1661200991616;
        Mon, 22 Aug 2022 13:43:11 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id l7-20020a63ba47000000b0040caab35e5bsm4628767pgu.89.2022.08.22.13.43.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Aug 2022 13:43:11 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id DD0226118F; Mon, 22 Aug 2022 13:43:10 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D6DC49FA79;
        Mon, 22 Aug 2022 13:43:10 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH] bonding: Remove unnecessary check
In-reply-to: <20220822103130.3466-1-sunshouxin@chinatelecom.cn>
References: <20220822103130.3466-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Mon, 22 Aug 2022 03:31:29 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14666.1661200990.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 22 Aug 2022 13:43:10 -0700
Message-ID: <14667.1661200990@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>This check is not necessary since the commit d5410ac7b0ba
>("net:bonding:support balance-alb interface with vlan to bridge").

	Please explain why this assertion is correct in your commit
message.

	Also, I presume this is for net-next; please specify in the
PATCH block of the Subject.

	-J

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_main.c | 13 -------------
> 1 file changed, 13 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 50e60843020c..6b0f0ce9b9a1 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1578,19 +1578,6 @@ static rx_handler_result_t bond_handle_frame(struc=
t sk_buff **pskb)
> =

> 	skb->dev =3D bond->dev;
> =

>-	if (BOND_MODE(bond) =3D=3D BOND_MODE_ALB &&
>-	    netif_is_bridge_port(bond->dev) &&
>-	    skb->pkt_type =3D=3D PACKET_HOST) {
>-
>-		if (unlikely(skb_cow_head(skb,
>-					  skb->data - skb_mac_header(skb)))) {
>-			kfree_skb(skb);
>-			return RX_HANDLER_CONSUMED;
>-		}
>-		bond_hw_addr_copy(eth_hdr(skb)->h_dest, bond->dev->dev_addr,
>-				  bond->dev->addr_len);
>-	}
>-
> 	return ret;
> }
> =

>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
