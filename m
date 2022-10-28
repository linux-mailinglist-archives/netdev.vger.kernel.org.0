Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F606119E3
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJ1SJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJ1SJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:09:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B652AD6;
        Fri, 28 Oct 2022 11:09:27 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h185so5479642pgc.10;
        Fri, 28 Oct 2022 11:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/L5Z2XwZyEiZpk5TpaXm6izqVLvK2HD+7ChAAkunc8=;
        b=ocr2QmKUbrlVFx1PDjaijwsrl20kjQLLyyZwEh9JqWyei3fKWkZLe33QziNbVF1aNB
         SmXkyMF2ACRDKNWwS5ySSUDs7G98G4otF7r8pw6pRi9LfrGIWd03pbmt5FVXsiDZCMjw
         Z6anQUiTcftTkdLtc/py0y02aib3WCSpYgoC+emNTBzYFeBoCgfptIARiS1YmgpsP8PP
         I4xx0HJR2uADpgnHO5Ol9rEI98VyCCcFapSNA+lAvEsZC4oSQyuVxW2K1AqdmHno3xOM
         U5N+GU4ucGDqHdcGbXUq2ww5j8BL3sde/Zu0itxMqay4RzZjAbeotWAK8u+bfAbfHs73
         tN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/L5Z2XwZyEiZpk5TpaXm6izqVLvK2HD+7ChAAkunc8=;
        b=gaOH7fImWeUBgNBImQ4ohp7/zvZxtbK1jggha/h+ytM1DZ1mGRGOdaXozvNYZq2qRr
         gzZJ0yQfrN+xpPmd914lNA+NjomaX3nykzbp34P65FUgktwJpzBNai8CaUSjLb+apGsZ
         K2JooIbh5Ro3favDsskUkgl/3RmwiNPwV5JuOFzjaZMseVsJbVdNA+F7iDlCG0N7RvNX
         quEYyLGmtXGnPwi6KhVjBPNDdsArDRY3EoBYHR38wHR2ZvZ6RieCSoujzaZlcGt7By2e
         JfkMjmmAXJwm5mytUr8/gDRN5CgSCw7fnC9YMzHb+F9VLuqrDuNzLMqt6gxpoT8w7F/u
         +3pA==
X-Gm-Message-State: ACrzQf10azROlx5Us9OzkA64VwheWDrOox1JS79083XAMnT1mj3AurM2
        u1xlUgdu33OibHzvSVfgTKE=
X-Google-Smtp-Source: AMsMyM7Ud5Q0qIAw7/PJxm91YfctQ0gbLwI/1MYEvW1cuVsFcvPgKa5bvoffn2G/TXF2vw8EmbU/PQ==
X-Received: by 2002:a05:6a00:230f:b0:53e:2c2c:5c03 with SMTP id h15-20020a056a00230f00b0053e2c2c5c03mr324703pfh.11.1666980567136;
        Fri, 28 Oct 2022 11:09:27 -0700 (PDT)
Received: from arch-desk ([2601:601:9100:9230:37fc:258f:1646:1aea])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ecca00b0017534ffd491sm3399709plh.163.2022.10.28.11.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 11:09:26 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:09:24 -0700
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: wwan: iosm: add rpc interface for xmm
 modems
Message-ID: <Y1wa1JR9URGCUo1P@arch-desk>
References: <20221028003128.514318-1-shaneparslow808@gmail.com>
 <CAMZdPi-tz4_vxum8SYbYVuv71UYhe4QUGO6_w8TPFBcw9oydfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi-tz4_vxum8SYbYVuv71UYhe4QUGO6_w8TPFBcw9oydfQ@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 12:35:01PM +0200, Loic Poulain wrote:
> On Fri, 28 Oct 2022 at 02:37, Shane Parslow <shaneparslow808@gmail.com> wrote:
> >
> > Add a new iosm wwan port that connects to the modem rpc interface. This
> > interface provides a configuration channel, and in the case of the 7360, is
> > the only way to configure the modem (as it does not support mbim).
> 
> Doesn't the AT channel offer that possibility? what is the status of
> 7360 support without this change?

Several initialization functions must be called through the RPC channel
to bring up the 7360. Without this initialization the modem is not
functional beyond responding to simple AT commands. After initialization
through this interface the modem works as expected.

Because of this, the 7360 is currently nonfunctional beyond responding
to a limited set of AT commands. As for the 7560, my understanding is that
it is currently functional, and this interface simply supplements the MBIM
interface.

> 
> > The new interface is compatible with existing software, such as
> > open_xdatachannel.py from the xmm7360-pci project [1].
> >
> > [1] https://github.com/xmm7360/xmm7360-pci
> >
> > Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
> > ---
> >  drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 2 +-
> >  drivers/net/wwan/wwan_core.c              | 4 ++++
> >  include/linux/wwan.h                      | 2 ++
> >  3 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> > index 128c999e08bb..91e3e83fc47b 100644
> > --- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> > +++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> > @@ -39,7 +39,7 @@ static struct ipc_chnl_cfg modem_cfg[] = {
> >         /* RPC - 0 */
> >         { IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
> >           IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
> > -         IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_UNKNOWN },
> > +         IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_RPC },
> >         /* IAT0 */
> >         { IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
> >           IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
> > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > index 62e9f7d6c9fe..cf16a2704914 100644
> > --- a/drivers/net/wwan/wwan_core.c
> > +++ b/drivers/net/wwan/wwan_core.c
> > @@ -319,6 +319,10 @@ static const struct {
> >                 .name = "FIREHOSE",
> >                 .devsuf = "firehose",
> >         },
> > +       [WWAN_PORT_RPC] = {
> > +               .name = "RPC",
> > +               .devsuf = "rpc",
> > +       },
> 
> RPC sounds more like a generic method than an actual XMM-specific
> protocol, isn't there a more precise name for that protocol? if not,
> maybe XMMRPC is more appropriate?

This is the only name I've seen it referred to by. I think XMMRPC/xmmrpc
will have to work.

> 
> >  };
> >
> >  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> > diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> > index 5ce2acf444fb..3cf2182ad4e9 100644
> > --- a/include/linux/wwan.h
> > +++ b/include/linux/wwan.h
> > @@ -15,6 +15,7 @@
> >   * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
> >   * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
> >   * @WWAN_PORT_FIREHOSE: XML based command protocol
> > + * @WWAN_PORT_RPC: Control protocol for Intel XMM modems
> >   *
> >   * @WWAN_PORT_MAX: Highest supported port types
> >   * @WWAN_PORT_UNKNOWN: Special value to indicate an unknown port type
> > @@ -26,6 +27,7 @@ enum wwan_port_type {
> >         WWAN_PORT_QMI,
> >         WWAN_PORT_QCDM,
> >         WWAN_PORT_FIREHOSE,
> > +       WWAN_PORT_RPC,
> >
> >         /* Add new port types above this line */
> >
> > --
> > 2.38.1
> >
> 
> Reagrds,
> Loic

Thanks for the feedback. Should I go ahead and submit a V2?
