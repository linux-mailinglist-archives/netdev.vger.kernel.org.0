Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1429D412
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfHZQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:34:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:52856 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbfHZQep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 12:34:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 09:34:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="355480938"
Received: from nkosecih-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.35.136])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2019 09:34:40 -0700
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
To:     Ilya Maximets <i.maximets@samsung.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
 <CGME20190826061127epcas5p21bb790365a436ff234d77786f03729f8@epcas5p2.samsung.com>
 <20190826061053.15996-3-bjorn.topel@gmail.com>
 <14576fd3-69ce-6493-5a38-c47566851d4e@samsung.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1b780dd4-227f-64c4-260d-9e819ba7081f@intel.com>
Date:   Mon, 26 Aug 2019 18:34:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <14576fd3-69ce-6493-5a38-c47566851d4e@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-26 17:24, Ilya Maximets wrote:
> This changes the error code a bit.
> Previously:
>     umem exists + xs unbound    --> EINVAL
>     no umem     + xs unbound    --> EBADF
>     xs bound to different dev/q --> EINVAL
> 
> With this change:
>     umem exists + xs unbound    --> EBADF
>     no umem     + xs unbound    --> EBADF
>     xs bound to different dev/q --> EINVAL
> 
> Just a note. Not sure if this is important.
> 

Note that this is for *shared* umem, so it's very seldom used. Still,
you're right, that strictly this is an uapi break, but I'd vote for the
change still. I find it hard to see that anyone relies on EINVAL/EBADF
for shared umem bind.

Opinions? :-)


Björn
