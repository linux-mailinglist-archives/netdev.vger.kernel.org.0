Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B70292B6E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgJSQ17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730527AbgJSQ17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 12:27:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7C4C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 09:27:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a3so14729992ejy.11
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 09:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=444fod4pS8wnwCeyAaaHBWf5AIrCVyPy1iAPkz44TYA=;
        b=KrMGx96x8S9Yhxs//KdD1LfYnksuqGPbDu9FwuEjwDGSuAOganTiz5gxrzu4058i1C
         FQzKsjF/6GFUOuTsIOs5h2Ibrki/ae/ks0KdAvEyv3slTjKEkcby9wJei8eQwttzY1qr
         zzqC9Nr43esAejllMH5tBZlCQWXy4g56GXu9OMz0gXjkskpNfd38JyWee3cVaUP5xXnK
         sAVmcVBCK2fQXyg2TSjMZCxTctJUXRFnJ3QW/uXUn5R4p92SjBOX/iA+FK4oWQ6OhtKj
         idjzqDEHT+2mZbzj37HXeQdVHIrntv0LHHXkt9Oec4UXiBi8m4mclUJzLsleum6CfRkB
         n6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=444fod4pS8wnwCeyAaaHBWf5AIrCVyPy1iAPkz44TYA=;
        b=bFL5De3IZz+MajyNy38pxwyZLMfaETX3zMTo8wy3qXviwQwb7WSxjsF7qnvOVrBa5n
         zPVmeHAZ316Gvrzrh+/IwrgRmB4pePFMnbbjuCz+1QTQQI0z01W+WVPULXyF88a3/via
         Y4kBnAk+l3pL95lQlcD874wbns7yLUWZajFVc4L1YzIxSQXB2dIIU4UBO5Ty72+HlF8M
         uIr2akaTtB0avJ9txLmiJjq3VTV1wKTiLjGsd/9QIfM8RpoRLMGd6MPlUGnxVumODWXv
         dRCUJV9oP3ftcrSnSGdP9qRiYbkyCk+DvRYiB/KL+ZlJLjgvbSU68OsZeOXISfAy45+f
         Ae8w==
X-Gm-Message-State: AOAM5332TamaJuPxqphOpycEIeNEHWVsiv8bCx/9Lme37TZ8AOzZHgsq
        0FPzmYteS3uohLQz+Ck/CbPWBA==
X-Google-Smtp-Source: ABdhPJySND+L2X2Ywosoq76p6+DF/hvYOugs84xxpn6IKdznP7CRfSztcbQ7lPM5DuyqxKRPmrsOLQ==
X-Received: by 2002:a17:906:95c5:: with SMTP id n5mr680433ejy.111.1603124876855;
        Mon, 19 Oct 2020 09:27:56 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:b49:2ba2:dca5:18d2])
        by smtp.gmail.com with ESMTPSA id p3sm212556edy.38.2020.10.19.09.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:27:56 -0700 (PDT)
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <cover.1603102503.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [MPTCP][PATCH net-next 0/2] init ahmac and port of
 mptcp_options_received
Message-ID: <7766357d-0838-1603-9967-8910aa312f65@tessares.net>
Date:   Mon, 19 Oct 2020 18:27:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <cover.1603102503.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 19/10/2020 12:23, Geliang Tang wrote:
> This patchset deals with initializations of mptcp_options_received's two
> fields, ahmac and port.
> 
> Geliang Tang (2):
>    mptcp: initialize mptcp_options_received's ahmac
>    mptcp: move mptcp_options_received's port initialization

Thank you for these two patches. They look good to me except one detail: 
these two patches are for -net and not net-next.

I don't know if it is alright for Jakub to apply them to -net or if it 
is clearer to re-send them with an updated subject.

If it is OK to apply them to -net without a re-submit, here is my:


Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>


Also, if you don't mind and while I am here, I never know: is it OK for 
you the maintainers to send one Acked/Reviewed-by for a whole series -- 
but then this is not reflected on patchwork -- or should we send one tag 
for each patch?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
