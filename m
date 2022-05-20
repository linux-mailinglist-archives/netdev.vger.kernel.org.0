Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C020152E299
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbiETCqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344787AbiETCpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:45:52 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA05A1E3F4
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:45:49 -0700 (PDT)
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0DB863F1B6
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653014747;
        bh=GaatjPyXHl4SmKXxygcZKmkO/KC5Kz97rzqAvXN3cKo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=CZQ/l3xpbHNcIdCBx9ZPSPz2Z1DVuu8hU7hRdDnfR2wFHv0IAqYTpSWC4/wOLAefh
         Chx4mQtpBov3S6CA2taxGlBPFIxYd6UD8X/JxZi6G/P2HDLBSoDn86kYzEtr44BXtH
         mW05IrEzgWlER729s63a5Dl70ONxZ6zMDmOYMSpdXj/KSe+3HH0AHfNs5eE+fGzXH0
         FkFjFWevQd/oPpvG60sGqHAt3CdHKZ8BxuEjNeDgV+BkgrC8RXN2v3CKCvVsxyAQVB
         fI2fu79T86C3eaQlWRL+bvoM6wQcP65CI1SwkH6SrMrYttxcv0kpQDqLvCjjFzrVYL
         H8RdmRxHIJINQ==
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-f18a9e2278so3763999fac.11
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GaatjPyXHl4SmKXxygcZKmkO/KC5Kz97rzqAvXN3cKo=;
        b=nhaAi8JCRqyxgs/bnidJTOSyiWP0ix1hFhvtX2hHo0xpJLNFf06NZ0ela6pHOHTQ+4
         RiarVF6Cem1MwfTNl6GPRfkXiK5QMbCI5mbpcwMIjLnivMtd9l8kQGfH8Mkw2oTQUoJ8
         Kws/bHkj7ZKK1ZkpjvlyWYqE4bqwMuW/ViBVris6iLo1Me8C4w50VxG9i/FhTPHaUO4t
         zVzxHTlkDxzMYEcRR30i9HWAXj6uxK2R3mz1vb6xSxea3YLLkMdrkVuO4MDO0wSvUj4Y
         JsU6OomwABo5+PND4wtuaf84GQz4hlBfJLp1KmmVl073UFIr2taFt8PT8hJVEaQqLv0z
         tLwA==
X-Gm-Message-State: AOAM532qDzi7SVvRUyAB3dvdRVmQCJivLeJmi06UkqwzSWgdnLwoEjw3
        NFQgnKZwL5ynF6T3+S1vCESbb00hgVrQM+4fZ+ZEEU/Xh+BnaoCkQzlXgzR7m+uDq9WmPMpsEQD
        IVrqoa1ki1319lfAwKNDxSrM0DpBzmPmNeY7jcvCd62hrsXUiLA==
X-Received: by 2002:a05:6870:2111:b0:e6:8026:8651 with SMTP id f17-20020a056870211100b000e680268651mr4440524oae.42.1653014745868;
        Thu, 19 May 2022 19:45:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUd8npgDZFVCRK+/H03mTTbAYJXBPp30NE0Tzuyut6qHq5m/2a0jX6vwPXLG6EttAHcJwZSaW+auW+bAcL76c=
X-Received: by 2002:a05:6870:2111:b0:e6:8026:8651 with SMTP id
 f17-20020a056870211100b000e680268651mr4440502oae.42.1653014745511; Thu, 19
 May 2022 19:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
 <20220511122806.2146847-2-kai.heng.feng@canonical.com> <6246d753-00cb-b5dc-f5fc-d041a8e78718@molgen.mpg.de>
 <CAAd53p52gkv-PLRvEM3GunTwU1J=c+n0J6uD03AQJ4EnL2y4Kg@mail.gmail.com>
In-Reply-To: <CAAd53p52gkv-PLRvEM3GunTwU1J=c+n0J6uD03AQJ4EnL2y4Kg@mail.gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 20 May 2022 10:45:33 +0800
Message-ID: <CAAd53p4h1-SJROvUghPYbBnh2Z9nRtgfNEagE4X6XtBwNg8JOg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU is
 active on the PCIe link
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:55 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Hi Paul,
>
> On Wed, May 11, 2022 at 8:49 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Kai-Hang,
> >
> >
> > Thank you for the patch.
> >
> >
> > Am 11.05.22 um 14:28 schrieb Kai-Heng Feng:
> > > We found Intel I210 can only achieve ~750Mbps Tx speed on some
> > > platforms. The RR2DCDELAY shows around 0x2xxx DMA delay, which will be
> >
> > Please give an example platform, where it works and where it does not.
>
> The platform is about but not yet hit the market yet, so I can't disclose it.
> They are Intel Alder Lake based.
>
> >
> > How did you test transfer speed?
>
> Iperf.
>
> >
> > > significantly lower when 1) ASPM is disabled or 2) SoC package c-state
> > > stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx speed can
> > > reach to ~950Mbps.
> > >
> > > According to the I210 datasheet "8.26.1 PCIe Misc. Register - PCIEMISC",
> > > "DMA Idle Indication" doesn't seem to tie to DMA coalesce anymore, so
> > > set it to 1b for "DMA is considered idle when there is no Rx or Tx AND
> > > when there are no TLPs indicating that CPU is active detected on the
> > > PCIe link (such as the host executes CSR or Configuration register read
> > > or write operation)" and performing Tx should also fall under "active
> > > CPU on PCIe link" case.
> > >
> > > In addition to that, commit b6e0c419f040 ("igb: Move DMA Coalescing init
> > > code to separate function.") seems to wrongly changed from enabling
> > > E1000_PCIEMISC_LX_DECISION to disabling it, also fix that.
> >
> > Please split this into a separate commit with Fixes tag, and maybe the
> > commit author in Cc.
>
> I don't see the need to split to separate commit as both require the
> same change.
>
> I will add the "Fixes" tag once the igb maintainers reviewed the patch.

A gentle ping...

Please let me know if this is a proper fix so I can send v2.

Kai-Heng

>
> Kai-Heng
>
> >
> >
> > Kind regards,
> >
> > Paul
> >
> >
> > > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > ---
> > >   drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
> > >   1 file changed, 5 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > > index 34b33b21e0dcd..eca797dded429 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -9897,11 +9897,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
> > >       struct e1000_hw *hw = &adapter->hw;
> > >       u32 dmac_thr;
> > >       u16 hwm;
> > > +     u32 reg;
> > >
> > >       if (hw->mac.type > e1000_82580) {
> > >               if (adapter->flags & IGB_FLAG_DMAC) {
> > > -                     u32 reg;
> > > -
> > >                       /* force threshold to 0. */
> > >                       wr32(E1000_DMCTXTH, 0);
> > >
> > > @@ -9934,7 +9933,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
> > >                       /* Disable BMC-to-OS Watchdog Enable */
> > >                       if (hw->mac.type != e1000_i354)
> > >                               reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
> > > -
> > >                       wr32(E1000_DMACR, reg);
> > >
> > >                       /* no lower threshold to disable
> > > @@ -9951,12 +9949,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
> > >                        */
> > >                       wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
> > >                            (IGB_TX_BUF_4096 + adapter->max_frame_size)) >> 6);
> > > +             }
> > >
> > > -                     /* make low power state decision controlled
> > > -                      * by DMA coal
> > > -                      */
> > > +             if (hw->mac.type >= e1000_i210 ||
> > > +                 (adapter->flags & IGB_FLAG_DMAC)) {
> > >                       reg = rd32(E1000_PCIEMISC);
> > > -                     reg &= ~E1000_PCIEMISC_LX_DECISION;
> > > +                     reg |= E1000_PCIEMISC_LX_DECISION;
> > >                       wr32(E1000_PCIEMISC, reg);
> > >               } /* endif adapter->dmac is not disabled */
> > >       } else if (hw->mac.type == e1000_82580) {
