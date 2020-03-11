Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA5180EF5
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgCKEgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:36:03 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40175 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgCKEgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:36:03 -0400
Received: by mail-il1-f198.google.com with SMTP id g79so525441ild.7
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 21:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TOW6EyRWWRmr0XeVGg68EU3oaAG/uTESSlfkqLc+cAM=;
        b=li7qTTymSESOtpdaVq4xJ1eUHCPHHt4xFnffPQmAdELUy8a521O/vsNe3ahn1ZqrDA
         4uqVXYsQrnLvZcTtGtxoxRxbdi7qZzvoH0dOpDACHxu2tU9cHZLH35zz38Zhv4WEUjr3
         MZSsrrbusSODGP2d8GVpVE7gzL+hnXRpZAE0V3j6M1dm87YIrQpJKEUWQpu+FBq2cReP
         4rBJI4UKMCNjBqokprOuxH3P6gZyrGT+IoafkB8GxUQnxt36DU+NfURMoiJGS3YTcbvK
         30Kp8sST4XeXyLsHVm/uefNtLxM3QRh3CnLFucF73Tpt8TXdp7mYBiTt03k6//ZhUlEp
         +C6Q==
X-Gm-Message-State: ANhLgQ2aTNruqAOUHlF7d/xtvwpK5YEu4oLujSwS3q52oXasK2v2UG+Z
        HftD2x1YX4H7zjsPhC6R9QRtney1J+SByM7MeyWySeJgw1uf
X-Google-Smtp-Source: ADFU+vux2t/xaiujvf8Y0YWq1KqzivojgudC+oOlyt8deIl3lhzOJSMIuuTOmRBd2XaXjPCRM7y5g8S9EcYG/6ABJbFkK9akhOZH
MIME-Version: 1.0
X-Received: by 2002:a92:7b10:: with SMTP id w16mr1278071ilc.93.1583901362950;
 Tue, 10 Mar 2020 21:36:02 -0700 (PDT)
Date:   Tue, 10 Mar 2020 21:36:02 -0700
In-Reply-To: <0000000000002e20b9059fee8a94@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019196205a08cc67d@google.com>
Subject: Re: WARNING in idr_destroy
From:   syzbot <syzbot+05835159fe322770fe3d@syzkaller.appspotmail.com>
To:     a@unstable.cc, airlied@linux.ie, airlied@redhat.com,
        alexander.deucher@amd.com, b.a.t.m.a.n@lists.open-mesh.org,
        christian.koenig@amd.com, daniel@ffwll.ch, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, kraxel@redhat.com,
        linux-kernel@vger.kernel.org, maarten.lankhorst@linux.intel.com,
        mareklindner@neomailbox.ch, mripard@kernel.org,
        netdev@vger.kernel.org, noralf@tronnes.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tzimmermann@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 5b3709793d151e6e12eb6a38a5da3f7fc2923d3a
Author: Thomas Zimmermann <tzimmermann@suse.de>
Date:   Wed May 8 08:26:19 2019 +0000

    drm/ast: Convert AST driver to |struct drm_gem_vram_object|

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a66fb5e00000
start commit:   63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17a66fb5e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a66fb5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=05835159fe322770fe3d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e978e3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b1a819e00000

Reported-by: syzbot+05835159fe322770fe3d@syzkaller.appspotmail.com
Fixes: 5b3709793d15 ("drm/ast: Convert AST driver to |struct drm_gem_vram_object|")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
