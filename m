Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEA7AB49
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbfG3Opu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:45:50 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40486 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730143AbfG3Opu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:45:50 -0400
Received: by mail-yb1-f195.google.com with SMTP id j6so1101137ybm.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/guRCHmkoiQgbLkV2hP5gvAMj/4JhzXH6fZBt0bRt0=;
        b=FMxw9VHQbaz5Pm+gKxft4hBckyun1hoRSl2ECYX3D07klrEVIGV++mIj/8WSxgYVoG
         eF3dRnV5FO6jFDomolrgm9c2BvUFJMN4QqY3UeKTBjm5ZShZ6Xm/cLjPgEIqz8+c/bIX
         dRspb2h7BrkEiNiwW2iWVfJ5adzCpEL/z87ch4I+zTAt86UOGxtLunwJXeob2ExGhhlU
         W13lOe6Vk09hdwoki7rZSTEKjOB6aRuEM8p0lCxdYql6Ujcg3Ydy+tUs76nCzC50kNvZ
         rMTp62jYZdX9/PnEmymS4VuaEp/tRD5wMC/ZJicPhqsu1Jbd6z2KALDSzw+yuF9ypo4x
         6qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/guRCHmkoiQgbLkV2hP5gvAMj/4JhzXH6fZBt0bRt0=;
        b=aCVQ0Leccfrg91LTgsFBwVZwhmI86meTRmQrTN8FYY7MhP5+filEtR6iDx6zAXxOj4
         QpwDX2COrqIi342O8whVHHQIZTIAVG4iU4hcXUhPjA7sBOz59ASICh5jUylOB5EqVpV8
         F+aM5O6e50qSguUTx+jPAo5Hor0ddAphE48MLnCSZv1EIJjGnD/N8wD1zRypNAgTu8bV
         8FXzuHSFjCjdm2OedSXUYbviOj9YQeH+fLWKn2eKKFPitKv96r2UUwcSPlH22ThoHbVM
         RlPjEXgloL/rhBxbRnm67lrOS/yrAZfaetMNzA81ov7FmIGTFZ2JPVskmWYimGnSuOCT
         0l6g==
X-Gm-Message-State: APjAAAXPB87rvOAm6ec/+FAu6IEUZBbW5PiT76ayzPUpr7QF3aKPacfs
        7GongtiAn3xJgyuM4SvC1rg4/ZA1
X-Google-Smtp-Source: APXvYqwpuh1mDrlmqG89gGtmgYD3J4TcAg9FC3BtCybTbnVmTYjNXHipm6jLFsqLZPwtu987Qun9eg==
X-Received: by 2002:a25:bc82:: with SMTP id e2mr69067236ybk.12.1564497948822;
        Tue, 30 Jul 2019 07:45:48 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id s188sm14774640ywd.7.2019.07.30.07.45.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:45:47 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id u141so23871063ywe.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:45:46 -0700 (PDT)
X-Received: by 2002:a81:9987:: with SMTP id q129mr69255613ywg.190.1564497946168;
 Tue, 30 Jul 2019 07:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190730113226.39845-1-dkirjanov@suse.com>
In-Reply-To: <20190730113226.39845-1-dkirjanov@suse.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jul 2019 10:45:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfnqV4zGvW+W0fh+=X-wm8rz1O5ZqGKXpxSVN1vPMD+sw@mail.gmail.com>
Message-ID: <CA+FuTSfnqV4zGvW+W0fh+=X-wm8rz1O5ZqGKXpxSVN1vPMD+sw@mail.gmail.com>
Subject: Re: [PATCH net-next] be2net: disable bh with spin_lock in be_process_mcc
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com,
        Network Development <netdev@vger.kernel.org>,
        Denis Kirjanov <kdav@linux-powerpc.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 7:33 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
> Signed-off-by: Denis Kirjanov <kdav@linux-powerpc.org>

This is a partial revert of the previous change to these lines in 2012
in commit 072a9c486004 ("netpoll: revert 6bdb7fe3104 and fix be_poll()
instead").

The commit message is empty. Can you give some context as to why this
is needed and correct?
