Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA32195AC6
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgC0QMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:12:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36241 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0QMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:12:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id d11so11370818qko.3;
        Fri, 27 Mar 2020 09:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3mneeletZPDxl6gpFOubTy3m6yd9tUBoB0H1uCjcxB0=;
        b=CaikV9pjtKdft3hiEwtklL0+nq+FYgdo9I91r89dEwtsRMCZ1DSAquh6TgbHSI1HRJ
         CHspiMuTVJUYXSfhPF4MU+l5b7gQjjduqtbcuRCGRoZAFxifbfjK3TgyV64bp1/T7vra
         E5Gt/JBfWk8MhcM0Ew3wTpmU2SpumLv+7bi5SzloHTMb/HR46dqdjiPSLpBhA23LciCJ
         /aDBBJPJCSwc9AgI3JeAy0qRvEUoje76KgM6sDijEM2kMdB/XT5RMhwXN1NkX4eX5Lpa
         FUNvcyWEP356ugBZAfRaO5mZUeLozQXsosaIAZTX4ty7HD53IW39Vm0fNk6hhVaoIA44
         68PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3mneeletZPDxl6gpFOubTy3m6yd9tUBoB0H1uCjcxB0=;
        b=sib1Z7hB3S2tdR8U3Am8AYPLOtVfSrMMF8w2Ym+KCPwMQRhFXSeMrlLGtoe5l4MuuB
         xOafo3xvL1t9tyj7Kg1HrtHIncDnS7vttZWm/2YlhiI7jW2a+eSRcdaMDmOuxrHs4OTQ
         LkOvsbgsL6zz8uvQvzzCgj8hsVW1XCLHTRxV12aB6tXib+idjJKjBlHs38kSlsAWYy/g
         VllYiBpAGRymc+/BHh0ZKzHgmvQSuvOzGfoxVC3WXIMmKbrTyYSDADcBOhvfMYLtG+WO
         jX20d65mulMllCU5TmpFx0L94tPnpdNDv3hJatc8IE8N0N8zmWcbjSdXjRym9MpXcssp
         LeCQ==
X-Gm-Message-State: ANhLgQ2hdO/kXRBTZUTakrrCvNs4yEPCGJwRNNqXml9czn2/BZtawqkQ
        Pew+tKu1CCE0qGs9aLtfNTiCL0ss
X-Google-Smtp-Source: ADFU+vvZSYspPbZmO/DAnh7PQlPN6lll3GTeNLWEOtJX5yLjxE5ukXNRezg5tA5HeacB+o/91/ue8A==
X-Received: by 2002:a37:6cb:: with SMTP id 194mr46085qkg.235.1585325527934;
        Fri, 27 Mar 2020 09:12:07 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:69d5:d817:1ef6:d239? ([2601:282:803:7700:69d5:d817:1ef6:d239])
        by smtp.googlemail.com with ESMTPSA id x14sm4012443qkj.66.2020.03.27.09.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 09:12:07 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
Date:   Fri, 27 Mar 2020 10:12:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 5:06 AM, Lorenz Bauer wrote:
> However, this behaviour concerns me. It's like Windows not
> letting you delete a file while an application has it opened, which just leads
> to randomly killing programs until you find the right one. It's frustrating
> and counter productive.
> 
> You're taking power away from the operator. In your deployment scenario
> this might make sense, but I think it's a really bad model in general. If I am
> privileged I need to be able to exercise that privilege. This means that if
> there is a netdevice in my network namespace, and I have CAP_NET_ADMIN
> or whatever, I can break the association.
> 
> So, to be constructive: I'd prefer bpf_link to replace a netlink attachment and
> vice versa. If you need to restrict control, use network namespaces
> to hide the devices, instead of hiding the bpffs.

I had a thought yesterday along similar lines: bpf_link is about
ownership and preventing "accidental" deletes. What's the observability
wrt to learning who owns a program at a specific attach point and can
that ever be hidden.
