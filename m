Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55526679D
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKMbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgIKMaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:30:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D9CC061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:30:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 67so6532311pgd.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbxwP9miORo2DKwSEZ5JCDhcOwdDMNbjt2KRy+7eBzM=;
        b=sxxXMyvLvBAPEMoIJ8QSKstOUEiBA7O41mtGLBLcawP4cPlQspzBE7xSaP1XfP2/F0
         GYAd+j3gc4ebjMb1Kf9ORadNiTYZokAYW1syP4A2tS6KWnlj37Liluhycsj8DoQsV+3l
         1bYKSpvfA1Z3Ivo9BaiSLrBvPUimSOEAs9gWmU6+nOKmZox9TjtYlvydCrUPSmRrplGW
         GE+OS4/Xiq6t1TuZq4VT3ZWVaGD7m+E1f8BBQSj8rP+JFNyE5Y9dLJgGpkGzbETQJJ8F
         nn2eBPZdUjUwrmnQ6/vR/MR4Y00Ix8qOhK4NJOHGEr0UbsvCuz3kRE7ALK6AcQw3iH0V
         Hc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbxwP9miORo2DKwSEZ5JCDhcOwdDMNbjt2KRy+7eBzM=;
        b=r0Y1lVmMAET0UbggxcGy8u40FaHVCDdmcNnVFmba9T/JheVn25wt725Y+toJemtarj
         qe1sQHBNhgPjmkf3sCgMBPzoQw2axS8V42THKxuCgN2A48Gi8dilL2miKsufkklbw/P/
         xTcIRtBV8ze5BCRQ+PfunO4qY7HoU7xfz7bRiCM6wzf2UDculmUL8fKT+OF7OYEe4d9R
         e6+4NkcHKO/KGnqs3SzccZtv1CkzDLAowJfKpI5w4L4WtM5Jtr+kHBs/pGZlXNgiTT6R
         uU3H2GevsY6S9+bIcr/7Ld3RulE6i13lw0pjgr0fUBeZ+yYt6CiA8KQu7A+4x92qJbVx
         OnlQ==
X-Gm-Message-State: AOAM530O7IVG9ad9YuM4x4r+p6uHDOD7SdUT7ouCZPnslHMQtxNkwsI+
        2td5ZBV4a0dU7RptP4xmnvqzIIzVFo0APdd+Mtk=
X-Google-Smtp-Source: ABdhPJycbi9144tCuWpJOm/DbHyimB+o7+twCZ4RlJMolGb2fwNpW/CpCjKpTViUWqAmg562BYyME7hhfh04qAplFEs=
X-Received: by 2002:a05:6a00:15c1:b029:13e:d13d:a04d with SMTP id
 o1-20020a056a0015c1b029013ed13da04dmr1869316pfu.19.1599827401252; Fri, 11 Sep
 2020 05:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com> <20200911120519.GA9758@ranger.igk.intel.com>
In-Reply-To: <20200911120519.GA9758@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 11 Sep 2020 14:29:50 +0200
Message-ID: <CAJ8uoz3ctVoANjiO_nQ38YA-JoB0nQH1B4W01AZFw3iCyCC_+w@mail.gmail.com>
Subject: Re: [PATCH net-next] i40e: allow VMDQs to be used with AF_XDP zero-copy
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        jeffrey.t.kirsher@intel.com,
        Network Development <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 2:11 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Sep 11, 2020 at 02:08:26PM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> > reason, we only allowed main VSIs to be used with zero-copy, but
> > there is now reason to not allow VMDQs also.
>
> You meant 'to allow' I suppose. And what reason? :)

Yes, sorry. Should be "not to allow". I was too trigger happy ;-).

I have gotten requests from users that they want to use VMDQs in
conjunction with containers. Basically small slices of the i40e
portioned out as netdevs. Do you see any problems with using a VMDQ
iwth zero-copy?

/Magnus

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index 2a1153d..ebe15ca 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -45,7 +45,7 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
> >       bool if_running;
> >       int err;
> >
> > -     if (vsi->type != I40E_VSI_MAIN)
> > +     if (!(vsi->type == I40E_VSI_MAIN || vsi->type == I40E_VSI_VMDQ2))
> >               return -EINVAL;
> >
> >       if (qid >= vsi->num_queue_pairs)
> > --
> > 2.7.4
> >
