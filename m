Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19812C183D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbgKWWJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbgKWWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:09:54 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767F1C0613CF;
        Mon, 23 Nov 2020 14:09:54 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so16290553pfm.13;
        Mon, 23 Nov 2020 14:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FA3bZWejjzUky+cRUDelSVf+reBgBIWV9vO6dtK4fYI=;
        b=cUmfrb3nRvaRxOO7vYL2kyuceAP4S2Lb6WvrYCOPs9nqxPdHdFzmYnsShUdQyjh6ic
         Hu0Pg+okTXYE+CKl3uwDoRHEcbZ8SK3VCPTTJE97fc5AuR/MEo22EfW6DINwVaLx2UBv
         ruK81gxj6Vafguega2sA5w7GjXleqeF43MSh15H+cDgNa9APVzXlLNMJZcRdZErT0kmn
         bUxCdAV2j14kVEZ7uai6Wcgzqg4B2dZp3s15at7VE9akgMQ1C6dc/49RMj74bpzPLpNU
         O1Cn73+n8SAKWFkDKLfSh3Z6zN256I1hpLwliR6h0mC9HPWN+/GeT+WIfvtHzvdI9/ss
         mr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FA3bZWejjzUky+cRUDelSVf+reBgBIWV9vO6dtK4fYI=;
        b=fjJp1vK4S5HsMoXuVcmPdMcoPMjoAPa8OaphIEF4sg0vgASN7HGWjkX1gaqMDUhkSn
         WiYsAXTYiC9ZW3PlBLSbmhxRIsVo7Qx4iOiJhrlDFeVt35yUSIAq8rRYuS7GwgSaNKKF
         ClwGmDINDgEPVU2m24jnEpLP3Y7HEbPMV5E1DhqI3KsOM7tbXwSuWn1LauFT7mH+N32C
         fTAlZSTvLhQzDspu9vVlj27gWrXKPvGyVU4Re7qDq+5RDLC1mWGxsvPQvEgj3hefMSSh
         ZPYaxmpTJunccPm6kaJOi0r5AxYCU1VZ1TclSV7aQgQZrOidXcy9qc7Z51/GTPm/lTkk
         rM5Q==
X-Gm-Message-State: AOAM532GBgnmCR19CQMod6EmpMXSVL12PvXtFhgpZ3tIQ0CuQneB4EH1
        l+UzOZ/SLMayAfSafWTbF7lbTcLnRAcch8JBBRg=
X-Google-Smtp-Source: ABdhPJxsbutLKr/ZXRfWfXQaLIqzdBEpd5PYgphqaKw0pwcFr4UloC5AULzjz1FhGEUvzE1y+VGfBLPPKxCDu6XNb7Q=
X-Received: by 2002:a62:170a:0:b029:196:5765:4abc with SMTP id
 10-20020a62170a0000b029019657654abcmr1442601pfx.4.1606169394089; Mon, 23 Nov
 2020 14:09:54 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de> <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de> <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
 <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com>
 <16b7e74e6e221f43420da7836659d7df@dev.tdt.de> <CAJht_EPtPDOSYfwc=9trBMdzLw4BbTzJbGvaEgWoyiy2624Q+Q@mail.gmail.com>
 <20201123113622.115c474b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123113622.115c474b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 23 Nov 2020 14:09:43 -0800
Message-ID: <CAJht_EOA4+DSjnKYZX3udrXX9jGHRmFw3OQesUb3AncD2oowwA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 11:36 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > >  From this point of view it will be the best to handle the NETDEV_UP in
> > > the lapb event handler and establish the link analog to the
> > > NETDEV_CHANGE event if the carrier is UP.
> >
> > Thanks! This way we can make sure LAPB would automatically connect in
> > all situations.
> >
> > Since we'll have a netif_carrier_ok check in NETDEV_UP handing, it
> > might make the code look prettier to also have a netif_carrier_ok
> > check in NETDEV_GOING_DOWN handing (for symmetry). Just a suggestion.
> > You can do whatever looks good to you :)
>
> Xie other than this the patches look good to you?
>
> Martin should I expect a respin to follow Xie's suggestion
> or should I apply v4?

There should be a respin because we need to handle the NETDEV_UP
event. The lapbether driver (and possibly some HDLC WAN drivers)
doesn't generate carrier events so we need to do auto-connect in the
NETDEV_UP event.
