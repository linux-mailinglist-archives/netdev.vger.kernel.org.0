Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2C35E9B2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 01:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348817AbhDMX2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 19:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhDMX2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 19:28:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EC5C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:27:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w3so28583503ejc.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aWRvWExhkOPB29pYry4pK90z7xH90mBOaaOqvblDByU=;
        b=P5wSQONzxsW6MT4NC+mHhxoXyV3+0cUgc6hUOCjkYUvkon0K98wVQ9h1eesuSXgsIT
         IZOlz7SgGmiOQZ0qTXPB481i7Gb+YmptJKscIZv7P4xG/d2O7Zte45mg9CbaCbEZ0yaD
         hNeyNU6rCkZYUv95dp7SzIeBWxY0wYBs+RqK4U9BGthq0tpCwt57T58IGwgWEYUAdbyn
         iquMKuyBR3WX1QsjUE0jVIKYovhKjNBQ2rtBfab1aymAfYnenH/28sJN3UeamkE7LAXB
         LisQurzMPtjDPTYcvzv+kX3j4ziGV36dDQuC9J5xw7YUcSF9aWNvhSB7DKqAK4tpV81o
         YS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aWRvWExhkOPB29pYry4pK90z7xH90mBOaaOqvblDByU=;
        b=rFc6yMsPhJzTg2J1Qp8sARo2EE78Fw0wbaERNXyXbHVank25TRxvHmwBp/so+sH18/
         xgf8fga6OF+pfun+HVPqTlbHzd9GXw+P+aAqxcceduxaVorFudCcNTlBj/dZ/1jCYRSP
         wblk2CmfFctrhQrrwKRQunKt/FZyN9jSz4q/zRkQ/mVHQjbzj9neEREnA2n7Vm/SanDS
         hAjSisEckhtYLoqVWbB36AswCIp3PObJnOlbK2HD4UJYNMzK0Lp+9zdB9Gz9g3LlfkU/
         V15B73wJcR+03u4OiVA+yoRbQfBUNhJpuwSziPO/TFY9PNLIecd7br1Skh8BXHug6ttI
         CE/Q==
X-Gm-Message-State: AOAM53307NNmU2tOcPAca5tBbW/pgDZKxX4FlNYaAxDINoMI4CVzjVWa
        wIGblsQ3buY84+Scn7MzNrh71oICDPJpaQ==
X-Google-Smtp-Source: ABdhPJzBsghXIiOmI2Et8Flg/kHgXbAzjyj3MwyzLEmQqa9E5lFvZtackDcEP+Xu0SDCaq5YTXuzKQ==
X-Received: by 2002:a17:906:35ca:: with SMTP id p10mr10667595ejb.199.1618356462702;
        Tue, 13 Apr 2021 16:27:42 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id f11sm4303474ejc.62.2021.04.13.16.27.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 16:27:42 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so9573592wmj.2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:27:42 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc8:: with SMTP id o8mr81580wmq.87.1618356461592;
 Tue, 13 Apr 2021 16:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <4FE5BFAB-1988-4CA9-9B97-CEF73396B4EC@purdue.edu> <CAJht_EN-7OPijuS4kjqL71tfQHcg_aa9c9SZSQBmSvcNP5fFow@mail.gmail.com>
In-Reply-To: <CAJht_EN-7OPijuS4kjqL71tfQHcg_aa9c9SZSQBmSvcNP5fFow@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 19:27:02 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdtdhJ+ZnGfmY3CxvPNGgPJdhV89bUfXVmkk4FszpUAVw@mail.gmail.com>
Message-ID: <CA+FuTSdtdhJ+ZnGfmY3CxvPNGgPJdhV89bUfXVmkk4FszpUAVw@mail.gmail.com>
Subject: Re: A data race between fanout_demux_rollover() and __fanout_unlink()
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "eyal.birger@gmail.com" <eyal.birger@gmail.com>,
        "yonatanlinik@gmail.com" <yonatanlinik@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 6:55 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Tue, Apr 13, 2021 at 1:51 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
> >
> > Hi,
> >
> > We found a data race in linux-5.12-rc3 between af_packet.c functions fa=
nout_demux_rollover() and __fanout_unlink() and we are able to reproduce it=
 under x86.
> >
> > When the two functions are running together, __fanout_unlink() will gra=
b a lock and modify some attribute of packet_fanout variable, but fanout_de=
mux_rollover() may or may not see this update depending on different interl=
eavings, as shown in below.
> >
> > Currently, we didn=E2=80=99t find any explicit errors due to this data =
race. But in fanout_demux_rollover(), we noticed that the data-racing varia=
ble is involved in the later operation, which might be a concern.
> >
> > ------------------------------------------
> > Execution interleaving
> >
> > Thread 1                                                        Thread =
2
> >
> > __fanout_unlink()                                               fanout_=
demux_rollover()
> > spin_lock(&f->lock);
> >                                                                        =
 po =3D pkt_sk(f->arr[idx]);
> >                                                                        =
 // po is a out-of-date value
> > f->arr[i] =3D f->arr[f->num_members - 1];
> > spin_unlock(&f->lock);
> >
> >
> >
> > Thanks,
> > Sishuai
>
> CC'ing more people.

__fanout_unlink removes a socket from the fanout group, but ensures
that the socket is not destroyed until after no datapath can refer to
it anymore, through a call to synchronize_net.
