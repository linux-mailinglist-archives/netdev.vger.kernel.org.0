Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7256254FB52
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383394AbiFQQnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383393AbiFQQnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:43:01 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7812AEC
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:42:59 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 62D1D3FC12
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655484178;
        bh=w2QkeXu0zMTbME5HaSJXMRmAa5SiQhl01ubZT4gunvE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Q197zgh+FnU6xGWSt5CtuATe4V+p2xpsy3tYLklO+IqKQNDxZdWvoqinoqPWjjgZE
         ceYaZjFXxg4j19THZk2GRZCq4amKWZeZOxGXUD6LL4AiCmZsUpVai3Pp0UCmz8YVSR
         +Tk8EsfUe7StNpDwuOSiWMHFNXm8Q12HDnt0adqUTdUmtdfWtxD9jVXRSpTzn+DugF
         bt7EkTAq1EEI7UHGePzuGdulRelELtD1cwK/fnerFmWtIp6O9tsXZ5bMlJXz4EnP4J
         4x1bj71dbnS7o4s6PfPWB4Jwk+1zNrLcXvNIMzkfZbCQQiHV7ZZ743ebXSBEz2T8Qo
         MNxBVCH+4eKdg==
Received: by mail-pj1-f71.google.com with SMTP id u9-20020a17090a2b8900b001ec79a1050eso1080104pjd.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:42:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=w2QkeXu0zMTbME5HaSJXMRmAa5SiQhl01ubZT4gunvE=;
        b=xsIgiG8c7LdB+flWmTu2DvvqM2SaEoObPi0LYdbpoDkt8HrMcKKHseQZ0DlsdW+Z7v
         pLJeRDpLKTzEsV12sP4JpEg5ZCpfEY85Xl0qRcAzyPUXzEbDfh5Nd1ASnQOmK3e6yw0W
         2ELvT9GiitrzBVXAc9BVWhKbqNW5erAwsX0Z68R8A58q2ln5560pnZA9M6bvjLUNAdtf
         4Co9rSTeGzwTe4faX7HR9rurclKJOjMjQ/eUlQmxfloW92fYfszQkRbozPAdYSPrMH/k
         BnK42JKFfHqlv54Qk1aQH4hfqHRMHdUAnwcnV8mo9j1jYDoBw3yTDByCjhoGLB7oXOho
         pZHg==
X-Gm-Message-State: AJIora/hVFQfxHSHyaxqMn9JjNA7aFdFAi8uDxBS6MG3tDITF58/yrX3
        JL2qtUtJXS/yFgjP+AFOokvg5RDmvpmn5AiHVsUjyY2HdmW2NRVVyozFnJJn2pq9Lx0HqtU+eEO
        Edi2r0o8YBygFfpjDzI8I+OFKJPkxPN/Vkw==
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id c18-20020a056a000ad200b004f12734a3d9mr10966018pfl.61.1655484177017;
        Fri, 17 Jun 2022 09:42:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vmDbgjjOfQxy2wwhMOfWvpGiIye1Npw7UNvXIfo68Txi12ei841SqUXWzTSo7nd78i2CSzTA==
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id c18-20020a056a000ad200b004f12734a3d9mr10965989pfl.61.1655484176717;
        Fri, 17 Jun 2022 09:42:56 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id g17-20020a639f11000000b004085adf1372sm3915323pge.77.2022.06.17.09.42.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jun 2022 09:42:56 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A6E856093D; Fri, 17 Jun 2022 09:42:55 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A0DB5A0B36;
        Fri, 17 Jun 2022 09:42:55 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
In-reply-to: <20220617084535.6d687ed0@kernel.org>
References: <9088.1655407590@famine> <20220617084535.6d687ed0@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Fri, 17 Jun 2022 08:45:35 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5764.1655484175.1@famine>
Date:   Fri, 17 Jun 2022 09:42:55 -0700
Message-ID: <5765.1655484175@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Thu, 16 Jun 2022 12:26:30 -0700 Jay Vosburgh wrote:
>> 	Since commit 21a75f0915dd ("bonding: Fix ARP monitor validation"),
>> the bonding ARP / ND link monitors depend on the trans_start time to
>> determine link availability.  NETIF_F_LLTX drivers must update trans_start
>> directly, which veth does not do.  This prevents use of the ARP or ND link
>> monitors with veth interfaces in a bond.
>
>Why is a SW device required to update its trans_start? trans_start is
>for the Tx hang watchdog, AFAIK, not a general use attribute. There's
>plenty of NETIF_F_LLTX devices, are they all broken? 

	In this case, it's to permit the bonding ARP / ND monitor to
function if that software device (veth in this case) is added to a bond
using the ARP / ND monitor (which relies on trans_start, and has done so
since at least 2.6.0).  I'll agree it's a niche case; this was broken
for veth for quite some time, but veth + netns is handy for software
only test cases, so it seems worth doing.

	I didn't exhaustively check all LLTX drivers, but, e.g., tun
does update trans_start:

drivers/net/tun.c:

       /* NETIF_F_LLTX requires to do our own update of trans_start */
        queue = netdev_get_tx_queue(dev, txq);
        txq_trans_cond_update(queue);

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
