Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010EC21507A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgGFA3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 20:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgGFA3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 20:29:08 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB5DC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 17:29:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q74so14011598iod.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 17:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wY90DJM5VX+/bqtbfcpniSqmUR2Yuc8OZIzp3HwEQA=;
        b=dQUs//ntlhuvLC49UFqLKSDr6KN0O0cu2Xsp+j5LRAPzQvfR3Dm1Nw6MIQrpIAjFxQ
         /mb/qVsxnDz73NVTkUXvbjmhAgUQtUPtcIItGi+ru+U0Fbcl62unqEMsAt2M+LtoN+oL
         BQd7PPVwDpj8UNVF9DYxqBvBwC9EFXfs9YI1z0MtGmwkHPLkm3sDpL3d5Wf1iR1CAnah
         wJ7f2v4myFTALBOu/osePAS9jxckJxYICXsIX4ME4n95evA9PY/0ftVZaeHUYZ+0zmIN
         ToG07xrrgN9jKqu0Z8TyQB4D8pIE+SEqx479W424eoJ1rIm5PaqNhkweMy1TwciC6BUF
         g0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wY90DJM5VX+/bqtbfcpniSqmUR2Yuc8OZIzp3HwEQA=;
        b=ectk1QeeV+syX+fq3KssrrdUAW32wPrgq4OKmideOBlfkX8JxXwUkvGwHcjuInwpD4
         +sKXfiVxZK21b5z1NGzG7VwBalNxFYGugTEYaQNuJX+OyhdcpmU8AmxFSSrDHf2jnfv1
         HH/TmeDN0AClAChauIRTJjzx3JOgDc9xSsXTw6ABrfURaHxu5pudDPKPmckWdZVSz4X1
         QQtxhLFQQyq9l+fwfik1y25LKJUVHOHZvYSEaCV5s9blaO3Mexgm83WFWTcmgQYTCuSh
         ClHXHyESCBGPKrLR/nM7mkdMqGOLsX5Um3Fr3y+0oKhn2wSfvzwk0WvVof5f0yOMB1ZZ
         jt6Q==
X-Gm-Message-State: AOAM531/A4DgbCYJLczdnCvqihLcs9XyWMsR+ob1Rn8/fsYKLbDrQ6fy
        PEXiAwUfBsgD9OdO6Agd4qztoDzuFOHBt6KIZbM=
X-Google-Smtp-Source: ABdhPJw/lqwGapvjOa3hcsQxXuNFOghYiPxqOPl0yv+gcjYFdRMy85g/iM/ziSXNlbskheskUNWT5tXtA6dIauV/Mfw=
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr16014741jao.49.1593995346357;
 Sun, 05 Jul 2020 17:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200701184719.8421-1-lariel@mellanox.com> <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com> <7c673079-043d-927b-fba2-e7a27d05f3e2@mojatatu.com>
In-Reply-To: <7c673079-043d-927b-fba2-e7a27d05f3e2@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 5 Jul 2020 17:28:55 -0700
Message-ID: <CAM_iQpXLBrJggTQU3+MpdHPh1zQcN4T-HCTmqiPaKd6Cda-_2g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 2:50 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> BTW, nothing in skbedit is against computing what the new metadata
> should be.

Yup.

>
> IMO: A good arguement to not make it part of skbedit is if it adds
> unnecessary complexity to skbedit or policy definitions.
>

TCA_HASH_ALG_L4 literally has 4 lines of code, has no way
to add any unnecessary complexity to skbedit. (The BPF algorithm
does not belong to skbedit, obviously.)

Thanks.
