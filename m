Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8E419F7B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhI0Tx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbhI0TxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:53:24 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF32C06176C
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 12:51:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d12-20020a05683025cc00b0054d8486c6b8so3939328otu.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 12:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oGNdujItoKhhov3nyssGvuaPZuIu4dhH2E6LPBUI2Zk=;
        b=n5a+YRsOOgIUqUTPJRjRTftr8NsEqaFGSFm0hRTcHdBh3If+VPh4l5i2kQtv0/KrUl
         DwcnniQEzaxOViyPlvN6i8Wt4YP7xe9DTsTmNutfe3HR+4LDmA1kGbAKvID9+NNOCQcZ
         hVr7e+K7oysU/oBQ0gejY0GT8lmrV6B6GsHh6J088EUeORfSoph6kJnPiWCKIuv06ixW
         gkYmlI5JJ3f4Su9fA0PZhgYXMuqtaxINcmGZGiaH+cMa5AhynG4NM7PUD2Zyl++2/a/O
         Bjz4uKIC2wogvVjvXH57BmTBD9xZmO30n4fb5sCNU0mVSnyIzqoK0fAY715UXJJ5OpkO
         OONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oGNdujItoKhhov3nyssGvuaPZuIu4dhH2E6LPBUI2Zk=;
        b=CkZ8J0G42zZIrF/I3ivxD1xAbSVGg8slRdTy3AvAjDRKP/jpAPjWlZBveH3szKg9et
         BT/s4AbqSIzTpFlOVqsy6+GhMOTZVMRjSP1wQdgMJPK+ehEQMxG3wmAizCCbDIpqe+yH
         pZzhqIAQOv6to9eLf+wal8CYOfvzvL0EEcZtzHpwqXXvHpnBtx+/Co9rKuhGEFcBmSg6
         yukQ3/BU9ZSQiF8czPEtyFwBZQKw29Oo1CHhwpS7nFyZZV8Cgp4VgBrrZoAdP87dUQW/
         QuWIvZL2fa3zUJB6ruPpAwg1iZOO8JL7dSGoll2SI41MBuPzqYysactEcznACQ5VtYe1
         qBQw==
X-Gm-Message-State: AOAM5313TiqTTF0yg5sZRVnGBBQnG2pifPp9A+d4k7V0jcE4UclshgoR
        c8NJ+yMRI6hy+F/nJ8nJMSbp5w==
X-Google-Smtp-Source: ABdhPJwA/ZlTVdGFDpgOatUF45pBeeu8Lr2/NhVyTrZMzlca2c70HTLKatP685zAvEGGCccHf+KOZw==
X-Received: by 2002:a05:6830:1644:: with SMTP id h4mr823764otr.199.1632772305687;
        Mon, 27 Sep 2021 12:51:45 -0700 (PDT)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id o19sm3911701otj.62.2021.09.27.12.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 12:51:45 -0700 (PDT)
Date:   Mon, 27 Sep 2021 12:52:20 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Arnd Bergmann <arnd@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH] [RFC] qcom_scm: hide Kconfig symbol
Message-ID: <YVIg9CxJGaJr1vpp@ripper>
References: <20210927152412.2900928-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927152412.2900928-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 27 Sep 08:22 PDT 2021, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Now that SCM can be a loadable module, we have to add another
> dependency to avoid link failures when ipa or adreno-gpu are
> built-in:
> 
> aarch64-linux-ld: drivers/net/ipa/ipa_main.o: in function `ipa_probe':
> ipa_main.c:(.text+0xfc4): undefined reference to `qcom_scm_is_available'
> 
> ld.lld: error: undefined symbol: qcom_scm_is_available
> >>> referenced by adreno_gpu.c
> >>>               gpu/drm/msm/adreno/adreno_gpu.o:(adreno_zap_shader_load) in archive drivers/built-in.a
> 
> This can happen when CONFIG_ARCH_QCOM is disabled and we don't select
> QCOM_MDT_LOADER, but some other module selects QCOM_SCM. Ideally we'd
> use a similar dependency here to what we have for QCOM_RPROC_COMMON,
> but that causes dependency loops from other things selecting QCOM_SCM.
> 
> This appears to be an endless problem, so try something different this
> time:
> 
>  - CONFIG_QCOM_SCM becomes a hidden symbol that nothing 'depends on'
>    but that is simply selected by all of its users
> 
>  - All the stubs in include/linux/qcom_scm.h can go away
> 
>  - arm-smccc.h needs to provide a stub for __arm_smccc_smc() to
>    allow compile-testing QCOM_SCM on all architectures.
> 
>  - To avoid a circular dependency chain involving RESET_CONTROLLER
>    and PINCTRL_SUNXI, change the 'depends on RESET_CONTROLLER' in
>    the latter one to 'select'.

Can you please help me understand why this is part of the same patch?

> 
> The last bit is rather annoying, as drivers should generally never
> 'select' another subsystem, and about half the users of the reset
> controller interface do this anyway.
> 
> Nevertheless, this version seems to pass all my randconfig tests
> and is more robust than any of the prior versions.
> 
> Comments?
> 

I like it!

It's less confusing than the current scheme, so should be easier to
get right. And I like the fact that we don't need the stubs anymore.


@John, could you please have a look at this as well, wrt GKI.

Regards,
Bjorn

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/firmware/Kconfig                |  4 +-
>  drivers/gpu/drm/msm/Kconfig             |  4 +-
>  drivers/iommu/Kconfig                   |  2 +-
>  drivers/media/platform/Kconfig          |  2 +-
>  drivers/mmc/host/Kconfig                |  2 +-
>  drivers/net/ipa/Kconfig                 |  1 +
>  drivers/net/wireless/ath/ath10k/Kconfig |  2 +-
>  drivers/pinctrl/qcom/Kconfig            |  3 +-
>  drivers/pinctrl/sunxi/Kconfig           |  6 +--
>  include/linux/arm-smccc.h               | 10 ++++
>  include/linux/qcom_scm.h                | 71 -------------------------
>  11 files changed, 23 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 220a58cf0a44..f7dd82ef0b9c 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -203,9 +203,7 @@ config INTEL_STRATIX10_RSU
>  	  Say Y here if you want Intel RSU support.
>  
>  config QCOM_SCM
> -	tristate "Qcom SCM driver"
> -	depends on ARM || ARM64
> -	depends on HAVE_ARM_SMCCC
> +	tristate
>  	select RESET_CONTROLLER
>  
>  config QCOM_SCM_DOWNLOAD_MODE_DEFAULT
> diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
> index e9c6af78b1d7..3ddf739a6f9b 100644
> --- a/drivers/gpu/drm/msm/Kconfig
> +++ b/drivers/gpu/drm/msm/Kconfig
> @@ -17,7 +17,7 @@ config DRM_MSM
>  	select DRM_SCHED
>  	select SHMEM
>  	select TMPFS
> -	select QCOM_SCM if ARCH_QCOM
> +	select QCOM_SCM
>  	select WANT_DEV_COREDUMP
>  	select SND_SOC_HDMI_CODEC if SND_SOC
>  	select SYNC_FILE
> @@ -55,7 +55,7 @@ config DRM_MSM_GPU_SUDO
>  
>  config DRM_MSM_HDMI_HDCP
>  	bool "Enable HDMI HDCP support in MSM DRM driver"
> -	depends on DRM_MSM && QCOM_SCM
> +	depends on DRM_MSM
>  	default y
>  	help
>  	  Choose this option to enable HDCP state machine
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 124c41adeca1..989c83acbfee 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -308,7 +308,7 @@ config APPLE_DART
>  config ARM_SMMU
>  	tristate "ARM Ltd. System MMU (SMMU) Support"
>  	depends on ARM64 || ARM || (COMPILE_TEST && !GENERIC_ATOMIC64)
> -	depends on QCOM_SCM || !QCOM_SCM #if QCOM_SCM=m this can't be =y
> +	select QCOM_SCM
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select ARM_DMA_USE_IOMMU if ARM
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 157c924686e4..80321e03809a 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -565,7 +565,7 @@ config VIDEO_QCOM_VENUS
>  	depends on VIDEO_DEV && VIDEO_V4L2 && QCOM_SMEM
>  	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
>  	select QCOM_MDT_LOADER if ARCH_QCOM
> -	select QCOM_SCM if ARCH_QCOM
> +	select QCOM_SCM
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	help
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 71313961cc54..95b3511b0560 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -547,7 +547,7 @@ config MMC_SDHCI_MSM
>  	depends on MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_IO_ACCESSORS
>  	select MMC_CQHCI
> -	select QCOM_SCM if MMC_CRYPTO && ARCH_QCOM
> +	select QCOM_SCM if MMC_CRYPTO
>  	help
>  	  This selects the Secure Digital Host Controller Interface (SDHCI)
>  	  support present in Qualcomm SOCs. The controller supports
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index 8f99cfa14680..d037682fb7ad 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -4,6 +4,7 @@ config QCOM_IPA
>  	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
>  	select QCOM_MDT_LOADER if ARCH_QCOM
> +	select QCOM_SCM
>  	select QCOM_QMI_HELPERS
>  	help
>  	  Choose Y or M here to include support for the Qualcomm
> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
> index 741289e385d5..ca007b800f75 100644
> --- a/drivers/net/wireless/ath/ath10k/Kconfig
> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> @@ -44,7 +44,7 @@ config ATH10K_SNOC
>  	tristate "Qualcomm ath10k SNOC support"
>  	depends on ATH10K
>  	depends on ARCH_QCOM || COMPILE_TEST
> -	depends on QCOM_SCM || !QCOM_SCM #if QCOM_SCM=m this can't be =y
> +	select QCOM_SCM
>  	select QCOM_QMI_HELPERS
>  	help
>  	  This module adds support for integrated WCN3990 chip connected
> diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
> index 32ea2a8ec02b..5ff4207df66e 100644
> --- a/drivers/pinctrl/qcom/Kconfig
> +++ b/drivers/pinctrl/qcom/Kconfig
> @@ -3,7 +3,8 @@ if (ARCH_QCOM || COMPILE_TEST)
>  
>  config PINCTRL_MSM
>  	tristate "Qualcomm core pin controller driver"
> -	depends on GPIOLIB && (QCOM_SCM || !QCOM_SCM) #if QCOM_SCM=m this can't be =y
> +	depends on GPIOLIB
> +	select QCOM_SCM
>  	select PINMUX
>  	select PINCONF
>  	select GENERIC_PINCONF
> diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
> index 33751a6a0757..3447d2744ca3 100644
> --- a/drivers/pinctrl/sunxi/Kconfig
> +++ b/drivers/pinctrl/sunxi/Kconfig
> @@ -29,7 +29,7 @@ config PINCTRL_SUN6I_A31
>  config PINCTRL_SUN6I_A31_R
>  	bool "Support for the Allwinner A31 R-PIO"
>  	default MACH_SUN6I
> -	depends on RESET_CONTROLLER
> +	select RESET_CONTROLLER
>  	select PINCTRL_SUNXI
>  
>  config PINCTRL_SUN8I_A23
> @@ -55,7 +55,7 @@ config PINCTRL_SUN8I_A83T_R
>  config PINCTRL_SUN8I_A23_R
>  	bool "Support for the Allwinner A23 and A33 R-PIO"
>  	default MACH_SUN8I
> -	depends on RESET_CONTROLLER
> +	select RESET_CONTROLLER
>  	select PINCTRL_SUNXI
>  
>  config PINCTRL_SUN8I_H3
> @@ -81,7 +81,7 @@ config PINCTRL_SUN9I_A80
>  config PINCTRL_SUN9I_A80_R
>  	bool "Support for the Allwinner A80 R-PIO"
>  	default MACH_SUN9I
> -	depends on RESET_CONTROLLER
> +	select RESET_CONTROLLER
>  	select PINCTRL_SUNXI
>  
>  config PINCTRL_SUN50I_A64
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 7d1cabe15262..63ccb5252190 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -321,10 +321,20 @@ asmlinkage unsigned long __arm_smccc_sve_check(unsigned long x0);
>   * from register 0 to 3 on return from the SMC instruction.  An optional
>   * quirk structure provides vendor specific behavior.
>   */
> +#ifdef CONFIG_HAVE_ARM_SMCCC
>  asmlinkage void __arm_smccc_smc(unsigned long a0, unsigned long a1,
>  			unsigned long a2, unsigned long a3, unsigned long a4,
>  			unsigned long a5, unsigned long a6, unsigned long a7,
>  			struct arm_smccc_res *res, struct arm_smccc_quirk *quirk);
> +#else
> +static inline void __arm_smccc_smc(unsigned long a0, unsigned long a1,
> +			unsigned long a2, unsigned long a3, unsigned long a4,
> +			unsigned long a5, unsigned long a6, unsigned long a7,
> +			struct arm_smccc_res *res, struct arm_smccc_quirk *quirk)
> +{
> +	*res = (struct arm_smccc_res){};
> +}
> +#endif
>  
>  /**
>   * __arm_smccc_hvc() - make HVC calls
> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index c0475d1c9885..81cad9e1e412 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -61,7 +61,6 @@ enum qcom_scm_ice_cipher {
>  #define QCOM_SCM_PERM_RW (QCOM_SCM_PERM_READ | QCOM_SCM_PERM_WRITE)
>  #define QCOM_SCM_PERM_RWX (QCOM_SCM_PERM_RW | QCOM_SCM_PERM_EXEC)
>  
> -#if IS_ENABLED(CONFIG_QCOM_SCM)
>  extern bool qcom_scm_is_available(void);
>  
>  extern int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus);
> @@ -115,74 +114,4 @@ extern int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
>  extern int qcom_scm_lmh_profile_change(u32 profile_id);
>  extern bool qcom_scm_lmh_dcvsh_available(void);
>  
> -#else
> -
> -#include <linux/errno.h>
> -
> -static inline bool qcom_scm_is_available(void) { return false; }
> -
> -static inline int qcom_scm_set_cold_boot_addr(void *entry,
> -		const cpumask_t *cpus) { return -ENODEV; }
> -static inline int qcom_scm_set_warm_boot_addr(void *entry,
> -		const cpumask_t *cpus) { return -ENODEV; }
> -static inline void qcom_scm_cpu_power_down(u32 flags) {}
> -static inline u32 qcom_scm_set_remote_state(u32 state,u32 id)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_pas_init_image(u32 peripheral, const void *metadata,
> -		size_t size) { return -ENODEV; }
> -static inline int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr,
> -		phys_addr_t size) { return -ENODEV; }
> -static inline int qcom_scm_pas_auth_and_reset(u32 peripheral)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_pas_shutdown(u32 peripheral) { return -ENODEV; }
> -static inline bool qcom_scm_pas_supported(u32 peripheral) { return false; }
> -
> -static inline int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_io_writel(phys_addr_t addr, unsigned int val)
> -		{ return -ENODEV; }
> -
> -static inline bool qcom_scm_restore_sec_cfg_available(void) { return false; }
> -static inline int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
> -		{ return -ENODEV; }
> -extern inline int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
> -						 u32 cp_nonpixel_start,
> -						 u32 cp_nonpixel_size)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
> -		unsigned int *src, const struct qcom_scm_vmperm *newvm,
> -		unsigned int dest_cnt) { return -ENODEV; }
> -
> -static inline bool qcom_scm_ocmem_lock_available(void) { return false; }
> -static inline int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
> -		u32 size, u32 mode) { return -ENODEV; }
> -static inline int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id,
> -		u32 offset, u32 size) { return -ENODEV; }
> -
> -static inline bool qcom_scm_ice_available(void) { return false; }
> -static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
> -static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> -				       enum qcom_scm_ice_cipher cipher,
> -				       u32 data_unit_size) { return -ENODEV; }
> -
> -static inline bool qcom_scm_hdcp_available(void) { return false; }
> -static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
> -		u32 *resp) { return -ENODEV; }
> -
> -static inline int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
> -				     u64 limit_node, u32 node_id, u64 version)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_lmh_profile_change(u32 profile_id) { return -ENODEV; }
> -
> -static inline bool qcom_scm_lmh_dcvsh_available(void) { return -ENODEV; }
> -#endif
>  #endif
> -- 
> 2.29.2
> 
