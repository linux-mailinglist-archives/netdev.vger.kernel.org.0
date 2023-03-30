Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69996CFA45
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjC3EjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC3EjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:39:23 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E502F35A1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:39:18 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 259643F231
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680151157;
        bh=/RXtAW5BniJ9zlYrolKK7lczcJyzF3/grSbinFokSZg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Gz9USsTva2OAXxQ441ZmzNEF6W5VePJFD99tAgVWVElt1TdUCwpdGGYIs0xD7nIno
         ueSNYQj0CcpmEMDBp+sZL5yhjBIbpi2CPoqnZiEI/rw9MnxbHWU262qn/kkHCoXYTR
         AvQqw3FPLi2+2OZW1MIDKykN2JB+1Y/7IP7yvr0o7irbCbe2whX+1KZLUY98dXZMTO
         1z7Wxp2ME+/6BjKVkS4lkbGvi2WoaU0eeFI6B3kxNl88gcoluQ4Neqpx6hcdEoiyeD
         FonGT4ekP7F24VJtcGVPkqd8nE3pWvBKw/73JkVJ2UcQxQetafdmI1WefSqr4Yxgxq
         xe6jQgMUQ7a2A==
Received: by mail-pf1-f198.google.com with SMTP id w135-20020a62828d000000b0062c4eb40ddeso6764689pfd.3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680151155;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RXtAW5BniJ9zlYrolKK7lczcJyzF3/grSbinFokSZg=;
        b=QD+vce0+mF6Xxhr97OkWbP1s62QS1pQkYqYyNWtFCfY7ZvPK88t3rDnCRMadHNshF6
         MrSsQXkB3jOdGjuV2zh0YnVEWC+cPM2B84LOpKxIIX62EooYTrfOJhpGMGmfiWPym0BP
         nP5fYFc8CWllGek3qvn4+SePIoiYyHbh0wVu6HMARg4jXKThDPYSgGOh+h15+LIPDaf1
         fr2yI40+/ZuQ6gZSynuvyduIu4zVMxkc3a7Blk/IVCBOLzmfKMVnbrjaz/c6ID3d/5u/
         K2+3jFxZLT3PGVsAvPzPUHbdC+W5lEbdn1zIvYo712xNzKoSduDcJ2vr76hnf+Dj1IDH
         TxdA==
X-Gm-Message-State: AAQBX9cmD0wwYOK8kP+23RAEDW0qeLuyQ+veNmwSwfQ60I6WP9QFc0Fb
        MB/ocWUl3mZ7I9n94fXG2HGxpWwQ8J3DTXIGiCKUGmUvB/x9YJ7JkMKymaoaMzVtUSzazKDGyfV
        nL5qz+d96oVKVmszuPA9KiTuIE/KWIfl8YA==
X-Received: by 2002:a17:902:d4c8:b0:1a1:ce05:9ba with SMTP id o8-20020a170902d4c800b001a1ce0509bamr28429770plg.52.1680151154834;
        Wed, 29 Mar 2023 21:39:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350YIWlwgio1DRohNyDZKW5ubT/KBJJZr2xAztAPZoDhwwQ1wRLqRrfbHQUDYR7xgxnu7spW53A==
X-Received: by 2002:a17:902:d4c8:b0:1a1:ce05:9ba with SMTP id o8-20020a170902d4c800b001a1ce0509bamr28429751plg.52.1680151154512;
        Wed, 29 Mar 2023 21:39:14 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090276c100b00195f0fb0c18sm23769477plt.31.2023.03.29.21.39.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Mar 2023 21:39:14 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AFB8A60DBD; Wed, 29 Mar 2023 21:39:13 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A77DA9FB79;
        Wed, 29 Mar 2023 21:39:13 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
In-reply-to: <ZCUJgmGacqI5Aw+L@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com> <26873.1680061018@famine> <ZCUJgmGacqI5Aw+L@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 30 Mar 2023 12:01:06 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9643.1680151153.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 29 Mar 2023 21:39:13 -0700
Message-ID: <9644.1680151153@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Tue, Mar 28, 2023 at 08:36:58PM -0700, Jay Vosburgh wrote:
>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>> =

>> >At present, bonding attempts to obtain the timestamp (ts) information =
of
>> >the active slave. However, this feature is only available for mode 1, =
5,
>> >and 6. For other modes, bonding doesn't even provide support for softw=
are
>> >timestamping. To address this issue, let's call ethtool_op_get_ts_info
>> >when there is no primary active slave. This will enable the use of sof=
tware
>> >timestamping for the bonding interface.
>> =

>> 	If I'm reading the patch below correctly, the actual functional
>> change here is to additionally set SOF_TIMESTAMPING_TX_SOFTWARE in
>> so_timestamping for the active-backup, balance-tlb and balance-alb mode=
s
>
>No. In the description. I said for other modes, bonding doesn't even prov=
ide
>support for software timestamping. So this patch is to address this issue=
.
>i.e. add sw timestaming for all bonding modes.

	Ok, I think I follow now.  It is still adding only TX software
timestamping, as (from your example below) RX was already available.

	So, I do think the patch description is imprecise in saying,
"For other modes, bonding doesn't even provide support for software
timestamping" as this really refers to specifically TX timestamping.

	-J

>For mode 1,5,6. We will try find the active slave and get it's ts info
>directly. If there is no ops->get_ts_info, just use sw timestamping.
>
>For other modes, use sw timestamping directly.
>
>This is because some users want to use PTP over bond with other modes. e.=
g. LACP.
>They are satisfied with just sw timestamping as it's difficult to support=
 hw
>timestamping for LACP bonding.
>
>Before this patch, bond mode with 0, 2, 3, 4 only has software-receive.
>
># ethtool -T bond0
>Time stamping parameters for bond0:
>Capabilities:
>        software-receive
>        software-system-clock
>PTP Hardware Clock: none
>Hardware Transmit Timestamp Modes: none
>Hardware Receive Filter Modes: none
>
># ptp4l -m -S -i bond0
>ptp4l[66296.154]: interface 'bond0' does not support requested timestampi=
ng mode
>failed to create a clock
>
>After this patch:
>
># ethtool -T bond0
>Time stamping parameters for bond0:
>Capabilities:
>        software-transmit
>        software-receive
>        software-system-clock
>PTP Hardware Clock: none
>Hardware Transmit Timestamp Modes: none
>Hardware Receive Filter Modes: none
>
># ptp4l -m -S -i bond0
>ptp4l[66952.474]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
>ptp4l[66952.474]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
>ptp4l[66952.474]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
>ptp4l[66981.681]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT=
_EXPIRES
>ptp4l[66981.681]: selected local clock 007c50.fffe.70cdb6 as best master
>ptp4l[66981.682]: port 1: assuming the grand master role
>
>Thanks
>Hangbin

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
