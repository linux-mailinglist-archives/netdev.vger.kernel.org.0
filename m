Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7437324306D
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHLVQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgHLVQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:16:51 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455CCC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 14:16:51 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z6so4585349iow.6
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 14:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=h4M69430nR1pS53r9bUi2Zzgztsu1K0gn+/eIjVXJuw=;
        b=sWuJz7t/efgDisJqydAci5RZKmQiVKgmHkXNG0wqp6jfuNezTlwdzAgXcQmXng4G29
         w8TInoKXSGhk26Glzi2QYF7/DBGjfE48C1j83hWHPsKJaTMO8P1JSUytOfc8Z6b6TghW
         xTxQEvmqFCznnCVLub9kl0JOH837L+S9TrHwG+ApTstelDmkm9QsKfFQQgAbSLSTsGzb
         kQ+V1lgwoCd3+hgwqfVBLkyF1EH4DM/xnAKO3h424sGtNONg3DI2zYjRfcVoeawH/URa
         lBgdQwLErxV6WdnYFEgC8LOt41O6jt/3tai37SuVq7KTLsbko/ZxBpux0bWn1T18n4lb
         Vz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=h4M69430nR1pS53r9bUi2Zzgztsu1K0gn+/eIjVXJuw=;
        b=UUPtaRcn8UZ8yzB1V1X5BxGvsbnbdSmTjitxtxzxae6Lh/F2xdtYfGgsoL2Ke/F68y
         4EP/7Mb3Uw6rGDNdaVkGKSuu9AzftXYG+RMPbd2LnJd2Thgvf6BaI9Ic0TjgZm2fkDxl
         YROK8GgWiofb+1sTiMjP3gOzm40b17RLssoCzOOUCdq/ijoH3IR0c/dQIt/o3RrGFr6i
         ufw5xojnPJSRRBkvscNvHHoGhjfyOiD8cgiGC9dZnr4lWiqfIIRpyPlSpbJoEQoLjDoh
         PduJHErlzBjyScVQaiCKVCu1hueCDyLLPRomwD7l8SasVGWx8CcML7+tRLRzcis8Bp6I
         VQ6Q==
X-Gm-Message-State: AOAM533wuAxrDOVCb840jN9Hfsv0OBm0uSs85n2CFJGJaoEpBeGj1Z/J
        jRhljHXY3oSXPww7a4L+vq3T3Q505OMc2BPaSN3522jY/7Y=
X-Google-Smtp-Source: ABdhPJzt4Lg/xqB67mBF5Ea4UqBNU0rFyf1PVtIlWkqwY1BEYqfFrciEE619ABvC5ZpYbbuRxeM9BBuKauvy7hePR0o=
X-Received: by 2002:a5d:9c0c:: with SMTP id 12mr1760635ioe.142.1597267010078;
 Wed, 12 Aug 2020 14:16:50 -0700 (PDT)
MIME-Version: 1.0
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Thu, 13 Aug 2020 00:16:16 +0300
Message-ID: <CAE_-sd=_2Skp4wY51rerHopU0ZiKPDxQ5Hd0F8qZTOrC7qNYRg@mail.gmail.com>
Subject: tc -j filter show with actions is not json valid
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everybody!

Could you help me, please?

I use Debian 10 and iproute2 version iproute2

dpkg -l iproute2
iproute2       4.20.0-2 amd64

My problem is this:
I can't convert "tc -j filter show u32" command to  json format.
Here it is command:
tc qdisc add dev eno1 ingress
tc filter add dev eno1 parent ffff: protocol all u32 match u8 0 0
action mirred egress mirror dev lo

Have a look:

~$ tc -j filter show parent ffff: dev eno1
[{
        "protocol": "all",
        "pref": 49152,
        "kind": "u32",
        "chain": 0
    },{
        "protocol": "all",
        "pref": 49152,
        "kind": "u32",
        "chain": 0,
        "options": {fh 800: ht divisor 1 }
    },{
        "protocol": "all",
        "pref": 49152,
        "kind": "u32",
        "chain": 0,
        "options": {fh 800::800 order 2048 key ht 800 bkt 0 terminal
flowid ??? not_in_hw
  match 00000000/00000000 at 0
            "actions": [{
                    "order": 1,
                    "kind": "mirred",
                    "mirred_action": "mirror",
                    "direction": "egress",
                    "to_dev": "lo",
                    "control_action": {
                        "type": "pipe"
                    },
                    "index": 1,
                    "ref": 1,
                    "bind": 1
                }]
        }
    }
]


May be problem when there is actions in tc filter the problem is... I
don't know about it.
Have a look:

"options": {fh 800::800 order 2048 key ht 800 bkt 0 terminal flowid
??? not_in_hw
  match 00000000/00000000 at 0
    "actions":

The json output is not valid.
Has somebody made a patch for fix it?

Thanks a lot for your answers!

-- 
Best regards,
Denis Gubin
