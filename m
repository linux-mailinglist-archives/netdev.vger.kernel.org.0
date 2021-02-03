Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6C930D0A8
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBCBLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:11:51 -0500
Received: from novek.ru ([213.148.174.62]:48446 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229657AbhBCBLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:11:49 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 08C4B500731;
        Wed,  3 Feb 2021 04:11:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 08C4B500731
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612314665; bh=//kP3HJXd2+cgk6eENi6gUxsAXX/B5XOvkk048qNTzQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EC0KeGNVfBu0KGu9e+Ev1mzcUEhNMZgz40zEF4kr00UZvCGYq/0cY0AibS7XJv9oV
         2p1eArQgkY20ISLxMhJIgnixjLIvMCDxNys3P1XlBzUVV12064hbUoAUc+gb8QWItT
         URgvOpNPyKzdiQ4EylmCESdFzKB4d1vgUbFnq9bI=
Subject: Re: [PATCH] selftests/tls: fix compile errors after adding
 CHACHA20-POLY1305
To:     Jakub Kicinski <kuba@kernel.org>, Rong Chen <rong.a.chen@intel.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
References: <20210202094500.679761-1-rong.a.chen@intel.com>
 <20210202135307.6a2306fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <67789f5b-7b26-7783-94f8-e9da434ac0a1@novek.ru>
Date:   Wed, 3 Feb 2021 01:11:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202135307.6a2306fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.2021 21:53, Jakub Kicinski wrote:
> On Tue,  2 Feb 2021 17:45:00 +0800 Rong Chen wrote:
>> The kernel test robot reported the following errors:
>>
>> tls.c: In function ‘tls_setup’:
>> tls.c:136:27: error: storage size of ‘tls12’ isn’t known
>>    union tls_crypto_context tls12;
>>                             ^~~~~
>> tls.c:150:21: error: ‘tls12_crypto_info_chacha20_poly1305’ undeclared (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
>>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tls.c:150:21: note: each undeclared identifier is reported only once for each function it appears in
>> tls.c:153:21: error: ‘tls12_crypto_info_aes_gcm_128’ undeclared (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
>>
>> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Link: https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9020/
>> Signed-off-by: Rong Chen <rong.a.chen@intel.com>
> 
> Are you sure you have latest headers installed on your system?
> 
> Try make headers_install or some such, I forgot what the way to appease
> selftest was exactly but selftests often don't build on a fresh kernel
> clone if system headers are not very recent :S

There is definitely error in test - I could reproduce it in a clean environment.
I will take care of it.

