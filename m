Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DFC9F1C5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfH0RjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 13:39:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38000 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbfH0RjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 13:39:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id e11so13075145pga.5
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 10:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SgLU2lS4IyQNmp0DPMkC+VzvEYvp2OfAzVkdN5Edpvc=;
        b=g/8eEdqRb3n3zfc6ptlnGmap71VtVOlk+CTfcRSSOasYGx57+EqRnHsiWP38O7SHW6
         RuUhU08JJtHCIaOnZ8lrRYYnXoJaT2dZyCdAOgCxVSbiFf92CPIWwTVQxBllF//GYjGc
         MuPea7l4o0THpRHLEqdxMrChJWVb51GV+pk0Bkh0FaBjPxW53aPHWFdVQbpnLJKB+zBJ
         hsrDScgAvC3cImeUTOVf9PUAyiWmlS06cAk8r3ifiv0GahGyIJkHooriPbM2HusUBT+f
         4UmUMGi4Ly++jcK04wsLhz6oGBcsPEn7wURVPkwneReWavtaprxmH1y3OrZfT14UorEV
         glGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SgLU2lS4IyQNmp0DPMkC+VzvEYvp2OfAzVkdN5Edpvc=;
        b=CXRgAvXTV/WdLMGLuIbXOze934skWI3Lhjwm9TrdeKybNk0yKi//BGXGGKsBnwYbFD
         u3yOonRGBu4nZDZISlAmO7A8m865rJakUyNDFghsom3samNetGpkESTAyc0Etfi+hkEx
         +cO2QvviYI/2HEZyXeHE+ERGcctbJ0QaZ4d9CAUQ70SBPmfp+U+B4/PVAMAB6n/IUfhY
         VLZCFNJ0yaDCEQ2jNcMoMjheAn4WOExKCR/bXhiUO34NXPabZzsWa/UGUfDVc3PcIp6w
         KbPaUDr7A1jdQYeHNQyyIi+qPnhkpyg9vPlSgOXFrdQCXm4OXds/xWZ1qv8zAA42TmOo
         5Fnw==
X-Gm-Message-State: APjAAAVo6ji+VMbA3JXEK64/appcEIjJqFRR6xNaI6ezh51CCvozZ2b2
        I+a0yP2QtUGRCxunjAJlp7HM1g==
X-Google-Smtp-Source: APXvYqzqTWGRooxwlO50s1QiB9mgPw1qDB9yYQl+v49squv1sI2jSUi+YqN8og+2RsmBC5pCHD/wTg==
X-Received: by 2002:aa7:8193:: with SMTP id g19mr26884963pfi.16.1566927562922;
        Tue, 27 Aug 2019 10:39:22 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k64sm14126pge.65.2019.08.27.10.39.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:39:22 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io> <20190827022628.GD13411@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ab2d6525-e1e1-ef87-7150-dabfaee5b6ff@pensando.io>
Date:   Tue, 27 Aug 2019 10:39:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827022628.GD13411@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 7:26 PM, Andrew Lunn wrote:
> On Mon, Aug 26, 2019 at 02:33:23PM -0700, Shannon Nelson wrote:
>> +void ionic_debugfs_add_dev(struct ionic *ionic)
>> +{
>> +	struct dentry *dentry;
>> +
>> +	dentry = debugfs_create_dir(ionic_bus_info(ionic), ionic_dir);
>> +	if (IS_ERR_OR_NULL(dentry))
>> +		return;
>> +
>> +	ionic->dentry = dentry;
>> +}
> Hi Shannon
>
> There was recently a big patchset from GregKH which removed all error
> checking from drivers calling debugfs calls. I'm pretty sure you don't
> need this check here.

With this check I end up either with a valid dentry value or NULL in 
ionic->dentry.  Without this check I possibly get an error value in 
ionic->dentry, which can get used later as the parent dentry to try to 
make a new debugfs node.  Some quick tracing looks like this error value 
will get dereferenced in a call to inode_lock(), which would likely 
cause us some heartburn.

I'd prefer to keep this check and leave ionic->dentry as NULL.

I've removed several of the other error checks and messages that were in 
this code, but left a few of the IS_ERR_OR_NULL checks to be sure we 
don't try dereferencing similar bogus values.

>
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +void ionic_debugfs_create(void);
>> +void ionic_debugfs_destroy(void);
>> +void ionic_debugfs_add_dev(struct ionic *ionic);
>> +void ionic_debugfs_del_dev(struct ionic *ionic);
>> +void ionic_debugfs_add_ident(struct ionic *ionic);
>> +#else
>> +static inline void ionic_debugfs_create(void) { }
>> +static inline void ionic_debugfs_destroy(void) { }
>> +static inline void ionic_debugfs_add_dev(struct ionic *ionic) { }
>> +static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
>> +static inline void ionic_debugfs_add_ident(struct ionic *ionic) { }
>> +#endif
> Is this really needed? I would expect there to be stubs for all the
> debugfs calls if it is disabled.

If CONFIG_DEBUG_FS is not enabled, I would prefer this driver's debugfs 
code to also be left out rather than be compiled in and left useless.

>
>> +/**
>> + * union drv_identity - driver identity information
>> + * @os_type:          OS type (see enum os_type)
>> + * @os_dist:          OS distribution, numeric format
>> + * @os_dist_str:      OS distribution, string format
>> + * @kernel_ver:       Kernel version, numeric format
>> + * @kernel_ver_str:   Kernel version, string format
>> + * @driver_ver_str:   Driver version, string format
>> + */
>> +union ionic_drv_identity {
>> +	struct {
>> +		__le32 os_type;
>> +		__le32 os_dist;
>> +		char   os_dist_str[128];
>> +		__le32 kernel_ver;
>> +		char   kernel_ver_str[32];
>> +		char   driver_ver_str[32];
>> +	};
>> +	__le32 words[512];
>> +};
>> +int ionic_identify(struct ionic *ionic)
>> +{
>> +	struct ionic_identity *ident = &ionic->ident;
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	size_t sz;
>> +	int err;
>> +
>> +	memset(ident, 0, sizeof(*ident));
>> +
>> +	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
>> +	ident->drv.os_dist = 0;
>> +	strncpy(ident->drv.os_dist_str, utsname()->release,
>> +		sizeof(ident->drv.os_dist_str) - 1);
>> +	ident->drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
>> +	strncpy(ident->drv.kernel_ver_str, utsname()->version,
>> +		sizeof(ident->drv.kernel_ver_str) - 1);
>> +	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
>> +		sizeof(ident->drv.driver_ver_str) - 1);
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +
> I don't know about others, but from a privacy prospective, i'm not so
> happy about this. This is a smart NIC. It could be reporting back to
> Mothership pensando with this information?

I suppose the phrase "you can trust us" wouldn't help much here, would 
it... :-)

>
> I would be happier if there was a privacy statement, right here,
> saying what this information is used for, and an agreement it is not
> used for anything else. If that gets violated, you can then only blame
> yourself when we ripe this out and hard code it to static values.

That makes perfect sense.

I can add a full description here of how the information will be used, 
which should help most folks, but I'm sure there will still be some that 
don't want this info released.

What I'd like to propose here is that I do the hardcoded strings myself 
for now, and I work up a way for the users to enable the feature as 
desired, with a reasonable comment here in the code and in the 
Documentation/.../ionic.rst file.  This might end up as an ethtool 
priv-flag that defaults to off and can set a NIC value that is 
remembered for later.

Does that sound reasonable?

Cheers,
sln


