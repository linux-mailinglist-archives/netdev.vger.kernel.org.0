Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0901C64B37B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiLMKqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiLMKp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:45:59 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8F71DF2F
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:45:56 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bp15so4185658lfb.13
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=clYGaKcoU1jAtJzCPRMHpCnuOhFFsRzkylcAv0cGAQE=;
        b=Hyk/u7lNvntXj4YIGVjbGxpVo9+4AEIvN3ReGe9BH2iYejVs3rC2OizZdfjAlTQn+S
         ukATwwPMluPzI663m3aWrIwQT3qUVosmYFPsNLk0yT223w4exTlCIFE2i1Y0BHPuLbtU
         OcmNRxh7RMY2lfsMpQ9B0avJUGtiVsRi2Us0L+3pPgrmMtb+rdPXHDOh+WvLjga46XVA
         BtM43NH+elaBWtH7Sc3IYLS25CzGEvgKjhdiRciSJU6VCo6UEzkcqPUn+LWFX5TUYVIc
         tmvSv2RdaW2NHhh8UetN18EW9IMa332t/JkZ7axiKobyJrq9UYoIsIU1AJ8LNamNOYJt
         NFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clYGaKcoU1jAtJzCPRMHpCnuOhFFsRzkylcAv0cGAQE=;
        b=fD8SiONlMloWYSfhA5BB0EuzexgLi+r+c2HV4ZveUJxU4RRclLSTBBZey5A9rtkJBj
         jNu12fgu2+sthlqfY1a2rtZBQ6dgdAZ+tAwj4fPijLOrm9BkH8CVAHkf73D/2AhZt+et
         7ynBdGbBT+0N3WDPsyeS5Ot099Cgnlv/txclN4kNNeGzW52meSNzO14yMHwP0zaIly2F
         bk/jdeTFLfLIwQ7GmBdFhDnS6Gi8ejSvxED0l+0AU3yt0MA2xoucNRfwmrrp6GD6iG8d
         tIe9RxNMLt28RSHbW/tAC3zb1UCgU7r1HAk7t+C5kFLzapUbytYV4ArHQKX6F9Jp0Um0
         bJKw==
X-Gm-Message-State: ANoB5pl8NbbeYnulHkV8qqJOJ5jR+PLVEBNS1+184FIXcsNlMpG09/L+
        W8HNOX+LPQq3y1bhtG9K3vr01g==
X-Google-Smtp-Source: AA0mqf4605JHK3TJe5r0QN+uxg1GshTxw+NaQOqxcrI5SbSY7WEwRp7wBXbabCXMYMwvOU7BDTKBhg==
X-Received: by 2002:a05:6512:b10:b0:4a6:c596:6ff7 with SMTP id w16-20020a0565120b1000b004a6c5966ff7mr6344158lfu.2.1670928355051;
        Tue, 13 Dec 2022 02:45:55 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id o4-20020ac25e24000000b004946a1e045fsm309778lfg.197.2022.12.13.02.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 02:45:54 -0800 (PST)
Message-ID: <15aba5c2-1f22-cb8a-742e-8bb8b1e8f0a0@linaro.org>
Date:   Tue, 13 Dec 2022 11:45:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net] nfc: pn533: Clear nfc_target in
 pn533_poll_dep_complete() before being used
Content-Language: en-US
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr
References: <20221213014120.969-1-linuxlovemin@yonsei.ac.kr>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213014120.969-1-linuxlovemin@yonsei.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2022 02:41, Minsuk Kang wrote:
> This patch fixes a slab-out-of-bounds read in pn533 that occurs in

Do not use "This commit/patch".
https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

> nla_put() called from nfc_genl_send_target() when target->sensb_res_len,
> which is duplicated from nfc_target in pn533_poll_dep_complete(), is
> too large as the nfc_target is not properly initialized and retains
> garbage values. The patch clears the nfc_target before it is used.

Same here

> 
> Found by a modified version of syzkaller.
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in nla_put+0xe0/0x120
> Read of size 94 at addr ffff888109d1dfa0 by task syz-executor/4367
> 
> CPU: 0 PID: 4367 Comm: syz-executor Not tainted 5.14.0+ #171
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  dump_stack_lvl+0x8e/0xd1
>  print_address_description.constprop.0.cold+0x93/0x334
>  kasan_report.cold+0x83/0xdf
>  kasan_check_range+0x14e/0x1b0
>  memcpy+0x20/0x60
>  nla_put+0xe0/0x120
>  nfc_genl_dump_targets+0x74f/0xb20
>  genl_lock_dumpit+0x65/0x90
>  netlink_dump+0x4b0/0xa40
>  __netlink_dump_start+0x5dc/0x8c0
>  genl_family_rcv_msg_dumpit.isra.0+0x2a1/0x300
>  genl_rcv_msg+0x3c8/0x4f0
>  netlink_rcv_skb+0x130/0x3b0
>  genl_rcv+0x29/0x40
>  netlink_unicast+0x4a1/0x6a0
>  netlink_sendmsg+0x788/0xc90
>  sock_sendmsg+0xca/0x110
>  ____sys_sendmsg+0x63f/0x780
>  ___sys_sendmsg+0xfb/0x170
>  __sys_sendmsg+0xd8/0x190
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46b55d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f167a757c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000686b60 RCX: 000000000046b55d
> RDX: 0000000000000000 RSI: 000000004004fb80 RDI: 0000000000000009
> RBP: 00000000004d9ba0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000686b60
> R13: 0000000000686b68 R14: 00007ffd2f2facc0 R15: 00007f167a757dc0
> 
> Allocated by task 0:
> (stack is not available)
> 
> The buggy address belongs to the object at ffff888109d1df80
>  which belongs to the cache kmalloc-96 of size 96
> The buggy address is located 32 bytes inside of
>  96-byte region [ffff888109d1df80, ffff888109d1dfe0)
> The buggy address belongs to the page:
> page:ffffea0004274740 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109d1d
> flags: 0x200000000000200(slab|node=0|zone=2)
> raw: 0200000000000200 0000000000000000 dead000000000122 ffff888100041780
> raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 4366, ts 19572546791, free_ts 19568585127
>  prep_new_page+0x1aa/0x240
>  get_page_from_freelist+0x159a/0x27c0
>  __alloc_pages+0x2da/0x6a0
>  alloc_pages+0xec/0x1e0
>  allocate_slab+0x380/0x4e0
>  ___slab_alloc+0x5bc/0x940
>  __slab_alloc+0x6d/0x80
>  __kmalloc+0x329/0x390
>  tomoyo_supervisor+0xb7f/0xd10
>  tomoyo_path_permission+0x26a/0x3a0
>  tomoyo_check_open_permission+0x2b0/0x310
>  tomoyo_file_open+0x99/0xc0
>  security_file_open+0x57/0x470
>  do_dentry_open+0x318/0xfe0
>  path_openat+0x1852/0x2310
>  do_filp_open+0x1c6/0x290
> page last free stack trace:
>  free_pcp_prepare+0x3d3/0x7f0
>  free_unref_page+0x1e/0x3d0
>  unfreeze_partials.isra.0+0x211/0x2f0
>  put_cpu_partial+0x66/0x160
>  qlist_free_all+0x5a/0xc0
>  kasan_quarantine_reduce+0x13d/0x180
>  __kasan_slab_alloc+0x73/0x80
>  slab_post_alloc_hook+0x4d/0x490
>  __kmalloc+0x180/0x390
>  tomoyo_supervisor+0xb7f/0xd10
>  tomoyo_path_permission+0x26a/0x3a0
>  tomoyo_path_perm+0x2c1/0x3c0
>  security_inode_getattr+0xc2/0x130
>  vfs_getattr+0x27/0x60
>  vfs_fstat+0x3e/0x80
>  __do_sys_newfstat+0x7d/0xf0
> 
> Memory state around the buggy address:
>  ffff888109d1de80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>  ffff888109d1df00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>> ffff888109d1df80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>                                                        ^
>  ffff888109d1e000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888109d1e080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Drop unrelated pieces of OOPS and keep only things which are relevant.

> ==================================================================
> 
> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
> Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
> Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

Reported-by is for crediting other people, not crediting yourself.
Otherwise all my patches would be reported-by, right? Please drop this
one and keep only credit for other people who actually reported it. It's
anyway weird to see three people reporting one bug.

Additionally I really dislike private reports because they sometimes
cannot be trusted (see all the fake report credits from running
coccinelle by Hulk Robot and others)... Care to provide link to the
reports of this bug?

> Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> ---
>  drivers/nfc/pn533/pn533.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> index d9f6367b9993..c6a611622668 100644
> --- a/drivers/nfc/pn533/pn533.c
> +++ b/drivers/nfc/pn533/pn533.c
> @@ -1295,6 +1295,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
>  	if (IS_ERR(resp))
>  		return PTR_ERR(resp);
> 
> +	memset(&nfc_target, 0, sizeof(struct nfc_target));

There is one more place to fix in pn533_in_dep_link_up_complete()

> +
>  	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
> 
>  	rc = rsp->status & PN533_CMD_RET_MASK;
> --
> 2.25.1
> 

Best regards,
Krzysztof

