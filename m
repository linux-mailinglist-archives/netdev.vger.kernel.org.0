Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840DE1D9380
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgESJlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 05:41:35 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0985FC061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:41:35 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z72so2719778wmc.2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PuOONN1H8b6oeg6VMw0TZ0gk2wRB6fh62ynnHxPsqlA=;
        b=tlzffMPaslLR5ntuXrrOCB0v7e848GupGmNHV6sD6jJavUXbh/rdEh3Q9qBE2XoXi3
         JnjwTUJ7WpiXzV03Hxh30EKhh5bGD1By6maFpxTrRm4sSGCZ7ie20voIfp/sVQWrTGBh
         /B9V6r9ODs344bABQbdwWeoX6oVnZLBdWHeUligoIIbFjts7N27eukTNe8MvfHjo6OQM
         bZT8Cd/yBSLE3/zVvhQivu/v+qazDdyu01vvxpzKIrrsbnXtyc2GYSZJwAP/WkpnhNk+
         UsdA3V4tKcLk6ZOtZ4osg0dk/HTmiCK8dOvbPZhXuA9JnHtVOhU3PlFdUITq5cG7qCXY
         BsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PuOONN1H8b6oeg6VMw0TZ0gk2wRB6fh62ynnHxPsqlA=;
        b=QbrTUZbD2L29dG3kxyyUS514Fbv73liSvjRtmcqB9YwKYpfKFd3o4YtTHk2ZW/SEm1
         YTQXnvKWVs6ypzrcG2Fe/FFIXnaY0QlK8Fp8tqc7Mz9yxqr3aFXIbBK5zQnJuKPmIYHQ
         tnl0rrFXwdcXzg+OBMHv21d8waUHD5nkmcV/kpEaiISfBU92Dc96ZRTvLtnbf2Mz5rEE
         BeKCi/JjAsY2aSHBGQEkJCCZBGVA+EvLRTQ+gyFONLCYRob2EXizFkLaPfwiwLhguiLd
         +kuJ9UYXASUONvWf/pi4earHvQOaU3FZ2VqRkc3XXkYcan/zxnJ+UC27y29hnAG6hqdN
         6y+A==
X-Gm-Message-State: AOAM533B1wBJJ4qBxzt8EzjXD4f24QWWiKL4cGWlUXWDvl53JK0eud3F
        jCXWcyp/sBepKH5QFoZpIVVhOfXLL4o=
X-Google-Smtp-Source: ABdhPJzcFQ2uiibUhcupMRN1k6d16huFyeu2qQZOZkbqNJSB0R+NgLYBh/0KuHxY4t7uu9fUJSu4Mg==
X-Received: by 2002:a05:600c:1403:: with SMTP id g3mr4665585wmi.51.1589881293655;
        Tue, 19 May 2020 02:41:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i4sm15689833wrv.23.2020.05.19.02.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 02:41:33 -0700 (PDT)
Date:   Tue, 19 May 2020 11:41:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519094132.GG4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
 <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
 <20200519073032.GE4655@nanopsycho>
 <CACKFLinpyX-sgkOMQd=uEVZzn1-+doJoV-t5NRRNrcnE+=tR3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLinpyX-sgkOMQd=uEVZzn1-+doJoV-t5NRRNrcnE+=tR3A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 10:41:44AM CEST, michael.chan@broadcom.com wrote:
>On Tue, May 19, 2020 at 12:30 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Tue, May 19, 2020 at 07:43:01AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> I don't follow, sorry. Could you be more verbose about what you are
>> >> trying to achieve here?
>> >As mentioned below, hot_fw_reset is a device capability similar to roce.
>> >Capability can be enabled or disabled on the device, if the device supports.
>> >When enabled and if supported firmware and driver are loaded, user can
>> >utilise the capability to fw_reset or fw_live_patch.
>>
>> I don't undestand what exactly is this supposed to enable/disable. Could
>> you be more specific?
>
>Let me see if I can help clarify.  Here's a little background.  Hot
>reset is a feature supported by the firmware and requires the
>coordinated support of all function drivers.  The firmware will only
>initiate this hot reset when all function drivers can support it.  For
>example, if one function is running a really old driver that doesn't
>support it, the firmware will not support this until this old driver
>gets unloaded or upgraded.  Until then, a PCI reset is needed to reset
>the firmware.
>
>Now, let's say one function driver that normally supports this
>firmware hot reset now wants to disable this feature.  For example,
>the function is running a mission critical application and does not
>want any hot firmware reset that may cause a hiccup during this time.
>It will use this devlink parameter to disable it.  When the critical
>app is done, it can then re-enable the parameter.  Of course other
>functions can also disable it and it is only enabled when all
>functions have enabled it.
>
>Hope this clarifies it.  Thanks.

Okay. So this is about the "allowing to be reseted from the outside".
I see. For that I think it makes sense to have the devlink param.
However, I think that it would be fine to find more suitable name and
describe this properly in the docs.

