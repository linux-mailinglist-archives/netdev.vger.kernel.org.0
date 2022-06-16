Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB554E9AE
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiFPSxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiFPSxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:53:05 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFD120BD5
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 11:53:04 -0700 (PDT)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 703D93F8D6
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655405582;
        bh=giMnzHq6yPv/9Ts99cLkTm6sS8JvR9PMrHeHIMNiQX8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=MxeckODMlp4ajG6y6o6Nxqe5Crduq251KQsFjemtjejcOe6RhBk9LqGR3+Pm9AZ5B
         MDxOrAaVc0NtoPi9AcrTixxdlnTilrBpAeml6qudASIZpXSXhFlA5+Nz2QII1LV4KK
         l3L/RPJWvlOARtpZbNVwGqLUtR+G9zqSAXG5YkMsgemp8mDjdnZoPwm0UIq7YVPKGx
         HlkBitdXiU+Z/YJugRaqCjS7u4K6CpwheThCcxJHirFsRCJFmQSGEQ6bRU7k0LeDCC
         2L5PR7hgGay5+7xOwFbmUJ0s0vlIzXBLnH9AgBUnpwBj0frUalzIalgsKTb9zEB3HZ
         GbT8qMDMxUqYg==
Received: by mail-pj1-f69.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so1510558pjb.2
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 11:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=giMnzHq6yPv/9Ts99cLkTm6sS8JvR9PMrHeHIMNiQX8=;
        b=LVfOq3p+EJkDXqWlVtVvTvIr4oPyvXIKs9LlqTOMIK9afLsOcIOhKOcMBlWUYzDMX9
         aHJS2/ysk6Mo5UDon+65jHNJxY5aXyWRl1Zfoec+WsUlm5kMSIv5O0aBFsnUDSUHpyks
         JCnEU6peI/xefXjwF3OreTlqwIWN27USZC+qMrq0H0TM0qJog2YHWUsF7H+6vYx3cX60
         l7ZOKgAuoam622eCS4IYq7SRJJ8HI1lrkUxrPT6No0fxmycT3RIpXV/EIT3L9gBGzVQy
         Tp/lo6SARbQRpw5/kaTFWZmTq/DXytduPvSgGveG0NY4gEZrFVH/DooMj+ksX5UpmTP1
         Ysnw==
X-Gm-Message-State: AJIora/D7EVWbbZ3u5GmJQ3QwWIVmM34elrLH2baXEnu2cDolddxNK1a
        vmvrBW1/5R36KmuMB6Oj+2E1a8MV4YHS9fLYnuj4CjsNen0NBs5SeTe1zYAiz0cHCfQd/dDhwj8
        6rg08dB12sAXY0z+UGLDirWhdQK8+dwUvkw==
X-Received: by 2002:a63:784a:0:b0:408:c36e:db35 with SMTP id t71-20020a63784a000000b00408c36edb35mr5518889pgc.484.1655405581192;
        Thu, 16 Jun 2022 11:53:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ujdO0WuqiBfCtM7VGzxHrpxM/ahWAxjZiAdSoitalXQkR7BC38F4BO3tmeaBirs0OcYAhIPg==
X-Received: by 2002:a63:784a:0:b0:408:c36e:db35 with SMTP id t71-20020a63784a000000b00408c36edb35mr5518874pgc.484.1655405580834;
        Thu, 16 Jun 2022 11:53:00 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902eac500b00161f9e72233sm1965366pld.261.2022.06.16.11.53.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 11:53:00 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 10D1A6093D; Thu, 16 Jun 2022 11:53:00 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 09176A0B36;
        Thu, 16 Jun 2022 11:53:00 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: Any reason why arp monitor keeps emitting netlink failover events?
In-reply-to: <2db298d5-4e3d-0e99-6ce7-6a4a0df4bb48@redhat.com>
References: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com> <10584.1655220562@famine> <0ea8519c-4289-c409-2e31-44574cdefde3@redhat.com> <8133.1655252763@famine> <2db298d5-4e3d-0e99-6ce7-6a4a0df4bb48@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Wed, 15 Jun 2022 11:51:16 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6431.1655405579.1@famine>
Date:   Thu, 16 Jun 2022 11:52:59 -0700
Message-ID: <6432.1655405579@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

[...]
>Now this exposes an easily reproducible bonding issue with
>bond_should_notify_peers() which is every second the bond issues a
>NOTIFY_PEERS event. This notify peers event issue has been observed on
>physical hardware (tg3, i40e, igb) drivers. I have not traced the code
>yet, wanted to point this out. Run the same reproducer script and start
>monitoring the bond;
>
>[root@fedora ~]# ip -ts -o monitor link dev bond0
>[2022-06-15T11:30:44.337568] 9: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-15T11:30:45.361381] 9: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd
>ff:ff:ff:ff:ff:ff
[...]

	This one is pretty straightforward; the ARP monitor logic never
decrements the counter for the number of notifications to send (but the
change active logic decrements once, so a failover makes it stop if the
number of notifications to send is one).  I'll submit a patch in a bit.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
