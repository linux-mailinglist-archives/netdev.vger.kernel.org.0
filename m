Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC55D9C89F
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfHZFPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:15:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZFPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:15:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7671714FE1C24;
        Sun, 25 Aug 2019 22:15:08 -0700 (PDT)
Date:   Sun, 25 Aug 2019 22:15:07 -0700 (PDT)
Message-Id: <20190825.221507.1465677703637201643.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: Re: [PATCH net-next 01/14] bnxt_en: Suppress all error messages in
 hwrm_do_send_msg() in silent mode.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566791705-20473-2-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
        <1566791705-20473-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 22:15:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 25 Aug 2019 23:54:52 -0400

> If the silent parameter is set, suppress all messages when there is
> no response from firmware.  When polling for firmware to come out of
> reset, no response may be normal and we want to suppress the error
> messages.  Also, don't poll for the firmware DMA response if Bus Master
> is disabled.  This is in preparation for error recovery when firmware
> may be in error or reset state or Bus Master is disabled.
> 
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

The function bnxt_hwrm_do_send_msg() seems to be an interesting mix of return
values, what are the semantics?

It seems to use 0 for success, some error codes, and -1.  Does -1 have special
meaning?

Just curious, and really this unorthodox return value semantic should
be documented into a comment above the function.
