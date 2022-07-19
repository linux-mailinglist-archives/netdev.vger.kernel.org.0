Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0418579581
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiGSIsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiGSIso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6613C8FC;
        Tue, 19 Jul 2022 01:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5B2161790;
        Tue, 19 Jul 2022 08:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD50C341C6;
        Tue, 19 Jul 2022 08:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658220521;
        bh=Y80I/9h5gwXwAl7BrWnNgRboomD0Q/i4fsdukksbxuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ftz2opaB3z+yb8RtydfLoLtaxsjl9hbVDuSH7gqPczmybG3jqnAUX/sMgYFai0B3B
         D/GVCtngIJW3ALxtzJdXN9F9GYV3fLFB6cJSSD+sVPPUikiEIjT0M8UPFkwT0aa5xL
         S6gbKGCyNjELTnqJzmWgE2WySNetGPq/TuPWVf762sbXBQXxv4Ch7L0hoP4OKxhBeF
         wempCKHPca39pk1WqmSOjqnkIctwswq4BX7jZBwaQ4uWPl0JWkCWzcYye7zvAQIS3v
         mXo4NI3t11uKJPh3r7gX87oIZdPIvGwwnzMg2urBDZulfeOAMM5Uk/DRfnKWweGNcg
         ixWwiuFbfaCqw==
Date:   Tue, 19 Jul 2022 09:48:35 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Dave Airlie <airlied@gmail.com>
Cc:     torvalds@linux-foundation.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        Daniel Vetter <daniel@ffwll.ch>, mcgrof@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-block@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines. (v2)
Message-ID: <20220719094835.52197852@sal.lan>
In-Reply-To: <20220719065357.2705918-1-airlied@gmail.com>
References: <20220719065357.2705918-1-airlied@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 19 Jul 2022 16:53:57 +1000
Dave Airlie <airlied@gmail.com> escreveu:

> From: Dave Airlie <airlied@redhat.com>
> 
> A recent snafu where Intel ignored upstream feedback on a firmware
> change, led to a late rc6 fix being required. In order to avoid this
> in the future we should document some expectations around
> linux-firmware.
> 
> I was originally going to write this for drm, but it seems quite generic
> advice.

Indeed it makes sense to document firmware API compatibility in a generic way.

Some suggestions below.

> v2: rewritten with suggestions from Thorsten Leemhuis.
>
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>
> Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  Documentation/driver-api/firmware/core.rst    |  1 +
>  .../firmware/firmware-usage-guidelines.rst    | 34 +++++++++++++++++++
>  2 files changed, 35 insertions(+)
>  create mode 100644 Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> 
> diff --git a/Documentation/driver-api/firmware/core.rst b/Documentation/driver-api/firmware/core.rst
> index 1d1688cbc078..803cd574bbd7 100644
> --- a/Documentation/driver-api/firmware/core.rst
> +++ b/Documentation/driver-api/firmware/core.rst
> @@ -13,4 +13,5 @@ documents these features.
>     direct-fs-lookup
>     fallback-mechanisms
>     lookup-order
> +   firmware-usage-guidelines
>  
> diff --git a/Documentation/driver-api/firmware/firmware-usage-guidelines.rst b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> new file mode 100644
> index 000000000000..34d2412e78c6
> --- /dev/null
> +++ b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> @@ -0,0 +1,34 @@
> +===================
> +Firmware Guidelines
> +===================
> +
> +Drivers that use firmware from linux-firmware should attempt to follow
> +the rules in this guide.
> +
> +* Firmware should be versioned with at least a major/minor version.

It is hard to enforce how vendors will version their firmware. On media,
we have some drivers whose major means different hardware versions. For
instance, on xc3028, v3.x means low voltage chips, while v2.x means
"normal" voltage. We end changing the file name on Linux to avoid the risk
of damaging the hardware, as using v27 firmware on low power chips damage
them. So, we have:

	drivers/media/tuners/xc2028.h:#define XC2028_DEFAULT_FIRMWARE "xc3028-v27.fw"
	drivers/media/tuners/xc2028.h:#define XC3028L_DEFAULT_FIRMWARE "xc3028L-v36.fw"

As their main market is not Linux - nor PC - as their main sales are on 
TV sets, and them don't officially support Linux, there's nothing we can
do to enforce it.

IMO we need a more generic text here to indicate that Linux firmware
files should be defined in a way that it should be possible to detect
when there are incompatibilities with past versions. 
So, I would say, instead:

	Firmware files shall be designed in a way that it allows
	checking for firmware ABI version changes. It is recommended
	that firmware files to be versioned with at least major/minor
	version.

> It
> +  is suggested that the firmware files in linux-firmware be named with
> +  some device specific name, and just the major version. 

> The
> +  major/minor/patch versions should be stored in a header in the
> +  firmware file for the driver to detect any non-ABI fixes/issues. 

I would also make this more generic. On media, we ended adding the firmware
version indicated at the file name. For instance, xc4000 driver checks for
two firmware files:

drivers/media/tuners/xc4000.c:#define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.fw"
drivers/media/tuners/xc4000.c:#define XC4000_DEFAULT_FIRMWARE_NEW "dvb-fe-xc4000-1.4.1.fw"

On such cases, the driver can take decisions based on the firmware name.

I would change the text to be more generic covering both cases:

	The firmware version shall either be stored at the firmware
	header or as part of the firmware file name, in order to let the
	driver to detect any non-ABI fixes/changes.

> The
> +  firmware files in linux-firmware should be overwritten with the newest
> +  compatible major version.

For me "shall" is mandatory, while "should" is optional.

In this specific case, I'm not so sure if overriding it is the best thing 
to do on all subsystems. I mean, even with the same ABI, older firmware 
usually means that some bugs and/or limitations will be present there.

That's specially true on codecs: even having the same ABI, older versions
won't support decoding newer protocols. We have one case with some
digital TV decoders that only support some Cable-TV protocols with
newer firmware versions. We have also one case were remote controller
decoding is buggy with older firmwares. On both situations, the ABI
didn't change.

> Newer major version firmware should remain
> +  compatible with all kernels that load that major number.

	should -> shall

> +
> +* Users should *not* have to install newer firmware to use existing
> +  hardware when they install a newer kernel. 

> If the hardware isn't
> +  enabled by default or under development,

Hmm.. someone might understand that not having a "default Y" at Kconfig
would mean that this is not enabled by default ;-)

IMO you can just tell, instead:

	"This can be ignored until the first kernel release that enables support
	 for such hardware."

> this can be ignored, until
> +  the first kernel release that enables that hardware. 

> This means no
> +  major version bumps without the kernel retaining backwards
> +  compatibility for the older major versions.  Minor version bumps
> +  should not introduce new features that newer kernels depend on
> +  non-optionally.
> +
> +* If a security fix needs lockstep firmware and kernel fixes in order to
> +  be successful, then all supported major versions in the linux-firmware
> +  repo should be updated with the security fix, and the kernel patches
> +  should detect if the firmware is new enough to declare if the security
> +  issue is fixed.  All communications around security fixes should point
> +  at both the firmware and kernel fixes. If a security fix requires
> +  deprecating old major versions, then this should only be done as a
> +  last option, and be stated clearly in all communications.
> +

Perfect!

Regards,
Mauro
