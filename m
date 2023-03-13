Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE776B7F6F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCMRZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCMRZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:25:26 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12892A6F8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:25:00 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i3so13766469plg.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678728241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yz8oEDJ/77aW7LqMjEdCVKI+U4V++estSGqzJEv2OnU=;
        b=cPxndz4sfLJJO1DZqFSdQkF5BX3CtrNw1Vz+i3PiIWk8TFTmtX0nKa42ZGBPj5qjGa
         Z6MhjZOlTikIFsaRwavWseNjhMZFpgI5JztqgSlJG1YTnuaDsfTuaQRixrGJ8roZpw7v
         tmRKhK9WPGZU8NYBk9eWU72S61E/iU9zaxepedy/8hK2Kyr6KEfphokkeYkX8rYN5Sms
         PQ4+s5WPZ8HpoLfMXS3n0cJBvWJ+fFsJDxWW7hf4SQAdMLl9MurR/druscKS/vnp8Tnn
         H/IWgXIY4Orr3ov18QfAk1Ac6r21Uv9ZOXldmCDMbtoObSufuPkbY5wdL6QQrac8aEB3
         bxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yz8oEDJ/77aW7LqMjEdCVKI+U4V++estSGqzJEv2OnU=;
        b=TTBFJfIfTA03Kk7GoZxIAyh6KTLXjEjP79qsIt8lDDVjmm1kcJtqlcE7NyhXg//fL1
         B+UFtJZpQjCsEKTETmYTZoFQdBqewQIifDjfuSIUJwfHt+mCM+744gMWbqEru/oU67AC
         w+Zl1NFp5sIBbD1RDAQTw00FHLJ6dhmySELjtQ9HLn5dzoBKaOfqnL5LKEUIVtotbHPl
         YYNim1RLPP6TyoafajK6tnIoRpmHM7dterQz4/DW0EERLVdR+L2lPCTasVfTSj/bb9C/
         O0mYG+93ztRm7y4hOD5DCtkeOiKz+fX2NtGrmQV4VNGUH4cICuc2SkmuWdIF86yBpJ+p
         46Gg==
X-Gm-Message-State: AO0yUKUpLwrlynIfiz3JPXsDTeEnPS6B/d2SVZFkaqu7Eyi946GYlrkP
        bD84k7ALRevRcUBT8jcXN9nm2Q==
X-Google-Smtp-Source: AK7set9QbA7y6ovAucuBjySPyqrEcVGNWMeLrhWXx5qC8VEUXFp8CTDJ9svRmraSTw+rMt43+gW6ew==
X-Received: by 2002:a05:6a20:3d02:b0:bc:42f9:6b21 with SMTP id y2-20020a056a203d0200b000bc42f96b21mr43192268pzi.15.1678728241100;
        Mon, 13 Mar 2023 10:24:01 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t14-20020a62ea0e000000b005d3901948d8sm9500pfh.44.2023.03.13.10.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 10:24:00 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:23:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jorge Merlino <jorge.merlino@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Add symlink in /sys/class/net for interface altnames
Message-ID: <20230313102359.7054d058@hermes.local>
In-Reply-To: <20230313164903.839-1-jorge.merlino@canonical.com>
References: <20230313164903.839-1-jorge.merlino@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 13:49:03 -0300
Jorge Merlino <jorge.merlino@canonical.com> wrote:

> Currently interface altnames behave almost the same as the interface
> principal name. One difference is that the not have a symlink in
> /sys/class/net as the principal has.
> This was mentioned as a TODO item in the original commit:
> https://lore.kernel.org/netdev/20190719110029.29466-1-jiri@resnulli.us
> This patch adds that symlink when an altname is created and removes it
> when the altname is deleted.
> 
> Signed-off-by: Jorge Merlino <jorge.merlino@canonical.com>

What about if altname is changed?
