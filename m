Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E6E6B9B3A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCNQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjCNQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:22:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBA483DB;
        Tue, 14 Mar 2023 09:22:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D0AE921DDD;
        Tue, 14 Mar 2023 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678810898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhRbYtHZMpwO8/vJpp6XFG49+84U78NFWeqB+NtGZ8c=;
        b=tKMRiJj6AaOAafhjAgTcUusVdJlkaZoMVs6rwTT+GSx91QpEB7rkIRa1I6+bLigRl+9KPp
        JcBVorYIXseleeIL3gtAXJ0Rc7MQ60qPRyYWKPybqmff/8evQ+3gwwd/KhoE9sHE2GQVio
        ZpHB5Yscal67249tppm9bQBsUzpPB90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678810898;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhRbYtHZMpwO8/vJpp6XFG49+84U78NFWeqB+NtGZ8c=;
        b=1F6AucFzNNQXbJst9r4oVX5Ly/wsLyGo+GX/nLU8McgJXD5JqT9TRs1n+7ivZsonvVATS+
        hZ8oL4VQW0/VKsCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEC1113A26;
        Tue, 14 Mar 2023 16:21:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aMwDKhKfEGR+YQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 16:21:38 +0000
Message-ID: <b867f388-df15-df08-349e-4c80aabec5a7@suse.de>
Date:   Tue, 14 Mar 2023 17:21:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 1/9] iscsi: create per-net iscsi netlink kernel
 sockets
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <95df16a252bc2c9f0e7fba667d2f542814c9b91b.1675876733.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <95df16a252bc2c9f0e7fba667d2f542814c9b91b.1675876733.git.lduncan@suse.com>
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
> Prepare iSCSI netlink to operate in multiple namespaces.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 73 +++++++++++++++++++++++++----
>   1 file changed, 63 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

