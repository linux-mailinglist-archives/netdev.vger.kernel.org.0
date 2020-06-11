Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1381F6DE9
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgFKTTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgFKTTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:19:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC550C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:19:02 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g3so6508292ilq.10
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HM3AqGJPElOxspsL/TgvLbkiRo8IGOBuT4DTNJYHMg8=;
        b=sUWBelGwQdBKxP7Q7+e4/aI/TBJ5MwVvNzCRTCmliTWWuRG0lAgYpIWjIYrYZ5WhWe
         9y7sCsLXeD1KvkJHDUHLqwr7FnDGQ0eSN15TuQ1zT16B1rSpL8sMznuGOFuzys0cyWHD
         kMhj4/4akmpox7YkPhF32LDhdY4lrR9NJgic9zaGaYU4lwgvg+O7mfLQPVMjTMbuUrdI
         btLwJBEi8qlMjloeHPtLCzv7ZDJ5oxmZxkoM5SZsH17wHoosSYXw0WRw09GM3cyp9bLZ
         8BIT6ODT0tBTmGWkODYamKpjb4WHFg0dERi5VTO2eHQV0td/Xj3p33tKqi5xlqKVIcfU
         6lYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HM3AqGJPElOxspsL/TgvLbkiRo8IGOBuT4DTNJYHMg8=;
        b=HI1by+7HUynaU3CTrAsMU9FjrH55dS7icif3KJD8lNMbTQPJULOW0uP3IqEUPl5g+C
         QAmFJP3MpzW5RtJHue8BwpqT6q40reZGr6VkwYEGT1ZWIFocjESb0xluqIhWe3tF+AyB
         k4RSNMk3sTmin72pXUS9XVRndbceIkGLBfVfp2fYy0vz18Y5PzmMg+MgiQXmHaxlv5d/
         Mozm6T+7N15dKMSPRJ9WXtdr056mTbSsjd0mxC53yQcq35gw4n89+IAYbtou83zPwWsZ
         6NI8ll5JnyOrGSDLYFzDVLUTS4bhwi3JgeMqaV9ObAIwrsRugxNZ+Rzs5seAOY52wvH3
         4Jxw==
X-Gm-Message-State: AOAM531FPGIxNXm+mV6q3uXilx7zG5mbPXy0Ry3a4MZmxG1s1vL2yRpT
        gMAWoqfLyf8Y9Alu64KQhtiO3g==
X-Google-Smtp-Source: ABdhPJyNPRrWvZNCyCyGu+KKHk2+mgEP/Y6Gc3xVljOvTqeQpLBInz1ETD28vaNjTn9xL0Wk4H40QA==
X-Received: by 2002:a92:79d1:: with SMTP id u200mr8900913ilc.67.1591903141896;
        Thu, 11 Jun 2020 12:19:01 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id e8sm2060103ill.25.2020.06.11.12.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 12:19:00 -0700 (PDT)
Subject: Re: [PATCH net 1/5] net: ipa: program metadata mask differently
To:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200610195332.2612233-2-elder@linaro.org>
 <202006110832.hKzHUsMH%lkp@intel.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <c864cbed-39ff-3877-03a9-b51630fc2682@linaro.org>
Date:   Thu, 11 Jun 2020 14:18:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <202006110832.hKzHUsMH%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/20 7:19 PM, kernel test robot wrote:
> Hi Alex,
> 
> I love your patch! Perhaps something to improve:

Thanks kernel test robot!

Somehow the "static" specifier got dropped in my patch.

I will fix this when I post version 2, shortly.

					-Alex

> [auto build test WARNING on net/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Alex-Elder/net-ipa-endpoint-configuration-fixes/20200611-035600
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 89dc68533b190117e1a2fb4298d88b96b3580abf
> config: arm64-allyesconfig (attached as .config)
> compiler: aarch64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> <<                  from drivers/net/ipa/ipa_endpoint.c:8:
>>> drivers/net/ipa/ipa_endpoint.c:457:6: warning: no previous prototype for 'ipa_endpoint_init_hdr' [-Wmissing-prototypes]
> 457 | void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
> |      ^~~~~~~~~~~~~~~~~~~~~
> In file included from include/linux/bits.h:23,
> from include/linux/bitops.h:5,
> from include/linux/kernel.h:12,
> from include/linux/list.h:9,
> from include/linux/rculist.h:10,
> from include/linux/pid.h:5,
> from include/linux/sched.h:14,
> from include/linux/ratelimit.h:6,
> from include/linux/dev_printk.h:16,
> from include/linux/device.h:15,
> from drivers/net/ipa/ipa_endpoint.c:8:
> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_config':
> include/linux/bits.h:26:28: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
> 26 |   __builtin_constant_p((l) > (h)), (l) > (h), 0)))
> |                            ^
> include/linux/build_bug.h:16:62: notkke: in definition of macro 'BUILD_BUG_ON_ZERO'
> 16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
> |                                                              ^
> include/linux/bits.h:39:3: note: in expansion of macro 'GENMASK_INPUT_CHECK'
> 39 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
> |   ^~~~~~~~~~~~~~~~~~~
> drivers/net/ipa/ipa_endpoint.c:1546:12: note: in expansion of macro 'GENMASK'
> 1546 |  tx_mask = GENMASK(max - 1, 0);
> |            ^~~~~~~
> include/linux/bits.h:26:40: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
> 26 |   __builtin_constant_p((l) > (h)), (l) > (h), 0)))
> |                                        ^
> include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
> 16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
> |                                                              ^
> include/linux/bits.h:39:3: note: in expansion of macro 'GENMASK_INPUT_CHECK'
> 39 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
> |   ^~~~~~~~~~~~~~~~~~~
> drivers/net/ipa/ipa_endpoint.c:1546:12: note: in expansion of macro 'GENMASK'
> 1546 |  tx_mask = GENMASK(max - 1, 0);
> |            ^~~~~~~
> 
> vim +/ipa_endpoint_init_hdr +457 drivers/net/ipa/ipa_endpoint.c
> 
>    438	
>    439	/**
>    440	 * We program QMAP endpoints so each packet received is preceded by a QMAP
>    441	 * header structure.  The QMAP header contains a 1-byte mux_id and 2-byte
>    442	 * packet size field, and we have the IPA hardware populate both for each
>    443	 * received packet.  The header is configured (in the HDR_EXT register)
>    444	 * to use big endian format.
>    445	 *
>    446	 * The packet size is written into the QMAP header's pkt_len field.  That
>    447	 * location is defined here using the HDR_OFST_PKT_SIZE field.
>    448	 *
>    449	 * The mux_id comes from a 4-byte metadata value supplied with each packet
>    450	 * by the modem.  It is *not* a QMAP header, but it does contain the mux_id
>    451	 * value that we want, in its low-order byte.  A bitmask defined in the
>    452	 * endpoint's METADATA_MASK register defines which byte within the modem
>    453	 * metadata contains the mux_id.  And the OFST_METADATA field programmed
>    454	 * here indicates where the extracted byte should be placed within the QMAP
>    455	 * header.
>    456	 */
>  > 457	void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
>    458	{
>    459		u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
>    460		u32 val = 0;
>    461	
>    462		if (endpoint->data->qmap) {
>    463			size_t header_size = sizeof(struct rmnet_map_header);
>    464	
>    465			/* We might supply a checksum header after the QMAP header */
>    466			if (endpoint->toward_ipa && endpoint->data->checksum)
>    467				header_size += sizeof(struct rmnet_map_ul_csum_header);
>    468			val |= u32_encode_bits(header_size, HDR_LEN_FMASK);
>    469	
>    470			/* Define how to fill mux_id in a received QMAP header */
>    471			if (!endpoint->toward_ipa) {
>    472				u32 off;	/* Field offset within header */
>    473	
>    474				/* Where IPA will write the metadata value */
>    475				off = offsetof(struct rmnet_map_header, mux_id);
>    476				val |= u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
>    477	
>    478				/* Where IPA will write the length */
>    479				off = offsetof(struct rmnet_map_header, pkt_len);
>    480				val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
>    481				val |= u32_encode_bits(off, HDR_OFST_PKT_SIZE_FMASK);
>    482			}
>    483			/* For QMAP TX, metadata offset is 0 (modem assumes this) */
>    484			val |= HDR_OFST_METADATA_VALID_FMASK;
>    485	
>    486			/* HDR_ADDITIONAL_CONST_LEN is 0; (RX only) */
>    487			/* HDR_A5_MUX is 0 */
>    488			/* HDR_LEN_INC_DEAGG_HDR is 0 */
>    489			/* HDR_METADATA_REG_VALID is 0 (TX only) */
>    490		}
>    491	
>    492		iowrite32(val, endpoint->ipa->reg_virt + offset);
>    493	}
>    494	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

