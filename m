Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C767A6DD2B7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 08:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjDKGWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 02:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDKGWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 02:22:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B1783;
        Mon, 10 Apr 2023 23:22:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 999111FE01;
        Tue, 11 Apr 2023 06:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681194152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OjA+c0IfKROkLab2Lvjku2ojXGQXfcFSI21favAo5M=;
        b=t9/CwEwd6kKJh7lz7PD4lsDjbj93RKVA7mjBw7JsWnNooaLzxdqdYNcz+Wj/gk9UMG/Q7c
        /0wUogExUhm3fdlm8/8T45r6+yD39CzlhbDBJHvWMlnkRKBEOGibPs5S1AzQb3qzRH/ws0
        eQ4m4O6P5S5YCSySd4+Lnzz7ZJ6DEK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681194152;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OjA+c0IfKROkLab2Lvjku2ojXGQXfcFSI21favAo5M=;
        b=tkzy75TRDiH9tjl3chKlYceroU7tKYYbaD2LACm0er47hW7EcNEOI2IvaFHzN5VLvof79E
        +mCp/M080sdAlwBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6FE8713519;
        Tue, 11 Apr 2023 06:22:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b9o3Gqj8NGQPSgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:22:32 +0000
Message-ID: <f3c23291-2f77-4935-4e1c-a61cbe29241a@suse.de>
Date:   Tue, 11 Apr 2023 08:22:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 4/9] iscsi: make all iSCSI netlink multicast namespace
 aware
Content-Language: en-US
To:     Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, Lee Duncan <leeman.duncan@gmail.com>,
        netdev@vger.kernel.org
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
 <20230410191033.1069293-1-cleech@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230410191033.1069293-1-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 21:10, Chris Leech wrote:
>> As discussed with Lee: you should tear down sessions related to this
>> namespace from the pernet ->exit callback, otherwise you end up with
>> session which can no longer been reached as the netlink socket is
>> gone.
> 
> These two follow on changes handle removing active sesions when the
> namespace exits. Tested with iscsi_tcp and seems to be working for me.
> 
> Chris Leech (2):
>    iscsi: make session and connection lists per-net
>    iscsi: force destroy sesions when a network namespace exits
> 
>   drivers/scsi/scsi_transport_iscsi.c | 122 ++++++++++++++++++----------
>   1 file changed, 79 insertions(+), 43 deletions(-)
> 
Thanks a lot!
That's precisely what I had been looking for.

But you really shouldn't have mentioned iSCSI offloads; that was too 
large an opening to _not_ comment on :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

