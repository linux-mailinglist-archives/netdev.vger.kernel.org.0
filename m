Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3369331490A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBIGmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:42:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:32488 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhBIGmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 01:42:19 -0500
IronPort-SDR: bUynXjoAkDgwLiy5wwhJuCE7yqnuTHfRXjQcQmf47E2LN9z8j+qyaOYPzZifFV55Af0AVfoZoJ
 C6Jau+fam5RA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="266670678"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="266670678"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 22:41:38 -0800
IronPort-SDR: N4CjeIMs8sr1M1kRZLtyhmAv1Nwro6Q/3NPEpl9ZUNTqm+y9vz749RvpKjzTvJipkTfIVevbx5
 748fziOCg/7w==
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="395976473"
Received: from ebirent-mobl1.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.47.82])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 22:41:32 -0800
Subject: Re: [PATCH bpf v2] selftests/bpf: remove bash feature in
 test_xdp_redirect.sh
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        u9012063@gmail.com, Randy Dunlap <rdunlap@infradead.org>
References: <20210206092654.155239-1-bjorn.topel@gmail.com>
 <CAEf4BzZ4aU26HGxYsOg4ma52bq9ghLDMJD03O1oQaRd8q0=ofA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <f2970774-02a0-dd88-242c-d1fb9c7b3ce6@intel.com>
Date:   Tue, 9 Feb 2021 07:41:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZ4aU26HGxYsOg4ma52bq9ghLDMJD03O1oQaRd8q0=ofA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-09 06:52, Andrii Nakryiko wrote:
> On Sat, Feb 6, 2021 at 1:29 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The test_xdp_redirect.sh script uses a bash redirect feature,
>> '&>/dev/null'. Use '>/dev/null 2>&1' instead.
> 
> We have plenty of explicit bash uses in selftest scripts, I'm not sure
> it's a good idea to make scripts more verbose.
>

$ cd tools/testing/selftests
$ git grep '\#!/bin/bash'|wc -l
282
$ git grep '\#!/bin/sh'|wc -l
164

Andrii/Randy, I'm fine with whatever. I just want to be able to run the
test on Debian-derived systems. ;-)


>>
>> Also remove the 'set -e' since the script actually relies on that the
>> return value can be used to determine pass/fail of the test.
> 
> This sounds like a dubious decision. The script checks return results
> only of last two commands, for which it's better to write and if
> [<first command>] && [<second command>] check and leave set -e intact.
>

Ok!

Please decide on the shell flavor, and I'll respin a v3.


Björn
