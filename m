Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988C335FE6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfFEPJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:09:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:47075 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbfFEPJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:09:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so8053747pls.13
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jIHJSbXsT9mMaQRHMFiZLTirKsEkNa2IxOc/BaBDrjQ=;
        b=OmEKBuRHH3JwRGmFDqSRCIRvJf1W0+7M/i/GDHJrsR08btBfFFrwJmFuTd0FY0d1Tc
         J5d3YcY4yosSh9Fb9r1/4KaFkBubbvpmZucrFzcP++h5eV/wCTVr5vXZ7NK6kQZZhrg6
         QMfSUQRPZTpdWLhVw71C3I8eG8yKhR0ShFMZBSuUnKfpKNLO8gR2bwd0woTkBmYBmw1L
         1c5WCqYmN0/c2+7KxD2971/gjSQPUK7sT9T4+G7Tk4ip5WhVTrn5ggRkxsa7ajZQyeTz
         xQZLqpnXFQdFmuNpyj6utRJ9JRtfIb+Vash8WmhztamBGEYR0v8/PQusrOyQgj50vmS3
         Igwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jIHJSbXsT9mMaQRHMFiZLTirKsEkNa2IxOc/BaBDrjQ=;
        b=awYZDfqHvFKGV7x6g3jaHZny1EH8CDsPLrJbsju1+jtxlXQ4IOr7Cto78mEtILsFsl
         knnm/BBtTUyNwdhIF8l7fXVt47XetNaD5i5yIFfc9It1MbI7EBbQGnAD+VTGHn2vGwP3
         GFIfvdkQDbGitYWIeewl5N91v+Y61Aroxt1p69bhSPJ11q/GKWj6Hg96ox33Qk2YPPBv
         qEvSOoCQVmuvhSgjNf5k5bUJX37g1W7AGMIedh8WLP9L7hHH9Hl193PbwUz8uCfE4FJX
         kCb7oZhsjT8eHGAeC3JIHdq3MY1DzJZx3RXHgNE7iw12xFSLoDOiZnxacRgDe4GTDdAs
         etZg==
X-Gm-Message-State: APjAAAWQ53EZKcPcOCgjR8fYyqraYyGy4+JzWv3QjsFPulP6PS0t1blF
        mNSFHpMw77gyy7DCc9REQGw=
X-Google-Smtp-Source: APXvYqw+KH2gaw49Srq7YEpSzcuyAxXQ68YxPlaunS4TFeU3UoGKHdDik9nAMNqm7J/PIJbv7tft5A==
X-Received: by 2002:a17:902:b58f:: with SMTP id a15mr43921327pls.201.1559747393301;
        Wed, 05 Jun 2019 08:09:53 -0700 (PDT)
Received: from [172.20.85.241] ([2620:10d:c090:180::1:bf6])
        by smtp.gmail.com with ESMTPSA id t15sm20823506pjb.6.2019.06.05.08.09.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 08:09:52 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>
Subject: Re: [PATCH net-next 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
Date:   Wed, 05 Jun 2019 08:09:50 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <30778336-BD88-4959-95CC-79443152EC7F@gmail.com>
In-Reply-To: <20190605123941.5b1d36ab@carbon>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
 <155966185069.9084.1926498690478259792.stgit@alrua-x1>
 <20190605123941.5b1d36ab@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5 Jun 2019, at 3:39, Jesper Dangaard Brouer wrote:

> On Tue, 04 Jun 2019 17:24:10 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> indication of whether it can successfully redirect to the map index 
>> it was
>> given. Instead, BPF programs have to track this themselves, leading 
>> to
>> programs using duplicate maps to track which entries are populated in 
>> the
>> devmap.
>>
>> This adds a flag to the XDP version of the bpf_redirect_map() helper, 
>> which
>> makes the helper do a lookup in the map when called, and return 
>> XDP_PASS if
>> there is no value at the provided index. This enables two use cases:
>
> To Jonathan Lemon, notice this approach of adding a flag to the helper
> call, it actually also works for your use-case of XSK AF_XDP maps.c

Hmm, yes, that should work also.

I have a patch which returns a XDP_SOCK type from the xskmap.
This could be used with a new helper for redirection directly to a 
socket
(instead of looking the socket up a second time).

While flexible, the downside is that this won't apply to devmaps.
-- 
Jonathan
