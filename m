Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88116160B7
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiKBKSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBKSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:18:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4921924976
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 03:18:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y14so44007207ejd.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 03:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MS71m6Xz/eAlqZp5cWZsVXBfS3768AcWxlB/kO8yxC0=;
        b=DG2XlJ2ru/I5xYW2PUv3oiyqA2kOIN1SuCQc+uGGy1CB/Up3oGtftX0S2YrbO44Pf7
         j58JJMzTeNbAz4RDPdqRaPa4DdtqhBtL1HZcqVW7GxRcFLasxK1Gs1lKuGy/F7N1BK4Q
         +XTzEdRIdDfLc8HN09kQz7q0sjcNadOZUquJLMq5vzOqDB9ozPRq7hKUGXXShARQA1Ip
         DQ6tSrnnQQBg0FUzl0P+WsEFr2leInnRMeSFJFiDVDTVoAeC0z1n16CIlYN/TSuOQ1sW
         QlIhNiPKbnEm7Iygo4+qWH9W2fqP54vfPSu8q67zcCeQX6n2YhZPXgUiQxKEnd7cMXXq
         s9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MS71m6Xz/eAlqZp5cWZsVXBfS3768AcWxlB/kO8yxC0=;
        b=x87pXTxVLv0M6vzPz1xFUf45Tg6pIWBZXJtUaM/XvkBHTMUqoYBcY74aN8iJFnzuCO
         /mJ2iR+SXUPY6nehYPq3oqgyHxs70lglu/v2vkArQZaQMHaaPMpPmLrsjKx/l1NdsJ5K
         EcXwz3fZgj5sCfoaaNETJPTd6DilxZg9euuyEMzOExLWCr2toCJ8fv3l0zpIfYSBHFVO
         4GOkqGMEnKGZG0Wj4SrPLx1O4+pb/AynJAD5c0hiYnXghOCioVy0RNiLk00Y7qGYQiJy
         rOSHcy/s9ZN13arMvYdWm0TKuwE9/jkyNwG0eXOGUVkWC6eksYIHTyqzBolHIp0cHH24
         t6Iw==
X-Gm-Message-State: ACrzQf27wKmXmqU6JlMVHNQWDBfIwfk5WK8MZTPMlLfphr04A1hIOnLt
        jfqdLtb2BinqWaN8EU2Hf40=
X-Google-Smtp-Source: AMsMyM7wW0G4lVtRUDjnLKv7gdgx6iMdZT4nL19seZc0Wp/BRw74DA/zBwqO+7IkShfbvBpTGEPKSg==
X-Received: by 2002:a17:907:e93:b0:7ad:923a:5908 with SMTP id ho19-20020a1709070e9300b007ad923a5908mr23383356ejc.396.1667384323832;
        Wed, 02 Nov 2022 03:18:43 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090623e100b007adbd01c566sm834223ejg.146.2022.11.02.03.18.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2022 03:18:43 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Bug Report napi_pool i40e gro 
Message-Id: <5806E6B7-C64D-4DE2-A5FC-ECD1723DE325@gmail.com>
Date:   Wed, 2 Nov 2022 12:18:42 +0200
To:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        Intel-wired-lan@osuosl.org, david.switzer@intel.com,
        netdev <netdev@vger.kernel.org>
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

Hi Team=20
Report one bug , if find a problem and make fix add me .

[98218.450757] ------------[ cut here ]------------
[98218.504077] list_add double add: new=3Dffff8b2455a02900, =
prev=3Dffff8b2455a02900, next=3Dffff8b240598d918.
[98218.558682] WARNING: CPU: 0 PID: 2644 at lib/list_debug.c:33 =
__list_add_valid+0x90/0xa0
[98218.612737] Modules linked in: nft_limit  pppoe pppox ppp_generic =
slhc nft_flow_offload nf_flow_table_inet nf_flow_table nft_objref =
nft_nat nft_ct nft_chain_nat nf_tables netconsole coretemp bonding i40 =
ixgbe mdio_devres libphy mdio nf_nat_sip nf_conntrack_sip nf_nat_pptp =
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
[98218.885477] CPU: 0 PID: 2644 Comm: napi/eth1-612 Tainted: G        W  =
O       6.0.6 #1
[98218.940817] Hardware name: Supermicro SYS-6028TR-HTR/X10DRT-H, BIOS =
3.3 10/24/2020
[98218.995542] RIP: 0010:__list_add_valid+0x90/0xa0
[98219.049254] Code: 89 c6 4c 89 c2 48 c7 c7 60 03 07 a7 e8 5b 14 4f 00 =
0f 0b eb c1 48 89 f2 48 89 c1 48 89 fe 48 c7 c7 b0 03 07 a7 e8 42 14 4f =
00 <0f> 0b eb a8 66 66 2e 0f 1f 84 00 00 00 00 00 90 48 8b 17 48 8b 4f
[98219.157904] RSP: 0018:ffffafa2ccb1be18 EFLAGS: 00010296
[98219.212690] RAX: 0000000000000058 RBX: ffff8b2455a02900 RCX: =
00000000ffefffff
[98219.267028] RDX: 00000000ffefffff RSI: 0000000000000001 RDI: =
00000000ffffffea
[98219.320313] RBP: ffff8b240598d810 R08: 0000000000000000 R09: =
00000000ffefffff
[98219.372525] R10: ffff8b3356600000 R11: 0000000000000003 R12: =
0000000000000003
[98219.423609] R13: ffff8b240598d918 R14: ffff8b2455a02900 R15: =
0000000000000000
[98219.474767] FS:  0000000000000000(0000) GS:ffff8b2b5f600000(0000) =
knlGS:0000000000000000
[98219.525426] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[98219.575035] CR2: 000000000098f790 CR3: 0000000913bc8005 CR4: =
00000000001706f0
[98219.625203] Call Trace:
[98219.674023]  <TASK>
[98219.721698]  napi_gro_receive+0x83/0x180
[98219.769488]  i40e_napi_poll+0x310/0x7b0 [i40e]
[98219.816340]  ? __napi_poll+0x130/0x130
[98219.862047]  __napi_poll+0x20/0x130
[98219.907716]  napi_threaded_poll+0x123/0x130
[98219.952446]  kthread+0xae/0xd0
[98219.995951]  ? kthread_complete_and_exit+0x20/0x20
[98220.039839]  ret_from_fork+0x1f/0x30
[98220.082631]  </TASK>
[98220.124082] ---[ end trace 0000000000000000 ]=E2=80=94


Best=20

Regards,
Martin=
