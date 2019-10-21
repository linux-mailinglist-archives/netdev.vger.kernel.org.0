Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC81DE27A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfJUDDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:03:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41655 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfJUDDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:03:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so7458798pfh.8;
        Sun, 20 Oct 2019 20:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ACaqDcqfjllbOB1eFfbSuTOX190d3zV2fq0EmIDPM4U=;
        b=X10b1fhMwiSeorZ8V1wR5NIeqGJYcicv/C7+OpkEgXE2wDa9RVtCvajbichjKjka5h
         IPmBIqi/IuENgPtpXFq2Fzft617e2A5nT0ACRRE2iR0eZLE7HG1D8hed/gkEHHsyHHpV
         px95kaMu7LbavdJbSWQO65537Qsy4sjbbLA9YyZl2tE1jksZY+2YVkkx0vHmN60fIbt3
         GmluchDnrgxsaFCmsS1QJtRx5y8RCaxsOvTBM8Vvfiwame9JGzjEE0VkOVo5CxW3pUMz
         dfJw0NPC9FZxlGSXaX2MMPNMMP8L5FrFF0bjV/RcBTViTvBMIBOiUv6Uk7Jha4jF5fno
         Sewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ACaqDcqfjllbOB1eFfbSuTOX190d3zV2fq0EmIDPM4U=;
        b=X9ajzEjWhf+2XE987kitmME0kxdQIUhfQpwLz1PFhbwUEYIWQ45gcfTcSTqfiwAoUE
         fYp5xaosuK3tZK6I5lqqxHAyJDhmoRy5YYuADSNDw537Tf7xC8s0XYAK8UWej5wkl+Bc
         v8jcg4x9yw1mLdcnmf5sVwSAQQNMqiT/Kw0CDNpPu0pHw55ptXCC1RP0e6RvoEPvtbv8
         Aa0DkDWnCJXgEF7ibRaYGxAwLIwtpsmFhF0PM9vEN9bwMX5YRLzMNuyNgPMyMDWMB99O
         Ile8m7SSe1M6Vy0unnbTLzXS+rH7r/Nnj2s2UcaYDZKpSVGALX20Iuj5pk8QyBJZcym7
         DPFA==
X-Gm-Message-State: APjAAAWBQ/7aPLVOv6EibSvBz+DjQC8R6HRX7blJWgMzmplsmLuzY+TY
        ss8D8cGmMs7SyIfrhKeZo1/88hy/
X-Google-Smtp-Source: APXvYqzhL73699ehSUCG1hIidByYxGPcyUUn5KVfbvsRFibviSI7p+sR3Qp+tV2Zjr1LlzUUe0VGtg==
X-Received: by 2002:a63:d44a:: with SMTP id i10mr12835607pgj.105.1571627017192;
        Sun, 20 Oct 2019 20:03:37 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h4sm11969550pgg.81.2019.10.20.20.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 20:03:36 -0700 (PDT)
Subject: Re: [PATCH net-next 08/16] net: dsa: use ports list to setup multiple
 master devices
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-9-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <55f1256b-c1b3-f222-9275-c0cc969a59ab@gmail.com>
Date:   Sun, 20 Oct 2019 20:03:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-9-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Now that we have a potential list of CPU ports, make use of it instead
> of only configuring the master device of an unique CPU port.

Out of your series, this is the only one that has possible side effects
to existing set-up in that if you had multiple CPU ports defined, today,
we would stop at the first one, whereas now, we will set them all up. I
believe this is right way to do it, but have not had time to fire up a
test on a BCM7278 w/ bcm_sf2 and this patch series to confirm that, will
do that first thing tomorrow morning.

Great stuff, thanks!
-- 
Florian
