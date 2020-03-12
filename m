Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2046F182BAF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 09:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCLI64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 04:58:56 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:56306 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 04:58:56 -0400
Received: by mail-pj1-f67.google.com with SMTP id mj6so2146495pjb.5;
        Thu, 12 Mar 2020 01:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kseNNsx2pgHvPyYxObU40X+5wxcbgZFilTTG78IMqS4=;
        b=pJ6Rh4QcTq373FX7O740x9ngwJovg4bNa+ruWhc+Gsx4x6n6Z5p8mFiZtKMebHdeK2
         AxRI8jt+Vj1OopakGjw2Dp8j8fVxpmrV92nRnPmzrMIldQcCSZ+nMxsyWCEYWNLYDXhw
         l6PKz9AK+6cGT/3s0SaOW+58iqdfoeDNi50NZ9VNAE8SEUF98XituF8inDwy+4dQWCvR
         Y6j3l9J1BtxT9v2iTO2E32FJJv5M5kknnpUYsDg8oQsIe+zPir0wm4TuGfz33VLA6ujG
         fG9RExzq1tY0EzyV5WQ0Me3y1rLtsFpHUdn5IdMzWdgM5V2Rmb6auxqbw/RZz6U+vDPB
         50eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kseNNsx2pgHvPyYxObU40X+5wxcbgZFilTTG78IMqS4=;
        b=UqFICZExZEOg9kj6bSAsnuFkkrJE5jjIowde19QGcQGOkDYJx5tAbZedCywshnvX/l
         iMW0hIyGXph0hI+Ll82PHsDwYt6cGPjzHd7aWIU6uj2DJdpNoIZ2GblgAItqSHQY9M7S
         FD3exH2eo6VQzsjHFKrFc04sOmbNsu9mNgVTVb6hiyZ+Y66qZgJ4KJyW/uanOZQvyhq5
         Q9O9sl2VQGiyQ+TtIhM7/xinCKg18q0QcJU+YyAZGjD2Z+3/mvUl7NX5FfzDxpzOmrpe
         z1abe9BoVRNHrpuR4xKcJ8/+gWyladbKNemtvReSg+6azlXF+V2XoVMla67tdwwUSPsA
         RTzg==
X-Gm-Message-State: ANhLgQ33Bj7MC9Y0CnNAqJrOXkQ0JqKUnVmgjduu8uNZTYwqJZpX01P1
        Iwz7yrVVyx9IVtijbHv583Y=
X-Google-Smtp-Source: ADFU+vukycXtGHoYcuotQ0VMk8rJ/gM3j14OTyZ1W99ibDvPzeKhBPuLDZuJRNvdUuz43vRH6qOV0g==
X-Received: by 2002:a17:90a:ead6:: with SMTP id ev22mr3212027pjb.66.1584003535239;
        Thu, 12 Mar 2020 01:58:55 -0700 (PDT)
Received: from [0.0.0.0] ([2001:19f0:8001:1c6b:5400:2ff:fe92:fb44])
        by smtp.googlemail.com with ESMTPSA id e28sm53152735pgn.21.2020.03.12.01.58.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 01:58:54 -0700 (PDT)
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     santosh.shilimkar@oracle.com
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        haakon.bugge@oracle.com
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
 <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
 <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
 <54d1140d-3347-a2b1-1b20-9a3959d3b451@oracle.com>
 <603ec723-842c-f6e1-01ee-6889c3925a63@gmail.com>
 <d9004325-2a97-c711-3abc-eb2550e047b1@oracle.com>
From:   zerons <sironhide0null@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a5990ab2-7d6b-8d5a-d461-8ad4bec104a4@gmail.com>
Date:   Thu, 12 Mar 2020 16:58:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d9004325-2a97-c711-3abc-eb2550e047b1@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/20 22:35, santosh.shilimkar@oracle.com wrote:
> On 3/10/20 9:48 PM, zerons wrote:
>>
>>
>> On 3/11/20 01:53, santosh.shilimkar@oracle.com wrote:
>>> On 3/6/20 4:11 AM, zerons wrote:
>>>>
>>>>
>>>> On 2/28/20 02:10, santosh.shilimkar@oracle.com wrote:
>>>>>
>>>>>>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>>>>>>
>>>>>>> Hi, all
>>>>>>>
>>>>>>> In net/rds/rdma.c
>>>>>>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>>>>>>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>>>>>>
>>>>> Hmmm.. I didn't see email before in my inbox. Please post questions/patches on netdev in future which is the correct mailing list.
>>>>>
>>>>>>> It seems that this one need some specific devices to run test,
>>>>>>> unfortunately, I don't have any of these.
>>>>>>> I've already sent two emails to the maintainer for help, no response yet,
>>>>>>> (the email address may not be in use).
>>>>>>>
>>>>>>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>>>>>>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>>>>>>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>>>>>>> call mr->r_trans->sync_mr().
>>>>>>>
>>> MR won't stay in the rbtree with force flag. If the MR is used or
>>> use_once is set in both cases its removed from the tree.
>>> See "if (mr->r_use_once || force)"
>>>
>>
>> Sorry, I may misunderstand. Did you mean that if the MR is *used*,
>> it is removed from the tree with or without the force flag in
>> rds_rdma_unuse(), even when r_use_once is not set?
>>
> Once the MR is being used with use_once semantics it gets removed with or without remote side indicating it via extended header. use_once
> optimization was added later. The base behavior is once the MR is
> used by remote and same information is sent via extended header,
> it gets cleaned up with force flag. Force flag ignores whether
> its marked as used_once or not.
> 

Sorry, I am still confused.

I check the code again. The rds_rdma_unuse() is called in two functions,
rds_recv_incoming_exthdrs() and rds_sendmsg().

In rds_sendmsg(), it calls rds_rdma_unuse() *with* force flag only when
the user included a RDMA_MAP cmsg *and* sendmsg() is failed.

In rds_recv_incoming_exthdrs(), the force is *false*. So we can consider
the rds_rdma_unuse() called *without* force flag.
Then I go check where r_use_once can be set.

__rds_rdma_map()
	rds_get_mr()
		rds_setsockopt()

	rds_get_mr_for_dest()
		rds_setsockopt()

	rds_cmsg_rdma_map()
		rds_cmsg_send()
			rds_sendmsg()

It seems to me that r_use_once is controlled by user applications.

I also wonder if we can ensure that the MR found in rds_rdma_unuse()
gets removed, then "if (mr->r_use_once || force)" doesn't make any sense.

Sorry to keep bothering you with my questions. I wish I had such a device 
that I can test it on.

Best regards,
