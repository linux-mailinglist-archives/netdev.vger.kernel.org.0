Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA15DC08A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406825AbfJRJHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:07:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46828 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfJRJHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:07:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id d1so5388295ljl.13
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 02:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SRH1Voew0FRQ/ys0rrwd2bZr5vliN3kcFi+61ROPMN0=;
        b=DzYe7NIk4aKjZxea/6wc6zg13mBF6NxLL61swMelZAs6V0og3EMnz3uooOL2talTwB
         D283dpluq8k6vxRvyYwbGtvy82lqHGb4wPjVkKn+rd0anjTJ4URir87+bBoyHEfQcGKk
         TrDTIlCe+No1Q+p/AsM8Diux2x72FHXxiXYEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SRH1Voew0FRQ/ys0rrwd2bZr5vliN3kcFi+61ROPMN0=;
        b=YyHe0V1pJLJcjyfRCZ9Vb8qFTJ1lgGmRMVEg8EesSLvbcy0bmR7DHUrMOhbuqJmr2J
         /nblC4GGx3IQBjRyYk7DkLcbzIqdaOyplr5UhGSzUN3EBN9w5OSPDa0Hew5L9g+4VU/u
         TIizG7g4Vr3Cy/7yP2ISTaU6qucHBXO8MaXneIvm6JRSDM+XPM8PmNG314vDq6dqazLw
         8SLJY/ACbYmEpwPTDVAf4YNgn3vxGHXlH+TVzaKAr2sgXX/dpq8HWLiYLlHDunAP0RuV
         EfEP/+Ix2r8Pl82Cyd/U+ADa/DvYeetncph7aBDrVb7e/kvowWS6RKXm5DVt90s1k3rt
         3WXA==
X-Gm-Message-State: APjAAAW42f6ADF484+to7RdK38UZyFPDUwc36m6ncwV2k3C8iX0YGk0f
        SLU6mKiqGCLHk3PWAskqdUcgsg==
X-Google-Smtp-Source: APXvYqzrdQoQzd5ANgZgmQioC7nMEp+JOdgCl1hFol2U0xDe4WD/umCDdNgaGUc/ZJML0aaJG18xIQ==
X-Received: by 2002:a2e:9848:: with SMTP id e8mr5439877ljj.148.1571389633398;
        Fri, 18 Oct 2019 02:07:13 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p3sm2066589ljn.78.2019.10.18.02.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 02:07:12 -0700 (PDT)
References: <20191017083752.30999-1-jakub@cloudflare.com> <20191017181812.eb23epbwnp3fo5sg@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Restore the netns after flow dissector reattach test
In-reply-to: <20191017181812.eb23epbwnp3fo5sg@kafai-mbp.dhcp.thefacebook.com>
Date:   Fri, 18 Oct 2019 11:07:11 +0200
Message-ID: <87pniucthc.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 08:18 PM CEST, Martin Lau wrote:
> On Thu, Oct 17, 2019 at 10:37:52AM +0200, Jakub Sitnicki wrote:

[...]

>> ---
>>  .../bpf/prog_tests/flow_dissector_reattach.c  | 21 +++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>> index 777faffc4639..1f51ba66b98b 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>> @@ -91,12 +91,18 @@ static void do_flow_dissector_reattach(void)
>>
>>  void test_flow_dissector_reattach(void)
>>  {
>> -	int init_net, err;
>> +	int init_net, self_net, err;
>> +
>> +	self_net = open("/proc/self/ns/net", O_RDONLY);
>> +	if (CHECK_FAIL(self_net < 0)) {
>> +		perror("open(/proc/self/ns/net");
>> +		return;
>> +	}
>>
>>  	init_net = open("/proc/1/ns/net", O_RDONLY);
>>  	if (CHECK_FAIL(init_net < 0)) {
>>  		perror("open(/proc/1/ns/net)");
>> -		return;
>> +		goto out_close;
> Mostly nit.  close(-1) is ok-ish...  The same goes for the "out_close" in
> do_flow_dissector_reattach().

Happy to fix it up. Is your concern that calls to close invalid FDs
clutter strace output or something else?

>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the review.

-Jakub
