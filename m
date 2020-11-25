Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E832C3826
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgKYEhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:37:21 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3288C0613D4;
        Tue, 24 Nov 2020 20:37:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m13so839255ioq.9;
        Tue, 24 Nov 2020 20:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8bh703RdQJMiFjZ/2TVig1+CsViCDtpTQ+pwTnkS0aI=;
        b=lyjUCf0YY89CujTP6TiODJZJVVpGFNZ8gdWlLdScAig25En/QJlIlxjfqOIb01Zif6
         Bh2JRBBMjbZJcO6di5S2LERBnZTBlloUgStYbesM48lRovhDLZL5MhfdfHuERn4mvaQi
         eCI/WKgi6xAngC6cwus/HVYSk1FcDIfjvyMuEZJHpoy7d6QCHvCVWPJuV2GnQderMVNA
         ZhMjNrO0Pgnw0BLyEveurYXv0HJvCru3/455fLtG0VCC5y4eOQvrFaXQswkZ9lZXNy7C
         YrDtN5EidCZGm0WOzlfxAGm+70YCr4Vj+i/uqAkSGrsMzQfzP8D4kGp99FBG46OVsW/C
         GZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8bh703RdQJMiFjZ/2TVig1+CsViCDtpTQ+pwTnkS0aI=;
        b=kkcTKypmVXGk8ycnlePOEDaIOJGNb6k2DQNE1hfl+d5EYGP1U5Vahkvn8uepVd3P9W
         Hkly+tJUuY076mvLH4UgNE4ezG8LtpdvMMDp1MloiH4vb+FM2QxqYCdkM6V3QDf9xeI6
         jhV34IuXRHHVNOVHw+KkoScpercvnP2/EJDfu1Falm1aTgcKq/S8yPH53d3aSX3dFjtf
         K96TrNz6yOYTZ/YZVLcUnL6uyIHHQl7hiqSoFUcCLVm5lWgs0O2asOnUykG9sz9I652d
         WpaWQjffkmX2Zu5rRir5LrWz7btl4xnU3pipTIh1csqQWvk80o7nXTWuujFWgBJUsU5I
         lBjw==
X-Gm-Message-State: AOAM533rDVEX130lD/pCVQwdWsmlgJlDUxzKtHcCfTaw+QLP7b6i2npL
        v9irFtq+uWhN9dY9+ghkl4A=
X-Google-Smtp-Source: ABdhPJyR0UwKEWTZs0I1rdSWvy8UVth1Jl0THdtP22esRj+URkzRP5NRGoiTiEvVBansBr+CJ8AKkQ==
X-Received: by 2002:a5e:c912:: with SMTP id z18mr1345453iol.185.1606279040813;
        Tue, 24 Nov 2020 20:37:20 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id z17sm501610ilk.53.2020.11.24.20.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 20:37:20 -0800 (PST)
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6 behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
 <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3dd23494-d6ae-1c09-acb3-c6c2b2ef93d8@gmail.com>
 <20201124175803.1e09e19e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08201db4-d523-3b0e-fcb6-dfb666f2e013@gmail.com>
Date:   Tue, 24 Nov 2020 21:37:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124175803.1e09e19e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 6:58 PM, Jakub Kicinski wrote:
> But it's generally not a huge issue for applying the patch. I just like
> to see the build bot result, to make sure we're not adding W=1 C=1
> warnings.

ah, the build bot part is new. got it.
