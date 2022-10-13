Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5C5FD680
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJMI4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJMI4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E729411BD85
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665651392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OWmJJ7tdKeTxLJ2ihy3nss5D3o4zsrHdrclXvSYrvos=;
        b=Wej34bd67c2W8/bHlZhTCdsoM62PXb8CFIKoeqrTp4cIeB/3NFsrb7ZwvgZJjW72L3aV2+
        dsELD6rY0GxQ2bbx5gAZ+1pWhm0kaxV4e/9VVeA0QTFKAcW8f1wAP7dj+NVF5/Du0oDJS8
        If1Omg+tEYxnaean3xkXVf+zexVe15E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-OYQyBvMyOpW-4iY_JNQ2pw-1; Thu, 13 Oct 2022 04:56:31 -0400
X-MC-Unique: OYQyBvMyOpW-4iY_JNQ2pw-1
Received: by mail-wr1-f71.google.com with SMTP id u20-20020adfc654000000b0022cc05e9119so289600wrg.16
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWmJJ7tdKeTxLJ2ihy3nss5D3o4zsrHdrclXvSYrvos=;
        b=S60YeS2lKYJBqEicR31k9FsUuqWxLTAfqiIlK17DV+LbN0jE+lVbz/GfYmh7+13DcV
         TTT0RmRv9y2aYfzrZGevq3fWyxLvVasBNJd89P20JSLwrihm7yW7Hbj6rQqgtF/vXxbu
         hqdw52eVHPGVUo4QnhXLF4lnTvxcWbwd52kQkOo9bIq73FC9NJ7D7YjCzNQL0Eg2YquS
         YZTQdHnIcQrh10hAtlaV7lyY7CtYkfb2xwJ7E3mdyqIg7uS59+ElIrXAIpoV/wn34jqr
         VxdlxRGWubBG1PmeR+QPU22n8ntdY8w3/ene6UIKSuuCNl+d66OF5aPCkILTmLJk9Wn9
         a7JQ==
X-Gm-Message-State: ACrzQf1vLSM7gYW+C/ej1F59/DmvEI0UVfQAWK/Ox6D61m7VIJJ+oa+R
        CnLNfi/+boSouFTkbmtE/dM7pVOSgsbrd3jyc3l38LOnhaYVZBnrY3tw3D3VKki8sjHCjAMMEn7
        seWOceC2kdKXbi07E
X-Received: by 2002:a05:600c:1291:b0:3c6:9ed5:7bb1 with SMTP id t17-20020a05600c129100b003c69ed57bb1mr5651434wmd.205.1665651389865;
        Thu, 13 Oct 2022 01:56:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6zBtVFTk6p7NJAlsSz+xOnO7y4M5i5HyvAD8uKoPBrShiyyjtebhAyV0/y9BOXUCkWnD15WQ==
X-Received: by 2002:a05:600c:1291:b0:3c6:9ed5:7bb1 with SMTP id t17-20020a05600c129100b003c69ed57bb1mr5651415wmd.205.1665651389547;
        Thu, 13 Oct 2022 01:56:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id p10-20020a05600c204a00b003c6bd12ac27sm3782546wmg.37.2022.10.13.01.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 01:56:28 -0700 (PDT)
Message-ID: <e71426117517a62f4e940318b1c048f15d8fe5b7.camel@redhat.com>
Subject: Re: [PATCH v2] hv_netvsc: Fix a warning triggered by memcpy in
 rndis_filter
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cezar Bulinaru <cbulinaru@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 13 Oct 2022 10:56:27 +0200
In-Reply-To: <20221012013922.32374-1-cbulinaru@gmail.com>
References: <20221012013922.32374-1-cbulinaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-10-11 at 21:39 -0400, Cezar Bulinaru wrote:
> A warning is triggered when the response message len exceeds
> the size of rndis_message. Inside the rndis_request structure
> these fields are however followed by a RNDIS_EXT_LEN padding
> so it is safe to use unsafe_memcpy.
> 
> memcpy: detected field-spanning write (size 168) of single field "(void *)&request->response_msg + (sizeof(struct rndis_message) - sizeof(union rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_filter.c:338 (size 40)
> RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
> RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
> RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
> R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
> R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
> FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
> Call Trace:
>  <IRQ>
>  ? _raw_spin_unlock_irqrestore+0x27/0x50
>  netvsc_poll+0x556/0x940 [hv_netvsc]
>  __napi_poll+0x2e/0x170
>  net_rx_action+0x299/0x2f0
>  __do_softirq+0xed/0x2ef
>  __irq_exit_rcu+0x9f/0x110
>  irq_exit_rcu+0xe/0x20
>  sysvec_hyperv_callback+0xb0/0xd0
>  </IRQ>
>  <TASK>
>  asm_sysvec_hyperv_callback+0x1b/0x20
> RIP: 0010:native_safe_halt+0xb/0x10
> 
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

Could you please additionally provide a suitable 'Fixes' tag?

You need to repost a new version, including such tag just before your
SoB. While at that, please also include the target tree in the subj
prefix (net).

On this repost you can retain the ack/review tags collected so far.

Thanks,

Paolo

