Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCE9F6E5
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfH0X3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:29:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43554 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfH0X3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 19:29:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so376004pfn.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 16:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=XLcLbsGuTgDqzQ91SZlPjdWS3T8ZXKpC3T5ZSC/M6f8=;
        b=C6O5id02PbpF/6M5zVO8z6XsLvOjzi5VdUo26Nmz/XOV0njADHJlRDire9Ak39TfMY
         dDOF8vgXVbExHGKVshHOV+bZ5LZEEWDVbFDB6VgbnNzpqQ86YlbCD/upGlrz74Jsd0pb
         6oYW84L8KL5fPc59NPdrmjvy4xk1KHSSpB3TVNpYDO926JQKqQRDqBRdURc1D8/KWh7G
         nujd8xr6+T7b+K2lr1XE4ULpEybcP9xcDNhF72adPbzl413UKMjqjDfXQHFf85DWTNLl
         pcXCOTeaW0Oeo17e671jeyZwHOCb0fWZAMbuAYvSnKom+Gox6qKzmBiCW+tnw8dO6ZHs
         35+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XLcLbsGuTgDqzQ91SZlPjdWS3T8ZXKpC3T5ZSC/M6f8=;
        b=TBYHfAYBogcPwizRfWnuyYAhYFz2f2wENAZm6JQig1XN3VHUt2Y0SxmXBG3b3wEgk5
         yFKH3aZvkbfH+AGr8iC+O1hnYvycLRwu70FCZZGv+2Olt0YOns/lmhqP3ECBG3+lWNuj
         ZLJtKloGU7aa6B7p/KMgxoCbGTRlWoAAiMVNKA+CElc9UN+Ml7mcFJmIGLPnZOhVttZf
         Y3uKfvwKO3PtpalKKqTTqR29OKjxgNWa2mrPHFn2T9K1uftL+lLAm1qaRfoZAfw5dE6/
         oOWG9iP6NX/mR904a8SMeB+Hf49hkSy8/SATCaEkpdqDRoN1FGiAMZilAxVu5YQm9mml
         G3rQ==
X-Gm-Message-State: APjAAAW8a3m4qXxwb2TFwBGfV/b4Ov24eQQ25lZX0IW0o0uMKAKv5zix
        EYkHI0cf9lowLJ4u/bU+hRGpGg==
X-Google-Smtp-Source: APXvYqzWMLpZzw6PonI/4e1JKRwnMIze7qnHQIg3doBW4q+LloOo6hUP4UixZ6lGXxAUIgjJ8JnJXw==
X-Received: by 2002:a63:5107:: with SMTP id f7mr896044pgb.4.1566948571861;
        Tue, 27 Aug 2019 16:29:31 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id w2sm268499pjr.27.2019.08.27.16.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 16:29:31 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 04/18] ionic: Add basic lif support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-5-snelson@pensando.io>
 <20190826214238.07a0eee9@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <35b8435a-0217-ad98-0896-e7aa2a5d2e89@pensando.io>
Date:   Tue, 27 Aug 2019 16:29:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826214238.07a0eee9@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 9:42 PM, Jakub Kicinski wrote:
> On Mon, 26 Aug 2019 14:33:25 -0700, Shannon Nelson wrote:
>> +static inline bool ionic_is_pf(struct ionic *ionic)
>> +{
>> +	return ionic->pdev &&
>> +	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF;
>> +}
>> +
>> +static inline bool ionic_is_vf(struct ionic *ionic)
>> +{
>> +	return ionic->pdev &&
>> +	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF;
>> +}
>> +
>> +static inline bool ionic_is_25g(struct ionic *ionic)
>> +{
>> +	return ionic_is_pf(ionic) &&
>> +	       ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_25;
>> +}
>> +
>> +static inline bool ionic_is_100g(struct ionic *ionic)
>> +{
>> +	return ionic_is_pf(ionic) &&
>> +	       (ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_4 ||
>> +		ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_8);
>> +}
> Again, a bunch of unused stuff.

More "near future" support code that didn't get stripped.  I'll pull it 
out for now.

sln

