Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26AD2A4D6A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgKCRpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgKCRpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:45:23 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95236C0613D1;
        Tue,  3 Nov 2020 09:45:23 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n12so7653226ioc.2;
        Tue, 03 Nov 2020 09:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qDfU0t4F/POl1oSh41vkV5vL8aH/oLSJnnxRJVTTqCw=;
        b=tVrT4vO2nnUaA2st4pPmL/hxfg2Kp1a+25Y0Ga/5uVUFcdYJP9oO57C/voE3iw/cJX
         nti/oR9cqj1n//sAJDUj3S3HRjmBrUg90c+LYB20rQfpB958tJC+R/YUT85pGl2qDKMF
         2pzSiEFBUqNv+9euzL7xu2vqgSgpsvs12eq5nmndbLo1JgfbbUfgP6fr0KB48ls+idza
         EnsVDY7BIAzGMS6ejJqHZna9mPPf7E1ok9vs/wmVrLkglwIyu8sgnkPTguTFE6i25cQ4
         V3DG9Mj7Pp6TAk/PjZeEW3m37zzZASOfpInXA83whD8r7c3XK2YzoSRS8KUgvN4wmy+K
         KO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qDfU0t4F/POl1oSh41vkV5vL8aH/oLSJnnxRJVTTqCw=;
        b=K+HoqfRhi8eiG0beXkN590QwvWzxrLZ1omJ07+TMEvRfEANq+/hsf9Bk8uEW32YwmL
         LRjDX1seMhT6G5f0be45KV2UL4xONgqsR/yC/h/8Hl+PsZwpMoKo4+5CVYFfD1gOFjJv
         c48LJmQCj/TxTxHdpS1DvczdEoDtWzlyQJ59a6LKAmW8xbv0ozl2WjGm6h3O4+8wgCjV
         wbdyHXlv8tZ07+zetKWG8q+R8G4bZo/wIrgMMeMEkHH3WLATjq+/TH5yS6FS4FoRXfXe
         0e+ffcyPIxHayTiqLpAS6hkBbPTrvkLGQRT7KrkSfImILFcTsQqNj/mKAsTSQj7Rfxb7
         a3ug==
X-Gm-Message-State: AOAM531gHKkrlZDqP6fc7oKMyLPeHfL7QuidoiuAN3/KFo29QbYT1NlC
        9GBYGSE8W70o7/lL+fRgmsw=
X-Google-Smtp-Source: ABdhPJzlMi4XEK+R4jKZLBvF5HOOuOliid7941qNpH1X3f1Qm7dyEqDOfsvv8Nldpcm5iEjy/Wtk7Q==
X-Received: by 2002:a02:6a59:: with SMTP id m25mr14829567jaf.132.1604425523085;
        Tue, 03 Nov 2020 09:45:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id n4sm5632507iox.6.2020.11.03.09.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:45:22 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <20201103094224.6de1470d@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <417988c1-e774-e16a-f6af-170e3b11b5f3@gmail.com>
Date:   Tue, 3 Nov 2020 10:45:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103094224.6de1470d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 1:42 AM, Jiri Benc wrote:
> And I'm convinced this is the way to go for libraries, too: put an
> emphasis on API stability. Make it easy to get consumed and updated
> under the hood. Everybody wins this way.

exactly. Libraries should export well thought out, easy to use, stable
APIs. Maintainers do not need to be concerned about how the code is
consumed by projects.
