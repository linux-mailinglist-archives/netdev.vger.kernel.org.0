Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52278D67E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfHNOr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:47:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34403 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:47:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id b24so3203752pfp.1;
        Wed, 14 Aug 2019 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=+bfgMzTl7z9Y6DJNVLvjkdqFQ1VmcHfYDw/wszdBB/0=;
        b=X2XwwVDGzuGz6/0z5RsERMw2Ub9WInmFP03LEyT2f8JNPHLqSZkC1LZvgm/52+af65
         O8fZq+T9yx7pplCSHbbzYR8+nx7xz+jYnjtof69KPBkSWaIee+/dS99xQBGyS/Ow2S1v
         ov3ysC1qBNgzPaXlG0a83V6+Vz64OQODczPMlli9/EsaA7SZLREx7nPmD5GawP4MUk8B
         CfMtIuusoNyg+pfMZ7RR/KYwkrjygerAj8MJvBwd+YPOg2lWLeHgl+yQPMru89I6qX9W
         o9gRuz9eJkkcaB3t1uuj+IJCh+yyg1T/iJDO6Qu9tiRo3rZ/eRM5F1vWOGMqIE+w5DyM
         LZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=+bfgMzTl7z9Y6DJNVLvjkdqFQ1VmcHfYDw/wszdBB/0=;
        b=HX1jKjM0UpmU6Q/yigVBjYsNFENgHitN5WIm14UgIp2hNhS9RATB0fwqDxzv29Md4p
         H2mQ4ui3ijjmkhG4mHy/Cbtv65ElQDr+ryhShFPXGkP+ZDaIxAyU1U6xZGb53HV3QG2q
         vC7Pbh0dML3th5UVhCqXnOaZYcNBMFkqVNaJvF5Fku89bCVLAhDHFZBcBtgYOlQLINqS
         DaYeDzcfzLKsEwaFI1GtZKeBFRiqGB2W/lFLSCUGtciczAB2TP1MQlp/V7u5oAh66O/G
         Ur1xR4t6O/UlxiF44fLlsYem66duCEyBfapu665Y0D3JG1dvnZLvln5d7jpHMpPr75KQ
         Chtw==
X-Gm-Message-State: APjAAAWzua2G6Cq85R2l+2VrOro4Qo2A2276aGtjgQdrq2twTlNuHLQL
        mNTe9WuFc0xcaqp38SDG6JE=
X-Google-Smtp-Source: APXvYqw0WB3o+N7IJOrL257UyMoZNcm9pS+lgtDN+iApwhFzkLAQqG9TZG01NXjoXJ/ZmuPBjD/kOQ==
X-Received: by 2002:a63:2a08:: with SMTP id q8mr38941051pgq.415.1565794048667;
        Wed, 14 Aug 2019 07:47:28 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id v184sm12995pfb.82.2019.08.14.07.47.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:47:28 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 2/8] xsk: add support for need_wakeup flag in
 AF_XDP rings
Date:   Wed, 14 Aug 2019 07:47:26 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <238E96EC-0BE7-461C-8FF8-509997EEBA31@gmail.com>
In-Reply-To: <1565767643-4908-3-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-3-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This commit adds support for a new flag called need_wakeup in the
> AF_XDP Tx and fill rings. When this flag is set, it means that the
> application has to explicitly wake up the kernel Rx (for the bit in
> the fill ring) or kernel Tx (for bit in the Tx ring) processing by
> issuing a syscall. Poll() can wake up both depending on the flags
> submitted and sendto() will wake up tx processing only.
>
> The main reason for introducing this new flag is to be able to
> efficiently support the case when application and driver is executing
> on the same core. Previously, the driver was just busy-spinning on the
> fill ring if it ran out of buffers in the HW and there were none on
> the fill ring. This approach works when the application is running on
> another core as it can replenish the fill ring while the driver is
> busy-spinning. Though, this is a lousy approach if both of them are
> running on the same core as the probability of the fill ring getting
> more entries when the driver is busy-spinning is zero. With this new
> feature the driver now sets the need_wakeup flag and returns to the
> application. The application can then replenish the fill queue and
> then explicitly wake up the Rx processing in the kernel using the
> syscall poll(). For Tx, the flag is only set to one if the driver has
> no outstanding Tx completion interrupts. If it has some, the flag is
> zero as it will be woken up by a completion interrupt anyway.
>
> As a nice side effect, this new flag also improves the performance of
> the case where application and driver are running on two different
> cores as it reduces the number of syscalls to the kernel. The kernel
> tells user space if it needs to be woken up by a syscall, and this
> eliminates many of the syscalls.
>
> This flag needs some simple driver support. If the driver does not
> support this, the Rx flag is always zero and the Tx flag is always
> one. This makes any application relying on this feature default to the
> old behaviour of not requiring any syscalls in the Rx path and always
> having to call sendto() in the Tx path.
>
> For backwards compatibility reasons, this feature has to be explicitly
> turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
> that you always turn it on as it so far always have had a positive
> performance impact.
>
> The name and inspiration of the flag has been taken from io_uring by
> Jens Axboe. Details about this feature in io_uring can be found in
> http://kernel.dk/io_uring.pdf, section 8.3.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
