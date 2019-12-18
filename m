Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9490612458F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLRLS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:18:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726682AbfLRLS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:18:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqO8aWTsw8nNsw3ZaTy9XRd/OVsjdS8T1HV1zC3O9O4=;
        b=Wp12k+eBrQaPlWLGwPKom6ozOPNFMrRJepIUOIlZVOeYIZSRnI6lr397S0Sgbn1oZFO9Z4
        dfVrSXzsUDXcnR0IqX7zxmWzvv74MrBlVjKkVdFp0FA61wYDUhPaQzMhmJdZwtAL4UgdQX
        chrMxsb+XemDxXM+st6KbK+vHnzGNsE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-3dzoLsoxPw-fCsS5Axi9kw-1; Wed, 18 Dec 2019 06:18:37 -0500
X-MC-Unique: 3dzoLsoxPw-fCsS5Axi9kw-1
Received: by mail-lj1-f199.google.com with SMTP id s8so585169ljo.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:18:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bqO8aWTsw8nNsw3ZaTy9XRd/OVsjdS8T1HV1zC3O9O4=;
        b=EuuoD2IqQVQkWAp2MQO2mvDO7dmAp6QhG4IEr5A3htlglCRSC6BB9l8Md3VVe5zynn
         PS8gPGTXH1UGJlun1YrQiGHr8P1RR50xEDXP3Ybe9bjWNTKMzPMlLzn8xQyqpR1ySm34
         GV5pRn9R79ZwSPccV1fUoTyfaNjuOIDtdcuVdbkRomq4dAzMY/ZnlnKfDVWYTMKQRSsj
         Mby2lndBfBIsi5u+JxoRngrqRqHxn+Da6DDrYPkFM127n4wgtnamXvl34tTD8zt23bVi
         iPrYCl1XwAu5MPQ2lMtpAHf2gB9fAitx/fKHAhRcUx47TxMnHX2JmSekApHBjDd9dfEt
         LWQw==
X-Gm-Message-State: APjAAAVftQVuUSde4EYcMqdMb8mdtblpI0o2WtfL33m2G3sbo545qjKg
        MGBDPccNBsC5SypN5VI1y9Blq74m7GmZ9Ci2ND2fEvzYDkyQ2aFr0xb3Rfw0/WySI6ofJ/Qs4Hw
        3UyRQEy8KU/TgTmP7
X-Received: by 2002:a19:48c5:: with SMTP id v188mr1407679lfa.100.1576667915566;
        Wed, 18 Dec 2019 03:18:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyuMNgg3shacLSjzVFCXCbTAhoYRat0ZZ0f+/jop/Eo24vYT5bZO+m4spu6MI5tFLyUXkFjvQ==
X-Received: by 2002:a19:48c5:: with SMTP id v188mr1407665lfa.100.1576667915360;
        Wed, 18 Dec 2019 03:18:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h19sm944357ljk.44.2019.12.18.03.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:18:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 29E46180969; Wed, 18 Dec 2019 12:18:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 3/8] xdp: fix graze->grace type-o in cpumap comments
In-Reply-To: <20191218105400.2895-4-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-4-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:18:34 +0100
Message-ID: <87woat6fw5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Simple spelling fix.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Even though I kinda like the mental image of RCU going out to the
savanna for a mouthful of grass that the typo seems to imply:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

