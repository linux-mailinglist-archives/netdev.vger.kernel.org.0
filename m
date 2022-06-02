Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C318253B21C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 05:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiFBD2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 23:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiFBD17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 23:27:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183CE5DBCD
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 20:27:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so4984461pjm.2
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 20:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=sZ8GzRUQBIRnVHILPlLfnQyD91gR78EWniMrsU1AmRw=;
        b=nHuGvwI9o58j8lsqts87M+3kByKxsrc6rcVXPBo7v2yqnvCQuP72TbGLvtDo8h2mFj
         8Xnpn2KWkwl1P+DnsYYpQTXW5BVC3B519Qv82bF5qq0UAX2M/jULgWfJbRC5MuMfMndm
         cOND4RdcH1iH4+nwv5uyffzq51YTrhYJmoffPJYJF07Sq9zts008GlGbpDVWuMv1eEZ7
         wzuTBOfdo6T3yf4aOYR3Ux6hh7ntQKdi7w+mZbiHD2I885cviqJsPzeP/vO8A7JvXoPt
         hs19TKJ7omx4l47CplvvvddULcSUuUq4ZyUWL5ZNBjTRG92UMMPx+RC97qZ4Pne1KtDP
         mIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sZ8GzRUQBIRnVHILPlLfnQyD91gR78EWniMrsU1AmRw=;
        b=APIwMnK3T0RCPfeMB6w17IPlV+zDfnJWg0/amTCQKpAs3uF9L8aXgKtoQ9hi6fgQ14
         n9W1/6SUtJmZR7lFTnsov+MnNqSnQrPmZAj3lKlI2RE/BxtTnpTgkEUhZ96lIBWkebZe
         r6inPhUxP6o3rtwYSpVygV5nTFVi3f5DkMeFzlR9DuO58kPNwPfXqRLkhmmeLCWUNhmU
         ABbdfBN1U2ipiKNAFVkWkpHt5EUVPCkyT6bBP2MYXflZTTEpSm1R9QF9IAErmNU4qZFO
         66IhaEGJW/LG93u95TwkBO37J6RWw+PlRf1Ss7SrT+8oH3qG/ivMmHUiVSrJAnsWqfTH
         89hg==
X-Gm-Message-State: AOAM532JvZLyKqZgJ2U4NknOpP4EF3psEbeUIYJ1bqMJwUIasrqbyvqi
        IQ1vXKQ6jaXcpkr5huGgWF2UNQ==
X-Google-Smtp-Source: ABdhPJzbui9XgIru9OSL8mR+ctNjeib5PVobaIezJORsGKxZXTGoi8iyoBq7eJRaZvW/YntSXpqDVA==
X-Received: by 2002:a17:902:a605:b0:163:8e47:8929 with SMTP id u5-20020a170902a60500b001638e478929mr2701820plq.69.1654140477634;
        Wed, 01 Jun 2022 20:27:57 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902c70200b001617541c94fsm2269689plp.60.2022.06.01.20.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 20:27:57 -0700 (PDT)
Message-ID: <6aedba89-51f4-c889-d3cc-5f513defb920@bytedance.com>
Date:   Thu, 2 Jun 2022 11:27:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Re: [PATCH v4 1/2] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-2-zhoufeng.zf@bytedance.com>
 <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
 <21ec90e3-2e89-09c1-fd22-de76e6794d68@bytedance.com>
 <CAADnVQKdU-3uBE9tKifChUunmr=c=32M4GwP8qG1-S=Atf7fvw@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQKdU-3uBE9tKifChUunmr=c=32M4GwP8qG1-S=Atf7fvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/6/1 下午7:35, Alexei Starovoitov 写道:
> On Wed, Jun 1, 2022 at 1:11 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/6/1 下午5:50, Alexei Starovoitov 写道:
>>> On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>>    static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
>>>> @@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
>>>>           orig_cpu = cpu = raw_smp_processor_id();
>>>>           while (1) {
>>>>                   head = per_cpu_ptr(s->freelist, cpu);
>>>> +               if (READ_ONCE(head->is_empty))
>>>> +                       goto next_cpu;
>>>>                   raw_spin_lock(&head->lock);
>>>>                   node = head->first;
>>>>                   if (node) {
>>> extra bool is unnecessary.
>>> just READ_ONCE(head->first)
>> As for why to add is_empty instead of directly judging head->first, my
>> understanding is this, head->first is frequently modified during updating
>> map, which will lead to invalid other cpus's cache, and is_empty is after
>> freelist having no free elems will be changed, the performance will be
>> better.
> maybe. pls benchmark it.
> imo wasting a bool for the corner case is not a good trade off.

Yes, I will do and post the results as soon as possible, Thanks.


