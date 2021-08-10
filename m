Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8703E56A4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhHJJUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbhHJJUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:20:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B116C0613D3;
        Tue, 10 Aug 2021 02:19:38 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id q11-20020a7bce8b0000b02902e6880d0accso1466353wmj.0;
        Tue, 10 Aug 2021 02:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mdkQluT1YKU8TSn2hpDxZUIUuX8zWsmkIMNtHoK0wRc=;
        b=qVM7w2WOseqIEw+mvNsvmGJXAzYFNM8Mie/v2wzH0JqGmrG5fOKwNtYQ8W776vTCdU
         aI+EPC0cVyNFCqV9Pxwtyaq+TOWm+rDGAuXaDNaXxnkonVhbOPW4yjeJSNRHr6czJ4uh
         UmsblVZLlNTN93SIn+UcgPT8+NqQFtC4/mFuw7uYCpEdrVpp2U+fLbEKG8D1fdIkBsmR
         mv5iGBAj/+syo8LT+/Krol9wJ0y7KWaBCfVtZM789SpGQoz8EZTtVPW6pg0wD3tflb+u
         68u10QojnFTJ3GrdNQkxfeCmR3DJruqsr/Oy/FiP83cgikNtyE0EFAjpQAQiFYyqsP4m
         qcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mdkQluT1YKU8TSn2hpDxZUIUuX8zWsmkIMNtHoK0wRc=;
        b=Tnmx1g+5+MM5GXuyeQBBqCnyEVYgOr6jExbEBRwbnVNnuXaN5i3bVdndGBwYIGy2eJ
         47db55mmTtL4VAV0cp4SGCQylngB8/yfp077sPCwKLbOEcTWeoX49FejiGnkGj0rsnpw
         SyX0jA49MtMdwHhQ6ZMdrqmLOSeEw21RZHsKX7DKhxq/sNm8WXCv27Ier/Hpwgx1W2MI
         Zix/MC3QIVrpsF2m7X04lZQ39uuB6kNBbSkkwpoKtwauigJ3GpdBrpo/ROekD81pMOEV
         tMrnPyRkZdBTVjzw9gjOwmnqdSXyA3DXh34iHGO95J9A1o2mvuRZH87oQI2XFSk+jEiY
         rUcQ==
X-Gm-Message-State: AOAM533tDEm7FqZ/9z+Yi0ugfaUzIKzM8O21oOqhGcGxuHY8T/ca5Ehi
        BI34LN07g90naDapRiUU+t8=
X-Google-Smtp-Source: ABdhPJy/+b23lIB1oxOeE0LvJTOKe0visUMdYUMrEVAA4hRnBpkcBWogNS+intxWX6QIQc1UiCUiKw==
X-Received: by 2002:a05:600c:213:: with SMTP id 19mr3636088wmi.2.1628587177196;
        Tue, 10 Aug 2021 02:19:37 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.16.90])
        by smtp.gmail.com with ESMTPSA id v5sm23513837wrd.74.2021.08.10.02.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:19:36 -0700 (PDT)
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Shoaib Rao <rao.shoaib@oracle.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
 <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
 <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <66417ce5-a0f0-9012-6c2e-7c8f1b161cff@gmail.com>
Date:   Tue, 10 Aug 2021 11:19:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/21 10:31 PM, Shoaib Rao wrote:
> 
> On 8/9/21 1:09 PM, Eric Dumazet wrote:

>> I am guessing that even your test would trigger the warning,
>> if you make sure to include CONFIG_DEBUG_ATOMIC_SLEEP=y in your kernel build.
> 
> Eric,
> 
> Thanks for the pointer, have you ever over looked at something when coding?
> 

I _think_ I was trying to help, not shaming you in any way.

My question about spinlock/mutex was not sarcastic, you authored
6 official linux patches, there is no evidence for linux kernel expertise.
