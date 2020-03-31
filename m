Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01386198BE2
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 07:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCaFpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 01:45:33 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50809 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgCaFpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 01:45:33 -0400
Received: by mail-pj1-f65.google.com with SMTP id v13so616056pjb.0;
        Mon, 30 Mar 2020 22:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oL8fdk5mmpy0zmnky2aGWkiNBKFYGLoSDb7pzpaDNLo=;
        b=ODsZ4sF438MvrtLkHMrrZgBbY43hri6jMW/Sdhh9vmrxK+6Pg2qTC8+ZQxpdjjmWJk
         Fbp79/MAAJvo8TMXZaprKXWvUuDslgw4oNDC0pUVt7P5PBvVd9QPunjtzoThaj/O0Hhp
         fU2onB+CbGECL4WJ7NPn8Wkmmo2v8wbnt+BIYlG3YMK235kU6Tn741s0jCckLEUhoKRb
         mLnIBMjAjoIo2PYL/7t7sxeQhGU5kMb8/Nq2aXNrKXdAUfSayT3X5GccNWG7RMBDrM/n
         LIir+CwLhewCdyq5zJZ8RGkF5MP5vcm1d2FMoq5AThqHGVCjFLpUn7s6rM1OhL/ZlyEu
         jY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oL8fdk5mmpy0zmnky2aGWkiNBKFYGLoSDb7pzpaDNLo=;
        b=Vi97JUWb0U6lekvPph5PsM7PbU4sTXXhnZWUP7OluqvUxseoYo/5WxVkfPaEpe/Mec
         +fpwCdPYGriPx3QM8ZuXSxqJJcM1Ddxq72q17iFDbblL2dLFZ5i8oo5sJLitwOjPNkjd
         JA9TOW0V75If/vs47F5Og0LB3vlYV2g4q8jezqCYw001M6es87iz3qywWrWTQ5Tjai1X
         Pmd5+copYMcFhacZTs+pFG9F2t43brbetXOnHNuMpYfkIN6H6qL02IuJ0wN0UiAaHxrS
         iXyErVlopzA3sNebPuAsolk0zBVTeDUSQpJGsjxp6/h4LNHWLGqA/CQGhxCraBPIXpa+
         Fp0g==
X-Gm-Message-State: AGi0Pua1Y7/tRWP1msr3ux7Af3W/oKz/GGKNhTBEBcy7zBL9x7dYAWA8
        1RS4xnxLIGAaZdmG1OFzXK9Kh4UW
X-Google-Smtp-Source: APiQypLLeEdSNbs4zQs0IqSLAtMS4fvatpo1+pwvHzXfxKmH0M08lHhvQxuld+WQiQZFjAs/J1EjIA==
X-Received: by 2002:a17:90a:a111:: with SMTP id s17mr1974434pjp.129.1585633532000;
        Mon, 30 Mar 2020 22:45:32 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id i14sm10912717pgh.47.2020.03.30.22.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 22:45:31 -0700 (PDT)
Subject: Re: [PATCH net] veth: xdp: use head instead of hard_start
To:     maowenan <maowenan@huawei.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        jwi@linux.ibm.com, jianglidong3@jd.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200330102631.31286-1-maowenan@huawei.com>
 <20200330133442.132bde0c@carbon>
 <3053de4c-cee6-f6fc-efc2-09c6250f3ef2@gmail.com>
 <e7cf1271-2953-a5aa-ab25-c4b4a3843ee1@huawei.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
Date:   Tue, 31 Mar 2020 14:45:26 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e7cf1271-2953-a5aa-ab25-c4b4a3843ee1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/31 12:56, maowenan wrote:
> On 2020/3/31 7:35, Toshiaki Makita wrote:
>> Hi Mao & Jesper
>> (Resending with plain text...)
>>
>> On 2020/03/30 20:34, Jesper Dangaard Brouer wrote:
>>> On Mon, 30 Mar 2020 18:26:31 +0800
>>> Mao Wenan <maowenan@huawei.com> wrote:
>>>
>>>> xdp.data_hard_start is mapped to the first
>>>> address of xdp_frame, but the pointer hard_start
>>>> is the offset(sizeof(struct xdp_frame)) of xdp_frame,
>>>> it should use head instead of hard_start to
>>>> set xdp.data_hard_start. Otherwise, if BPF program
>>>> calls helper_function such as bpf_xdp_adjust_head, it
>>>> will be confused for xdp_frame_end.
>>>
>>> I have noticed this[1] and have a patch in my current patchset for
>>> fixing this.  IMHO is is not so important fix right now, as the effect
>>> is that you currently only lose 32 bytes of headroom.
>>>
> I consider that it is needed because bpf_xdp_adjust_head() just a common helper function,
> veth as one driver application should keep the same as 32 bytes of headroom as other driver.
> And convert_to_xdp_frame set() also store info in top of packet, and set:
> 	xdp_frame = xdp->data_hard_start;
> 
>>> [1] https://lore.kernel.org/netdev/158446621887.702578.17234304084556809684.stgit@firesoul/
>>
>> You are right, the subtraction is not necessary here.
> I guess you mean that previous subtraction is not necessary ? this line : void *head = hard_start - sizeof(struct xdp_frame); ?

No I just mean subtraction of headroom is not necessary, and I noticed this 
description was confusing. Sorry about that.
You can use "head" for data_hard_start.

Toshiaki Makita
