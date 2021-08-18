Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F77A3F0EE6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhHSAAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 20:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbhHRX76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 19:59:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8028BC061796
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:59:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a5so2877431plh.5
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ihRSUosZ1n/QH58LU5drX97jQNk+oYE3vHV9UEG8bhY=;
        b=ll0X1F/1yJb+64r0U9YpjrHHbzyCyA3JdVLIsZBGSDD5G8By6g0Da0FvU5ma5PfPOz
         QC4sz18rY2gpOQxJm5PmQyk9q0bDlmToRffwWKkDWOoZx6TCSYGWys/Yplpd7VScrov4
         Ino9fR/0iet8k+NaPzK7xaA5zNSBEEQ3I0jbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ihRSUosZ1n/QH58LU5drX97jQNk+oYE3vHV9UEG8bhY=;
        b=ZVTIVxBqeXPpDzlP+00THXqvTuTxlodqJESRCI5oOmwbplZ/mnG0C09QaDcVwcXwvY
         6/Yj4E/QZrXiqEXxLRLlp3YzXoSvLayWdmZd+iT5t94q+3/FTaFK8yf4tsLlN/7LNtb6
         Xm3SB9Bygfy35ll/ZEz9dwCUH9tI/ZoUni+HpJ1bhj0NjEDxpVHMI58zhWYemLsENPfw
         6cz11Dy6fU0RuNaZnWTvhivAusoUh9nfe7gnRN8Bhazcoc/ts+mACuqqtvvUyZ09PWzD
         wJxIEM+1PvyINlHeKSQePZJv/YOE33lqbx16K2lapQ6sUVib3DngJbosrx3R3zBHs3yQ
         848g==
X-Gm-Message-State: AOAM5339VGifj1KuRGJczBezB7O93L0z445yBSWjcrLJqhGzanofJafT
        1Nb5lxX3tXKNLr30oze0W8S4/A==
X-Google-Smtp-Source: ABdhPJyqLAVutuhaUvZwqCN9mzT6ajj2JdJOPLObLJIeTaHnjuorpiaj1FYbc1rllZLoCI06EyvNXg==
X-Received: by 2002:a17:90a:c006:: with SMTP id p6mr11982780pjt.144.1629331163071;
        Wed, 18 Aug 2021 16:59:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q4sm834430pjd.52.2021.08.18.16.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:59:22 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:59:21 -0700
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
Message-ID: <202108181619.B603481527@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-19-keescook@chromium.org>
 <753ef2d1-0f7e-c930-c095-ed86e1518395@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <753ef2d1-0f7e-c930-c095-ed86e1518395@amd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 05:12:28PM +0530, Lazar, Lijo wrote:
> 
> On 8/18/2021 11:34 AM, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > Use struct_group() in structs:
> > 	struct atom_smc_dpm_info_v4_5
> > 	struct atom_smc_dpm_info_v4_6
> > 	struct atom_smc_dpm_info_v4_7
> > 	struct atom_smc_dpm_info_v4_10
> > 	PPTable_t
> > so the grouped members can be referenced together. This will allow
> > memcpy() and sizeof() to more easily reason about sizes, improve
> > readability, and avoid future warnings about writing beyond the end of
> > the first member.
> > 
> > "pahole" shows no size nor member offset changes to any structs.
> > "objdump -d" shows no object code changes.
> > 
> > Cc: "Christian König" <christian.koenig@amd.com>
> > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: Hawking Zhang <Hawking.Zhang@amd.com>
> > Cc: Feifei Xu <Feifei.Xu@amd.com>
> > Cc: Lijo Lazar <lijo.lazar@amd.com>
> > Cc: Likun Gao <Likun.Gao@amd.com>
> > Cc: Jiawei Gu <Jiawei.Gu@amd.com>
> > Cc: Evan Quan <evan.quan@amd.com>
> > Cc: amd-gfx@lists.freedesktop.org
> > Cc: dri-devel@lists.freedesktop.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2FCADnq5_Npb8uYvd%2BR4UHgf-w8-cQj3JoODjviJR_Y9w9wqJ71mQ%40mail.gmail.com&amp;data=04%7C01%7Clijo.lazar%40amd.com%7C92b8d2f072f0444b9f8508d9620f6971%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637648640625729624%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=rKh5LUXCRUsorYM3kSpG2tkB%2Fczwl9I9EBnWBCtbg6Q%3D&amp;reserved=0
> > ---
> >   drivers/gpu/drm/amd/include/atomfirmware.h           |  9 ++++++++-
> >   .../gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h    |  3 ++-
> >   drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h  |  3 ++-
> >   .../gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h   |  3 ++-
> 
> Hi Kees,

Hi! Thanks for looking into this.

> The headers which define these structs are firmware/VBIOS interfaces and are
> picked directly from those components. There are difficulties in grouping
> them to structs at the original source as that involves other component
> changes.

So, can you help me understand this a bit more? It sounds like these are
generated headers, yes? I'd like to understand your constraints and
weight them against various benefits that could be achieved here.

The groupings I made do appear to be roughly documented already,
for example:

   struct   atom_common_table_header  table_header;
     // SECTION: BOARD PARAMETERS
+  struct_group(dpm_info,

Something emitted the "BOARD PARAMETERS" section heading as a comment,
so it likely also would know where it ends, yes? The good news here is
that for the dpm_info groups, they all end at the end of the existing
structs, see:
	struct atom_smc_dpm_info_v4_5
	struct atom_smc_dpm_info_v4_6
	struct atom_smc_dpm_info_v4_7
	struct atom_smc_dpm_info_v4_10

The matching regions in the PPTable_t structs are similarly marked with a
"BOARD PARAMETERS" section heading comment:

--- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
@@ -643,6 +643,7 @@ typedef struct {
   // SECTION: BOARD PARAMETERS
 
   // SVI2 Board Parameters
+  struct_group(v4_6,
   uint16_t     MaxVoltageStepGfx; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
   uint16_t     MaxVoltageStepSoc; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
 
@@ -728,10 +729,10 @@ typedef struct {
   uint32_t     BoardVoltageCoeffB;    // decode by /1000
 
   uint32_t     BoardReserved[7];
+  );
 
   // Padding for MMHUB - do not modify this
   uint32_t     MmHubPadding[8]; // SMU internal use
-
 } PPTable_t;

Where they end seems known as well (the padding switches from a "Board"
to "MmHub" prefix at exactly the matching size).

So, given that these regions are already known by the export tool, how
about just updating the export tool to emit a struct there? I imagine
the problem with this would be the identifier churn needed, but that's
entirely mechanical.

However, I'm curious about another aspect of these regions: they are,
by definition, the same. Why isn't there a single struct describing
them already, given the existing redundancy? For example, look at the
member names: maxvoltagestepgfx vs MaxVoltageStepGfx. Why aren't these
the same? And then why aren't they described separately?

Fixing that would cut down on the redundancy here, and in the renaming,
you can fix the identifiers as well. It should be straight forward to
write a Coccinelle script to do this renaming for you after extracting
the structure.

> The driver_if_* files updates are frequent and it is error prone to manually
> group them each time we pick them for any update.

Why are these structs updated? It looks like they're specifically
versioned, and aren't expected to change (i.e. v4.5, v4.6, v4.10, etc).

> Our usage of memcpy in this way is restricted only to a very few places.

True, there's 1 per PPTable_t duplication. With a proper struct, you
wouldn't even need a memcpy().

Instead of the existing:
               memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
                       sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));

or my proposed:
               memcpy(&smc_pptable->v4, &smc_dpm_table_v4_7->dpm_info,
                      sizeof(smc_dpm_table_v4_7->dpm_info));

you could just have:
		smc_pptable->v4 = smc_dpm_table_v4_7->dpm_info;

since they'd be explicitly the same type.

That looks like a much cleaner solution to this. It greatly improves
readability, reduces the redundancy in the headers, and should be a
simple mechanical refactoring.

Oh my, I just noticed append_vbios_pptable() in
drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
which does an open-coded assignment of the entire PPTable_t, including
padding, and, apparently, the i2c address twice:

        ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;

        ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;

> As another option - is it possible to have a helper function/macro like
> memcpy_fortify() which takes the extra arguments and does the extra compile
> time checks? We will use the helper whenever we have such kind of usage.

I'd rather avoid special cases just for this, especially when the code
here is already doing a couple things we try to avoid in the rest of
the kernel (i.e. open coded redundant struct contents, etc).

If something mechanically produced append_vbios_pptable() above, I bet
we can get rid of the memcpy()s entirely and save a lot of code doing a
member-to-member assignment.

What do you think?

-Kees

-- 
Kees Cook
