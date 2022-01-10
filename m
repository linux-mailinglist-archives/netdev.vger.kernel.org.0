Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED32489BF9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiAJPPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 10:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiAJPPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 10:15:18 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93801C06173F;
        Mon, 10 Jan 2022 07:15:18 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d7so5928649ybo.5;
        Mon, 10 Jan 2022 07:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGF/nGHtbeVmxgDo34A0moRipaYpJVIiWNAE+daWzos=;
        b=mBdUHa3P6bXUlUuslJZ/9rWCl1S0gWCnSRdFNwhtg6hVinsfVVB8pl5elniva3m/sB
         KPalKL8louTtY2mvJHJSxKubW1KP6OTilhJK38vibgy5E/D0OR7c8KVs72B53zXJu1c5
         GFd0JxvkDiXaiqt6oyFs1/bRICIXAQicbuI2Xuyrfx+F5L5QuiX2O91Xw7kf1VnhrzUi
         lRPp37CMoihV+8HX2ekw0/p9mYpIs11KqI0VTvlvAKG9WctJG4aszgLCCUR7Hr3QD/DO
         bzNKGUSpWyvunF+Jbf1Zzi4CfvbFeGQqZWQTGUUwWkWjmzsuKoE7fLo8Xcy+UTg9m5b1
         LW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGF/nGHtbeVmxgDo34A0moRipaYpJVIiWNAE+daWzos=;
        b=4BRp0FJ5OjaEWD/v4JGv6QHA3tefwt9rpjRiCly3vgTy0wYuVyzdx5wKNArmDMvCSd
         kR11gfrm/moPy/NRnSoTpFHuJiUe3ejNxSgt2UxG2rTCfKojdj5Uwlqp6vXQqWS1IAAi
         kuufEBvJcNmp6enJory/ibeJEM0h3J3v21TTthMkvknDByej14WatX1/GUpmFIg5LTS5
         wznArvoU3wKzAbtjRhLAxpxp6LxdBbSbFBDa82wVs+26HnWFDLsJocVf6GmmipHG5nBk
         JbEh98kj7ywhFwJEt85N6UwNYCJssIf/WbRtJ+gDzKxgAUUECsPJw4yjNz1vizSfSJl0
         +CoQ==
X-Gm-Message-State: AOAM533N1u4/ztH7bbtKysGjSB6s+srsXPn9SdnjXVurUZK6l2HT5eV6
        CyZt3ZRpcdbc+e36AZGVEpG6wV77CByB0wukBhU=
X-Google-Smtp-Source: ABdhPJxCpRh0F7eIDaIwTnKPI4BeWNFWVCHaBaUoE4XzakjJVuUhdd34JyS826GBPz6NE89LGvrbs8TrooDLDD0dXOA=
X-Received: by 2002:a25:4f44:: with SMTP id d65mr10476817ybb.723.1641827717754;
 Mon, 10 Jan 2022 07:15:17 -0800 (PST)
MIME-Version: 1.0
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
 <35cebb4b-3a1d-fa47-4d49-1a516f36af4f@oracle.com> <CAKXUXMwQE6Z1EFYOtixwA+8nLZySxdHH9xHiOkGhcy5p0sr9xQ@mail.gmail.com>
 <20220109064905.1594-1-hdanton@sina.com>
In-Reply-To: <20220109064905.1594-1-hdanton@sina.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 10 Jan 2022 16:15:06 +0100
Message-ID: <CAKXUXMwL5ThVG-LtcUwiC3qTS6CMObSB7m=vpGENUzERYaGeaQ@mail.gmail.com>
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
To:     Hillf Danton <hdanton@sina.com>
Cc:     Shoaib Rao <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 7:49 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Sun, 9 Jan 2022 05:10:48 +0100 Lukas Bulwahn wrote:
> > On Fri, Jan 7, 2022 at 6:55 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
> > >
> > > Hi Lukas,
> > >
> > > I took a look at the patch and I fail to see how prepare_creds() could
> > > be impacted by the patch. The only reference to a cred in the patch is
> > > via maybe_add_creds().
> > >
> > > prepare_creds() is called to make a copy of the current creds which will
> > > be later modified. If there is any leak it would be in the caller not
> > > releasing the memory. The patch does not do anything with creds.
> > >
> > > If there is any more information that can help identify the issue, I
> > > will be happy to look into it.
> > >
> >
> > Here is more information:
> >
> > Here are all crash reports:
> >
> > https://elisa-builder-00.iol.unh.edu/syzkaller-next/crash?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3
>
> More weid is the failure of Ctrl-f "unix" at [1] except for a bunch of
> clone. Can you specify why report at [1] has a direct link to af_unix?
>
>         Hillf
>
> [1] https://elisa-builder-00.iol.unh.edu/syzkaller-next/file?name=crashes%2f1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3%2freport15
>

Hillf,

I agree that is really weird. I fear we have some issue with our
syzkaller instance, somehow the database is collecting error logs that
seem to be different from the error logs I observe when manually
running the reproducer. The heuristics of aggregating error messages
is black magic.

Importantly, we have a reproducer, which is clearly related to the
af_unix functionality and we can manually trigger a reasonable error
trace. Ignore all the rest.

Lukas
