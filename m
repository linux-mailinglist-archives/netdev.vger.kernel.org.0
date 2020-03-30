Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579B419885B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgC3Xft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:35:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33979 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbgC3Xft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 19:35:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id l14so2322941pgb.1;
        Mon, 30 Mar 2020 16:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ihsd+LIKK09BkgBU5lK2nHCqw9TRvnbaMLRrOxk0h2k=;
        b=p87pYBLC3MmWCxVZxPixFPk6zecH/3RVA/V+yOI0oeJczOLk1ARxjJOILz3yRWLgh9
         dpo1UMPXP/oOHEay3q8cjdIUnznd/37ul1yDXPofgGVctfE8neuhZsP+WzjN+aCDj9iS
         OOVobG4/HmQYZ3jG3i5O2CY7/cD7iiCetln5QPTQzyZNe6LCaSzMOGp8oNBwoOJZmZUi
         1mk4RYiUQmiklpe5P+EkU8LTxHdr3j9OES2HMhberyOXNwUdxAD09N+2uIXtlAuopr+a
         6rXTfjJ5hdjpi+0PTRpBFFl3mlzNJdwLw97inGC1pSO6SmPHu9yfL7IyaaPp/OebOubK
         whxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ihsd+LIKK09BkgBU5lK2nHCqw9TRvnbaMLRrOxk0h2k=;
        b=Av06UhtnAYjYYBnrdqKiUk/3VzsD9LCzAsEjr7cVLnPEaBJ+J2CEFOFHpc/WCIR6DR
         phOSLtsLG0z+1lVg4tnUAMbD0gf/U1/hEgK5R0G6pUo9w5izOkdVCT0mqeyZcJ7EnF8B
         Wx6yebGY0ymV8Cp5tsMyfdJUU1Cp3+STgMt65KZ3idLNuQbyGzQBC9YjbuIlJOS5WCGg
         4PAc0puzhFsp3Pg4l+dSx+K9BN1DB1i21cOIIOuZtnheFJEPVAX//o+P0J9rM88A6Ibj
         RzPtpwME/C555NcYLW2V/hHjmqe5xQPNkaJFPM58Oogep9QNfWQo1s9UuNILsf4r23iL
         Sh8A==
X-Gm-Message-State: ANhLgQ3vHlN1xIpbK/DBcEz+KaBp/RioVsp3mPzgsro636/qSjWxTNHo
        Y6J0HEVX0OuZX2A1sW+9UPfdrKqG
X-Google-Smtp-Source: ADFU+vu3oMl5981LfcveEQsB0jz8wUh2Fvws/6FzXOCgNF7QgTXM4QbqbUJrfuD3cK8bW+/d58RzFw==
X-Received: by 2002:a63:1003:: with SMTP id f3mr15181161pgl.450.1585611345613;
        Mon, 30 Mar 2020 16:35:45 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id gi2sm521816pjb.30.2020.03.30.16.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 16:35:44 -0700 (PDT)
Subject: Re: [PATCH net] veth: xdp: use head instead of hard_start
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Mao Wenan <maowenan@huawei.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        jwi@linux.ibm.com, jianglidong3@jd.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200330102631.31286-1-maowenan@huawei.com>
 <20200330133442.132bde0c@carbon>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <3053de4c-cee6-f6fc-efc2-09c6250f3ef2@gmail.com>
Date:   Tue, 31 Mar 2020 08:35:39 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330133442.132bde0c@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mao & Jesper
(Resending with plain text...)

On 2020/03/30 20:34, Jesper Dangaard Brouer wrote:
> On Mon, 30 Mar 2020 18:26:31 +0800
> Mao Wenan <maowenan@huawei.com> wrote:
> 
>> xdp.data_hard_start is mapped to the first
>> address of xdp_frame, but the pointer hard_start
>> is the offset(sizeof(struct xdp_frame)) of xdp_frame,
>> it should use head instead of hard_start to
>> set xdp.data_hard_start. Otherwise, if BPF program
>> calls helper_function such as bpf_xdp_adjust_head, it
>> will be confused for xdp_frame_end.
> 
> I have noticed this[1] and have a patch in my current patchset for
> fixing this.  IMHO is is not so important fix right now, as the effect
> is that you currently only lose 32 bytes of headroom.
> 
> [1] https://lore.kernel.org/netdev/158446621887.702578.17234304084556809684.stgit@firesoul/

You are right, the subtraction is not necessary here.
Thank you for working on this.

Toshiaki Makita
