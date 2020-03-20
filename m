Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D66218D573
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCTROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:14:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46564 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 13:14:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id k191so2252884pgc.13
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 10:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xW6AAlb0NSrViMGBoaS8CXAG+vAOOxYm2IIhxarIEbM=;
        b=GW3HWwtSwcdg57QGsZbEO8yNkfaPd5xjMWpxRQG/R5b5QYy7oXr6Q91vSaeSCJ0RPF
         AFlo5G8GVMFa8RKrMEkbwPHS7bpis3PnkmZ1kyQTMSihJb2G6Cg2VQR8bcye7q0KPSIC
         DeiWWcbq9YBbZWHK6CscQeheXzoOogrOyK6/0EMn2Di6vsMxLQODPzL6hn9yh1pfBBck
         Na8Wj61sCdvZ43+ngw8Vr6uM6W7mWV3FGmJ4MqGQ1DpoQhlKJfOoTk6RWcHUk/QM69Mp
         qWJrFxbiP0If0sg5d6CArp/zA8QxkHkUJnzwu8g2M/rVkPIdJ0clbNOIdk3sYJ73KAn1
         s+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xW6AAlb0NSrViMGBoaS8CXAG+vAOOxYm2IIhxarIEbM=;
        b=rCosbIJTMbeiKeYHQwTqY+QZogkcTKarn+W+867kPvzqnXBE6dADycTukH+DjQ39zD
         q6dDzARhEln26WYFG1fg8rvXKQP4vYuPl4STmGnc5CrqJUnCYkDO+3SqayaLfyzi7T4m
         o/cKbNTuseh4rYS1+HS+Zg8UoCAwBOXhc3y0wYeiFHMCB37Q3jfgRi3DbR1dDK7sDAAz
         +mSWZS8k0lz7Ami3lhhTdDNIEHPW8YVN/dk1PcH2Hq0GN+eYM+b7ifIctUcYvaieZqGd
         BB9r54+rkY7PKpD4nnfjxpFPza2MRzm0Swo2fpPl67wLP/AxS9hja+uOLrbIuxIzA3mx
         XQ8w==
X-Gm-Message-State: ANhLgQ2LtiB/le0noduj0jI3so10iA21Vsli4fNdzBFd+8IDLdpYe+f0
        HEbNBTvvDl/jJbstmpHPjquuO1H9
X-Google-Smtp-Source: ADFU+vumOkALjbaIJcS09xS+ZYfMLjyOmq/z41IndL8xzlmeSXPo9lQtAdqSSa37ggTxVWFe0odtkg==
X-Received: by 2002:a63:3187:: with SMTP id x129mr9302572pgx.180.1584724448704;
        Fri, 20 Mar 2020 10:14:08 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e38sm5739342pgb.32.2020.03.20.10.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:14:07 -0700 (PDT)
Subject: Re: [PATCH net] tcp: also NULL skb->dev when copy was needed
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <20200320155202.25719-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cc8b3834-f9f4-d5e9-f2e7-7e40249e7609@gmail.com>
Date:   Fri, 20 Mar 2020 10:14:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320155202.25719-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 8:52 AM, Florian Westphal wrote:
> In rare cases retransmit logic will make a full skb copy, which will not
> trigger the zeroing added in recent change
> b738a185beaa ("tcp: ensure skb->dev is NULL before leaving TCP stack").
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
> Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Good catch, thanks Florian !

Signed-off-by: Eric Dumazet <edumazet@google.com>
