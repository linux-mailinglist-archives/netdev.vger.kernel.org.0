Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0919308D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgCYSlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:41:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36647 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCYSlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:41:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so4543026wrs.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gxfalGneNc5/eiQ8pv2QMrw7YZtQpbRsEhy0gwwxZ78=;
        b=o4kBM3+1HwW6NDHXvbGXX/MRwNKX5zkwzrKNgz3j8IEBftQP2kJJOOS93Reg/e4SCH
         CE7XvPsDfPavJfrRo3uFP/LmHHs9sB4y4BkyTMJGgad30Ol5dyxpV9VcL3fBqWOhgtKq
         3eghqoiKg6gw97lVsNwk9tVcBdIwsS6rcKyycdenl1U3BpX1lFlulFlSFHS0cwgk6UTs
         xnfe6Xkxcc6456l0cbtmisjnYys+Tk7bxKnni4G9wZGWmraWVpD0iADjHD18pC7xPtpn
         VGndfSYLdrw74lW5zf8Yr2L/ZstBUGlTMqTvm/59fQ3Mm6O1SJLXzx3wf1yKBh5SMcgn
         m8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gxfalGneNc5/eiQ8pv2QMrw7YZtQpbRsEhy0gwwxZ78=;
        b=cVnPVYUd6UOPQSgX+ILDTM2159jEH8e14OMZQH1si9+uXruWsDURH4fXWqBXziiqit
         0ogEpSvI12oaY584strU3T06+5JD/4WRzZdwXYOU77YPGXd8ihobgjFuD/cwJT6nt8gn
         Mmobv240NcEy8/cjAfopeKz4/tjl5QrjJ5675M4L3eBVtLrj4CUpl98AvHlFKGUF/Qqr
         7SkbmzsnTOMkwevTUf0Ft/QVQSQhhtzTgbJBqQnnFdkyQHNOOCJFMMmBkPNfCec/T1gw
         4n/aWNfhMZwLIvTSEg2iNpxy9mUCg3KDU8sfZN5u64CxCy3H/V4hkAa6n6lHchXqLpSE
         shrQ==
X-Gm-Message-State: ANhLgQ2AxlD/ukGh27u22ryZbcNogIJ043E/komSa9yZ1ZiFLYUu0MiY
        cDQ1h7JUMJ02Opg6HIeB8fE5TbqmdQc=
X-Google-Smtp-Source: ADFU+vu0ajSYFN5aC9pbtmF5/Z55PkftobxS24RnJ+G80TXonguMyrSfhyydwt69pVWr3Vv6Wz7crQ==
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr4820973wrp.184.1585161680378;
        Wed, 25 Mar 2020 11:41:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f12sm10285398wmh.4.2020.03.25.11.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 11:41:19 -0700 (PDT)
Date:   Wed, 25 Mar 2020 19:41:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325184110.GD11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-9-jacob.e.keller@intel.com>
 <20200325164622.GZ11304@nanopsycho.orion>
 <20200325101804.09db32af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325172036.GC11304@nanopsycho.orion>
 <20200325104641.24b7ce5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325104641.24b7ce5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 25, 2020 at 06:46:41PM CET, kuba@kernel.org wrote:
>On Wed, 25 Mar 2020 18:20:36 +0100 Jiri Pirko wrote:
>> Wed, Mar 25, 2020 at 06:18:04PM CET, kuba@kernel.org wrote:
>> >On Wed, 25 Mar 2020 17:46:22 +0100 Jiri Pirko wrote:  
>> >> >+	err = region->ops->snapshot(devlink, info->extack, &data);
>> >> >+	if (err)
>> >> >+		goto err_decrement_snapshot_count;
>> >> >+
>> >> >+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>> >> >+	if (err)
>> >> >+		goto err_free_snapshot_data;
>> >> >+
>> >> >+	return 0;
>> >> >+
>> >> >+err_decrement_snapshot_count:
>> >> >+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
>> >> >+err_free_snapshot_data:    
>> >> 
>> >> In devlink the error labers are named according to actions that failed.  
>> >
>> >Can we leave this to the author of the code to decide?  
>> 
>> Well, if you look at 1 .c file, the reader should see one style. So...
>
>Fine :)

You know, consistency is important. That is all I care about really :)
