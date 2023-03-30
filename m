Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1E6CF9E9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjC3EBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjC3EBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:01:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8DE1FED
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:01:12 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n14so1059237plc.8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680148872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vOHl0/o2HtCPgtA61yO355BnbdzKv2TEbL10PEyV6Qg=;
        b=T9G1opOqews3y67BLatq999yM4ZlgTuWhApcwMLilLYSu0zVD+QxkuzOdsLRVvoJuL
         +WfgC5NzseQV+LUs+8EPWt37XemLl2shu/UTfT7MNqAJ3GEBhiDp1FKgdOh+XXN+atrw
         u3RnGmRkNzGB9c5PqRKavXOylYShko2W6lBqJEYWhexCyv1YL3NMAajKRsig0N3viOLZ
         VVHOHWgWCy9boj2Y5UdJylhPqr9IKuLybsiVYXwDXxQrYTseVozPhu7g1LTfKn1pPiK/
         IMXbrY42UBtInnGNqgdZXzrwITXUAzO/nyEDrUyG7oGKvSGtRiNjPeo4iPnj0K/L2ua9
         vcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680148872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOHl0/o2HtCPgtA61yO355BnbdzKv2TEbL10PEyV6Qg=;
        b=bns3/9vtYaoA3okDGd2nO1CiphsaTbE96HwPSwB4XEnjLP9Vty7lqc8W1iJkGDgeWs
         e5SHr2JvIyRx6qh3vB1IRd9maOUQ3gbNSpEcPtIROamWPZm6tPLJCP/Xesncv0KfS4BN
         9KfvuBL8/E6WMpzW0CQTpp3Wax6yRQIEep4NUeOPbWbgPYKAfFvEs5+8PFup6scAl23+
         K4UdDustyjVWaFUjqqOpZTQqvBFTwr2uUkjcBo+sjaOm7KMPue9jYVIvM0livHYVosQ8
         cmHxLAtW4uJW74WI9LhznlInpkiKRHFZFZ6QU2Qq6zJb1TueA2WkI5VyFgL5Pov86HrY
         G3dQ==
X-Gm-Message-State: AAQBX9clLh5w5udsklIFSHB+tN14LTfWnq3gVqEc13hRTjr6CiPLhc+9
        TTiB6eR96PUS7PaWNLQRLoM=
X-Google-Smtp-Source: AKy350YE9ES0qkwVz/4Q1CH+7JSpEuHqQcu0444TT/41O+9RRfEHoER88Y6aBd2tjzpZfODaG1IiFQ==
X-Received: by 2002:a05:6a20:4f11:b0:db:ae75:c70e with SMTP id gi17-20020a056a204f1100b000dbae75c70emr5685946pzb.15.1680148871814;
        Wed, 29 Mar 2023 21:01:11 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0050bcf117643sm21526345pgh.17.2023.03.29.21.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 21:01:11 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:01:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZCUJgmGacqI5Aw+L@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
 <26873.1680061018@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26873.1680061018@famine>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 08:36:58PM -0700, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >At present, bonding attempts to obtain the timestamp (ts) information of
> >the active slave. However, this feature is only available for mode 1, 5,
> >and 6. For other modes, bonding doesn't even provide support for software
> >timestamping. To address this issue, let's call ethtool_op_get_ts_info
> >when there is no primary active slave. This will enable the use of software
> >timestamping for the bonding interface.
> 
> 	If I'm reading the patch below correctly, the actual functional
> change here is to additionally set SOF_TIMESTAMPING_TX_SOFTWARE in
> so_timestamping for the active-backup, balance-tlb and balance-alb modes

No. In the description. I said for other modes, bonding doesn't even provide
support for software timestamping. So this patch is to address this issue.
i.e. add sw timestaming for all bonding modes.

For mode 1,5,6. We will try find the active slave and get it's ts info
directly. If there is no ops->get_ts_info, just use sw timestamping.

For other modes, use sw timestamping directly.

This is because some users want to use PTP over bond with other modes. e.g. LACP.
They are satisfied with just sw timestamping as it's difficult to support hw
timestamping for LACP bonding.

Before this patch, bond mode with 0, 2, 3, 4 only has software-receive.

# ethtool -T bond0
Time stamping parameters for bond0:
Capabilities:
        software-receive
        software-system-clock
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes: none
Hardware Receive Filter Modes: none

# ptp4l -m -S -i bond0
ptp4l[66296.154]: interface 'bond0' does not support requested timestamping mode
failed to create a clock

After this patch:

# ethtool -T bond0
Time stamping parameters for bond0:
Capabilities:
        software-transmit
        software-receive
        software-system-clock
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes: none
Hardware Receive Filter Modes: none

# ptp4l -m -S -i bond0
ptp4l[66952.474]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[66952.474]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[66952.474]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[66981.681]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l[66981.681]: selected local clock 007c50.fffe.70cdb6 as best master
ptp4l[66981.682]: port 1: assuming the grand master role

Thanks
Hangbin
