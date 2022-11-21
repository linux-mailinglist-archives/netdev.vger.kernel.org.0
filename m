Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5476E632EFA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiKUVlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiKUVlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:41:17 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65962D3280
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:41:01 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p184so9601885iof.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+xfYS/683CuEX8Moz7DN5D+iq5a+HRddPc04OAxt08=;
        b=Tmrax2HtLx9acijQh4ktOiCFNspYBm9czQO9vC+hgh16yhXiq5RyvSKc/8X48Yn6bo
         htTajxPPiW0Lsmr5jl6ZJh1+6V/m5ChitgOSpS6KBQ7ll5X5P1skZcbsej2h/DApNnIq
         u0xC1JtTdPPMF5q+wPkS1LuhqaXUemqkmRceA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+xfYS/683CuEX8Moz7DN5D+iq5a+HRddPc04OAxt08=;
        b=dQ+rQfChckSQua6uhilGNmJgONHHraCaqctreatwOMDNkqS/jRL4KDHh/ZDEl/0BMq
         W71g4XTyotyCK9qAT3l9tjnMZDKY1KU4lfe3Scc/AZgGjheYloR1jd1MRcNu7HUXP6TC
         DG73uRk19OuGvKGlokP/9Z0BRf6J5yKWeZ0MSBQkbUwsKnNoecjUIYrFAwCcJg6V3fd0
         zK2v07A2etelJ3mSWbPPgZEzPTzg2fiybfPhyDZZ8dAeeWRQNDvvwYdpjA6yWSs2CpS8
         51zGMxL9WNmRw/zhuLbd0QB0ioP05Yyv4b9HyiJvWePyiVA6j2CGWw1OB/JVSJw0bnBD
         gnhA==
X-Gm-Message-State: ANoB5pnjQt6t9z5AkqgYzNBV7IvCrZmnkh/J4A5d6CPrt0aJdnQoZFam
        qGLG+odsgAvbA4D+5nZzeiZMtQ==
X-Google-Smtp-Source: AA0mqf4lOq6werVuvT/Ru0/037+ZZBKwQ9dV2Uvyt9oiXBE03aeSGMACS9M8fMwvTL7wgcvnDkeJPA==
X-Received: by 2002:a05:6638:3786:b0:363:b82d:d510 with SMTP id w6-20020a056638378600b00363b82dd510mr9070708jal.112.1669066860689;
        Mon, 21 Nov 2022 13:41:00 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w11-20020a056638024b00b0037609ad8485sm4704611jaq.69.2022.11.21.13.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 13:40:59 -0800 (PST)
Message-ID: <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 14:40:56 -0700
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
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 07:34, Benjamin Coddington wrote:
> On 21 Nov 2022, at 8:56, David Howells wrote:
> 
>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>
>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>> when it is safe to use current->task_frag.
>>
>> Um, what's task_frag?
> 
> Its a per-task page_frag used to coalesce small writes for networking -- see:
> 
> 5640f7685831 net: use a per task frag allocator
> 
> Ben
> 
> 

I am not seeing this in the mainline. Where can find this commit?

thanks,
-- Shuah
