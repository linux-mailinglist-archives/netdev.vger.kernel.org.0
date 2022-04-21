Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D83F509940
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385875AbiDUHim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385849AbiDUHie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:38:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DA310B1;
        Thu, 21 Apr 2022 00:35:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9AFA21F753;
        Thu, 21 Apr 2022 07:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650526544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5J/d+SM7KHL9BwwpEelR22zLqcl+L3PD3ZatS4fmTLU=;
        b=cAb1NvX9EPQRjHLDGalKC2jKWS2yvR5AqagsSmTe/QiyCyeeFIoxFQNsdOr+42kA+6e8GH
        Hwl5MgrKv4sJFhYj03IBoKpdDr7BL/FAb5ZcAorOFWSmwHin8G/UwlZ7XvDjQfZvFvgvZn
        UYVyJOPLSv/4ou4fpkAHp6ztRcWrUKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650526544;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5J/d+SM7KHL9BwwpEelR22zLqcl+L3PD3ZatS4fmTLU=;
        b=6CPPkWYj7r3kuQRcRa41jhwfeLW7pMs++61sJes7hTzz11ie/PUcC/YhaIWG8vejWSt/0w
        D1GweOfeRzxDzqDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C79413A84;
        Thu, 21 Apr 2022 07:35:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8SfeGFAJYWKvEQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 21 Apr 2022 07:35:44 +0000
Message-ID: <437ef42d-1c7e-5140-d89f-66bd1ab7293c@suse.de>
Date:   Thu, 21 Apr 2022 09:35:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC 3/5] net/tls: Add an AF_TLSH address family
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030058340.5073.5461321687798728373.stgit@oracle-102.nfsv4.dev>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <165030058340.5073.5461321687798728373.stgit@oracle-102.nfsv4.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/22 18:49, Chuck Lever wrote:
> Add definitions for an AF_TLSH address family. The next patch
> explains its purpose and operation.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   include/linux/socket.h                         |    4 +++-
>   net/core/sock.c                                |    2 +-
>   net/socket.c                                   |    1 +
>   security/selinux/hooks.c                       |    4 +++-
>   security/selinux/include/classmap.h            |    4 +++-
>   tools/perf/trace/beauty/include/linux/socket.h |    4 +++-
>   6 files changed, 14 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
