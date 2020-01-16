Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8613E671
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391596AbgAPRUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:20:21 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37686 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbgAPRUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:20:20 -0500
Received: by mail-qt1-f195.google.com with SMTP id w47so19467765qtk.4;
        Thu, 16 Jan 2020 09:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nYqhTNAODcj08o+Iw5Uj38+d+Gjt6QkbVMAo+P0Al6A=;
        b=gNNdE1xqlQTNxWrzBRp0zxnswM9okuIbuVXGsb5071kCP5DyRGZA8jkE3s9/g0IhHA
         XcsnzwSrcUYoFgiutn6CN30a6Z5udbC2+y9TxFgeQeIEvJr7TJMuD+3aY/2OH1bP/RjK
         sT4nisMDrvL1vudi1FmxFWA4TwnZxqA+n0eLUb0nNJKqUG9BWKPu+OTBiOA1XeSATC1e
         J1pJe2kZatd5+XplVruu4IOImldEVFF0/LQ6JZRmuZa254cgSsDv2KYAj53ufPsoTkGo
         cgWpEswiSIQtpNx89lpA4a6bd/pfNRhccwQAieQr4LGVbwf9QsskTsG+m+zzRQeZ6fiz
         dqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nYqhTNAODcj08o+Iw5Uj38+d+Gjt6QkbVMAo+P0Al6A=;
        b=ByoaL/edYtdM707Z6RruKmIiupew6h0khvU8wllppN+X/ot/6KE3p5w5R5yaMfHymm
         pM00XzByJCsnbQ/ycBP+d4iB0J40iWRu3ljZdCeeKe/+3ywh+Oq+iQi+XykHypp/SjY2
         /Uz+GwjTDNKej5DuGPFfMr92HhLEJPydmINnMp29zXOH9MridSEkxBG3B7ope8JiidEm
         Ndy0W4du2Id5BbaNc0wkVV7GWXP0D3jnjGBin/vfpQnJhbkQAI696NfprqO2EDGtFeYd
         PpKLXAg/lBR8Bl7A0eKhUghekUVHWeRadk9ptWbgxTtwIxT9K0cyZlD2HACGyCgm+iYn
         0ucQ==
X-Gm-Message-State: APjAAAXATZ4Ls5D5DHVEiA1jY0/t6rU0KALavBWi1Rb7M6whJOHrygl3
        RWtkJjVvmi7Hiz/IIWxcCPGmYKDR
X-Google-Smtp-Source: APXvYqxiWRk5q4Q98cKa8Qbh1r9gtwbt0VekwnFg0yVAUIqxde9eAnRyMN4e9IWsqI1uwB/EMhKGVA==
X-Received: by 2002:ac8:1206:: with SMTP id x6mr3547501qti.55.1579195219103;
        Thu, 16 Jan 2020 09:20:19 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5c84:fd9a:6187:58f5? ([2601:282:803:7700:5c84:fd9a:6187:58f5])
        by smtp.googlemail.com with ESMTPSA id b40sm12099516qta.86.2020.01.16.09.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 09:20:18 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 4.19 573/671] ipv6: Handle race in
 addrconf_dad_work
From:   David Ahern <dsahern@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-310-sashal@kernel.org>
 <fc012e53-ccdf-5ac5-6f3f-a2ecdf25bc39@gmail.com>
Message-ID: <630c6286-2ab4-44ab-693e-0615a2ac690b@gmail.com>
Date:   Thu, 16 Jan 2020 10:20:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <fc012e53-ccdf-5ac5-6f3f-a2ecdf25bc39@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 10:18 AM, David Ahern wrote:
> On 1/16/20 10:03 AM, Sasha Levin wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> [ Upstream commit a3ce2a21bb8969ae27917281244fa91bf5f286d7 ]
>>
> 
> That commit was reverted by 8ae72cbf62d2c1879456c0c5872f958e18f53711 and
> then replaced by 2d819d250a1393a3e725715425ab70a0e0772a71
> 

BTW, the AUTOSEL algorithm should be updated to look for reverts and
even ones that have already been nack'ed from a backport perspective.

I felt a bit of deja vu with my response and sure enough this patch was
selected back in October and I responded then that it should not be
backported.
