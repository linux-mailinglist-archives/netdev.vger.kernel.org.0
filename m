Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C3B3142
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfIORub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:50:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46844 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbfIORua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:50:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so21201108pfg.13
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V7u2aMxGEW+QafhybGhMq7kE0cXRA07ytJTj5DPGKek=;
        b=WyuooJvl+Rn4EChSlOOTlOGkk44JcBg3IJNATEGUwqyHJ6PnxtOyEGTdFbBhXmcmdz
         cTOLb1+VIAqhc3ymIHGhcOX46JfLItbR5oTQLPlbGhFmvoTeqMXocNOdjRahY4VCQz+g
         tEf3UtsyD4dtEFcVp57wXgBW2tmIetiKUAVIJajl/xwJ9Z/cF0dhN53SoW95997yBuqP
         ECSFPvPrQSBmuAm6RV5ZeodFTRkgF7JyU5gme0LycZw2oVaDMFlqwRFimTTNHyf0mIk9
         hu34FMG6TCkfKZmPeEyU/t5iNBAGAIZzv25OrKCcrgEE2OYQGaY+YkM1DHrWWm3MYJfN
         342A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V7u2aMxGEW+QafhybGhMq7kE0cXRA07ytJTj5DPGKek=;
        b=fNo2pmEGQQn5gstSxzPQsNu2y3kZLHjsrQFKSInD/dx/uQnRmYhDZveTYVorYVi4qK
         QbFfFU1ct1a372ecmfUKFh2TbNFPjc3Sdz9Tt1dvouDsAQ5QMtG/DFpDSSQ9aV6S7gE/
         9/KA4UuRk/xlqqI+5fjQkVa3GtltIY9A0pnmBkePYtiUDKMKzCoSMgfqZmOIvpkYL828
         1136hRRP0+RaqG59rSanwXtsS/0FddG6NUlX2Y/h2rBKSqifYH41Gn6K4ZaREewrF3kf
         u427ZWs3PbsK2qnPDEAqV2y27ZSvO2zcaMYqVQvxOxDwgmoL3D0RskWM4yOJaHrXMN8E
         dXFw==
X-Gm-Message-State: APjAAAWwkbAgolNcaMoCbU3UlVn0Xugse8ugnsz/g6HvN5zd0SyzmxEC
        WwT4TdFXawNHlr/XipiiSPDE3lors/c=
X-Google-Smtp-Source: APXvYqwyUB6S22V2yYExk1OxCPm402SKSfnsUyDHDeBHo3ayBBl9o+4Iie34gHZhW0J1nZQ4dCdMdQ==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr2805411pjb.137.1568569830044;
        Sun, 15 Sep 2019 10:50:30 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id fa13sm2381789pjb.16.2019.09.15.10.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:50:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] devlink: add 'reset_dev_on_drv_probe'
 devlink param
To:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
References: <20190911130517.21986-1-simon.horman@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <49982a39-d6dd-7d35-1b36-49c8f7cd98c6@gmail.com>
Date:   Sun, 15 Sep 2019 11:50:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190911130517.21986-1-simon.horman@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 7:05 AM, Simon Horman wrote:
> From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> 
> Add support for the new devlink parameter along with string to uint
> conversion.
> 
> Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> ---
> Depends on devlink.h changes present in net-next commit
> 5bbd21df5a07 ("devlink: add 'reset_dev_on_drv_probe' param")
> ---
>  devlink/devlink.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 

applied to iproute2-next. Thanks


