Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672C33D8418
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhG0Xdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbhG0Xdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:33:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD32CC061757;
        Tue, 27 Jul 2021 16:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=41wpVpavNVm7pF419ATH4r8xqqa08ERgI3LuOyPcGto=; b=St1ko82YVev0bfzCo8YlqcAWmW
        hr8hpuUOKsdzCrcPuwVnS3q/Plii2gc2y72mvnUDrd88/Ee0aMlJrGenY9KK6SsdfJ3AA1toKsYMh
        zWwqjDGuGBo4Z30xOkTfYdv/BnreryNqQQEFvin7dexkAmnM8HWqpKvanzLPvj+aU7s//28WihHVX
        iiDLgdbEzCA8X3hMEzwVO3pKRPyqjgtZl55Nh+PvITALYCI+P53/qr04qmgR7KSo3DxPciVbaldwk
        CsOn5fnegZ7k6rRT8CPrLJ3DUBN40ij+32GWkm5Pwn9WlS7icC6Wy+eNCSjkPj/X0wETRQqjdkJvv
        tTxLVPQw==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8WZn-00GfWY-Tk; Tue, 27 Jul 2021 23:33:32 +0000
Subject: Re: [PATCH 33/64] lib: Introduce CONFIG_TEST_MEMCPY
To:     Bart Van Assche <bvanassche@acm.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-34-keescook@chromium.org>
 <9827144a-dacf-61dc-d554-6c69434708de@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <afa92312-a667-3597-d937-7e09bac2bb29@infradead.org>
Date:   Tue, 27 Jul 2021 16:33:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9827144a-dacf-61dc-d554-6c69434708de@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 4:31 PM, Bart Van Assche wrote:
> On 7/27/21 1:58 PM, Kees Cook wrote:
>> +static int __init test_memcpy_init(void)
>> +{
>> +    int err = 0;
>> +
>> +    err |= test_memcpy();
>> +    err |= test_memmove();
>> +    err |= test_memset();
>> +
>> +    if (err) {
>> +        pr_warn("FAIL!\n");
>> +        err = -EINVAL;
>> +    } else {
>> +        pr_info("all tests passed\n");
>> +    }
>> +
>> +    return err;
>> +}
>> +
>> +static void __exit test_memcpy_exit(void)
>> +{ }
>> +
>> +module_init(test_memcpy_init);
>> +module_exit(test_memcpy_exit);
>> +MODULE_LICENSE("GPL");
> 
> Has it been considered to implement this test using the Kunit framework?

and do we want everything converted to use the Kunit test framework?

My answer is No, we don't, but I could easily be in the minority.

-- 
~Randy

