Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3161E25EB0F
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgIEVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 17:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 17:48:01 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CECC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 14:48:01 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id g6so4637485pjl.0
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 14:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NeU3OMwsEfyfLyeG4TARKstBw3GMLd+yeFRQvg7yypo=;
        b=UgrxZjzTCr/uhO1R8VrXZMZKaU4eDk/bCax/PzOMYimPP/WG+Tl4uyGAyYCqb/UwK6
         F3pkV03ZmC0XFgpAdyYcgVuFIC70LOviFNR31oW5DQT6XCkgbsEPFkDFiQuSNIPAacl0
         MTsybCJbH8WWc2kq68ODakfupsHyjPJbY8DbBEMoiBEnZ2mGDzre/2tKlXFOPVG7CUtU
         50282O7iO3Blg/dZoPmSLAjTF9HCFtiZLn1eU5bD2MnziFSmRgwE7/O7OYURTcd0O32+
         BZeMh5G94bov/kJGqGLx9MOWxf5Zd6xqd1NQiK15U2skDI3+jdfn0siiNPnriwYr5a19
         wOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NeU3OMwsEfyfLyeG4TARKstBw3GMLd+yeFRQvg7yypo=;
        b=OCJPeD9sWIAHzP3DMz2gxoSrUVA+L/IIk8yY4BRbV28jlHh0WFX0SNJQI8KvJmKjiI
         hi2JJ+NVm7nOwEqh2NAa64k4CXERwBEWukdr2XBaBqBhoafMzjqVwkdrma03n+HVaf29
         YS6bzhLxXC2XS4Tz8TT/mXeKNzBaRJKy9idEkEr3N20emPGtJSMZ+X97qI1nBc15OW0A
         GtpTcV/YHAC4Tq0GVFR6sec4piOReQFwXswZQ4kPL4xkTPBLGYSDRFsk9hvBaeqqoi16
         1PY74bEM8xI9lhsCDCqwtivGcR/TEySTieW5OcGZuGpEgmgyDBRI8QVe9P2Fk9A89KMM
         2tkg==
X-Gm-Message-State: AOAM530Jvsq0SVpmz+RCFEdZxPgapDUURktjbZsF9+NEGel5DiXwm6vW
        553AT9lhZhNymaLprTWLw7HDCA==
X-Google-Smtp-Source: ABdhPJwxHhpH6fRLVr4CTXz6MX7YyS2LjEGQsc43nW+XiqXcvCT4PzftfDrjbIcnqQji0WP04H6pQg==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr13716182pjx.90.1599342480966;
        Sat, 05 Sep 2020 14:48:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id k4sm11368021pfp.189.2020.09.05.14.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 14:48:00 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200904000534.58052-1-snelson@pensando.io>
 <20200904000534.58052-3-snelson@pensando.io>
 <20200905125214.7a13b32b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c18aca84-7cd4-64be-1222-2c36c795f024@pensando.io>
Date:   Sat, 5 Sep 2020 14:47:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200905125214.7a13b32b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/20 12:52 PM, Jakub Kicinski wrote:
> On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote:
>> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 0, fw->size);
>> +	offset = 0;
>> +	next_interval = fw->size / IONIC_FW_INTERVAL_FRACTION;
>> +	while (offset < fw->size) {
>> +		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
>> +		mutex_lock(&ionic->dev_cmd_lock);
>> +		memcpy_toio(&idev->dev_cmd_regs->data, fw->data + offset, copy_sz);
>> +		ionic_dev_cmd_firmware_download(idev,
>> +						offsetof(union ionic_dev_cmd_regs, data),
>> +						offset, copy_sz);
>> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +		mutex_unlock(&ionic->dev_cmd_lock);
>> +		if (err) {
>> +			netdev_err(netdev,
>> +				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
>> +				   offset, offsetof(union ionic_dev_cmd_regs, data),
>> +				   copy_sz);
>> +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
>> +			goto err_out;
>> +		}
>> +		offset += copy_sz;
>> +
>> +		if (offset > next_interval) {
>> +			devlink_flash_update_status_notify(dl, "Downloading",
>> +							   NULL, offset, fw->size);
>> +			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
>> +		}
>> +	}
>> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1);
> This is quite awkward. You send a notification with a different size,
> and potentially an unnecessary one if last iteration of the loop
> triggered offset > next_interval.
>
> Please just add || offset == fw->size to the condition at the end of
> the loop and it will always trigger, with the correct length.

Or maybe make that last one look like
     devlink_flash_update_status_notify(dl, "Downloading", NULL, 
fw->size, fw->size);
to be less awkward and to keep the style of using a final status_notify 
at the end of the block, as done in the Install and Select blocks 
further along?

sln






