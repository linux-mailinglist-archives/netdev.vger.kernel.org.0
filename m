Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8C182CF0
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCLKA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:00:59 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:34230 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgCLKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:00:58 -0400
Received: by mail-wm1-f49.google.com with SMTP id x3so5134118wmj.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 03:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gssi.it; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T0cHVlh0IotE0wQx3kxPQ2qR9ahWTST/WVB/i9Hm1yI=;
        b=LdmIYf3A52Uh+odbZvOG9MlZ4esDXhA0ZFK2tFTgPTyzQJMxLOVT3VVF/MIUs41dg+
         bvP/ve4tOJhTqyJemQowyP0pVOPYVk/wQ3uZ/LvKANTl8Ei0Z1B6W1YT3t0OG0WvApcn
         alpKXP2Wn4g48HM+SVbc07nrMN0YUFrVa/cx4JhDFZPT4WCaQvS+JiqVUtPScOTPVoPK
         VTRq+atiTMBOME2eJGeh3UKQ9i2CVgZ/vAkAFqUVtvShu4Nm1/sfqSYH6HNSB6XKccEe
         JPzOtM3xMkIiC7Rn/HWNb5I8fN/Xqtg8e01B8VzKsXDs1u1NYYC84OdTRmAO87Q3HM/B
         jnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0cHVlh0IotE0wQx3kxPQ2qR9ahWTST/WVB/i9Hm1yI=;
        b=YkuOGsYKqlULpS/uKEDk9DXhaJdoo643q6UYZfu4j9tEsWMkLGTDDzOawNLL5XeQaQ
         0qgsegw/uNBcbUtTZG4Z4jr1U0SphyW7OXYgTksPORNA7qdwucyU72eb9U4UfdNdToBg
         ZbwqTxhGpGbriXNE50TmkDLQu1Ng9Ort78fbO73mWdJztGO56FJoY10zw5oIGAhAo672
         QgHpNwGzY8QINDhqUA9uk9nSFCXajGxNh5CF4uw7ZCzQjBPBe0I/6NBGmM8rMfFaV2VX
         H6/niOrAPYx2RkNvh53seVRRItzZZFPcWg7T2+plDyCcnhoahRzWekr0/YsDj3H1afbe
         MZ7w==
X-Gm-Message-State: ANhLgQ3AjhuthdBsg1AxklPMGrGO3FeZhiUZmFOXqS3FvaPX2AQjmaqD
        xkOFK9MWchh6L1LBgByLtvdYTg==
X-Google-Smtp-Source: ADFU+vs1qTTVdmaCl/G4tsIpDvgdWvB+wR4+bttsjzxd5O2Evhb5BhnA0pqT0cdgu6TofEyIERZV8A==
X-Received: by 2002:a05:600c:21d1:: with SMTP id x17mr641793wmj.94.1584007256206;
        Thu, 12 Mar 2020 03:00:56 -0700 (PDT)
Received: from [10.55.3.148] ([173.38.220.54])
        by smtp.gmail.com with ESMTPSA id 9sm11812756wmo.38.2020.03.12.03.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 03:00:55 -0700 (PDT)
Subject: Re: [net] seg6: fix SRv6 L2 tunnels to use IANA-assigned protocol
 number
To:     David Miller <davem@davemloft.net>, paolo.lungaroni@cnit.it
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200311165406.22044-1-paolo.lungaroni@cnit.it>
 <20200311.235031.754217366237670514.davem@davemloft.net>
From:   Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
Message-ID: <596e8f0a-9aec-a18a-e6e1-4aab1092457b@gssi.it>
Date:   Thu, 12 Mar 2020 11:00:53 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311.235031.754217366237670514.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2020 07:50, David Miller wrote:
> But this is that classic case where we add a protocol element to the
> tree before the official number is assigned.
> 
> Then the number is assigned and if we change it then everything using
> the original number is no longer interoperable.

David, Is there a way to port this patch to previous releases ?
This would be really great and helpful.
