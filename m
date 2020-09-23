Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9140C275D67
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIWQ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgIWQ23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:28:29 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33203C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:28:29 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so57103iow.9
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EzhY1KYi0pVlHYlyYC4E/2ZpCPNFP9SIE2F8MWZ9XM=;
        b=nFXKmkvcX5DfMyGhr7HnGICERTNNFvnMGoH5ECzgLbyKsgxVoTWrqn25+RdmAOUseS
         K/Mp83l7eVlDCImTGLpma7YdQd/f5v4iKtxhXOjvA2wRqVZggAvgvnrHcEDmDSKjdtHm
         3FIDUpORfU00fh2PJB+m490EZowvvynf+w3JGKDaknXGTc5dyQnYZ4b4wBONZr2i3q5H
         m+wOl1+/dSIEEd4GPneJ14WTru3guuwy+voaAle3e+nC0SPUy8voTqkqARrSvYQ1SKtt
         W9bbk04gisozIG5rLKGAMRYWHtrLWI/qygUBB/ur/ULUBjnhWOmZ7rxK2QC1ofKTb1jj
         zGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EzhY1KYi0pVlHYlyYC4E/2ZpCPNFP9SIE2F8MWZ9XM=;
        b=dLrg0bxrv6my45LD51ZQhoEE8Tx/V/yknYKVdTxE4SgoKsoWp5Aoi+mnqZpt+rP1zX
         271kTcDctpBqCizwMkRRbZHPFpRAhNwQRKTxp2p9v4AMtFB0if8vNJRWmyO5cAmYxMlL
         H3SEfCJ+RqVNKwgyIqp4COmQXf6vOzSBexiEmAmgOIx02qlYo9drG3CeomGpmRJow5k2
         W1ak/0cseaMSAPwRsSZTCazs9m9Kbd1NfClsCImVsJeaKCUksg3ZHiFleq8JLE8Dy3cY
         vKdTzLQtAMWCcY1Xx6Y4PvmQ3ARfij2uMpgXQwNI99munVJ5kyWEOhW2KRFVhb48QVio
         izDQ==
X-Gm-Message-State: AOAM531ZT25k6p6YnqfP4S3OwlGNNt4I0jkUqiAussLaCapgXLMSO1wh
        qvVl40ZOvbAUgsuIBv2yoS1wvffpQ6Ya+V0VMfRe3w==
X-Google-Smtp-Source: ABdhPJwpfupRTCfXWtTM8I8Azc8/O/rfLuY/x2TahtDkIK9N+krEQaWFNz0673xMZULLFwqGA5+3Mb2/iPMsCiKrJq4=
X-Received: by 2002:a6b:cd89:: with SMTP id d131mr253385iog.41.1600878508465;
 Wed, 23 Sep 2020 09:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200922155100.1624976-1-awogbemila@google.com>
 <20200922155100.1624976-4-awogbemila@google.com> <20200922104015.005cd8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922104015.005cd8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 23 Sep 2020 09:28:17 -0700
Message-ID: <CAL9ddJedL6Yj_0oM+a6R7vdy55uoqDWt+Zs0bsayeDsUXYDMFQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] gve: Add support for raw addressing in
 the tx path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 22 Sep 2020 08:51:00 -0700 David Awogbemila wrote:
> > -static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
> > -                                 u64 iov_offset, u64 iov_len)
> > +static void gve_dma_sync_for_device(struct gve_priv *priv,
> > +                                 dma_addr_t *page_buses,
> > +                                                             u64 iov_offset, u64 iov_len)
>
> Alignment stilled messed up here.

Thanks, I'll fix this.
