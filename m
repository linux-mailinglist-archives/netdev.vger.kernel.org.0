Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DDB21BF23
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGJVUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgGJVUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:20:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688ABC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 14:20:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7E7C12866F0E;
        Fri, 10 Jul 2020 14:20:54 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:20:54 -0700 (PDT)
Message-Id: <20200710.142054.1540339072424385806.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        jtoppins@redhat.com, feliu@redhat.com
Subject: Re: [PATCH net] bnxt_en: fix NULL dereference in case SR-IOV
 configuration fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
References: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:20:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 10 Jul 2020 12:55:08 +0200

> we need to set 'active_vfs' back to 0, if something goes wrong during the
> allocation of SR-IOV resources: otherwise, further VF configurations will
> wrongly assume that bp->pf.vf[x] are valid memory locations, and commands
> like the ones in the following sequence:
> 
>  # echo 2 >/sys/bus/pci/devices/${ADDR}/sriov_numvfs
>  # ip link set dev ens1f0np0 up
>  # ip link set dev ens1f0np0 vf 0 trust on
> 
> will cause a kernel crash similar to this:
 ...
> Fixes: c0c050c58d840 ("bnxt_en: New Broadcom ethernet driver.")
> Reported-by: Fei Liu <feliu@redhat.com>
> CC: Jonathan Toppins <jtoppins@redhat.com>
> CC: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied and queued up for -stable, thanks.
