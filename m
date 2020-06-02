Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB811EB38F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 05:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFBDAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 23:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBDAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 23:00:08 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC9AC061A0E;
        Mon,  1 Jun 2020 20:00:08 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m2so7845289otr.12;
        Mon, 01 Jun 2020 20:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jtF4AvSxqsU+X9FzCx+GzCjq0VfbG8HvJK2Tbq5CDY0=;
        b=RSLiVLlsx0GyxaZMFtsugZhjVJIetvCAIvJP23h6+s1CmWYVi+9rjm9kh967ZbfUD6
         YhI+GjME7AuAUWgT7kzgEyIUEvBDm0SlAoqaRcXEIvlqH52XX8WCcxHoabvniHBgcDbD
         5BrUnGoG4gSNgXDpJSW/0xWGHbsFSxmxVM5R2/jOqCPvhqpHKYaCVcTzG6rHBUDyipa7
         XGRsjdoJGaKi0D76fzf/SLqmOp74HQJQWaHmGYrOSwInw7QiEvR9ccGfyKrFIldUZFzi
         BQuBdfZz2s1On6aauHFFWzf9d5oEboRO3SLQ/VVjuCYDclR+MrRsCJdUzlz/CXF9rubQ
         A1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jtF4AvSxqsU+X9FzCx+GzCjq0VfbG8HvJK2Tbq5CDY0=;
        b=U/aw/O1AcVTVYWyaqbetvVdjrsHz62xL95C7heCD+Fm0Ok6Igdcbc4aK9JwJxLx6hn
         SoHRGSUB85pUAX7o9PE3w6s28pGzVWafvDFNFvOfhtOdz5YsE/Uyoh/sQn3LzlihFfQk
         KVgiU1oPOSyEERoiUHngDxXY+DeB7X2OuOA/mRbPYyDfbHLXNAqKtTT7O1DLhNM+eTS7
         6lZaiH+SCuqnRWLc7fX3jISs24UE9GBRt/KIHtPWOWCW9x3AM/sDm07q7fz7LHxFocuO
         gVcYCEt9lOboMKl8aGF9ALTUyJVXpHi+Y7wUEPb/orowF26HriQkN0dm1eByV18M5i0F
         3o7g==
X-Gm-Message-State: AOAM533BxTDIzs9hwN2BfPgQcAzGTaCH59HMQjHWX+NVGvlG1tH6/kFF
        n5QFAjEwpe6/y4lWCSQDXJE=
X-Google-Smtp-Source: ABdhPJxRUGiVLdRKfwEwmeb0IyoH6Hz9zy6DRrAZooecRAHQb8hsQJic4MPO8aGA5Nlpq2LhzPz4uA==
X-Received: by 2002:a9d:3f5:: with SMTP id f108mr19613801otf.74.1591066807662;
        Mon, 01 Jun 2020 20:00:07 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c9ef:b9c4:cdc1:2f07? ([2601:282:803:7700:c9ef:b9c4:cdc1:2f07])
        by smtp.googlemail.com with ESMTPSA id u17sm329505ote.63.2020.06.01.20.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:00:07 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200529220716.75383-1-dsahern@kernel.org>
 <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
 <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
 <CAEf4BzaYU7-JhjnStL_JWVtL1-8wuB1ZcJkxoN01_bbKvdyaqA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2fe68b0-922e-a5ed-f2c3-5d1a122d790f@gmail.com>
Date:   Mon, 1 Jun 2020 21:00:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaYU7-JhjnStL_JWVtL1-8wuB1ZcJkxoN01_bbKvdyaqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/20 4:52 PM, Andrii Nakryiko wrote:
> Do you have specific examples of inconsistencies? Seems like duration is:

nope, just a quick grep trying to understand why it compiled cleanly for
me and looking at similar tests.

> 1. either static variable, and thus zero-initialized;
> 2. is initialized explicitly at declaration;
> 3. is filled out with bpf_prog_test_run().
> 

apparently so.
