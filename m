Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0117F180ECF
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgCKEA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:00:27 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:43826 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgCKEA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:00:27 -0400
Received: by mail-oi1-f175.google.com with SMTP id p125so516544oif.10;
        Tue, 10 Mar 2020 21:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=VkewgkckImO3/cvacOc12GhIahWuHs9c3iTajeqirWBBgk/SBukfkx0AR88XE62dd+
         tgWzwSY4czTtzCHm1n9/Hb45sZHakDFe7U+pYIqJUQyBUC9MQCfluYqrI/yiRfKUzMmj
         Bxmlc8T9R9RH7spLHQ99bOYAY2pIoTM4udNf2Br0AvtvR1XGAtw7iCy8p+xOcesgUtQN
         ndBt2fSToP2JaoRhwpjlFd8W2OqVhhwrDUKl1QXHXE7av+OKH8kxnqbYMaVmzw/SugwC
         Xy8z8Ef0L6C7Tt+oi3c4x1EWwtHtsMzXMGXE+tYRNta61gIgPiPxH6zl/2Mz3z9+I7xg
         KyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=n/Tj8SqAov44HZjzJoVKNhd4Q5QzRhQma8es8naUNwCmQyTJQyBHe1mulS29wjvsHk
         MSG8AwF8DEEDSfpE0S9dIk7dIC+dg+0NFnB5iqYZh9dcuI3SJLfeOOSvVRkN17SR4P8P
         ECAV/jqVKWu2y8gHAPeINpajVBky9iCfyhYS+k730lvYpUe4yjYAMuPpr4dtrppmdfiJ
         HOKtN293bhRUBoQPSAiBuk0/MJRqXhBcll00IWXV25hilSMnZndmMf2zwD8Xu8TqHbkY
         1tXo5ersKSKWIfkeu65di/UQzJ/CWhWxmXoWTNVoB1uEfbY5hjuabCGhqrHAoRO6ytkA
         TScw==
X-Gm-Message-State: ANhLgQ1HR5Yg+Q2iWy13Cmj7X3g3htrWCdO3iAiy/JXfRLymJcJvDddA
        BUbNe1kfbZIVXcWlJuU3bHXnCOXsZ8olUd/E0Ik=
X-Google-Smtp-Source: ADFU+vt5DCH3EKV4urgUxiikT4GCUzKtoPtcxu2ckhkcKXpjrXv/06frAtmJ0IPYz6IynFuaXJjBzBuIccB47ZigVl4=
X-Received: by 2002:aca:d489:: with SMTP id l131mr639426oig.5.1583899225583;
 Tue, 10 Mar 2020 21:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000efa06005a0879722@google.com>
In-Reply-To: <000000000000efa06005a0879722@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 21:00:14 -0700
Message-ID: <CAM_iQpXBb_73wLrBWW7qYfpryWB8zUpMs62d-b0cq3Rw2r2f1w@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tcindex_dump
To:     syzbot <syzbot+653090db2562495901dc@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git tcindex
