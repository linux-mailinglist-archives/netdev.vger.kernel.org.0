Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895BB6B9B38
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCNQWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCNQWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:22:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777B7D535;
        Tue, 14 Mar 2023 09:21:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F4771F8B4;
        Tue, 14 Mar 2023 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678810811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMm8wGU9lKPlT+0A0cGn5WagEyZwDalHzp2AUlTmDSc=;
        b=apwyjtcp/EVS9dM6ody3LL2t8knoB8nIEkBvA1pxqiwOzz/rW7kYmGzKTPhl6qX+N60bfc
        09kxa5qPRbE7T+TegyInkr0K+RoQXwJHbs8O7989KUl6LHWBfiqoYciRCyA0l76BK4A2TM
        FlyoVXbV21z0S2oLgnsWPb6tlTHCnL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678810811;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMm8wGU9lKPlT+0A0cGn5WagEyZwDalHzp2AUlTmDSc=;
        b=tsgGseOXY4Gd4cEIMivm3EcJCLye24yO236m81+SJPybZDJP79Q5z92hu2ZEUvoNIGPYM7
        TOBcwBkuYF19m3BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 25FBE13A26;
        Tue, 14 Mar 2023 16:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I35UCLueEGS9YAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 16:20:11 +0000
Message-ID: <bc73fcf1-d679-ec43-8235-b6342f78c1ba@suse.de>
Date:   Tue, 14 Mar 2023 17:20:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/9] Make iscsid-kernel communications namespace-aware
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <cover.1675876731.git.lduncan@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 18:40, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> This is a request for comment on a set of patches that
> modify the kernel iSCSI initiator communications so that
> they are namespace-aware. The goal is to allow multiple
> iSCSI daemon (iscsid) to run at once as long as they
> are in separate namespaces, and so that iscsid can
> run in containers.
> 
> Comments and suggestions are more than welcome. I do not
> expect that this code is production-ready yet, and
> networking isn't my strongest suit (yet).
> 
> These patches were originally posted in 2015 by Chris
> Leech. There were some issues at the time about how
> to handle namespaces going away. I hope to address
> any issues raised with this patchset and then
> to merge these changes upstream to address working
> in working in containers.
> 
> My contribution thus far has been to update these patches
> to work with the current upstream kernel.
> 
> Chris Leech/Lee Duncan (9):
>    iscsi: create per-net iscsi netlink kernel sockets
>    iscsi: associate endpoints with a host
>    iscsi: sysfs filtering by network namespace
>    iscsi: make all iSCSI netlink multicast namespace aware
>    iscsi: set netns for iscsi_tcp hosts
>    iscsi: check net namespace for all iscsi lookup
>    iscsi: convert flashnode devices from bus to class
>    iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
>    iscsi: filter flashnode sysfs by net namespace
> 
>   drivers/infiniband/ulp/iser/iscsi_iser.c |   7 +-
>   drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
>   drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
>   drivers/scsi/iscsi_tcp.c                 |   7 +
>   drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
>   drivers/scsi/qla4xxx/ql4_os.c            |  64 +--
>   drivers/scsi/scsi_transport_iscsi.c      | 625 ++++++++++++++++-------
>   include/scsi/scsi_transport_iscsi.h      |  63 ++-
>   9 files changed, 537 insertions(+), 253 deletions(-)
> 
Awesome work!

Thanks for this!

Comments to follow on the individual patches.

Cheers,

Hannes
