Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F304E1A3
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfFUIJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:09:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42179 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfFUIJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:09:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so5582223wrl.9
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 01:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PR92/JEMZwnNKU2C3DGFGBbemU42hIRwRLnglrS7YJc=;
        b=OCEY2h2afyHj7uKtsRtGIiYH8Cu74iwLjbtKxwB2llxE7Xm0Uc5cXYEfqRxHkr1O8R
         y5iCFmNWkQV0tJA9S3kUmIDUiQdwcRAYCLm3Oxwu9aK4W0z6j8MRGsGWmI1A8Xex1paz
         BjQebDXLPzM7pKHDkLys+NYPRhRgbt8jt/i0LsO/Q0dy5vBJq5+1g6bQqsJ0VD3Wj1B2
         sS2jsibSFxWkzA2kfcatT6PEGE+Kx474YuuksG+UaRbKCrGbHAPeTuzStkQ1yz8rV9K2
         fuYkUnP9/a1zIcoW8dPl2yg7ZKo8sxJBCKjLm5Ff2vSJw8GrghOt2fv+y8c0KHDGfek6
         2QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PR92/JEMZwnNKU2C3DGFGBbemU42hIRwRLnglrS7YJc=;
        b=XHfUL16qv0tSgbN2aAJ0BPPhUN0r7mLWO4l/idjsWELvEN956lNLcvo0TF5yOMxylY
         cCPB+2Gz1K/c3qD/8hiV/yCn9whkt4kVokOyjOYUU0+dtCDw4tiFrSuu2TVuxwXp0scV
         My1E6iQ8mLThhOkXi9/P7+AWxzRd05dH6m7+oImoianaD+8sG/VOQEO5U/R+paIEd4kK
         egPCNAk2iguqrcOyvFRZhGUXKv0H69cj26+pahun3RsCJQ1ZMGA7ZnI0TADwK0D+KvuR
         MbFrTLV7Qpin3SsFf3JUPv0zpISfrFe8qZ87GyfO2eU4sJwitvI3LN79D1d3YK0zy4Cz
         PUzg==
X-Gm-Message-State: APjAAAV2ttsyEYFSbjnvGs1cY5LNiqM6TKdqsLonenNKqKY45nPl0CBf
        9klwhflpWilBq1/pTYiXLY6CJOPtkYs=
X-Google-Smtp-Source: APXvYqx2sx+MNAVgwkFSkVzi1t6J9KTOcpA7PtjyGZXLUwkkVfUeHl1p9hcVc18AQZlvhZufukjQog==
X-Received: by 2002:a5d:49c6:: with SMTP id t6mr22279666wrs.64.1561104557516;
        Fri, 21 Jun 2019 01:09:17 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:519:49a0:d5f3:b366? ([2a01:e35:8b63:dc30:519:49a0:d5f3:b366])
        by smtp.gmail.com with ESMTPSA id j7sm2607389wru.54.2019.06.21.01.09.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 01:09:16 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
 <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
 <3066f846-f549-f982-7bc0-1f9bc3d87b94@6wind.com>
 <c1e3d444-a7c9-def4-9f16-37db5dd071fe@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <483e9d45-dd9b-45ea-a2e8-0b3ae6d25a82@6wind.com>
Date:   Fri, 21 Jun 2019 10:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <c1e3d444-a7c9-def4-9f16-37db5dd071fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/06/2019 à 18:36, David Ahern a écrit :
[snip]
> You don't have a fixes tag, but this should go to stable releases.
Yeah, I was not able to point a specific commit. The bug is reproducible with a
4.4 from ubuntu-16.04, with a 3.10 from redhat-7 but not with a vanilla 3.10.20.
