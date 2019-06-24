Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1951D42
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfFXVos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:44:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39051 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbfFXVor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:44:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so7643377pls.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=QCNti2xDn0YfCSd7WXuqC8QaXhom4UGOcib4fGDoI10=;
        b=mjFOu6nxrWnG1bHuP5tToeiKtZMz4DOdk6lJB2tx4qn/djSSg87+2w8o7rvTIAh/p3
         GJW0sR6TjmX43Q0qVC0H0CS9LlV+SZW1WSERiDJj6XKVoO5FfDv6mRgH9PdGifzowOBp
         1t78Q3fe8AMpVOHUZS271cInb0VSVXZiVm9Ijis3ONtlHIZV+A8Zbk4lNp2TPejoNgU3
         5BI1/EytO5Hq5L3iqis9MZim/OLTFoJ4Mgzgn+9RxdLBwlUp/um+94y1Xh44wejG6Z+y
         a++DXTcPOS6RROx7Amk20f952XDdEGFQ20H09k1QeDLjwty6aIb6h9tqsbO9fGCiNIIP
         b15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QCNti2xDn0YfCSd7WXuqC8QaXhom4UGOcib4fGDoI10=;
        b=tbtQWd10X4ID18lw3WJ92f8UblyD39+8VPQBiEIyiWWbUElCTjV/mmyR5mmKdIE9mc
         cdJpLr3Pjrvz+0g57VTNAUxgDb2oQopEyS4livYpUBYs8T0o4g7rnRGD+yePEpRJnVHZ
         pDMuuHN96bui2RVsqiBPGR9e1mU2/0iBz2W1vTF4CIZllWmFY+4np0LPzghKQg837CE2
         gPFX01bUtMs5MQbqcsNTvC+XhIGy3izKmP2B8APXPFc7x6IdH10HOIW4/1LLwzSpFMbZ
         aSI749tStTyYpYeqFWO0NDHYczlDKzj+u+szNSLD2rwdANKLqAQE89i905Dp3p338+tc
         Z4tw==
X-Gm-Message-State: APjAAAW6M0KSRxuWRgD7qRoofOuH/GFnREcNVc5aa2pkBT3h0bOlQrZa
        rg95DtYljHx676mt614om0QUXnyyv5Q=
X-Google-Smtp-Source: APXvYqxOc9vkVc2fbm++9OV0Eur1ZU/DWh52KNXBHz6xqM/cPOKLOgcYghnxmB2qhzCfjtQhs3TGVA==
X-Received: by 2002:a17:902:54d:: with SMTP id 71mr38244760plf.140.1561412687025;
        Mon, 24 Jun 2019 14:44:47 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u16sm450383pjb.2.2019.06.24.14.44.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:44:46 -0700 (PDT)
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-14-snelson@pensando.io>
 <20190621023205.GD21796@unicorn.suse.cz>
 <4588d437-6308-0b6c-50e9-964a877b833f@pensando.io>
 <20190624072604.GA27240@unicorn.suse.cz>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <8aa7bc60-4e27-64cd-0a3c-c055a45ded7d@pensando.io>
Date:   Mon, 24 Jun 2019 14:44:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190624072604.GA27240@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/19 12:26 AM, Michal Kubecek wrote:
> On Fri, Jun 21, 2019 at 03:30:20PM -0700, Shannon Nelson wrote:
>> On 6/20/19 7:32 PM, Michal Kubecek wrote:
>>> On Thu, Jun 20, 2019 at 01:24:19PM -0700, Shannon Nelson wrote:
>>> +
>>> +	if (ch->combined_count > lif->ionic->ntxqs_per_lif)
>>> +		return -EINVAL;
>>> This has been already checked in ethtool_set_channels().
>> That's what I get for copying from an existing driver.  I'll check those and
>> clean them up.
> The checks in general code were only added recently so most drivers
> probably still have their own checks.
>
That would be the reason.  Thanks, I'll clean those up.

sln

