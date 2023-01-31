Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F95F6834AF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjAaSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaSFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:05:51 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA02D4A
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:05:50 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4ff1fa82bbbso214323937b3.10
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWttzzEqLZ4mobKc2KtU79+X9WqztKnmp/PSm+ukpqA=;
        b=VJm1EAPsPsACM6/mz95Oz1ExYh5K4M2TXCVTD7UvRP84mFTo4aueVArSy4FlpdJ36m
         axk9OY9931MKlM3i+kLz+34jk8BO+krPdxjbJLKIHrm8b5NKgByas4eQw3/E152Kg2VE
         FkCq/fRwa0tBj76bxdzAQJtKurRFz5HPiJL4vuB1NqdPTb872bGjM/asA+GqkIMXSf7W
         kEfI1+H1Zz7S3TvWcMhBYEBB4SU7MtxGbQ3W1lAzwERDcG3qG367bK0owiJK2IetwMJ2
         Z9FkrS5uzZLU9/RnHcnQ63lShCWsqkvSa6Dlx0dMZBpPdFLx6JUMijHfdNaRyljY29ZX
         tzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWttzzEqLZ4mobKc2KtU79+X9WqztKnmp/PSm+ukpqA=;
        b=CQM6PNLhH8X8LtV6U3a0HWSNOhnoLDo3J2MFgGY+4+ras1esQDZ7EYkRdOgiEz2Yf3
         JXgCrMykSHsp4t29iBwRELPRSMdW0aAMJSqL6PfukqYkUslrrIWSJBCXisGJ1pwmYyxW
         cLzBYHPBGOANJRgfsILlr1PVgLcoza5vyuT7R/fVWSg5FwmRsuDzZ0vL2SUR/XiAn4hT
         o2okf1DDIChhp/BwLinaKB1Xzl3nTi4BF2F2tR/qtpfunh+Bk1m9aQSD0Zc0Mt6D5ED0
         Oq4ppxiKzHMQURigO9vjYX1bKeN/Jxjw/b3gj5kVrbKIZvz0RcM3yzUvA54h8wAjPufF
         FeJw==
X-Gm-Message-State: AO0yUKVNBfMIzn9S3TkKLCOYDqx3tlsmsHT6YQs3KgaIsJr+7WN1fTo/
        dK04VRIVCbvJ+ceZY8+aHMTjg+8HX1c1NmnSdFga
X-Google-Smtp-Source: AK7set9FHKQF8kjhMobb5qikCjjSVJ5yhENI27t+4pv+8JeADKx4pF7Be0tJDg36DyGIUuQ8FAplSHml32YG3VcBWGc=
X-Received: by 2002:a81:8582:0:b0:50f:f163:7072 with SMTP id
 v124-20020a818582000000b0050ff1637072mr1081761ywf.285.1675188349551; Tue, 31
 Jan 2023 10:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20230130192519.686446-1-anthony.l.nguyen@intel.com> <Y9jQpjLPkRR/emeH@unreal>
In-Reply-To: <Y9jQpjLPkRR/emeH@unreal>
From:   Bjorn Helgaas <bhelgaas@google.com>
Date:   Tue, 31 Jan 2023 12:05:37 -0600
Message-ID: <CAErSpo64=miv7++wUhHKx=mnN1Rmh3u+cTaPxngbj4nd=9spjQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN: Remove
 redundant Device Control Error Reporting Enable
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 2:26 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jan 30, 2023 at 11:25:11AM -0800, Tony Nguyen wrote:
> > Bjorn Helgaas says:
> >
> > Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native=
"),
> > the PCI core sets the Device Control bits that enable error reporting f=
or
> > PCIe devices.
> >
> > This series removes redundant calls to pci_enable_pcie_error_reporting(=
)
> > that do the same thing from several NIC drivers.
> >
> > There are several more drivers where this should be removed; I started =
with
> > just the Intel drivers here.
> > ---
> > TN: Removed mention of AER driver as this was taken through PCI tree [1=
]
> > and fixed a typo.
> >
> > [1] https://lore.kernel.org/all/20230126231527.GA1322015@bhelgaas/
> >
> > The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688d=
afca26f2:
> >   Merge branch 'devlink-next'
> > and are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> >
> > Bjorn Helgaas (8):
> >   e1000e: Remove redundant pci_enable_pcie_error_reporting()
> >   fm10k: Remove redundant pci_enable_pcie_error_reporting()
> >   i40e: Remove redundant pci_enable_pcie_error_reporting()
> >   iavf: Remove redundant pci_enable_pcie_error_reporting()
> >   ice: Remove redundant pci_enable_pcie_error_reporting()
> >   igb: Remove redundant pci_enable_pcie_error_reporting()
> >   igc: Remove redundant pci_enable_pcie_error_reporting()
> >   ixgbe: Remove redundant pci_enable_pcie_error_reporting()
> >
> >  drivers/net/ethernet/intel/e1000e/netdev.c    | 7 -------
> >  drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 5 -----
> >  drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ----
> >  drivers/net/ethernet/intel/iavf/iavf_main.c   | 5 -----
> >  drivers/net/ethernet/intel/ice/ice_main.c     | 3 ---
> >  drivers/net/ethernet/intel/igb/igb_main.c     | 5 -----
> >  drivers/net/ethernet/intel/igc/igc_main.c     | 5 -----
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
> >  8 files changed, 39 deletions(-)
>
> I see that you didn't touch any other places except drivers/net/ethernet/=
intel/.
> Are you planning to remove other occurrences too?
>
> =E2=9E=9C  kernel git:(rdma-next) git grep pci_enable_pcie_error_reportin=
g -- drivers/infiniband/
> drivers/infiniband/hw/hfi1/pcie.c:      (void)pci_enable_pcie_error_repor=
ting(pdev);
> drivers/infiniband/hw/qib/qib_pcie.c:   ret =3D pci_enable_pcie_error_rep=
orting(pdev);

Yes, definitely, I just haven't had a chance yet.  Some of the others
are a little more complicated than the simple removals for the Intel
drivers.

Bjorn
