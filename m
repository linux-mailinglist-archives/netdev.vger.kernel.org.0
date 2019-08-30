Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD58A3E69
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfH3TbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:31:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34830 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3TbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:31:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn20so3795783plb.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9iDeFp92B5W2itGLMZ4kKqQyRTjN8gH5SIsyUVnfaZw=;
        b=mVU41iVidkxmOSBxWMzkFvgjamp6lJAdgvtdIiEpOpiu/L7cgAdzRfmyJXosvWE5f3
         3Y2zOhqCa0g5ImS/6BOBrOwhS8r0xcTTkvVwpIDWMIHReLFvucO6T2OZdQsgmpD/2SWZ
         Q1/RkBGG5a+Xrzyyz0McyozescS6z58gyEvzP0+879r4wkNKANPE91rg7rZWE/fhd7WI
         DYwOeiOGNBFMMIy4TDYCVm4se/dZZR13+rlEwoIHwCltL6P0ZpO7erZYbn2dhkIvFnl4
         9rIYB552cGUFMgQtHpGTEq/LnXekarOHHNkx/5jtmfLIaeniJLHKNqzOThCvqRe5prf9
         NPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9iDeFp92B5W2itGLMZ4kKqQyRTjN8gH5SIsyUVnfaZw=;
        b=mQ70pfMNXkcqc2WR4N+WdpT8Cn3j0a7Ko+c0AOkaBYlTEOPBhAjTjJcRrjSgkbM9sF
         9KN9nTh7LiJ0rU5hSNzen+0YAn/25cpQLHGwO+UApTXAiYolxi4wonn7hgDvR3JlOXcJ
         w3bKAJmbjHvww3t3xFBXPd3NjFK+Z8qAiUjxMxCGkG/f/btD+yA+MOWt9YatYAsMa4Vq
         sUCyvo9XgA19/ulzgJw+rS0mYU+ChPgZbvaeBr6DN9KeN/RU1Xe/Pdm+DtfiH6H6AoEU
         YpeXwSVQ49/gSvSLaBsX5OB39kCGK3GddeUKgI+Nob2NvK7IXCIxYyJPuzfhOR1YeGFO
         6RbQ==
X-Gm-Message-State: APjAAAUKOTHG3oVwdYByCF+83bVcl8PhhNhe11/r4EOLJpq17bDF0fb3
        IWLMSRipS1ugg1T4zTR9nOjysA==
X-Google-Smtp-Source: APXvYqwUfEWQIw690SoaAb2rCMX+my66Uy+QZEzACLpwpy1q4vL+RJ1whOhqyyqTzV7k7yD/oOydXA==
X-Received: by 2002:a17:902:b08a:: with SMTP id p10mr10490201plr.261.1567193469670;
        Fri, 30 Aug 2019 12:31:09 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k5sm5887320pgo.45.2019.08.30.12.31.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 12:31:08 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-8-snelson@pensando.io>
 <20190829155251.3b2d86c7@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bad39320-8e67-e280-5e35-612cbdc49b6f@pensando.io>
Date:   Fri, 30 Aug 2019 12:31:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829155251.3b2d86c7@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 3:52 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:08 -0700, Shannon Nelson wrote:
>> +static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
>> +{
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct device *dev = lif->ionic->dev;
>> +
>> +	if (!qcq)
>> +		return;
>> +
>> +	ionic_debugfs_del_qcq(qcq);
>> +
>> +	if (!(qcq->flags & IONIC_QCQ_F_INITED))
>> +		return;
>> +
>> +	if (qcq->flags & IONIC_QCQ_F_INTR) {
>> +		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
>> +				IONIC_INTR_MASK_SET);
>> +		synchronize_irq(qcq->intr.vector);
>> +		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
> Doesn't free_irq() basically imply synchronize_irq()?

The synchronize_irq() waits for any threaded handlers to finish, while 
free_irq() only waits for HW handling.  This helps makes sure we don't 
have anything still running before we remove resources.

sln

>
>> +		netif_napi_del(&qcq->napi);
>> +	}
>> +
>> +	qcq->flags &= ~IONIC_QCQ_F_INITED;

