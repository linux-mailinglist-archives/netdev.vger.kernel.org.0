Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085315EB2AA
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiIZUvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiIZUvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:51:37 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FDB5A824;
        Mon, 26 Sep 2022 13:51:36 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id p4so7784060vsa.9;
        Mon, 26 Sep 2022 13:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qKfQ34C5O0rzE70r20R+tBB75q+j778U5ZfxXFszttA=;
        b=BPHvEFMYltn2Rg8aDJxPny0237ec0tFbJGaTtOttAlEIZSm2TcnzNn5ETQhaCYVEA/
         1qY0MRCPSEGPtvV6OJa4pIwvqGU+4Ncve0silNBsx4rvedoSb5MwXkDLo/2JJMKO6YDO
         uDV1svhkfvCNY5bRTIm4UaEewGyshTTQW5W37wbwQv20EMhnSwp2b2mIIW3j9jgxoH2S
         kOSTeNDjg0w60LZwx8judNwqPq4P/fFfyHt44AQOgxdHuQYhpcTnpOws8ApnRvxHUjqT
         W7xAz71SNhJzJVfmp6wCixGNyR+o+JP+Y+gwzOGIkgoDiSl9dHxRXDQv9UayvKO+2AN9
         oaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qKfQ34C5O0rzE70r20R+tBB75q+j778U5ZfxXFszttA=;
        b=1tqum0NvVTXNsDec60A5DYPzMD2n2KcxTiJA4glelV6p0NYPVm8u9rHuZdT+PGoFWX
         395JiSS8QzPV2o1EL5jaWq9r3GmIhPcaVUTP4SnJA7eejZLV/apGPs2m1pz0RmFk/Yx1
         EkkZZ2BCEWKs1TE4img+tZTohTO4mjBt1YqR3nj9Jcaxh1zypFgZ6sR3uq3v7A0zV4v3
         lGE7amj3/SKctRbueT1+2b5mGpcSkfZGfvCPn+IGjLhwQCSzVJ8bstKhV7TbeyJ5Y0sY
         ShCFKbyC81zb8vukHCz6+fsUvYi3CDmCWKeW2RZQTA0k49TzlzWgmWZuV/wK0T4exiOT
         wipg==
X-Gm-Message-State: ACrzQf113IIN2mvLyPSeuVrMsgAj3trBmqkAlAVXcePuqd23oYRQkFjo
        1h7nRbuC2jV6RGpeVBfhFppXNZsZpN22hSoZdzQ=
X-Google-Smtp-Source: AMsMyM61qhvjMNXEsMZbHVi9pCwdwFn2hFbnwr6qFxEtjuqg591fuKkDmD/Cu3PIDRsXc4iH9Pd3znSaSDk3yY/AUJA=
X-Received: by 2002:a67:e314:0:b0:397:f9b2:1b9a with SMTP id
 j20-20020a67e314000000b00397f9b21b9amr9455108vsf.40.1664225495312; Mon, 26
 Sep 2022 13:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220926040524.4017-1-shaneparslow808@gmail.com> <20220926131109.43d51e55@kernel.org>
In-Reply-To: <20220926131109.43d51e55@kernel.org>
From:   Shane Parslow <shaneparslow808@gmail.com>
Date:   Mon, 26 Sep 2022 13:51:23 -0700
Message-ID: <CALi=oTY7Me6g1=jtnZig-MzS-TPOOMQ53ih-78QuF-K+Rs0rUw@mail.gmail.com>
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel mapping
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 13:11:09 -0700 Jakub Kicinski wrote:
> On Sun, 25 Sep 2022 21:05:24 -0700 Shane Parslow wrote:
>> This patch fixes the control channel mapping for the 7360, which was
>> previously the same as the 7560.
>>
>> As shown by the reverse engineering efforts of James Wah [1], the layout
>> of channels on the 7360 is actually somewhat different from that of the
>> 7560.
>>
>> A new ipc_chnl_cfg is added specifically for the 7360. The new config
>> updates channel 7 to be an AT port and removes the mbim interface, as
>> it does not exist on the 7360. The config is otherwise left the same as
>> the 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
>> In ipc_imem, a special case for the mbim port is removed as it no longer
>> exists in the 7360 ipc_chnl_cfg.
>>
>> As a result of this, the second userspace AT port now functions whereas
>> previously it was routed to the trace channel. Modem crashes ("confused
>> phase", "msg timeout", "PORT open refused") resulting from garbage being
>> sent to the modem are also fixed.
>
> What's the Fixes: tag for this one?

There isn't currently an open bug report for this. I can open one if that
is preferred.
The gist is that previously, any writes to the 2nd userspace AT port
would crash the modem.
This is my first patch -- I apologize if I did things out of order.

On Mon, Sep 26, 2022 at 1:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 25 Sep 2022 21:05:24 -0700 Shane Parslow wrote:
> > This patch fixes the control channel mapping for the 7360, which was
> > previously the same as the 7560.
> >
> > As shown by the reverse engineering efforts of James Wah [1], the layout
> > of channels on the 7360 is actually somewhat different from that of the
> > 7560.
> >
> > A new ipc_chnl_cfg is added specifically for the 7360. The new config
> > updates channel 7 to be an AT port and removes the mbim interface, as
> > it does not exist on the 7360. The config is otherwise left the same as
> > the 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
> > In ipc_imem, a special case for the mbim port is removed as it no longer
> > exists in the 7360 ipc_chnl_cfg.
> >
> > As a result of this, the second userspace AT port now functions whereas
> > previously it was routed to the trace channel. Modem crashes ("confused
> > phase", "msg timeout", "PORT open refused") resulting from garbage being
> > sent to the modem are also fixed.
>
> What's the Fixes: tag for this one?
