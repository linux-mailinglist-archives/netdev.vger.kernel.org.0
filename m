Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E456B9D45
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjCNRph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCNRpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:45:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14747AA70F;
        Tue, 14 Mar 2023 10:45:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A72181F37E;
        Tue, 14 Mar 2023 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678815931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hInEgkm+AFEBSizkAKBzMZHSNbriKfmk/Sip+Qqpx4=;
        b=Sqjig8Sov83YvviS6TgSDFW2oQn9DLANn0Dx06ifViij+WW14JokHSHfU5HV44+rDuYdFH
        WlOBG3QJEAVFAPwfvPPvbCbV9D9hGxddGuf0Itd1cESuaUN7MsXwxwhZxYh3Ls379elJ7A
        lpoqeHgcf8EuujMNgYrtwMi1zqKda98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678815931;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hInEgkm+AFEBSizkAKBzMZHSNbriKfmk/Sip+Qqpx4=;
        b=MTkeI4FjsATiWQ1UP2V7DmMKNHgloQAXfZ4NRAx1lv8WonDGE8SvJxqFQxPhGdI/SZrFyd
        ceFQgZgEC6O6jQDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84B5013A1B;
        Tue, 14 Mar 2023 17:45:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5tWsH7uyEGR7EAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 17:45:31 +0000
Message-ID: <81e3d1f1-26c4-0fd3-7c99-00de4d8d9f12@suse.de>
Date:   Tue, 14 Mar 2023 18:45:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 7/9] iscsi: convert flashnode devices from bus to
 class
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <e4f5405384b984cff51acfc6d36f49f0dd924a3e.1675876735.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <e4f5405384b984cff51acfc6d36f49f0dd924a3e.1675876735.git.lduncan@suse.com>
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
> The flashnode session and connection devices should be filtered by net
> namespace along with the iscsi_host, but we can't do that with a bus
> device.  As these don't use any of the bus matching functionality, they
> make more sense as a class device anyway.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
>   drivers/scsi/scsi_transport_iscsi.c | 36 ++++++++++++-----------------
>   include/scsi/scsi_transport_iscsi.h |  2 ++
>   3 files changed, 18 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


