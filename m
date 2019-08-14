Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB18D68B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfHNOtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:49:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37306 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfHNOtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:49:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id 129so6797783pfa.4;
        Wed, 14 Aug 2019 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=2hx+tTqvJK8Pz3h0BtvO/SZZI9UW7Kk8eC6c3WGNqRg=;
        b=mziiyfuE6w44lXE9EfZ/VTNnPnhIOldk/th2YGGwoFRsUBtecQe8M7+/hgaKMW65RH
         SaQnBBCZgW+2TdoMt3ATR4qJD+zp907Wd/EgaKlvZR0DPuG1ALrMiWycnkfPSZyySzcs
         D0OF0jSYL/6pDvhuUSuy0yfR9QxAtgLOyu+0Tl9N8+GjZVVecHwjoTXB1zQiXL+soY9L
         cfdkUOVhIf2khZYx5QohGV6aZWuUeb3NU68AhwZYYD/rGWd67RqRs90ONHRe3iWNYq65
         dZ26dS8ZKEQ88X2EHoOHkayFUhaLZij5G/RmQQO2M4An8w0RBWVTWwIfrQLiFC4GdjWc
         BHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=2hx+tTqvJK8Pz3h0BtvO/SZZI9UW7Kk8eC6c3WGNqRg=;
        b=NY+ySvpKROXIqyYeq5OaGOXcxWWy5WQBnZrNmbG/I2T6q9X2y4BGqRhA/2qHlqEpbI
         CZewB9er4SnhhfAK6gL/1helez/AhptzBWzUlW+yNDnx+nwjIABd7U0j9JeArFDuahVL
         z3rEk8Go0G56tfMTq9FfiTGDxVM5Qm5/04kL0QYrkoBYFK/ElwHWaceuh8LfGu1cBOBO
         YDGhgfFl07rmr5ww63//9u/1XZujPYlpNcqiEkOYeIJi6G1Gh5ph8+NxvFfuUoKtITCg
         8qjvAFZD3qgLhG/zd7vk7bcPiv6L9+fUnCLSoHVEeLn+JLRS/4S9tIbWqBFXbS/3DKCV
         aNWQ==
X-Gm-Message-State: APjAAAUDxVRzCjBa88Dhd2t5ID6l3uZbOOS5Me6JQnBQBOJTOwpPI/rH
        9vU2P4g0o41RGAu26EL0BiU=
X-Google-Smtp-Source: APXvYqyBWvJa15pge6AkdaHrHw/Wbcpbnns9XmwG1c9sS4MMupQ5S4mwoeWZ5x3VALxbOt4Vk1OfDg==
X-Received: by 2002:a17:90a:c086:: with SMTP id o6mr185669pjs.2.1565794149710;
        Wed, 14 Aug 2019 07:49:09 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id l26sm142758532pgb.90.2019.08.14.07.49.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:49:09 -0700 (PDT)
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
Subject: Re: [PATCH bpf-next v4 5/8] libbpf: add support for need_wakeup flag
 in AF_XDP part
Date:   Wed, 14 Aug 2019 07:49:07 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <CF4AFFE2-D7F3-4C2E-BD31-42441B553EC5@gmail.com>
In-Reply-To: <1565767643-4908-6-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-6-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This commit adds support for the new need_wakeup flag in AF_XDP. The
> xsk_socket__create function is updated to handle this and a new
> function is introduced called xsk_ring_prod__needs_wakeup(). This
> function can be used by the application to check if Rx and/or Tx
> processing needs to be explicitly woken up.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
