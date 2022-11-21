Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144ED632F28
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiKUVoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKUVns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:43:48 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB62183A8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:43:33 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d123so9629663iof.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ImVe+g+b+10JJjRyFbVg3VQDLgN59Ue/Abv7vaFmseQ=;
        b=OHO4FjaPJmimqdrzS/OkstIvhocxCz1emkoHfOdBnFW624ABdZXIGpUr2qg1Kuoid7
         jQ3zRS/xznKzGtwvpkBw8YcBHanbAjUGKtSMJ92a5WUJdkI77H4tBot4cVhu32vyccdd
         iMTMhCXmKhazzg9UmrMMNr5aOJxLl31QLMnEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ImVe+g+b+10JJjRyFbVg3VQDLgN59Ue/Abv7vaFmseQ=;
        b=zyZhQb4MAM2fq7wYsv0lzZm7T3xdB8nCrKnWZf4WSH+TPORkx3JCZflOfLD/U7PC19
         Ok3sSANTmqHDB5yTmqqQ0yY8DVimB0F/mPozCk8mb8Sp+ZL1OC2qd4NT6N156Z+RGoUm
         nqcU+CpB5w00fdGkyT/XRhYv0d2fne1yuwt0l6IXwW/DxI2JOgeF+WBUiTicZBf3tqP4
         xqi7ia/TwaPjHjAPIVfYwxhTAlUdlIXAH7j4u+o7FgJY2+cfBuk4VaaYe8ylZu0TGfmt
         1j+27kHUnsXOFH1yAB6vQvejbUh2f+QdV49c1jRBdTwzutPuFxzSdtRFTtkGK4lfbU9x
         BCOQ==
X-Gm-Message-State: ANoB5pnlQsIRz2OoW1WeKFlPvnFrwOSmV+7tinn+tDAik6ApXYNNzxpC
        NHiduAwq3jxOtOwUBNGjQt1bZw==
X-Google-Smtp-Source: AA0mqf7f7poc1w7ewSMxS1++ciq574fA83Q7zTNUSYFoHm3cWPyzQwbrRSPhTjg/tqVe+6wU++ijsA==
X-Received: by 2002:a5d:9c0d:0:b0:6de:e346:27d4 with SMTP id 13-20020a5d9c0d000000b006dee34627d4mr639526ioe.138.1669067012402;
        Mon, 21 Nov 2022 13:43:32 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p5-20020a92c105000000b00302a7165d9bsm3672008ile.53.2022.11.21.13.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 13:43:31 -0800 (PST)
Message-ID: <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 14:43:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v1 2/3] Treewide: Stop corrupting socket's task_frag
Content-Language: en-US
To:     Benjamin Coddington <bcodding@redhat.com>,
        David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-nvme@lists.infradead.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, v9fs-developer@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
 <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 14:40, Shuah Khan wrote:
> On 11/21/22 07:34, Benjamin Coddington wrote:
>> On 21 Nov 2022, at 8:56, David Howells wrote:
>>
>>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>>
>>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>>> when it is safe to use current->task_frag.
>>>
>>> Um, what's task_frag?
>>
>> Its a per-task page_frag used to coalesce small writes for networking -- see:
>>
>> 5640f7685831 net: use a per task frag allocator
>>
>> Ben
>>
>>
> 
> I am not seeing this in the mainline. Where can find this commit?
> 

Okay. I see this commit in the mainline. However, I don't see the
sk_use_task_frag in mainline.

thanks,
-- Shuah

