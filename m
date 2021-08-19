Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C93F213F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhHST7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhHST7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 15:59:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33695C061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 12:58:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e7so6899061pgk.2
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LynX178MCRLTZU5nO2CQfUksz3iyT32ZXzH2mGMWDBA=;
        b=IXP6D8XUx7q38sbKdbR+/AGu2s0ZJLBWooVJkgCUSHWtToTxSgv5DmH5+2jvYOp6Zi
         HzsBie7+wTjJLrZAtj2grSzQ23RPyHvcRjIk1YBMcTFffxfJWBxG7UDPfDsT7lYLqEXs
         P59yXQ7sA3PbiyfDMZYBhF0RVfO2fU3LZbyYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LynX178MCRLTZU5nO2CQfUksz3iyT32ZXzH2mGMWDBA=;
        b=R5+LYG10/dO0B2NOR1vStEHzLs45mSkI/9/ZRBKHZnCP8apEJ13LCOCBxGDp8tXhKm
         2qtXxvrM7gQyT+XwgFWuvL7WkQGa070+FCWwlMjlllMl1N6kxCs4ZKvpOO6+odCGb9DB
         L+xEJhCiMiKBLlOMoUPfSVu0KussGjffvCp/NVgJFiGrx44m/FoahMT6joChVBxWzcv4
         vTT0ld4hzv7TECoL0zUwabQ5sAVSXLPt0/nZkfm21v+SMcUjBYXX3DLz7zkIWqH20MEd
         MS4kcaHvCT6E5D93Mz6zgafxIFh0LRRGCQ0AZkIwv6ShBPvpFgE/7323G28VQpmZtj1H
         FyNw==
X-Gm-Message-State: AOAM533CEg0VM9oiJpOmKgWeuCuoekUIoLh2NY5btDmvzz+oBTK6R2bj
        vhxDLmk6zAI+eJh07iPY8Lo2yg==
X-Google-Smtp-Source: ABdhPJwENFrpIU7Xhf4Zl5AymWSqlMMnYKOiArZ+vRAHZd9/qVLc9guwbLoTcMORFGutADg/dAOGOw==
X-Received: by 2002:aa7:83c6:0:b029:3e0:1f64:6f75 with SMTP id j6-20020aa783c60000b02903e01f646f75mr15962378pfn.69.1629403104650;
        Thu, 19 Aug 2021 12:58:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r16sm3784554pje.10.2021.08.19.12.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 12:58:24 -0700 (PDT)
Date:   Thu, 19 Aug 2021 12:58:22 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>, Likun Gao <Likun.Gao@amd.com>,
        Jiawei Gu <Jiawei.Gu@amd.com>, Evan Quan <evan.quan@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 18/63] drm/amd/pm: Use struct_group() for memcpy()
 region
Message-ID: <202108191214.6269AFD@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-19-keescook@chromium.org>
 <753ef2d1-0f7e-c930-c095-ed86e1518395@amd.com>
 <202108181619.B603481527@keescook>
 <e56aad3c-a06f-da07-f491-a894a570d78f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e56aad3c-a06f-da07-f491-a894a570d78f@amd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 10:33:43AM +0530, Lazar, Lijo wrote:
> On 8/19/2021 5:29 AM, Kees Cook wrote:
> > On Wed, Aug 18, 2021 at 05:12:28PM +0530, Lazar, Lijo wrote:
> > > 
> > > On 8/18/2021 11:34 AM, Kees Cook wrote:
> > > > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > > > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > > > intentionally writing across neighboring fields.
> > > > 
> > > > Use struct_group() in structs:
> > > > 	struct atom_smc_dpm_info_v4_5
> > > > 	struct atom_smc_dpm_info_v4_6
> > > > 	struct atom_smc_dpm_info_v4_7
> > > > 	struct atom_smc_dpm_info_v4_10
> > > > 	PPTable_t
> > > > so the grouped members can be referenced together. This will allow
> > > > memcpy() and sizeof() to more easily reason about sizes, improve
> > > > readability, and avoid future warnings about writing beyond the end of
> > > > the first member.
> > > > 
> > > > "pahole" shows no size nor member offset changes to any structs.
> > > > "objdump -d" shows no object code changes.
> > > > 
> > > > Cc: "Christian König" <christian.koenig@amd.com>
> > > > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > > > Cc: David Airlie <airlied@linux.ie>
> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > Cc: Hawking Zhang <Hawking.Zhang@amd.com>
> > > > Cc: Feifei Xu <Feifei.Xu@amd.com>
> > > > Cc: Lijo Lazar <lijo.lazar@amd.com>
> > > > Cc: Likun Gao <Likun.Gao@amd.com>
> > > > Cc: Jiawei Gu <Jiawei.Gu@amd.com>
> > > > Cc: Evan Quan <evan.quan@amd.com>
> > > > Cc: amd-gfx@lists.freedesktop.org
> > > > Cc: dri-devel@lists.freedesktop.org
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2FCADnq5_Npb8uYvd%2BR4UHgf-w8-cQj3JoODjviJR_Y9w9wqJ71mQ%40mail.gmail.com&amp;data=04%7C01%7Clijo.lazar%40amd.com%7C3861f20094074bf7328808d962a433f2%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637649279701053991%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=386LcfJJGfQfHsXBuK17LMqxJ2nFtGoj%2FUjoN2ZtJd0%3D&amp;reserved=0
> > > > ---
> > > >    drivers/gpu/drm/amd/include/atomfirmware.h           |  9 ++++++++-
> > > >    .../gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h    |  3 ++-
> > > >    drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h  |  3 ++-
> > > >    .../gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h   |  3 ++-
> > > 
> > > Hi Kees,
> > 
> > Hi! Thanks for looking into this.
> > 
> > > The headers which define these structs are firmware/VBIOS interfaces and are
> > > picked directly from those components. There are difficulties in grouping
> > > them to structs at the original source as that involves other component
> > > changes.
> > 
> > So, can you help me understand this a bit more? It sounds like these are
> > generated headers, yes? I'd like to understand your constraints and
> > weight them against various benefits that could be achieved here.
> > 
> > The groupings I made do appear to be roughly documented already,
> > for example:
> > 
> >     struct   atom_common_table_header  table_header;
> >       // SECTION: BOARD PARAMETERS
> > +  struct_group(dpm_info,
> > 
> > Something emitted the "BOARD PARAMETERS" section heading as a comment,
> > so it likely also would know where it ends, yes? The good news here is
> > that for the dpm_info groups, they all end at the end of the existing
> > structs, see:
> > 	struct atom_smc_dpm_info_v4_5
> > 	struct atom_smc_dpm_info_v4_6
> > 	struct atom_smc_dpm_info_v4_7
> > 	struct atom_smc_dpm_info_v4_10
> > 
> > The matching regions in the PPTable_t structs are similarly marked with a
> > "BOARD PARAMETERS" section heading comment:
> > 
> > --- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> > +++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> > @@ -643,6 +643,7 @@ typedef struct {
> >     // SECTION: BOARD PARAMETERS
> >     // SVI2 Board Parameters
> > +  struct_group(v4_6,
> >     uint16_t     MaxVoltageStepGfx; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
> >     uint16_t     MaxVoltageStepSoc; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
> > @@ -728,10 +729,10 @@ typedef struct {
> >     uint32_t     BoardVoltageCoeffB;    // decode by /1000
> >     uint32_t     BoardReserved[7];
> > +  );
> >     // Padding for MMHUB - do not modify this
> >     uint32_t     MmHubPadding[8]; // SMU internal use
> > -
> >   } PPTable_t;
> > 
> > Where they end seems known as well (the padding switches from a "Board"
> > to "MmHub" prefix at exactly the matching size).
> > 
> > So, given that these regions are already known by the export tool, how
> > about just updating the export tool to emit a struct there? I imagine
> > the problem with this would be the identifier churn needed, but that's
> > entirely mechanical.
> > 
> > However, I'm curious about another aspect of these regions: they are,
> > by definition, the same. Why isn't there a single struct describing
> > them already, given the existing redundancy? For example, look at the
> > member names: maxvoltagestepgfx vs MaxVoltageStepGfx. Why aren't these
> > the same? And then why aren't they described separately?
> > 
> > Fixing that would cut down on the redundancy here, and in the renaming,
> > you can fix the identifiers as well. It should be straight forward to
> > write a Coccinelle script to do this renaming for you after extracting
> > the structure.
> > 
> > > The driver_if_* files updates are frequent and it is error prone to manually
> > > group them each time we pick them for any update.
> > 
> > Why are these structs updated? It looks like they're specifically
> > versioned, and aren't expected to change (i.e. v4.5, v4.6, v4.10, etc).
> > 
> > > Our usage of memcpy in this way is restricted only to a very few places.
> > 
> > True, there's 1 per PPTable_t duplication. With a proper struct, you
> > wouldn't even need a memcpy().
> > 
> > Instead of the existing:
> >                 memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
> >                         sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));
> > 
> > or my proposed:
> >                 memcpy(&smc_pptable->v4, &smc_dpm_table_v4_7->dpm_info,
> >                        sizeof(smc_dpm_table_v4_7->dpm_info));
> > 
> > you could just have:
> > 		smc_pptable->v4 = smc_dpm_table_v4_7->dpm_info;
> > 
> > since they'd be explicitly the same type.
> > 
> > That looks like a much cleaner solution to this. It greatly improves
> > readability, reduces the redundancy in the headers, and should be a
> > simple mechanical refactoring.
> > 
> > Oh my, I just noticed append_vbios_pptable() in
> > drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
> > which does an open-coded assignment of the entire PPTable_t, including
> > padding, and, apparently, the i2c address twice:
> > 
> >          ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;
> > 
> >          ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;
> > 
> > > As another option - is it possible to have a helper function/macro like
> > > memcpy_fortify() which takes the extra arguments and does the extra compile
> > > time checks? We will use the helper whenever we have such kind of usage.
> > 
> > I'd rather avoid special cases just for this, especially when the code
> > here is already doing a couple things we try to avoid in the rest of
> > the kernel (i.e. open coded redundant struct contents, etc).
> > 
> > If something mechanically produced append_vbios_pptable() above, I bet
> > we can get rid of the memcpy()s entirely and save a lot of code doing a
> > member-to-member assignment.
> > 
> > What do you think?
> > 
> 
> Hi Kees,
> 
> Will give a background on why there are multiple headers and why it's
> structured this way. That may help to better understand this arrangement.
> 
> This code is part of driver for AMD GPUs. These GPUs get to the consumers
> through multiple channels - AMD designs a few boards with those, there are
> add-in-board partners like ASRock, Sapphire etc. who take these ASICs and
> design their own boards, and others like OEM vendors who have their own
> design for boards in their laptops.
> 
> As you have noticed, this particular section in the structure carries
> information categorized as 'BOARD PARAMETERS'. Since there are multiple
> vendors designing their own boards, this gives the option to customize the
> parameters based on their board design.
> 
> There are a few components in AMD GPUs which are interested in these board
> parameters main ones being - Video BIOS (VBIOS) and power management
> firmware (PMFW). There needs to be a single source where a vendor can input
> the information and that is decided as VBIOS. VBIOS carries different data
> tables which carry other information also (some of which are used by
> driver), so this information is added as a separate data table in VBIOS. A
> board vendor can customize the VBIOS build with this information.
> 
> The data tables (and some other interfaces with driver) carried by VBIOS are
> published in this header - drivers/gpu/drm/amd/include/atomfirmware.h

I understand this to mean that this header is shared by other projects?

If that's true, what compilers are processing this header? (i.e. so I
can scope my suggestions to things that all the compilers will be able
to deal with.)

How are edits of this file managed "upstream" from the Linux kernel?

Why does it have strange indentations like this:

  uint8_t  ledpin0;
  uint8_t  ledpin1;
  uint8_t  ledpin2;
  uint8_t  padding8_4;

	uint8_t  pllgfxclkspreadenabled;
	uint8_t  pllgfxclkspreadpercent;
	uint16_t pllgfxclkspreadfreq;

  uint8_t uclkspreadenabled;
  uint8_t uclkspreadpercent;
  uint16_t uclkspreadfreq;


> There are multiple families of AMD GPUs like Navi10, Arcturus, Aldebaran
> etc. and the board specific details change with different families of GPUs.
> However, VBIOS team publishes a common header file for these GPUs and any
> difference in data tables (between GPU families) is maintained through a
> versioning scheme. Thus there are different tables like
> atom_smc_dpm_info_v4_5, atom_smc_dpm_info_v4_6 etc. which are relevant for a
> particular family of GPUs.
> 
> With newer VBIOS versions and new GPU families, there could be changes in
> the structs defined in atomfirmware.h and we pick the header accordingly.
> 
> As mentioned earlier, one other user of the board specific information is
> power management firmware (PMFW). PMFW design is isolated from the actual
> source of board information. In addition to board specific information, PMFW
> needs some other info as well and driver is the one responsible for passing
> this info to the firmware. PMFW gives an interface header to driver
> providing the different struct formats which are used in driver<->PMFW
> interactions. Unlike VBIOS, these interface headers are defined per family
> of ASICs and those are smu11_driver_if_arcturus.h, smu11_driver_if_* etc.
> (in short driver_if_* files). Like VBIOS,  with newer firmware versions,
> there could be changes in the different structs defined in these headers and
> we pick them accordingly.

Are these headers also shared between other projects?

What's needed to coordinate making these less redundant? (i.e. replacing
the "BOARD PARAMETERS" portion of PPTable_t with the associated
struct *_dpm_info_v* from atomfirmware.h?)

> Driver acts the intermediary between actual source of board information
> (VBIOS) and PMFW. So what is being done here is driver picks the board
> information from VBIOS table, strips the VBIOS table header and passes it as
> part of PPTable_t which defines all the information that is needed by PMFW
> from driver for enabling dynamic power management.
> 
> In summary, these headers are not generated and not owned by driver. They
> define the interfaces of two different components with driver, and are
> consumed by those components themselves. A simple change to group the
> information as a separate structure involves changes in multiple components
> like VBIOS, PMFW, software used to build VBIOS, Windows driver etc.
> 
> In all practical cases, this code is harmless as these structs (in both
> headers) are well defined for a specific family of GPUs. There is always a
> reserve field defined with some extra bytes so that the size is not affected
> if at all new fields need to be added.

It sounds like it's unlikely that the headers will be able to change? If
that's true, it seems like a good idea to mark those headers very
clearly at the top with details like you describe here. Maybe something
like:

/*
 * This header file is shared between VBIOS, Windows drivers, and Linux
 * drivers. Any changes need to be well justified and coordinated with
 * email@address...
 */

And in looking through these, I notice there's a typo in the Description:

    header file of general definitions for OS nd pre-OS video drivers

nd -> and

> The patch now makes us to modify the headers for Linux through
> script/manually whenever we pick them, and TBH that strips off the coherency
> with the original source. The other option is field by field copy. Now we
> use memcpy as a safe bet so that a new field added later taking some reserve
> space is not missed even if we miss a header update.

How does this look as a work-around for now:


diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 96e895d6be35..4605934a4fb7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1446,4 +1446,29 @@ static inline int amdgpu_in_reset(struct amdgpu_device *adev)
 {
 	return atomic_read(&adev->in_gpu_reset);
 }
+
+/**
+ * memcpy_trailing - Copy the end of one structure into the middle of another
+ *
+ * @dst: Pointer to destination struct
+ * @first_dst_member: The member name in @dst where the overwrite begins
+ * @last_dst_member: The member name in @dst where the overwrite ends after
+ * @src: Pointer to the source struct
+ * @first_src_member: The member name in @src where the copy begins
+ *
+ */
+#define memcpy_trailing(dst, first_dst_member, last_dst_member,		   \
+		        src, first_src_member)				   \
+({									   \
+	size_t __src_offset = offsetof(typeof(*(src)), first_src_member);  \
+	size_t __src_size = sizeof(*(src)) - __src_offset;		   \
+	size_t __dst_offset = offsetof(typeof(*(dst)), first_dst_member);  \
+	size_t __dst_size = offsetofend(typeof(*(dst)), last_dst_member) - \
+			    __dst_offset;				   \
+	BUILD_BUG_ON(__src_size != __dst_size);				   \
+	__builtin_memcpy((u8 *)(dst) + __dst_offset,			   \
+			 (u8 *)(src) + __src_offset,			   \
+			 __dst_size);					   \
+})
+
 #endif
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 8ab58781ae13..1918e6232319 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -465,10 +465,8 @@ static int arcturus_append_powerplay_table(struct smu_context *smu)
 
 	if ((smc_dpm_table->table_header.format_revision == 4) &&
 	    (smc_dpm_table->table_header.content_revision == 6))
-		memcpy(&smc_pptable->MaxVoltageStepGfx,
-		       &smc_dpm_table->maxvoltagestepgfx,
-		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_6, maxvoltagestepgfx));
-
+		memcpy_trailing(smc_pptable, MaxVoltageStepGfx, BoardReserved,
+				smc_dpm_table, maxvoltagestepgfx);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 2e5d3669652b..b738042e064d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -431,16 +431,16 @@ static int navi10_append_powerplay_table(struct smu_context *smu)
 
 	switch (smc_dpm_table->table_header.content_revision) {
 	case 5: /* nv10 and nv14 */
-		memcpy(smc_pptable->I2cControllers, smc_dpm_table->I2cControllers,
-			sizeof(*smc_dpm_table) - sizeof(smc_dpm_table->table_header));
+		memcpy_trailing(smc_pptable, I2cControllers, BoardReserved,
+				smc_dpm_table, I2cControllers);
 		break;
 	case 7: /* nv12 */
 		ret = amdgpu_atombios_get_data_table(adev, index, NULL, NULL, NULL,
 					      (uint8_t **)&smc_dpm_table_v4_7);
 		if (ret)
 			return ret;
-		memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
-			sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));
+		memcpy_trailing(smc_pptable, I2cControllers, BoardReserved,
+				smc_dpm_table_v4_7, I2cControllers);
 		break;
 	default:
 		dev_err(smu->adev->dev, "smc_dpm_info with unsupported content revision %d!\n",
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index c8eefacfdd37..a6fd7ee314a9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -409,9 +409,8 @@ static int aldebaran_append_powerplay_table(struct smu_context *smu)
 
 	if ((smc_dpm_table->table_header.format_revision == 4) &&
 	    (smc_dpm_table->table_header.content_revision == 10))
-		memcpy(&smc_pptable->GfxMaxCurrent,
-		       &smc_dpm_table->GfxMaxCurrent,
-		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_10, GfxMaxCurrent));
+		memcpy_trailing(smc_pptable, GfxMaxCurrent, reserved,
+				smc_dpm_table, GfxMaxCurrent);
 	return 0;
 }
 

-- 
Kees Cook
