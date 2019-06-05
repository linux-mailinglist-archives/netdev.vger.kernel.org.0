Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608FF3636A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFESgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:36:46 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41052 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFESgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:36:46 -0400
Received: by mail-pl1-f193.google.com with SMTP id s24so9864317plr.8
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 11:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tO89OC4zfG1h8Qv+Eq1/q+33py6kblvzUsRwisLuHJ8=;
        b=iD7yTboE4/t1lL7KAe1MxaXgWn4n/ez8phzL6h5JOOOrcXikZnWpcpWcdJu6f+vuKa
         k09gjwDea55O2vkrXzmirAEJhcQTF/RfseizjlEvfypLXqiCsPEPOGyz7/mB4TCVwuNH
         NjY5vlddXapLe4HN0ne57o1YhYRXGOBxxXs9jwN6N/G91aC00GLhl7jjBpGrV+KkOXJ9
         X/33UaldolQo6NmLt7fIJY0X9WVvdHuI9u2kWwv8ZcZ5bcp+fl5RYcNXM3anFq6Qd5TK
         hYtU/0p6+4bYFw6+LJZux9oQ5cOi+azJjTNudc2veuUqyHlSSiR2VSy5HQlhsrfWrs1r
         0mLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tO89OC4zfG1h8Qv+Eq1/q+33py6kblvzUsRwisLuHJ8=;
        b=R+E4cLQlt/4XoN3v+Vd4u3PA34PkTanQfwMrvhoYRuhIvsR9RE5OF5GnG+ohxRXIuT
         GhnZ/k0mV0wvcoM/p24NMayKy+eWLY4lxHYWDaRMVXx6C+Yy80vAmwl/yS7fhNZW9Rcl
         h9y0IlI5Tczc490KyNx2WOeqAqvnduhE1OCAKrNmYyqs8d7T/fAFw5l7aF/mSjZlKUgR
         7QU6uaue9swI3ZNkbXHvfXauxY+yjEogP/2pE7nXmul9mOyL1kcaaW5CEzBNgcrhaCz8
         xbJ2kZy/tjkyKd2BErlcEk9gV5i3S6cQA1k9gik4kaXaSkoAve52IDI8mlYGf0qs528+
         calQ==
X-Gm-Message-State: APjAAAV+koYnwsXkO0WSIlTdSRI6dg0PlmcqcaMYmRC6olcJgU1Mjix+
        yRBm/BrmGNZwVaAyZka+nkbEGN8xD0U=
X-Google-Smtp-Source: APXvYqxuOfLfrcRFJthDYZ7JWzsESjzEpg94FRH5sFxQbDeS0iuMRfOlGUowjni/ZWfBjIuPhH8q6g==
X-Received: by 2002:a17:902:7297:: with SMTP id d23mr31869593pll.254.1559759805511;
        Wed, 05 Jun 2019 11:36:45 -0700 (PDT)
Received: from [172.20.85.241] ([2620:10d:c090:180::1:a25e])
        by smtp.gmail.com with ESMTPSA id i12sm22836904pfd.33.2019.06.05.11.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 11:36:44 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Kernel Team" <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>
Subject: Re: [PATCH 1/1] bpf: Allow bpf_map_lookup_elem() on an xskmap
Date:   Wed, 05 Jun 2019 11:36:43 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <3CF29D29-971B-41CC-8CA9-42EBFC054A4B@gmail.com>
In-Reply-To: <CAJ+HfNizsTgxTvtyUezQkqAuoWr7txYNCuDTeWgy4UTR2hbr8g@mail.gmail.com>
References: <20190605155756.3779466-1-jonathan.lemon@gmail.com>
 <20190605155756.3779466-2-jonathan.lemon@gmail.com>
 <CAJ+HfNizsTgxTvtyUezQkqAuoWr7txYNCuDTeWgy4UTR2hbr8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5 Jun 2019, at 10:16, Björn Töpel wrote:

> On Wed, 5 Jun 2019 at 17:58, Jonathan Lemon <jonathan.lemon@gmail.com> 
> wrote:
>>
>> Currently, the AF_XDP code uses a separate map in order to
>> determine if an xsk is bound to a queue.  Instead of doing this,
>> have bpf_map_lookup_elem() return a xdp_sock.
>>
>> Rearrange some xdp_sock members to eliminate structure holes.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 55bfc941d17a..f2d9d77b4b57 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -5680,6 +5680,46 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff 
>> *, skb)
>>         return INET_ECN_set_ce(skb);
>>  }
>>
>> +bool bpf_xdp_sock_is_valid_access(int off, int size, enum 
>> bpf_access_type type,
>> +                                 struct bpf_insn_access_aux *info)
>> +{
>> +       if (off < 0 || off >= offsetofend(struct bpf_xdp_sock, 
>> queue_id))
>> +               return false;
>> +
>> +       if (off % size != 0)
>> +               return false;
>> +
>> +       switch (off) {
>> +       default:
>> +               return size == sizeof(__u32);
>> +       }
>
> Hmm? Missing case or remove?

It looks odd because the default is for 32 bit accesses, and
separate case statements are added for overrides (64 bit, etc).
The style matches the rest of the file.

It compiles down to a single comparison, so no additional overhead.
-- 
Jonathan
