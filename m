Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336FCA3A30
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfH3PTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:19:06 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43131 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3PTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:19:06 -0400
Received: by mail-wr1-f49.google.com with SMTP id y8so7339080wrn.10
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 08:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glVlYMR3iJhyiPBG5wCXHa8wRhub+uwH1lFexuA4XEI=;
        b=AXNM1HLKNPVcFv1ufegi7tAiysV9gC5dkmpDjJ/g3a7qS15K0LHy7sPnkUdWmJ49pA
         a9KTnCWb8JUYDurBTe5IljESci33si+SNwzSbpTja5gVCEs4Q5Psh8PE/pBzsOIb1xqm
         FJEfO5QJLm8Zhg63Vx91Wto15ufXq0Y2RtmXAFnn4R1YFKb8OU5GoJGB6EuKTu0SRxhj
         yvL+l4YDXLfvFOc9CUqdM2TVFZ8hxBI5KAw3ukAowJgDVojTUx3GuabRTVLGmkvKpHI5
         pQ/Kcx3KgXhmJ732h9arKYdN3wNG5a+Eu1Xe0M7z52Ct5aUG1+mW5XvrmVgHxLDatHRh
         P84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=glVlYMR3iJhyiPBG5wCXHa8wRhub+uwH1lFexuA4XEI=;
        b=dnvBnIBYd5wHeDgawqw05Bs8OmlqnRdox1TYHnUN/kQFoWxV/hyHm1XN0A5Cqg2kOD
         IEb4+EJYYZtn63y4weqniwVjDe9HFsgjLyqgfIoaIWIVndDbA8XEW3xoBXQhumuXzBB3
         4ckLzkAqnRU8jx16Yh0QUvxh28NsAvtU8if7nV+aXUE7hTcs+RvSfFmFZt9BXCf/VeY/
         WQArsmX0iHdma6+h0G8W8i32pEVSEaF4u5fj3Alu/2mIhLqqIDpGK+xo7wwS2tNOTZs8
         aYu0F7bBVxzMYxlOIiKE0riz3DWhu6mnHyTAvIJqatpZtB8pZEE6Rpup77PCx+5cTnZp
         uAzA==
X-Gm-Message-State: APjAAAUWIuv/eLew4pzTNgO1YVNIegvOwl3oKm8FKuslaF/a+PiuY9s+
        MfzHWE3zPftG338bbwQgoxw+og==
X-Google-Smtp-Source: APXvYqzWvQySjLF6+FggzOgd22xwvNvT+s3gjz+CDa4+QrDRWfsRdNlyCXLvTk1FytVHcJq6yIy4eg==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr5891327wru.306.1567178343683;
        Fri, 30 Aug 2019 08:19:03 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:dd14:ded7:6a4e:962e? ([2a01:e35:8b63:dc30:dd14:ded7:6a4e:962e])
        by smtp.gmail.com with ESMTPSA id z10sm1202415wrg.12.2019.08.30.08.19.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:19:03 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
Date:   Fri, 30 Aug 2019 17:19:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 29/08/2019 à 19:30, Alexei Starovoitov a écrit :
[snip]
> These are the links that showing that k8 can delegates caps.
> Are you saying that you know of folks who specifically
> delegate cap_sys_admin and cap_net_admin _only_ to a container to run bpf in there?
> 
Yes, we need cap_sys_admin only to load bpf:
tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test

I'm not sure to understand why cap_net_admin is not enough to run the previous
command (ie why load is forbidden).

I want to avoid sys_admin, thus cap_bpf will be ok. But we need to manage the
backward compatibility.

Regards,
Nicolas
