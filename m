Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AADD49503
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfFQWRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:17:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:60784 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfFQWRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:17:39 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hczwV-0005xV-89; Tue, 18 Jun 2019 00:17:35 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hczwU-00038d-Vc; Tue, 18 Jun 2019 00:17:35 +0200
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        jakub.kicinski@netronome.com, joe@wand.net.nz
References: <20190617192700.2313445-1-andriin@fb.com>
 <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
Message-ID: <0a002492-b07d-bc0b-073d-b3e5ebae2b2c@iogearbox.net>
Date:   Tue, 18 Jun 2019 00:17:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25483/Mon Jun 17 09:56:00 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/17/2019 11:17 PM, Daniel Borkmann wrote:
> On 06/17/2019 09:26 PM, Andrii Nakryiko wrote:
>> This patch set implements initial version (as discussed at LSF/MM2019
>> conference) of a new way to specify BPF maps, relying on BTF type information,
>> which allows for easy extensibility, preserving forward and backward
>> compatibility. See details and examples in description for patch #6.
>>
>> [0] contains an outline of follow up extensions to be added after this basic
>> set of features lands. They are useful by itself, but also allows to bring
>> libbpf to feature-parity with iproute2 BPF loader. That should open a path
>> forward for BPF loaders unification.
>>
>> Patch #1 centralizes commonly used min/max macro in libbpf_internal.h.
>> Patch #2 extracts .BTF and .BTF.ext loading loging from elf_collect().
>> Patch #3 simplifies elf_collect() error-handling logic.
>> Patch #4 refactors map initialization logic into user-provided maps and global
>> data maps, in preparation to adding another way (BTF-defined maps).
>> Patch #5 adds support for map definitions in multiple ELF sections and
>> deprecates bpf_object__find_map_by_offset() API which doesn't appear to be
>> used anymore and makes assumption that all map definitions reside in single
>> ELF section.
>> Patch #6 splits BTF intialization from sanitization/loading into kernel to
>> preserve original BTF at the time of map initialization.
>> Patch #7 adds support for BTF-defined maps.
>> Patch #8 adds new test for BTF-defined map definition.
>> Patches #9-11 convert test BPF map definitions to use BTF way.

LGTM as a base, applied 1-10 as per Stanislav's concern, added Song's Ack to
patch 10, and fixed up typos in patch 2 while at it.
