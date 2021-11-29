Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E46462640
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhK2WtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:49:10 -0500
Received: from novek.ru ([213.148.174.62]:40816 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235068AbhK2Wsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 17:48:31 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2021 17:48:31 EST
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A0AF8500EED;
        Tue, 30 Nov 2021 01:34:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A0AF8500EED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1638225293; bh=UilxnPp1JwAYg9cfICkzyqauiN/niX1Q+oO4Af7aFEg=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=shzP+jlvYiIGzIPorOEkLHl0vkYKb5enhK/1DlUUcCPZTSfdIPx+ixc+paUral2OD
         CS/ScLkRopIGdnXy+YsRYs1nd9qdU+54UjxXYvLxsJ5CKIHVQclWbFPuI4PGn4au5y
         L8XJqn/ytfE4Jm8DLBNHqtEg2QkOTl/I+gCb8oqk=
Subject: Re: [PATCH] net/tls: Fix authentication failure in CCM mode
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org
References: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <e623a691-2212-e1cc-7fed-1c3a2043b6bd@novek.ru>
Date:   Mon, 29 Nov 2021 22:39:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2021 09:32, Tianjia Zhang wrote:
> When the TLS cipher suite uses CCM mode, including AES CCM and
> SM4 CCM, the first byte of the B0 block is flags, and the real
> IV starts from the second byte. The XOR operation of the IV and
> rec_seq should be skip this byte, that is, add the iv_offset.
> 
> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Nice catch, thanks!
This is what I was talking about last time.

Tested-by: Vadim Fedorenko <vfedorenko@novek.ru>
