Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC266E2928
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDNRUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDNRUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:20:15 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BF1BD6;
        Fri, 14 Apr 2023 10:20:13 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id o7so14896374qvs.0;
        Fri, 14 Apr 2023 10:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681492813; x=1684084813;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anVanRqRAMLkondoY3FgX8UFzTsrcBKenJMcpkQ/ghs=;
        b=kcZmgmLRpmwfYUtTgGBhF7ybS2GbzLgHDq2aY6iRrU3XVia8lX6gahyxfdBdjccnr1
         dLHO+T6ZuPcHK2L4vFuOstUVpFYPjQJVgEYu6GN3qSYSJuj7TdjpzDf3cXEN/vmWyzrW
         n50HGQ4gDeOtv3edzgAhb4V6DLd90S8SVkX3SCsB95Up+QEpDaGbLPG+SthZxPVgkOPk
         2C8IL4XD/JqKMOUYTrVedfgcZUmIriAiA756pbLxSlbs0PIHhg1J9pyjwQL2rbiE/OMc
         G9CMwr3CPt6LiMiK9uj+T8/4/1szyvx8K/YXXO3NjDY+kZbcRO8oJDkX9wR3S4/Xy7BL
         /5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681492813; x=1684084813;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=anVanRqRAMLkondoY3FgX8UFzTsrcBKenJMcpkQ/ghs=;
        b=bigbSW65Y/ISsBS0PMEMjVyO3183QG5tb+PJwJ5NBfB+3X/KkoixQltQ+EwgCPTGYh
         2xiBJOaJKEz6XCqMk1m6haJ23hf305gLFKJivn5p3QAG+W1O7MovsPod04Z0/3QUru4f
         BuGBNlFwji9oi9G8pMUPFUl7ESKNPgHKpb1pMHvg8GtWtAfBXrf640v/Wrpfk61Y1hdT
         U2gT0LNBD6dWLFH5Ly/dg2AAPRl8lFBMpmHd3cXscCdaLG8o31OdevcKFilOlZlZ0Jsy
         VmLBx0S5Vg4bRfVbCUPfLbmaN+hO2j3fDk7DOIi+eFB5cCYK9uV1D90i4j69vUOCxEDD
         WKnw==
X-Gm-Message-State: AAQBX9eW54+p4auPDHEPa0Gwe7tnm8OXN/0wXxvnAxaQkJsBA8nXGWI2
        jcgKOPawFASq6ceFwwQEhUA=
X-Google-Smtp-Source: AKy350bXI6yV0maPBDVpcT3ONykGzvmgxlEIb4TPKU7k7saEceSRFYGrHUogheeac1Nl8ciMcygyXQ==
X-Received: by 2002:a05:6214:e6f:b0:5ef:4455:fd24 with SMTP id jz15-20020a0562140e6f00b005ef4455fd24mr4552747qvb.1.1681492813006;
        Fri, 14 Apr 2023 10:20:13 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id z17-20020a0cf251000000b005e90a67a687sm1228581qvl.65.2023.04.14.10.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 10:20:12 -0700 (PDT)
Date:   Fri, 14 Apr 2023 13:20:12 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "luwei (O)" <luwei32@huawei.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jbenc@redhat.com" <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <64398b4c4585f_17abe429442@willemb.c.googlers.com.notmuch>
In-Reply-To: <643983f69b440_17854f2948c@willemb.c.googlers.com.notmuch>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
 <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
 <6436b5ba5c005_41e2294dd@willemb.c.googlers.com.notmuch>
 <a30a8ffaa8dd4cb6a84103eecf0c3338@huawei.com>
 <643983f69b440_17854f2948c@willemb.c.googlers.com.notmuch>
Subject: =?UTF-8?Q?RE:_=E7=AD=94=E5=A4=8D:_[PATCH_net]_net:_Add_check_for?=
 =?UTF-8?Q?_csum=5Fstart_in_skb=5Fpartial=5Fcsum=5Fset=28=29?=
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> luwei (O) wrote:
> > yes, here is the vnet_hdr:
> > 
> >     flags: 3
> >     gso_type: 3
> >     hdr_len: 23
> >     gso_size: 58452
> >     csum_start: 5
> >     csum_offset: 16
> > 
> > and the packet:
> > 
> > | vnet_hdr | mac header | network header | data ... |
> > 
> >   memcpy((void*)0x20000200,
> >          "\x03\x03\x02\x00\x54\xe4\x05\x00\x10\x00\x80\x00\x00\x53\xcc\x9c\x2b"
> >          "\x19\x3b\x00\x00\x00\x89\x4f\x08\x03\x83\x81\x04",
> >          29);
> >   *(uint16_t*)0x200000c0 = 0x11;
> >   *(uint16_t*)0x200000c2 = htobe16(0);
> >   *(uint32_t*)0x200000c4 = r[3];
> >   *(uint16_t*)0x200000c8 = 1;
> >   *(uint8_t*)0x200000ca = 0;
> >   *(uint8_t*)0x200000cb = 6;
> >   memset((void*)0x200000cc, 170, 5);
> >   *(uint8_t*)0x200000d1 = 0;
> >   memset((void*)0x200000d2, 0, 2);
> >   syscall(__NR_sendto, r[1], 0x20000200ul, 0xe45ful, 0ul, 0x200000c0ul, 0x14ul);
> 
> Thanks. So this can happen whenever a packet is injected into the tx
> path with a virtio_net_hdr.
> 
> Even if we add bounds checking for the link layer header in pf_packet,
> it can still point to the network header.
> 
> If packets are looped to the tx path, skb_pull is common if a packet
> traverses tunnel devices. But csum_start does not directly matter in
> the rx path (CHECKSUM_PARTIAL is just seen as CHECKSUM_UNNECESSARY).
> Until it is forwarded again to the tx path.
> 
> So the question is which code calls skb_checksum_start_offset on the
> tx path. Clearly, skb_checksum_help. Also a lot of drivers. Which
> may cast the signed int return value to an unsigned. Even an u8 in 
> the first driver I spotted (alx).
> 
> skb_postpull_rcsum anticipates a negative return value, as do other
> core functions. So it clearly allowed in certain cases. We cannot
> just bound it.
> 
> Summary after a long story: an initial investigation, but I don't have
> a good solution so far. Maybe others have a good suggestiong based on
> this added context.

Specific to skb_checksum_help, it appears that skb_checksum will
work with negative offset just fine.

Perhaps the only issue is that the WARN_ON_ONCE compares signed to
unsigned, and thus incorrectly interprets a negative offset as
 >= skb_headlen(skb)
