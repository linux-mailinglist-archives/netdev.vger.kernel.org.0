Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768A21A52E9
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgDKQi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 12:38:27 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44529 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgDKQi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 12:38:27 -0400
Received: by mail-lf1-f67.google.com with SMTP id 131so3427960lfh.11
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 09:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHjNiAPiJ1Oz2tFcDWgKOCe+L+oTgqAXQPJRZQ/4hzk=;
        b=fURPhmhZDafu3/qkIgLMIEfe4A4py1LqcCqCeBR+aVwJ7drlaVanUhZYjyx5KCUiZx
         KGDD6HlS++yVH8L88Y7vc/HiMTfe8JLWu5zgSXu8r7QLGa8LZ7tfbZa2cOHm/M603dUP
         wu/c+M9wGg8Em1o8TiiYeR2NppvuUZeOBDKjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHjNiAPiJ1Oz2tFcDWgKOCe+L+oTgqAXQPJRZQ/4hzk=;
        b=cybWmibvjITgPuKMdvUNGJaIAYB1c3qe2bRP4kZBVnvZq3rl7MZZWmqzd08IwdLsbc
         frIXYNZ1yLmKjC8ffeBdSO2Jnbme3JCLzNVfj9hDwPUtS9Rs1wbftIV2fLsEn82V0iFR
         Vwkg2DIEG8nRTPOQjrcBf7IPFVMPRVQLi2sFilcop7H86jCpuEkQ/G4KnNiuWWVzL0gZ
         xL8XnGE3N425hzGdsP325cxVE7aNcjZjzXiU4Z0+BlmSUKQmcOMWVO5b64h5AoXnOYc6
         4hp1F+rnWzASoRCqkNIcy2Q/dLXiX0AoCrDrO1dpnRUO+JlfmnvEo/nvpmIVMoiwDbvi
         nbxQ==
X-Gm-Message-State: AGi0PubKX6rDjTblJdseS7xoJzbDoOiQ/B6ilqHpnNBN3uZqsjSO8e71
        PLzWAKBXSyu3dt8lKso63Cc36GuUE+w=
X-Google-Smtp-Source: APiQypKbu4vI8ocXF2lu0/EKuhf256kQuy/oWeg5EjkreoEZFSWTJ4INdvjgaCSBzGID7TAamLeIhg==
X-Received: by 2002:ac2:4853:: with SMTP id 19mr5508808lfy.171.1586623103244;
        Sat, 11 Apr 2020 09:38:23 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id h9sm1192282lji.30.2020.04.11.09.38.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 09:38:22 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id v16so4811618ljg.5
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 09:38:21 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr6327984ljj.265.1586623101184;
 Sat, 11 Apr 2020 09:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200406171124-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200406171124-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Apr 2020 09:38:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
Message-ID: <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
Subject: Re: [GIT PULL] vhost: fixes, vdpa
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, eperezma@redhat.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        lingshan.zhu@intel.com, Michal Hocko <mhocko@kernel.org>,
        Nadav Amit <namit@vmware.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>, tiwei.bie@intel.com,
        tysand@google.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <wei.w.wang@intel.com>,
        xiao.w.wang@intel.com, yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 2:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> The new vdpa subsystem with two first drivers.

So this one is really annoying to configure.

First it asks for vDPA driver for virtio devices (VIRTIO_VDPA) support.

If you say 'n', it then asks *again* for VDPA drivers (VDPA_MENU).

And then when you say 'n' to *that* it asks you for Vhost driver for
vDPA-based backend (VHOST_VDPA).

This kind of crazy needs to stop.

Doing kernel configuration is not supposed to be like some truly
horrendously boring Colossal Cave Adventure game where you have to
search for a way out of maze of twisty little passages, all alike.

                Linus
