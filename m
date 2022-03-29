Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732314EA4F6
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiC2CQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiC2CQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6550662DE;
        Mon, 28 Mar 2022 19:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D058B81607;
        Tue, 29 Mar 2022 02:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17534C340EC;
        Tue, 29 Mar 2022 02:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648520064;
        bh=7fW0qiBX6nf6aqmiYTUKl8IZVghKod9oKgapNiJVVvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R6ZFmTkoeFLrWXHirerVB3/ekSSKk0h9CqMcFF9I1cpcnFF9Ck0bqt6gBRyIxNiXa
         7laoaN3FENWYbNJ4tpYm9oCK0KPR3oHQrTNlPF58bHZvuoSp69Oi+vEbmuP9zUzom2
         yHqf9Iy8E43EYtmi17uKmDgQQtVb0wAcwIyWQ3RZ5Mtt5Uxza7dYZkvSPuBOuxy/NG
         oqzPFHeZN3XGjbcNKQCgAjXUcYI4fDvsvzv2FC/4FIoYjQyd/6QEa3EHy6ywHRucul
         jTF7f7DKZ7foVRYAezETdnl/zwzhkdRXvuZ4oHBuOYIYeooac6zrTsT216HSsyPR6x
         YUDal7RhJ7www==
Date:   Mon, 28 Mar 2022 19:14:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net-next 0/1] veth: Support bonding events
Message-ID: <20220328191422.2acecf5f@kernel.org>
In-Reply-To: <20220328081417.1427666-1-wintera@linux.ibm.com>
References: <20220328081417.1427666-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 10:14:16 +0200 Alexandra Winter wrote:
> In case virtual instances are attached to an external network via veth
> and a bridge, the interface to the external network can be a bond
> interface. Bonding drivers generate specific events during failover
> that trigger switch updates.  When a veth device is attached to a
> bridge with a bond interface, we want external switches to learn about
> the veth devices as well.

Can you please add an ASCII diagram of a setup your trying to describe?

> Without this patch we have seen cases where recovery after bond
> failover took an unacceptable amount of time (depending on timeout
> settings in the network).
> 
> Due to the symmetric nature of veth special care is required to avoid
> endless notification loops. Therefore we only notify from a veth
> bridgeport to a peer that is not a bridgeport.
> 
> References:
> Same handling as for macvlan:
> 4c9912556867 ("macvlan: Support bonding events"
> and vlan:
> 4aa5dee4d999 ("net: convert resend IGMP to notifier event")

When sending a single patch change you can put all the information 
in the commit message of the patch, the cover letter is only necessary
for series of multiple patches.
