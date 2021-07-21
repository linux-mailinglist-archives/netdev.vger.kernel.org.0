Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81F3D124E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhGUOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:44:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48263 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237983AbhGUOoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:44:38 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AE13C5C0215;
        Wed, 21 Jul 2021 11:25:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 21 Jul 2021 11:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=jguvfQWRqSf5PGIwgKKlGqCFm3i6e0TYQAvb+bgOW
        cY=; b=CSSYMVigcVxz5bQlE1hUKNofN30drXQibMPMLzqrZ04Qr7/RxIOCpv6gb
        6q1JsQGsRLbvBXg189QgtxY51j8k6r68w7QdJ0bl+DWzyFG1Xe15wL+PrmEKQmRW
        qipSt2C/XOy54sUCK5SAZb/3iwKqdyMIsEEFsW8eeOlGKSpMzC5U7PsMV1ro8z5s
        mKm3LtEK8roumXCVll0TUc55Dgah8uV8xV0srwoBlsctawOxwLPrkSxtdgjLNvfq
        G4ZLwVdMs86rDDt75aGIRFTya0sV39ro9zLzSJq0t1cRk4NW9cSSI1IAVZy8Y++s
        l5qY4tTLOcCsJE9KobS2iban+Vofg==
X-ME-Sender: <xms:WTz4YMDqB0SDFuH3YlnG8OkQObsI_PTfwYTJZFDmUcY2o2SO5fi8qA>
    <xme:WTz4YOiPPUUEe6wSqbjaR38vKRTgscoR-Zeg-eaf5GiCctiCNeDzMiN9hRUTlGuKG
    70dVmhVn5Mf_NuqVzo>
X-ME-Received: <xmr:WTz4YPkNwZtfa5H4JM0gatP9X-uUVyKNmwebls3oxLxrzcE43dUvbJmp3Csq3qW9W2Wlj0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpefuvfhfhffkffgfgggjtgfg
    sehtkeertddtfeejnecuhfhrohhmpeforghrthihnhgrshcurfhumhhpuhhtihhsuceomh
    eslhgrmhgsuggrrdhltheqnecuggftrfgrthhtvghrnhepjeehjeekuedvkeehteeijedu
    ueevteetudetteduleekgedvgfevjeekudejjeehnecuffhomhgrihhnpehgohhoghhlvg
    drtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehmsehlrghmsggurgdrlhht
X-ME-Proxy: <xmx:WTz4YCwVMNgvXIboQMIiQZnDxeNwZtSBSBGZlXUvhSw8rmptOMy7eQ>
    <xmx:WTz4YBRQUihnyDIbET1_I2gcWxnyoCplsHR4CUNpqTBIDfbtlp_VHA>
    <xmx:WTz4YNasVMqJa8Z_5pbLz6FQTr5XTikEoaphTZ8lAtDn30nXihNbIA>
    <xmx:Wjz4YDeX2XbAvPdX6IieSU5_peyw1aNMm47ObyaN1tcVwdgpa8x3mg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 11:25:12 -0400 (EDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
 <4f1b5aaa-80e0-5dcc-277e-c098811cc359@gmail.com>
From:   Martynas Pumputis <m@lambda.lt>
Message-ID: <a68f1e05-e9c7-595e-23e9-6f02a3a209de@lambda.lt>
Date:   Wed, 21 Jul 2021 17:27:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4f1b5aaa-80e0-5dcc-277e-c098811cc359@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/21 4:59 PM, David Ahern wrote:
> On 7/21/21 8:47 AM, Martynas Pumputis wrote:
>>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
>>>> index d05737a4..f76b90d2 100644
>>>> --- a/lib/bpf_libbpf.c
>>>> +++ b/lib/bpf_libbpf.c
>>>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>>>           }
>>>>
>>>>           bpf_object__for_each_program(p, obj) {
>>>> +               bool prog_to_attach = !prog && cfg->section &&
>>>> +                       !strcmp(get_bpf_program__section_name(p),
>>>> cfg->section);
>>>
>>> This is still problematic, because one section can have multiple BPF
>>> programs. I.e., it's possible two define two or more XDP BPF programs
>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
>>> moving users to specify the program name (i.e., C function name
>>> representing the BPF program). All the xdp_mycustom_suffix namings are
>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
>>> a head start on fixing this early on.
>>
>> Thanks for bringing this up. Currently, there is no way to specify a
>> function name with "tc exec bpf" (only a section name via the "sec"
>> arg). So probably, we should just add another arg to specify the
>> function name.
>>
>> It would be interesting to hear thoughts from iproute2 maintainers
>> before fixing this.
> 
> maintaining backwards compatibility is a core principle for iproute2. If
> we know of a libbpf change is going to cause a breakage then it is best
> to fix it before any iproute2 release is affected.
> 

Just to avoid any confusion (if there is any), the required change we 
are discussing doesn't have anything to do with my fix.

To set the context, the motivation for unifying section names is 
documented and discussed in "Stricter and more uniform BPF program 
section name (SEC()) handling" of [1].

Andrii: is bpftool able to load programs with multiple sections which 
are named the same today?


[1]: 
https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY/edit#
