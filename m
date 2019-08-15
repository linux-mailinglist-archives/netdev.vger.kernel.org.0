Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F218E96B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 12:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfHOK7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 06:59:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35274 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfHOK7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 06:59:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id d85so1190735pfd.2;
        Thu, 15 Aug 2019 03:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=auaBGL57UuHgPvSTlDel04wBmZ14+wK6r2arVuPnWOQ=;
        b=kW7bHBgAQnWyFLkWgZz648vc6otDj9rJfJlNfAkrd/nib5/m9xFPZlAPSExKWCJqQ3
         tDpKWHE6eWd+30QlDSh0rAFm0afxieiMSOENtWEll5hluRLuOmA0eOjy/i90q/EWHzCk
         X9ED/j6/a66rin2eOIzl/apCzgtFWCmrnJR2ne21aR9UZ4dLq8pdMrDWkX5jQXEfVicV
         3q7cDOkWR8Vgja1acjlfHiy0sdJNhfAE0JMN7aNUuLdm2MzNWr48B9kI3CocPyNfy4j/
         L6IYGRq33EVhxzuz/lwtvR/W0Kb54UZAmSW2oeWO/xvFis3cXP2wCKnRO2ltFn988/uS
         I5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=auaBGL57UuHgPvSTlDel04wBmZ14+wK6r2arVuPnWOQ=;
        b=cxuP4EhrjChZK6mCYPinsv9MMoJ1zMrf8aEiLhnuhvf6bcChKD7tsf6k5CNfnIkZNk
         fCOKEzVPc2Bps3MKfELKTV5Mw+iQKG2ryQ8mfPPLyNG3I7m7HgylQo8yAUKA2A711ANz
         2SDYQtd+mz/5ZauDxZ08u3u8mqXntqCMc3Vt6Yq44aWm6M2fx4Dfd97sWcvQyAjlehbC
         phgNNKVYNbOKjLfUKHIOGlgKWcLI7tXpwdVybutMx0UoyIczkga7Y/9IQ9JK6hq8Uh4b
         uVLgkshb8qXhRc8epaJ6qALPr/eZWqM7TwEqSDaHEdhdLl2AsUuy7z9n1dTBkLEkpAu1
         IgLw==
X-Gm-Message-State: APjAAAUYt9kek6D6BRBiMgIcM16njEbE3e0FcydbKWKnFo6FU/lSqJ59
        4xYovcRrQUlKaviVljjmuy8=
X-Google-Smtp-Source: APXvYqxVAfgelm4RwmkXEiwO960zxVQIIAg7oYN8rv6TxRwVIdEpFhBbUiRSF6dAoq3GstHYmPwmnA==
X-Received: by 2002:a65:6547:: with SMTP id a7mr2994673pgw.65.1565866757041;
        Thu, 15 Aug 2019 03:59:17 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id y9sm2348745pfn.152.2019.08.15.03.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 03:59:16 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814014445.3dnduyrass5jycr5@ast-mbp>
 <f6160572-8fa8-0199-8d81-6159dd4cd5ff@gmail.com>
Message-ID: <ace27be2-6780-b2d1-dddf-48fbf738b69d@gmail.com>
Date:   Thu, 15 Aug 2019 19:59:11 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f6160572-8fa8-0199-8d81-6159dd4cd5ff@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/14 16:33, Toshiaki Makita wrote:
>>>    bpf, hashtab: Compare keys in long
>>
>> 3Mpps vs 4Mpps just from this patch ?
>> or combined with i40 prefech patch ?
> 
> Combined.
> 
>>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +
>>
>> Could you share "perf report" for just hash tab optimization
>> and for i40 ?
> 
> Sure, I'll get some more data and post them.

Here are perf report and performance numbers.
This time for some reason the performance is better than before.
Something in my env may have changed but could not identify that.

I cut and paste top 10 functions from perf report with drop rate for each case.
perf report is run with --no-child option, so does not include child functions load.
It looks like the hottest function is always xdp_flow BPF program for XDP,
but the shown function name is some meaningless one, like __this_module+0x800000007446.

- No prefetch, no long-compare

   3.3 Mpps

     25.22%  ksoftirqd/4      [kernel.kallsyms]             [k] __this_module+0x800000007446
     21.64%  ksoftirqd/4      [kernel.kallsyms]             [k] __htab_map_lookup_elem
     14.93%  ksoftirqd/4      [kernel.kallsyms]             [k] memcmp
      7.07%  ksoftirqd/4      [kernel.kallsyms]             [k] i40e_clean_rx_irq
      4.57%  ksoftirqd/4      [kernel.kallsyms]             [k] dev_map_enqueue
      3.60%  ksoftirqd/4      [kernel.kallsyms]             [k] lookup_nulls_elem_raw
      3.44%  ksoftirqd/4      [kernel.kallsyms]             [k] page_frag_free
      2.69%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_rcv
      2.29%  ksoftirqd/4      [kernel.kallsyms]             [k] xdp_do_redirect
      1.51%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_xmit

- With prefetch, no long-compare

   3.7 Mpps

     25.02%  ksoftirqd/4      [kernel.kallsyms]             [k] mirred_list_lock+0x800000008052
     21.52%  ksoftirqd/4      [kernel.kallsyms]             [k] __htab_map_lookup_elem
     13.20%  ksoftirqd/4      [kernel.kallsyms]             [k] memcmp
      7.38%  ksoftirqd/4      [kernel.kallsyms]             [k] i40e_clean_rx_irq
      4.09%  ksoftirqd/4      [kernel.kallsyms]             [k] lookup_nulls_elem_raw
      3.57%  ksoftirqd/4      [kernel.kallsyms]             [k] dev_map_enqueue
      3.50%  ksoftirqd/4      [kernel.kallsyms]             [k] page_frag_free
      2.86%  ksoftirqd/4      [kernel.kallsyms]             [k] xdp_do_redirect
      2.84%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_rcv
      1.79%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_xmit

- No prefetch, with long-compare

   4.2 Mpps

     24.64%  ksoftirqd/4      [kernel.kallsyms]             [k] __this_module+0x800000008f47
     24.42%  ksoftirqd/4      [kernel.kallsyms]             [k] __htab_map_lookup_elem
      6.91%  ksoftirqd/4      [kernel.kallsyms]             [k] i40e_clean_rx_irq
      4.04%  ksoftirqd/4      [kernel.kallsyms]             [k] page_frag_free
      3.53%  ksoftirqd/4      [kernel.kallsyms]             [k] lookup_nulls_elem_raw
      3.14%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_rcv
      3.13%  ksoftirqd/4      [kernel.kallsyms]             [k] dev_map_enqueue
      2.34%  ksoftirqd/4      [kernel.kallsyms]             [k] xdp_do_redirect
      1.76%  ksoftirqd/4      [kernel.kallsyms]             [k] key_equal
      1.37%  ksoftirqd/4      [kernel.kallsyms]             [k] zero_key+0x800000010e93

   NOTE: key_equal is called in place of memcmp.

- With prefetch, with long-compare

   4.6 Mpps

     26.68%  ksoftirqd/4      [kernel.kallsyms]             [k] mirred_list_lock+0x80000000a109
     22.37%  ksoftirqd/4      [kernel.kallsyms]             [k] __htab_map_lookup_elem
     10.79%  ksoftirqd/4      [kernel.kallsyms]             [k] i40e_clean_rx_irq
      4.74%  ksoftirqd/4      [kernel.kallsyms]             [k] page_frag_free
      4.09%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_rcv
      3.97%  ksoftirqd/4      [kernel.kallsyms]             [k] dev_map_enqueue
      3.79%  ksoftirqd/4      [kernel.kallsyms]             [k] lookup_nulls_elem_raw
      3.09%  ksoftirqd/4      [kernel.kallsyms]             [k] xdp_do_redirect
      2.45%  ksoftirqd/4      [kernel.kallsyms]             [k] key_equal
      1.91%  ksoftirqd/4      [kernel.kallsyms]             [k] veth_xdp_xmit

Toshiaki Makita
