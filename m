Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602231F8606
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgFNAea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 20:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFNAea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 20:34:30 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C812C03E96F;
        Sat, 13 Jun 2020 17:34:29 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id p15so6164870qvr.9;
        Sat, 13 Jun 2020 17:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xhDQgSlxauq4koVH1jln5IkM0olmjc97GyxoQx2UWbU=;
        b=qvKw6vs1M9rZWjiczu/pRIp52Py+5W/XG2lT4dkGAEh0irUZbh7IAUs8zO0sJvPwcu
         uDDg4ICC5b0llEOhkd0FD4DI4lwotwSpkHdeGzwaGHRTK8rHvHtQmsHSKMVBgyxMWO6O
         oFFXXd1XaKamKpSXqxcLZEnnXv4BtSkO2mCOsNR5nbqPV/wHpAFD9b8mBWwXzkOx2Qbp
         nBjOMHzgPOhmxeXoRxFLwIJjG1WyaIIRj4s2XdQXF0Rtl7POitcUq8mMKrdwxkAMe5qu
         LdglWQKJUzUA/tKqIdWjoMhZ3rcLNAUiDjeUy35nS7wIF5rDf7u/3WtyPYpa4XfPjLqh
         tZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xhDQgSlxauq4koVH1jln5IkM0olmjc97GyxoQx2UWbU=;
        b=bPNiZ1G8JkkRV4bCxqv6SQ9PrkG8eFpEfL5A1JYQFZZXW8JUXDr2vLs/cDqc0urElG
         VEYlMpijtMrpsdOnjEledigUTBPn8cLIfmC96XwgygCSQtLb2ZoLGj4hzqSZPjN9xeCe
         xfTEitn54WKC7DszMBya20t/Dp0P1D/xu4pqHB+TFuJg5r8jmi8Z0Ji9yYDylNF8Nzps
         TgPq604sR1tms2AAiahQiBVn9iLQGSh0ZWj6eW5naCNZuylY6apquv9n9VEIp2wh1krF
         88D0L8L/sybLr6+cVD8vcg1eP09eL/QwP/OYfw202+VWjno1IRa1Vnakr0zLWZngMhHy
         SZ+A==
X-Gm-Message-State: AOAM533Tto7VrrPzur2fgnzUIel+C0jiTMyXPMI9a1QSUe6GEsiBqwgK
        FMrW/Osbm/pCnqXiJeduEBI=
X-Google-Smtp-Source: ABdhPJx0vim7ho1oWIBdussTycMgOanSkkbC4PqvxV8r6baBCoorrzjBO8TlTQaJ+K/1swMDnMF6rQ==
X-Received: by 2002:ad4:5987:: with SMTP id ek7mr18844817qvb.206.1592094867562;
        Sat, 13 Jun 2020 17:34:27 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c0a6:d168:a4bb:a408? ([2601:284:8202:10b0:c0a6:d168:a4bb:a408])
        by smtp.googlemail.com with ESMTPSA id p11sm8956712qtb.4.2020.06.13.17.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 17:34:27 -0700 (PDT)
Subject: Re: [RFC,net-next, 2/5] vrf: track associations between VRF devices
 and tables
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
 <20200612164937.5468-3-andrea.mayer@uniroma2.it>
 <20200613122859.4f5e2761@hermes.lan>
 <20200614005353.fb4083bed70780feee2fd19a@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <df8e9f2a-6c39-a398-5a44-5c18346f7bdc@gmail.com>
Date:   Sat, 13 Jun 2020 18:34:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200614005353.fb4083bed70780feee2fd19a@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/20 4:53 PM, Andrea Mayer wrote:
> Hi Stephen,
> thanks for your questions.
> 
> On Sat, 13 Jun 2020 12:28:59 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
>>> +
>>> +	 * Conversely, shared_table is decreased when a vrf is de-associated
>>> +	 * from a table with exactly two associated vrfs.
>>> +	 */
>>> +	int shared_tables;
>>
>> Should this be unsigned?
>> Should it be a fixed size?
> 
> Yes. I think an u32 would be reasonable for the shared_table.
> What do you think?
> 

u32 or unsigned int is fine.
