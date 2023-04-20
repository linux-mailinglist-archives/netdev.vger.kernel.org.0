Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4166B6E9DCB
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjDTVXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjDTVXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:23:42 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CF030C5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:23:39 -0700 (PDT)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6F1214425C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 21:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682025815;
        bh=HBG9VOFtZIMtAywBR/nqNm9aM9egFJsYV2JJSs37XUU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=r6kxwESNdcs/6zsGx7K4DqLmWlCA0QVKwTizCVi4A/Xb3yVor9m9VdoRGmybUQeDn
         KGBHP7Ky3ad29UQHa/LfgJRmF7iKzGy5X5qrRHg5KdEdwImawj5PjwAzM/kgmA4Ra6
         5xoKTHCsyayDTwnvssqn+4cCrOMuN3LoFFIbrH7F+qaSdeGkDlMayYe6CVNE67jobq
         mYM+fnEq2AxOmrMZ1VsY9ac4auQwD7lBPqxJIr9Tz9tqXruARGCAb7f0+LNhIuKu+i
         6YOXbDp/57YdpSl4ScDsqnaF4a0VcrHilmUGtzSTQNFYpkxnZg+a8tP/XJHD5U6ZKa
         ot7L1ppP0YBDw==
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-63b27afef94so1727696b3a.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682025814; x=1684617814;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HBG9VOFtZIMtAywBR/nqNm9aM9egFJsYV2JJSs37XUU=;
        b=QlzVGkt7URlSFMYMd8/MD/qY4TaP5VnhZdQjoIDN8ZSUm5/8NvodDtw75px3oOd4/n
         9ORtqEaIDt797+c5/T8a0GeIvcAVV1syXF1T8914u7/FWIRu8RljhcUxTvoOYK0q6Lun
         qZ7U+UwmKoZgRLr0WWRC1eatTdIUzpw8temr/XpdPFC37Yoln5/2vzY+sC2VQBVqJMvM
         QDiRDeOKeFBsVp5oUFhX8OgOdHoDcXd6gS6s6HknM4i238+Ejag8NsmBP/QhxsX0bCuY
         SRTpHevNxVyh7ADvWNk9X2nsnDKSRWglD6Sq0ndkdPKO0qfOWD36/G0XK45p3r4wwlSd
         O8AQ==
X-Gm-Message-State: AAQBX9f/7dXBS5+jkZkJDg/O89o+uCpxmCdSG2jfphGoc9ETrvMpBb7a
        MGIV7awUZ8IBz5eOy04K8lLQMjbcJJvV82fR0b/wuK1mdccUjvHtQxmMFSzLddly/mL1fvM/0q1
        Tw8+GTqIrOmsJy+/dyOnHhwE+WrNVIMtnRMLycKwYEQ==
X-Received: by 2002:a05:6a00:1a86:b0:63d:315f:560f with SMTP id e6-20020a056a001a8600b0063d315f560fmr3037986pfv.13.1682025813914;
        Thu, 20 Apr 2023 14:23:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350aCVNcZ+fbqx3NmBFIyCbzrVMUcKpV+ZjqAhR2eIojiu3gS59Ek0g53E0q8zA2EULqPf5n97A==
X-Received: by 2002:a05:6a00:1a86:b0:63d:315f:560f with SMTP id e6-20020a056a001a8600b0063d315f560fmr3037971pfv.13.1682025813643;
        Thu, 20 Apr 2023 14:23:33 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id d19-20020a056a0024d300b0063b488f3305sm1657958pfv.155.2023.04.20.14.23.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Apr 2023 14:23:33 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AEF9B607E6; Thu, 20 Apr 2023 14:23:32 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A72D49FB79;
        Thu, 20 Apr 2023 14:23:32 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>
cc:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
In-reply-to: <20230420202303.iecl2vnkbdm2qfs7@skbuf>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org> <9836.1682020053@famine> <20230420202303.iecl2vnkbdm2qfs7@skbuf>
Comments: In-reply-to Vladimir Oltean <olteanv@gmail.com>
   message dated "Thu, 20 Apr 2023 23:23:03 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16321.1682025812.1@famine>
Date:   Thu, 20 Apr 2023 14:23:32 -0700
Message-ID: <16322.1682025812@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> wrote:

>On Thu, Apr 20, 2023 at 12:47:33PM -0700, Jay Vosburgh wrote:
>> Simon Horman <horms@kernel.org> wrote:
>> 
>> >The type of the vlan_proto field is __be16.
>> >And most users of the field use it as such.
>> >
>> >In the case of setting or testing the field for the
>> >special VLAN_N_VID value, host byte order is used.
>> >Which seems incorrect.
>> >
>> >Address this issue by converting VLAN_N_VID to __be16.
>> >
>> >I don't believe this is a bug because VLAN_N_VID in
>> >both little-endian (and big-endian) byte order does
>> >not conflict with any valid values (0 through VLAN_N_VID - 1)
>> >in big-endian byte order.
>> 
>> 	Is that true for all cases, or am I just confused?  Doesn't VLAN
>> ID 16 match VLAN_N_VID (which is 4096) if byte swapped?
>> 
>> 	I.e., on a little endian host, VLAN_N_VID is 0x1000 natively,
>> and network byte order (big endian) of VLAN ID 16 is also 0x1000.
>> 
>> 	Either way, I think the change is fine; VLAN_N_VID is being used
>> as a sentinel value here, so the only real requirement is that it not
>> match an actual VLAN ID in network byte order.
>> 
>> 	-J
>
>In a strange twist of events, VLAN_N_VID is assigned as a sentinel value
>to a variable which usually holds the output of vlan_dev_vlan_proto(),
>or i.o.w. values like htons(ETH_P_8021Q), htons(ETH_P_8021AD). It is
>certainly a confusion of types to assign VLAN_N_VID to it, but at least
>it's not a valid VLAN protocol.
>
>To answer your question, tags->vlan_proto is never compared against a
>VLAN ID.

	Yah, looking again I see that now; I was checking the math on
Simon's statement about "0 through VLAN_N_VID - 1".

	So, I think the patch is correct, but the commit message should
really explain the reality.  And, perhaps we should use 0 or 0xffff for
the sentinel, since neither are valid Ethernet protocol IDs.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
