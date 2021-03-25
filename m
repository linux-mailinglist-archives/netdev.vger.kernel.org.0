Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF62634949B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCYOuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCYOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:50:02 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DCAC06174A;
        Thu, 25 Mar 2021 07:50:02 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id z10so1962103qkz.13;
        Thu, 25 Mar 2021 07:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A01xU9scL5QHqCTcEARA+UZXhX3w6QfTLVjGvG0qhWs=;
        b=fjIpx38pKKpF7tuHHnx+6bHTa8GIAr+gRLGjKt2x69P7v8gjKVe3W9dYqxgP9vSwI9
         QihvfqnQepbko6JQmAIRW+EQAppxHtxDBVpKo/ulTx0XeTA+TsLT2XPd5R47EHfs/vL+
         RcfmGpqKXdbxR340ysSTk2TR5aaFQcoTZCnFjyd/rFWDxI9wey0GlS/SNuFSvLhs+psi
         0EVXYddJbSDWFSlhrUt5I6M67vOMO/RGQOVQ0jvf2R4mqWnxzVz/163P9EVlylTqlOyg
         RuvSoLqCSa3d1HolOz0J7uXNfTUCd96jvr8FQ9pq7Hu06fFtmIslpU2LxY/2YEkWewFc
         MUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A01xU9scL5QHqCTcEARA+UZXhX3w6QfTLVjGvG0qhWs=;
        b=EQmldZIvRhPxIqCRsDdjkoQalzl6ePRtPbnagLaXFj9n1qaDLC3YoddTUlK4Dz4d7M
         umjLrutpZZ4KIr5n9UskLKix4ub7sKQ1rIGV+ePI4LdZ3eK+PV0OKQJJ8BOOz10pXzZG
         T8+mVmWb3LTBgbJaBApjkwH/Nl4PGoWC+r75qtQFrsY0Ljb4EaDE43zgqjCJO0mjzIoF
         ypL2uDs5nsEjrEXqRyHCeHdfbl3kcTxm6au7dTHdp9rAS9T832ges3+Nu3HWJX0YmpMe
         2yOqfhx8o/L27/4/IzotHC88Q5TCLBh7Wkp35V3j0WAhZxlvHu0cX4KqfUYlx1X43h42
         8DnA==
X-Gm-Message-State: AOAM532At6N0YPKEkz4ZjxO+iki9p6I2ImF18DH3oviJFRiJ8rR+RwQx
        VTYLSnxwrQ+Uy7tQxZeBG/A=
X-Google-Smtp-Source: ABdhPJx2RAnajmw8ltd8BDZCZjs+AmRvn2izOpJq6Wnqeic5eWA8Vk7CLaR0JiE3Cx4o6fmRuVGtdA==
X-Received: by 2002:a05:620a:1369:: with SMTP id d9mr8566930qkl.378.1616683801356;
        Thu, 25 Mar 2021 07:50:01 -0700 (PDT)
Received: from [192.168.0.41] (71-218-23-248.hlrn.qwest.net. [71.218.23.248])
        by smtp.gmail.com with ESMTPSA id y1sm4324368qki.9.2021.03.25.07.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:50:00 -0700 (PDT)
Subject: Re: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
To:     Arnd Bergmann <arnd@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ning Sun <ning.sun@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        tboot-devel@lists.sourceforge.net,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Sean Paul <seanpaul@chromium.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-12-arnd@kernel.org> <87wntv3bgt.fsf@intel.com>
 <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA@mail.gmail.com>
From:   Martin Sebor <msebor@gmail.com>
Message-ID: <44ad545d-cc07-2e5f-9ec8-ad848f39268a@gmail.com>
Date:   Thu, 25 Mar 2021 08:49:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 3:53 AM, Arnd Bergmann wrote:
> On Thu, Mar 25, 2021 at 9:05 AM Jani Nikula <jani.nikula@linux.intel.com> wrote:
>>> Clearly something is wrong here, but I can't quite figure out what.
>>> Changing the array size to 16 bytes avoids the warning, but is
>>> probably the wrong solution here.
>>
>> Ugh. drm_dp_channel_eq_ok() does not actually require more than
>> DP_LINK_STATUS_SIZE - 2 elements in the link_status. It's some other
>> related functions that do, and in most cases it's convenient to read all
>> those DP_LINK_STATUS_SIZE bytes.
>>
>> However, here the case is slightly different for DP MST, and the change
>> causes reserved DPCD addresses to be read. Not sure it matters, but
>> really I think the problem is what drm_dp_channel_eq_ok() advertizes.
>>
>> I also don't like the array notation with sizes in function parameters
>> in general, because I think it's misleading. Would gcc-11 warn if a
>> function actually accesses the memory out of bounds of the size?
> 
> Yes, that is the point of the warning. Using an explicit length in an
> array argument type tells gcc that the function will never access
> beyond the end of that bound, and that passing a short array
> is a bug.
> 
> I don't know if this /only/ means triggering a warning, or if gcc
> is also able to make optimizations after classifying this as undefined
> behavior that it would not make for an unspecified length.

GCC uses the array parameter notation as a hint for warnings but
it doesn't optimize on this basis and never will be able to because
code that accesses more elements from the array isn't invalid.
Adding static to the bound, as in void f (int[static N]) does
imply that the function won't access more than N elements and
C intends for optimizers to rely on it, although GCC doesn't yet.

The warning for the array notation is a more portable alternative
to explicitly annotating functions with attribute access, and to
-Wvla-parameter for VLA parameters.  The latter seem to be used
relatively rarely, sometimes deliberately because of the bad rap
of VLA objects, even though VLA parameters don't suffer from
the same problems.

Martin

> 
>> Anyway. I don't think we're going to get rid of the array notation
>> anytime soon, if ever, no matter how much I dislike it, so I think the
>> right fix would be to at least state the correct required size in
>> drm_dp_channel_eq_ok().
> 
> Ok. Just to confirm: Changing the declaration to an unspecified length
> avoids the warnings, as does the patch below:
> 
> diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
> index eedbb48815b7..6ebeec3d88a7 100644
> --- a/drivers/gpu/drm/drm_dp_helper.c
> +++ b/drivers/gpu/drm/drm_dp_helper.c
> @@ -46,12 +46,12 @@
>    */
> 
>   /* Helpers for DP link training */
> -static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE], int r)
> +static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2], int r)
>   {
>          return link_status[r - DP_LANE0_1_STATUS];
>   }
> 
> -static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE],
> +static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                               int lane)
>   {
>          int i = DP_LANE0_1_STATUS + (lane >> 1);
> @@ -61,7 +61,7 @@ static u8 dp_get_lane_status(const u8
> link_status[DP_LINK_STATUS_SIZE],
>          return (l >> s) & 0xf;
>   }
> 
> -bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
> +bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                            int lane_count)
>   {
>          u8 lane_align;
> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
> index edffd1dcca3e..160f7fd127b1 100644
> --- a/include/drm/drm_dp_helper.h
> +++ b/include/drm/drm_dp_helper.h
> @@ -1456,7 +1456,7 @@ enum drm_dp_phy {
> 
>   #define DP_LINK_CONSTANT_N_VALUE 0x8000
>   #define DP_LINK_STATUS_SIZE       6
> -bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
> +bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                            int lane_count);
>   bool drm_dp_clock_recovery_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
>                                int lane_count);
> 
> 
> This obviously needs a good explanation in the code and the changelog text,
> which I don't have, but if the above is what you had in mind, please take that
> and add Reported-by/Tested-by: Arnd Bergmann <arnd@arndb.de>.
> 
>         Arnd
> 

