Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9045289B79
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 00:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390340AbgJIWD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 18:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390154AbgJIWD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 18:03:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E12C0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 15:03:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so11200843wmj.5
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 15:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=6AdF7ImouyBo1v+UVVHbR2jrgxlTgfY49UnpKuJl2vo=;
        b=MAvLr2XnoBdtbc8e8cEo1YppoaD8vfmQyJEZKkS/CF5FMGYOCD9W7O0IZtWYq8ODgA
         hPrQ1FmqoKh8rvOQoL3cQ1KrqxgRTT0OnIwFAo1dmcJzppCqnka5FyN347HmibM8jSEz
         e9ww2l67YncgPsbvE8VuHqhkcOIRrbdxVqCNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6AdF7ImouyBo1v+UVVHbR2jrgxlTgfY49UnpKuJl2vo=;
        b=PdIK75p2G1RmRXAHVMSRvUhjaF4AQrmZBYb4ayWkbGIE0qIqr8/L1mP0Sgj0jp9X4R
         S23cw7qeZw+37ajllclSp6pfWRmU/4b6C1qHeOR9EWQ0dkBNsoT8hALeAXkaW+UN/WSL
         aWgzcwufYw9snEOf5przV54FnZYHl4S+3C6Wlr+E1Lw62cTqG1Z5qqVHihBNh5Zt8ZaL
         5oOEoCgOXTDpLq9/LQisFe2ptslmPlxY31i4XAbln/YG22YBab6mR5Ve5IOnJV1ugZzm
         ZrCEdQ6Etl4BKc9fekeYDNBn3A+EhUbgL7Gs7QWRIpa7ZGL1tm/qUie4BfqsahK/ikhh
         fzmQ==
X-Gm-Message-State: AOAM5332SOEbxvE20o6lY0fIAHTHA/EtIEnX2D2ry+g6ztHqc2Xrg71k
        LPHSt7ijIu2lLxngnJ7dyXd9nQ==
X-Google-Smtp-Source: ABdhPJzLUGH0qXD9MRJ9uaTqaSHXSKqVIytWPhW+Fv8l3CnjdOFUZRdjqAS25NTJ59jhdr8rs7Tm+A==
X-Received: by 2002:a1c:a9d1:: with SMTP id s200mr4476wme.107.1602281034146;
        Fri, 09 Oct 2020 15:03:54 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id c18sm14231894wrq.5.2020.10.09.15.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 15:03:52 -0700 (PDT)
Date:   Sat, 10 Oct 2020 00:03:49 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     ira.weiny@intel.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH RFC PKS/PMEM 09/58] drivers/gpu: Utilize new kmap_thread()
Message-ID: <20201009220349.GQ438822@phenom.ffwll.local>
Mail-Followup-To: ira.weiny@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
        cluster-devel@redhat.com, ecryptfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-rdma@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-cachefs@redhat.com, samba-technical@lists.samba.org,
        intel-wired-lan@lists.osuosl.org
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-10-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195033.3208459-10-ira.weiny@intel.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 12:49:44PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> These kmap() calls in the gpu stack are localized to a single thread.
> To avoid the over head of global PKRS updates use the new kmap_thread()
> call.
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

I'm guessing the entire pile goes in through some other tree. If so:

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

If you want this to land through maintainer trees, then we need a
per-driver split (since aside from amdgpu and radeon they're all different
subtrees).

btw the two kmap calls in drm you highlight in the cover letter should
also be convertible to kmap_thread. We only hold vmalloc mappings for a
longer time (or it'd be quite a driver bug). So if you want maybe throw
those two as two additional patches on top, and we can do some careful
review & testing for them.
-Daniel

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c              | 12 ++++++------
>  drivers/gpu/drm/gma500/gma_display.c                 |  4 ++--
>  drivers/gpu/drm/gma500/mmu.c                         | 10 +++++-----
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c            |  4 ++--
>  .../gpu/drm/i915/gem/selftests/i915_gem_context.c    |  4 ++--
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c   |  8 ++++----
>  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c         |  4 ++--
>  drivers/gpu/drm/i915/gt/intel_gtt.c                  |  4 ++--
>  drivers/gpu/drm/i915/gt/shmem_utils.c                |  4 ++--
>  drivers/gpu/drm/i915/i915_gem.c                      |  8 ++++----
>  drivers/gpu/drm/i915/i915_gpu_error.c                |  4 ++--
>  drivers/gpu/drm/i915/selftests/i915_perf.c           |  4 ++--
>  drivers/gpu/drm/radeon/radeon_ttm.c                  |  4 ++--
>  13 files changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index 978bae731398..bd564bccb7a3 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -2437,11 +2437,11 @@ static ssize_t amdgpu_ttm_gtt_read(struct file *f, char __user *buf,
>  
>  		page = adev->gart.pages[p];
>  		if (page) {
> -			ptr = kmap(page);
> +			ptr = kmap_thread(page);
>  			ptr += off;
>  
>  			r = copy_to_user(buf, ptr, cur_size);
> -			kunmap(adev->gart.pages[p]);
> +			kunmap_thread(adev->gart.pages[p]);
>  		} else
>  			r = clear_user(buf, cur_size);
>  
> @@ -2507,9 +2507,9 @@ static ssize_t amdgpu_iomem_read(struct file *f, char __user *buf,
>  		if (p->mapping != adev->mman.bdev.dev_mapping)
>  			return -EPERM;
>  
> -		ptr = kmap(p);
> +		ptr = kmap_thread(p);
>  		r = copy_to_user(buf, ptr + off, bytes);
> -		kunmap(p);
> +		kunmap_thread(p);
>  		if (r)
>  			return -EFAULT;
>  
> @@ -2558,9 +2558,9 @@ static ssize_t amdgpu_iomem_write(struct file *f, const char __user *buf,
>  		if (p->mapping != adev->mman.bdev.dev_mapping)
>  			return -EPERM;
>  
> -		ptr = kmap(p);
> +		ptr = kmap_thread(p);
>  		r = copy_from_user(ptr + off, buf, bytes);
> -		kunmap(p);
> +		kunmap_thread(p);
>  		if (r)
>  			return -EFAULT;
>  
> diff --git a/drivers/gpu/drm/gma500/gma_display.c b/drivers/gpu/drm/gma500/gma_display.c
> index 3df6d6e850f5..35f4e55c941f 100644
> --- a/drivers/gpu/drm/gma500/gma_display.c
> +++ b/drivers/gpu/drm/gma500/gma_display.c
> @@ -400,9 +400,9 @@ int gma_crtc_cursor_set(struct drm_crtc *crtc,
>  		/* Copy the cursor to cursor mem */
>  		tmp_dst = dev_priv->vram_addr + cursor_gt->offset;
>  		for (i = 0; i < cursor_pages; i++) {
> -			tmp_src = kmap(gt->pages[i]);
> +			tmp_src = kmap_thread(gt->pages[i]);
>  			memcpy(tmp_dst, tmp_src, PAGE_SIZE);
> -			kunmap(gt->pages[i]);
> +			kunmap_thread(gt->pages[i]);
>  			tmp_dst += PAGE_SIZE;
>  		}
>  
> diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
> index 505044c9a673..fba7a3a461fd 100644
> --- a/drivers/gpu/drm/gma500/mmu.c
> +++ b/drivers/gpu/drm/gma500/mmu.c
> @@ -192,20 +192,20 @@ struct psb_mmu_pd *psb_mmu_alloc_pd(struct psb_mmu_driver *driver,
>  		pd->invalid_pte = 0;
>  	}
>  
> -	v = kmap(pd->dummy_pt);
> +	v = kmap_thread(pd->dummy_pt);
>  	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
>  		v[i] = pd->invalid_pte;
>  
> -	kunmap(pd->dummy_pt);
> +	kunmap_thread(pd->dummy_pt);
>  
> -	v = kmap(pd->p);
> +	v = kmap_thread(pd->p);
>  	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
>  		v[i] = pd->invalid_pde;
>  
> -	kunmap(pd->p);
> +	kunmap_thread(pd->p);
>  
>  	clear_page(kmap(pd->dummy_page));
> -	kunmap(pd->dummy_page);
> +	kunmap_thread(pd->dummy_page);
>  
>  	pd->tables = vmalloc_user(sizeof(struct psb_mmu_pt *) * 1024);
>  	if (!pd->tables)
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index 38113d3c0138..274424795fb7 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -566,9 +566,9 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *dev_priv,
>  		if (err < 0)
>  			goto fail;
>  
> -		vaddr = kmap(page);
> +		vaddr = kmap_thread(page);
>  		memcpy(vaddr, data, len);
> -		kunmap(page);
> +		kunmap_thread(page);
>  
>  		err = pagecache_write_end(file, file->f_mapping,
>  					  offset, len, len,
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
> index 7ffc3c751432..b466c677d007 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
> @@ -1754,7 +1754,7 @@ static int check_scratch_page(struct i915_gem_context *ctx, u32 *out)
>  		return -EINVAL;
>  	}
>  
> -	vaddr = kmap(page);
> +	vaddr = kmap_thread(page);
>  	if (!vaddr) {
>  		pr_err("No (mappable) scratch page!\n");
>  		return -EINVAL;
> @@ -1765,7 +1765,7 @@ static int check_scratch_page(struct i915_gem_context *ctx, u32 *out)
>  		pr_err("Inconsistent initial state of scratch page!\n");
>  		err = -EINVAL;
>  	}
> -	kunmap(page);
> +	kunmap_thread(page);
>  
>  	return err;
>  }
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> index 9c7402ce5bf9..447df22e2e06 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> @@ -143,7 +143,7 @@ static int check_partial_mapping(struct drm_i915_gem_object *obj,
>  	intel_gt_flush_ggtt_writes(&to_i915(obj->base.dev)->gt);
>  
>  	p = i915_gem_object_get_page(obj, offset >> PAGE_SHIFT);
> -	cpu = kmap(p) + offset_in_page(offset);
> +	cpu = kmap_thread(p) + offset_in_page(offset);
>  	drm_clflush_virt_range(cpu, sizeof(*cpu));
>  	if (*cpu != (u32)page) {
>  		pr_err("Partial view for %lu [%u] (offset=%llu, size=%u [%llu, row size %u], fence=%d, tiling=%d, stride=%d) misalignment, expected write to page (%llu + %u [0x%llx]) of 0x%x, found 0x%x\n",
> @@ -161,7 +161,7 @@ static int check_partial_mapping(struct drm_i915_gem_object *obj,
>  	}
>  	*cpu = 0;
>  	drm_clflush_virt_range(cpu, sizeof(*cpu));
> -	kunmap(p);
> +	kunmap_thread(p);
>  
>  out:
>  	__i915_vma_put(vma);
> @@ -236,7 +236,7 @@ static int check_partial_mappings(struct drm_i915_gem_object *obj,
>  		intel_gt_flush_ggtt_writes(&to_i915(obj->base.dev)->gt);
>  
>  		p = i915_gem_object_get_page(obj, offset >> PAGE_SHIFT);
> -		cpu = kmap(p) + offset_in_page(offset);
> +		cpu = kmap_thread(p) + offset_in_page(offset);
>  		drm_clflush_virt_range(cpu, sizeof(*cpu));
>  		if (*cpu != (u32)page) {
>  			pr_err("Partial view for %lu [%u] (offset=%llu, size=%u [%llu, row size %u], fence=%d, tiling=%d, stride=%d) misalignment, expected write to page (%llu + %u [0x%llx]) of 0x%x, found 0x%x\n",
> @@ -254,7 +254,7 @@ static int check_partial_mappings(struct drm_i915_gem_object *obj,
>  		}
>  		*cpu = 0;
>  		drm_clflush_virt_range(cpu, sizeof(*cpu));
> -		kunmap(p);
> +		kunmap_thread(p);
>  		if (err)
>  			return err;
>  
> diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> index 7fb36b12fe7a..38da348282f1 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> @@ -731,7 +731,7 @@ static void swizzle_page(struct page *page)
>  	char *vaddr;
>  	int i;
>  
> -	vaddr = kmap(page);
> +	vaddr = kmap_thread(page);
>  
>  	for (i = 0; i < PAGE_SIZE; i += 128) {
>  		memcpy(temp, &vaddr[i], 64);
> @@ -739,7 +739,7 @@ static void swizzle_page(struct page *page)
>  		memcpy(&vaddr[i + 64], temp, 64);
>  	}
>  
> -	kunmap(page);
> +	kunmap_thread(page);
>  }
>  
>  /**
> diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
> index 2a72cce63fd9..4cfb24e9ed62 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gtt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
> @@ -312,9 +312,9 @@ static void poison_scratch_page(struct page *page, unsigned long size)
>  	do {
>  		void *vaddr;
>  
> -		vaddr = kmap(page);
> +		vaddr = kmap_thread(page);
>  		memset(vaddr, POISON_FREE, PAGE_SIZE);
> -		kunmap(page);
> +		kunmap_thread(page);
>  
>  		page = pfn_to_page(page_to_pfn(page) + 1);
>  		size -= PAGE_SIZE;
> diff --git a/drivers/gpu/drm/i915/gt/shmem_utils.c b/drivers/gpu/drm/i915/gt/shmem_utils.c
> index 43c7acbdc79d..a40d3130cebf 100644
> --- a/drivers/gpu/drm/i915/gt/shmem_utils.c
> +++ b/drivers/gpu/drm/i915/gt/shmem_utils.c
> @@ -142,12 +142,12 @@ static int __shmem_rw(struct file *file, loff_t off,
>  		if (IS_ERR(page))
>  			return PTR_ERR(page);
>  
> -		vaddr = kmap(page);
> +		vaddr = kmap_thread(page);
>  		if (write)
>  			memcpy(vaddr + offset_in_page(off), ptr, this);
>  		else
>  			memcpy(ptr, vaddr + offset_in_page(off), this);
> -		kunmap(page);
> +		kunmap_thread(page);
>  		put_page(page);
>  
>  		len -= this;
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 9aa3066cb75d..cae8300fd224 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -312,14 +312,14 @@ shmem_pread(struct page *page, int offset, int len, char __user *user_data,
>  	char *vaddr;
>  	int ret;
>  
> -	vaddr = kmap(page);
> +	vaddr = kmap_thread(page);
>  
>  	if (needs_clflush)
>  		drm_clflush_virt_range(vaddr + offset, len);
>  
>  	ret = __copy_to_user(user_data, vaddr + offset, len);
>  
> -	kunmap(page);
> +	kunmap_thread(page);
>  
>  	return ret ? -EFAULT : 0;
>  }
> @@ -708,7 +708,7 @@ shmem_pwrite(struct page *page, int offset, int len, char __user *user_data,
>  	char *vaddr;
>  	int ret;
>  
> -	vaddr = kmap(page);
> +	vaddr = kmap_thread(page);
>  
>  	if (needs_clflush_before)
>  		drm_clflush_virt_range(vaddr + offset, len);
> @@ -717,7 +717,7 @@ shmem_pwrite(struct page *page, int offset, int len, char __user *user_data,
>  	if (!ret && needs_clflush_after)
>  		drm_clflush_virt_range(vaddr + offset, len);
>  
> -	kunmap(page);
> +	kunmap_thread(page);
>  
>  	return ret ? -EFAULT : 0;
>  }
> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
> index 3e6cbb0d1150..aecd469b6b6e 100644
> --- a/drivers/gpu/drm/i915/i915_gpu_error.c
> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c
> @@ -1058,9 +1058,9 @@ i915_vma_coredump_create(const struct intel_gt *gt,
>  
>  			drm_clflush_pages(&page, 1);
>  
> -			s = kmap(page);
> +			s = kmap_thread(page);
>  			ret = compress_page(compress, s, dst, false);
> -			kunmap(page);
> +			kunmap_thread(page);
>  
>  			drm_clflush_pages(&page, 1);
>  
> diff --git a/drivers/gpu/drm/i915/selftests/i915_perf.c b/drivers/gpu/drm/i915/selftests/i915_perf.c
> index c2d001d9c0ec..7f7ef2d056f4 100644
> --- a/drivers/gpu/drm/i915/selftests/i915_perf.c
> +++ b/drivers/gpu/drm/i915/selftests/i915_perf.c
> @@ -307,7 +307,7 @@ static int live_noa_gpr(void *arg)
>  	}
>  
>  	/* Poison the ce->vm so we detect writes not to the GGTT gt->scratch */
> -	scratch = kmap(ce->vm->scratch[0].base.page);
> +	scratch = kmap_thread(ce->vm->scratch[0].base.page);
>  	memset(scratch, POISON_FREE, PAGE_SIZE);
>  
>  	rq = intel_context_create_request(ce);
> @@ -405,7 +405,7 @@ static int live_noa_gpr(void *arg)
>  out_rq:
>  	i915_request_put(rq);
>  out_ce:
> -	kunmap(ce->vm->scratch[0].base.page);
> +	kunmap_thread(ce->vm->scratch[0].base.page);
>  	intel_context_put(ce);
>  out:
>  	stream_destroy(stream);
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 004344dce140..0aba0cac51e1 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -1013,11 +1013,11 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
>  
>  		page = rdev->gart.pages[p];
>  		if (page) {
> -			ptr = kmap(page);
> +			ptr = kmap_thread(page);
>  			ptr += off;
>  
>  			r = copy_to_user(buf, ptr, cur_size);
> -			kunmap(rdev->gart.pages[p]);
> +			kunmap_thread(rdev->gart.pages[p]);
>  		} else
>  			r = clear_user(buf, cur_size);
>  
> -- 
> 2.28.0.rc0.12.gb6a658bd00c9
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
