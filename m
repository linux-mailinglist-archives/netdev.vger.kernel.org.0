Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE7E31041D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhBEEiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBEEip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 23:38:45 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85AC0613D6;
        Thu,  4 Feb 2021 20:38:05 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id k25so3617055otb.4;
        Thu, 04 Feb 2021 20:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gXJkzkVbLeHT96SiJVJ5L6nwS8dlabVVFuYGhFlSHBI=;
        b=DB3QCxj44EwrtjXYUT8hkpTiTWDzKIhr+3JjmRYVwVVXSL/EwCBfu/sZeBvXmxHJ1i
         XF6AxvJ4JdY3n3p3BKHY3Yd8OwKtgYAfzjKPpr58AcOaPByUVC/SDMtP8ul3y1FoAGLJ
         kcUjJw1lnrhRb/xvBw6Z0NPhYeYAJevkjJ+zhKAszu2fDxV/0B4VbkV8u+5n0PXHMLig
         HYv9dRDywE4xSz5RT4tQNF3qurh4WaZpjPaXFzbtPtI6cu3ARzRqf0TN3X/jjKge3You
         wNCxPKx50rg9Frqn0O/fXGNwmxzVlc8DtE05Gk9Hc4x0PlfMol403yrfILfCEEVMUAIP
         X+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXJkzkVbLeHT96SiJVJ5L6nwS8dlabVVFuYGhFlSHBI=;
        b=f9fOxunRzAo33Fl4yOOHJUjIIbezNwuUZW4+OD/oiqt+csH5RuICA6FSFWlVewh/O2
         fyqYq0iF27fIU35uadQkX5uNV95FkIDHrsC4htJk2XPPHbpUfAb+LZmZ8uLV5omCQowO
         lhGM88TG+EmgX5aMHdknILy0XqDFqDDY3Lkec1PL/0Gj6A5TBjfII3fHRpy1asFkE9Ug
         8Wv0xtoB4tnEK2yuRNlrjIIb6i87Jf6+7wnUJmDzcU8bmLsmv/lwq+Gy3erjy3x51zTQ
         N3XFpAfq2o/3Nx+xe7x8rIFLkmmTlLlmBtx/m7SOZstxIvzQUOgH1hANi3KEOfBDGhtK
         d6ow==
X-Gm-Message-State: AOAM531XvITa1Mmdx2UYs6lq2SxyL9DY9UOP1JBY1JnpkLCGZbonb505
        QmdKxBwL3leVHP8Y7QRh1IQ=
X-Google-Smtp-Source: ABdhPJw2EB4BjSAqQzyQsTa1F4sGj4q4K0o0I0NE7bu+EUzdik5rPnzJ6I9i5HRpeBNwfv2UGoeH7Q==
X-Received: by 2002:a9d:5f12:: with SMTP id f18mr2106169oti.282.1612499883953;
        Thu, 04 Feb 2021 20:38:03 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id a76sm1620888oib.45.2021.02.04.20.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 20:38:02 -0800 (PST)
Subject: Re: [PATCH iproute2-next V3] devlink: add support for port params
 get/set
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Parav Pandit <parav@nvidia.com>
References: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b5a428af-80c9-0a27-e054-ddf1ff87b399@gmail.com>
Date:   Thu, 4 Feb 2021 21:38:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri/Parav: does this look ok to you?
