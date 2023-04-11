Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826F76DD398
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDKHGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKHGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:06:54 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07321FE2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:06:52 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id x31so3423405ljq.10
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681196811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xWLFqLmDWmt0Zth7IUEkc/daA4hIfhoAeCe5gJbvC80=;
        b=WsUBgGu4I/zQWjsgFlV1/rIESTuxTozRuc0iDqqFbYXEsVsZ+fzENzCBHha4633gWH
         UpPCyq1MmGflUmoAiLjzAVgyzvj02p0JEtri5RbUSK3u+zpKxmQ8UeQonvqaVJonvdDr
         ZnXvntLbHuJSfFXDAatIk1C2RLD950ErwtuijM8Q9GbxoxR4ZdMTOT7VOHBQLQytUiD2
         WLhUzHgA8oGeV/SxTVY/pXrd8GAgbVgF1RP8zZx24XLIVH0FcL+hUHN0/BmDkxyxbo3V
         nNkgPjFl9dBB2nM8ZjCbzGLaXpPAPKWnAkqrbbiS2unjDP39rPD7i99ENydSZndm8RJJ
         g2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681196811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWLFqLmDWmt0Zth7IUEkc/daA4hIfhoAeCe5gJbvC80=;
        b=VhHCzBhdfxNVo7ysufJP91hGqs1/hQ2cZInrM9gHi1vFcptnmBat5wTUXjRneOFxgC
         gixd4p5aqf1ElmN5V6XVJvD5C0maFNIKu20izeAmPAeXMHt5tZwWqI9jz1KXo0XdeImf
         1hW+PdUBfE//ZXzSlAoKIOpq8p4WK9uJX9yhltatx16B9Zhltzj/zOv1iXvaBJxgAkxp
         Ct+io/52p1aCvNOg5jNQnP/U3ZFUh7jesTXts9es4+HOXEwnuG5OUUQq+oCmoTuPJfoD
         WhZs8kkMxGOJ1s0I3saP6QjUSn/of5SX8iEZWyzcpDyCo8M/+zYOJRhcRt54V+2L+rlb
         jL0Q==
X-Gm-Message-State: AAQBX9e2NcZN4/OOLtmDYyfoNxGgkH0HF6su90Kgn8GJclbOcO+T2r0p
        u3TGjtABIBXvBEQRYQTaHbl8DGWRgJXHr2fIM5m6NQ==
X-Google-Smtp-Source: AKy350bMi0aQpqyGht3Q9mFF+O4C25IT2795IKMLIZA/67AP3GolkoVcIF43JXlQn2ch0G3xs6YG7KW00BQwwADVExA=
X-Received: by 2002:a2e:3015:0:b0:2a7:8a4c:4c1d with SMTP id
 w21-20020a2e3015000000b002a78a4c4c1dmr523442ljw.8.1681196810845; Tue, 11 Apr
 2023 00:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e8fd1f05ed75bf20@google.com> <000000000000a5727605f7c2f407@google.com>
In-Reply-To: <000000000000a5727605f7c2f407@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 11 Apr 2023 09:06:38 +0200
Message-ID: <CACT4Y+YkCX9kmu24NGPV_fZQ6fK9aWSJQMY1SQ8G80zsU+DqnQ@mail.gmail.com>
Subject: Re: [syzbot] [nfc?] possible deadlock in nci_start_poll
To:     syzbot <syzbot+f1f36887d202cea1446d@syzkaller.appspotmail.com>
Cc:     bongsu.jeon@samsung.com, davem@davemloft.net, edumazet@google.com,
        hdanton@sina.com, krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linma@zju.edu.cn, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Mar 2023 at 01:46, syzbot
<syzbot+f1f36887d202cea1446d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit b2e44aac91b25abbed57d785089c4b7af926a7bd
> Author: Dmitry Vyukov <dvyukov@google.com>
> Date:   Tue Nov 15 10:00:17 2022 +0000
>
>     NFC: nci: Allow to create multiple virtual nci devices
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117e50c1c80000
> start commit:   0b1dcc2cf55a Merge tag 'mm-hotfixes-stable-2022-11-24' of ..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=436ee340148d5197
> dashboard link: https://syzkaller.appspot.com/bug?extid=f1f36887d202cea1446d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125fa5c5880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12508d3d880000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: NFC: nci: Allow to create multiple virtual nci devices
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix: NFC: nci: Allow to create multiple virtual nci devices
