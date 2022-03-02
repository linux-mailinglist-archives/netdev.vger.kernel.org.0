Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8DC4CAB53
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiCBRPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbiCBRPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:15:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19AA58E45;
        Wed,  2 Mar 2022 09:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646241306; x=1677777306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=quZJORXDoBJnmtXWeY1UEG0LMErZNbKWG4uR8GxuM8A=;
  b=EgFtrQTE2RuXhvw9sRIr3IT+pA0Ncb8f9tiCc0SC60P5NxN5IIJ1lIbG
   qRXhfI2wJDlspyrIGC0iL/9/1vb/Lqq8nOVou0CScelNSeM2zFz5ZYwQd
   vRCxbYiuOYMHLgn2p868GOLIzIRhmd1d7Ftp+C+uIAO1rF5yphwxH1nTK
   BZo8QGgTZGobcAwOhtAkimiecLreyGJPEymFRGwK29ytkPQQTUw1YAXwn
   7s74MTXIjfdUqEKiu1QGwymv12Ru01fVqM/H0rIJHbiNJzFQB0n0mysA7
   4izUGN7Nj88HSoNqykEmQlZt68TbXwAcpy2jJWkt8gcliob3VHMqMtNgg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="339886271"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="339886271"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:15:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="551343768"
Received: from jbuller-mobl1.ger.corp.intel.com (HELO [10.213.194.231]) ([10.213.194.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:14:53 -0800
Message-ID: <ed52ce3c-0f4a-a1e8-4176-543657d6228d@linux.intel.com>
Date:   Wed, 2 Mar 2022 17:14:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [Intel-gfx] [PATCH 6/6] treewide: remove check of list iterator
 against head past the loop body
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx@lists.freedesktop.org, samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-cifs@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-sgx@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-7-jakobkoschel@gmail.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220228110822.491923-7-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/02/2022 11:08, Jakob Koschel wrote:
> When list_for_each_entry() completes the iteration over the whole list
> without breaking the loop, the iterator value will be a bogus pointer
> computed based on the head element.
> 
> While it is safe to use the pointer to determine if it was computed
> based on the head element, either with list_entry_is_head() or
> &pos->member == head, using the iterator variable after the loop should
> be avoided.
> 
> In preparation to limiting the scope of a list iterator to the list
> traversal loop, use a dedicated pointer to point to the found element.
> 
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

[snip until i915 parts]

>   drivers/gpu/drm/i915/gem/i915_gem_context.c   | 14 +++---
>   .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 15 ++++---
>   drivers/gpu/drm/i915/gt/intel_ring.c          | 15 ++++---

[snip]

> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> index 00327b750fbb..80c79028901a 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> @@ -107,25 +107,27 @@ static void lut_close(struct i915_gem_context *ctx)
>   	radix_tree_for_each_slot(slot, &ctx->handles_vma, &iter, 0) {
>   		struct i915_vma *vma = rcu_dereference_raw(*slot);
>   		struct drm_i915_gem_object *obj = vma->obj;
> -		struct i915_lut_handle *lut;
> +		struct i915_lut_handle *lut = NULL;
> +		struct i915_lut_handle *tmp;
> 
>   		if (!kref_get_unless_zero(&obj->base.refcount))
>   			continue;
> 
>   		spin_lock(&obj->lut_lock);
> -		list_for_each_entry(lut, &obj->lut_list, obj_link) {
> -			if (lut->ctx != ctx)
> +		list_for_each_entry(tmp, &obj->lut_list, obj_link) {
> +			if (tmp->ctx != ctx)
>   				continue;
> 
> -			if (lut->handle != iter.index)
> +			if (tmp->handle != iter.index)
>   				continue;
> 
> -			list_del(&lut->obj_link);
> +			list_del(&tmp->obj_link);
> +			lut = tmp;
>   			break;
>   		}
>   		spin_unlock(&obj->lut_lock);
> 
> -		if (&lut->obj_link != &obj->lut_list) {
> +		if (lut) {
>   			i915_lut_handle_free(lut);
>   			radix_tree_iter_delete(&ctx->handles_vma, &iter, slot);

Looks okay although personally I would have left lut as is for a smaller 
diff and introduced a new local like 'found' or 'unlinked'.

>   			i915_vma_close(vma);
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> index 1736efa43339..fda9e3685ad2 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -2444,7 +2444,8 @@ static struct i915_request *eb_throttle(struct i915_execbuffer *eb, struct intel
>   {
>   	struct intel_ring *ring = ce->ring;
>   	struct intel_timeline *tl = ce->timeline;
> -	struct i915_request *rq;
> +	struct i915_request *rq = NULL;
> +	struct i915_request *tmp;
> 
>   	/*
>   	 * Completely unscientific finger-in-the-air estimates for suitable
> @@ -2460,15 +2461,17 @@ static struct i915_request *eb_throttle(struct i915_execbuffer *eb, struct intel
>   	 * claiming our resources, but not so long that the ring completely
>   	 * drains before we can submit our next request.
>   	 */
> -	list_for_each_entry(rq, &tl->requests, link) {
> -		if (rq->ring != ring)
> +	list_for_each_entry(tmp, &tl->requests, link) {
> +		if (tmp->ring != ring)
>   			continue;
> 
> -		if (__intel_ring_space(rq->postfix,
> -				       ring->emit, ring->size) > ring->size / 2)
> +		if (__intel_ring_space(tmp->postfix,
> +				       ring->emit, ring->size) > ring->size / 2) {
> +			rq = tmp;
>   			break;
> +		}
>   	}
> -	if (&rq->link == &tl->requests)
> +	if (!rq)
>   		return NULL; /* weird, we will check again later for real */

Alternatively, instead of break could simply do "return 
i915_request_get(rq);" and replace the end of the function after the 
loop with "return NULL;". A bit smaller diff, or at least less "spread 
out" over the function, so might be easier to backport stuff touching 
this area in the future. But looks correct as is.

> 
>   	return i915_request_get(rq);
> diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
> index 2fdd52b62092..4881c4e0c407 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ring.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ring.c
> @@ -191,24 +191,27 @@ wait_for_space(struct intel_ring *ring,
>   	       struct intel_timeline *tl,
>   	       unsigned int bytes)
>   {
> -	struct i915_request *target;
> +	struct i915_request *target = NULL;
> +	struct i915_request *tmp;
>   	long timeout;
> 
>   	if (intel_ring_update_space(ring) >= bytes)
>   		return 0;
> 
>   	GEM_BUG_ON(list_empty(&tl->requests));
> -	list_for_each_entry(target, &tl->requests, link) {
> -		if (target->ring != ring)
> +	list_for_each_entry(tmp, &tl->requests, link) {
> +		if (tmp->ring != ring)
>   			continue;
> 
>   		/* Would completion of this request free enough space? */
> -		if (bytes <= __intel_ring_space(target->postfix,
> -						ring->emit, ring->size))
> +		if (bytes <= __intel_ring_space(tmp->postfix,
> +						ring->emit, ring->size)) {
> +			target = tmp;
>   			break;
> +		}
>   	}
> 
> -	if (GEM_WARN_ON(&target->link == &tl->requests))
> +	if (GEM_WARN_ON(!target))
>   		return -ENOSPC;
> 
>   	timeout = i915_request_wait(target,

Looks okay as well. Less clear here if there is a clean solution to make 
the diff smaller so no suggestions. I mean do I dare mention "goto 
found;" from inside the loop, where the break is, instead of the 
variable renames.. risky.. :) (And ofc "return -ENOSPC" immediately 
after the loop.)

As a summary changes looks okay, up to you if you want to try to make 
the diffs smaller or not. It doesn't matter hugely really, all I have is 
a vague and uncertain "maybe it makes backporting of something, someday 
easier". So for i915 it is good either way.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com> # i915 bits only

Regards,

Tvrtko
