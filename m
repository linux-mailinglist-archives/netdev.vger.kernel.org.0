Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163262241F
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 18:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbfERQuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 12:50:02 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:43022 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbfERQuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 12:50:02 -0400
Received: by mail-it1-f198.google.com with SMTP id z66so9579334itc.8
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 09:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/+qIz3tApBlHUL41YqHiyHFDjU+/tNH+rU6/UEVFdzY=;
        b=rMMkaOzPxXZeEy0n1JMRY78xMIwW0cqLeAJ0FNVkJ9DTJhI+5Rpwn+wOZGP1t1Y+qz
         WpFDfQ1SYGxyzjIA8nxozQdt80SSajTovrsgAEn1gqwbHJSuFVpc8iXU44WcFDuycMAG
         v/lWxxDiAqIFh2cEBvt+vDjGTjtvTisZc4dLTukuu5U4mEeqoF7ycyvP7oeyUo8PhkiM
         eGqVzLRAO5Ut11zT3PaUAH+L2UgmLNZSbi8JJ20xS+E9NtFghEyJYnGQf2Sm57HJOKl6
         bKwkxnlQa9ZBfXHYG5AuSWESlTEx9mYT1SKSh19LDxchk1edTExA5aeyKEcfzeJUUcId
         XhuQ==
X-Gm-Message-State: APjAAAWzwA6ZUjXNYHxyznTyKascWcUAKjElxYWRhAFn8gMtUZallIGI
        nSLE19Pi8GWpV6EVJd9nsSXr9yBMmsm+xZzUCyEzwEixzOOQ
X-Google-Smtp-Source: APXvYqxUBs5j99DSEzisXC8LwzZ/FgRp3siun721j4spsgsHFKXBLU0iDc0Eaa8XOQT9eRKB980P5pChQ1niwiboZ5SJp2HRBiRB
MIME-Version: 1.0
X-Received: by 2002:a5d:9e0f:: with SMTP id h15mr4074235ioh.48.1558198201062;
 Sat, 18 May 2019 09:50:01 -0700 (PDT)
Date:   Sat, 18 May 2019 09:50:01 -0700
In-Reply-To: <Pine.LNX.4.44L0.1905181202500.7855-100000@netrider.rowland.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000043a1f905892c4a1f@google.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
From:   syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@gmail.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

si/sg.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/rootgp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/rootgv100.o
   CC      drivers/scsi/ch.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/roottu102.o
   CC      drivers/scsi/ses.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/changf119.o
   CC      drivers/scsi/scsi_sysfs.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/changv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/dmacnv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/dmacgf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/dmacgp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/dmacgv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/basenv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/baseg84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/basegf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/basegp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/corenv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coreg84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coreg94.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coregf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coregk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coregp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/coregv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlynv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlyg84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlygt200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlygf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlygk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/ovlygp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/wimmgv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/wndwgv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/piocnv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/piocgf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/cursgf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/cursgp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/cursnv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/cursgv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/oimmnv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/oimmgf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/disp/oimmgp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/nv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/gf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/gv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/user.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/usernv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/usernv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/usergf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/usergf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/dma/usergv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/nv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/nv10.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/nv17.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/nv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/g84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk110.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk208.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gm107.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk20a.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gm200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gm20b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gp100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gp10b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/tu102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/chan.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/channv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmanv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmanv17.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmanv10.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmanv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmanv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/dmag84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifonv50.o
   AR      drivers/net/ethernet/sun/built-in.a
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifog84.o
   AR      drivers/net/ethernet/built-in.a
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifogk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifogf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifogv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/usergv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/usertu102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv15.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/fifo/gpfifotu102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv10.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv17.o
scripts/Makefile.build:486: recipe for target 'drivers/net' failed
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv25.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv20.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv2a.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv30.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv34.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv35.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv44.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/g84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gt200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/mcp79.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gt215.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/mcp89.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf110.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf108.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf117.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gk110.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gk110b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gk208.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gm107.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gm200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gm20b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gp100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gp104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gp107.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/gp10b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf108.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf110.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf119.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf117.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk20a.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm20b.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mpeg/nv31.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mpeg/nv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mpeg/nv44.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mspdec/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mpeg/g84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mpeg/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mspdec/g98.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mspdec/gt215.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mspdec/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/mspdec/gk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msppp/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msppp/g98.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msppp/gt215.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msppp/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/g98.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/mcp89.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/gt215.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/msvld/gk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/nvdec/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/nvdec/gp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/g84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gt200.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gt215.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gf108.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/nv40.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gf117.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/gk104.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sec2/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sec/g98.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/pm/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sec2/gp102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sec2/tu102.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/base.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/nv04.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/nv10.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/nv50.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/gf100.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/chan.o
   CC      drivers/gpu/drm/nouveau/nouveau_acpi.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/vp/g84.o
   CC      drivers/gpu/drm/nouveau/nvkm/engine/sw/nvsw.o
   CC      drivers/gpu/drm/nouveau/nouveau_debugfs.o
   CC      drivers/gpu/drm/nouveau/nouveau_drm.o
   CC      drivers/gpu/drm/nouveau/nouveau_hwmon.o
   CC      drivers/gpu/drm/nouveau/nouveau_ioc32.o
   CC      drivers/gpu/drm/nouveau/nouveau_led.o
   CC      drivers/gpu/drm/nouveau/nouveau_nvif.o
   CC      drivers/gpu/drm/nouveau/nouveau_usif.o
   CC      drivers/gpu/drm/nouveau/nouveau_bo.o
   CC      drivers/gpu/drm/nouveau/nouveau_gem.o
   CC      drivers/gpu/drm/nouveau/nouveau_mem.o
   CC      drivers/gpu/drm/nouveau/nouveau_backlight.o
   CC      drivers/gpu/drm/nouveau/nouveau_vga.o
   CC      drivers/gpu/drm/nouveau/nouveau_vmm.o
   CC      drivers/gpu/drm/nouveau/nouveau_ttm.o
   CC      drivers/gpu/drm/nouveau/nouveau_bios.o
   CC      drivers/gpu/drm/nouveau/nouveau_prime.o
   CC      drivers/gpu/drm/nouveau/nouveau_connector.o
   CC      drivers/gpu/drm/nouveau/nouveau_sgdma.o
   CC      drivers/gpu/drm/nouveau/nouveau_dp.o
   CC      drivers/gpu/drm/nouveau/nouveau_display.o
   CC      drivers/gpu/drm/nouveau/nv04_fbcon.o
   CC      drivers/gpu/drm/nouveau/nv50_fbcon.o
   CC      drivers/gpu/drm/nouveau/nouveau_fbcon.o
   CC      drivers/gpu/drm/nouveau/nvc0_fbcon.o
   CC      drivers/gpu/drm/nouveau/dispnv04/arb.o
   CC      drivers/gpu/drm/nouveau/dispnv04/crtc.o
   CC      drivers/gpu/drm/nouveau/dispnv04/cursor.o
   CC      drivers/gpu/drm/nouveau/dispnv04/dac.o
   CC      drivers/gpu/drm/nouveau/dispnv04/dfp.o
   CC      drivers/gpu/drm/nouveau/dispnv04/disp.o
   CC      drivers/gpu/drm/nouveau/dispnv04/hw.o
   CC      drivers/gpu/drm/nouveau/dispnv04/overlay.o
   CC      drivers/gpu/drm/nouveau/dispnv04/tvmodesnv17.o
   CC      drivers/gpu/drm/nouveau/dispnv04/tvnv04.o
   AR      drivers/scsi/built-in.a
   CC      drivers/gpu/drm/nouveau/dispnv04/tvnv17.o
   CC      drivers/gpu/drm/nouveau/dispnv50/disp.o
   CC      drivers/gpu/drm/nouveau/dispnv50/lut.o
   CC      drivers/gpu/drm/nouveau/dispnv50/core507d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/core.o
   CC      drivers/gpu/drm/nouveau/dispnv50/core907d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/core827d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/core917d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/corec37d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/corec57d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/dac907d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/dac507d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/pior507d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/sor507d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/sor907d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/sorc37d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/head.o
   CC      drivers/gpu/drm/nouveau/dispnv50/head507d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/head827d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/head907d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/headc37d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/head917d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/headc57d.o
   CC      drivers/gpu/drm/nouveau/dispnv50/wimm.o
   CC      drivers/gpu/drm/nouveau/dispnv50/wimmc37b.o
   CC      drivers/gpu/drm/nouveau/dispnv50/wndwc37e.o
   CC      drivers/gpu/drm/nouveau/dispnv50/base.o
   CC      drivers/gpu/drm/nouveau/dispnv50/wndwc57e.o
   CC      drivers/gpu/drm/nouveau/dispnv50/wndw.o
   CC      drivers/gpu/drm/nouveau/dispnv50/base907c.o
   CC      drivers/gpu/drm/nouveau/dispnv50/base827c.o
   CC      drivers/gpu/drm/nouveau/dispnv50/base507c.o
   CC      drivers/gpu/drm/nouveau/dispnv50/base917c.o
   CC      drivers/gpu/drm/nouveau/dispnv50/curs.o
   CC      drivers/gpu/drm/nouveau/dispnv50/curs507a.o
   CC      drivers/gpu/drm/nouveau/dispnv50/curs907a.o
   CC      drivers/gpu/drm/nouveau/dispnv50/cursc37a.o
   CC      drivers/gpu/drm/nouveau/dispnv50/oimm.o
   CC      drivers/gpu/drm/nouveau/dispnv50/oimm507b.o
   CC      drivers/gpu/drm/nouveau/dispnv50/ovly.o
   CC      drivers/gpu/drm/nouveau/dispnv50/ovly507e.o
   CC      drivers/gpu/drm/nouveau/dispnv50/ovly827e.o
   CC      drivers/gpu/drm/nouveau/dispnv50/ovly907e.o
   CC      drivers/gpu/drm/nouveau/dispnv50/ovly917e.o
   CC      drivers/gpu/drm/nouveau/nouveau_abi16.o
   CC      drivers/gpu/drm/nouveau/nouveau_chan.o
   CC      drivers/gpu/drm/nouveau/nv04_fence.o
   CC      drivers/gpu/drm/nouveau/nouveau_fence.o
   CC      drivers/gpu/drm/nouveau/nouveau_dma.o
   CC      drivers/gpu/drm/nouveau/nv10_fence.o
   CC      drivers/gpu/drm/nouveau/nv50_fence.o
   CC      drivers/gpu/drm/nouveau/nv17_fence.o
   CC      drivers/gpu/drm/nouveau/nv84_fence.o
   CC      drivers/gpu/drm/nouveau/nvc0_fence.o
   AR      drivers/gpu/drm/nouveau/built-in.a
   AR      drivers/gpu/drm/built-in.a
   AR      drivers/gpu/built-in.a
Makefile:1051: recipe for target 'drivers' failed
make: *** [drivers] Error 2


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=164a0108a00000


Tested on:

commit:         43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15d1ef02a00000

