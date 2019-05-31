Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4EE3124E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEaQ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:27:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42043 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:27:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id r22so6498334pfh.9;
        Fri, 31 May 2019 09:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5z7/0pNszPVIhFomXqZmyP9TIVQJErGRUKJ0k9x44PQ=;
        b=sMW4jgMZppC9TgopFkPIgSv37t1JFvNITJclRlFPioq+77lVMTCppVoLz7uz+UmM6Y
         153AV+893frJGLvOocQArfzjBQ2OGP2GQp12QD2JAA7T9UJel2/M95lhBBjT99tJR4gr
         EnYm5yg5/PHQQP7Z3PltJ35DLaKtPaRNK0dAoHn3NhPxhdfIFq3Ko3kyFlIRhuPTRoVd
         V3HEPWX+mdcWkbKs8AcKlTIXCGBnxFEmroZIznoOjMesViDt7daoCujubFYUMOQKvx4U
         uDHc/YGOtq13MoIYxcUfw5Wv+v2ePrv6quJCPQwYDXZudPooJrlwpxsEZiQTkwkypqzx
         o12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z7/0pNszPVIhFomXqZmyP9TIVQJErGRUKJ0k9x44PQ=;
        b=eR09h+l8ixkeS/Fnv2Kyt/H9pq40SmagwWiEiEcAw3ATzYVGr8EptLWqtHZkBwvc6O
         6xvc53MVwJJs293iCvgnYsQgLniZ9djrU9lDfPsyR6ROmzuSFDl9bxYuE1Vs+vPDCegv
         Cxc/Xtq7WIdfGk0W4jy4NTzL9nAqWXG9C58/3cDp9B19/EGjqvRr5GEVn3mXdZNvBcwV
         +DMVzzFUfN5K8c3xQojp9UeZvlR5F68HsOAUCPW5CRqg3axsGlnKi3IS0B0kZ2/GeJgD
         CUH7i3FNIL/Tc9Mi1/actzQUu1/tWRdsMwABSBnsoL1jDv4v08rKtLtHBoSidMvEmQHJ
         lZmg==
X-Gm-Message-State: APjAAAXOWoS5UJcXAx9Y583gHNHBSEexQyTfOh9wavIy07rf25DWTAE8
        D7QYGGyBPfaEPMQj0dE29oY=
X-Google-Smtp-Source: APXvYqy3BSamUqerjdpmyW/SNw9DUMYaUi0od6VlzBdn4OHv0TA9dCoCFw3qmQuiUpqxmJg1iAPDFA==
X-Received: by 2002:aa7:8a11:: with SMTP id m17mr11314805pfa.122.1559320028433;
        Fri, 31 May 2019 09:27:08 -0700 (PDT)
Received: from [172.26.115.243] ([2620:10d:c090:180::779])
        by smtp.gmail.com with ESMTPSA id r7sm10008150pjb.8.2019.05.31.09.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:27:07 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        kernel-team@fb.com, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Date:   Fri, 31 May 2019 09:27:06 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <4AC230DE-6529-4798-BE32-C0AD873855CB@gmail.com>
In-Reply-To: <5fde46e3-1967-d802-d1db-f02d15d11aa4@intel.com>
References: <20190530185709.1861867-1-jonathan.lemon@gmail.com>
 <5fde46e3-1967-d802-d1db-f02d15d11aa4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 May 2019, at 4:49, Björn Töpel wrote:

> On 2019-05-30 20:57, Jonathan Lemon wrote:
>> Currently, the AF_XDP code uses a separate map in order to
>> determine if an xsk is bound to a queue.  Instead of doing this,
>> have bpf_map_lookup_elem() return the queue_id, as a way of
>> indicating that there is a valid entry at the map index.
>>
>> Rearrange some xdp_sock members to eliminate structure holes.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>   include/net/xdp_sock.h                            |  6 +++---
>>   kernel/bpf/verifier.c                             |  6 +++++-
>>   kernel/bpf/xskmap.c                               |  4 +++-
>>   .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 ---------------
>>   4 files changed, 11 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index d074b6d60f8a..7d84b1da43d2 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -57,12 +57,12 @@ struct xdp_sock {
>>   	struct net_device *dev;
>>   	struct xdp_umem *umem;
>>   	struct list_head flush_node;
>> -	u16 queue_id;
>> -	struct xsk_queue *tx ____cacheline_aligned_in_smp;
>> -	struct list_head list;
>> +	u32 queue_id;
>
> Why the increase of size?

Currently xskmaps are defined as size=4, so the returned pointer for
bpf must have that many bytes.  I was kicking around the idea of using
a union and returning { qid, zc }, but Alexei pointed out that doesn't
make a good API.

Besides, queue_index in struct xdp_rxq_info is already a u32.
-- 
Jonathan

