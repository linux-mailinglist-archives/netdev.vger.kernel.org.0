Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613D3403005
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbhIGU51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 16:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhIGU51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 16:57:27 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A7AC061575;
        Tue,  7 Sep 2021 13:56:20 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u1so6600710plq.5;
        Tue, 07 Sep 2021 13:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YmP9q78+HL9MRTEtUSJRzT3l9AZ1B5DfbRIDhNkP2QU=;
        b=qi5igrp407rylIsW9HzbtpKoxnOMZnLRKgriZX/FQ2OAzAugVpBNwe8Up+oWyHPDqa
         ld0XlUeq7hj224Laq8rvoPCDFjMIdzUwHObbUZoOZYedytDPEO6r9tDEWa82Lef5SPat
         9s5quEH6w5D1O1n1mJGQE2yeBr6nmjpqH1t4vzL88DT+otvPkITfeo7I9iWU5aBEdlo2
         cfbFpPG9jiehBvB2YPx01GuXxzt/hOANdGL712A4K4Hg9SXlqMUJscD8tgSFS+r5WGZc
         Q86R9QF8kTT5ETLL6mgfoUIoLl5QyFLzgRtmK8N9a+tJ0MKfdQA73pKNCg9fDMijqJl2
         sm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YmP9q78+HL9MRTEtUSJRzT3l9AZ1B5DfbRIDhNkP2QU=;
        b=tPLPCdvdUjU7NzSHazcK2GG41zaFbfinOJof2cYJzMhjuU0zIlwqpFloQ6z2eyP7Vz
         URQY3ZtcKE+OWpF2nBAm2kG9fDHUHofInUg2/FHPhZB4c7JLAl3G9BaSaKb8udfNuQyj
         FYQ/Ap6SkQel/D991I67tgD5W7XccifoLt8UHK0fEpcdlvzBYZvnsz7VsR+w1p2pxPxd
         BQtvxHiPs/F7KJIeWliFzg9usAa9dWnn5zwCXcEq1JxjubJlFY+xWEnLJdOGCFcRByQB
         HqNpkGSQRLm2cXw9ANOVUX2cBHsuSqwu4XD48hkrt9J81a7JKLmMCbQi1imTpvWlFBo/
         dguw==
X-Gm-Message-State: AOAM533LJN3NSCXGG+bk1kfjjeTJ9yQkplDq1ZmJur6y4xD7W7DsYnHU
        D9T/YEy5g95ii5jF1Q7fgGzSIpIbqyg=
X-Google-Smtp-Source: ABdhPJwjF9v9eFwUgV1yYcVLqYDk4WaZbtKIyAgxjT5qZjtP/6aZuuR6xwi7MzfbVZ/vxTSb+qauZQ==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr315044pjg.217.1631048179871;
        Tue, 07 Sep 2021 13:56:19 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id z9sm24510pfk.28.2021.09.07.13.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 13:56:19 -0700 (PDT)
Message-ID: <73b64f16-a8d0-cd1e-c08f-dbc3cf493e5a@gmail.com>
Date:   Tue, 7 Sep 2021 13:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [syzbot] net build error (3)
Content-Language: en-US
To:     Marco Elver <elver@google.com>,
        syzbot <syzbot+8322c0f0976fafa0ae88@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
References: <000000000000cdb6a905cb069738@google.com>
 <CANpmjNP2JEyFO_d9Dxkw5h6WQL70AhDsxkyoFTizvo+n3Ct3Tg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CANpmjNP2JEyFO_d9Dxkw5h6WQL70AhDsxkyoFTizvo+n3Ct3Tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2021 1:14 AM, Marco Elver wrote:
> #syz fix: x86/setup: Explicitly include acpi.h
> 
> On Thu, 2 Sept 2021 at 19:34, syzbot
> <syzbot+8322c0f0976fafa0ae88@syzkaller.appspotmail.com> wrote:

David, Jakub can you cherry pick that change into net/master, today's 
net/master tree was still failing to build because of this.

Thanks!
-- 
Florian
