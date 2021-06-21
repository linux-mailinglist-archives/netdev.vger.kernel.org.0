Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FA3AEC13
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFUPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhFUPOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624288359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqWBK7Z8CbBX214bEDMtGKqV2k7WcX25nCByeL8bask=;
        b=blVgWJXFmbLLy3xLbrtI4h2kOaigt0uxjtq1zTvZxHb8kJ/E79VagnV/bAHP+uZFp1iMZ7
        VmvJqiHO6imFuztNHuqVZVfM1/DqWRsfefXVCYSE4jrxeUaSzEeAOPJ2QjQHUphkGdtKsg
        iSNixT5ZyHY9yn5y3P3lnEbrhEewqe8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-6oqmJy8hNxmLg5Z7Z6H5Fg-1; Mon, 21 Jun 2021 11:12:37 -0400
X-MC-Unique: 6oqmJy8hNxmLg5Z7Z6H5Fg-1
Received: by mail-il1-f197.google.com with SMTP id c15-20020a92b74f0000b02901ee2d62033eso3557628ilm.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 08:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UqWBK7Z8CbBX214bEDMtGKqV2k7WcX25nCByeL8bask=;
        b=rKVt6fr2QpNrdj1qmDEI+pmnAjydreomrazw1KTkdhGdTV1qXnrUQ9UNFrPjOYquU0
         1QC+zFzygkhk1KQ9PPmJx9TeKSFetLAeTft4fmizurFsWCkkQrI7GsSNQnezuDAgNYEE
         0002mPQXB+RnOliGiQ1jNdwqDXZ8RlJmyKlENA3hNVx2cOz/pW3s1amdGEzcqMVcxlTQ
         0GGNX88vPBegSTIH45vEHTaFes09hGckE84A3s73p+GXwNq3+3+2jUpCcZIRWeTVcb3J
         k3b6kqz4cKJH1aKtnp1nbr+PwGaQH51lNjK2Yq7wRk39dPIJGuTI2K7nwH7jUGNhpGA7
         2DYQ==
X-Gm-Message-State: AOAM533CfPhOfwqGPdf9wUJBM4l1DVUJn++xMBivLxp9rSsqH0jGd22h
        VMyyTIjgZo/kxTgU1UZmGyKKygL+h990fHiE2XPx+JwtGv3udc2yWMlnhRklRc8uzQfzLB/GvAR
        Kz70HVmtkDlQI+oTDFPsOilcsrcn4yuui
X-Received: by 2002:a5d:9c59:: with SMTP id 25mr20349042iof.27.1624288357138;
        Mon, 21 Jun 2021 08:12:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMtJEdlEFk2XOI5Tz6M/vyS3isV45OGviFOxXa/xsYPQkRvuMveuy0VrnmLqKOrR671zzlgFWghYfjz/tqh2I=
X-Received: by 2002:a5d:9c59:: with SMTP id 25mr20349029iof.27.1624288356961;
 Mon, 21 Jun 2021 08:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
 <20210618093506.245a4186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <9a0836b2f5ed487bb7d9c03a4b17222f@intel.com>
In-Reply-To: <9a0836b2f5ed487bb7d9c03a4b17222f@intel.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 21 Jun 2021 17:12:25 +0200
Message-ID: <CACT4oufCHsXLsw4uLtYMD4d3_UvJYn_Nr1dbiGYvPRVz=fwnNA@mail.gmail.com>
Subject: Re: Correct interpretation of VF link-state=auto
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Edward Harold Cree <ecree@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 6:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Like all legacy SR-IOV networking the correct thing to do here is clear
> as mud. I'd go for the link status of the PF netdev. If the netdev
> cannot pass traffic (either for administrative or physical link reasons)
> then VFs shouldn't talk either. But as I said, every vendor will have the=
ir
> own interpretation, and different users may expect different things...

On Fri, Jun 18, 2021 at 9:10 PM Keller, Jacob E
<jacob.e.keller@intel.com> wrote:
> I like this interpretation too.. but I agree that it's unfortunately conf=
using and each vendor has done something different.. :(

Thanks Jakub and Keller, at least now it's clear that it's not clear :P

Good enough info to move forward, for me.
--=20
=C3=8D=C3=B1igo Huguet

