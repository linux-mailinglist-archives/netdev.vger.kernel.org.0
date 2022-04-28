Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602875135BB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347775AbiD1NzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242095AbiD1NzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:55:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB4CB3DF5;
        Thu, 28 Apr 2022 06:51:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D4AA1210EE;
        Thu, 28 Apr 2022 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651153909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFrWyI3pnAaXT81fErIIpvt2wQOvd3gCUyoB7CnENBY=;
        b=KTa8ZgmaDnnB2alv1ZPLPdNAvU1N1/4jtghKJNzAvatRFtgpysCCEsn0eKxkY/XAm5hx66
        T4w8fr4e/6/JK8mi8o1B6feyupQfNRUgXV5mgOlj5aOYpZkv0kdYrRkIzCbU+La6X6Cj5J
        XyMh9xzC+z+9MegfHgoWSgJRu4+PV9I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651153909;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFrWyI3pnAaXT81fErIIpvt2wQOvd3gCUyoB7CnENBY=;
        b=P5rfx4tv3diQ+ps5/9JJimsubqW+dOzfLCLY1HqyvhrkiuBbtJYhDmKvigoGYgCiHxByrq
        L9/YccyDPcTvp4Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A57F313491;
        Thu, 28 Apr 2022 13:51:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SlLlJ/WbamIKVgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 28 Apr 2022 13:51:49 +0000
Message-ID: <be7e3c4b-8bb5-e818-1402-ac24cbbcb38c@suse.de>
Date:   Thu, 28 Apr 2022 15:51:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
 <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
 <20220426080247.19bbb64e@kernel.org>
 <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
 <20220426170334.3781cd0e@kernel.org>
 <23f497ab-08e3-3a25-26d9-56d94ee92cde@suse.de>
 <20220428063009.0a63a7f9@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
In-Reply-To: <20220428063009.0a63a7f9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 15:30, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 09:26:41 +0200 Hannes Reinecke wrote:
>> The whole thing started off with the problem on _how_ sockets could be
>> passed between kernel and userspace and vice versa.
>> While there is fd passing between processes via AF_UNIX, there is no
>> such mechanism between kernel and userspace.
> 
> Noob question - the kernel <> user space FD sharing is just
> not implemented yet, or somehow fundamentally hard because kernel
> fds are "special"?

Noob reply: wish I knew.
(I somewhat hoped _you_ would've been able to tell me.)

Thing is, the only method I could think of for fd passing is the POSIX 
fd passing via unix_attach_fds()/unix_detach_fds().
But that's AF_UNIX, which really is designed for process-to-process 
communication, not process-to-kernel.
So you probably have to move a similar logic over to AF_NETLINK. And 
design a new interface on how fds should be passed over AF_NETLINK.

But then you have to face the issue that AF_NELINK is essentially UDP, 
and you have _no_ idea if and how many processes do listen on the other 
end. Thing is, you (as the sender) have to copy the fd over to the 
receiving process, so you'd better _hope_ there is a receiving process.
Not to mention that there might be several processes listening in...

And that's something I _definitely_ don't feel comfortable with without 
guidance from the networking folks, so I didn't pursue it further and we 
went with the 'accept()' mechanism Chuck implemented.

I'm open to suggestions, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
