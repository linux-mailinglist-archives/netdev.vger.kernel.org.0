Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93641E4E32
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgE0Tbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE0Tbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:31:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D239C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:31:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y13so7491326eju.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=3iP99u7MW7LTm3Pdh5bRsJ3IqZrIPpHpVGyoisVCKsU=;
        b=AjPKXFtQ2WSAX1TAxoqV85vpgz5xH97VjezmwwxoWgTMCCq8DjHRYLphJP1rAXlarn
         orfUkhp97c9IrH9ToW0h8GrMz13uSWqZJ70oWgnxHt8wx1D8QdjHO75wuUVfu21jVhZo
         znx4J8vz0UJ4pl2skNq5uEFDhmk7B3JBj+uto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=3iP99u7MW7LTm3Pdh5bRsJ3IqZrIPpHpVGyoisVCKsU=;
        b=TwtZYUULLHmZvgs3etGGlH1dfjQaQNKZL+nOz1/VWSnBiLf6MsGbICnd3nmjBAhTed
         07DETGyUbEVT5y/P13TX2vIheBSqcKceaK8s3fc30ciwjgPcmfk0c26eaEO9EpZWX4P0
         iFQOZ6SwdPWoQXBIhTg56IoDVF8zQ6gW1IdRJsCmOlwkJnLTPYqxcW7dC7fB2yqCf99U
         SwwGsHx9GGbX0PlsGU9hViBDa2xT5kXPFp20YrN6z2baa1bLrAqm+BP/y3mJHo1Uy2HK
         in1OsCEq9Tn8DQUMJXQpp01hHR0SKhHB6sfBHt+0xfA0x/spZohLStOutSXVznn5P5Jc
         8kBQ==
X-Gm-Message-State: AOAM531YvtqfLBk7LeyANgmKPJ8niU1vWNbnCdXUdmi0XXQ1KSd+d009
        NM50KFhWkvYe+3UoxsQ/6MyRrw==
X-Google-Smtp-Source: ABdhPJzv3AJ4zpOiPWvrhAIqoAxtjELfOueixe6KrwJQpm7ictkx5IKCchceOIpP3U/Wz4JG4rKixg==
X-Received: by 2002:a17:906:48ce:: with SMTP id d14mr5326982ejt.468.1590607908608;
        Wed, 27 May 2020 12:31:48 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v8sm2925796eds.20.2020.05.27.12.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 12:31:48 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-4-jakub@cloudflare.com> <20200527174036.GF49942@google.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 3/8] net: Introduce netns_bpf for BPF programs attached to netns
In-reply-to: <20200527174036.GF49942@google.com>
Date:   Wed, 27 May 2020 21:31:47 +0200
Message-ID: <87v9kh2mzg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 07:40 PM CEST, sdf@google.com wrote:
> On 05/27, Jakub Sitnicki wrote:
>> In order to:
>
>>   (1) attach more than one BPF program type to netns, or
>>   (2) support attaching BPF programs to netns with bpf_link, or
>>   (3) support multi-prog attach points for netns
>
>> we will need to keep more state per netns than a single pointer like we
>> have now for BPF flow dissector program.
>
>> Prepare for the above by extracting netns_bpf that is part of struct net,
>> for storing all state related to BPF programs attached to netns.
>
>> Turn flow dissector callbacks for querying/attaching/detaching a program
>> into generic ones that operate on netns_bpf. Next patch will move the
>> generic callbacks into their own module.
>
>> This is similar to how it is organized for cgroup with cgroup_bpf.
>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>   include/linux/bpf-netns.h   | 56 ++++++++++++++++++++++
>>   include/linux/skbuff.h      | 26 ----------
>>   include/net/net_namespace.h |  4 +-
>>   include/net/netns/bpf.h     | 17 +++++++
>>   kernel/bpf/syscall.c        |  7 +--
>>   net/core/flow_dissector.c   | 96 ++++++++++++++++++++++++-------------
>>   6 files changed, 143 insertions(+), 63 deletions(-)
>>   create mode 100644 include/linux/bpf-netns.h
>>   create mode 100644 include/net/netns/bpf.h
>
>> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
>> new file mode 100644
>> index 000000000000..f3aec3d79824
>> --- /dev/null
>> +++ b/include/linux/bpf-netns.h
>> @@ -0,0 +1,56 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _BPF_NETNS_H
>> +#define _BPF_NETNS_H
>> +
>> +#include <linux/mutex.h>
>> +#include <uapi/linux/bpf.h>
>> +
>> +enum netns_bpf_attach_type {
>> +	NETNS_BPF_INVALID = -1,
>> +	NETNS_BPF_FLOW_DISSECTOR = 0,
>> +	MAX_NETNS_BPF_ATTACH_TYPE
>> +};
>> +
>> +static inline enum netns_bpf_attach_type
>> +to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
>> +{
>> +	switch (attach_type) {
>> +	case BPF_FLOW_DISSECTOR:
>> +		return NETNS_BPF_FLOW_DISSECTOR;
>> +	default:
>> +		return NETNS_BPF_INVALID;
>> +	}
>> +}
>> +
>> +/* Protects updates to netns_bpf */
>> +extern struct mutex netns_bpf_mutex;
> I wonder whether it's a good time to make this mutex per-netns, WDYT?
>
> The only problem I see is that it might complicate the global
> mode of flow dissector where we go over every ns to make sure no
> progs are attached. That will be racy with per-ns mutex unless
> we do something about it...

It crossed my mind. I stuck with a global mutex for a couple of
reasons. Different that one you bring up, which I forgot about.

1. Don't know if it has potential to be a bottleneck.

cgroup BPF uses a global mutex too. Even one that serializes access to
more data than just BPF programs attached to a cgroup.

Also, we grab the netns_bpf_mutex only on prog attach/detach, and link
create/update/release. Netns teardown is not grabbing it. So if you're
not using netns BPF you're not going to "feel" contention.

2. Makes locking on nets bpf_link release trickier

In bpf_netns_link_release (patch 5), we deref pointer from link to
struct net under RCU read lock, in case the net is being destroyed
simulatneously.

However, we're also grabbing the netns_bpf_mutex, in case of another
possible scenario, when struct net is alive and well (refcnt > 0), but
we're racing with a prog attach/detach to access net->bpf.{links,progs}.

Making the mutex part of net->bpf means I first need to somehow ensure
netns stays alive if I go to sleep waiting for the lock. Or it would
have to be a spinlock, or some better (simpler?) locking scheme.


The above two convinced me that I should start with a global mutex, and
go for more pain if there's contention.

Thanks for giving the series a review.

-jkbs
