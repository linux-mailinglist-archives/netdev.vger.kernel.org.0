Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E755FE724
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 04:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJNCqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 22:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJNCqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 22:46:49 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C683959246;
        Thu, 13 Oct 2022 19:46:48 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y5so5262299lfl.4;
        Thu, 13 Oct 2022 19:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RfdSljC+ZlRlSIbb2xqe38Q0hGyQBSXvKtVP1N3+V3A=;
        b=hX7My3Zq0LMDD7fpO48654Y0A1CUNRg/mUOXwVan06UG7TevWJGrzqrVrFWLjAjOH2
         ng2MDwpz+lXPsj5mWm4uBiWPZrq91il/88MqcL9Uvr75bYXYyif7vEO0Uxbfcs99boRE
         MdeauT0ONmcCkFYNc9gNZWMP9kAW0kK7ujPzu0S1tMlf0/2EbN4hvfRDAhq0B4UO9eJg
         8WpKZ3jielXELGzVO+SqbsWH3gF9tEhdt9jpP5jyqxi6z+AcuGyHqsG8xFADkbn0NP/q
         FxPdJ/G/ZbMcNiQ6i4A3cS09i97TZXEhltNo5y2Ji1QH2YsHcnEWtzth6eOOEJr9YxJu
         zqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfdSljC+ZlRlSIbb2xqe38Q0hGyQBSXvKtVP1N3+V3A=;
        b=SBlD5IfharDo2pJIu1kMUnrM/H7pEF1WWUU5W8oSmRwLmc1USJSB6aCKN/+/cQUyeq
         U3R14WYauRoQ8+yVs4LtDT/5uFtG5Mvy8bl8wJag5rEKhZ8NA0BVc9EQzyujsdog8hUV
         U3MnMHQMJWACrQ/uRcALuV5/ljyDAX9xAT1Md8NxvpB6qj0/mQukUNhF/AplkCWPsBU1
         MNZnLsZ46QGtE+UV0WkddEaUUK+wgVp1HuyRN9PN4m7fQt8STIniKrb3Sx/OIn/D612T
         vPABdLlLqTx49/ncx2ZP6BgmVfpc7GwMYGhdBt5tNkwuDG5BuGWLaxjD48/kNVQC0QOf
         WvLw==
X-Gm-Message-State: ACrzQf1L7IFnjqWyaLn1jDZjst/atx/+LuA82gaYAhmsgE8M3rMVZnVq
        P+oa5SrMkeqPKJSrJXGznVkujo+JhsVWkItJHRoJEA2o84JfeQ==
X-Google-Smtp-Source: AMsMyM6TnFIBjZTsH5c3zmqTsShEQXJpg0+ZWNpYtJTesJz4nMZonGD095ufd/c1oEwHkeaFqICLW6NZc104Sz5bqn4=
X-Received: by 2002:a05:6512:1694:b0:48a:9d45:763f with SMTP id
 bu20-20020a056512169400b0048a9d45763fmr860438lfb.662.1665715607061; Thu, 13
 Oct 2022 19:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221012013922.32374-1-cbulinaru@gmail.com> <e71426117517a62f4e940318b1c048f15d8fe5b7.camel@redhat.com>
In-Reply-To: <e71426117517a62f4e940318b1c048f15d8fe5b7.camel@redhat.com>
From:   Cezar Bulinaru <cbulinaru@gmail.com>
Date:   Thu, 13 Oct 2022 22:46:34 -0400
Message-ID: <CAG0ZtY6iJVS94ruMMuqxuORnV+eKE7SvPioE613UFT+FPScHXQ@mail.gmail.com>
Subject: Re: [PATCH v2] hv_netvsc: Fix a warning triggered by memcpy in rndis_filter
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks , I have  sent [PATCH v3] net: hv_netvsc: Fix a warning
triggered by memcpy in rndis_filter


On Thu, 13 Oct 2022 at 04:56, Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Tue, 2022-10-11 at 21:39 -0400, Cezar Bulinaru wrote:
> > A warning is triggered when the response message len exceeds
> > the size of rndis_message. Inside the rndis_request structure
> > these fields are however followed by a RNDIS_EXT_LEN padding
> > so it is safe to use unsafe_memcpy.
> >
> > memcpy: detected field-spanning write (size 168) of single field "(void *)&request->response_msg + (sizeof(struct rndis_message) - sizeof(union rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_filter.c:338 (size 40)
> > RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
> > RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
> > RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
> > R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
> > R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
> > FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
> > Call Trace:
> >  <IRQ>
> >  ? _raw_spin_unlock_irqrestore+0x27/0x50
> >  netvsc_poll+0x556/0x940 [hv_netvsc]
> >  __napi_poll+0x2e/0x170
> >  net_rx_action+0x299/0x2f0
> >  __do_softirq+0xed/0x2ef
> >  __irq_exit_rcu+0x9f/0x110
> >  irq_exit_rcu+0xe/0x20
> >  sysvec_hyperv_callback+0xb0/0xd0
> >  </IRQ>
> >  <TASK>
> >  asm_sysvec_hyperv_callback+0x1b/0x20
> > RIP: 0010:native_safe_halt+0xb/0x10
> >
> > Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
>
> Could you please additionally provide a suitable 'Fixes' tag?
>
> You need to repost a new version, including such tag just before your
> SoB. While at that, please also include the target tree in the subj
> prefix (net).
>
> On this repost you can retain the ack/review tags collected so far.
>
> Thanks,
>
> Paolo
>
