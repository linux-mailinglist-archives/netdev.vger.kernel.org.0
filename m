Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCE2D7321
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437498AbgLKJxF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Dec 2020 04:53:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:34410 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394039AbgLKJw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 04:52:56 -0500
IronPort-SDR: 44vVqCSzTldSRf3mcw6itLM+sODRFCKzg0H1VqoYllviQshHf/NT89iCOWes5DlH6UyAIoRjdo
 Lu6fqZnnBWqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="236002886"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236002886"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 01:52:14 -0800
IronPort-SDR: PVl8OU8ROdRYNRcuuI1cwHnm0Pahwqqsf4O0coU6GZWsYYiN/hRTouvAiYE5Ccs0+xvEJJqBLa
 InJ3eAdxnHfQ==
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="440808660"
Received: from dkreft-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.158.206])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 01:52:00 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Russell King <linux@armlinux.org.uk>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Helge Deller <deller@gmx.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-pci@vger.kernel.org, xen-devel@lists.xenproject.org,
        intel-gfx@lists.freedesktop.org,
        Wambui Karuga <wambui.karugax@gmail.com>,
        Allen Hubbe <allenbh@gmail.com>, Will Deacon <will@kernel.org>,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        linux-gpio@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Juergen Gross <jgross@suse.com>,
        David Airlie <airlied@linux.ie>, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Jon Mason <jdmason@kudzu.us>,
        linux-ntb@googlegroups.com, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-gfx] [patch 13/30] drm/i915/lpe_audio: Remove pointless irq_to_desc() usage
In-Reply-To: <X9J7h+myHaraeoKH@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20201210192536.118432146@linutronix.de> <20201210194043.862572239@linutronix.de> <X9J7h+myHaraeoKH@intel.com>
Date:   Fri, 11 Dec 2020 11:51:57 +0200
Message-ID: <87zh2k7jr6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> On Thu, Dec 10, 2020 at 08:25:49PM +0100, Thomas Gleixner wrote:
>> Nothing uses the result and nothing should ever use it in driver code.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Daniel Vetter <daniel@ffwll.ch>
>> Cc: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Wambui Karuga <wambui.karugax@gmail.com>
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: dri-devel@lists.freedesktop.org
>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Thomas, I presume you want to merge this series as a whole.

Acked-by: Jani Nikula <jani.nikula@intel.com>

for merging via whichever tree makes most sense. Please let us know if
you want us to pick this up via drm-intel instead.

>
>> ---
>>  drivers/gpu/drm/i915/display/intel_lpe_audio.c |    4 ----
>>  1 file changed, 4 deletions(-)
>> 
>> --- a/drivers/gpu/drm/i915/display/intel_lpe_audio.c
>> +++ b/drivers/gpu/drm/i915/display/intel_lpe_audio.c
>> @@ -297,13 +297,9 @@ int intel_lpe_audio_init(struct drm_i915
>>   */
>>  void intel_lpe_audio_teardown(struct drm_i915_private *dev_priv)
>>  {
>> -	struct irq_desc *desc;
>> -
>>  	if (!HAS_LPE_AUDIO(dev_priv))
>>  		return;
>>  
>> -	desc = irq_to_desc(dev_priv->lpe_audio.irq);
>> -
>>  	lpe_audio_platdev_destroy(dev_priv);
>>  
>>  	irq_free_desc(dev_priv->lpe_audio.irq);
>> 
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Graphics Center
