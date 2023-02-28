Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7550A6A5344
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 07:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjB1G6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 01:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjB1G61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 01:58:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CC093FF
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 22:58:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 553841FDBE;
        Tue, 28 Feb 2023 06:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677567497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F1iQKicBKRquStjA5qCV6KAsCxOVyxupNpyDt/LgelY=;
        b=ohHJd9Wivmcz1psi/DG7A4zoouyafZrX0A/nWLR+zvT4hs4OOnbPtPSqZo5uh7ELsP86uQ
        TPLw1/HCL2lYjthqw0Tb/hxl3NAUit+tWe2znANgdCeUllhDk5cArg2O62LxJZmRn4l7rW
        F6xv1MSMBdw8B+OH2gAb3rnK4QDN3/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677567497;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F1iQKicBKRquStjA5qCV6KAsCxOVyxupNpyDt/LgelY=;
        b=svNmg1OQMj+Qe8/YvFl+5R1Z2v1veNEZbt4oLX0F7c2BO9W3QkqWk+XYRG+6wTe2bODbVx
        Y83MCSiFplpCywDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D49513440;
        Tue, 28 Feb 2023 06:58:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ghGUHQim/WP3cQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 28 Feb 2023 06:58:16 +0000
Message-ID: <b9c3e5aa-c7e1-08dd-8a1b-00035f046071@suse.de>
Date:   Tue, 28 Feb 2023 07:58:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
 <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
 <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
 <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 19:10, Chuck Lever III wrote:
> 
> 
>> On Feb 27, 2023, at 12:21 PM, Hannes Reinecke <hare@suse.de> wrote:
>>
>>> On 2/27/23 16:39, Chuck Lever III wrote:
>>>> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> Problem here is with using different key materials.
>>>> As the current handshake can only deal with one key at a time
>>>> the only chance we have for several possible keys is to retry
>>>> the handshake with the next key.
>>>> But out of necessity we have to use the _same_ connection
>>>> (as tlshd doesn't control the socket). So we cannot close
>>>> the socket, and hence we can't notify userspace to give up the handshake attempt.
>>>> Being able to send a signal would be simple; sending SIGHUP to userspace, and wait for the 'done' call.
>>>> If it doesn't come we can terminate all attempts.
>>>> But if we get the 'done' call we know it's safe to start with the next attempt.
>>> We solve this problem by enabling the kernel to provide all those
>>> materials to tlshd in one go.
>> Ah. Right, that would work, too; provide all possible keys to the
>> 'accept' call and let the userspace agent figure out what to do with
>> them. That makes life certainly easier for the kernel side.
>>
>>> I don't think there's a "retry" situation here. Once the handshake
>>> has failed, the client peer has to know to try again. That would
>>> mean retrying would have to be part of the upper layer protocol.
>>> Does an NVMe initiator know it has to drive another handshake if
>>> the first one fails, or does it rely on the handshake itself to
>>> try all available identities?
>>> We don't have a choice but to provide all the keys at once and
>>> let the handshake negotiation deal with it.
>>> I'm working on DONE passing multiple remote peer IDs back to the
>>> kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
>>> the other way.
>> Nope. That's not required.
>> DONE can only ever have one peer id (TLS 1.3 specifies that the client
>> sends a list of identities, the server picks one, and sends that one back
>> to the client). So for DONE we will only ever have 1 peer ID.
>> If we allow for several peer IDs to be present in the client ACCEPT message
>> then we'd need to include the resulting peer ID in the client DONE, too;
>> otherwise we'll need it for the server DONE only.
>>
>> So all in all I think we should be going with the multiple IDs in the
>> ACCEPT call (ie move the key id from being part of the message into an
>> attribute), and have a peer id present in the DONE all for both versions,
>> server and client.
> 
> To summarize:
> 
> ---
> 
> The ACCEPT request (from tlshd) would have just the handler class
> "Which handler is responding". The kernel uses that to find a
> handshake request waiting for that type of handler. In our case,
> "tlshd".
> 
> The ACCEPT response (from the kernel) would have the socket fd,
> the handshake parameters, and zero or more peer ID key serial
> numbers. (Today, just zero or one peer IDs).
>  > There is also an errno status in the ACCEPT response, which
> the kernel can use to indicate things like "no requests in that
> class were found" or that the request was otherwise improperly
> formed.
> 
> ---
> 
> The DONE request (from tlshd) would have the socket fd (and
> implicitly, the handler's PID), the session status, and zero
> or one remote peer ID key serial numbers.
>  > The DONE response (from the kernel) is an ACK. (Today it's
> more than that, but that's broken and will be removed).
> 
> ---
> 
> For the DONE request, the session status is one of:
> 
> 0: session established -- see @peerid for authentication status
> EIO: local error
> EACCES: handshake rejected
> 
> For server handshake completion:
> 
> @peerid contains the remote peer ID if the session was
> authenticated, or TLS_NO_PEERID if the session was not
> authenticated.
> 
> status == EACCES if authentication material was present from
> both peers but verification failed.
> 
> For client handshake completion:
> 
> @peerid contains the remote peer ID if authentication was
> requested and the session was authenticated
> 
> status == EACCES if authentication was requested and the
> session was not authenticated, or if verification failed.
> 
> (Maybe client could work like the server side, and the
> kernel consumer would need to figure out if it cares
> whether there was authentication).
> 
Yes, that would be my preference. Always return @peerid
for DONE if the TLS session was established.
We might also consider returning @peerid with EACCESS
to indicate the offending ID.

> 
> Is that adequate?
> 
Yes, it is.

So the only bone of contention is the timeout; as we won't
be implementing signals I still think that we should have
a 'timeout' attribute. And if only to feed the TLS timeout
parameter for gnutls ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

