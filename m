Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CDB2AB786
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgKILvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:51:55 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:17846 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKILvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604922711;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=o/5UMyM7rAmApMSfSqcYpvo+wFZPcCFwoq94SXiRKf8=;
        b=B4313r4K9sAMg2ljk/2fQWUODDx3gMBAHAW+WhUQQG+yITT1YFn58/Kt71nj7TCWhM
        AnVLxTCnl4f+i7HMkg4WqjZUXmfK0soAZ3Pt52cMDnNoNuyv4BzdhfOjOP5t0IQkPv8H
        pIQyWqKUG26+UKv4XS07dErVTV8uLL7gbqyioqzXdlVDOY2dR5hqcnlZYau+EKdaqY4N
        LuSNOY+Yh9PYxiWSQE5/Xqe+hKvse2S7agE8cu8wfAMvn5Y4OyE59zAi3iC4W1112BRv
        LNhvZzb8PfQ8MoZM/kzVXPcTiEvl1nIXEsKmFHkGbpHPBYS49BcbDPIV/08HmALOeBfS
        HwxA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J88G"
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9Bpn75l
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 12:51:49 +0100 (CET)
Subject: Re: [PATCH v4 0/7] Introduce optional DLC element for Classic CAN
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org
References: <20201109102618.2495-1-socketcan@hartkopp.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <701d9cfc-fa48-1a6c-2ecb-cb903b311e5a@hartkopp.net>
Date:   Mon, 9 Nov 2020 12:51:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109102618.2495-1-socketcan@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.11.20 11:26, Oliver Hartkopp wrote:
> Introduce improved DLC handling for Classic CAN with introduces a new
> element 'len8_dlc' to the struct can_frame and additionally rename
> the 'can_dlc' element to 'len' as it represents a plain payload length.
> 
> Before implementing the CAN_CTRLMODE_CC_LEN8_DLC handling on driver level
> this patch set cleans up and renames the relevant code.
> 
> No functional changes.
> 
> This patch set is based on mkl/linux-can.git (testing branch).

In fact it is based on the latest net-next ...

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

copy/paste error, sorry.

m(

> 
> Changes in v2:
>    - rephrase commit message of patch 4 about can_dlc replacement
> 
> Changes in v3:
>    - remove unnecessarily introduced u8 cast in flexcan.c
> 
> Changes in v4:
>    - adopt phrasing suggestions from Vincent Mailhol
>    - separate and extend CAN documentation (Documentation/networking/can.rst)
>    - add new patches for len8_dlc handling for CAN drivers
>        - add new helpers in include/linux/can/dev.h
>        - add len8_dlc support for various CAN USB adapters as reference
> 
> Oliver Hartkopp (7):
>    can: add optional DLC element to Classical CAN frame structure
>    can: rename get_can_dlc() macro with can_get_cc_len()
>    can: remove obsolete get_canfd_dlc() macro
>    can: replace can_dlc as variable/element for payload length
>    can: update documentation for DLC usage in Classical CAN
>    can-dev: introduce helpers to access Classical CAN DLC values
>    can-dev: add len8_dlc support for various CAN USB adapters
> 
>   Documentation/networking/can.rst              | 68 ++++++++++++++-----
>   drivers/net/can/at91_can.c                    | 14 ++--
>   drivers/net/can/c_can/c_can.c                 | 20 +++---
>   drivers/net/can/cc770/cc770.c                 | 14 ++--
>   drivers/net/can/dev.c                         | 10 +--
>   drivers/net/can/flexcan.c                     |  4 +-
>   drivers/net/can/grcan.c                       | 10 +--
>   drivers/net/can/ifi_canfd/ifi_canfd.c         |  6 +-
>   drivers/net/can/janz-ican3.c                  | 20 +++---
>   drivers/net/can/kvaser_pciefd.c               |  4 +-
>   drivers/net/can/m_can/m_can.c                 |  6 +-
>   drivers/net/can/mscan/mscan.c                 | 20 +++---
>   drivers/net/can/pch_can.c                     | 14 ++--
>   drivers/net/can/peak_canfd/peak_canfd.c       | 16 ++---
>   drivers/net/can/rcar/rcar_can.c               | 14 ++--
>   drivers/net/can/rcar/rcar_canfd.c             |  8 +--
>   drivers/net/can/rx-offload.c                  |  2 +-
>   drivers/net/can/sja1000/sja1000.c             | 10 +--
>   drivers/net/can/slcan.c                       | 32 ++++-----
>   drivers/net/can/softing/softing_fw.c          |  2 +-
>   drivers/net/can/softing/softing_main.c        | 14 ++--
>   drivers/net/can/spi/hi311x.c                  | 20 +++---
>   drivers/net/can/spi/mcp251x.c                 | 20 +++---
>   .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  4 +-
>   drivers/net/can/sun4i_can.c                   | 10 +--
>   drivers/net/can/ti_hecc.c                     |  8 +--
>   drivers/net/can/usb/ems_usb.c                 | 16 ++---
>   drivers/net/can/usb/esd_usb2.c                | 16 ++---
>   drivers/net/can/usb/gs_usb.c                  | 20 +++---
>   .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
>   .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 20 +++---
>   .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 22 +++---
>   drivers/net/can/usb/mcba_usb.c                | 10 +--
>   drivers/net/can/usb/peak_usb/pcan_usb.c       | 20 +++---
>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c    | 29 +++++---
>   drivers/net/can/usb/peak_usb/pcan_usb_pro.c   | 14 ++--
>   drivers/net/can/usb/ucan.c                    | 20 +++---
>   drivers/net/can/usb/usb_8dev.c                | 21 +++---
>   drivers/net/can/xilinx_can.c                  | 12 ++--
>   include/linux/can/dev.h                       | 30 ++++++--
>   include/linux/can/dev/peak_canfd.h            |  2 +-
>   include/uapi/linux/can.h                      | 38 +++++++----
>   include/uapi/linux/can/netlink.h              |  1 +
>   net/can/af_can.c                              |  2 +-
>   net/can/gw.c                                  |  2 +-
>   net/can/j1939/main.c                          |  4 +-
>   46 files changed, 377 insertions(+), 294 deletions(-)
> 
