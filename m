Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16828D757
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfHNPle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:41:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42507 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfHNPlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:41:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id y1so487856plp.9;
        Wed, 14 Aug 2019 08:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=A4Rxd200j00xiq48qsdaEzJnhe23VeGpskQxHrue20o=;
        b=MF5oaFy7zhu1XET6aWH8DvZKm/S+BXbMmVzQmOHd9PDB9+ZQ9mdkoC4BQFEp+XY5zG
         /DbUUN4i8h3F5osQdAwKDzn7yywa/tXIvMp053XWIs1vKbHavMvwp8rHhZAPoVcH+ql4
         7UORlZJq7JaWaxeGIKxBuWVm2sR9gN6a9JfcEp9pPKJmyPEKsdhA+xr4VYWv1mNJu05x
         we7uTWZte+hGWiBubPRTGPjGY2uh178iXJLwL1a2qVOS6cEzUnIQR0KY+tT597WEu64o
         ZXTJgAyd65hlMLhwJXmn7+mGQfsbQit6zc6H4eZDkII3p/bCVqw2e0XTWmEXhxT7XEyC
         206g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=A4Rxd200j00xiq48qsdaEzJnhe23VeGpskQxHrue20o=;
        b=MPCW2/tP6qTDaoPE9kjn5zdt1uTMBPA0lkzkdYGePzbFGSMrVqeEqLYYSYI5ALynpX
         q56tzs+AnVJpK89ZErbpKVBnkQeQUErXfPp5AiE2LrCbIBVVijJH2dluTXxVcUFUUPKJ
         pr1jcReiNM34dJ/47R701cOpZDEv+r8544E9FJd4uMBWn6zMDEypUI1S1BSnNg/gfTqI
         Mnl9MPG4uHMVmhuC2/lxq41YIAOQiRjSlJrDnJldxN5SCVDY+I3Us2xD7VXJlYdOlhdI
         H8++EZ1o9fKdANz6/F5FGXZd9ykW8OScRQ3gbj68GfqkxIaJLfxMumpISSwwQRgWWZn6
         xfMA==
X-Gm-Message-State: APjAAAWbWAMRETukTruFW4Hd711RFxp0bzsIb4EtPOed17IfQeJFwkng
        qxTuNxGrdrkY9sAmT1XlCJk=
X-Google-Smtp-Source: APXvYqxLUw57lXhjtooJWVoWXHXuORVhgljCxNXzthbyWBmRv+HF3ckdxnvC2f6Vf0cL83CQye8JFg==
X-Received: by 2002:a17:902:8345:: with SMTP id z5mr65579pln.29.1565797291885;
        Wed, 14 Aug 2019 08:41:31 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id s72sm65545pgc.92.2019.08.14.08.41.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:41:31 -0700 (PDT)
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
Subject: Re: [PATCH bpf-next v4 3/8] i40e: add support for AF_XDP need_wakeup
 feature
Date:   Wed, 14 Aug 2019 08:41:29 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <DA842C18-42DF-4559-A746-F0B428B3CAB5@gmail.com>
In-Reply-To: <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This patch adds support for the need_wakeup feature of AF_XDP. If the
> application has told the kernel that it might sleep using the new bind
> flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it has
> no more buffers on the NIC Rx ring and yield to the application. For
> Tx, it will set the flag if it has no outstanding Tx completion
> interrupts and return to the application.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
