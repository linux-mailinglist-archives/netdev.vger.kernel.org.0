Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290DB686AD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbfGOJwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:52:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39994 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOJwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:52:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so14518181wmj.5
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 02:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAaM48TdwzB0Flv7Dgc9aWFllbcyKHqhN40heY/1QM0=;
        b=itEEvtBDJYaycVcFg1q4pqPipgQ53stjPNlgE5sb/o3nrhUiCGwjL2ZsI5KzaRQpIG
         1a2+t4xjf5R9aMK3oc4EwZxA7TroJiLcxP2n0KZ4RJ6BIDfRMBjRt2mh4DsLWrUJwvCE
         k33Ly4fGf3U+Vh1OcZY2+M2sjAj0nFjo2oliCKXipO6DtUMS1+suRRfWAPUjwzV++MQn
         lzTnrs00AElSs/yGWsWJf5ghnvOAkcl0lCcE7zEtnuIy5qJGXtPGA7SyLceNIk2LCOxy
         w+vfz+Yuwzg4yRDW+jlx9byV17+zH9QM30WeeNkY9D/UxGnuR5d3ewpVZCVjaGFHMaw4
         sOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PAaM48TdwzB0Flv7Dgc9aWFllbcyKHqhN40heY/1QM0=;
        b=G4k8T1ipifDyYcnxiS1noORkDKyEUkAHO+WRgUXjv8Lw+57iYRnMbWk6x21uCTwLku
         b7Q7l/7nBBQIwesDrn7ywVHeA8KnBo7kzrneO41rwJNSg0WvXwaeYUFsOMcDRea+EBWd
         69GawoAF9oRIf4QJFrxgkERZbDHvLBuxSopCLo2izODtNRva3oum9Bq3BYUEALdA2Joq
         Ll9EVWRzTSpeC1t3xb3Uv9lNWf+P0OWdgDNzHujuR88PD6y9YD8zlz2eoOjMJkaWebtX
         eSBgykaHX7H9ALAyP5cIf4NTD3MTQtru8tEgRakfFHBi4opxDv+41yveeXLIvh3VFeJV
         6elA==
X-Gm-Message-State: APjAAAXFqkIPUAGRcz4BUhg+AaEprBVr/Jg7PPVhUr9AGyWBKiDccBQe
        VtqLyu/Tca7wek8GzM4OA82U3BqZGmw=
X-Google-Smtp-Source: APXvYqzWsWDofQX6NEKVK4+B+Ty6LgL3ovwmc0DT8ZoctGzfbw8GSiIfMOgI5Qf2xQgjF1Cp61VPGQ==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr23229641wmj.144.1563184372695;
        Mon, 15 Jul 2019 02:52:52 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c118:a958:bcb2:844f? ([2a01:e35:8b63:dc30:c118:a958:bcb2:844f])
        by smtp.gmail.com with ESMTPSA id j10sm28594356wrd.26.2019.07.15.02.52.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:52:52 -0700 (PDT)
Subject: Re: [PATCH ipsec 0/2] xfrm interface: bug fix on changelink
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <df990564-819a-314f-dda6-aab58a2e7b6e@6wind.com>
Date:   Mon, 15 Jul 2019 11:52:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/07/2019 à 09:45, Nicolas Dichtel a écrit :
> 
> Here are two bug fix seen by code review. The first one avoids a corruption of
> existing xfrm interfaces and the second is a minor fix of an error message.
> 
>  include/net/xfrm.h        |  1 -
>  net/xfrm/xfrm_interface.c | 20 ++++++--------------
>  2 files changed, 6 insertions(+), 15 deletions(-)
Please, drop this series, I will resend it.


Regards,
Nicolas
