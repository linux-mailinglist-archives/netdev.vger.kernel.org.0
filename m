Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3F127F75
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLTPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:37:18 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39217 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:37:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so9831266wrt.6
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Tn9iSGR8aWplSyc0f20lPDuu4aMdmRpNytOn41OfwA=;
        b=SEj7Tr+nA5pHgRzpDJ24ZXWldKG0JkeijeReyAt3avmns94FcOGfPaUyZbKg5iC8SY
         k0ZsVhcUjhEXy/8J3Wgz/62i6gZZmP4LnQ8BvOVssz1Rvil4xKDaCN8XCMw31WG5dXeG
         s3ZhsTbmkOD0OVDzKXd45hiZlqmQ1XcEJgB5O02csX3FWgeYoe4xBcvzG9p7RDxIt5NN
         owIPxoLZMVM2FfwnqIRkIPzgt+g/Q6lJE3EHgBgE0g+jLLJJMZczpbh3pMmvEtf7W395
         uj+ZZokFQh3fKMAg5Hl64ViaX0Rtq9ZnshFwZ1WI9n4Eu9aUDKBsES9J/TT/YuGtD+UX
         LkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Tn9iSGR8aWplSyc0f20lPDuu4aMdmRpNytOn41OfwA=;
        b=Vt5j6QIY+HW4leaSJW8jIRrhuLXmYoJpWojk7dWW5j20LYbuJNCMY5kJ7xtne0m0L4
         CcDUxhYKi6aaDqNbPmNDSD9zu795zFKLSF64ECJZh6KWXn2Z6lpEezvRntJQEbFFDIMw
         8sPFudN8sm6ARUGyaN/KIJsedTMb+boxxaKvfjwSP1ld3U/EZZA6lpmbXOdZ/VcnID/L
         YXjF0RZjlQEPaOldfIFluwpqk5un/KGl54Z8i4AZ/X6jIWLjCvA2BuT6GmrJCqkvEzVB
         /7CvOpf4y/WCX0PkPwnoVmHQiRaJMqGR1pKwL4AMcC+H7YtLRbA6mA+fn8rlMWvF9j8D
         abGA==
X-Gm-Message-State: APjAAAW3CyYgnCYSj+GO+Zy3AOaqX2uOlA3QV1lTmbCQZZ0uhGES/Twl
        fm63pGGLqmGr3+wK2Vlbqok=
X-Google-Smtp-Source: APXvYqygvfwKCKdCXS1SZ5HUmORQiFZ3sF1VmmI/EEpCdx8UUXGIBlR7nOhRaEe5Fxif2jwT3L3kNA==
X-Received: by 2002:adf:ea4f:: with SMTP id j15mr16260895wrn.356.1576856236350;
        Fri, 20 Dec 2019 07:37:16 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id t12sm10338541wrs.96.2019.12.20.07.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:37:15 -0800 (PST)
Subject: Re: [PATCH net-next v5 02/11] sock: Make sk_protocol a 16-bit value
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-3-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8354e6ef-c4ec-080f-5272-baf825646c83@gmail.com>
Date:   Fri, 20 Dec 2019 07:37:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-3-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
> sizeof(struct sock) does not change.
> 
> v2 -> v3:
>  - keep 'sk_type' 2 bytes aligned (Eric)
> v1 -> v2:
>  - preserve sk_pacing_shift as bit field (Eric)
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---


Reviewed-by: Eric Dumazet <edumazet@google.com>

