Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38361610
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 20:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGGSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 14:40:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33962 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfGGSkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 14:40:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so1874406pfo.1
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 11:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LNc09ge9aBw78vF0pr3wTYMi03Q3EEsH+DlIgcuV2lI=;
        b=U4Cuo/8+oimQF9HrZieEC0AnKrEf26rHMuKeBCuMZN+KeGlYFr9M5O0pTO5nZyvDhq
         Ix9kIksDSgZnP9vVkGwhMbdaMqionrlcnGgHdW2LdUM7ijynLyvFlowEszxwI4Iuk8pW
         gBYcgqcduRJLrvcQM8s4Y4J2vr+UE/nT0Dg4lOsHxETg7yflaMdNyDDwgvKeaALzQhFV
         9hjtUvfPCGUuL3RF6wU2Sy5d4wqsDtaChr6qmnZxOSYKkm8VVak+byDhXXJ6gfzoEb5m
         28vswgR+kuTdRN1OwLVOGZgBhKJDrhLhZXKzbsk+NTHWZG01WL0SXg/nqyJwbCugXKGR
         SFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LNc09ge9aBw78vF0pr3wTYMi03Q3EEsH+DlIgcuV2lI=;
        b=QsPKevcM8YPMaTExA4YrAxY1Mi0hghjUjb8e1c1NjCU/+FH0vG2/4rgL0e8R42NFUg
         oD3TaeyYaJFZ7+NL55U+WNc8QJFvRbOeHA9p0Q1lSqFrQ5t1lO3Re0cRfgaH2OGg13jD
         yblS+2oY/ZMxRmSzv3iXnLVYliWlS+JEQRisNtMDVDy9PJYF19U2upXKLhQ6zA8+IbEy
         IEFiRonY88mWRNhY+sQ6FClzFBbRWb1ONlZIFDzZax9QKw8uXESWAB8ibAncj0VOd7/j
         qhnZ8HJ19zJmXKg2tRR86b3QCdCYGuzIBnIv0dtJ09a2zxTRY4KjyEBmwWbaKtOanbj2
         TV7g==
X-Gm-Message-State: APjAAAWTPWk4S7XzcttKmP2T1keKHDbuZNE2YX6RrvWsLkCaLGrGosDA
        UbgS2nOJPVsVnOqE05sqKADKWPXIiVo=
X-Google-Smtp-Source: APXvYqyyNkz+wf8B1C1VY1SgD1kv9w1Hh1mx9HGSaxCy84elbBJ8chSBxaP+4Yd+iac45985RjBTpg==
X-Received: by 2002:a63:f510:: with SMTP id w16mr19031206pgh.0.1562524844997;
        Sun, 07 Jul 2019 11:40:44 -0700 (PDT)
Received: from xps13.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w7sm15768527pfb.117.2019.07.07.11.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 07 Jul 2019 11:40:44 -0700 (PDT)
Date:   Sun, 7 Jul 2019 11:40:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: bond: add peer notification delay
 support
Message-ID: <20190707114041.4f068bee@xps13.lan>
In-Reply-To: <20190707175115.3704-1-vincent@bernat.ch>
References: <20190707094141.1b98f3f4@hermes.lan>
        <20190707175115.3704-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Jul 2019 19:51:15 +0200
Vincent Bernat <vincent@bernat.ch> wrote:

> Ability to tweak the delay between gratuitous ND/ARP packets has been
> added in kernel commit 07a4ddec3ce9 ("bonding: add an option to
> specify a delay between peer notifications"), through
> IFLA_BOND_PEER_NOTIF_DELAY attribute. Add support to set and show this
> value.
> 
> Example:
> 
>     $ ip -d link set bond0 type bond peer_notify_delay 1000
>     $ ip -d link l dev bond0
>     2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     state UP mode DEFAULT group default qlen 1000
>         link/ether 50:54:33:00:00:01 brd ff:ff:ff:ff:ff:ff
>         bond mode active-backup active_slave eth0 miimon 100 updelay 0
>     downdelay 0 peer_notify_delay 1000 use_carrier 1 arp_interval 0
>     arp_validate none arp_all_targets any primary eth0
>     primary_reselect always fail_over_mac active xmit_hash_policy
>     layer2 resend_igmp 1 num_grat_arp 5 all_slaves_active 0 min_links
>     0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select
>     stable tlb_dynamic_lb 1 addrgenmode eu
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

Looks good. I notice that all these flags don't show up in any man page.

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
