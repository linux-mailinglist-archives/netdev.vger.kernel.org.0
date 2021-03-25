Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B15348D6F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCYJxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCYJxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 05:53:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A4E61A24;
        Thu, 25 Mar 2021 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616666011;
        bh=zDIkwCmITSxBLdjnUtP8aWuLpPIn7yP+onOPa2fWtIM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aw+dq7xqFwszvQn+7YjwXW7/fxugShYPXJjaDJagcTuDAOuB8E9nNiKezq66fA/8m
         hFuPlB/FQy5OaxdMAZxMHga0tzWzb7PQ6p+xNpG4X8bAN7OAf2G+Qkm0llEzqPMeL1
         Kid4PdS5VCb6nVOuYhBFHH0Yau0kHvVybsDn9ffxag5/mdTWHzlRYsdW/dxayQNar3
         KY8Ym1MijDJv/mTgzfTa/iwhfzr2YqelyjbMy1v1O0PJUB5A8eiQqK6LL68YF5Ta8p
         SByPQKDJncOjrUNNBuwi03nuXQ11JZYKUdMwcj0KubiMCvSEyc/5dYjwzZVUc5ZcXd
         6uORErooXgDMw==
Received: by mail-oi1-f174.google.com with SMTP id n140so1511569oig.9;
        Thu, 25 Mar 2021 02:53:31 -0700 (PDT)
X-Gm-Message-State: AOAM531+Fc0vPk+snEmfO/sX6kulbyC9mLBlEz92JVW/lZGGQK++d02J
        xEDrMZrr7OU5O4u3f59H+2m+hy9PpwOT9kGs664=
X-Google-Smtp-Source: ABdhPJyt+33nuIsqD16dqkOAUJq8r6LTgDPW80yQCvhzID/3JW2uxW7CNu42WWpingJPnDTPb6eqRDMwNCcIjLZ5/jc=
X-Received: by 2002:aca:5945:: with SMTP id n66mr5293345oib.11.1616666010658;
 Thu, 25 Mar 2021 02:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-12-arnd@kernel.org>
 <87wntv3bgt.fsf@intel.com>
In-Reply-To: <87wntv3bgt.fsf@intel.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Mar 2021 10:53:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA@mail.gmail.com>
Message-ID: <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA@mail.gmail.com>
Subject: Re: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 9:05 AM Jani Nikula <jani.nikula@linux.intel.com> wrote:
> > Clearly something is wrong here, but I can't quite figure out what.
> > Changing the array size to 16 bytes avoids the warning, but is
> > probably the wrong solution here.
>
> Ugh. drm_dp_channel_eq_ok() does not actually require more than
> DP_LINK_STATUS_SIZE - 2 elements in the link_status. It's some other
> related functions that do, and in most cases it's convenient to read all
> those DP_LINK_STATUS_SIZE bytes.
>
> However, here the case is slightly different for DP MST, and the change
> causes reserved DPCD addresses to be read. Not sure it matters, but
> really I think the problem is what drm_dp_channel_eq_ok() advertizes.
>
> I also don't like the array notation with sizes in function parameters
> in general, because I think it's misleading. Would gcc-11 warn if a
> function actually accesses the memory out of bounds of the size?

Yes, that is the point of the warning. Using an explicit length in an
array argument type tells gcc that the function will never access
beyond the end of that bound, and that passing a short array
is a bug.

I don't know if this /only/ means triggering a warning, or if gcc
is also able to make optimizations after classifying this as undefined
behavior that it would not make for an unspecified length.

> Anyway. I don't think we're going to get rid of the array notation
> anytime soon, if ever, no matter how much I dislike it, so I think the
> right fix would be to at least state the correct required size in
> drm_dp_channel_eq_ok().

Ok. Just to confirm: Changing the declaration to an unspecified length
avoids the warnings, as does the patch below:

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index eedbb48815b7..6ebeec3d88a7 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -46,12 +46,12 @@
  */

 /* Helpers for DP link training */
-static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE], int r)
+static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2], int r)
 {
        return link_status[r - DP_LANE0_1_STATUS];
 }

-static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE],
+static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
                             int lane)
 {
        int i = DP_LANE0_1_STATUS + (lane >> 1);
@@ -61,7 +61,7 @@ static u8 dp_get_lane_status(const u8
link_status[DP_LINK_STATUS_SIZE],
        return (l >> s) & 0xf;
 }

-bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
+bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
                          int lane_count)
 {
        u8 lane_align;
diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index edffd1dcca3e..160f7fd127b1 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -1456,7 +1456,7 @@ enum drm_dp_phy {

 #define DP_LINK_CONSTANT_N_VALUE 0x8000
 #define DP_LINK_STATUS_SIZE       6
-bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
+bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
                          int lane_count);
 bool drm_dp_clock_recovery_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
                              int lane_count);


This obviously needs a good explanation in the code and the changelog text,
which I don't have, but if the above is what you had in mind, please take that
and add Reported-by/Tested-by: Arnd Bergmann <arnd@arndb.de>.

       Arnd
