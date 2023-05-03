Return-Path: <netdev+bounces-75-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 477DB6F50A6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88FBC1C20A8F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A18111D;
	Wed,  3 May 2023 07:09:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAFDEBF
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:09:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE28269D
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683097738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pHJN0MwZt1Qkyg0FwWKVsL71HOfF8cRCNsnTVzqCki0=;
	b=D0/wd8rnEWmWlMr/XtAwPijjPgbMq3yz/a2EVkmuofSTffQGzLgpGF8mN/V2Jxn3wkdOyB
	5d3gacQGLWuGX6k6KvcUmopGW4FLfyRmQHYnAiy73XmV+Kas85MRoiu6d1EQRrLTHdUvRJ
	rHz1AFHTLD06s9XnbCrv+pJXicnhUJs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-1X6Zm6a-MdCcyfYQJuJoLA-1; Wed, 03 May 2023 03:08:57 -0400
X-MC-Unique: 1X6Zm6a-MdCcyfYQJuJoLA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3062b468a36so1091616f8f.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 00:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683097736; x=1685689736;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHJN0MwZt1Qkyg0FwWKVsL71HOfF8cRCNsnTVzqCki0=;
        b=lj9yeuiQhhX86u+EANSnlY0HEUDc+5zYhm3FdUd2bdw1j6bBnlp2Jp5J8IFak4dN8Y
         dSQN44bdjY/aAhvST2SnQMaJewCQb79fxnrpDswIUvtJOB14dPK/22KWN9OkuOomJLfz
         fHTeSkC/ww97VJXGFtuSgDVugQ5jSxIq8G7Hos6Z+9UCgwr2F8KnBS1RS4FL7asPQlNl
         5litco5HPMoYOAAQQEYddoZ8ltiAWTKX549QJTUsXZXS+Qcu8d4oIKCmhz3WBe5s3v46
         z5kB+6IG9LVVlUajqq4e6/Z0Gxg9maoxnhDjfpCUuLI6C/BPqFQORXW1p/6lkga5xDQc
         mRQQ==
X-Gm-Message-State: AC+VfDxqjTGNhNnpQWSlePkiSZ2aTHLZdOH3p678kLN9V76ZOqZfL7Ye
	WatNCLvgm8RaQeoOB+Zj7Pikh9M7ziwHBSmZqqURfolQmyr4fgGu3uHhLTM0hT8i3RBEhpNg7KR
	coTUdBiaG60gbEJh8
X-Received: by 2002:a5d:6410:0:b0:306:3a28:f950 with SMTP id z16-20020a5d6410000000b003063a28f950mr3061912wru.7.1683097735925;
        Wed, 03 May 2023 00:08:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7NT02o8A0M+QHO4dvjy7p83osecccZDAuDP/z0mhC15FeHFbBpxcPnSHMrIpl83AzT6cM6xQ==
X-Received: by 2002:a5d:6410:0:b0:306:3a28:f950 with SMTP id z16-20020a5d6410000000b003063a28f950mr3061838wru.7.1683097735470;
        Wed, 03 May 2023 00:08:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c711:6a00:9109:6424:1804:a441? (p200300cbc7116a00910964241804a441.dip0.t-ipconnect.de. [2003:cb:c711:6a00:9109:6424:1804:a441])
        by smtp.gmail.com with ESMTPSA id v2-20020a1cf702000000b003f32f013c3csm962580wmh.6.2023.05.03.00.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 00:08:54 -0700 (PDT)
Message-ID: <1b34e9a4-83c0-2f44-1457-dd8800b9287a@redhat.com>
Date: Wed, 3 May 2023 09:08:52 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Matthew Rosato <mjrosato@linux.ibm.com>,
 Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
 Matthew Wilcox <willy@infradead.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Leon Romanovsky <leon@kernel.org>, Christian Benvenuti <benve@cisco.com>,
 Nelson Escobar <neescoba@cisco.com>, Bernard Metzler <bmt@zurich.ibm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Bjorn Topel <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Christian Brauner <brauner@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
 bpf@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, "Kirill A . Shutemov" <kirill@shutemov.name>,
 Pavel Begunkov <asml.silence@gmail.com>, Mika Penttila
 <mpenttil@redhat.com>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <20d078c5-4ee6-18dc-d3a5-d76b6a68f64e@linux.ibm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v8 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
In-Reply-To: <20d078c5-4ee6-18dc-d3a5-d76b6a68f64e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03.05.23 02:31, Matthew Rosato wrote:
> On 5/2/23 6:51 PM, Lorenzo Stoakes wrote:
>> Writing to file-backed mappings which require folio dirty tracking using
>> GUP is a fundamentally broken operation, as kernel write access to GUP
>> mappings do not adhere to the semantics expected by a file system.
>>
>> A GUP caller uses the direct mapping to access the folio, which does not
>> cause write notify to trigger, nor does it enforce that the caller marks
>> the folio dirty.
>>
>> The problem arises when, after an initial write to the folio, writeback
>> results in the folio being cleaned and then the caller, via the GUP
>> interface, writes to the folio again.
>>
>> As a result of the use of this secondary, direct, mapping to the folio no
>> write notify will occur, and if the caller does mark the folio dirty, this
>> will be done so unexpectedly.
>>
>> For example, consider the following scenario:-
>>
>> 1. A folio is written to via GUP which write-faults the memory, notifying
>>     the file system and dirtying the folio.
>> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>>     the PTE being marked read-only.
>> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>>     direct mapping.
>> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>>     (though it does not have to).
>>
>> This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
>> pin_user_pages_fast_only() does not exist, we can rely on a slightly
>> imperfect whitelisting in the PUP-fast case and fall back to the slow case
>> should this fail.
>>
>> v8:
>> - Fixed typo writeable -> writable.
>> - Fixed bug in writable_file_mapping_allowed() - must check combination of
>>    FOLL_PIN AND FOLL_LONGTERM not either/or.
>> - Updated vma_needs_dirty_tracking() to include write/shared to account for
>>    MAP_PRIVATE mappings.
>> - Move to open-coding the checks in folio_pin_allowed() so we can
>>    READ_ONCE() the mapping and avoid unexpected compiler loads. Rename to
>>    account for fact we now check flags here.
>> - Disallow mapping == NULL or mapping & PAGE_MAPPING_FLAGS other than
>>    anon. Defer to slow path.
>> - Perform GUP-fast check _after_ the lowest page table level is confirmed to
>>    be stable.
>> - Updated comments and commit message for final patch as per Jason's
>>    suggestions.
> 
> Tested again on s390 using QEMU with a memory backend file (on ext4) and vfio-pci -- This time both vfio_pin_pages_remote (which will call pin_user_pages_remote(flags | FOLL_LONGTERM)) and the pin_user_pages_fast(FOLL_WRITE | FOLL_LONGTERM) in kvm_s390_pci_aif_enable are being allowed (e.g. returning positive pin count)

At least it's consistent now ;) And it might be working as expected ...

In v7:
* pin_user_pages_fast() succeeded
* vfio_pin_pages_remote() failed

But also in v7:
* GUP-fast allows pinning (anonymous) pages in MAP_PRIVATE file
   mappings
* Ordinary GUP allows pinning pages in MAP_PRIVATE file mappings

In v8:
* pin_user_pages_fast() succeeds
* vfio_pin_pages_remote() succeeds

But also in v8:
* GUP-fast allows pinning (anonymous) pages in MAP_PRIVATE file
   mappings
* Ordinary GUP allows pinning pages in MAP_PRIVATE file mappings


I have to speculate, but ... could it be that you are using a private 
mapping?

In QEMU, unfortunately, the default for memory-backend-file is 
"share=off" (private) ... for memory-backend-memfd it is "share=on" 
(shared). The default is stupid ...

If you invoke QEMU manually, can you specify "share=on" for the 
memory-backend-file? I thought libvirt would always default to 
"share=on" for file mappings (everything else doesn't make much sense) 
... but you might have to specify
	<access mode="shared"/>
in addition to
	<source type="file"/>

-- 
Thanks,

David / dhildenb


