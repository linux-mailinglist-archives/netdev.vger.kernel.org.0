Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5BB1F0397
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 01:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgFEXpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 19:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgFEXpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 19:45:16 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979BC08C5C2;
        Fri,  5 Jun 2020 16:45:16 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id y1so10010304qtv.12;
        Fri, 05 Jun 2020 16:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cDnXKvrGYGj1JaieRDbcFskiNgfUz83IdJ88bt0ez48=;
        b=RnwtsHCyQOrlUpn6nT0vBiJZLcUP2AKVs+4NI2VOaB69paLwHOYh13BlT0ky1Sejih
         NTBuYwc1XrFINYItQB68VSYT9iZTCQebVRmLnHlNbd+qJ81zu4JaOPVZbKivd6ujAnSk
         Cxv42AkW3XS4n7sVRQre6xFJS/otDPKf6g0zHiEW/7nTLUlN0lBCJEO77JnQHvIamYTU
         VA2V4hc18woOvxeUJ9uAVzOzSe9kVi69PYCx15pVuzjYPQYHTCds7YTlcmjq+xEmxuyI
         LYuaQwQkrvrIVnp1kpZaFjnoJd/jZ8MO3LV0J/15CQ8i/IsoLGrhMQpdId6OujgqpRPr
         gGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cDnXKvrGYGj1JaieRDbcFskiNgfUz83IdJ88bt0ez48=;
        b=HIp8cBbp9y6IrykEAlM6uYRXMg0F3PzewrSzE6pU2f97LpGLiNxy3wHD49OvUiyy7r
         dMj02+1/3cDtj2oqtz/a50lYZK/4oYZ9mP1yfxsrUIu5g4Sp1C4WpKpYd4vSJPTaSHt9
         sAG+wG2mRk3WUZm31B8f262pqorkEfS3uMImZhY6UJM14Pk/8yxFAnUhWQIiJjDCpB+s
         Iha9m8iecteER/q/sofx6jGki+j/mCR6y5Re5gbTvU0IY1HS4pr8Mz/+itPeA5/VLdrG
         iAgOBj1avtrdJpEH2i+mIVSp7Lmp6Dqh7y1PX1gP2cpwdVDF9QnfPE2I1WIeV1Bcm7eD
         hWQg==
X-Gm-Message-State: AOAM531BB2zkOf/evt8zOmyALBPo+izTOe2WUe9MhUi91EuW4vz2Z+Vi
        LQGLlHklcH2mjCaR8ENqabg=
X-Google-Smtp-Source: ABdhPJwOYYiME0l0Mhpfxm9+ltFRZPYoQ0qo3TiQh/gYXf7yXL4rWSYdBpeWhr7ZzI4lvCbu3jIsoQ==
X-Received: by 2002:ac8:3483:: with SMTP id w3mr11790858qtb.330.1591400715346;
        Fri, 05 Jun 2020 16:45:15 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2910:573e:9fb2:51d7? ([2601:282:803:7700:2910:573e:9fb2:51d7])
        by smtp.googlemail.com with ESMTPSA id k190sm1117514qkf.40.2020.06.05.16.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 16:45:14 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
From:   David Ahern <dsahern@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
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
Message-ID: <3136e24a-abf7-3cdb-f0a8-6de8830bc3f9@gmail.com>
Date:   Fri, 5 Jun 2020 17:45:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/20 4:28 PM, David Ahern wrote:
>>
>> and that selftest is imo too primitive.
> 
> I focused the selftests on API changes introduced by this set - new
> attach type, valid accesses to egress_ifindex and not allowing devmap
> programs with xdp generic.
> 
>> It's only loading progs and not executing them.
>> Could you please add prog_test_run to it?
>>
> 
> I will look into it.
> 

The test_run infrastructure does not handle XDP_REDIRECT which is needed
to step into the devmap code and then run programs tied to devmap entries.
