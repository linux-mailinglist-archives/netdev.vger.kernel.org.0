Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE45EFEF1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiI2U5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 16:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiI2U5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 16:57:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F3160E54
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 13:57:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id nb11so5250937ejc.5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=LyQer5h6k/nnebIdaSJUIv+iuN6CF+uIaXRImCee2v8=;
        b=VGjZzTap9y9WLSehETNsduHUG/yMxfj14zd57WGcRdmXYBIFsGqRDeNOB0s6kU4WUn
         2ue7UC5NYe2IoXHrXFrecVISkOTi328q87A1QBLbERDiC141iMxDuWiXhPh+VJudrAJ8
         or8+fcnTGWylX1ukMwBBQG9mmeJlVosU/aRvXgXb7HsG8u+nfmsifmaogYq6evEILqKM
         Vj28aKmOJG4MfDHcWjjSfYVvzH5hbIxFCtXweHRoi8XSYM2pbYw1lq4DccnJ/lcXaLn2
         iFJrm8goWdp1LmaAshDh8sKkbUPYnhLli+Mm4V1+j5aOFIPLaZiF7bWYcLp+GPQcEtjE
         +Ojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LyQer5h6k/nnebIdaSJUIv+iuN6CF+uIaXRImCee2v8=;
        b=bYydX3HO84yseeM0XgCfGOw8JZjZYKImoWhXwoxDvldxvnSVhLY/4rQUe4xHbIe0Jz
         Cw/sW84HWth6w8RysRmq1uSTCecWW2PA8CjSUTowY1HUak9mv3L2lgyI/5AuIO9YLgW/
         4+3IOFa7EUMVfjszuEtgqqxR1ZB8GfMZBp+M8doXEfnPs1v7tYdCwJ/MbfI0DzycoFu7
         SGJZAUszRBSfhk5cM8Y/4mCFAnSQQkVZTAmGKYD3GVu2yfY3PxXyb6PveYiB2JZTnMmm
         GlK7kLpGaoN3HkmNKdlO8kVupse1tin0aVE3CzHqe2kWr8DFACVlKGP/i+5MbEoX8Oo2
         LsJw==
X-Gm-Message-State: ACrzQf2wfrqrF/vd+xRlrhESOuerN3IbfXzztKTj2dBRokGFgHuU9HqA
        s1cPgyrsyhIcz7Uop1+iyw/MS1LwvGo=
X-Google-Smtp-Source: AMsMyM5MhYSHVkY2OQAlGmbRLTJu9uQ+Pfaal/geXGgx89ZljTdI5hJGPJbwLQjcSU+uK53pS1I9pA==
X-Received: by 2002:a17:906:4fca:b0:782:2484:6d72 with SMTP id i10-20020a1709064fca00b0078224846d72mr4272283ejw.150.1664485027402;
        Thu, 29 Sep 2022 13:57:07 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id d2-20020a50fb02000000b004580296bb0bsm331081edq.83.2022.09.29.13.57.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Sep 2022 13:57:06 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220928085708.GI12777@breakpoint.cc>
Date:   Thu, 29 Sep 2022 23:57:05 +0300
Cc:     netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF75F7A2-FAB1-4614-8704-A8F07484B8A8@gmail.com>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFp4H/rbdov7iDg@dhcp22.suse.cz> <20220926151939.GG12777@breakpoint.cc>
 <D304A05C-D535-43D0-AC70-D5943CE66D89@gmail.com>
 <43A13D50-9CD8-41A5-A355-B361DE277D93@gmail.com>
 <20220928085708.GI12777@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel 5.19.12 and run test if see any bugs will update


Thanks Florian !


Martin

> On 28 Sep 2022, at 11:57, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> And one more from last min
>> this is with kernel 5.19.11
>=20
> This is unrelated to the rhashtable/mm thing, so I am trimming CCs.
>=20
>> Sep 27 17:44:57 [ 1771.332920][    C8] RIP: =
0010:queued_spin_lock_slowpath+0x41/0x1a0
>> Sep 27 17:44:57 [ 1771.356563][    C8] Code: 08 0f 92 c1 8b 02 0f b6 =
c9 c1 e1 08 30 e4 09 c8 3d ff 00 00 00 0f 87 f5 00 00 00 85 c0 74 0f 8b =
02 84 c0 74 09 0f ae e8 8b 02 <84> c0 75 f7 b8 01 00 00 00 66 89 02 c3 =
8b 37 b8 00 02 00 00 81 fe
>> Sep 27 17:44:57 [ 1771.405388][    C8] RSP: 0000:ffffa03dc3e3faf8 =
EFLAGS: 00000202
>> Sep 27 17:44:57 [ 1771.429444][    C8] RAX: 0000000000000101 RBX: =
ffff9d530e975a48 RCX: 0000000000000000
>> Sep 27 17:44:57 [ 1771.454289][    C8] RDX: ffff9d5380235d04 RSI: =
0000000000000001 RDI: ffff9d5380235d04
>> Sep 27 17:44:57 [ 1771.479285][    C8] RBP: ffff9d5380235d04 R08: =
0000000000000056 R09: 0000000000000030
>> Sep 27 17:44:57 [ 1771.504541][    C8] R10: c3acfae79ca90a0d R11: =
ffffa03dc3e30a0d R12: 0000000064a1ac01
>> Sep 27 17:44:57 [ 1771.529954][    C8] R13: 0000000000000002 R14: =
0000000000000000 R15: 0000000000000001
>> Sep 27 17:44:57 [ 1771.555591][    C8]  nf_ct_seqadj_set+0x55/0xd0 =
[nf_conntrack]
>> Sep 27 17:44:57 [ 1771.581511][    C8]  =
__nf_nat_mangle_tcp_packet+0x102/0x160 [nf_nat]
>> Sep 27 17:44:57 [ 1771.607825][    C8]  nf_nat_ftp+0x175/0x267 =
[nf_nat_ftp]
>> Sep 27 17:44:57 [ 1771.634121][    C8]  ? =
fib_validate_source+0x37/0xd0
>> Sep 27 17:44:57 [ 1771.660376][    C8]  ? help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
>> Sep 27 17:44:57 [ 1771.686819][    C8]  help+0x4d5/0x6a0 =
[nf_conntrack_ftp]
>=20
> Either need to wait for next 5.19.y release or apply the patch =
manually:
> =
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tr=
ee/queue-5.19/netfilter-nf_ct_ftp-fix-deadlock-when-nat-rewrite-is.patch
>=20
> or remove nf_nat ftp module for the time being.

