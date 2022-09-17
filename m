Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535975BB4DC
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 02:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIQACa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 20:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIQAC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 20:02:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BACEAB046;
        Fri, 16 Sep 2022 17:02:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id kr11so6710193ejc.8;
        Fri, 16 Sep 2022 17:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=50pfUUj/vgJFWVGyCmPh4h7BWyWJzM6r5aZUYPBRoMw=;
        b=gX6FWj46IiYEMBWFzAQpW/X9rgfemENCTEGH7qioDntvtkqCifz2ld/bbtzLYyLn3d
         4PCLXtTYhHukcC4tIj6BY/X530N2+lkUJ+okA7NcKCX4ObLu+N+Fj3WoYKgikvDAsS1T
         1oIj+JeU1LsBntvA8oagnJAIbaueJXMu/m1AGzpqky1gsc1FWWBeFuMjr3Z4icUbQSNR
         twRd+k0a4mhqI2YPBVpmQOE9UwxUSUlSpE5OHqgksyIt8xMvlrNSxFWGBVKe2DDelfvA
         vIPcBaawr1vY/GtU9yI9rqIGPKtdNBVM9LV/QT05IdQt970IzFj5EVLUanspwkSOAIhU
         2ykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=50pfUUj/vgJFWVGyCmPh4h7BWyWJzM6r5aZUYPBRoMw=;
        b=B8yXqu7+X9A5nwKtY6kFHOHb+6YzrsIqD9FSYIR7sae6FmfsxAi4HJbvjScIT/ZKQX
         /Tjx/9/vbTrz7VK/UqGMii/HiQl37UJg+sspKIEn0WQdlfyt86g/ZdGGK9Elsg/YkXjO
         VQgFzFxjBwc59cdvNWD+1dvGsFMmy9/BXjx0ASIZB7xY+bkBF8l76crpgdgHCZ3AD9un
         a2Yh1khSro5IAmzdgIXzGDawLlXIxAyB5NYFznoqPdKP0vHAV6mvYN9n7/oymtbj8LWm
         A2/ipr89ByU0d8eN0De1xx2ndIDUub5DmBjOGmUEH/hktHoC4z9hbDQ3hZHRLMI0P0DH
         n8Vw==
X-Gm-Message-State: ACrzQf2HpOFFQRdqf4zmyjLCNHtAz2U+RGI15mvY3+ol5MNFCz3MBroE
        KuFTf5bUAkR/MUG1x1yp8vSOtMHip0vLHV76XNs=
X-Google-Smtp-Source: AMsMyM5mOnaEfXDy8jqFsNuwi+v6tx4gEz61WuQMsLniHsaIqCxIJTFjMs0dk5vg4LmiLerh0z237itaAZymfj+6z2U=
X-Received: by 2002:a17:907:ea0:b0:779:6c9d:7355 with SMTP id
 ho32-20020a1709070ea000b007796c9d7355mr4956271ejc.542.1663372945402; Fri, 16
 Sep 2022 17:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220909041645.2612842-1-floridsleeves@gmail.com> <4ff0b209-2770-3790-ae93-3ea81c15a03e@intel.com>
In-Reply-To: <4ff0b209-2770-3790-ae93-3ea81c15a03e@intel.com>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Fri, 16 Sep 2022 17:02:14 -0700
Message-ID: <CAMEuxRqbmds-XXjbGsgCup1_aj4EMfRO2dVurcS1O4fd0mdygA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] drivers/net/ethernet/intel/e100: check the
 return value of e100_exec_cmd()
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        jesse.brandeburg@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 3:08 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> On 9/8/2022 9:16 PM, Li Zhong wrote:
> > Check the return value of e100_exec_cmd() which could return error code
> > when execution fails.
>
> Are you coming across this as a real bug or as something reported by
> static analysis? If the latter, I suggest checking the return value and
> reporting it as debug, however, not changing existing behavior. We don't
> have validation on this driver so there is limited ability to check for
> regressions and the code has been like this for a long time without
> reported issues.

Thanks for replying and suggestions! This is detected by static analysis.
I submit a v2 patch that fixes it as debug printk.

>
> Thanks,
> Tony
>
> > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > ---
> >   drivers/net/ethernet/intel/e100.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
> > index 11a884aa5082..3b84745376fe 100644
> > --- a/drivers/net/ethernet/intel/e100.c
> > +++ b/drivers/net/ethernet/intel/e100.c
> > @@ -1911,7 +1911,8 @@ static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
> >
> >       /* (Re)start RU if suspended or idle and RFA is non-NULL */
> >       if (rx->skb) {
> > -             e100_exec_cmd(nic, ruc_start, rx->dma_addr);
> > +             if (!e100_exec_cmd(nic, ruc_start, rx->dma_addr))
> > +                     return;
> >               nic->ru_running = RU_RUNNING;
> >       }
> >   }
