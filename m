Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901996B9B4B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCNQZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjCNQZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:25:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0217C974B;
        Tue, 14 Mar 2023 09:24:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5BA8A1F8B4;
        Tue, 14 Mar 2023 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678811049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2yCT+hn3LOVwZ3gEgePdUHNGzzfSdkH+Xu/nGZDXQvM=;
        b=Nzbsj5gRoYYMrz42Ebk4uQvCrQRqBYzlFemYere2iWhhiYvFr5XnJXNcO4QS4Oj4tke4rU
        /TsWuMwJn2RMixe2094+kKriUdgJyXrV4ag4TVNqRNd3X4aYx1q9CvgtQG2sTEC3vfcN2W
        sQ2t7zTIPX1/tXu40JAtTuxhOqX3sck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678811049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2yCT+hn3LOVwZ3gEgePdUHNGzzfSdkH+Xu/nGZDXQvM=;
        b=Th14VlwnG6BrHfgBWxgd5jhDNVBMJGuPesYIoDTfU2Ti8ivjvzPYCo6eIHvDBS+ph3D6hi
        D4zKVU1LLAJjRICw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AEAE13A26;
        Tue, 14 Mar 2023 16:24:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vhGyDamfEGS7YgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 16:24:09 +0000
Message-ID: <e71a718e-9d36-095a-9c7b-ea7761fe486a@suse.de>
Date:   Tue, 14 Mar 2023 17:24:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 3/9] iscsi: sysfs filtering by network namespace
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Lee Duncan <lduncan@gmail.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <1ce0ef45c40b6873f2889bbcdc1a74d7fc04e370.1675876734.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <1ce0ef45c40b6873f2889bbcdc1a74d7fc04e370.1675876734.git.lduncan@suse.com>
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
> This makes the iscsi_host, iscsi_session, iscsi_connection, iscsi_iface,
> and iscsi_endpoint transport class devices only visible in sysfs under a
> matching network namespace.  The network namespace for all of these
> objects is tracked in the iscsi_cls_host structure.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@gmail.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 124 ++++++++++++++++++++++++----
>   include/scsi/scsi_transport_iscsi.h |   1 +
>   2 files changed, 110 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


