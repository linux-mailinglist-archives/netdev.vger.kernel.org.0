Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA2A53F24C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 01:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiFFXBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiFFXBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 19:01:11 -0400
Received: from mail-pf1-x461.google.com (mail-pf1-x461.google.com [IPv6:2607:f8b0:4864:20::461])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257FB9CCB3
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 16:01:09 -0700 (PDT)
Received: by mail-pf1-x461.google.com with SMTP id j6so13876767pfe.13
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 16:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:to:subject:user-agent
         :content-transfer-encoding:message-id:from;
        bh=z4aVwej7juJX7SBqujxN7wR8+kjJALLXek/yHbHolH0=;
        b=MwvpUwD9cVPFsqYS5Zmq7UJEa5pF1YFSFtDCRlbU8UWb/3XEZTb+oPd/rXzUmc+MX0
         P9Ua8/9Pum1BX+Av7bBLQrOfo+Bf1THYj4PlfEzAhCzyCAM4b2su7o0SkyJCjoZS+C8t
         Z+oJXGJSXW3SB9L0e/MbfN0eoBI2dWekqbFcNDoZaPTUK8PqYRLlRttSOI/iOvV9zKQL
         cGdMrZsOHmNg3VJh2wSW4d77ac8pOFQQQb5CUkS7nLIJjlVTaZi0hYtJ7PYbMRN6lLkY
         O4bv6aQYUko4OEHyJLVOVgDIa+pCGVlH8VO8/pQiStbOeNDddAoyCKrcutsNUiq7yHDK
         KG5w==
X-Gm-Message-State: AOAM533egChZwqC6ashQMAFlG1M/nMpCzdBNjogyAeZju2irtnLy9iPG
        d46dP0PA1C6q4PYfhCRNkfH9m+5YZhnWsp9/b07S5q+MpJGW
X-Google-Smtp-Source: ABdhPJzkeeFmeWZyDKSlAh8weNb5tobm3hCQ7eO8+2BBvV0BFjewsELyDyX/GF2FdTrN20EQEky94xMOzmxG
X-Received: by 2002:a05:6a00:164c:b0:50a:472a:6b0a with SMTP id m12-20020a056a00164c00b0050a472a6b0amr26626996pfc.77.1654556468579;
        Mon, 06 Jun 2022 16:01:08 -0700 (PDT)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id u11-20020a170902b28b00b001677a0bc1a1sm425735plr.51.2022.06.06.16.01.08
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jun 2022 16:01:08 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from us226.sjc.aristanetworks.com (us226.sjc.aristanetworks.com [10.243.208.9])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 296AA416A26;
        Mon,  6 Jun 2022 16:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1654556468;
        bh=z4aVwej7juJX7SBqujxN7wR8+kjJALLXek/yHbHolH0=;
        h=Date:To:Subject:From:From;
        b=PZsPeJGSbqft6EXJEAn3EPJW01o457kuY9A6aU8RCIkv0zmgAgIbXDGWLQt+2tMnb
         q4wJkHhlTnDhGJwMOTg2jr7w8v9C8YW9Xpkah8N9CVxS1VzxHy/iLH86wBN2sBsEEO
         IH+eD4nPfWZgteoFRHB7iBN+pCpqRHdO4hVTyq3PUNHeElwKPoLhmA4+yMTPqcDSMp
         igfyHuJAWzikuEKXhKanNnBTnPZw6g7G5RwdvBHAQOx+2hf3tgj7hbwZ8dYMfLHdj5
         PS3oRVXveFvpUZXDLCYGshplFvC08YFlwk3cDPqpLoI1v9xjgBhA1xrWruFQPXEMM2
         hbN8Eyn9u+lpg==
Received: by us226.sjc.aristanetworks.com (Postfix, from userid 10189)
        id D70B55EC0B30; Mon,  6 Jun 2022 16:01:07 -0700 (PDT)
Date:   Mon, 06 Jun 2022 16:01:07 -0700
To:     netdev@vger.kernel.org, fruggeri@arista.com
Subject: neighbour netlink notifications delivered in wrong order
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have run into a race condition on a 4.19 kernel where netlink
notifications for a neighbour are queued in the wrong order on the
netlink socket.
This is one scenario, but I have also seen cases where the process
and softirq processing happens on the same cpu.
An Arp reply (or maybe garp, I am not sure) is received for a neighbour
while it is being deleted.

	CPU1			CPU2

rtnetlink_rcv_msg
neigh_delete
neigh_update
__neigh_notify(RTM_NEWNEIGH/NUD_FAILED)
__netlink_sendskb
			arp_rcv
			arp_process
			neigh_update
			__neigh_notify(RTM_NEWNEIGH/REACHABLE)
			__netlink_sendskb
			skb_queue_tail(&sk->sk_receive_queue, skb);
skb_queue_tail(&sk->sk_receive_queue, skb);

Is this a known issue?

Thanks,
Francesco Ruggeri


