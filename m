Return-Path: <netdev+bounces-2908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 845B07047D9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 415F6281573
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC6824EA9;
	Tue, 16 May 2023 08:31:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE3224EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:31:17 +0000 (UTC)
X-Greylist: delayed 355 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 01:31:15 PDT
Received: from a27-22.smtp-out.us-west-2.amazonses.com (a27-22.smtp-out.us-west-2.amazonses.com [54.240.27.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A5B188;
	Tue, 16 May 2023 01:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684225520;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=GScpAXv+J3eSM6qFgW9uds9TDleKdfcZkU54I1b2MRI=;
	b=Y8G2vfQC3vwxxj6j4GwDb2AvnBwuAhbIXYMXBUinIRvi7RDzmhp6LNLO6fKYRJkD
	lvnoSRy++FdjiK7WmboaZz3KIsmmtHCcFkWQMb6gR81gguLjzvEDRPh3Rd/QWJ3oryD
	vqffG4sn6O0C6WCw4NTLqVMeUx7b/yAZKYsz7Jel9MHxCLB7IJfxZDJt849xpt3O+xR
	lnZQ/Kp9wVfLkhqgV529PZunpOf9qjaZCKZ+CAgvOQ2giF0uxsIHHxzlWOQxzwA068N
	uLfRH4mFBP6AX9AczUeYTIddfcTIgiezZoB6DDAFFiDSN3SO7j6NNOCIhDVZaYkVMpR
	4O6peZXobA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684225520;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=GScpAXv+J3eSM6qFgW9uds9TDleKdfcZkU54I1b2MRI=;
	b=QF1W1RKbg7VbNHjsIPVKDaZMjOrcbd3oJrHgEXH9XligsGLyX3vbv0MOgV9r9TWa
	vqFQqnM9GxCrLUobdPlSNl58NYltNrjnktWYlOUxHNGb7f63IGABFnRtFC0K1eKwtIU
	OCqiiGYtzeMH8NkHxfFNiqFHaDIC8XK+Ieqt3NAc=
Date: Tue, 16 May 2023 08:25:19 +0000
Message-ID: <0101018823a9f0f2-a4620a25-6974-4464-a7ed-c997e9579243-000000@us-west-2.amazonses.com>
To: ebiggers@kernel.org
Cc: tomo@exabit.dev, rust-for-linux@vger.kernel.org,
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 fujita.tomonori@gmail.com
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
From: FUJITA Tomonori <tomo@exabit.dev>
In-Reply-To: <20230516055219.GC2704@sol.localdomain>
References: <20230515043353.2324288-1-tomo@exabit.dev>
	<010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
	<20230516055219.GC2704@sol.localdomain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.16-54.240.27.22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Mon, 15 May 2023 22:52:19 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

>> +#include <crypto/hash.h>
>>  #include <linux/bug.h>
>>  #include <linux/build_bug.h>
>>  #include <linux/err.h>
>> @@ -27,6 +28,29 @@
>>  #include <linux/sched/signal.h>
>>  #include <linux/wait.h>
>>  
>> +void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
>> +{
>> +	crypto_free_shash(tfm);
>> +}
>> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);
> 
> Shouldn't this code be compiled only when the crypto API is available?

Oops, I'll add #ifdef CONFIG_CRYPTO


>> +impl<'a> ShashDesc<'a> {
>> +    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
>> +    pub fn new(tfm: &'a Shash) -> Result<Self> {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        let size = core::mem::size_of::<bindings::shash_desc>()
>> +            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
>> +        let layout = Layout::from_size_align(size, 2)?;
>> +        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
>> +        let mut desc = ShashDesc { ptr, tfm, size };
>> +        // SAFETY: The `desc.tfm` is non-null and valid for the lifetime of this object.
>> +        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
>> +        Ok(desc)
>> +    }
>> +
>> +    /// (Re)initializes message digest.
>> +    pub fn init(&mut self) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
>> +    }
>> +
>> +    /// Adds data to message digest for processing.
>> +    pub fn update(&mut self, data: &[u8]) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe {
>> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
>> +        })
>> +    }
>> +
>> +    /// Calculates message digest.
>> +    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
>> +    }
> 
> This doesn't enforce that init() is called before update() or finalize().  I
> think that needs to be checked in the Rust code, since the C code doesn't have
> defined behavior in that case.

Surely, Rust side should handle the case.

If the new() function internally calls init() before returning, it
works? The new() returns an initialized ShaDesc object.


Thanks for reviewing!

