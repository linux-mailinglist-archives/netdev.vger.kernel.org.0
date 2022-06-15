Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761AC54BEAC
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 02:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiFOA0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 20:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiFOA0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 20:26:11 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385442715B
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 17:26:10 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 235363F21E
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655252768;
        bh=4vyBoX0WHZu9teTZemB6rfOPTt881co0DZMPF1l8FnU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IvqxdsoenFsQgEMOLH+2Tl4vO3Gbnn3BozPmt8UHaxmJ3syoP+vaG8DpLmMGk/blO
         HhhHI7wDxt6/l9cmSWR8d63Gsas/NQKOArqrtR3jJX32MvaZczkxqs5ew8BPUTTsfn
         QhP9yOerwCVUfWL3xcfWIBRvoSzXkNOtdlHv69pOHfdyUidUk4m2VRKqBuN5qwMtge
         7pan1iUy32O4i2z15HvVcY9/9PERE5PTWQ288Vc+nDg0GEyymbkISrI3YM9WmUzXc3
         2b0p4o31xw3oRXPsD69M9ZBGLNsakvkld9Osc6cgZHzxD/38pSq4uG7HSISBULHAvi
         pm/Z6e1cVocDg==
Received: by mail-pl1-f200.google.com with SMTP id t24-20020a170902b21800b00168e27c3c2aso3650948plr.18
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 17:26:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=4vyBoX0WHZu9teTZemB6rfOPTt881co0DZMPF1l8FnU=;
        b=rAhrmou3N9me61izejAJbw3Wr3gR51rjXeDhxBbzZeWxVgpDZPll8bKnQ8WwxJpHdR
         5zE8sUvzD/aJ/Kdh17Hy0F3R24blEUPvheHIFZLEn09Xi9SDQurroMfHiarGjyjXlBkZ
         R4P/TtUkxxrOdek7agH7RKA/X0mQ/gfpO+qhpGlHcivpzY1rdgc/9u/5VS8SZTU1C29s
         LH5nFtDCoRNTJSX6qKhUAgjFKz4ajEQEPFk9VMeQ8SvpkqwrMLHq+g3+BKJ0J8465t9f
         EWfz/V/tfA9yw2q71StdVUc3lXm5uyI2yi68FY2w2LK6VRp62UtPuhW4U0xoeljIPZYJ
         c37Q==
X-Gm-Message-State: AOAM532sZq2v6+yL0lKR+x2yhoc6JgW6kqd3fphrphmNS1ktzWAPMLWB
        +pryVj3lqO1h+Obf2TVP20xsdwS5QUrzEXc+dbPHx+fzMemOKhC4Cn2zqR079svWW0RUO4tU0zN
        2jP95ZNWuT9cii78B3h1TkFAFc/SAml+6rw==
X-Received: by 2002:a05:6a00:1305:b0:512:ebab:3b20 with SMTP id j5-20020a056a00130500b00512ebab3b20mr7135573pfu.82.1655252766341;
        Tue, 14 Jun 2022 17:26:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww66F7z/4TDw+jQwYTBdpGAb5B0+tUSFUM1uyg818Izi5OOjGbjYMlbKmxE8As8uQyFp2aCA==
X-Received: by 2002:a05:6a00:1305:b0:512:ebab:3b20 with SMTP id j5-20020a056a00130500b00512ebab3b20mr7135476pfu.82.1655252764554;
        Tue, 14 Jun 2022 17:26:04 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902d90300b00163c0a1f718sm7828218plz.303.2022.06.14.17.26.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jun 2022 17:26:04 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AC4B96093D; Tue, 14 Jun 2022 17:26:03 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A6538A0B36;
        Tue, 14 Jun 2022 17:26:03 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: Any reason why arp monitor keeps emitting netlink failover events?
In-reply-to: <0ea8519c-4289-c409-2e31-44574cdefde3@redhat.com>
References: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com> <10584.1655220562@famine> <0ea8519c-4289-c409-2e31-44574cdefde3@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 14 Jun 2022 13:07:11 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8132.1655252763.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 14 Jun 2022 17:26:03 -0700
Message-ID: <8133.1655252763@famine>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On 6/14/22 11:29, Jay Vosburgh wrote:
>> Jonathan Toppins <jtoppins@redhat.com> wrote:
>> =

>>> On net-next/master from today, I see netlink failover events being emi=
tted
>>>from an active-backup bond. In the ip monitor dump you can see the bond=
 is
>>> up (according to the link status) but keeps emitting failover events a=
nd I
>>> am not sure why. This appears to be an issue also on Fedora 35 and Cen=
tOS
>>> 8 kernels. The configuration appears to be correct, though I could be
>>> missing something. Thoughts?
>> 	Anything showing up in the dmesg?  There's only one place that
>> generates the FAILOVER notifier, and it ought to have a corresponding
>> message in the kernel log.
>> 	Also, I note that the link1_1 veth has a lot of failures:
>
>Yes all those failures are created by the setup, I waited about 5 minutes
>before dumping the link info. The failover occurs about every second. Not=
e
>this is just a representation of a physical network so that others can ru=
n
>the setup. The script `bond-bz2094911.sh`, easily reproduces the issue
>which I dumped with cat below in the original email.
>
>Here is the kernel log, I have dynamic debug enabled for the entire
>bonding module:

	I set up the test, and added some additional instrumentation to
bond_ab_arp_inspect, and what seems to be going on is that the
dev_trans_start for link1_1 is never updating.  The "down to up"
transition for the ARP monitor only checks last_rx, but the "up to down"
check for the active interface requires both TX and RX recently
("recently" being within the past missed_max * arp_interval).

	This looks to be due to HARD_TX_LOCK not actually locking for
NETIF_F_LLTX devices:

#define HARD_TX_LOCK(dev, txq, cpu) {                           if ((dev->=
features & NETIF_F_LLTX) =3D=3D 0) {                      __netif_tx_lock(=
txq, cpu);                      } else {                                  =
                      __netif_tx_acquire(txq);                        }   =
                                            }

	in combination with

static inline void txq_trans_update(struct netdev_queue *txq)
{
        if (txq->xmit_lock_owner !=3D -1)
                WRITE_ONCE(txq->trans_start, jiffies);
}

	causes the trans_start update to be skipped on veth devices.

	And, sure enough, if I apply the following, the test case
appears to work:

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 466da01ba2e3..2cb833b3006a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -312,6 +312,7 @@ static bool veth_skb_is_eligible_for_gro(const struct =
net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
+	struct netdev_queue *queue =3D NULL;
 	struct veth_rq *rq =3D NULL;
 	struct net_device *rcv;
 	int length =3D skb->len;
@@ -329,6 +330,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
 	rxq =3D skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq =3D &rcv_priv->rq[rxq];
+		queue =3D netdev_get_tx_queue(dev, rxq);
 =

 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
@@ -340,6 +342,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
 =

 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) =3D=3D NET_RX_SUCCES=
S)) {
+		if (queue)
+			txq_trans_cond_update(queue);
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {


	I'm not entirely sure this is the best way to get the
trans_start updated in veth, but LLTX devices need to handle it
internally (and others do, e.g., tun).

	Could you test the above and see if it resolves the problem in
your environment as well?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
